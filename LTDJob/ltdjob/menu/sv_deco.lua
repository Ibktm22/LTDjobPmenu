ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
TriggerEvent('esx_society:registerSociety', 'ltd', 'LTD Sud', 'society_ltd', 'society_ltd', 'society_ltd', {type = 'public'})

RegisterServerEvent('ltdouvert')
AddEventHandler('ltdouvert', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'LTD Sud', '~b~~h~Annonce', 'Le LTD Sud est désormais ouvert, venez faire vos achats !', 'CHAR_ANTONIA', 8)
	end
end)

RegisterServerEvent('ltdrecru')
AddEventHandler('ltdrecru', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'LTD Sud', '~b~~h~Annonce', 'Le LTD Sud recrute des employés , venez vous présenter au magasin !', 'CHAR_ANTONIA', 8)
	end
end)

RegisterServerEvent('ltdfermer')
AddEventHandler('ltdfermer', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'LTD Sud', '~b~~h~Annonce', 'Le LTD Sud est désormais fermé, venez faire vos achats plus tard !', 'CHAR_ANTONIA', 8)
	end
end)


-------------------- Coffre
RegisterServerEvent('ltd:prendreitems')
AddEventHandler('ltd:prendreitems', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ltd', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then

			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, "~r~~h~Votre quantité est invalide !")
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, '~b~~h~Vous avez retirer votre objet !', count, inventoryItem.label)
			end
		else
			TriggerClientEvent('esx:showNotification', _source, "~r~~h~Votre quantité est invalide !")
		end
	end)
end)


RegisterNetEvent('ltd:stockitem')
AddEventHandler('ltd:stockitem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ltd', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', _source, "~b~~h~Vous avez déposé un objet au nombre de "..count.." se nommant "..inventoryItem.label.."")
		else
			TriggerClientEvent('esx:showNotification', _source, "~b~~h~Vous avez retirer votre objet !")
		end
	end)
end)


ESX.RegisterServerCallback('ltd:inventairejoueur', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

ESX.RegisterServerCallback('ltd:prendreitem', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ltd', function(inventory)
		cb(inventory.items)
	end)
end)

------------------------------ ACHATS ALIMENTS ---------------------------------------------

RegisterNetEvent('ibktm22:ltdpain')
AddEventHandler('ibktm22:ltdpain', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 1
    local xMoney = xPlayer.getMoney()

    if xMoney >= price then

    xPlayer.removeMoney(price)
    xPlayer.addInventoryItem('bread', 1)
         TriggerClientEvent('esx:showNotification', source, "Vous avez recu ~b~1x ".. ESX.GetItemLabel("bread") .." dans votre sac a dos !")
    else
         TriggerClientEvent('esx:showNotification', source, "Il vous ~r~manque~g~ $"..price-xMoney.."~w~ !")
    end
end)

RegisterNetEvent('ibktm22:ltdbonbons')
AddEventHandler('ibktm22:ltdbonbons', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 2
    local xMoney = xPlayer.getMoney()

    if xMoney >= price then

    xPlayer.removeMoney(price)
    xPlayer.addInventoryItem('bonbons', 1)
         TriggerClientEvent('esx:showNotification', source, "Vous avez recu ~b~1x ".. ESX.GetItemLabel("bonbons") .." dans votre sac a dos !")
    else
         TriggerClientEvent('esx:showNotification', source, "Il vous ~r~manque~g~ $"..price-xMoney.."~w~ !")
    end
end)

RegisterNetEvent('ibktm22:ltdchips')
AddEventHandler('ibktm22:ltdchips', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 2
    local xMoney = xPlayer.getMoney()

    if xMoney >= price then

    xPlayer.removeMoney(price)
    xPlayer.addInventoryItem('chips', 1)
         TriggerClientEvent('esx:showNotification', source, "Vous avez recu ~b~1x ".. ESX.GetItemLabel("chips") .." dans votre sac a dos !")
    else
         TriggerClientEvent('esx:showNotification', source, "Il vous ~r~manque~g~ $"..price-xMoney.."~w~ !")
    end
end)

RegisterNetEvent('ibktm22:ltdcookie')
AddEventHandler('ibktm22:ltdcookie', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 1
    local xMoney = xPlayer.getMoney()

    if xMoney >= price then

    xPlayer.removeMoney(price)
    xPlayer.addInventoryItem('cookie', 1)
         TriggerClientEvent('esx:showNotification', source, "Vous avez recu ~b~1x ".. ESX.GetItemLabel("cookie") .." dans votre sac a dos !")
    else
         TriggerClientEvent('esx:showNotification', source, "Il vous ~r~manque~g~ $"..price-xMoney.."~w~ !")
    end
end)

RegisterNetEvent('ibktm22:ltddonuts')
AddEventHandler('ibktm22:ltddonuts', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 3
    local xMoney = xPlayer.getMoney()

    if xMoney >= price then

    xPlayer.removeMoney(price)
    xPlayer.addInventoryItem('donuts', 1)
         TriggerClientEvent('esx:showNotification', source, "Vous avez recu ~b~1x ".. ESX.GetItemLabel("donuts") .." dans votre sac a dos !")
    else
         TriggerClientEvent('esx:showNotification', source, "Il vous ~r~manque~g~ $"..price-xMoney.."~w~ !")
    end
end)

RegisterNetEvent('ibktm22:ltdburger')
AddEventHandler('ibktm22:ltdburger', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 4
    local xMoney = xPlayer.getMoney()

    if xMoney >= price then

    xPlayer.removeMoney(price)
    xPlayer.addInventoryItem('hamburger', 1)
         TriggerClientEvent('esx:showNotification', source, "Vous avez recu ~b~1x ".. ESX.GetItemLabel("hamburger") .." dans votre sac a dos !")
    else
         TriggerClientEvent('esx:showNotification', source, "Il vous ~r~manque~g~ $"..price-xMoney.."~w~ !")
    end
end)

RegisterNetEvent('ibktm22:ltdmuffin')
AddEventHandler('ibktm22:ltdmuffin', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 2
    local xMoney = xPlayer.getMoney()

    if xMoney >= price then

    xPlayer.removeMoney(price)
    xPlayer.addInventoryItem('muffin', 1)
         TriggerClientEvent('esx:showNotification', source, "Vous avez recu ~b~1x ".. ESX.GetItemLabel("muffin") .." dans votre sac a dos !")
    else
         TriggerClientEvent('esx:showNotification', source, "Il vous ~r~manque~g~ $"..price-xMoney.."~w~ !")
    end
end)

RegisterNetEvent('ibktm22:ltdnutella')
AddEventHandler('ibktm22:ltdnutella', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 5
    local xMoney = xPlayer.getMoney()

    if xMoney >= price then

    xPlayer.removeMoney(price)
    xPlayer.addInventoryItem('nutellab', 1)
         TriggerClientEvent('esx:showNotification', source, "Vous avez recu ~b~1x ".. ESX.GetItemLabel("nutellab") .." dans votre sac a dos !")
    else
         TriggerClientEvent('esx:showNotification', source, "Il vous ~r~manque~g~ $"..price-xMoney.."~w~ !")
    end
end)

RegisterNetEvent('ibktm22:ltdbiere')
AddEventHandler('ibktm22:ltdbiere', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 4
    local xMoney = xPlayer.getMoney()

    if xMoney >= price then

    xPlayer.removeMoney(price)
    xPlayer.addInventoryItem('beer', 1)
         TriggerClientEvent('esx:showNotification', source, "Vous avez recu ~b~1x ".. ESX.GetItemLabel("beer") .." dans votre sac a dos !")
    else
         TriggerClientEvent('esx:showNotification', source, "Il vous ~r~manque~g~ $"..price-xMoney.."~w~ !")
    end
end)

RegisterNetEvent('ibktm22:ltdtea')
AddEventHandler('ibktm22:ltdtea', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 2
    local xMoney = xPlayer.getMoney()

    if xMoney >= price then

    xPlayer.removeMoney(price)
    xPlayer.addInventoryItem('icetea', 1)
         TriggerClientEvent('esx:showNotification', source, "Vous avez recu ~b~1x ".. ESX.GetItemLabel("icetea") .." dans votre sac a dos !")
    else
         TriggerClientEvent('esx:showNotification', source, "Il vous ~r~manque~g~ $"..price-xMoney.."~w~ !")
    end
end)

RegisterNetEvent('ibktm22:ltdjus')
AddEventHandler('ibktm22:ltdjus', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 1
    local xMoney = xPlayer.getMoney()

    if xMoney >= price then

    xPlayer.removeMoney(price)
    xPlayer.addInventoryItem('jusfruit', 1)
         TriggerClientEvent('esx:showNotification', source, "Vous avez recu ~b~1x ".. ESX.GetItemLabel("jusfruit") .." dans votre sac a dos !")
    else
         TriggerClientEvent('esx:showNotification', source, "Il vous ~r~manque~g~ $"..price-xMoney.."~w~ !")
    end
end)

RegisterNetEvent('ibktm22:ltdmartini')
AddEventHandler('ibktm22:ltdmartini', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 4
    local xMoney = xPlayer.getMoney()

    if xMoney >= price then

    xPlayer.removeMoney(price)
    xPlayer.addInventoryItem('martini', 1)
         TriggerClientEvent('esx:showNotification', source, "Vous avez recu ~b~1x ".. ESX.GetItemLabel("martini") .." dans votre sac a dos !")
    else
         TriggerClientEvent('esx:showNotification', source, "Il vous ~r~manque~g~ $"..price-xMoney.."~w~ !")
    end
end)

RegisterNetEvent('ibktm22:ltdmojito')
AddEventHandler('ibktm22:ltdmojito', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 5
    local xMoney = xPlayer.getMoney()

    if xMoney >= price then

    xPlayer.removeMoney(price)
    xPlayer.addInventoryItem('mojito', 1)
         TriggerClientEvent('esx:showNotification', source, "Vous avez recu ~b~1x ".. ESX.GetItemLabel("mojito") .." dans votre sac a dos !")
    else
         TriggerClientEvent('esx:showNotification', source, "Il vous ~r~manque~g~ $"..price-xMoney.."~w~ !")
    end
end)

RegisterNetEvent('ibktm22:ltdoasis')
AddEventHandler('ibktm22:ltdoasis', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 2
    local xMoney = xPlayer.getMoney()

    if xMoney >= price then

    xPlayer.removeMoney(price)
    xPlayer.addInventoryItem('oasis', 1)
         TriggerClientEvent('esx:showNotification', source, "Vous avez recu ~b~1x ".. ESX.GetItemLabel("oasis") .." dans votre sac a dos !")
    else
         TriggerClientEvent('esx:showNotification', source, "Il vous ~r~manque~g~ $"..price-xMoney.."~w~ !")
    end
end)

RegisterNetEvent('ibktm22:ltdorangina')
AddEventHandler('ibktm22:ltdorangina', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 2
    local xMoney = xPlayer.getMoney()

    if xMoney >= price then

    xPlayer.removeMoney(price)
    xPlayer.addInventoryItem('orangina', 1)
         TriggerClientEvent('esx:showNotification', source, "Vous avez recu ~b~1x ".. ESX.GetItemLabel("orangina") .." dans votre sac a dos !")
    else
         TriggerClientEvent('esx:showNotification', source, "Il vous ~r~manque~g~ $"..price-xMoney.."~w~ !")
    end
end)

RegisterNetEvent('ibktm22:ltdpepsi')
AddEventHandler('ibktm22:ltdpepsi', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 2
    local xMoney = xPlayer.getMoney()

    if xMoney >= price then

    xPlayer.removeMoney(price)
    xPlayer.addInventoryItem('pepsi', 1)
         TriggerClientEvent('esx:showNotification', source, "Vous avez recu ~b~1x ".. ESX.GetItemLabel("pepsi") .." dans votre sac a dos !")
    else
         TriggerClientEvent('esx:showNotification', source, "Il vous ~r~manque~g~ $"..price-xMoney.."~w~ !")
    end
end)

