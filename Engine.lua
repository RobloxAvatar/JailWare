local JailWare = {}
JailWare.Doors = {}

for i, v in pairs(getgc(true)) do
    if type(v) == "table" then
        if rawget(v, "State") and rawget(v, "OpenFun") then
            table.insert(JailWare.Doors, v)
        end
    elseif type(v) == "function" then
        if getfenv(v).script == game:GetService("Players").LocalPlayer.PlayerScripts.LocalScript then
            local con = getconstants(v)
            if table.find(con, "SequenceRequireState") then
                JailWare.OpenDoor = v
            end
        end
    end
end

return JailWare
