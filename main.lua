local functions = {
    'base',
    'calculate-score',
    'hook',
    'joker-display',
    'talisman',
}

local items = {
    'blind',
    'booster', 
    'challenge',
    'consumable',
    'deck',
    'enhancement',
    'joker',
    'stake',
    'sticker',
    'tag',
    'voucher'
}

local jokers = {
    'atlas',
    'dart',
    'boomer',
    'bomb',
    'tack',
    'ice',
    'glue',
    'desperado',
    'sniper',
    'sub',
    'boat',
    'ace',
    'heli',
    'mortar',
    'dartling',
    'wizard',
    'super',
    'ninja',
    'alch',
    'druid',
    'mermonkey',
    'farm',
    'spac',
    'village',
    'engi',
    'beast',
    'other',
    'legendary',
}

for k, v in ipairs(functions) do
    local success, error_msg = pcall(function()
        local init, error = SMODS.load_file("functions/" .. v .. ".lua")
        if not error then
            if init then
                init()
            end
            sendDebugMessage("Loaded module: " .. v)
        end
    end)
    if not success then
        sendErrorMessage("Error in module " .. v .. ": " .. error_msg)
    end
end

for k, v in ipairs(items) do
    local success, error_msg = pcall(function()
        local init, error = SMODS.load_file("items/" .. v .. ".lua")
        if not error then
            if init then
                init()
            end
            sendDebugMessage("Loaded module: " .. v)
        end
    end)
    if not success then
        sendErrorMessage("Error in module " .. v .. ": " .. error_msg)
    end
end

for k, v in ipairs(jokers) do
    local success, error_msg = pcall(function()
        local init, error = SMODS.load_file("items/jokers/" .. v .. ".lua")
        if not error then
            if init then
                init()
            end
            sendDebugMessage("Loaded module: " .. v)
        end
    end)
    if not success then
        sendErrorMessage("Error in module " .. v .. ": " .. error_msg)
    end
end