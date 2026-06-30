local function set_button_state(e, is_enabled, fallback_action)
    if is_enabled then
        e.config.colour = e.config.active_colour or G.C.GREEN
        e.config.button = e.config.action_button or fallback_action
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

local function can_interact_with_card(card)
    if not card or not card.area then return false end
    if (G.play and #G.play.cards > 0) then return false end
    if (G.CONTROLLER and G.CONTROLLER.locked) then return false end
    if (G.GAME and G.GAME.STOP_USE and G.GAME.STOP_USE > 0) then return false end
    return true
end

local function can_use_card(card)
    if not can_interact_with_card(card) then return false end
    local center = card.config and card.config.center
    if not center then return false end
    if type(center.can_use) ~= 'function' then return false end
    return center.can_use(card)
end

local function can_use_deck(card)
    local deck = G.GAME and G.GAME.selected_back
    if not deck or not deck.effect or not deck.effect.center then return false end
    if not can_interact_with_card(card) then return false end
    if type(deck.effect.center.can_use) ~= 'function' then return false end
    return deck.effect.center.can_use(card)
end

G.FUNCS.can_joker_use = function(e)
    set_button_state(e, can_use_card(e.config.ref_table), 'joker_use')
end

G.FUNCS.joker_use = function(e)
    local card = e.config.ref_table
    if not can_use_card(card) then return end
    local center = card.config and card.config.center
    if center and type(center.use) == 'function' then
        center.use(card)
    end
    card.highlighted = false
end

G.FUNCS.can_deck_use = function(e)
    set_button_state(e, can_use_deck(e.config.ref_table), 'deck_use')
end

G.FUNCS.deck_use = function(e)
    local card = e.config.ref_table
    local deck = G.GAME and G.GAME.selected_back
    if not deck or not deck.effect or not deck.effect.center then return end
    if not can_use_deck(card) then return end
    if type(deck.effect.center.use) == 'function' then
        deck.effect.center.use(card)
    end
    card.highlighted = false
end

function build_button(args)
    if not args or not args.card or not args.can or not args["function"] then return nil end

    local card = args.card
    local text = args.text or 'Use'
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