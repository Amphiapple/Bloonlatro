SMODS.Joker { --Spike Factory
    key = 'spike_factory',
    name = 'Spike Factory',
    atlas = 'Joker',
	pos = { x = 0, y = 21 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Spike Factory", category = "support" },
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
        elseif context.end_of_round and card.ability.extra.current > 0 and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = 0
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker { --Bigger Stacks
    key = 'bigger_stacks',
    name = 'Bigger Stacks',
    atlas = 'Joker',
	pos = { x = 1, y = 21 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Spike Factory", category = "support" },
        extra = { chips = 35, current = 0 } --Variables: chips = +chips for each discard used, current = current +chips
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
        elseif context.end_of_round and card.ability.extra.current > 0 and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = 0
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker { --White Hot Spikes
    key = 'white_hot_spikes',
    name = 'whitehot',
    atlas = 'Joker',
	pos = { x = 2, y = 21 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Spike Factory", category = "support" },
        extra = { chips = 90, discards = 0 } --Variables: chips = +chips, discards = discards left
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.discards } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.discards_left == card.ability.extra.discards then
            return {
                chips = card.ability.extra.chips,
            }
        end
    end
}

SMODS.Joker { --Spiked Balls
    key = 'spiked_balls',
    name = 'Spiked Balls',
    atlas = 'Joker',
	pos = { x = 3, y = 21 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Spike Factory", category = "support" },
        extra = { chips = 10, current = 0 } --Variables: chips = +chips per discarded card, current = current chips
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.current,
            }
        elseif context.discard and not context.blueprint then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.chips
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                colour = G.C.CHIPS,
                delay = 0.45,
            }
        elseif context.end_of_round and card.ability.extra.current > 0 and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = 0
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker { --Spiked Mines
    key = 'spiked_mines',
    name = 'Spiked Mines',
    atlas = 'Joker',
	pos = { x = 4, y = 21 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Spike Factory", category = "support" },
        extra = { Xmult = 2 } --Variables: Xmult = Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_left == 0 then
            return {
                x_mult = card.ability.extra.Xmult,
            }
        elseif context.destroying_card and not context.blueprint then
            if G.GAME.current_round.hands_left == 0 then
                return true
            end
            return nil
        end
    end
}

SMODS.Joker { --Super Mines
    key = 'super_mines',
    name = 'Super Mines',
    atlas = 'Joker',
	pos = { x = 5, y = 21 },
    rarity = 3,
	cost = 10,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Spike Factory", category = "support" },
        extra = { Xmult = 5, loss = 0.25, current = 5 } --Variables: Xmult = Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.loss, card.ability.extra.current } }
    end,
    update = function(self, card, dt)
        if G.deck and G.deck.cards then
            if #G.deck.cards > 16 then
                card.ability.extra.current = 1
            else
                card.ability.extra.current = card.ability.extra.Xmult - card.ability.extra.loss * #G.deck.cards
            end
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.current > 1 then
            return {
                x_mult = card.ability.extra.Xmult,
            }
        end
    end
}

SMODS.Joker { --Faster Production
    key = 'faster_production',
    name = 'Faster Production',
    atlas = 'Joker',
	pos = { x = 6, y = 21 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Spike Factory", category = "support" },
        extra = { mult = 5, current = 0 } --Variables: mult = +mult for each discard used, current = current +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card == context.full_hand[#context.full_hand] and not context.blueprint then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                colour = G.C.MULT,
                delay = 0.45,
            }
        elseif context.joker_main then
            return {
                mult = card.ability.extra.current,
            }
        elseif context.end_of_round and card.ability.extra.current > 0 and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = 0
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker { --Even Faster Production
    key = 'even_faster_production',
    name = 'Even Faster Production',
    atlas = 'Joker',
	pos = { x = 7, y = 21 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Spike Factory", category = "support" },
        extra = { mult = 7, current = 0 } --Variables: mult = +mult for each discard used, current = current +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card == context.full_hand[#context.full_hand] and not context.blueprint then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                colour = G.C.MULT,
                delay = 0.45,
            }
        elseif context.joker_main then
            return {
                mult = card.ability.extra.current,
            }
        elseif context.end_of_round and card.ability.extra.current > 0 and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = 0
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}


SMODS.Joker { --MOAB SHREDR
    key = 'moab_shredr',
    name = 'MOAB SHREDR',
	atlas = 'Joker',
	pos = { x = 8, y = 21 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        tower_info = { base = "Spike Factory", category = "support" },
        extra = { Xmult = 0.25, Xmult_boss = 0.5, current = 1 } --Variables: Xmult = Xmult gain/loss, current = current Xmult
    },

    loc_vars = function(self, info_queue, card)
        local function process_var(normal, boss)
			return G.GAME.blind and G.GAME.blind.boss and boss or normal
		end
        return {
            vars = {
                process_var(card.ability.extra.Xmult, card.ability.extra.Xmult_boss),
                card.ability.extra.current
            }
        }
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card == context.full_hand[#context.full_hand] and not context.blueprint then
            if G.GAME.blind.boss then
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult_boss
            else
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult
            end
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.current}},
                colour = G.C.MULT,
                delay = 0.45,
            }
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current,
            }
        elseif context.end_of_round and card.ability.extra.current > 1 and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = 1
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker { --Spike Storm
    key = 'spike_storm',
    name = 'Spike Storm',
	atlas = 'Joker',
	pos = { x = 9, y = 21 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Spike Factory", category = "support" },
        extra = { limit = 4, counter = 4, Xmult = 1.5 } --Variables: limit = number of hands for Xmult, counter = hand index, Xmult = Xmult per card
    },

    loc_vars = function(self, info_queue, card)
        local function process_var(count, cap)
			if count == cap - 1 then
				return 'Active!'
			end
			return cap - count%cap - 1 .. ' remaining'
		end
		return {
			vars = {
                card.ability.extra.Xmult,
                card.ability.extra.limit,
                process_var(card.ability.extra.counter, card.ability.extra.limit),
			},
		}
    end,
    calculate = function(self, card, context)
        if context.before then
            card.ability.extra.counter = (G.GAME.hands_played - card.ability.hands_played_at_create)%(card.ability.extra.limit) + 1
            if not context.blueprint then
                local eval = function()
                    return card.ability.extra.counter == card.ability.extra.limit - 1
                end
                juice_card_until(card, eval, true)
            end
        elseif context.individual and context.cardarea == G.play and card.ability.extra.counter == card.ability.extra.limit then
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --Carpet of Spikes
    key = 'carpet_of_spikes',
    name = 'Carpet of Spikes',
	atlas = 'Joker',
	pos = { x = 10, y = 21 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Spike Factory", category = "support" },
        extra = { Xmult = 1.3, discards = 0 } --Variables: Xmult = Xmult, discards = discards left
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult, card.ability.extra.discards } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and G.GAME.current_round.discards_left == card.ability.extra.discards then
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --Long Reach
    key = 'long_reach',
    name = 'Long Reach',
    atlas = 'Joker',
	pos = { x = 11, y = 21 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Spike Factory", category = "support" },
        extra = { hands = 1 } --Variables: hands = hands gain and discard loss
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.hands } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not (context.blueprint_card or card).getting_sliced then
            G.E_MANAGER:add_event(Event({
                func = function()
                    if G.GAME.current_round.discards_left > 1 then
                        ease_discard(-card.ability.extra.hands)
                    end
                    ease_hands_played(card.ability.extra.hands)
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_hands', vars = {card.ability.extra.hands}}})
                return true end
            }))
            return nil, true
        end
    end
}

SMODS.Joker { --Smart Spikes
    key = 'smart_spikes',
    name = 'Smart Spikes',
    atlas = 'Joker',
	pos = { x = 12, y = 21 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        tower_info = { base = "Spike Factory", category = "support" },
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
    key = 'long_life_spikes',
    name = 'Long Life Spikes',
	atlas = 'Joker',
	pos = { x = 13, y = 21 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        tower_info = { base = "Spike Factory", category = "support" },
        extra = { mult = 1, loss = 3, current = 0 } --Variables: mult = +mult per spade discarded, current = current +mult, loss = -mult at end of round
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,
                localize(G.GAME.current_round.spike_factory_card.suit, 'suits_singular'),
                card.ability.extra.loss,
                card.ability.extra.current,
                colours = {G.C.SUITS[G.GAME.current_round.spike_factory_card.suit]},
            }
        }
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card:is_suit(G.GAME.current_round.spike_factory_card.suit) and not context.other_card.debuff and not context.blueprint then
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

SMODS.Joker { --Deadly Spikes
    key = 'deadly_spikes',
    name = 'Deadly Spikes',
	atlas = 'Joker',
	pos = { x = 14, y = 21 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        tower_info = { base = "Spike Factory", category = "support" },
        extra = { mult = 10, loss = 3, current = 0 } --Variables: mult = +mult per spade discarded, current = current +mult, loss = -mult at end of round
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,
                localize(G.GAME.current_round.spike_factory_card.rank, 'ranks'),
                localize(G.GAME.current_round.spike_factory_card.suit, 'suits_plural'),
                card.ability.extra.loss,
                card.ability.extra.current,
                colours = {G.C.SUITS[G.GAME.current_round.spike_factory_card.suit]},
            }
        }
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card:get_id() == G.GAME.current_round.spike_factory_card.id
                and context.other_card:is_suit(G.GAME.current_round.spike_factory_card.suit) and not context.other_card.debuff and not context.blueprint then
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

SMODS.Joker { --Perma-Spike
    key = 'perma_spike',
    name = 'Perma-Spike',
    atlas = 'Joker',
	pos = { x = 15, y = 21 },
    rarity = 3,
	cost = 8,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Spike Factory", category = "support" },
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
