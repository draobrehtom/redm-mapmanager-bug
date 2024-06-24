-- End round
local function roundEnded()
    exports['mapmanager']:roundEnded()
end
RegisterCommand('round-ended', function()
    roundEnded()
end, false)

--[[
    Tests
]]

-- Scenario 1 [All correct]
-- AddEventHandler('playerConnecting', function()
--     print('Scenario 1')
--     roundEnded()
-- end)

-- Scenario 2 [Bug identified]
AddEventHandler('playerJoining', function()
    print('Scenario 2')
    roundEnded()
end)