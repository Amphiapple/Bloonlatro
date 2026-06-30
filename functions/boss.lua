-------------------------------------------------------
-- BOSS HELPERS
-------------------------------------------------------

local function get_banned_cards(selected)
    local bans = {
        { id = 'j_luchador' },
        { id = 'j_chicot' },
        { id = 'j_mr_bones' },
        { id = 'j_bloons_bomb_blitz' },
        { id = 'j_bloons_cripple_moab' },
        { id = 'j_bloons_herald_of_everfrost' },
        { id = 'v_bloons_big_bloon_sabotage' },
        { id = 'v_bloons_big_bloon_blueprints' },
    }

    local challenge_params = selected.bloonlatro_boss.challenge_params or {}
    if challenge_params.banned_ids then
        for _, ban in ipairs(challenge_params.banned_ids) do
            bans[#bans + 1] = ban
        end
    end

    for i, v in ipairs(bans) do
        v._index = i
    end
    table.sort(bans, function(a, b)
        local function rank(id)
            if id:match("^j_") then return 1 end
            if id:match("^c_") then return 2 end
            if id:match("^v_") then return 3 end
            return 4
        end

        local ra = rank(a.id)
        local rb = rank(b.id)

        if ra == rb then
            return a._index < b._index
        end

        return ra < rb
    end)

    return bans
end

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
    if G.P_BLINDS[Bloonlatro.selected_boss_key] then
        boss_icon_y = G.P_BLINDS[Bloonlatro.selected_boss_key].pos.y
    else
        boss_icon_y = math.random(5, 11)
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
            padding = 0.25
        },
        nodes = {}
    }

    local boss_scale = 10 / #filtered_blinds

    for _, b in ipairs(filtered_blinds) do
        local card = create_sprite_card({
            w = boss_scale,
            h = boss_scale,
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
        selected_name = localize({ type = "name_text", set = "Blind", key = selected.key }):match("^(.-)%s+%S+$")
    else
        selected_name = localize({ type = "name_text", set = "Blind", key = selected.key })
    end

    return {
        n = G.UIT.R,
        config = {
            align = "cm",
            padding = 0.02,
            minw = 16,
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
                    minw = 16,
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

local function build_boss_info()
    return {
        n = G.UIT.R,
        config = {
            align = "cm",
            padding = 0.02,
            minw = 16,
            id = "bloonlatro_boss_info"
        },
        nodes = {}
    }
end

local function build_boss_details(selected)
    local boss_nodes = {
        n = G.UIT.R,
        nodes = {}
    }

    local family = get_boss_family(selected, get_bloonlatro_bosses())
    for _, blind in ipairs(family) do
        boss_nodes.nodes[#boss_nodes.nodes + 1] = {
            n = G.UIT.O,
            config = {
                object = create_bloonlatro_boss_card(blind)
            }
        }
    end

    local has_segments = #family > 1

    local rule_nodes = {
        {
            n = G.UIT.C,
            config = { align = "cm" },
            nodes = {}
        }
    }

    local loc_rules = G.localization.descriptions.Blind[selected.key].bloons_boss_challenge_rules or nil
    if loc_rules and type(loc_rules) == "table" and #loc_rules > 0 then
        for _, rule_text in ipairs(loc_rules) do
            rule_nodes[1].nodes[#rule_nodes[1].nodes + 1] = {
                n = G.UIT.R,
                config = { 
                    align = "cl",
                    padding = 0.03,
                    maxw = has_segments and 4.7 or 4.5
                },
                nodes = SMODS.localize_box(
                    loc_parse_string(rule_text),
                    {scale = 1, colour = G.C.UI.TEXT_DARK, vars = selected.bloonlatro_boss.loc_vars or {}}
                )
            }
        end
    else
        rule_nodes[1].nodes[#rule_nodes[1].nodes + 1] = {
            n = G.UIT.R,
            config = { align = "cm", padding = 0.03 },
            nodes = {
                {
                    n = G.UIT.O,
                    config = {
                        object = DynaText({
                            string = { "None" },
                            colours = { G.C.UI.TEXT_INACTIVE },
                            scale = 0.4,
                            maxw = has_segments and 4.7 or 4.5,
                        })
                    }
                }
            }
        }
    end

    --------------------------------------------------
    -- Base bans
    --------------------------------------------------

    local bans = get_banned_cards(selected)

    --------------------------------------------------
    -- Two ban card areas (top + bottom)
    --------------------------------------------------

    local ban_area_top = CardArea(
        0, 0,
        has_segments and 6.6 or 8.8,
        1.1,
        {
            card_limit = #bans,
            type = "title_2",
            view_deck = true,
            highlight_limit = 0,
            card_w = G.CARD_W * 0.55
        }
    )

    local ban_area_bottom = CardArea(
        0, 0,
        has_segments and 6.6 or 8.8,
        1.1,
        {
            card_limit = #bans,
            type = "title_2",
            view_deck = true,
            highlight_limit = 0,
            card_w = G.CARD_W * 0.55
        }
    )

    local display_amount = 0
    for _, ban in ipairs(bans) do
        local center = G.P_CENTERS[ban.id]

        if center then
            local card = Card(
                0, 0,
                G.CARD_W * 0.55,
                G.CARD_H * 0.55,
                nil,
                center,
                {
                    bypass_discovery_center = true,
                    bypass_discovery_ui = true,
                    bypass_lock = true
                }
            )
            display_amount = display_amount + 1

            if display_amount > 12 then
                ban_area_bottom:emplace(card)
            else
                ban_area_top:emplace(card)
            end
        end
    end

    local banned_cards = {
        {
            n = G.UIT.R,
            config = { align = "cm" },
            nodes = {
                {
                    n = G.UIT.O,
                    config = {
                        object = ban_area_top
                    }
                }
            }
        },
    }
    if #bans > 12 then
        banned_cards[#banned_cards + 1] = {
            n = G.UIT.R,
            config = { align = "cm" },
            nodes = {
                {
                    n = G.UIT.O,
                    config = {
                        object = ban_area_bottom
                    }
                }
            }
        }
    end

    --------------------------------------------------
    -- Boss panel
    --------------------------------------------------

    local boss_panel = {
        n = G.UIT.C,
        config = {
            align = "cm",
            r = 0.1,
            colour = selected.boss_colour or G.C.BLUE
        },
        nodes = {
            {
                n = G.UIT.R,
                config = {
                    align = "cm",
                    padding = 0.08,
                    minh = 0.6
                },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = "Boss",
                            scale = 0.4,
                            colour = G.C.UI.TEXT_LIGHT,
                            shadow = true
                        }
                    }
                }
            },
            {
                n = G.UIT.R,
                config = {
                    align = "cm",
                    minw = has_segments and 4 or 2,
                    minh = 3,
                    padding = 0.05,
                    r = 0.1,
                    colour = G.C.WHITE
                },
                nodes = {
                    boss_nodes
                }
            }
        }
    }

    --------------------------------------------------
    -- Rules panel
    --------------------------------------------------

    local rules_panel = {
        n = G.UIT.C,
        config = {
            align = "cm",
            r = 0.1,
            colour = G.C.BLUE
        },
        nodes = {
            {
                n = G.UIT.R,
                config = {
                    align = "cm",
                    padding = 0.08,
                    minh = 0.6
                },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = "Rules",
                            scale = 0.4,
                            colour = G.C.UI.TEXT_LIGHT,
                            shadow = true
                        }
                    }
                }
            },
            {
                n = G.UIT.R,
                config = {
                    align = "cm",
                    minh = 3,
                    minw = has_segments and 4.7 or 4.5,
                    padding = 0.05,
                    r = 0.1,
                    colour = G.C.WHITE
                },
                nodes = rule_nodes
            }
        }
    }

    --------------------------------------------------
    -- Bans panel (two rows)
    --------------------------------------------------

    local bans_panel = {
        n = G.UIT.C,
        config = {
            align = "cm",
            r = 0.1,
            colour = G.C.RED
        },
        nodes = {
            {
                n = G.UIT.R,
                config = {
                    align = "cm",
                    padding = 0.08,
                    minh = 0.6
                },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = "Bans",
                            scale = 0.4,
                            colour = G.C.UI.TEXT_LIGHT,
                            shadow = true
                        }
                    }
                }
            },
            {
                n = G.UIT.R,
                config = {
                    align = "cm",
                    minh = 3,
                    minw = has_segments and 6.7 or 8.9,
                    padding = 0.05,
                    r = 0.1,
                    colour = G.C.WHITE
                },
                nodes = banned_cards
            }
        }
    }

    return {
        n = G.UIT.C,
        config = {
            align = "cm",
            padding = 0.1,
            colour = G.C.L_BLACK,
            r = 0.1,
            minw = 16
        },
        nodes = {
            boss_panel,
            rules_panel,
            bans_panel
        }
    }
end

local function set_bloonlatro_boss_info()
    local selected = ensure_selected_boss()
    if not selected then return end

    local info_e = G.OVERLAY_MENU and G.OVERLAY_MENU:get_UIE_by_ID("bloonlatro_boss_info")
    if not info_e or not info_e.children then return end

    for i = #info_e.children, 1, -1 do
        local child = info_e.children[i]
        table.remove(info_e.children, i)
        child:remove()
    end

    G.OVERLAY_MENU:add_child(
        build_boss_details(selected),
        info_e
    )
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
                padding = 0.3,
                r = 0.15,
                colour = G.C.BLACK,
                border = 0.08,
                border_colour = G.C.RED
            },
            nodes = {
                {
                    n = G.UIT.C,
                    config = {
                        align = "cm",
                        padding = 0.1,
                        minw = 16
                    },
                    nodes = {
                        build_list(),
                        build_name(),
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
                                    minw = 16,
                                    minh = 1
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
    set_bloonlatro_boss_info()

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

    local name_e = G.OVERLAY_MENU:get_UIE_by_ID("bloonlatro_boss_name_text")

    if name_e then
        if selected.bloonlatro_boss and selected.bloonlatro_boss.parts then
            name_e.config.text = localize({ type = "name_text", set = "Blind", key = selected.key }):match(
                "^(.-)%s+%S+$")
        else
            name_e.config.text = localize({ type = "name_text", set = "Blind", key = selected.key })
        end
    end

    local outline_e = G.OVERLAY_MENU:get_UIE_by_ID("bloonlatro_boss_name_outline")
    if outline_e then
        outline_e.config.outline_colour = selected.boss_colour or G.C.GREY
    end

    set_bloonlatro_boss_info()
end

-------------------------------------------------------
-- BOSS FUNCTIONS
-------------------------------------------------------

G.FUNCS.bloonlatro_start_boss_run = function()
    local selected = G.P_BLINDS[Bloonlatro.selected_boss_key]
    if not selected then return end

    local challenge_params = selected.bloonlatro_boss.challenge_params or {}
    local bans = get_banned_cards(selected)

    local deck = G.P_CENTERS["b_bloons_boss_challenge"]
    local params = {
        boss_challenge = selected.key,
        vouchers = challenge_params.vouchers or {},
        win_ante = challenge_params.win_ante or 8,
        banned_keys = bans
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
