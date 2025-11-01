SMODS.Joker { --Monkey Ace
    key = 'ace',
    name = 'Monkey Ace',
	loc_txt = {
        name = 'Monkey Ace',
        text = {
            'Each {C:attention}Ace{}',
            'held in hand',
            'gives {C:chips}+#1#{} Chips'
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 0 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'ace',
        extra = { chips = 50 } --Variables: chips = +chips

    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and context.other_card:get_id() == 14 and not context.end_of_round then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED
                }
            else
                return {
                    h_chips = card.ability.extra.chips
                }
			end
		end
    end
}

SMODS.Joker { --Exploding Pineapple
    key = 'pineapple',
    name = 'Exploding Pineapple',
    loc_txt = {
        name = 'Exploding Pineapple',
        text = {
            'Destroy all scoring',
            'cards after {C:attention}#1#{} hands',
            '{S:1.1,C:red,E:2}self destructs{}'
        }
    },
    atlas = 'Joker',
	pos = { x = 9, y = 3 },
    rarity = 1,
	cost = 5,
    blueprint_compat = false,
    eternal_compat = false,
    config = {
        base = 'ace',
        extra = { hands = 3 } --Variables: hands = hands remaining
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.hands } }
    end,
    calculate = function(self, card, context)
        if context.destroying_card and card.ability.extra.hands <= 1 and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.3,
                        blockable = false,
                        func = function()
                            G.jokers:remove_card(card)
                            card:remove()
                            card = nil
                            return true;
                        end
                    })) 
                    return true
                end
            }))
            return true
        elseif context.after and card.ability.extra.hands > 1 and not context.blueprint then
            card.ability.extra.hands = card.ability.extra.hands - 1
            return {
                message = localize{type='variable',key='a_chips_minus',vars={1}},
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker { --Neva-Miss Targeting
    key = 'nevamiss',
    name = 'Neva-Miss Targeting',
    loc_txt = {
        name = 'Neva-Miss Targeting',
        text = {
            'Create a {C:tarot}Tarot{} card',
            'if chips scored are',
            'between {C:attention}#1#%{} and {C:attention}#2#%{}',
            'of required chips'
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 6 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'ace',
        extra = { percent_min = 75, percent_max = 125 } --Variables: percent_min = minimum percent of required chips scored, percent_max = maximum percent of required chips scored
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.percent_min, card.ability.extra.percent_max } }
    end,
    calculate = function(self, card, context)
        if context.after and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and
                (hand_chips*mult + G.GAME.chips)/G.GAME.blind.chips >= to_big(card.ability.extra.percent_min / 100.0) and
                (hand_chips*mult + G.GAME.chips)/G.GAME.blind.chips <= to_big(card.ability.extra.percent_max / 100.0) then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'nevamiss')
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                    G.GAME.consumeable_buffer = 0
                    return true
                end)
            }))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
        end
    end
}

SMODS.Joker { --Ground Zero 
    key = 'gz',
    name = 'Ground Zero',
	loc_txt = {
        name = 'Ground Zero',
        text = {
            '{C:chips}+#1#{} chips on',
            '{C:attention}first hand{} of round'
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 9 },
    rarity = 3,
	cost = 7,
    blueprint_compat = true,
    config = {
        base = 'ace',
        extra = { chips = 350 } --Variables: chips = +chips
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function()
                return (G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES)
            end
            juice_card_until(card, eval, true)
        elseif context.joker_main and G.GAME.current_round.hands_played == 0 then
            return {
                chips = card.ability.extra.chips,
            }
        end
    end
}

SMODS.Joker { --Sky Shredder
    key = 'shredder',
    name = 'Sky Shredder',
	loc_txt = {
        name = 'Sky Shredder',
        text = {
            'This Joker gains {X:mult,C:white}X#1#{} Mult after',
            '{C:attention}#2#{C:inactive} [#3#]{} scoring {C:attention}Aces{} are played',
            'Requirement doubles each increment',
            '{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult)',
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 12 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'ace',
        extra = { Xmult = 1, limit = 4, counter = 0, current = 1 } --Variables: Xmult = Xmult gain, limit = aces for next level, counter = aces scored, current = current Xmult
    },

    loc_vars = function(self, info_queue, card)
        local function process_var(count)
			if count == 32 then
				return 'Max!'
			end
			return count
		end
        return { vars = { card.ability.extra.Xmult, card.ability.extra.limit, process_var(card.ability.extra.counter), card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            for k, v in ipairs(context.scoring_hand) do
                if card.ability.extra.counter < 32 and v:get_id() == 14 and not v.debuff then
                    card.ability.extra.counter = card.ability.extra.counter + 1
                    if card.ability.extra.counter >= card.ability.extra.limit then
                        card.ability.extra.current = card.ability.extra.current + 1
                        if card.ability.extra.current < 5 then
                            card.ability.extra.limit = card.ability.extra.limit * 2
                        end
                        return {
                            message = localize('k_upgrade_ex'),
                            colour = G.C.RED,
                            delay = 0.45,
                        }
                    end
                end
            end
        elseif context.joker_main and card.ability.extra.current > 1 then
            return {
                x_mult = card.ability.extra.current
            }
        end
    end
}