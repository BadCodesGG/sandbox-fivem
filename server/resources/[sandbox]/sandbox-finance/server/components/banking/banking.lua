function GenerateBankAccountNumber()
    local bankAccount = math.random(100001, 999999)
    while IsAccountNumberInUse(bankAccount) do
        bankAccount = math.random(100001, 999999)
    end

    return bankAccount
end

local genTCache = {}
function IsAccountNumberInUse(account)
    if genTCache[account] then
        return true
    end

    local res = MySQL.single.await('SELECT 1 FROM bank_accounts WHERE account = ?', {
        account
    })

    if res then
        genTCache[account] = true
        return true
    end

    return false
end

function CreateBankAccount(accountType, owner, balance, name, account, jobAccess)
    if not accountType or not owner then return false end
    local p = promise.new()

    if not account then
        account = GenerateBankAccountNumber()
    end

    if not name then
        name = account
    end

    if not balance or balance < 0 then
        balance = 0
    end

    local res = MySQL.insert.await('INSERT INTO bank_accounts (account, type, owner, balance, name) VALUES(?, ?, ?, ?, ?)', {
        account,
        accountType,
        owner,
        balance,
        name,
    })

    if res and jobAccess and #jobAccess > 0 then
        local qry = 'INSERT INTO bank_accounts_permissions (account, type, job, workplace, jobPermissions) VALUES '

        local params = {}

        for k, v in ipairs(jobAccess) do
            table.insert(params, account)
            table.insert(params, 0)
            table.insert(params, v.Job)
            table.insert(params, v.Workplace or '')
            table.insert(params, json.encode(v.Permissions))

            qry = qry .. '(?, ?, ?, ?, ?)'

            if k < #jobAccess then
                qry = qry .. ','
            end
        end

        qry = qry .. ';'

        MySQL.insert.await(qry, params)
    end

    if res then
        return account
    end
    return false
end

function GetDefaultBankAccountPermissions()
    return {
        MANAGE = 'BANK_ACCOUNT_MANAGE', -- Can Manage The Account (IDK What this does yet)
        WITHDRAW = 'BANK_ACCOUNT_WITHDRAW', -- Can Withdraw/Tranfer money
        DEPOSIT = 'BANK_ACCOUNT_DEPOSIT', -- Can Deposit
        TRANSACTIONS = 'BANK_ACCOUNT_TRANSACTIONS', -- Can View Transaction History
        BILL = 'BANK_ACCOUNT_BILL', -- Can Bill Using This Account
        BALANCE = 'BANK_ACCOUNT_BALANCE',
    }
end

function HasBankAccountPermission(source, accountData, permission, stateId)
    if accountData.Type == 'personal' then
        if accountData.Owner == tostring(stateId) then
            return true
        end
    elseif accountData.Type == 'personal_savings' then
        if accountData.Owner == tostring(stateId) then
            return true
        elseif permission ~= "MANAGE" then
            local pData = MySQL.single.await("SELECT account, jointOwner FROM bank_accounts_permissions WHERE account = ? AND type = ? AND jointOwner = ?", {
                accountData.Account,
                1,
                stateId
            })
            if pData and pData.account == accountData.Account then
                return true
            end
        end
    elseif accountData.Type == 'organization' then
        local pData = MySQL.query.await("SELECT account, job, workplace, jobPermissions FROM bank_accounts_permissions WHERE account = ? AND type = ?", {
            accountData.Account,
            0
        })

        for k, v in ipairs(pData) do
            local jp = json.decode(v.jobPermissions or "{}")
            local fuckingWorkplace = false
            if v.workplace and v.workplace ~= "" and #v.workplace > 0 then
                fuckingWorkplace = v.workplace
            end

            if Jobs.Permissions:HasJob(source, v.job, fuckingWorkplace, false, false, false, jp[permission]) then
                return true
            end
        end
    end
    return false
end