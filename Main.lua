require(game:GetService("ReplicatedStorage").Game.Notification).new({
    Text = "Loading JailWare...",
    Duration = 4
})

wait(4)

local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/RobloxAvatar/uiLibary/main/Uilib.lua')))()

local w = library:CreateWindow("JailWare")
local MainTab = w:CreateFolder("Main")

local engine = loadstring(game:HttpGet("https://raw.githubusercontent.com/RobloxAvatar/JailWare/main/Engine.lua"))()

MainTab:Button("Open All Doors", function()
    for i,v in next, engine.Doors do 
        engine.OpenDoor(v)
    end
end)
