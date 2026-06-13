-------------------------------------------------------
-- BOSS HELPERS
-------------------------------------------------------

local function get_bloonlatro_bosses()
    local t = {}

    for _, v in pairs(G.P_BLINDS) do
        if v.boss and v.boss.showdown and v.bloonlatro_boss then
            t[#t + 1] = v
        end
    end

    table.sort(t, function(a, b)
        return (a.bloonlatro_boss.index or 0) < (b.bloonlatro_boss.index or 0)
    end)

    return t
end

local function get_boss_family(blind, all_blinds)
    if not blind then return {} end

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
    if #all_blinds == 0 then return nil, nil end

    local selected
    if Bloonlatro.selected_boss_key then
        selected = G.P_BLINDS[Bloonlatro.selected_boss_key]
    end

    if not selected then
        selected = all_blinds[1]
        Bloonlatro.selected_boss_key = selected.key
    end

    return selected, get_boss_family(selected, all_blinds)
end

-------------------------------------------------------
-- BOSS UI
-------------------------------------------------------

function create_bloonlatro_boss_button()
    local boss_icon_y

    local selected = ensure_selected_boss()
    boss_icon_y = (selected and selected.pos and selected.pos.y) or math.random(5, 11)

    local card = create_sprite_card({
        w = 1.8,
        h = 1.8,
        atlas = G.ANIMATION_ATLAS["bloons_Blind"],
        pos = { x = 0, y = boss_icon_y },
        no_ui = true
    })

    function card:click()
        ensure_selected_boss()
        G.FUNCS.create_bloonlatro_boss_ui()
    end

    return card
end

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
            padding = 0.03
        },
        nodes = {}
    }

    for _, b in ipairs(filtered_blinds) do
        local card = create_sprite_card({
            w = 1.2,
            h = 1.2,
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

local function build_name()
    local selected = ensure_selected_boss()

    if not selected then
        return nil
    end

    local selected_name
    if selected.bloonlatro_boss and selected.bloonlatro_boss.parts then
        selected_name = localize({type = "name_text", set = "Blind", key = selected.key}):match("^(.-)%s+%S+$")
    else
        selected_name = localize({type = "name_text", set = "Blind", key = selected.key})
    end

    return {
        n = G.UIT.R,
        config = {
            align = "cm",
            padding = 0.02,
            minw = 12,
        },
        nodes = {
            {
                n = G.UIT.C,
                config = {
                    id = "bloonlatro_boss_name_outline",
                    align = "cm",
                    padding = 0.15,
                    r = 0.08,
                    colour = G.C.GREY,
                    outline = 1.5,
                    outline_colour = selected.boss_colour or G.C.GREY,
                    minh = 0.75,
                    minw = 12,
                },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            id = "bloonlatro_boss_name_text",
                            text = selected_name,
                            scale = 0.9,
                            colour = G.C.WHITE,
                            align = "cm",
                        }
                    }
                }
            }
        }
    }
end

function build_boss_info_toggle()
    return {
        n = G.UIT.R,
        config = {
            align = "cm",
            padding = 0.02,
            minw = 12,
        },
        nodes = {
            UIBox_button({
                id = "bloonlatro_boss_info_toggle",
                label = { "Description" },
                button = "toggle_bloonlatro_boss_info",
                colour = G.C.RED,
                minw = 6,
                minh = 0.9
            })
        }
    }
end

function build_boss_info()
    return {
        n = G.UIT.R,
        config = {
            align = "cm",
            padding = 0.02,
            minw = 14,
            id = "bloonlatro_boss_info"
        },
        nodes = {}
    }
end

local function build_boss_info_text(text)
    return {
        n = G.UIT.T,
        config = {
            text = text,
            align = "cm",
            colour = G.C.WHITE,
            scale = 0.3
        }
    }
end

local function clear_boss_info()
    local info_e = G.OVERLAY_MENU and G.OVERLAY_MENU:get_UIE_by_ID("bloonlatro_boss_info")
    if not info_e or not info_e.children then return end

    for i = #info_e.children, 1, -1 do
        local child = info_e.children[i]
        table.remove(info_e.children, i)
        child:remove()
    end
end

local function set_boss_info(ui)
    local info_e = G.OVERLAY_MENU and G.OVERLAY_MENU:get_UIE_by_ID("bloonlatro_boss_info")
    if not info_e then return end

    clear_boss_info()
    G.OVERLAY_MENU:add_child(ui, info_e)
    G.OVERLAY_MENU:recalculate()
end

local function set_boss_info_toggle_label(label)
    local toggle_e = G.OVERLAY_MENU and G.OVERLAY_MENU:get_UIE_by_ID("bloonlatro_boss_info_toggle")
    local text_e = toggle_e and toggle_e.children and toggle_e.children[1] and toggle_e.children[1].children and toggle_e.children[1].children[1]

    if text_e and text_e.config then
        text_e.config.text = label
    end
end

function show_bloonlatro_description_info()
    Bloonlatro.boss_info_mode = "description"
    set_boss_info_toggle_label("Rules")
    set_boss_info(build_boss_info_text("Description"))
end

function show_bloonlatro_rules_info()
    Bloonlatro.boss_info_mode = "rules"
    set_boss_info_toggle_label("Description")
    set_boss_info(build_boss_info_text("Rules"))
end

G.FUNCS.create_bloonlatro_boss_ui = function(origin, from_game_over)
    local back_func = 'bloonlatro_boss_ui_back'
    local back_target = origin == 'run_tab' and 'setup_run' or 'exit_overlay_menu'
    local back_id = origin == 'run_tab' and (from_game_over and 'from_game_over' or nil) or nil

    Bloonlatro.boss_ui_back_func = origin == 'run_tab' and back_target or nil
    Bloonlatro.boss_ui_back_id = origin == 'run_tab' and back_id or nil

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
                minw = 16,
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
                        padding = 0.2,
                        minw = 14
                    },
                    nodes = {
                        build_list(),
                        build_name(),
                        build_boss_info_toggle(),
                        build_boss_info(),
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
                    back_button = 'back',
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
            bond = 'Weak',
        }
    }

    G.OVERLAY_MENU = ui
    show_bloonlatro_description_info()

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

G.FUNCS.toggle_bloonlatro_boss_info = function()
    if Bloonlatro.boss_info_mode == "description" then
        show_bloonlatro_rules_info()
    else
        show_bloonlatro_description_info()
    end
end

G.FUNCS.update_bloonlatro_boss_ui = function()
    if not G.OVERLAY_MENU then
        return
    end

    local selected, segments = ensure_selected_boss()

    if not selected then
        return
    end

    local name_e = G.OVERLAY_MENU:get_UIE_by_ID("bloonlatro_boss_name_text")

    if name_e then
        if selected.bloonlatro_boss and selected.bloonlatro_boss.parts then
            name_e.config.text = localize({type = "name_text", set = "Blind", key = selected.key}):match("^(.-)%s+%S+$")
        else
            name_e.config.text = localize({type = "name_text", set = "Blind", key = selected.key})
        end
    end

    local outline_e = G.OVERLAY_MENU:get_UIE_by_ID("bloonlatro_boss_name_outline")
    if outline_e then
        outline_e.config.outline_colour = selected.boss_colour or G.C.GREY
    end

    if Bloonlatro.boss_info_mode == "rules" then
        show_bloonlatro_rules_info()
    else
        show_bloonlatro_description_info()
    end
end

-------------------------------------------------------
-- BOSS FUNCTIONS
-------------------------------------------------------

G.FUNCS.bloonlatro_start_boss_run = function()
    local selected = G.P_BLINDS[Bloonlatro.selected_boss_key]
    if not selected then return end

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

    local deck = G.P_CENTERS["b_bloons_boss_challenge"]
    local params = {
        boss_challenge = selected.key,
        vouchers = challenge_params.vouchers or {},
        win_ante = challenge_params.win_ante or 8,
        banned_keys = boss_bans
    }

    deck:set_params(params)
    G.FUNCS.start_run(nil, { challenge = { deck = { type = "Boss Challenge Deck" } } })
end

local old_start_run = Game.start_run
function Game:start_run(args)
    Bloonlatro.boss_ui_back_func = nil
    Bloonlatro.boss_ui_back_id = nil

    return old_start_run(self, args)
end

local old_back_load = Back.load
function Back:load(args)
    local res = old_back_load(self, args)

    if self.effect and self.effect.center and self.effect.center.load_params then
        self.effect.center:load_params()
    end

    return res
end
