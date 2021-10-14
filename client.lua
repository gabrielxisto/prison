local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

src = Tunnel.getInterface("vrp_prison")

GlobalState.reducaopenalvarrerchao = false



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if GlobalState.tempo > -1 then
			local ped = PlayerPedId()
			local distance1 = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),1642.78, 2541.22, 45.57,true)

			if GetEntityHealth(PlayerPedId()) <= 100 then
				GlobalState.reducaopenalvarrerchao = false
				vRP._DeletarObjeto()
			end

			if distance1 <= 100 and not GlobalState.reducaopenalvarrerchao then
				if distance1 <= 5.0 then
					drawSimple(1642.78, 2541.22, 45.57,"PRESSIONE ~r~E~w~ PARA TRABALHAR VARRENDO CHÃO")
					if IsControlJustPressed(0,38) then
						GlobalState.reducaopenalvarrerchao = true

						vRP._CarregarObjeto("amb@world_human_janitor@male@idle_a","idle_a","prop_tool_broom",50,28422)
						Wait(30000)
						TriggerServerEvent("xst:diminuirpenaa")
						Wait(4000)
						TriggerEvent("Notify","importante","Sua pena foi reduzida, faltam " ..GlobalState.tempo.. " meses.")
						vRP.DeletarObjeto()
						ClearPedTasks(ped)
						ResetPedMovementClipset(PlayerPedId(),0)
						SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
						GlobalState.reducaopenalvarrerchao = false
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		if GlobalState.tempo > 0 then
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),1700.5,2605.2,45.5,true)
			if distance >= 150 then
				SetEntityCoords(PlayerPedId(),1680.1,2513.0,45.5)
				TriggerEvent("Notify","aviso","O agente penitenciário encontrou você tentando escapar.")
				print(TriggerEvent("xst:returntime"))
			end
		end
	end
end)

RegisterNetEvent('xst:cutscene')
AddEventHandler('xst:cutscene', function()
    local ped = PlayerPedId()
	if not DoesCamExist(cam) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        cam2 = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
		cam3 = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
		cam4 = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
		cam5 = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	end
	DoScreenFadeOut(2000)
    Wait(3000)
	SetEntityCoords(ped, 1775.44, 2552.07, 45.47, false, false, true)
    DoScreenFadeIn(2000)
	SetCamActive(cam,  true)
	SetCamCoord(cam, 1876.78, 2595.59, 56.11)
	PointCamAtCoord(cam, 1830.43, 2603.61, 48.53)
	SetCamActive(cam3,  true)
	RenderScriptCams(true,  false,  0,  true,  true)
	SetCamCoord(cam3, 1622.98, 2560.19, 60.44)
	PointCamAtCoord(cam3, 1654.47, 2513.88, 46.15)
	SetCamActive(cam4,  true)
	SetCamCoord(cam4, 1678.87, 2557.61, 59.01)
	PointCamAtCoord(cam4, 1654.47, 2513.88, 46.15)
	SetEntityCollision(GetPlayerPed(-1),  false,  false)
	SetEntityVisible(GetPlayerPed(-1),  false)
	FreezeEntityPosition(GetPlayerPed(-1), true);
    SetCamActive(cam2,  true)
	RenderScriptCams(true,  false,  0,  true,  true)
	SetCamCoord(cam2, 1880.19, 2645.47, 58.76)
	PointCamAtCoord(cam2, 1830.43, 2603.61, 48.53)
    SetCamActiveWithInterp(cam2, cam, 15000, 1, 1    )
    Wait(12000)
    DoScreenFadeOut(2000)
    Wait(3000)
    DoScreenFadeIn(2000)
	SetCamActiveWithInterp(cam4, cam3, 15000, 1, 1    )
	Wait(12000)
	DoScreenFadeOut(2000)
    Wait(3000)
    DoScreenFadeIn(2000)
	RenderScriptCams(false, false, 0, true, false)
	Wait(1000)
	SetEntityCollision(GetPlayerPed(-1),  true,  true)
	SetEntityVisible(GetPlayerPed(-1),  true)
	FreezeEntityPosition(GetPlayerPed(-1), false);
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWSIMPLE
-----------------------------------------------------------------------------------------------------------------------------------------
function drawSimple(x,y,z,text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35,0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 200)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end
	  
