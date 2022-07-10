local engine = loadstring(game:HttpGet("https://raw.githubusercontent.com/RobloxAvatar/JailWare/main/Engine.lua"))()

engine.MakeNotification("Initialization Scripts...", 5)

wait(5.1)

engine.MakeNotification("Successfully Initialized!", 3)

local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/RobloxAvatar/uiLibary/main/Uilib.lua')))()

local w = library:CreateWindow("JailWare")
local MainTab = w:CreateFolder("Main")

MainTab:Button("Open All Doors", function()
    for i,v in next, engine.Doors do 
        engine.OpenDoor(v)
    end
end)

MainTab:Button("Remove Lasers", function()
    for i,v in pairs(workspace:GetDescendants()) do
        if string.find(v.Name, "Lasers") then
            v:Destroy()
        end
    end
    engine.MakeNotification("Removed Lasers!", 3)
end)
