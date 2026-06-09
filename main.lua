Bloonlatro = {}
Bloonlatro.config = SMODS.current_mod.config

loc_colour()
G.C.PRIMARY  = HEX("25ACE8")
G.C.MILITARY = HEX("3DD228")
G.C.MAGIC    = HEX("7E4AF4")
G.C.SUPPORT  = HEX("EE882B")
G.C.MISC     = HEX("FF6FAE")

G.ARGS.LOC_COLOURS.primary  = G.C.PRIMARY
G.ARGS.LOC_COLOURS.military = G.C.MILITARY
G.ARGS.LOC_COLOURS.magic    = G.C.MAGIC
G.ARGS.LOC_COLOURS.support  = G.C.SUPPORT
G.ARGS.LOC_COLOURS.misc     = G.C.MISC

local old_localize = localize
function localize(args, misc_cat)
    if type(args) == 'table' then
        if args.type == 'bloonlatro_title' then
            local blind = G.localization
                and G.localization.descriptions
                and G.localization.descriptions.Blind
                and G.localization.descriptions.Blind[args.key]

            if blind and blind.title then
                return blind.title
            else
                return "ERROR"
            end
        elseif args.type == 'bloonlatro_desc' then
            local blind = G.localization
                and G.localization.descriptions
                and G.localization.descriptions.Blind
                and G.localization.descriptions.Blind[args.key]

            if blind and blind.desc then
                return blind.desc
            else
                return "ERROR"
            end
        end
    end

    return old_localize(args, misc_cat)
end

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
    'joker_buttons',
    'main_menu',
    'boss',

    --Crossmod files
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
    'desp',
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
