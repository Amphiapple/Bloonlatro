Bloonlatro = Bloonlatro or {}
Bloonlatro.boss_selected_index = Bloonlatro.boss_selected_index or 1

-------------------------------------------------------
-- INIT
-------------------------------------------------------

SMODS.Atlas {
    key = 'bloons_logo',
    path = 'logos.png',
    px = 129 / 2,
    py = 163 / 2
}

SMODS.Sound({ key = "pop01", path = "pop01.ogg" })
SMODS.Sound({ key = "pop02", path = "pop02.ogg" })
SMODS.Sound({ key = "pop03", path = "pop03.ogg" })
SMODS.Sound({ key = "pop04", path = "pop04.ogg" })

-------------------------------------------------------
-- MAIN MENU
-------------------------------------------------------

function Bloonlatro.main_menu()
    MAX_LOGO_POS_X = 4
    create_bloonlatro_logo(MAX_LOGO_POS_X)
    create_bloonlatro_boss_button()
end

function create_bloonlatro_logo(pos_x)
    if not G.title_top or not G.title_top.cards or not G.title_top.cards[1] then return end

    G.title_top.max_pos_x = G.title_top.max_pos_x or pos_x
    G.title_top.cards[1]:remove()

    local card = Card(
        0, 0,
        G.CARD_W * 1.4,
        G.CARD_H * 1.4,
        G.P_CARDS.empty,
        G.P_CENTERS.c_base
    )

    card:set_alignment({
        major = G.title_top,
        type = 'cm',
        bond = 'Strong',
        offset = { x = 0, y = 0 }
    })

    card.no_ui = true

    card.children.center:remove()
    card.children.center = SMODS.create_sprite(
        card.T.x, card.T.y, card.T.w, card.T.h,
        G.ASSET_ATLAS["bloons_logo"],
        { x = pos_x, y = 0 }
    )

    card.children.center:set_role({
        major = card,
        role_type = 'Glued',
        draw_major = card
    })

    function card:click()
        local num = math.random(1, 4)
        play_sound('bloons_pop0' .. num)

        G.E_MANAGER:add_event(Event({
            delay = 0.1,
            func = function()
                local next_x = (pos_x <= 0 and G.title_top.max_pos_x) or (pos_x - 1)
                pos_x = next_x
                card.children.center:set_sprite_pos({ x = pos_x, y = 0 })
                return true
            end
        }))
    end

    G.title_top:emplace(card)
end

function create_bloonlatro_boss_button()
    local pos_y = math.random(17, 22)

    local card = Card(
        0, 0,
        1.8, 1.8,
        G.P_CARDS.empty,
        G.P_CENTERS.c_base
    )

    card.no_ui = true

    card.children.center:remove()
    card.children.center = SMODS.create_sprite(
        card.T.x, card.T.y, card.T.w, card.T.h,
        G.ANIMATION_ATLAS["bloons_Blind"],
        { x = 0, y = pos_y }
    )

    card.children.center:set_role({
        major = card,
        role_type = 'Glued',
        draw_major = card
    })

    function card:click()
        G.FUNCS.create_bloonlatro_boss_ui()
    end

    return UIBox {
        definition = {
            n = G.UIT.ROOT,
            config = { align = "cm", colour = G.C.CLEAR },
            nodes = {
                { n = G.UIT.O, config = { object = card } }
            }
        },
        config = {
            align = "cri",
            offset = { x = 0, y = -3.3 },
            major = G.ROOM_ATTACH,
            bond = "Weak"
        }
    }
end

-------------------------------------------------------
-- BOSS DATA
-------------------------------------------------------

local function get_bloonlatro_bosses()
    local t = {}

    for _, v in pairs(G.P_BLINDS) do
        if v.boss and v.boss.showdown and v.bloonlatro_boss then
            t[#t+1] = v
        end
    end

    table.sort(t, function(a, b)
        return (a.bloonlatro_boss.index or 0) < (b.bloonlatro_boss.index or 0)
    end)

    return t
end

local function get_boss_segments(selected, all_blinds)
    if not selected then return {} end

    local parts = selected.bloonlatro_boss.parts

    if not parts then
        return { selected }
    end

    local main = parts.main
    local segments = {}

    for _, b in ipairs(all_blinds) do
        local p = b.bloonlatro_boss.parts
        if p and p.main == main then
            table.insert(segments, b)
        end
    end

    table.sort(segments, function(a, b)
        return (a.bloonlatro_boss.parts.order or 0)
             < (b.bloonlatro_boss.parts.order or 0)
    end)

    return segments
end

local function get_bloonlatro_view_data()
    local all_blinds = get_bloonlatro_bosses()
    local selected = all_blinds[Bloonlatro.boss_selected_index]
    if not selected then return nil end

    local segments = get_boss_segments(selected, all_blinds)
    return selected, segments
end

function get_bloonlatro_boss_card_nodes()
    local nodes = {}

    local bosses = get_bloonlatro_bosses()
    local selected = bosses[Bloonlatro.boss_selected_index]
    if not selected then return nodes end

    local parts = selected.bloonlatro_boss and selected.bloonlatro_boss.parts

    if parts and parts.main then
        local main = parts.main

        for _, boss in ipairs(bosses) do
            local bp = boss.bloonlatro_boss and boss.bloonlatro_boss.parts

            if bp and bp.main == main then
                nodes[#nodes + 1] = {
                    n = G.UIT.O,
                    config = {
                        object = create_bloonlatro_boss_card(boss)
                    }
                }
            end
        end
    else
        nodes[#nodes + 1] = {
            n = G.UIT.O,
            config = {
                object = create_bloonlatro_boss_card(selected)
            }
        }
    end

    return nodes
end

-------------------------------------------------------
-- BOSS CARD
-------------------------------------------------------

function create_bloonlatro_boss_card(blind)
    if not blind then return nil end
    local card = Card(0, 0, 1.3, 1.3, G.P_CARDS.empty, G.P_CENTERS.c_base)

    card.children.center:remove()
    card.children.center = SMODS.create_sprite(
        card.T.x, card.T.y, card.T.w, card.T.h,
        G.ANIMATION_ATLAS[blind.atlas],
        { x = 0, y = blind.pos.y }
    )

    card.children.center:set_role({ major = card, role_type = 'Glued', draw_major = card })

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
        if self.facing ~= 'front' or self.no_ui or G.debug_tooltip_toggle then return end

        self:juice_up(0.05, 0.03)
        play_sound('paper1', math.random() * 0.2 + 0.9, 0.35)

        self.config.h_popup = UIBox{
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
    if not selected then return nil end

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
                config = { align = "cm", padding = 0.2 },
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
        if not blind.bloonlatro_boss.parts or blind.bloonlatro_boss.parts.segment == "head" then
            table.insert(filtered_blinds, blind)
        end
    end

    local row = {
        n = G.UIT.R,
        config = { align = "cm", padding = 0.1 },
        nodes = {}
    }

    for i, b in ipairs(filtered_blinds) do
        local icon = SMODS.create_sprite(
            0, 0, 1.0, 1.0,
            G.ANIMATION_ATLAS[b.atlas],
            { x = 0, y = b.pos.y }
        )

        local card = Card(0, 0, 1, 1, G.P_CARDS.empty, G.P_CENTERS.c_base)
        card.no_ui = true
        card.no_shadow = true

        card.children.center:remove()
        card.children.center = icon

        icon:set_role({
            major = card,
            role_type = 'Glued',
            draw_major = card
        })

        function card:click()
            Bloonlatro.boss_selected_index = i
            G.FUNCS.update_bloonlatro_boss_ui()
        end

        row.nodes[#row.nodes+1] = {
            n = G.UIT.O,
            config = { object = card }
        }
    end

    return row
end

G.FUNCS.create_bloonlatro_boss_ui = function()
    local blinds = get_bloonlatro_bosses()
    if #blinds == 0 then return end

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
                            config = { align = "cm", padding = 0.3 },
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
        func = (function()
            if ui and ui.alignment then ui.alignment.offset.y = 0 end
            return true
        end)
    }))

    return ui
end

G.FUNCS.update_bloonlatro_boss_ui = function()
    if not G.OVERLAY_MENU then return end

    local selected, segments = get_bloonlatro_view_data()
    if not selected then return end

    local name_e = G.OVERLAY_MENU:get_UIE_by_ID("bloonlatro_boss_name")
    if name_e then
        name_e.config.text = selected.bloonlatro_boss.title
        name_e.config.colour = selected.boss_colour or G.C.WHITE
        name_e:update_text()
    end

    local cards_container = G.OVERLAY_MENU:get_UIE_by_ID("bloonlatro_boss_cards_container")
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

local old_start_run = Game.start_run
function Game:start_run(args)
    args = args or {}
    Bloonlatro.boss_id = args.boss_id or nil
    if args.challenge then
        G.GAME.challenge = args.challenge
    end
    if args.win_ante then
        Bloonlatro.pending_win_ante = args.win_ante
    end

    return old_start_run(self, args)
end

G.FUNCS.bloonlatro_start_boss_run = function()
    local blinds = get_bloonlatro_bosses()
    local selected = blinds[Bloonlatro.boss_selected_index]
    if not selected then return end

    local boss_bans = {
        {id = 'j_luchador'},
        {id = 'j_chicot'},
        {id = 'j_mr_bones'},
        {id = 'j_bloons_bomb_blitz'},
        {id = 'j_bloons_cripple_moab'},
        {id = 'j_bloons_herald_of_everfrost'},
        {id = 'tag_bloons_sabotage'},
        {id = 'v_bloons_big_bloon_sabotage'},
        {id = 'v_bloons_big_bloon_blueprints'},
    }

    local challenge_params = selected.bloonlatro_boss.challenge_params or {}

    if challenge_params.banned_ids then
        for _, ban in ipairs(challenge_params.banned_ids) do
            table.insert(boss_bans, ban)
        end
    end

    local args = {
        boss_id = selected.key,
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

    G.FUNCS.start_run(nil, args)
end