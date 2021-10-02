
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Citizen.Wait(0)
    end  
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
    Citizen.Wait(5000)
end)



-----------------------------------------------------------------------------------------------------------------
---------------------------------------------- SCRIPT -----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

function OpenBillingMenu()
    ESX.UI.Menu.Open(
        'dialog', GetCurrentResourceName(), 'facture',
        {
            title = 'Donner une facture'
        },
        function(data, menu)

            local amount = tonumber(data.value)

            if amount == nil or amount <= 0 then
                ESX.ShowNotification('Montant invalide')
            else
                menu.close()

                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                if closestPlayer == -1 or closestDistance > 3.0 then
                    ESX.ShowNotification('Pas de joueurs proche')
                else
                    local playerPed        = GetPlayerPed(-1)

                    Citizen.CreateThread(function()
                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
                        Citizen.Wait(5000)
                        ClearPedTasks(playerPed)
                        TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_ltd', 'LTD Sud', amount)
                        ESX.ShowNotification("~r~Vous avez bien envoyer la facture")
                    end)
                end
            end
        end,
        function(data, menu)
            menu.close()
    end)
end

function habittaff()
    local model = GetEntityModel(GetPlayerPed(-1))
    TriggerEvent('skinchanger:getSkin', function(skin)
        if model == GetHashKey("mp_m_freemode_01") then
            clothesSkin = {
             ['tshirt_1'] = 129,  ['tshirt_2'] = 0,
             ['torso_1'] = 42,   ['torso_2'] = 0,
             ['arms'] = 11,
             ['pants_1'] = 1,   ['pants_2'] = 0,
             ['shoes_1'] = 7,   ['shoes_2'] = 0,
             ['helmet_1'] = -1,  ['helmet_2'] = 0,
             ['chain_1'] = 0,    ['chain_2'] = 0,
             ['ears_1'] = -1,     ['ears_2'] = 0
           }
       else
           clothesSkin = {
               ['tshirt_1'] = 21,  ['tshirt_2'] = 1,
               ['torso_1'] = 10,   ['torso_2'] = 0, 
               ['arms'] = 1,
               ['pants_1'] = 10,   ['pants_2'] = 0,
               ['shoes_1'] = 10,   ['shoes_2'] = 0,  
               ['helmet_1'] = -1,  ['helmet_2'] = 0,
               ['chain_1'] = 0,    ['chain_2'] = 0,
               ['ears_1'] = -1,     ['ears_2'] = 0
             }
        end
        TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
   end)
end
       
function tenuecivil()
  ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
      TriggerEvent('skinchanger:loadSkin', skin)
   end)
end

-----------------------------------------------------------------------------------------------------------------
---------------------------------------------- Menu F6 ----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

local menuf6 = {
    Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {8, 0, 255}, Title = "LTD SUD" },
    Data = { currentMenu = "~r~Voici votre menu :", "Test"},
    Events = {
        onSelected = function(self, _, btn, PMenu, menuData, result)
         
            if btn.name == "Facturation" then   
                OpenBillingMenu()
            elseif btn.name == "Achat des produits" then
                OpenMenu('~r~Achat des produits :')
            elseif btn.name == "Annonce" then
                OpenMenu("~r~Annonce")
            elseif btn.name == "Ouvert" then
                TriggerServerEvent("ltdouvert")
            elseif btn.name == "Recrutement" then
                TriggerServerEvent("ltdrecru")
            elseif btn.name == "Fermé" then
                TriggerServerEvent('ltdfermer')
            elseif btn.name == "Achat des aliments" then
                SetNewWaypoint(-1190.74, -742.98)
                CloseMenu('')
            elseif btn.name == "Achat des boissons" then
                SetNewWaypoint(282.89, 28.18)
            elseif btn.name == "~r~Fermer le Menu" then
                CloseMenu()
            end 
    end,
},
    Menu = {
        ["~r~Voici votre menu :"] = {
            b = {
                {name = "Facturation", ask = '~b~→→→', askX = true},
                {name = "Annonce", ask = '~b~→→→', askX = true},
                {name = "Achat des produits", ask = '~b~→→→', askX = true},
                {name = "~b~-----------------------------------------------------------------------", ask = '', askX = true},
                {name = "~r~Fermer le Menu", ask = '❌', askX = true},
            }
        },
        ["~r~Achat des produits :"] = {
            b = {
                {name = "Achat des aliments", ask = '~b~→→→', askX = true},
                {name = "Achat des boissons", ask = '~b~→→→', askX = true},
                {name = "~b~-----------------------------------------------------------------------", ask = '', askX = true},
                {name = "~r~Fermer le Menu", ask = '❌', askX = true},
            }
        },
        ["~r~Annonce"] = {
            b = {
                {name = "Ouvert", ask = '~b~→→→', askX = true},
                {name = "Recrutement", ask = '~b~→→→', askX = true},
                {name = "Fermé", ask = '~b~→→→', askX = true},
                {name = "~b~-----------------------------------------------------------------------", ask = '', askX = true},
                {name = "~r~Fermer le Menu", ask = '❌', askX = true},
            }
        }
    }
} 

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		if IsControlJustPressed(0,167) and PlayerData.job and PlayerData.job.name == 'ltd' then
			CreateMenu(menuf6)
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------
---------------------------------------------- Menu BOSS --------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

local boss = { 
    {x=-44.09, y=-1749.40, z=29.4}
}
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k in pairs(boss) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, boss[k].x, boss[k].y, boss[k].z)
            if dist <= 1.5 and PlayerData.job and PlayerData.job.name == 'ltd' and PlayerData.job.grade_name == 'boss'   then
                DrawMarker(29, -44.09, -1749.40, 29.4, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.9, 0.9, 0.9, 8, 0, 255, 255, 0, 1, 2, 0, nil, nil, 0)
                ESX.ShowHelpNotification("~h~Appuyez sur [~b~E~s~] pour accéder a l'ordinateur")
                if IsControlJustPressed(1,38) then 			
                    TriggerEvent('esx_society:openBossMenu', 'ltd', function(data, menu)
                        menu.close()
                    end, {wash = true})
         end end end end end)  

-----------------------------------------------------------------------------------------------------------------
---------------------------------------------- Coffre -----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

local coffre = {
    Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {8, 0, 255}, Title = "COFFRE" },
    Data = { currentMenu = "~r~Voici votre menu :", "Test"},
    Events = {
        onSelected = function(self, _, btn, PMenu, menuData, result)
         
            if btn.name == "" then   
                OpenMenu("")
            elseif btn.name == "Coffre" then
                OpenMenu("~r~Coffre :")
            elseif btn.name == "Prendre" then
                OpenGetStockspharmaMenu()
                CloseMenu()
            elseif btn.name == "Deposer" then
                OpenPutStockspharmaMenu()
                CloseMenu()
            elseif btn.name == "Kit de premier soin" then
                TriggerServerEvent('prendre:kit')
                CloseMenu()
            elseif btn.name == "Bandage" then
                TriggerServerEvent("prendre:bandage")
                CloseMenu()
            elseif btn.name == "Fermer le menu" then
                CloseMenu()
            end 
    end,
},
    Menu = {
        ["~r~Voici votre menu :"] = {
            b = {
                {name = "Coffre", ask = '~b~→→→', askX = true},
                {name = "~b~-----------------------------------------------------------------------", ask = '', askX = true},
                {name = "~r~Fermer le Menu", ask = '❌', askX = true},
            }
        },
        ["~r~Coffre :"] = {
            b = {
                {name = "Prendre", ask = '~b~→→→', askX = true},
                {name = "Deposer", ask = '~b~→→→', askX = true},
                {name = "~b~-----------------------------------------------------------------------", ask = '', askX = true},
                {name = "~r~Fermer le Menu", ask = '❌', askX = true},
            }
        },
        [""] = {
            b = {
                {name = "Kit de premier soin", ask = '>>', askX = true},
                {name = "Bandage", ask = '>>', askX = true},
            }
        }
    }
} 

local stock = { 
    {x=-40.69, y=-1751.20, z=29.42} --Position coffre
}
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k in pairs(stock) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, stock[k].x, stock[k].y, stock[k].z)
            if dist <= 1.5 and PlayerData.job and PlayerData.job.name == 'ltd'  then
            DrawMarker(22, -40.69, -1751.20, 29.42, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.6, 8, 0, 255, 255, 0, 1, 2, 0, nil, nil, 0)
                ESX.ShowHelpNotification("~h~Appuyez sur [~b~E~s~] pour accéder au stock")
                if IsControlJustPressed(1,38) then 			
                    CreateMenu(coffre)
         end end end end end)

         ------ Coffre

function OpenGetStockspharmaMenu()
	ESX.TriggerServerCallback('ltd:prendreitem', function(items)
		local elements = {}

		for i=1, #items, 1 do
            table.insert(elements, {
                label = 'x' .. items[i].count .. ' ' .. items[i].label,
                value = items[i].name
            })
        end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            css      = 'pizzamenu',
			title    = 'stockage',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
                css      = 'pizzamenu',
				title = 'quantité'
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if not count then
					ESX.ShowNotification('quantité invalide')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('ltd:prendreitems', itemName, count)

					Citizen.Wait(300)
					OpenGetStocksLSPDMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutStockspharmaMenu()
	ESX.TriggerServerCallback('ltd:inventairejoueur', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            css      = 'pizzamenu',
			title    = 'inventaire',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
                css      = 'pizzamenu',
				title = 'quantité'
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if not count then
					ESX.ShowNotification('~r~La quantité est invalide')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('ltd:stockitem', itemName, count)

					Citizen.Wait(300)
					OpenPutStocksLSPDMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

-----------------------------------------------------------------------------------------------------------------
---------------------------------------------- GARAGE -----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    local hash = GetHashKey("csb_customer")
    while not HasModelLoaded(hash) do
    RequestModel(hash)
    Wait(20)
    end
    ped = CreatePed("PED_TYPE_CIVFEMALE", "csb_customer", -41.24, -1747.96, 28.5, 322.4, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    end)

    local voiture = {
        Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {8, 0, 255}, Title = "GARAGE" },
        Data = { currentMenu = "~r~Voici votre menu :", "Test"},
        Events = {
            onSelected = function(self, _, btn, PMenu, menuData, result)
             
                if btn.name == "Camionette" then   
                    spawnCar200("burrito3")
                    CloseMenu('')
                elseif btn.name == "~r~Fermer le Menu" then
                    CloseMenu('')
                end 
        end,
    },
        Menu = {
            ["~r~Voici votre menu :"] = {
                b = {
                    {name = "Camionette", ask = '~b~→→→', askX = true},
                    {name = "~b~-----------------------------------------------------------------------", ask = '', askX = true},
                    {name = "~r~Fermer le Menu", ask = '❌', askX = true},
                }
            }
        }
    } 
    
    
    function spawnCar200(car)
        local car = GetHashKey(car)
        RequestModel(car)
        while not HasModelLoaded(car) do
            RequestModel(car)
            Citizen.Wait(50)   
        end
    
    
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), false))
        local vehicle = CreateVehicle(car, -41.73, -1742.86, 29.12, 41.90, true, false)   ---- spawn du vehicule (position)
        ESX.ShowNotification('~b~Garage~s~ : Vous avez sorti votre véhicule, bonne route ! ')
        TriggerServerEvent('esx_vehiclelock:givekey', 'no', plate)
        SetEntityAsNoLongerNeeded(vehicle)
        SetVehicleNumberPlateText(vehicle, "LTD")
    
    
    
    
    
    end 
    
    local ltdgarage = { 
        {x=-40.97, y=-1747.34, z=29.30} -- Point pour sortir le vehicule
    }
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            for k in pairs(ltdgarage) do
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, ltdgarage[k].x, ltdgarage[k].y, ltdgarage[k].z)
                if dist <= 1.5 and PlayerData.job and PlayerData.job.name == 'ltd'  then
                    DrawMarker(23, -1923.64, 2054.36, 139.83, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.9, 0.9, 0.9, 255, 255, 0, 255, 0, 1, 2, 0, nil, nil, 0)
                    ESX.ShowHelpNotification("~h~Appuyez sur [~b~E~s~] pour accéder au garage")
                    if IsControlJustPressed(1,38) then 			
                        CreateMenu(voiture)
             end end end end end)   

                      -------------------------------------------------------- Suppression VOITURE -------------------------------------------------------

local suppressionltd = { 
    {x=-41.82, y=-1742.98, z=29.15} -- Suppression pos
}
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k in pairs(suppressionltd) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, suppressionltd[k].x, suppressionltd[k].y, suppressionltd[k].z)
            if dist <= 1.5 and PlayerData.job and PlayerData.job.name == 'ltd'  then
                DrawMarker(36, -41.82, -1742.98, 29.15, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.9, 0.9, 0.9, 8, 0, 255, 255, 0, 1, 2, 0, nil, nil, 0)
                ESX.ShowHelpNotification("~h~Appuyez sur [~b~E~s~] pour ranger ton véhicule")
                if IsControlJustPressed(1,38) then 			
                    TriggerEvent('esx:deleteVehicle')
         end end end end end)

                  -----------------------------------------------------------------------------------------------------------------
---------------------------------------------- VESTIAIRE -----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

local ltdvetement = {
    Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {8, 0, 255}, Title = "VESTIAIRE" },
    Data = { currentMenu = "~r~Vestiaire :", "Test"},
    Events = {
        onSelected = function(self, _, btn, PMenu, menuData, result)

        if btn.name == "~r~Fermer le Menu" then
            CloseMenu()
        elseif btn.name == "Prendre sa tenue" then
            habittaff()
        elseif btn.name == "Déposer sa tenue" then
            tenuecivil()
        end 
end,
},
Menu = {
    ["~r~Vestiaire :"] = {
        b = {
            {name = "Prendre sa tenue", ask = '~b~→→→', askX = true},
            {name = "Déposer sa tenue", ask = '~b~→→→', askX = true},
            {name = "~b~----------------------------------------------------------------------", ask = '', askX = true},
            {name = "~r~Fermer le Menu", ask = '❌', askX = true},
        }
    }
}
} 

local vestiaire = { 
    {x=-44.83, y=-1751.18, z=29.43} --vestiaire
}
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k in pairs(vestiaire) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, vestiaire[k].x, vestiaire[k].y, vestiaire[k].z)
            if dist <= 1.5 and PlayerData.job and PlayerData.job.name == 'ltd'  then
            DrawMarker(22, -44.83, -1751.18, 29.43, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.6, 8, 0, 255, 255, 0, 1, 2, 0, nil, nil, 0)
                ESX.ShowHelpNotification("~h~Appuyez sur [~b~E~s~] pour accéder à l'armoire")
                if IsControlJustPressed(1,38) then 			
                    CreateMenu(ltdvetement)
         end end end end end)

-----------------------------------------------------------------------------------------------------------------
---------------------------------------------- ACHAT ALIMENTS ---------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    local hash = GetHashKey("csb_customer")
    while not HasModelLoaded(hash) do
    RequestModel(hash)
    Wait(20)
    end
    ped = CreatePed("PED_TYPE_CIVFEMALE", "csb_customer", -1190.76, -742.93, 19.2, 308.4, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    end)

    local achats = {
        Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {8, 0, 255}, Title = "ACHAT NOURRITURES" },
        Data = { currentMenu = "~r~Voici votre menu :", "Test"},
        Events = {
            onSelected = function(self, _, btn, PMenu, menuData, result)
    
            if btn.name == "~r~Fermer le Menu" then
                CloseMenu()
            elseif btn.name == "Pain" then
                TriggerServerEvent('ibktm22:ltdpain')
            elseif btn.name == "Bonbons" then
                TriggerServerEvent('ibktm22:ltdbonbons')
            elseif btn.name == "Chips" then
                TriggerServerEvent('ibktm22:ltdchips')
            elseif btn.name == "Cookie" then
                TriggerServerEvent('ibktm22:ltdcookie')
            elseif btn.name == "Donuts" then
                TriggerServerEvent('ibktm22:ltddonuts')
            elseif btn.name == "Hamburger" then
                TriggerServerEvent('ibktm22:ltdburger')
            elseif btn.name == "Muffin" then
                TriggerServerEvent('ibktm22:ltdmuffin')
            elseif btn.name == "Nutella Bready" then
                TriggerServerEvent('ibktm22:ltdnutella')
            elseif btn == "Déposer sa tenue" then
                tenuecivil()
            end 
    end,
    },
    Menu = {
        ["~r~Voici votre menu :"] = {
            b = {
                {name = "Pain", ask = '~b~1$', askX = true},
                {name = "Bonbons", ask = '~b~2$', askX = true},
                {name = "Chips", ask = '~b~2$', askX = true},
                {name = "Cookie", ask = '~b~1$', askX = true},
                {name = "Donuts", ask = '~b~3$', askX = true},
                {name = "Hamburger", ask = '~b~4$', askX = true},
                {name = "Muffin", ask = '~b~2$', askX = true},
                {name = "Nutella Bready", ask = '~b~5$', askX = true},
                {name = "~b~----------------------------------------------------------------------", ask = '', askX = true},
                {name = "~r~Fermer le Menu", ask = '❌', askX = true},
            }
        }
    }
    } 
    
    local achataliments = { 
        {x=-1190.76, y=-742.93, z=19.2} --vestiaire
    }
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            for k in pairs(achataliments) do
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, achataliments[k].x, achataliments[k].y, achataliments[k].z)
                if dist <= 1.5 and PlayerData.job and PlayerData.job.name == 'ltd'  then
                DrawMarker(22, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.9, 0.9, 0.9, 81, 189, 49, 255, 0, 1, 2, 0, nil, nil, 0)
                    ESX.ShowHelpNotification("~h~Appuyez sur [~b~E~s~] pour parler au vendeur")
                    if IsControlJustPressed(1,38) then 			
                        CreateMenu(achats)
             end end end end end)

             -----------------------------------------------------------------------------------------------------------------
---------------------------------------------- ACHAT ALIMENTS ---------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    local hash = GetHashKey("csb_customer")
    while not HasModelLoaded(hash) do
    RequestModel(hash)
    Wait(20)
    end
    ped = CreatePed("PED_TYPE_CIVFEMALE", "csb_customer", 282.89, 28.18, 83.1, 164.5, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    end)

    local achatsboissons = {
        Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {8, 0, 255}, Title = "ACHAT BOISSONS" },
        Data = { currentMenu = "~r~Voici votre menu :", "Test"},
        Events = {
            onSelected = function(self, _, btn, PMenu, menuData, result)
    
            if btn.name == "~r~Fermer le Menu" then
                CloseMenu()
            elseif btn.name == "Bière" then
                TriggerServerEvent('ibktm22:ltdbiere')
            elseif btn.name == "Ice Tea" then
                TriggerServerEvent('ibktm22:ltdtea')
            elseif btn.name == "Jus de Fruits" then
                TriggerServerEvent('ibktm22:ltdjus')
            elseif btn.name == "Martini" then
                TriggerServerEvent('ibktm22:ltdmartini')
            elseif btn.name == "Mojito" then
                TriggerServerEvent('ibktm22:ltdmojito')
            elseif btn.name == "Oasis" then
                TriggerServerEvent('ibktm22:ltdoasis')
            elseif btn.name == "Orangina" then
                TriggerServerEvent('ibktm22:ltdorangina')
            elseif btn.name == "Pepsi" then
                TriggerServerEvent('ibktm22:ltdpepsi')
            elseif btn == "Déposer sa tenue" then
                tenuecivil()
            end 
    end,
    },
    Menu = {
        ["~r~Voici votre menu :"] = {
            b = {
                {name = "Bière", ask = '~b~4$', askX = true},
                {name = "Ice Tea", ask = '~b~2$', askX = true},
                {name = "Jus de Fruits", ask = '~b~1$', askX = true},
                {name = "Martini", ask = '~b~4$', askX = true},
                {name = "Mojito", ask = '~b~5$', askX = true},
                {name = "Oasis", ask = '~b~2$', askX = true},
                {name = "Orangina", ask = '~b~2$', askX = true},
                {name = "Pepsi", ask = '~b~2$', askX = true},
                {name = "~b~----------------------------------------------------------------------", ask = '', askX = true},
                {name = "~r~Fermer le Menu", ask = '❌', askX = true},
            }
        }
    }
    } 
    
    local  achatboissons = { 
        {x=282.89, y=28.18, z=84.0} --point menu
    }
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            for k in pairs(achatboissons) do
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, achatboissons[k].x, achatboissons[k].y, achatboissons[k].z)
                if dist <= 1.5 and PlayerData.job and PlayerData.job.name == 'ltd'  then
                DrawMarker(22, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.9, 0.9, 0.9, 81, 189, 49, 255, 0, 1, 2, 0, nil, nil, 0)
                    ESX.ShowHelpNotification("~h~Appuyez sur [~b~E~s~] pour parler au vendeur")
                    if IsControlJustPressed(1,38) then 			
                        CreateMenu(achatsboissons)
             end end end end end)