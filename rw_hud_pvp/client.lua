local ESX

local lastValues = {}
local PlayerData = {}
local isPauseMenu = false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()

    while true do

        Wait(700)

		ESX.PlayerData = ESX.GetPlayerData()

        TriggerServerEvent('rw_hud:getServerInfo')	


		SendNUIMessage({action = 'update', type = 'serverId', data = GetPlayerServerId(PlayerId())})


--------------------GLOBAL------------------------------------------------------------------------------------------------------
		local ped = PlayerPedId()
		local playerId = PlayerId()

------------------------HEALTH-------------------------------------------------------------------------------------------------				
		SetPlayerHealthRechargeMultiplier(playerId,0.0)
		local maxHealth = GetEntityMaxHealth(ped)-100
		local health = GetEntityHealth(ped)-100
		if health < 0 then health = 0 end
		if lastValues.health ~= health then
			lastValues.health = health
			SendNUIMessage({action = 'updateBar', type = 'health', current = health, max = maxHealth})
			SendNUIMessage({action = 'update', type = 'healthbar-value', data = health})
		end
---------------------ARMOR-----------------------------------------------------------------------------------------------------
        SetPlayerHealthRechargeMultiplier(playerId,0.0)
        local maxArmor = GetPlayerMaxArmour(playerId)
        local armor = GetPedArmour(ped)
        if armor < 0 then armor = 0 end
        if lastValues.armor ~= armor then
	      lastValues.armor = armor
	      SendNUIMessage({action = 'updateBar', type = 'vest', current = armor, max = maxArmor})
	      SendNUIMessage({action = 'update', type = 'vestbar-value', data = armor})
        end

---------------------STAMINA---------------------------------------------------------------------------------------------------				
		local stamina = 100 - GetPlayerSprintStaminaRemaining(playerId)
		if lastValues.stamina ~= stamina then
			lastValues.stamina = stamina
			SendNUIMessage({action = 'updateBar', type = 'stamina', current = stamina, max = 100})
		end
----------------------PAUSE-MENU-------------------------------------
		if IsPauseMenuActive() then 
			if not isPauseMenu then
				isPauseMenu = not isPauseMenu
				SendNUIMessage({action = 'hide'})
			end
		else
			if isPauseMenu then
				isPauseMenu = not isPauseMenu
				SendNUIMessage({action = 'show'})
			end
		end
----------------------------------------------
    end	
end)

-- Overall Info
RegisterNetEvent('rw_hud:setInfo')
AddEventHandler('rw_hud:setInfo', function(info)

	SendNUIMessage({action = 'update', type = 'society-name', data = ESX.PlayerData.job.label..': ' .. ESX.PlayerData.job.grade_label or 'ERORR_1'})
	SendNUIMessage({action = 'update', type = 'money', data = info['money'] or 'ERORR_1'})
	SendNUIMessage({action = 'update', type = 'bank-account', data = info['bank'] or 'ERORR_1'})
	SendNUIMessage({action = 'update', type = 'black_money', data = info['blackm'] or 'ERORR_1'})
    SendNUIMessage({action = 'update', type = 'tmda-time-text', data = info['time'] or 'ERORR_1'})
    SendNUIMessage({action = 'update', type = 'tmda-date-text', data = info['date'] or 'ERORR_1' })
    SendNUIMessage({action = 'update', type = 'donate-coins', data = info['dnates'] or 'ERORR_1'})

	if ESX.PlayerData.job ~= nil then
		if ESX.PlayerData.job.grade_name == 'boss' then
				SendNUIMessage({action = 'showElement', type = 'society'})
			ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
				SendNUIMessage({action = 'update', type = 'society-money', data = money})
			end, ESX.PlayerData.job.name)
		else
			SendNUIMessage({action = 'hideElement', type = 'society'})
		end
	end

end)

---- VEHICLE
CreateThread(function()
	while true do
		Wait(150)
		------- vehicle ------
		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped, false) then
			SendNUIMessage({action = 'showElement', type = 'in-vehicle'})

			local vehicle = GetVehiclePedIsIn(ped)

			local data = {
				health = GetVehicleEngineHealth(vehicle),
				speed = GetEntitySpeed(vehicle)*2.2,
				maxSpeed = GetVehicleMaxSpeed(vehicle)*2.2,
				fuel = GetVehicleFuelLevel(vehicle),
			}
			SendNUIMessage({action = 'speedometer', data = data})
		else
			SendNUIMessage({action = 'hideElement', type = 'in-vehicle'})
		
		end
	end
end)

