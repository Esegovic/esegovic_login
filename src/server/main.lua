getIdentifier = function (playerId)
	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'license:') then
			local identifier = string.gsub(v, 'license:', '')
			return identifier
		end
	end
end

RegisterNetEvent('esegovic.login')
AddEventHandler('esegovic.login', function(user, pass)
	local playerId = source
	local license = getIdentifier(playerId)
	if license then
        MySQL.Async.fetchScalar('SELECT 1 FROM esegovic_login WHERE identifier = @identifier', {
            ['@identifier'] = license
        }, function(result)
            if result then
				MySQL.Async.fetchAll('SELECT username, password FROM esegovic_login WHERE identifier = @identifier', {
					['@identifier'] = license
				}, function(result)
					if #result > 0 then
						DB_USERNAME = result[1].username;
						DB_PASSWORD = result[1].password;
						if DB_USERNAME == user then
							if DB_PASSWORD == pass then
								TriggerClientEvent('esegovic.login.loggedin', playerId)
							else
								TriggerClientEvent('esegovic.login.noti', playerId,  Translate["wrong_password"])
							end
						else
							TriggerClientEvent('esegovic.login.noti', playerId,  Translate["wrong_username"])
						end
					end
				end)
			else
				TriggerClientEvent('esegovic.noti', playerId,  Translate["no_account"])
            end
        end)
    end
end)

RegisterNetEvent('esegovic.register')
AddEventHandler('esegovic.register', function(user, pass, keyed)
	local playerId = source
	local license = getIdentifier(playerId)
	if license then
        MySQL.Async.fetchScalar('SELECT 1 FROM esegovic_login WHERE identifier = @identifier', {
            ['@identifier'] = license
        }, function(result)
            if result then
				TriggerClientEvent('esegovic.login.noti', playerId,  Translate["have_account"])
			else
				MySQL.Async.execute('INSERT INTO esegovic_login (identifier, username, password, secretKey) VALUES (@identifier, @username, @password, @secretKey)', {
					['@identifier'] = license,
                    ['@username'] = user,
                    ['@password'] = pass,
					['@secretKey'] = keyed,
                }, function(inserted)
					TriggerClientEvent('esegovic.login.noti', playerId,  Translate["account_created"])
                end)	
            end
        end)
    end
end)


RegisterNetEvent('esegovic.login.deleteAcc')
AddEventHandler('esegovic.login.deleteAcc', function()
	local playerId = source
	local license = getIdentifier(playerId)
	MySQL.Async.execute("DELETE FROM esegovic_login WHERE identifier = @identifier", {
		["@identifier"] = license
	})
	TriggerClientEvent('esegovic.login.noti', playerId,  Translate["account_deleted"])
end)

RegisterNetEvent('esegovic.login.resetPassword')
AddEventHandler('esegovic.login.resetPassword', function(key)
	print(key)
	local playerId = source
	local license = getIdentifier(playerId)
	MySQL.Async.fetchScalar('SELECT 1 FROM esegovic_login WHERE identifier = @identifier', {
		['@identifier'] = license
	}, function(result)
		if result then
			MySQL.Async.fetchAll('SELECT secretKey, password FROM esegovic_login WHERE identifier = @identifier', {
				['@identifier'] = license
			}, function(result)
				if #result > 0 then
					DB_KEY = result[1].secretKey;
					DB_PASSWORD = result[1].password;
					if DB_KEY == key then
						TriggerClientEvent('esegovic.login.noti', playerId,  Translate["password_reset"]..DB_PASSWORD)
					else
						TriggerClientEvent('esegovic.login.noti', playerId,  Translate["wrong_key"])
					end
				end
			end)
		else
			TriggerClientEvent('esegovic.login.noti', playerId, Translate["no_account"])
		end
	end)
end)