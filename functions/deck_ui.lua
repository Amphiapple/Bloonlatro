SMODS.Atlas {
    key = 'deck_icons',
    path = 'deck_icons.png',
    px = 71,
    py = 95,
}

function generate_corvus_ui()
    local ui = UIBox{
        definition = {
            n = G.UIT.ROOT,
            config = {
                align = "cm",
                colour = G.C.CLEAR,
                padding = 0,
                minw = 0,
                minh = 0
            },
            nodes = {
                {
                    n = G.UIT.C,
                    config = {
                        align = "cm",
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
                                                minw = 0.1,
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
            align = 'cri',
            offset = {x = 0, y = 0},
            major = G.ROOM_ATTACH,
            bond = 'Weak'
        }
    }
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