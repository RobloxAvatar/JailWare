local start_time = tick();
local network = getupvalue(require(game.ReplicatedStorage.Module.AlexChassis).SetEvent, 1);
local keys_list = getupvalue(getupvalue(network.FireServer, 1), 3);
local roblox_environment = getrenv();

local function fetch_key(caller_function)
    local constants = getconstants(caller_function);
    
    for index, constant in next, constants do
        if keys_list[constant] then
            return constant;
        elseif type(constant) ~= "string" or constant == "" or roblox_environment[constant] or string[constant] or table[constant] or #constant > 7 or constant:lower() ~= constant then
            constants[index] = nil; 
        end;
    end;
    
    for key, remote in next, keys_list do 
        local prefix_passed = false;
        local key_length = #key;
        
        for index, constant in next, constants do 
            local constant_length = #constant;
            
            if not prefix_passed and key:sub(1, constant_length) == constant then -- check if the key starts with one of the constants
                prefix_passed = constant;
            elseif prefix_passed and constant ~= prefix_passed and key:sub(key_length - (constant_length - 1), key_length) == constant then -- check if the key ends with one of the constants
                return key;
            end;
        end;
    end;
end;

local network_keys = {}

local default_actions = require(game.ReplicatedStorage.Game.DefaultActions);

do
    local punch_function = getupvalue(default_actions.punchButton.onPressed, 1).attemptPunch;
    
    network_keys.Punch = fetch_key(punch_function)
end
