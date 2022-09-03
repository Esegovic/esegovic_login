_Func = {}

_Func.SendMessage = function (msg)
    SendNUIMessage({ 
        event = 'notify',
        msg = msg
    })
end

_Func.CheckLenght = function (str, lenght)
    if string.len(str) >= lenght then
        return true
    end
    return false
end

AddEventHandler('playerSpawned', function()
    SetNuiFocus(true, true)
    SendNUIMessage({ 
        event = 'login'
    })
end)

RegisterNUICallback("close", function()
    SetNuiFocus(false, false)
    SendNUIMessage({ 
        type = 'close'
    })
end)

RegisterNetEvent("esegovic.login.loggedin")
AddEventHandler('esegovic.login.loggedin', function()
    SetNuiFocus(false, false)
    SendNUIMessage({ 
        event = 'hide'
    })
end)

RegisterNUICallback("NUI.Register", function(data)
    local username, password, secretKey = data.username, data.password, data.secretKey
    local CHECK_USERNAME, CHECK_PASSWORD = _Func.CheckLenght(username, Config.Username_Minimum_Characters), _Func.CheckLenght(password, Config.Password_Minimum_Characters)
    if CHECK_USERNAME then
        if CHECK_PASSWORD then
            TriggerServerEvent("esegovic.register", username, password, secretKey)
        else
            _Func.SendMessage(Translate["pass_len"]..Config.Password_Minimum_Characters.." "..Translate["characters"])
        end
    else
        _Func.SendMessage(Translate["user_len"]..Config.Username_Minimum_Characters.." "..Translate["characters"])
    end
end)

RegisterNUICallback("NUI.Login", function(data)
    local username, password = data.username, data.password
    TriggerServerEvent("esegovic.login", username, password)
end)

RegisterNUICallback("NUI.DeleteAccount", function()
    TriggerServerEvent("esegovic.login.deleteAcc")
end)

RegisterNUICallback("NUI.ResetPassword", function(data)
    local key = data.key;
    TriggerServerEvent("esegovic.login.resetPassword", key)
end)

RegisterNetEvent("esegovic.login.noti")
AddEventHandler('esegovic.login.noti', function(msg)
    _Func.SendMessage(msg)
end)