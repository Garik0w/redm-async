# RedM Async
![RedM-async](https://i.imgur.com/gIg0rcH.jpg)
Async utilities for RedM

## INSTALLATION

Set it as a dependency in you **__resource.lua** or **fxmanifest.lua**

```lua
server_script '@async/async.lua'
```

## USAGE

```lua
local tasks = {}

for i=1, 100, 1 do

	local task = function(cb)
		
		SetTimeout(1000, function()

			local result = math.random(1, 50000)

			cb(result)
			
		end)

	end

	table.insert(tasks, task)

end

Async.parallel(tasks, function(results)
	-- Trigger when all tasks are done
	print(json.encode(results))
end)

Async.parallelLimit(tasks, 2, function(results)
	-- Trigger when all tasks are done
	print(json.encode(results))
end)

Async.series(tasks, function(results)
	-- Trigger when all tasks are done
	print(json.encode(results))
end)

```
