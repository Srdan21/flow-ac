ResourceStopper = {}

if not ClientConfig.Modules.ResourceStopper.enabled then
    return
end

function ResourceStopper.ProcessEventData(rName)
    TriggerServerEvent("flow:9045go7a03c5", rName)
end
