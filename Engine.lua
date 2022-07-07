local JailWare = {}
JailWare.Doors = {}

function JailWare.MakeNotification(txt, time)
    local p = loadstring(game:HttpGet("https://raw.githubusercontent.com/RobloxAvatar/JailWare/main/Notify.lua"))()
	p:MakeNotification({Name = "JailWare", Content = txt, Time = time})
end

function JailWare.Teleport(cframe)
    game.Players.LocalPlayer.Character.HumanoidRootPart.Parent = nil
    for i,v in pairs(getnilinstances()) do
        if v.Name == "HumanoidRootPart" then
            v.CFrame = cframe
            v.Parent = game.Players.LocalPlayer.Character
        end
    end
end

if game.PlaceId == 606849621 then
    for i, v in pairs(getgc(true)) do
        if type(v) == "table" then
            if rawget(v, "State") and rawget(v, "OpenFun") then
                table.insert(JailWare.Doors, v)
            end
        elseif type(v) == "function" then
            if getfenv(v).script == game:GetService("Players").LocalPlayer.PlayerScripts:FindFirstChild("LocalScript") then
                local con = getconstants(v)
                if table.find(con, "SequenceRequireState") then
                    JailWare.OpenDoor = v
                end
            end
        end
    end
end

return JailWare
