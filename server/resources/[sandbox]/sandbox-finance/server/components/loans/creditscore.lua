function GetCharacterCreditScore(stateId)
    local p = promise.new()
    Database.Game:findOne({
        collection = 'loans_credit_scores',
        query = {
            SID = stateId,
        }
    }, function(success, results)
        if success and #results > 0 then
            p:resolve(results[1].Score)
        else
            p:resolve(_creditScoreConfig.default)
        end
    end)

    local res = Citizen.Await(p)
    return res
end

function SetCharacterCreditScore(stateId, score)
    local p = promise.new()

    if score > _creditScoreConfig.max then
        score = _creditScoreConfig.max
    end

    if score < _creditScoreConfig.min then
        score = _creditScoreConfig.min
    end

    Database.Game:findOneAndUpdate({
        collection = 'loans_credit_scores',
        query = {
            SID = stateId,
        },
        update = {
            ['$set'] = {
                Score = score,
            },
        },
        options = {
            returnDocument = 'after',
            upsert = true,
        }
    }, function(success, results)
        if success and results then
            p:resolve(results.Score)
        else
            p:resolve(false)
        end
    end)

    local res = Citizen.Await(p)
    return res
end

function IncreaseCharacterCreditScore(stateId, amount)
    local creditScore = GetCharacterCreditScore(stateId)
    return SetCharacterCreditScore(stateId, math.min(_creditScoreConfig.max, creditScore + amount))
end

function DecreaseCharacterCreditScore(stateId, amount)
    local creditScore = GetCharacterCreditScore(stateId)
    return SetCharacterCreditScore(stateId, math.max(_creditScoreConfig.min, creditScore - amount))
end