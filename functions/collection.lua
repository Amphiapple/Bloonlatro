local function create_bloonlatro_collection_button()
    return UIBox_button {
        button = 'your_collection_blind_modifiers',
        label = {'Blind Modifiers'},
        minw = 5,
        id = 'your_collection_blind_modifiers'
    }
end

local function get_sorted_modifiers()
    local out = {}
    for _, modifier in pairs(Bloonlatro.blind_modifiers or {}) do
        out[#out + 1] = modifier
    end
    table.sort(out, function(a, b) return (a.config.ante or '') < (b.config.ante or '') end)
    return out
end

local function make_modifier_cell(modifier)
    local loc_data = G.localization
        and G.localization.descriptions
        and G.localization.descriptions.Other
        and G.localization.descriptions.Other[modifier.key]

    local tooltip_title = (loc_data and loc_data.name) or modifier.name or modifier.key or "Unknown"
    local tooltip_text = (loc_data and loc_data.text) or {"Unknown modifier"}
    local tooltip_vars = (modifier.loc_vars and modifier.loc_vars(modifier)) or { vars = {} }

    local icon_node = {
        n = G.UIT.O,
        config = {
            object = Sprite(0, 0, 1, 1, G.ASSET_ATLAS[modifier.atlas], modifier.pos),
            hover = true,
            can_collide = true,
            bloons_modifier_tooltip = {
                key = modifier.key,
                set = "Other",
                name = tooltip_title,
                title = tooltip_title,
                text = tooltip_text,
                vars = tooltip_vars,
                color = modifier.badge_colour or modifier.colour or G.C.WHITE,
                colour = modifier.badge_colour or modifier.colour or G.C.WHITE,
                in_blind = false
            }
        }
    }

    return {
        n = G.UIT.C,
        config = { align = 'cm', minw = 0.78, minh = 0.78, padding = 0.005, colour = G.C.CLEAR },
        nodes = {
            {
                n = G.UIT.C,
                config = {
                    align = 'cm',
                    minw = 0.66,
                    minh = 0.66,
                    padding = 0.01,
                    r = 0.05,
                    colour = G.C.CLEAR
                },
                nodes = { icon_node }
            }
        }
    }
end

local function create_UIBox_blind_modifiers()
    local modifiers = get_sorted_modifiers()
    local nodes = {}
    local cols = 3
    local row_nodes = {}

    for i = 1, math.min(3, #modifiers) do
        row_nodes[#row_nodes + 1] = make_modifier_cell(modifiers[i])
    end

    while #row_nodes < cols do
        row_nodes[#row_nodes + 1] = {
            n = G.UIT.C,
            config = { align = 'cm', minw = 0.78, minh = 0.78, padding = 0.005, colour = G.C.CLEAR },
            nodes = {}
        }
    end

    nodes[#nodes + 1] = {
        n = G.UIT.R,
        config = { align = 'cm', padding = 0.005, colour = G.C.CLEAR },
        nodes = row_nodes
    }

    -- match row to icon footprint + a little extra
    local CELL_W, CELL_H = 0.78, 0.78
    local CELL_GAP = 0.005
    local EXTRA_W, EXTRA_H = 1, 0.5
    local used_cols = cols
    local used_rows = 1

    local row_w = (used_cols * CELL_W) + ((used_cols - 1) * CELL_GAP) + EXTRA_W
    local row_h = (used_rows * CELL_H) + ((used_rows - 1) * CELL_GAP) + EXTRA_H

    return create_UIBox_generic_options({
        back_func = 'your_collection_other_gameobjects',
        contents = {
            {
                n = G.UIT.C,
                config = { align = 'cm', minw = row_w, minh = row_h, padding = 0.03, r = 0.08, colour = G.C.BLACK },
                nodes = nodes
            }
        }
    })
end

G.FUNCS.your_collection_blind_modifiers = function()
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu {
        definition = create_UIBox_blind_modifiers()
    }
end

SMODS.current_mod.custom_collection_tabs = function()
    return { create_bloonlatro_collection_button(), }
end