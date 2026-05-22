Bloonlatro = Bloonlatro or {}
Bloonlatro.boss_selected_index = Bloonlatro.boss_selected_index or 1
Bloonlatro.main_menu_context = Bloonlatro.main_menu_context or nil
Bloonlatro.boss_challenge = Bloonlatro.boss_challenge or nil
Bloonlatro.reset_boss_challenge = true

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

-------------------------------------------------------
-- HELPERS
-------------------------------------------------------

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

-------------------------------------------------------
-- MAIN MENU
-------------------------------------------------------

function Bloonlatro.main_menu()
    local MAX_LOGO_POS_X = 8

    create_bloonlatro_logo(MAX_LOGO_POS_X)
    create_bloonlatro_boss_button()
end

local old_main_menu = Game.main_menu

function Game:main_menu(change_context)
    Bloonlatro.main_menu_context = change_context
    return old_main_menu(self, change_context)
end

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

function create_bloonlatro_boss_button()
    local pos_y = math.random(5, 11)

    local card = create_sprite_card({
        w = 1.8,
        h = 1.8,
        atlas = G.ANIMATION_ATLAS["bloons_Blind"],
        pos = { x = 0, y = pos_y },
        no_ui = true
    })

    function card:click()
        G.FUNCS.create_bloonlatro_boss_ui()
    end

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

    return ui
end

-------------------------------------------------------
-- BOSS DATA
-------------------------------------------------------

local function get_bloonlatro_view_data()
    local all_blinds = get_bloonlatro_bosses()
    local selected = all_blinds[Bloonlatro.boss_selected_index]

    if not selected then
        return nil
    end

    local segments = get_boss_family(selected, all_blinds)

    return selected, segments
end

function Bloonlatro.get_boss_challenge_blind(index)
    local challenge = Bloonlatro.boss_challenge

    if not challenge then
        return nil
    end

    if challenge[index] then
        return challenge[index]
    end

    if index == 3 then
        return challenge[1]
    end

    return nil
end

local function resolve_boss_blind_by_key(key)
    if not key then
        return nil
    end

    if G.P_BLINDS[key] then
        return G.P_BLINDS[key]
    end

    for _, blind in pairs(G.P_BLINDS) do
        if blind.key == key then
            return blind
        end
    end

    return nil
end

local function boss_challenge_to_keys(challenge)
    local keys = {}

    if type(challenge) ~= 'table' then
        return keys
    end

    for _, entry in ipairs(challenge) do
        local key = type(entry) == 'table' and entry.key or entry

        if type(key) == 'string' then
            keys[#keys + 1] = key
        end
    end

    return keys
end

local function boss_challenge_from_keys(keys)
    local challenge = {}

    if type(keys) ~= 'table' then
        return challenge
    end

    for _, key in ipairs(keys) do
        local blind = resolve_boss_blind_by_key(key)

        if blind then
            challenge[#challenge + 1] = blind
        end
    end

    return challenge
end

function get_bloonlatro_boss_card_nodes()
    local nodes = {}

    if Bloonlatro.boss_challenge then
        for _, blind in ipairs(Bloonlatro.boss_challenge) do
            nodes[#nodes + 1] = {
                n = G.UIT.O,
                config = {
                    object = create_bloonlatro_boss_card(blind)
                }
            }
        end
    end

    return nodes
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
    segments = segments or {}

    local card_nodes = {}

    for _, b in ipairs(segments) do
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
    local selected, segments = get_bloonlatro_view_data()

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
            or blind.bloonlatro_boss.parts.segment == "head" then
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

    for i, b in ipairs(filtered_blinds) do
        local card = create_sprite_card({
            w = 1,
            h = 1,
            atlas = G.ANIMATION_ATLAS[b.atlas],
            pos = { x = 0, y = b.pos.y },
            no_ui = true,
            no_shadow = true
        })

        function card:click()
            Bloonlatro.boss_selected_index = i
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

G.FUNCS.create_bloonlatro_boss_ui = function()
    local blinds = get_bloonlatro_bosses()

    if #blinds == 0 then
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
                    back_func = "exit_overlay_menu",
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

    local selected, segments = get_bloonlatro_view_data()

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

        for _, b in ipairs(segments) do
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
-- RUN START
-------------------------------------------------------

local old_init_game_object = Game.init_game_object
function Game:init_game_object()
    local obj = old_init_game_object(self)

    if Bloonlatro.pending_win_ante then
        obj.win_ante = Bloonlatro.pending_win_ante
        Bloonlatro.pending_win_ante = nil
    end

    return obj
end

local old_start_setup_run = G.FUNCS.start_setup_run
G.FUNCS.start_setup_run = function(e)
    if (e and G.SETTINGS.current_setup == 'New Run')
        or (not e and G.SETTINGS.current_setup == 'New Run') then
        Bloonlatro.reset_boss_challenge = true
    end

    return old_start_setup_run(e)
end

local old_start_run = Game.start_run
function Game:start_run(args)
    args = args or {}

    if args.challenge then
        G.GAME.challenge = args.challenge
    end

    if args.win_ante then
        Bloonlatro.pending_win_ante = args.win_ante
    end

    if Bloonlatro.reset_boss_challenge then
        local keys = args.boss_challenge_keys

        if (not keys or #keys == 0) and args.boss_challenge then
            keys = boss_challenge_to_keys(args.boss_challenge)
        end

        if keys and #keys > 0 then
            local hydrated = boss_challenge_from_keys(keys)
            Bloonlatro.boss_challenge = (#hydrated > 0) and hydrated or nil
        else
            Bloonlatro.boss_challenge = args.boss_challenge or nil
        end

        Bloonlatro.reset_boss_challenge = false
    end

    local result = old_start_run(self, args)

    if (not Bloonlatro.boss_challenge or #Bloonlatro.boss_challenge == 0)
        and G.GAME and G.GAME.boss_challenge_keys
        and #G.GAME.boss_challenge_keys > 0 then
        local hydrated = boss_challenge_from_keys(G.GAME.boss_challenge_keys)
        Bloonlatro.boss_challenge = (#hydrated > 0) and hydrated or nil
    end

    if G.GAME then
        local keys = boss_challenge_to_keys(Bloonlatro.boss_challenge)
        G.GAME.boss_challenge_keys = (#keys > 0) and keys or nil
    end

    return result
end

G.FUNCS.bloonlatro_start_boss_run = function()
    local selected, boss_challenge = get_bloonlatro_view_data()

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

    local challenge_params =
        selected.bloonlatro_boss.challenge_params or {}

    if challenge_params.banned_ids then
        for _, ban in ipairs(challenge_params.banned_ids) do
            table.insert(boss_bans, ban)
        end
    end

    local args = {
        boss_challenge = boss_challenge,
        boss_challenge_keys = boss_challenge_to_keys(boss_challenge),
        challenge = {
            deck = { type = "Challenge Deck" },
            restrictions = {
                banned_cards = boss_bans
            },
            jokers = challenge_params.jokers or {},
            consumeables = challenge_params.consumeables or {},
            vouchers = challenge_params.vouchers or {},
        },
        win_ante = challenge_params.win_ante or 8
    }

    Bloonlatro.reset_boss_challenge = true
    G.FUNCS.start_run(nil, args)
end
