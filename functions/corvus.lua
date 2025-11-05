SMODS.Atlas {
    key = 'Corvus',
    path = 'corvus.png',
    px = 71,
    py = 95,
}

function corvus_spellbook()
    local ui = UIBox{
        definition = {
            n = G.UIT.ROOT,
            config = {
                align = "cr",
                colour = G.C.CLEAR,
                padding = 0,
                minw = G.ROOM.T.w,
                minh = G.ROOM.T.h
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
                                colour = G.C.BLUE,
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
                                                object = Sprite(0, 0, 0.71, 0.95, G.ASSET_ATLAS["bloons_Corvus"], { x = 0, y = 4 }),
                                            }
                                        },
                                        {
                                            n = G.UIT.T,
                                            config = {
                                                ref_table = G.GAME,
                                                ref_value = "bloons_mana",
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
                                                ref_table = G.GAME,
                                                ref_value = "bloons_max_mana",
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
            bond = 'Weak'
        }
    }
    return ui
end

local start_run_old = Game.start_run
function Game:start_run(args)
    start_run_old(self, args)
    if G.GAME and G.GAME.selected_back and G.GAME.selected_back.name ~= "Corvus Deck" then return end
    G.GAME.bloons_mana = G.GAME.bloons_mana or 0
    G.GAME.bloons_max_mana = G.GAME.bloons_max_mana or 800
    corvus_spellbook()
end