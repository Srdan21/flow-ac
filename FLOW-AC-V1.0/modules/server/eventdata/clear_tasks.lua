ClearTasks = {}

if not ServerConfig.Modules.ClearTasks.enabled then
    return
end

function ClearTasks.ProcessEventData(sender, data)
	TriggerEvent("flow:0tlj76j3duew", sender, "ClearPedTask [C1]", false)
	CancelEvent()
end
