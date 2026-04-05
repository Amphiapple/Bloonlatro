

local function can_interact_with_card(card)
    if not card or not card.area then return false end
    if (G.play and #G.play.cards > 0) then return false end
    if (G.CONTROLLER and G.CONTROLLER.locked) then return false end
    if (G.GAME and G.GAME.STOP_USE and G.GAME.STOP_USE > 0) then return false end
    return true
end

local function can_adora_sacrifice(card)
    local is_adora_deck = G.GAME and G.GAME.selected_back and G.GAME.selected_back.name and G.GAME.selected_back.name == 'Adora Deck'

    if not can_interact_with_card(card) then return false end
    if not is_adora_deck then return false end
    if not card.ability or card.ability.eternal then return false end

    local back = G.GAME and G.GAME.selected_back
    local center = back and back.effect and back.effect.center
    return center and type(center.sac_to_adora) == 'function'
end

local function can_vtsg_sacrifice(card)
    local is_vtsg = card and card.ability and card.ability.name == 'Vengeful True Sun God'

    if not can_interact_with_card(card) then return false end
    if not is_vtsg then return false end
    if not (card.config and card.config.center and type(card.config.center.sac_to_vtsg) == 'function') then
        return false
    end

    local sacrifices = card.ability and card.ability.extra and card.ability.extra.sacrifices
    if not sacrifices then return false end

    local no_sacs =
        (sacrifices.primary or 0) == 0 and
        (sacrifices.military or 0) == 0 and
        (sacrifices.magic or 0) == 0 and
        (sacrifices.support or 0) == 0

    if not no_sacs then return false end

    local has_valid_target = false
    for _, joker in pairs(G.jokers.cards or {}) do
        if joker ~= card then
            local tower = joker.ability and joker.ability.tower_info
            local base = tower and tower.base
            local category = tower and tower.category

            local valid_base = base and base ~= "Sentry" and base ~= "Marine"
            local valid_category = category and string.lower(tostring(category)) ~= "misc"

            if valid_base and valid_category then
                has_valid_target = true
                break
            end
        end
    end

    return has_valid_target
end

local function set_button_state(e, is_enabled, fallback_action)
    if is_enabled then
        e.config.colour = e.config.active_colour or G.C.GREEN
        e.config.button = e.config.action_button or fallback_action
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.can_adora_sac = function(e)
    set_button_state(e, can_adora_sacrifice(e.config.ref_table), 'adora_sac')
end

G.FUNCS.can_vtsg_sac = function(e)
    set_button_state(e, can_vtsg_sacrifice(e.config.ref_table), 'vtsg_sac')
end

G.FUNCS.adora_sac = function(e)
    local card = e.config.ref_table
    if not can_adora_sacrifice(card) then return end

    local center = G.GAME.selected_back.effect.center
    center.sac_to_adora(card)
end

G.FUNCS.vtsg_sac = function(e)
    local card = e.config.ref_table
    if not can_vtsg_sacrifice(card) then return end

    card.config.center.sac_to_vtsg(card)
    card.highlighted = false
end

function build_button(args)
    if not args or not args.card or not args.can or not args["function"] then return nil end

    local card = args.card
    local text = args.text or 'Unknown'
    local minw = args.minw or 1.25
    local minh = args.minh or 0
    local padding = args.padding or 0.15

    return {
        n = G.UIT.C,
        config = {align = "cr"},
        nodes = {
            {
                n = G.UIT.C,
                config = {
                    ref_table = card,
                    align = "cr",
                    maxw = minw,
                    minw = minw,
                    minh = minh,
                    padding = padding,
                    r = 0.08,
                    hover = true,
                    shadow = true,
                    one_press = true,
                    colour = G.C.UI.BACKGROUND_INACTIVE,
                    button = args["function"],
                    func = args.can,
                    active_colour = args.colour or G.C.GREEN,
                    action_button = args["function"]
                },
                nodes = {
                    {n = G.UIT.B, config = {w = 0.1, h = 0.6}},
                    {n = G.UIT.C, config = {align = "cm"}, nodes = {
                        {n = G.UIT.R, config = {align = "cm", maxw = minw}, nodes = {
                            {n = G.UIT.T, config = {text = text, colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}}
                        }}
                    }}
                }
            }
        }
    }
end