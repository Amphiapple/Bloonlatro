Bloonlatro = Bloonlatro or {}
Bloonlatro.main_menu_context = Bloonlatro.main_menu_context or nil
Bloonlatro.selected_boss_key = Bloonlatro.selected_boss_key or nil

-------------------------------------------------------
-- INIT
-------------------------------------------------------

SMODS.Atlas {
    key = 'bloons_logo',
    path = 'logos.png',
    px = 71,
    py = 95
}

SMODS.Sound({ key = "pop01", path = "pop01.ogg" })
SMODS.Sound({ key = "pop02", path = "pop02.ogg" })
SMODS.Sound({ key = "pop03", path = "pop03.ogg" })
SMODS.Sound({ key = "pop04", path = "pop04.ogg" })

local CONTEXT_TIMINGS = {
    splash = {
        logo_delay = 1.8,
        logo_duration = 2.3,
        boss_delay = 4.05
    },
    game = {
        logo_delay = 2,
        logo_duration = 0.9,
        boss_delay = 3
    },
    default = {
        logo_delay = 0.5,
        logo_duration = 0.9,
        boss_delay = 1.5
    }
}

local function get_context_timing(key)
    local context = Bloonlatro.main_menu_context
    local timings = CONTEXT_TIMINGS[context] or CONTEXT_TIMINGS.default
    return timings[key]
end

-------------------------------------------------------
-- HELPERS
-------------------------------------------------------

local function create_sprite_card(args)
    local card = Card(
        args.x or 0,
        args.y or 0,
        args.w or 1,
        args.h or 1,
        G.P_CARDS.empty,
        G.P_CENTERS.c_base
    )

    card.no_ui = args.no_ui or false
    card.no_shadow = args.no_shadow or false

    card.children.center:remove()

    card.children.center = SMODS.create_sprite(
        card.T.x,
        card.T.y,
        card.T.w,
        card.T.h,
        args.atlas,
        args.pos or { x = 0, y = 0 }
    )

    card.children.center:set_role({
        major = card,
        role_type = 'Glued',
        draw_major = card
    })

    return card
end

local function next_bloon_state(state, max_pos)
    local map = {
        [7] = math.random(5, 6),
        [6] = 4,
        [0] = max_pos
    }

    return map[state] or (state - 1)
end

local function get_bloonlatro_bosses()
    local t = {}

    for _, v in pairs(G.P_BLINDS) do
        if v.boss and v.boss.showdown and v.bloonlatro_boss then
            t[#t + 1] = v
        end
    end

    table.sort(t, function(a, b)
        return (a.bloonlatro_boss.index or 0)
            < (b.bloonlatro_boss.index or 0)
    end)

    return t
end

local function get_boss_family(blind, all_blinds)
    if not blind then
        return {}
    end

    local parts = blind.bloonlatro_boss.parts

    if not parts or not parts.main then
        return { blind }
    end

    local family = {}

    for _, b in ipairs(all_blinds) do
        local p = b.bloonlatro_boss.parts

        if p and p.main == parts.main then
            table.insert(family, b)
        end
    end

    table.sort(family, function(a, b)
        return (a.bloonlatro_boss.parts.order or 0)
            < (b.bloonlatro_boss.parts.order or 0)
    end)

    return family
end

local function ensure_selected_boss()
    local all_blinds = get_bloonlatro_bosses()

    if #all_blinds == 0 then
        return nil, nil
    end

    local selected

    if Bloonlatro.selected_boss_key then
        selected = G.P_BLINDS[Bloonlatro.selected_boss_key]
    end

    if not selected then
        selected = all_blinds[1]
        Bloonlatro.selected_boss_key = selected.key
    end

    local segments = get_boss_family(selected, all_blinds)

    return selected, segments
end

-------------------------------------------------------
-- MAIN MENU
-------------------------------------------------------

function Bloonlatro.main_menu()
    local MAX_LOGO_POS_X = 8

    create_bloonlatro_logo(MAX_LOGO_POS_X)

    local card = create_bloonlatro_boss_button('main_menu')

    local ui = UIBox {
        definition = {
            n = G.UIT.ROOT,
            config = {
                align = "cm",
                colour = G.C.CLEAR
            },
            nodes = {
                {
                    n = G.UIT.O,
                    config = { object = card }
                }
            }
        },
        config = {
            align = "cri",
            offset = { x = 10, y = -3.3 },
            major = G.ROOM_ATTACH,
            bond = "Weak"
        }
    }

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = get_context_timing("boss_delay"),
        blockable = false,
        blocking = false,
        func = function()
            if ui and ui.alignment then
                ui.alignment.offset.x = 0
                ui:align_to_major()
            end

            return true
        end
    }))
end

local old_main_menu = Game.main_menu
function Game:main_menu(change_context)
    Bloonlatro.main_menu_context = change_context
    return old_main_menu(self, change_context)
end

-------------------------------------------------------
-- LOGO
-------------------------------------------------------

function create_bloonlatro_logo(pos_x)
    if not G.title_top or not G.title_top.cards or not G.title_top.cards[1] then
        return
    end

    G.title_top.max_pos_x = G.title_top.max_pos_x or pos_x
    G.title_top.cards[1]:remove()

    local card = create_sprite_card({
        w = G.CARD_W * 1.4,
        h = G.CARD_H * 1.4,
        atlas = G.ASSET_ATLAS["bloons_logo"],
        pos = { x = pos_x, y = 0 },
        no_ui = true
    })

    card:set_alignment({
        major = G.title_top,
        type = 'cm',
        bond = 'Strong',
        offset = { x = 0, y = 0 }
    })

    card.dissolve_colours = { G.C.WHITE, G.C.WHITE }
    card.dissolve = 1

    function card:click()
        local num = math.random(1, 4)

        play_sound('bloons_pop0' .. num)

        G.E_MANAGER:add_event(Event({
            delay = 0.1,
            func = function()
                pos_x = next_bloon_state(pos_x, G.title_top.max_pos_x)

                card.children.center:set_sprite_pos({
                    x = pos_x,
                    y = 0
                })

                return true
            end
        }))
    end

    G.title_top:emplace(card)

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = get_context_timing("logo_delay"),
        blockable = false,
        blocking = false,
        func = function()
            ease_value(
                card,
                'dissolve',
                -1,
                nil,
                nil,
                nil,
                get_context_timing("logo_duration")
            )

            return true
        end
    }))
end

-------------------------------------------------------
-- BOSS BUTTON
-------------------------------------------------------

function create_bloonlatro_boss_button(origin, from_game_over)
    local boss_icon_y

    local boss_blind
    if origin == 'uidef' and G.GAME and G.GAME.selected_back and type(G.GAME.selected_back.get_boss_blind) == 'function' then
        boss_blind = G.GAME.selected_back:get_boss_blind()
    end

    if boss_blind and boss_blind.pos_y then
        boss_icon_y = boss_blind.pos_y
    else
        local selected = ensure_selected_boss()
        if selected and selected.pos and selected.pos.y then
            boss_icon_y = selected.pos.y
        else
            boss_icon_y = math.random(5, 11)
        end
    end

    local card = create_sprite_card({
        w = 1.8,
        h = 1.8,
        atlas = G.ANIMATION_ATLAS["bloons_Blind"],
        pos = { x = 0, y = boss_icon_y },
        no_ui = true
    })

    function card:click()
        ensure_selected_boss()
        G.FUNCS.create_bloonlatro_boss_ui(origin, from_game_over)
    end

    return card
end

-------------------------------------------------------
-- BOSS CARD
-------------------------------------------------------

function create_bloonlatro_boss_card(blind)
    if not blind then
        return nil
    end

    local card = create_sprite_card({
        w = 1.3,
        h = 1.3,
        atlas = G.ANIMATION_ATLAS[blind.atlas],
        pos = { x = 0, y = blind.pos.y }
    })

    function card:align_h_popup()
        return {
            major = self,
            parent = self,
            xy_bond = 'Strong',
            r_bond = 'Weak',
            wh_bond = 'Weak',
            offset = { x = 0.1, y = 0 },
            type = 'cr',
        }
    end

    function card:hover()
        if self.facing ~= 'front' or self.no_ui or G.debug_tooltip_toggle then
            return
        end

        self:juice_up(0.05, 0.03)

        play_sound(
            'paper1',
            math.random() * 0.2 + 0.9,
            0.35
        )

        self.config.h_popup = UIBox {
            definition = create_UIBox_blind_popup(blind, true),
            config = {
                instance_type = 'POPUP',
                parent = self,
                align = 'cr',
            }
        }

        self.children.h_popup = self.config.h_popup
    end

    return card
end

-------------------------------------------------------
-- BOSS UI
-------------------------------------------------------

local function build_cards_container(segments)
    local card_nodes = {}

    for _, b in ipairs(segments or {}) do
        card_nodes[#card_nodes + 1] = {
            n = G.UIT.O,
            config = {
                object = create_bloonlatro_boss_card(b)
            }
        }
    end

    return {
        n = G.UIT.R,
        config = {
            id = "bloonlatro_boss_cards_container",
            align = "cm",
            padding = 0.3,
            minw = 10
        },
        nodes = card_nodes
    }
end

local function build_view()
    local selected, segments = ensure_selected_boss()

    if not selected then
        return nil
    end

    return {
        n = G.UIT.R,
        config = {
            align = "cm",
            padding = 0.4,
            minw = 12,
        },
        nodes = {
            {
                n = G.UIT.R,
                config = {
                    align = "cm",
                    padding = 0.2
                },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            id = "bloonlatro_boss_name",
                            text = selected.bloonlatro_boss.title,
                            scale = 0.9,
                            colour = selected.boss_colour or G.C.WHITE,
                            shadow = true,
                            align = "cm"
                        }
                    }
                }
            },
            build_cards_container(segments)
        }
    }
end

local function build_list()
    local blinds = get_bloonlatro_bosses()
    local filtered_blinds = {}

    for _, blind in ipairs(blinds) do
        if not blind.bloonlatro_boss.parts
            or blind.bloonlatro_boss.parts.segment == "head"
        then
            table.insert(filtered_blinds, blind)
        end
    end

    local row = {
        n = G.UIT.R,
        config = {
            align = "cm",
            padding = 0.1
        },
        nodes = {}
    }

    for _, b in ipairs(filtered_blinds) do
        local card = create_sprite_card({
            w = 1,
            h = 1,
            atlas = G.ANIMATION_ATLAS[b.atlas],
            pos = { x = 0, y = b.pos.y },
            no_ui = true,
            no_shadow = true
        })

        function card:click()
            Bloonlatro.selected_boss_key = b.key
            G.FUNCS.update_bloonlatro_boss_ui()
        end

        row.nodes[#row.nodes + 1] = {
            n = G.UIT.O,
            config = {
                object = card
            }
        }
    end

    return row
end

G.FUNCS.create_bloonlatro_boss_ui = function(origin, from_game_over)
    local back_func = origin == 'uidef' and 'setup_run' or 'exit_overlay_menu'
    local back_id = origin == 'uidef' and (from_game_over and 'from_game_over' or nil) or nil

    local selected = ensure_selected_boss()

    if not selected then
        return
    end

    if G.OVERLAY_MENU then
        G.OVERLAY_MENU:remove()
        G.OVERLAY_MENU = nil
    end

    local contents = {
        {
            n = G.UIT.C,
            config = {
                align = "cm",
                padding = 0.8,
                r = 0.15,
                colour = G.C.BLACK,
                minw = 14,
                minh = 8,
                maxw = 16,
                border = 0.08,
                border_colour = G.C.RED
            },
            nodes = {
                {
                    n = G.UIT.C,
                    config = {
                        align = "cm",
                        padding = 0.4,
                        minw = 12
                    },
                    nodes = {
                        build_view(),
                        {
                            n = G.UIT.R,
                            config = {
                                align = "cm",
                                padding = 0.3
                            },
                            nodes = {
                                UIBox_button({
                                    label = { "Start Run" },
                                    button = "bloonlatro_start_boss_run",
                                    colour = G.C.GREEN,
                                    minw = 6,
                                    minh = 0.9
                                })
                            }
                        },
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
                colour = G.C.UI.TRANSPARENT_DARK,
            },
            nodes = {
                create_UIBox_generic_options({
                    contents = contents,
                    back_func = back_func,
                    back_id = back_id,
                    emboss = 0.05
                })
            }
        },
        config = {
            align = "cm",
            major = G.ROOM_ATTACH,
            instance_type = "POPUP",
            offset = { x = 0, y = 15 },
            bond = 'Weak',
        }
    }

    G.OVERLAY_MENU = ui

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            if ui and ui.alignment then
                ui.alignment.offset.y = 0
            end

            return true
        end
    }))

    return ui
end

G.FUNCS.update_bloonlatro_boss_ui = function()
    if not G.OVERLAY_MENU then
        return
    end

    local selected, segments = ensure_selected_boss()

    if not selected then
        return
    end

    local name_e = G.OVERLAY_MENU:get_UIE_by_ID("bloonlatro_boss_name")

    if name_e then
        name_e.config.text = selected.bloonlatro_boss.title
        name_e.config.colour = selected.boss_colour or G.C.WHITE
        name_e:update_text()
    end

    local cards_container =
        G.OVERLAY_MENU:get_UIE_by_ID("bloonlatro_boss_cards_container")

    if cards_container then
        for i = #cards_container.children, 1, -1 do
            cards_container.children[i]:remove()
            cards_container.children[i] = nil
        end

        for _, b in ipairs(segments or {}) do
            G.OVERLAY_MENU:add_child({
                n = G.UIT.O,
                config = {
                    object = create_bloonlatro_boss_card(b),
                    align = "cm"
                }
            }, cards_container)
        end

        G.OVERLAY_MENU:recalculate()
    end
end

-------------------------------------------------------
-- START RUN
-------------------------------------------------------

G.FUNCS.bloonlatro_start_boss_run = function()
    local selected = G.P_BLINDS[Bloonlatro.selected_boss_key]

    if not selected then
        return
    end

    local boss_bans = {
        { id = 'j_luchador' },
        { id = 'j_chicot' },
        { id = 'j_mr_bones' },
        { id = 'j_bloons_bomb_blitz' },
        { id = 'j_bloons_cripple_moab' },
        { id = 'j_bloons_herald_of_everfrost' },
        { id = 'tag_bloons_sabotage' },
        { id = 'v_bloons_big_bloon_sabotage' },
        { id = 'v_bloons_big_bloon_blueprints' },
    }

    local challenge_params = selected.bloonlatro_boss.challenge_params or {}

    if challenge_params.banned_ids then
        for _, ban in ipairs(challenge_params.banned_ids) do
            table.insert(boss_bans, ban)
        end
    end

    local args = {
        challenge = {
            deck = { type = "Boss Challenge Deck" },
        },
    }

    local deck = G.P_CENTERS["b_bloons_boss_challenge"]
    local params = {
        boss_challenge = selected.key,
        vouchers = challenge_params.vouchers or {},
        win_ante = challenge_params.win_ante or 8,
        banned_keys = boss_bans
    }

    deck:set_params(params)
    G.FUNCS.start_run(nil, args)
end

local old_start_run = Game.start_run
function Game:start_run(args)
    local res = old_start_run(self, args)
    if args.win_ante then G.GAME.win_ante = args.win_ante end

    local deck = G.GAME.selected_back
    local config = deck and deck.effect and deck.effect.center and deck.effect.center.config

    local win_ante = config and config.extra and config.extra.win_ante
    if win_ante then G.GAME.win_ante = win_ante end

    local banned_keys = config and config.extra and config.extra.banned_keys
    if banned_keys then
        for _, v in ipairs(banned_keys) do
            G.GAME.banned_keys[v.id] = true
            if v.ids then
                for _, vv in ipairs(v.ids) do
                    G.GAME.banned_keys[vv] = true
                end
            end
        end
    end

    return res
end

local old_back_load = Back.load
function Back:load(args)
    local res = old_back_load(self, args)

    if self.effect and self.effect.center and self.effect.center.load_params then
        self.effect.center:load_params()
    end

    return res
end

function G.UIDEF.boss_challenge(from_game_over)
    local saved_params = G.SETTINGS and G.SETTINGS.boss_challenge_params or nil
    if not Bloonlatro.selected_boss_key and saved_params and saved_params.boss_challenge then
        Bloonlatro.selected_boss_key = saved_params.boss_challenge
    end

    local selected = ensure_selected_boss()
    if not selected then
        return {
            n = G.UIT.ROOT,
            config = { align = "cm", padding = 0.1, colour = G.C.CLEAR, minh = 6, minw = 7 },
            nodes = {
                {
                    n = G.UIT.R,
                    config = { align = "cm", padding = 0.2 },
                    nodes = {
                        { n = G.UIT.T, config = { text = "No Bloonlatro boss blinds available", scale = 0.4, colour = G.C.WHITE, shadow = true } }
                    }
                }
            }
        }
    end

    local boss_button = create_bloonlatro_boss_button('uidef', from_game_over)

    return {
        n = G.UIT.ROOT,
        config = { align = "cm", padding = 0.1, colour = G.C.CLEAR, minh = 8, minw = 9 },
        nodes = {
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.1, r = 0.1, colour = G.C.BLACK, emboss = 0.05 },
                nodes = {
                    {
                        n = G.UIT.R,
                        config = { align = "cm", padding = 0.2 },
                        nodes = {
                            { n = G.UIT.T, config = { text = "Selected boss", scale = 0.3, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
                        }
                    },
                    {
                        n = G.UIT.R,
                        config = { align = "cm", padding = 0.2 },
                        nodes = {
                            { n = G.UIT.O, config = { object = boss_button, align = "cm" } },
                        }
                    },
                }
            }
        }
    }
end
