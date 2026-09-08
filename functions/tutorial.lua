SMODS.Atlas {
    key = "bloons_tutorial",
    path = "tutorial.png",
    px = 34,
    py = 34
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
        w = Bloonlatro.MAIN_MENU_BUTTON_W,
        h = Bloonlatro.MAIN_MENU_BUTTON_H,
        atlas = G.ASSET_ATLAS["bloons_tutorial"],
        pos = { x = G.PROFILES[G.SETTINGS.profile].viewed_bloonlatro_tutorial and 0 or 1, y = 0 },
        no_ui = true
    })

    function card:click()
        G.PROFILES[G.SETTINGS.profile].viewed_bloonlatro_tutorial = true
        card.children.center:set_sprite_pos({ x = G.PROFILES[G.SETTINGS.profile].viewed_bloonlatro_tutorial and 0 or 1, y = 0 })
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

local function build_list(selected_tab)
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

local function build_info()
    return {
        n = G.UIT.R,
        config = {
            align = "cm",
            padding = 0.02,
            minw = 16,
            id = "bloonlatro_tutorial_info"
        },
        nodes = {}
    }
end

----------------------------------------------------------
-- Tab Content
----------------------------------------------------------

G.FUNCS.create_bloonlatro_tab_tower_information = function()
    local dart_monkey = Card(
        0,
        0,
        G.CARD_W,
        G.CARD_H,
        G.P_CARDS.empty,
        G.P_CENTERS['j_bloons_dart_monkey']
    )

    dart_monkey.ability_UIBox_table = dart_monkey:generate_UIBox_ability_table()

    local popup_definition = G.UIDEF.card_h_popup(dart_monkey)

    local popup = UIBox {
        definition = popup_definition,
        config = {
            offset = { x = 0, y = 0 }
        }
    }

    dart_monkey:remove()

    local desc_nodes = {
        {
            n = G.UIT.R,
            config = {
                align = "cm",
                padding = 0.05
            },
            nodes = {
                {
                    n = G.UIT.T,
                    config = {
                        text = G.localization.bloonlatro_tutorial.tabs.tower_information.name,
                        scale = 1,
                        colour = G.C.UI.TEXT_DARK,
                        shadow = false
                    }
                },
                {
                    n = G.UIT.R,
                    config = {
                        align = "cm",
                        minh = 0.3
                    },
                }
            }
        }
    }
    local loc_desc = G.localization.bloonlatro_tutorial.tabs.tower_information.description or nil
    if loc_desc and type(loc_desc) == "table" and #loc_desc > 0 then
        for i, desc_text in ipairs(loc_desc) do
            desc_nodes[#desc_nodes + 1] = {
                n = G.UIT.R,
                config = {
                    align = "cl",
                    padding = 0.03,
                    maxw = 16
                },
                nodes = SMODS.localize_box(
                    loc_parse_string(desc_text),
                    { scale = 1.2, text_colour = G.C.UI.TEXT_DARK, vars = { colours = {} } }
                ),
            }
        end
    else
        desc_nodes[#desc_nodes + 1] = {
            n = G.UIT.R,
            config = { align = "cm", padding = 0.03 },
            nodes = {
                {
                    n = G.UIT.O,
                    config = {
                        object = DynaText({
                            string = { "None" },
                            colours = { G.C.UI.TEXT_INACTIVE },
                            scale = 0.4,
                            maxw = 16,
                        })
                    }
                }
            }
        }
    end

    return {
        n = G.UIT.C,
        config = {
            align = "cm",
            padding = 0.12,
            r = 0.1,
            colour = G.C.WHITE,
            minw = 16
        },
        nodes = {
            {
                n = G.UIT.R,
                config = {
                    align = "cm",
                    padding = 0.05
                },
                nodes = {
                    {
                        n = G.UIT.C,
                        config = {
                            align = "cm",
                            minw = 3.75
                        },
                        nodes = {
                            {
                                n = G.UIT.O,
                                config = {
                                    object = popup
                                }
                            }
                        }
                    },
                    {
                        n = G.UIT.C,
                        config = {
                            align = "lm",
                            padding = 0.03,
                            minw = 10.5
                        },
                        nodes = desc_nodes
                    }
                }
            }
        }
    }
end

G.FUNCS.create_bloonlatro_tab_upgrade_system = function()
    return {
        n = G.UIT.C,
        config = {
            align = "cm",
            padding = 0.12,
            r = 0.1,
            colour = G.C.WHITE,
            minw = 16,
            minh = 4
        },
        nodes = {
            {
                n = G.UIT.T,
                config = {
                    text = "Coming Soon!",
                    scale = 1.5,
                    colour = G.C.UI.TEXT_DARK,
                    shadow = false
                }
            }
        }
    }
end

local function set_bloonlatro_tutorial_info(tab)
    local selected_tab = tab or "tower_information"

    local info_e = G.OVERLAY_MENU and G.OVERLAY_MENU:get_UIE_by_ID("bloonlatro_tutorial_info")
    if not info_e or not info_e.children then
        return
    end

    for i = #info_e.children, 1, -1 do
        local child = info_e.children[i]
        table.remove(info_e.children, i)
        child:remove()
    end

    local func = G.FUNCS["create_bloonlatro_tab_" .. selected_tab]
    if not func then
        print("Tutorial tab '" .. selected_tab .. "' does not exist.")
        return
    end

    local content = func()
    if content then
        G.OVERLAY_MENU:add_child(content, info_e)
    end
end

----------------------------------------------------------
-- Update Tab
----------------------------------------------------------

G.FUNCS.update_bloonlatro_tutorial_ui = function(e)
    local tab = type(e) == "table" and e.config and e.config.ref_table and e.config.ref_table.id or e
    if not tab then
        return
    end

    if not G.OVERLAY_MENU then
        return
    end

    local func = G.FUNCS["create_bloonlatro_tab_" .. tab]
    if not func then
        print("Tutorial tab '" .. tab .. "' does not exist.")
        return
    end

    set_bloonlatro_tutorial_info(tab)
end

----------------------------------------------------------
-- Tutorial UI
----------------------------------------------------------

G.FUNCS.create_bloonlatro_tutorial_ui = function(selected_tab)
    if G.OVERLAY_MENU then
        G.OVERLAY_MENU:remove()
        G.OVERLAY_MENU = nil
    end

    local active_tab = selected_tab or "tower_information"

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
                        build_list(active_tab),
                        build_info()
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
    set_bloonlatro_tutorial_info(active_tab)

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
