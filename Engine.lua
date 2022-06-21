local JailWare = {}
JailWare.Doors = {}

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

function JailWare.MakeNotification(txt, time)
    local p = loadstring(game:HttpGet("https://raw.githubusercontent.com/RobloxAvatar/JailWare/main/Notify.lua"))()
	p:MakeNotification({Name = "JailWare", Content = txt, Time = time})
end

return JailWare
