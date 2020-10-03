ESX = nil

local bluePlayerReady = false
local redPlayerReady = false
local fight = {}

TriggerEvent('esx:getSharedObject',
    function(obj)
        ESX = obj
    end
)

RegisterServerEvent('xex_streetfight:join')
AddEventHandler('xex_streetfight:join', function(betAmount, side)

        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)

		if side == 0 then
			bluePlayerReady = true
		else
			redPlayerReady = true
		end

        local fighter = {
            id = source,
            amount = betAmount
        }
        table.insert(fight, fighter)

        balance = xPlayer.getAccount('money').money
        if (balance > betAmount) then
            xPlayer.removeAccountMoney('money', betAmount)
            TriggerClientEvent('esx:showNotification', source, 'Te has unido correctamente')

            if side == 0 then
                TriggerClientEvent('xex_streetfight:playerJoined', -1, 1, source)
            else
                TriggerClientEvent('xex_streetfight:playerJoined', -1, 2, source)
            end

            if redPlayerReady and bluePlayerReady then 
                TriggerClientEvent('xex_streetfight:startFight', -1, fight)
            end

        else
            TriggerClientEvent('esx:showNotification', source, 'No tienes dinero')
        end
end)

local count = 240
local actualCount = 0
function countdown(copyFight)
    for i = count, 0, -1 do
        actualCount = i
        Citizen.Wait(1000)
    end

    if copyFight == fight then
        TriggerClientEvent('xex_streetfight:fightFinished', -1, -2)
        fight = {}
        bluePlayerReady = false
        redPlayerReady = false
    end
end

RegisterServerEvent('xex_streetfight:finishFight')
AddEventHandler('xex_streetfight:finishFight', function(looser)
       -- print("el perdedor es" .. looser)
       TriggerClientEvent('xex_streetfight:fightFinished', -1, looser)
       fight = {}
       bluePlayerReady = false
       redPlayerReady = false
end)

RegisterServerEvent('xex_streetfight:leaveFight')
AddEventHandler('xex_streetfight:leaveFight', function(id)
       if bluePlayerReady or redPlayerReady then
            bluePlayerReady = false
            redPlayerReady = false
            fight = {}
            TriggerClientEvent('xex_streetfight:playerLeaveFight', -1, id)
       end
end)

RegisterServerEvent('xex_streetfight:pay')
AddEventHandler('xex_streetfight:pay', function(amount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.addAccountMoney('money', amount * 2)
end)

RegisterServerEvent('xex_streetfight:raiseBet')
AddEventHandler('xex_streetfight:raiseBet', function(looser)
       TriggerClientEvent('xex_streetfight:raiseActualBet', -1)
end)

RegisterServerEvent('xex_streetfight:showWinner')
AddEventHandler('xex_streetfight:showWinner', function(id)
       TriggerClientEvent('xex_streetfight:winnerText', -1, id)
end)