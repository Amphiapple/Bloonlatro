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

function generate_rosalia_ui()
    if not G.GAME then return nil end

    local weapons = {
        laser   = { icon_x = 2, colour = G.C.ORANGE },
        grenade = { icon_x = 1, colour = G.C.BLUE }
    }

    G.GAME.rosalia_weapon = (G.GAME.rosalia_weapon == "grenade") and "grenade" or "laser"

    G.FUNCS = G.FUNCS or {}
    G.FUNCS.bloonlatro_toggle_rosalia_weapon = function(e)
        if not G.GAME then return end
        G.GAME.rosalia_weapon = (G.GAME.rosalia_weapon == "laser") and "grenade" or "laser"

        local d = weapons[G.GAME.rosalia_weapon]
        if G.GAME.rosalia_weapon_icon and G.GAME.rosalia_weapon_icon.set_sprite_pos then
            G.GAME.rosalia_weapon_icon:set_sprite_pos({ x = d.icon_x, y = 0 })
        end
        if G.GAME.rosalia_weapon_button_cfg then
            G.GAME.rosalia_weapon_button_cfg.colour = d.colour
        end
    end

    local data = weapons[G.GAME.rosalia_weapon]
    local icon = Sprite(0, 0, 0.92, 1.2, G.ASSET_ATLAS["bloons_deck_icons"], { x = data.icon_x, y = 0 })

    local button_cfg = {
        colour = data.colour,
        padding = 0.12,
        r = 0.1,
        minw = 1.2,
        minh = 1.2,
        shadow = true,
        hover = true,
        emboss = 0.05,
        align = "cm",
        button = "bloonlatro_toggle_rosalia_weapon"
    }

    local ui = UIBox{
        definition = {
            n = G.UIT.ROOT,
            config = { align = "cm", colour = G.C.CLEAR, padding = 0, minw = 0, minh = 0 },
            nodes = {
                {
                    n = G.UIT.C,
                    config = { align = "cm", padding = 0.1, r = 0.1, minw = 1.2, minh = 1.2, colour = G.C.CLEAR },
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = button_cfg,
                            nodes = {
                                {
                                    n = G.UIT.C,
                                    config = { align = "cm", padding = 0.05, minw = 0, minh = 0, colour = G.C.CLEAR },
                                    nodes = {
                                        { n = G.UIT.O, config = { object = icon } }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        },
        config = { align = "cri", offset = { x = 0, y = 0 }, major = G.ROOM_ATTACH, bond = "Weak" }
    }

    G.GAME.rosalia_weapon_icon = icon
    G.GAME.rosalia_weapon_button_cfg = button_cfg
    return ui
end

local start_run_ref = Game.start_run
function Game:start_run(args)
    local result = start_run_ref(self, args)

    local deck = G.GAME and G.GAME.selected_back
    local deck_key = deck and deck.effect and deck.effect.center and deck.effect.center.original_key

    if deck_key == 'corvus' then
        generate_corvus_ui()
    elseif deck_key == 'rosalia' then
        generate_rosalia_ui()
    end

    return result
end