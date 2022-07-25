local keys, network = loadstring(game:HttpGet("https://raw.githubusercontent.com/RobloxAvatar/JailWare/main/Fetcher.lua"))()

local replicated_storage = game:GetService("ReplicatedStorage")
local run_service = game:GetService("RunService")
local pathfinding_service = game:GetService("PathfindingService")
local players = game:GetService("Players")
local tween_service = game:GetService("TweenService")

local player = players.LocalPlayer

local dependencies = {
    variables = {
        up_vector = Vector3.new(0, 500, 0),
        raycast_params = RaycastParams.new(),
        path = pathfinding_service:CreatePath({WaypointSpacing = 3}),
        player_speed = 150, 
        vehicle_speed = 450
    },
    modules = {
        ui = require(replicated_storage.Module.UI),
        store = require(replicated_storage.App.store),
        player_utils = require(replicated_storage.Game.PlayerUtils),
        vehicle_data = require(replicated_storage.Game.Garage.VehicleData)
    },
    helicopters = {Heli = true},
    motorcycles = {Volt = true},
    free_vehicles = {},
    unsupported_vehicles = {},
    door_positions = {}    
}

local movement = {}
local utilities = {}

function utilities:toggle_door_collision(door, toggle)
    for index, child in next, door.Model:GetChildren() do 
        if child:IsA("BasePart") then 
            child.CanCollide = toggle
        end 
    end
end

function utilities:get_nearest_vehicle(tried)
    local nearest
    local distance = math.huge

    for index, action in next, dependencies.modules.ui.CircleAction.Specs do
        if action.IsVehicle and action.ShouldAllowEntry == true and action.Enabled == true and action.Name == "Enter Driver" then
            local vehicle = action.ValidRoot

            if not table.find(tried, vehicle) and workspace.VehicleSpawns:FindFirstChild(vehicle.Name) then
                if not dependencies.unsupported_vehicles[vehicle.Name] and (dependencies.modules.store._state.garageOwned.Vehicles[vehicle.Name] or dependencies.free_vehicles[vehicle.Name]) and not vehicle.Seat.Player.Value then
                    if not workspace:Raycast(vehicle.Seat.Position, dependencies.variables.up_vector, dependencies.variables.raycast_params) then
                        local magnitude = (vehicle.Seat.Position - player.Character.HumanoidRootPart.Position).Magnitude
            
                        if magnitude < distance then 
                            distance = magnitude
                            nearest = vehicle
                        end
                    end
                end
            end
        end
    end

    return nearest
end

function movement:move_to_position(part, cframe, speed, car, target_vehicle, tried_vehicles)
    local vector_position = cframe.Position
    
    if not car and workspace:Raycast(part.Position, dependencies.variables.up_vector, dependencies.variables.raycast_params) then
        movement:pathfind()
        task.wait(0.5)
    end
    
    local y_level = 500
    local higher_position = Vector3.new(vector_position.X, y_level, vector_position.Z)

    repeat
        local velocity_unit = (higher_position - part.Position).Unit * speed
        part.Velocity = Vector3.new(velocity_unit.X, 0, velocity_unit.Z)

        task.wait()

        part.CFrame = CFrame.new(part.CFrame.X, y_level, part.CFrame.Z)

        if target_vehicle and target_vehicle.Seat.Player.Value then
            table.insert(tried_vehicles, target_vehicle)

            local nearest_vehicle = utilities:get_nearest_vehicle(tried_vehicles)

            if nearest_vehicle then 
                movement:move_to_position(player.Character.HumanoidRootPart, nearest_vehicle.Seat.CFrame, 135, false, nearest_vehicle)
            end

            return
        end
    until (part.Position - higher_position).Magnitude < 10

    part.CFrame = CFrame.new(part.Position.X, vector_position.Y, part.Position.Z)
    part.Velocity = Vector3.new(0, 0, 0)
end

dependencies.variables.raycast_params.FilterType = Enum.RaycastFilterType.Blacklist
dependencies.variables.raycast_params.FilterDescendantsInstances = {player.Character, workspace.Vehicles, workspace:FindFirstChild("Rain")}

workspace.ChildAdded:Connect(function(child)
    if child.Name == "Rain" then 
        table.insert(dependencies.variables.raycast_params.FilterDescendantsInstances, child)
    end
end)

player.CharacterAdded:Connect(function(character)
    table.insert(dependencies.variables.raycast_params.FilterDescendantsInstances, character)
end)

for index, vehicle_data in next, dependencies.modules.vehicle_data do
    if vehicle_data.Type == "Heli" then
        dependencies.helicopters[vehicle_data.Make] = true
    elseif vehicle_data.Type == "Motorcycle" then
        dependencies.motorcycles[vehicle_data.Make] = true
    end

    if vehicle_data.Type ~= "Chassis" and vehicle_data.Type ~= "Motorcycle" and vehicle_data.Type ~= "Heli" and vehicle_data.Type ~= "DuneBuggy" and vehicle_data.Make ~= "Volt" then
        dependencies.unsupported_vehicles[vehicle_data.Make] = true
    end
    
    if not vehicle_data.Price then
        dependencies.free_vehicles[vehicle_data.Make] = true
    end
end

for index, value in next, workspace:GetChildren() do
    if value.Name:sub(-4, -1) == "Door" then 
        local touch_part = value:FindFirstChild("Touch")

        if touch_part and touch_part:IsA("BasePart") then
            for distance = 5, 100, 5 do 
                local forward_position, backward_position = touch_part.Position + touch_part.CFrame.LookVector * (distance + 3), touch_part.Position + touch_part.CFrame.LookVector * -(distance + 3)
                
                if not workspace:Raycast(forward_position, dependencies.variables.up_vector, dependencies.variables.raycast_params) then
                    table.insert(dependencies.door_positions, {instance = value, position = forward_position})

                    break
                elseif not workspace:Raycast(backward_position, dependencies.variables.up_vector, dependencies.variables.raycast_params) then
                    table.insert(dependencies.door_positions, {instance = value, position = backward_position})

                    break
                end
            end
        end
    end
end

local old_is_point_in_tag = dependencies.modules.player_utils.isPointInTag
dependencies.modules.player_utils.isPointInTag = function(point, tag)
    if tag == "NoRagdoll" or tag == "NoFallDamage" then 
        return true
    end
    
    return old_is_point_in_tag(point, tag)
end

local function teleport(cframe, tried)
    local relative_position = (cframe.Position - player.Character.HumanoidRootPart.Position)
    local target_distance = relative_position.Magnitude

    if target_distance <= 20 and not workspace:Raycast(player.Character.HumanoidRootPart.Position, relative_position.Unit * target_distance, dependencies.variables.raycast_params) then 
        player.Character.HumanoidRootPart.CFrame = cframe 
        
        return
    end 

    local tried = tried or {}
    local nearest_vehicle = utilities:get_nearest_vehicle(tried)

    if nearest_vehicle then 
        local vehicle_distance = (nearest_vehicle.Seat.Position - player.Character.HumanoidRootPart.Position).Magnitude 

        if target_distance < vehicle_distance then
            movement:move_to_position(player.Character.HumanoidRootPart, cframe, dependencies.variables.player_speed)
        else 
            if nearest_vehicle.Seat.PlayerName.Value ~= player.Name then
                movement:move_to_position(player.Character.HumanoidRootPart, nearest_vehicle.Seat.CFrame, dependencies.variables.player_speed, false, nearest_vehicle, tried)

                local enter_attempts = 1

                repeat
                    network:FireServer(keys.EnterCar, nearest_vehicle, nearest_vehicle.Seat)
                    
                    enter_attempts = enter_attempts + 1

                    task.wait(0.1)
                until enter_attempts == 10 or nearest_vehicle.Seat.PlayerName.Value == player.Name

                if nearest_vehicle.Seat.PlayerName.Value ~= player.Name then
                    table.insert(tried, nearest_vehicle)

                    return teleport(cframe, tried or {nearest_vehicle})
                end
            end

            local vehicle_root_part

            if dependencies.helicopters[nearest_vehicle.Name] then 
                vehicle_root_part = nearest_vehicle.Model.TopDisc
            elseif dependencies.motorcycles[nearest_vehicle.Name] then 
                vehicle_root_part = nearest_vehicle.CameraVehicleSeat
            elseif nearest_vehicle.Name == "DuneBuggy" then 
                vehicle_root_part = nearest_vehicle.BoundingBox
            else 
                vehicle_root_part = nearest_vehicle.PrimaryPart
            end

            movement:move_to_position(vehicle_root_part, cframe, dependencies.variables.vehicle_speed, true)

            repeat
                task.wait(0.15)
                network:FireServer(keys.ExitCar)
            until nearest_vehicle.Seat.PlayerName.Value ~= player.Name
        end
    end
end

return teleport
