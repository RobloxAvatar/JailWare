local engine = loadstring(game:HttpGet("https://raw.githubusercontent.com/RobloxAvatar/JailWare/main/Engine.lua"))()

engine.MakeNotification("Initialization Scripts...", 5)

wait(5.1)

engine.MakeNotification("Successfully Initialized!", 3)

wait(3)

function destroylasers()
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
end

local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/RobloxAvatar/uiLibary/main/Uilib.lua')))()

local w = library:CreateWindow("JailWare")
local MainTab = w:CreateFolder("Main")

MainTab:Button("Open All Doors", function()
    for i,v in next, engine.Doors do 
        engine.OpenDoor(v)
    end
end)

MainTab:Button("Remove Lasers", function()
    destroylasers()
    engine.MakeNotification("Removed Lasers!", 3)
end)

MainTab:Toggle("Infinite Nitro", function(bool)
    _G.infNitro = bool
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
