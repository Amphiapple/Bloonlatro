SMODS.Atlas {
    key = "bloons_tutorial",
    path = "tutorial.png",
    px = 75,
    py = 75
}

----------------------------------------------------------
-- Tutorial Button
----------------------------------------------------------

function create_bloonlatro_tutorial_button()
    G.PROFILES[G.SETTINGS.profile].viewed_bloonlatro_tutorial =
        G.PROFILES[G.SETTINGS.profile].viewed_bloonlatro_tutorial or false

    -- TODO:
    -- Change sprite depending on viewed_bloonlatro_tutorial

    local card = create_sprite_card({
        w = 1.8,
        h = 1.8,
        atlas = G.ASSET_ATLAS["bloons_tutorial"],
        pos = { x = 0, y = 0 },
        no_ui = true
    })

    function card:click()
        G.PROFILES[G.SETTINGS.profile].viewed_bloonlatro_tutorial = true
        G.FUNCS.create_bloonlatro_tutorial_ui()
    end

    return card
end

----------------------------------------------------------
-- Title
----------------------------------------------------------

local function build_name()
    return {
        n = G.UIT.R,
        config = {
            align = "cm",
            padding = 0.02,
            minw = 16,
        },
        nodes = {
            {
                n = G.UIT.C,
                config = {
                    align = "cm",
                    padding = 0.15,
                    r = 0.08,
                    colour = G.C.GREY,
                    outline = 1.5,
                    outline_colour = G.C.GREEN,
                    minh = 0.75,
                    minw = 16,
                },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = G.localization.bloonlatro_tutorial.name,
                            scale = 0.9,
                            colour = G.C.WHITE
                        }
                    }
                }
            }
        }
    }
end

----------------------------------------------------------
-- Tab Buttons
----------------------------------------------------------

local function build_list()
    local tabs = G.localization.bloonlatro_tutorial.tabs

    local sorted_tabs = {}

    for id, tab in pairs(tabs) do
        table.insert(sorted_tabs, {
            id = id,
            name = tab.name,
            order = tab.order
        })
    end

    table.sort(sorted_tabs, function(a, b)
        return a.order < b.order
    end)

    local row = {
        n = G.UIT.R,
        config = {
            align = "cm",
            padding = 0.25,
        },
        nodes = {}
    }

    local width = 16 / #sorted_tabs

    for _, tab in ipairs(sorted_tabs) do
        local button = UIBox_button({
            label = { tab.name },
            ref_table = tab,
            button = "update_bloonlatro_tutorial_ui",
            colour = G.C.GREEN,
            minw = width,
            minh = 1,
            col = true
        })

        table.insert(row.nodes, button)
    end

    return row
end

----------------------------------------------------------
-- Tab Content
----------------------------------------------------------

G.FUNCS.create_bloonlatro_tab_tower_information = function()
    print("Creating Tower Information")
end

G.FUNCS.create_bloonlatro_tab_upgrade_system = function()
    print("Creating Upgrade System")
end

----------------------------------------------------------
-- Update Tab
----------------------------------------------------------

G.FUNCS.update_bloonlatro_tutorial_ui = function(e)
    local tab = type(e) == "table" and e.config and e.config.ref_table and e.config.ref_table.id or e

    local func = G.FUNCS["create_bloonlatro_tab_" .. tab]

    if not func then
        print("Tutorial tab '" .. tab .. "' does not exist.")
        return
    end

    func()
end

----------------------------------------------------------
-- Tutorial UI
----------------------------------------------------------

G.FUNCS.create_bloonlatro_tutorial_ui = function()
    if G.OVERLAY_MENU then
        G.OVERLAY_MENU:remove()
        G.OVERLAY_MENU = nil
    end

    local contents = {
        {
            n = G.UIT.C,
            config = {
                align = "cm",
                padding = 0.3,
                r = 0.15,
                colour = G.C.BLACK,
                border = 0.08,
                border_colour = G.C.RED
            },
            nodes = {
                {
                    n = G.UIT.C,
                    config = {
                        align = "cm",
                        padding = 0.1,
                        minw = 16
                    },
                    nodes = {
                        build_name(),
                        build_list()
                    }
                }
            }
        }
    }

    local ui = UIBox {
        definition = {
            n = G.UIT.ROOT,
            config = {
                align = "cm",
                colour = G.C.UI.TRANSPARENT_DARK
            },
            nodes = {
                create_UIBox_generic_options({
                    contents = contents,
                    back_button = "back",
                    snap_back = true,
                    emboss = 0.05
                })
            }
        },

        config = {
            align = "cm",
            major = G.ROOM_ATTACH,
            instance_type = "POPUP",
            offset = { x = 0, y = 15 },
            bond = "Weak"
        }
    }

    G.OVERLAY_MENU = ui

    G.E_MANAGER:add_event(Event({
        trigger = "immediate",
        func = function()
            if ui and ui.alignment then
                ui.alignment.offset.y = 0
            end

            return true
        end
    }))

    return ui
end
