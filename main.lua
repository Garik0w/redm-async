Async = {
	TaskID = 0,
	Tasks = {}
}

Async.parallel = function(tasks, cb)
	if (type(tasks) ~= 'table' or #tasks == 0) then
		if(cb ~= nil) then cb({}) end
		return
	end

	if (Async.TaskID < 65535) then
		Async.TaskID = Async.TaskID + 1
	else
		Async.TaskID = 1
	end

	local currentTaskId = Async.TaskID

	Async.Tasks[currentTaskId] = {
		remaining = #tasks,
		results = {}
	}

	for _, task in ipairs(tasks) do
		Citizen.CreateThread(function()
			local taskId = currentTaskId

			task(function(result)
				Async.Tasks[taskId].remaining = Async.Tasks[taskId].remaining - 1

				table.insert(Async.Tasks[taskId].results, result)
			end)
		end)
	end

	Citizen.CreateThread(function()
		local taskId = currentTaskId
		local callback = cb

		while true do
			if (Async.Tasks[taskId].remaining <= 0) then
                callback(Async.Tasks[taskId].results)
                Async.Tasks[taskId] = nil
				return
			end

			Citizen.Wait(0)
		end
	end)
end

Async.parallelLimit = function(tasks, limit, cb)
	if (type(tasks) ~= 'table' or #tasks == 0) then
		if(cb ~= nil) then cb({}) end
		return
	end

	if (Async.TaskID < 65535) then
		Async.TaskID = Async.TaskID + 1
	else
		Async.TaskID = 1
	end

	local currentTaskId = Async.TaskID

	Async.Tasks[currentTaskId] = {
        remaining = #tasks,
        running = 0,
        results = {},
        queue = tasks,
        limit = limit
	}

    Citizen.CreateThread(function()
        local taskId = currentTaskId
        local callback = cb

        for _, task in ipairs(Async.Tasks[taskId].queue) do
            while Async.Tasks[taskId].running >= Async.Tasks[taskId].limit do
                Citizen.Wait(0)
            end

            Citizen.CreateThread(function()
                Async.Tasks[taskId].running = Async.Tasks[taskId].running + 1

                task(function(result)
                    Async.Tasks[taskId].remaining = Async.Tasks[taskId].remaining - 1
                    Async.Tasks[taskId].running = Async.Tasks[taskId].running - 1

                    table.insert(Async.Tasks[taskId].results, result)
                end)
            end)
        end

        while true do
			if (Async.Tasks[taskId].remaining <= 0) then
                callback(Async.Tasks[taskId].results)
                Async.Tasks[taskId] = nil
				return
			end

			Citizen.Wait(0)
		end
    end)
end

Async.series = function(tasks, cb)
	Async.parallelLimit(tasks, 1, cb)
end

AddEventHandler('async:getSharedObject', function(cb)
    cb(Async)
end)

exports('getSharedObject', function()
    return Async
end)