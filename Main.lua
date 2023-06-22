local engine = loadstring(game:HttpGet("https://raw.githubusercontent.com/RobloxAvatar/JailWare/main/Engine.lua"))()

engine.MakeNotification("Initialization Scripts...", 5)

wait(5.1)

engine.MakeNotification("Successfully Initialized!", 3)

wait(3)

local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/RobloxAvatar/uiLibary/main/Uilib.lua')))()

local w = library:CreateWindow("JailWare")
local MainTab = w:CreateFolder("Main")
local VechileTab = w:CreateFolder("Vechiles")
local GunTab = w:CreateFolder("Guns")
local LocalPlayerTab = w:CreateFolder("LocalPlayer")

function casinoVaultCrack()
    workspace.Casino.HackableVaults.VaultDoorMain.InnerModel.Puzzle.RequestHack:FireServer()

    repeat wait(0.6) until game:GetService("Workspace").Casino.HackableVaults.VaultDoorMain.InnerModel.Model.UnlockedLED.BrickColor == BrickColor.new("Lime green")

    workspace.Casino.HackableVaults.VaultDoorMain.InnerModel.Puzzle.UpdateDirection:FireServer()

    repeat wait(0.6) until game:GetService("Workspace").Casino.HackableVaults.VaultDoorMain.InnerModel.Model.UnlockedLED.BrickColor == BrickColor.new("Lime green")

    workspace.Casino.HackableVaults.VaultDoorMain.InnerModel.Puzzle.UpdateDirection:FireServer()

    repeat wait(0.6) until game:GetService("Workspace").Casino.HackableVaults.VaultDoorMain.InnerModel.Model.UnlockedLED.BrickColor == BrickColor.new("Lime green")

    workspace.Casino.HackableVaults.VaultDoorMain.InnerModel.Puzzle.UpdateDirection:FireServer()
end

local teleport = loadstring(game:HttpGet("https://raw.githubusercontent.com/RobloxAvatar/JailWare/main/Teleporation.lua"))()

function escape()
    teleport(CFrame.new(109.154991, 19.2171669, -1396.34204, 0.254605263, -1.94824654e-08, 0.967045069, 1.27417801e-08, 1, 1.67917111e-08, -0.967045069, 8.04661759e-09, 0.254605263))
end

local Deez = {}

for i,v in next, getgc(true) do
    if type(v) == "table" then
        if rawget(v, "Event") and rawget(v, "GetVehiclePacket") then
            Deez.GetVehiclePacket = v.GetVehiclePacket
        end
    end
end

function destroylasers()
    for i,v in pairs(game.Workspace.Casino.LaserCarousel.InnerModel:GetChildren()) do
        if v.Name == "Part" then
            v:Destroy()
        end
    end
    for i,v in pairs(workspace:GetDescendants()) do
        if v.Name == "Part" and v.Parent.Name == "2_StorageAndMeeting" then
            v:Destroy()
        end
    end
    for i,v in pairs(workspace:GetDescendants()) do
        if v.Name == "BarbedWire" then
            v:Destroy()
        end
    end
    for i,v in pairs(workspace:GetDescendants()) do
        if string.find(v.Name, "Lasers") then
            v:Destroy()
        end
    end
    for i,v in pairs(workspace:GetDescendants()) do
        if string.find(v.Name, "Laser") then
            v:Destroy()
        end
    end
    for i,v in pairs(workspace:GetDescendants()) do
        if v.Name == "Camera" and v.Parent == game:GetService("Workspace").Casino.CamerasMoving then
            v:Destroy()
        end
    end
    function getJewerly()
        for i,v in pairs(game:GetService("Workspace").Jewelrys:GetChildren()) do
            return v.Name
        end
    end

    for i,v in pairs(workspace:GetDescendants()) do
        if v.Name == "Camera" and v.Parent == game:GetService("Workspace").Jewelrys[getJewerly()].Floors["2_StorageAndMeeting"].Cameras then
            v:Destroy()
        end
    end

    function getJewerly2()
        for i,v in pairs(game:GetService("Workspace").Jewelrys:GetChildren()) do
            return v
        end
    end

    for i,v in pairs(getJewerly2().Floors["3_ExpandedStore"]:GetChildren()) do
        if v.Name == "Part" then
            v:Destroy()
        end
    end

    for i,v in pairs(getJewerly2().Floors["3_ExpandedStore"].LaserFloor:GetChildren()) do
        if v:FindFirstChild("Part") and v.Name == "Part" then
            v:Destroy()
        end
    end
end

MainTab:Button("Open All Doors", function()
    for i,v in next, engine.Doors do 
        engine.OpenDoor(v)
    end
end)

MainTab:Button("Escape", function()
    if game.Players.LocalPlayer.Team.Name == "Prisoner" then
        engine.MakeNotification("Fixing Position...", 3.5)
        escape()
    else
        engine.MakeNotification("cannot escape, error: you are " .. game.Players.LocalPlayer.Team.Name .. "!", 3.5)
    end
end)

MainTab:Button("Crack Casino(Vault)", function()
    casinoVaultCrack()
end)

MainTab:Button("Casino Code", function()
    local a = engine.GetCasinoCode()
    engine.MakeNotification("Casino Code: " .. tostring(a), 5)
end)

MainTab:Button("Remove Lasers", function()
    engine.MakeNotification("Removed Lasers!", 3)
    destroylasers()
end)

MainTab:Toggle("Infinite Nitro", function(bool)
    _G.infNitro = bool
end)

GunTab:Button("Get All Guns", function()
    for i,v in pairs(workspace.Givers:GetDescendants()) do
        if v:IsA("ClickDetector") then
            if v.Parent.Item.Value == "Pistol" or v.Parent.Item.Value == "Shotgun" or v.Parent.Item.Value == "RifleSWAT" or v.Parent.Item.Value == "RifleBOSS" or v.Parent.Item.Value == "Baton" then
                fireclickdetector(v)
            end
        end
    end
end)

_G.VechileHeight = 1

VechileTab:Slider("Vechile Height",{
   min = 1,
   max = 250,
   precise = false
},function(hh)
    _G.VechileHeight = hh
end)

_G.VechileSpeed = 1

VechileTab:Slider("Vechile Speed",{
   min = 1,
   max = 150,
   precise = false
},function(sp)
    _G.VechileSpeed = sp
end)

_G.VechileTurnSpeed = 1

VechileTab:Slider("Vechile Turn Speed",{
   min = 1,
   max = 100,
   precise = false
},function(ts)
    Deez.GetVehiclePacket().TurnSpeed = ts
end)

_G.Ws = 16

LocalPlayerTab:Slider("Walkspeed",{
   min = 16,
   max = 100,
   precise = false
},function(ws)
    _G.Ws = ws
end)

game:GetService("UserInputService").InputBegan:Connect(function(i, istyping)
    if istyping == true then return end
    if _G.infNitro == true then
        if i.KeyCode == Enum.KeyCode.Q then
            for i,v in next, getgc(true) do
                if type(v) == "table" and rawget(v, "Nitro") then
                    v.Nitro = math.huge
                end
            end
        end
    end
end)

spawn(function()
    while task.wait() do
        pcall(function()
            Deez.GetVehiclePacket().Height = _G.VechileHeight
        end)
    end
end)

spawn(function()
    while task.wait() do
        pcall(function()
            Deez.GetVehiclePacket().GarageEngineSpeed = _G.VechileSpeed
        end)
    end
end)

spawn(function()
    while task.wait() do
        pcall(function()
            Deez.GetVehiclePacket().TurnSpeed = _G.VechileTurnSpeed
        end)
    end
end)

local gmt = getrawmetatable(game)
local oldIndex = gmt.__index
setreadonly(gmt, false)

gmt.__index = newcclosure(function(Self,Key)
    if tostring(Self) == "Humanoid" and tostring(Key) == "WalkSpeed" then
        return _G.Ws
    end
    return oldIndex(Self,Key)
end)

while wait() do
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = _G.Ws
end

game.Players.LocalPlayer.Character.Humanoid.Died:Connect(function()
    while wait() do
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = _G.Ws
    end
end)
