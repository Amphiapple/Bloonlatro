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

function create_sprite_card(args)
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

local old_exit_overlay_menu = G.FUNCS.exit_overlay_menu
G.FUNCS.bloonlatro_boss_ui_back = function()
    local back_func = Bloonlatro.boss_ui_back_func or 'exit_overlay_menu'
    local back_id = Bloonlatro.boss_ui_back_id

    Bloonlatro.boss_ui_back_func = nil
    Bloonlatro.boss_ui_back_id = nil

    if back_func == 'exit_overlay_menu' then
        return old_exit_overlay_menu()
    end

    if G.OVERLAY_MENU then
        G.OVERLAY_MENU:remove()
        G.OVERLAY_MENU = nil
    end

    if G.FUNCS[back_func] then
        return G.FUNCS[back_func]({ config = { id = back_id } })
    end
end

G.FUNCS.exit_overlay_menu = function(...)
    if Bloonlatro.boss_ui_back_func then
        return G.FUNCS.bloonlatro_boss_ui_back()
    end

    return old_exit_overlay_menu(...)
end

-------------------------------------------------------
-- MAIN MENU
-------------------------------------------------------

function Bloonlatro.main_menu()
    local MAX_LOGO_POS_X = 8

    create_bloonlatro_logo(MAX_LOGO_POS_X)

    local boss_ui = UIBox {
        definition = {
            n = G.UIT.ROOT,
            config = {
                align = "cm",
                colour = G.C.CLEAR
            },
            nodes = {
                { n = G.UIT.O, config = { object = create_bloonlatro_boss_button() } }
            }
        },
        config = {
            align = "cri",
            offset = { x = 10, y = -3.3 },
            major = G.ROOM_ATTACH,
            bond = "Weak"
        }
    }

    G.PROFILES[G.SETTINGS.profile].viewed_bloonlatro_tutorial = false

    local tutorial_ui = UIBox {
        definition = {
            n = G.UIT.ROOT,
            config = {
                align = "cm",
                colour = G.C.CLEAR
            },
            nodes = {
                { n = G.UIT.O, config = { object = create_bloonlatro_tutorial_button() } }
            }
        },
        config = {
            align = "cri",
            offset = { x = 10, y = -1.3 },
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
            if boss_ui and boss_ui.alignment then
                boss_ui.alignment.offset.x = 0
                boss_ui:align_to_major()
            end

            if tutorial_ui and tutorial_ui.alignment then
                tutorial_ui.alignment.offset.x = 0
                tutorial_ui:align_to_major()
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