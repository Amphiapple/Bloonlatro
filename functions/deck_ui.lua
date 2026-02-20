SMODS.Atlas {
    key = 'deck_icons',
    path = 'deck_icons.png',
    px = 71,
    py = 95,
}

function generate_corvus_ui()
    local ui = UIBox{
        definition = {
            n = G.UIT.R,
            config = {
                colour = G.C.CLEAR,
            },
            nodes = {
                {
                    n = G.UIT.C,
                    config = {
                        align = "cr",
                        padding = 0.1,
                        r = 0.1,
                        minw = 2.5,
                        minh = 1.2,
                        colour = G.C.CLEAR,
                    },
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = {
                                colour = G.C.PURPLE,
                                padding = 0.1,
                                r = 0.1,
                                minw = 2.3,
                                minh = 1.0,
                                shadow = true,
                                hover = false,
                                emboss = 0.05,
                                align = "cm"
                            },
                            nodes = {
                                {
                                    n = G.UIT.C,
                                    config = {
                                        align = "cm",
                                        padding = 0.05,
                                        minw = 0,
                                        minh = 0,
                                        colour = G.C.CLEAR
                                    },
                                    nodes = {
                                        {
                                            n = G.UIT.O,
                                            config = {
                                                object = Sprite(0, 0, 0.71, 0.95, G.ASSET_ATLAS["bloons_deck_icons"], { x = 0, y = 0 }),
                                            }
                                        },
                                        {
                                            n = G.UIT.C,
                                            config = {
                                                minw = 0.18,
                                                minh = 0,
                                                colour = G.C.CLEAR
                                            }
                                        },
                                        {
                                            n = G.UIT.T,
                                            config = {
                                                ref_table = G.GAME.corvus_mana,
                                                ref_value = "current_mana",
                                                scale = 0.5,
                                                colour = G.C.WHITE,
                                                shadow = true,
                                                align = "cm"
                                            }
                                        },
                                        {
                                            n = G.UIT.T,
                                            config = {
                                                text = "/",
                                                scale = 0.5,
                                                colour = G.C.WHITE,
                                                shadow = true,
                                                align = "cm"
                                            }
                                        },
                                        {
                                            n = G.UIT.T,
                                            config = {
                                                ref_table = G.GAME.corvus_mana,
                                                ref_value = "max_mana",
                                                scale = 0.5,
                                                colour = G.C.WHITE,
                                                shadow = true,
                                                align = "cm"
                                            }
                                        },
                                    }
                                }
                            }
                        }
                    }
                }
            }
        },
        config = {
            major = G.ROOM,
            bond = 'Weak',
        }
    }

    if ui and ui.T and G.ROOM and G.ROOM.T then
        local x_offset = 1.5
        local y_offset = 0.8
        ui.T.x = (G.ROOM.T.x or 0) + (G.ROOM.T.w or 0) - (ui.T.w or 0) - x_offset
        ui.T.y = (G.ROOM.T.y or 0) + ((G.ROOM.T.h or 0) - (ui.T.h or 0)) / 2 - y_offset
        ui.VT.x, ui.VT.y = ui.T.x, ui.T.y
        if ui.initialize_VT then ui:initialize_VT() end
    end

    return ui
end

local start_run_ref = Game.start_run
function Game:start_run(args)
    local result = start_run_ref(self, args)

    if G.GAME and G.GAME.selected_back and G.GAME.selected_back.name == "Corvus Deck" then
        generate_corvus_ui()
    end

    return result
end