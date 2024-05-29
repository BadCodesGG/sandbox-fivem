RegisterNetEvent("Phone:Client:Documents:ReceivedSignature", function(id, data)
	SendNUIMessage({
		type = "DOCUMENTS_RECEIVED_SIGNATURE",
		data = {
			id = id,
			signature = data,
		},
	})

	Phone.Notification:Add(
		"Document Signed",
		string.format("%s Signed Your Document", data.signed_name),
		data.signed,
		6000,
		"documents",
		{
			view = "view/" .. id,
		},
		nil
	)
end)

RegisterNetEvent("Phone:Client:Documents:SigReqReceived", function(id, data)
	SendNUIMessage({
		type = "DOCUMENTS_RECEIVED_SIGNATURE",
		data = {
			id = id,
			signature = data,
		},
	})

	if data.signed ~= nil then
		Phone.Notification:Add(
			"Document Signed",
			string.format("%s Signed Your Document", data.signed_name),
			data.signed,
			6000,
			"documents",
			{
				view = "view/" .. id,
			},
			nil
		)
	end
end)

RegisterNetEvent("Phone:Client:Documents:Deleted", function(id)
	SendNUIMessage({
		type = "DOCUMENTS_DOCUMENT_DELETED",
		data = {
			id = id,
		},
	})
end)

RegisterNUICallback("EditDocument", function(data, cb)
	Callbacks:ServerCallback("Phone:Documents:Edit", data, cb)
end)

RegisterNUICallback("DeleteDocument", function(data, cb)
	Callbacks:ServerCallback("Phone:Documents:Delete", data.id, cb)
end)

RegisterNUICallback("CreateDocument", function(data, cb)
	Callbacks:ServerCallback("Phone:Documents:Create", data, cb)
end)

RegisterNUICallback("ShareDocument", function(data, cb)
	Callbacks:ServerCallback("Phone:Documents:Share", data, cb)
end)

RegisterNUICallback("SignDocument", function(data, cb)
	Callbacks:ServerCallback("Phone:Documents:Sign", data, cb)
end)

RegisterNUICallback("Documents:GetSignatures", function(data, cb)
	Callbacks:ServerCallback("Phone:Documents:GetSignatures", data, cb)
end)
