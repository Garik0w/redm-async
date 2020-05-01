Async    = nil

if (exports and exports['async']) then
    Async = exports['async']:getSharedObject()
end

if (Async == nil) then
    TriggerEvent('async:getSharedObject', function(obj) Async = obj end)
end