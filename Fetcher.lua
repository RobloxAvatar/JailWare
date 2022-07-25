if network_keys and network then
    return network_keys, network
end

local start_time = tick()

local replicated_storage = game:GetService("ReplicatedStorage")
local collection_service = game:GetService("CollectionService")

local network = getupvalue(require(replicated_storage.Module.AlexChassis).SetEvent, 1)
local keys_list = getupvalue(getupvalue(network.FireServer, 1), 3)

local game_folder = replicated_storage.Game

local team_choose_ui = require(game_folder.TeamChooseUI)
local default_actions = require(game_folder.DefaultActions)

local roblox_environment = getrenv()
local network_keys = {}

local function fetch_key(caller_function)
    local constants = getconstants(caller_function)
    
    for index, constant in next, constants do
        if keys_list[constant] then
            return constant
        elseif type(constant) ~= "string" or constant == "" or roblox_environment[constant] or string[constant] or table[constant] or #constant > 7 or constant:lower() ~= constant then
            constants[index] = nil
        end
    end
    
    for key, remote in next, keys_list do 
        local prefix_passed = false
        local key_length = #key
        
        for index, constant in next, constants do 
            local constant_length = #constant
            
            if not prefix_passed and key:sub(1, constant_length) == constant then 
                prefix_passed = constant
            elseif prefix_passed and constant ~= prefix_passed and key:sub(key_length - (constant_length - 1), key_length) == constant then -- check if the key ends with one of the constants
                return key
            end
        end
    end
end

do
    local exit_car_function = getupvalue(team_choose_ui.Init, 3)
    
    network_keys.ExitCar = fetch_key(exit_car_function)
end

do
    local switch_team_function = getproto(team_choose_ui.Show, 4)
    
    network_keys.SwitchTeam = fetch_key(switch_team_function)
end

do
    local path = getconnections(collection_service:GetInstanceAddedSignal("VehicleSeat"))[1].Function

    local i2 = getupvalue(path, 1)

    local io_ad = getupvalue(i2, 3)

    network_keys.EnterCar = fetch_key(io_ad)
end

local environment = getgenv()

environment.network_keys, environment.network = network_keys, network

warn(("Key Fetcher Loaded in %s Seconds"):format(tick() - start_time))

return network_keys, network
