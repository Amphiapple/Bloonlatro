Bloonlatro = {}
Bloonlatro.config = SMODS.current_mod.config

-- category colors
G.C.PRIMARY  = HEX("25ACE8")
G.C.MILITARY = HEX("3DD228")
G.C.MAGIC    = HEX("7E4AF4")
G.C.SUPPORT  = HEX("EE882B")
G.C.MISC     = HEX("FF6FAE")

G.ARGS.LOC_COLOURS          = G.ARGS.LOC_COLOURS or {}
G.ARGS.LOC_COLOURS.primary  = G.C.PRIMARY
G.ARGS.LOC_COLOURS.military = G.C.MILITARY
G.ARGS.LOC_COLOURS.magic    = G.C.MAGIC
G.ARGS.LOC_COLOURS.support  = G.C.SUPPORT
G.ARGS.LOC_COLOURS.misc     = G.C.MISC

SMODS.Atlas({
	key = "modicon",
	path = "icon.png",
	px = 32,
	py = 32,
})

local functions = {
    'base',
    'calculate-score',
    'config_tab',
    'hook',
    'deck_ui',
    'collection',
    'tutorial',
    'badges',

    --Crossmod files
    'bunco',
    'talisman',
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

local items = {
    'blind',
    'booster', 
    'challenge',
    'consumable',
    'deck',
    'enhancement',
    'stake',
    'blind_modifiers',
    'tag',
    'voucher'
}

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
    'merm',
    'farm',
    'spac',
    'village',
    'engi',
    'beast',
    'other',
    'legendary',
}

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

--JokerDisplay files
if SMODS.Mods["JokerDisplay"] and SMODS.Mods["JokerDisplay"].can_load and JokerDisplay then
    for k, v in ipairs(jokers) do
        local success, error_msg = pcall(function()
            local init, error = SMODS.load_file("functions/jokerdisplay/" .. v .. ".lua")
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
end