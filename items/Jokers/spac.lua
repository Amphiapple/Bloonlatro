SMODS.Joker { --Spike Factory
    key = 'spac',
    name = 'Spike Factory',
    loc_txt = {
        name = 'Spike Factory',
        text = {
            'This joker gains {C:chips}+#1#{}',
            'Chips for every discard',
            'used this round',
            '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)'
        }
    },
    atlas = 'Joker',
	pos = { x = 0, y = 21 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'spac',
        extra = { chips = 25, current = 0 } --Variables: chips = +chips for each discard used, current = current +chips
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card == context.full_hand[#context.full_hand] and not context.blueprint then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.chips
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                colour = G.C.CHIPS,
                delay = 0.45,
            }
        elseif context.joker_main then
            return {
            chips = card.ability.extra.current,
            }
        elseif context.end_of_round and card.ability.extra.current > 0 and not context.individual and not context.repetitionand and not context.blueprint then
            card.ability.extra.current = 0
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker { --Bigger Stacks
    key = 'stacks',
    name = 'Bigger Stacks',
    loc_txt = {
        name = 'Bigger Stacks',
        text = {
            'Earn an extra {C:money}$#1#{}',
            'per unused hand',
            'at end of round',
        }
    },
    atlas = 'Joker',
	pos = { x = 1, y = 21 },
    rarity = 1,
	cost = 5,
    blueprint_compat = false,
    config = {
        base = 'spac',
        extra = { money = 2 } --Variables = money = dollars per unused hands
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calc_dollar_bonus = function(self, card)
        if G.GAME.current_round.hands_left > 0 then
            return card.ability.extra.money * G.GAME.current_round.hands_left
        end
    end,
}

SMODS.Joker { --Smart Spikes
    key = 'smart',
    name = 'Smart Spikes',
    loc_txt = {
        name = 'Smart Spikes',
        text = {
            'This Joker gains {C:mult}+#1#{}',
            'Mult per unused hand',
            '{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)'
        }
    },
    atlas = 'Joker',
	pos = { x = 12, y = 21 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'spac',
        extra = { mult = 1, current = 0 } --Variables: mult = +mult per unused hand, current = current +mult
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.current
            }
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult * G.GAME.current_round.hands_left
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult * G.GAME.current_round.hands_left}}
            }
        end
    end
}

SMODS.Joker { --Long Life Spikes
    key = 'lls',
    name = 'Long Life Spikes',
	loc_txt = {
        name = 'Long Life Spikes',
        text = {
            'This joker gains {C:mult}+#1#{} Mult',
            'for every discarded {C:spades}Spade',
            '{C:mult}-#2#{} Mult at end of round',
            '{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)'
        }
    },
	atlas = 'Joker',
	pos = { x = 13, y = 21 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'spac',
        extra = { mult = 1, loss = 3, current = 0 } --Variables: mult = +mult per spade discarded, current = current +mult, loss = -mult at end of round
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.loss, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card:is_suit('Spades', true) and not context.other_card.debuff and not context.blueprint then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                colour = G.C.MULT,
                delay = 0.45,
            }
        elseif context.joker_main and card.ability.extra.current > 0 then
            return {
            mult = card.ability.extra.current,
            }
        end
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            local loss = card.ability.extra.loss
            if loss > card.ability.extra.current then
                loss = card.ability.extra.current
            end
            card.ability.extra.current = card.ability.extra.current - loss
            return {
                message = localize{type='variable',key='a_mult_minus',vars={loss}},
                colour = G.C.MULT
            }
        end
    end
}

SMODS.Joker { --Spike Storm
    key = 'sporm',
    name = 'Spike Storm',
	loc_txt = {
        name = 'Spike Storm',
        text = {
            'This Joker gains {X:mult,C:white}X#1#{} Mult',
            'per discard and loses {X:mult,C:white}X#1#{}',
            'Mult per hand played',
            '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 21 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'spac',
        extra = { Xmult = 0.2, current = 1 } --Variables: Xmult = Xmult gain/loss, current = current Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card == context.full_hand[#context.full_hand] and not context.blueprint then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.current}},
                colour = G.C.MULT,
                delay = 0.45,
            }
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current,
            }
        elseif context.after and not context.blueprint then
            if card.ability.extra.current - card.ability.extra.Xmult < 1 then
                card.ability.extra.current = 1
            else
                card.ability.extra.current = card.ability.extra.current - card.ability.extra.Xmult
            end
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.current}},
                colour = G.C.MULT,
                delay = 0.45,
            }
        end
    end
}

SMODS.Joker { --Perma-Spike
    key = 'pspike',
    name = 'Perma-Spike',
    loc_txt = {
        name = 'Perma-Spike',
        text = {
            'Carry over up to',
            '{C:attention}#1#{} unused hands',
            'to the next round',
            '{C:inactive}(Currently {C:blue}+#2#{C:inactive} hands)'
        }
    },
    atlas = 'Joker',
	pos = { x = 15, y = 21 },
    rarity = 3,
	cost = 8,
    blueprint_compat = false,
    config = {
        base = 'spac',
        extra = { hands = 5, current = 0 } --Variables: hands = max carryover hands, current = current hands
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.hands, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_hands_played(card.ability.extra.current)
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_hands', vars = {card.ability.extra.current}}})
                    card.ability.extra.current = 0
                    return true
                end
            }))
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            if G.GAME.current_round.hands_left > card.ability.extra.hands then
                card.ability.extra.current = card.ability.extra.hands
            else
                card.ability.extra.current = G.GAME.current_round.hands_left
            end
            return {
                message = localize{type = 'variable', key = 'a_hands', vars = {card.ability.extra.current}}
            }
        end
    end
}