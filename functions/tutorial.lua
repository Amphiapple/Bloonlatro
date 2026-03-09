local function ensure_bloonlatro_tutorial_progress()
    local p = G.SETTINGS.bloonlatro_tutorial_progress or {}

    p.forced_shop = p.forced_shop or { "c_empress", "j_bloons_dart_monkey" }
    p.forced_voucher = p.forced_voucher or "v_grabber"
    p.forced_tags = p.forced_tags or { "tag_handy", "tag_garbage" }
    p.hold_parts = p.hold_parts or {}
    p.completed_parts = p.completed_parts or {}

    G.SETTINGS.bloonlatro_tutorial_progress = p
    return p
end

local function ensure_bloonlatro_overlay()
    local overlay_colour = { 0.32, 0.36, 0.41, 0 }
    ease_value(overlay_colour, 4, 0.6, nil, "REAL", true, 0.4)

    G.OVERLAY_TUTORIAL = G.OVERLAY_TUTORIAL or UIBox({
        definition = {
            n = G.UIT.ROOT,
            config = { align = "cm", padding = 32.05, r = 0.1, colour = overlay_colour, emboss = 0.05 },
            nodes = {
                {
                    n = G.UIT.R,
                    config = { align = "tr", minh = G.ROOM.T.h, minw = G.ROOM.T.w },
                    nodes = {
                        UIBox_button({
                            label = { localize("b_skip") .. " >" },
                            button = "skip_tutorial_section",
                            minw = 1.3,
                            scale = 0.45,
                            colour = G.C.JOKER_GREY,
                        }),
                    },
                },
            },
        },
        config = {
            align = "cm",
            offset = { x = 0, y = 3.2 },
            major = G.ROOM_ATTACH,
            bond = "Weak",
        },
    })

    G.OVERLAY_TUTORIAL.step = G.OVERLAY_TUTORIAL.step or 1
    G.OVERLAY_TUTORIAL.step_complete = false
    return G.OVERLAY_TUTORIAL
end

local function has_owned_dart()
    if G.jokers and G.jokers.cards then
        for _, c in ipairs(G.jokers.cards) do
            if c and c.config and c.config.center_key == "j_bloons_dart_monkey" then
                return true
            end
        end
    end
    return false
end

local function default_attach_from_hud()
    local row_dollars_chips = G.HUD and G.HUD:get_UIE_by_ID("row_dollars_chips")
    if row_dollars_chips then
        return { major = row_dollars_chips, type = "tm", offset = { x = 0, y = -0.5 } }
    end
    return { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = 0 } }
end

local function ensure_dynamic_tutorial_text(key, lines)
    G.localization = G.localization or {}
    G.localization.misc = G.localization.misc or {}
    G.localization.misc.tutorial = G.localization.misc.tutorial or {}
    G.localization.tutorial_parsed = G.localization.tutorial_parsed or {}

    G.localization.misc.tutorial[key] = lines
    G.localization.tutorial_parsed[key] = { multi_line = true }
    for i = 1, #lines do
        G.localization.tutorial_parsed[key][i] = loc_parse_string(lines[i])
    end
end

G.FUNCS.start_bloonlatro_tutorial_run = function(e, args)
    ensure_bloonlatro_tutorial_progress()
    G.SETTINGS.paused = true
    G.SETTINGS.run_stake_stickers = false
    if e and e.config and e.config.id == "restart_button" then
        G.GAME.viewed_back = nil
    end

    args = args or {}
    G.GAME.selected_back = Back(G.P_CENTERS["b_red"])

    G.E_MANAGER:clear_queue()
    G.FUNCS.wipe_on()

    G.E_MANAGER:add_event(Event({
        no_delete = true,
        func = function()
            G:delete_run()
            return true
        end,
    }))

    G.E_MANAGER:add_event(Event({
        trigger = "immediate",
        no_delete = true,
        func = function()
            G:start_run(args)
            G.STATE = G.STATES.SHOP
            return true
        end,
    }))

    G.FUNCS.wipe_off()
end

G.FUNCS.bloonlatro_tutorial_controller = function()
    if G.F_SKIP_TUTORIAL then
        G.SETTINGS.bloonlatro_tutorial_complete = true
        G.SETTINGS.bloonlatro_tutorial_progress = nil
        return
    end

    local progress = ensure_bloonlatro_tutorial_progress()
    if G.SETTINGS.paused or G.SETTINGS.bloonlatro_tutorial_complete then
        return
    end

    if G.STATE == G.STATES.SHOP
        and not progress.completed_parts["welcome"] then
        progress.section = "welcome"
        G.FUNCS.bloonlatro_tutorial_part("welcome")
        progress.completed_parts["welcome"] = true
        G:save_progress()
    end

    if progress.hold_parts["welcome"]
        and not progress.completed_parts["buy_dart_monkey"] then
        progress.section = "buy_dart_monkey"
        G.FUNCS.bloonlatro_tutorial_part("buy_dart_monkey")
        progress.completed_parts["buy_dart_monkey"] = true
        G:save_progress()
    end

    if progress.hold_parts["buy_dart_monkey"]
        and has_owned_dart()
        and not progress.completed_parts["joker_information"] then
        progress.section = "joker_information"
        G.FUNCS.bloonlatro_tutorial_part("joker_information")
        progress.completed_parts["joker_information"] = true
        G:save_progress()
    end

    if progress.hold_parts["joker_information"] 
        and not progress.hold_parts["placeholder"] then
        progress.section = "placeholder"
        G.FUNCS.bloonlatro_tutorial_part("placeholder")
        progress.hold_parts["placeholder"] = true
        G:save_progress()
    end

    if progress.hold_parts["placeholder"] then
        G.SETTINGS.bloonlatro_tutorial_complete = true
        G.SETTINGS.bloonlatro_tutorial_progress = nil
        G.SETTINGS.run_stake_stickers = true
        G:save_progress()
    end
end

G.FUNCS.bloonlatro_tutorial_info = function(args)
    args = args or {}
    local overlay = ensure_bloonlatro_overlay()

    local step = args.step or overlay.step or 1
    local align = args.align or "tm"
    local attach = args.attach or default_attach_from_hud()
    local attach_major = attach and attach.major
    local pos = args.pos or {
        x = attach_major and (attach_major.T.x + (attach_major.T.w / 2)) or 0,
        y = attach_major and (attach_major.T.y + (attach_major.T.h / 2)) or 0,
    }
    pos.center = "j_bloons_bloonprint"

    local button = args.button or { button = localize("b_next"), func = "tut_next" }
    args.highlight = args.highlight or {}

    G.E_MANAGER:add_event(Event({
        trigger = "after",
        delay = 0.3,
        func = function()
            local current = G.OVERLAY_TUTORIAL
            if not current then return true end
            if current.step ~= step or current.step_complete then
                return current.step > step or current.skip_steps
            end

            G.CONTROLLER.interrupt.focus = true

            current.Jimbo = current.Jimbo or Card_Character(pos)

            if type(args.highlight) == "function" then
                args.highlight = args.highlight() or {}
            end

            current.Jimbo:add_speech_bubble(args.text_key, align, args.loc_vars)
            current.Jimbo:set_alignment(attach)
            if args.hard_set then current.Jimbo:hard_set_VT() end

            current.button_listen = args.button_listen or nil

            if not args.no_button then
                current.Jimbo:add_button(button.button, button.func, button.colour, button.update_func, true)
            end

            args.highlight[#args.highlight + 1] = current.Jimbo
            if current.Jimbo.children and current.Jimbo.children.button then
                args.highlight[#args.highlight + 1] = current.Jimbo.children.button
            end
            current.highlights = args.highlight

            current.Jimbo:say_stuff(2 * (#(G.localization.misc.tutorial[args.text_key] or {})) + 1)
            current.step_complete = true
            return current.step > step or current.skip_steps
        end,
    }), "tutorial")

    return step + 1
end

G.FUNCS.bloonlatro_tutorial_part = function(part)
    local step = 1
    G.SETTINGS.paused = true

    if part == "welcome" then
        ensure_dynamic_tutorial_text("bloons_welcome_1", {
            "Welcome to Bloonlatro!",
        })

        ensure_dynamic_tutorial_text("bloons_welcome_2", {
            "In this tutorial, you'll learn the basics of playing Bloonlatro.",
        })

        step = G.FUNCS.bloonlatro_tutorial_info({
            text_key = "bloons_welcome_1",
            attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = 0 } },
            step = step,
        })

        step = G.FUNCS.bloonlatro_tutorial_info({
            text_key = "bloons_welcome_2",
            attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = 0 } },
            step = step,
        })
    end

    if part == "buy_dart_monkey" then
        ensure_dynamic_tutorial_text("bloons_buy_dart_monkey_1", {
            "Now let's buy a Dart Monkey!",
        })

        local dart = G.shop_jokers and G.shop_jokers.cards and G.shop_jokers.cards[1] or nil

        step = G.FUNCS.bloonlatro_tutorial_info({
            text_key = "bloons_buy_dart_monkey_1",
            attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = -5, y = 0 } },
            highlight = function()
                return { dart }
            end,
            no_button = true,
            button_listen = "buy_from_shop",
            step = step,
        })
    end

    if part == "joker_information" then
        ensure_dynamic_tutorial_text("bloons_joker_information_1", {
            "Joker information!",
        })

        local dart = G.jokers and G.jokers.cards and G.jokers.cards[1] or nil

        step = G.FUNCS.bloonlatro_tutorial_info({
            text_key = "bloons_joker_information_1",
            attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = -5, y = 0 } },
            highlight = function()
                return { dart }
            end,
            step = step,
        })
        
        dart.states.hover.can = false
        dart:hover()
    end

    if part == "placeholder" then
        local dart = G.jokers and G.jokers.cards and G.jokers.cards[1] or nil
        dart.states.hover.can = true
        dart:stop_hover()
    end

    G.E_MANAGER:add_event(Event({
        blockable = false,
        timer = "REAL",
        func = function()
            local overlay = G.OVERLAY_TUTORIAL
            if not overlay then
                return true
            end

            if (overlay.step == step and not overlay.step_complete) or overlay.skip_steps then
                if overlay.Jimbo then overlay.Jimbo:remove() end
                if overlay.content then overlay.content:remove() end
                overlay:remove()
                G.OVERLAY_TUTORIAL = nil

                local progress = ensure_bloonlatro_tutorial_progress()
                progress.hold_parts[part] = true
                return true
            end

            return overlay.step > step or overlay.skip_steps
        end,
    }), "tutorial")

    G.SETTINGS.paused = false
end