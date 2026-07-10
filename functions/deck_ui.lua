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

function generate_psi_ui()
    if not G.GAME or not G.GAME.selected_back or G.GAME.selected_back.name ~= "Psi Deck" then return nil end
    local cards = G.GAME.selected_back.effect.center:get_next_cards()

    local card_scale = 0.7

    local psi_cardarea = CardArea(0, 0, 2.3, 1.2, {
        type = "title_2",
        card_limit = #cards,
        highlight_limit = 0,
        card_w = G.CARD_W * card_scale
    })

    G.GAME.psi_cards = {}

    for _, card in ipairs(cards) do
        local psi_card = copy_card(card, nil, card_scale, nil, nil)

        psi_cardarea:emplace(psi_card)
        if G.GAME.round == 0 then psi_card:flip() end

        G.GAME.psi_cards[#G.GAME.psi_cards+1] = psi_card
    end

    local ui = UIBox{
       definition = {
            n = G.UIT.ROOT,
            config = {
                align = "cm",
                colour = G.C.CLEAR
            },
            nodes = {
                {
                    n = G.UIT.C,
                    config = { align = "cm" },
                    nodes = {
                        { n = G.UIT.O, config = { object = psi_cardarea } }
                    }
                }
            }
        },
        config = {
            align = 'cri',
            offset = {x = -0.3, y = 1.9},
            major = G.ROOM_ATTACH,
            bond = 'Weak'
        }
    }
    return ui
end

G.FUNCS.update_psi_ui = function(cards)
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            for i=1, #cards do
                if G.GAME.psi_cards[i].facing == "front" then
                    G.GAME.psi_cards[i]:flip()
                end
            end
            return true
        end
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.5,
        func = function()
            for i, card in ipairs(cards) do
                copy_card(card, G.GAME.psi_cards[i])
                G.GAME.psi_cards[i].children.back:set_sprite_pos(G.GAME.selected_back.pos)
            end
            return true
        end
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.5,
        func = function()
            for i=1, #cards do
                if G.GAME.psi_cards[i].facing == "back" then
                    G.GAME.psi_cards[i]:flip()
                end
            end
            return true
        end
    }))
end

local start_run_ref = Game.start_run
function Game:start_run(args)
    local result = start_run_ref(self, args)

    local deck = G.GAME and G.GAME.selected_back
    local deck_key = deck and deck.effect and deck.effect.center and deck.effect.center.key

    if deck_key == 'b_bloons_corvus' then
        generate_corvus_ui()
    elseif deck_key == 'b_bloons_rosalia' then
        generate_rosalia_ui()
    elseif deck_key == 'b_bloons_psi' then
        generate_psi_ui()
    end

    return result
end
