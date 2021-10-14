local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

src = {}
Tunnel.bindInterface("prison",src)

vRP.prepare("vRP/checkid", "SELECT user_id FROM vrp_prisao WHERE user_id = @user_id")
vRP.prepare("vRP/checktime", "SELECT tempo FROM vrp_prisao WHERE tempo = @tempo")


RegisterCommand("prender", function(source,args)
    local nplayer = vRP.getUserSource(parseInt(args[1]))
    local player = vRP.getUserSource(parseInt(args[1]))
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"policia.permissao") then
        if nplayer then
            vRP.setUData(parseInt(args[1]),"vRP:prisao",json.encode(parseInt(args[2])))
            TriggerClientEvent("xst:cutscene", nplayer)
            TriggerClientEvent('xst:prisioneiroo',player,true)
            prison_lockk(parseInt(args[1]))
            TriggerClientEvent("Notify",source,"sucesso","Prisão efetuada com sucesso.",7000)
            TriggerClientEvent("Notify",nplayer,"aviso","Você foi preso por <b>"..vRP.format(parseInt(args[2])).." meses</b>.",16000)
			Wait(18000)
			TriggerClientEvent("Notify",nplayer,"info","Você pode trabalhar para diminuir sua pena.",20000)
			vRP.giveInventoryItem(nplayer,"agua",2)
			vRP.giveInventoryItem(nplayer,"sanduiche",2)
        end
    end
end)

function prison_lockk(target_id)
	local player = vRP.getUserSource(parseInt(target_id))
	if player then
		SetTimeout(60000,function()
			local value = vRP.getUData(parseInt(target_id),"vRP:prisao")
			GlobalState.tempo = json.decode(value) or 0
            if parseInt(GlobalState.tempo) >= 1 then                
				vRP.setUData(parseInt(target_id),"vRP:prisao",json.encode(parseInt(GlobalState.tempo)-1))
				prison_lockk(parseInt(target_id))
			elseif parseInt(GlobalState.tempo) <= 0 then
                TriggerClientEvent('xst:prisioneiroo',player,false)
				vRPclient.teleport(player,1850.5,2604.0,45.5)
				vRP.setUData(parseInt(target_id),"vRP:prisao",json.encode(-1))
				TriggerClientEvent("Notify",player,"importante","Sua sentença terminou, esperamos não ve-lo novamente.",8000)
			end
		end)
	end
end

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	local player = vRP.getUserSource(parseInt(user_id))
	if player then
		SetTimeout(30000,function()
			local value = vRP.getUData(parseInt(user_id),"vRP:prisao")
			local tempo = json.decode(value) or -1

			if GlobalState.tempo == -1 then
				return
			end

			if GlobalState.tempo > 0 then
				TriggerClientEvent('prisioneiro',player,true)
				vRPclient.teleport(player,1680.1,2513.0,46.5)
				prison_lock(parseInt(user_id))
			end
		end)
	end
end)

RegisterServerEvent("xst:globalstate")
AddEventHandler("xst:globalstate", function()
	local source = source
	local user_id = vRP.getUserId(source)
	local value = vRP.getUData(parseInt(user_id),"vRP:prisao")
	GlobalState.tempo = json.decode(value) or 0	
end)

RegisterServerEvent("xst:diminuirpenaa")
AddEventHandler("xst:diminuirpenaa",function()
	local source = source
	local user_id = vRP.getUserId(source)
	local value = vRP.getUData(parseInt(user_id),"vRP:prisao")
	GlobalState.tempo = json.decode(value) or 0	
	vRP.setUData(parseInt(user_id),"vRP:prisao",json.encode(parseInt(GlobalState.tempo)-math.random(4,9)))
end)

AddEventHandler('onResourceStart', function(resourceName)
	print("Inicializado")
	TriggerEvent("xst:globalstate")
end)
