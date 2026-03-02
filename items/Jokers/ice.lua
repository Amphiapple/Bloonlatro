SMODS.Joker { --Ice Monkey
    key = 'ice_monkey',
    name = 'Ice Monkey',
	loc_txt = {
        name = 'Ice Monkey',
        text = {
            '{C:chips}+#1#{} Chips and',
            '{C:attention}Freeze{} all scoring cards',
            'every {C:attention}#2#{} hands played',
            '{C:inactive}(#3#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 4 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'ice',
        extra = { chips = 40, limit = 3, counter = 3 } --Variables: chips = +chips, limit = number of hands for freeze, counter = hand index
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        local function process_var(count, cap)
			if count == cap - 1 then
				return 'Active!'
			end
			return cap - count%cap - 1 .. ' remaining'
		end
		return {
			vars = {
				card.ability.extra.chips,
				card.ability.extra.limit,
                process_var(card.ability.extra.counter, card.ability.extra.limit)
			},
		}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.counter = (G.GAME.hands_played - card.ability.hands_played_at_create)%(card.ability.extra.limit) + 1
            if not context.blueprint then
                local eval = function()
                    return card.ability.extra.counter == card.ability.extra.limit - 1
                end
                juice_card_until(card, eval, true)
            end
            if card.ability.extra.counter == card.ability.extra.limit then
                for k, v in ipairs(context.scoring_hand) do
                    if not v.debuff then
                        v:set_ability('m_bloons_frozen', nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v:juice_up()
                                return true
                            end
                        }))
                    end
                end
                return {
                    chips = card.ability.extra.chips,
                }
            end
        end
    end
}

SMODS.Joker { --Permafrost
    key = 'permafrost',
    name = 'Permafrost',
	loc_txt = {
        name = 'Permafrost',
        text = {
            '{C:attention}Frozen Cards{}',
            'permanently gain',
            '{C:chips}+#1#{} Hand Chips',
            'when thawed out'
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 4 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    enhancement_gate = 'm_bloons_frozen',
    config = {
        base = 'ice',
        extra = { chips = 20 } --Variables: money = dollars, chips = +chips
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.after then
            for k, v in ipairs(G.hand.cards) do
                if v.ability.name == 'Frozen Card' and not v.debuff then
                    v.ability.perma_h_chips = v.ability.perma_h_chips or 0
                    v.ability.perma_h_chips = v.ability.perma_h_chips + card.ability.extra.chips
                end
            end
        end
    end
}

SMODS.Joker { --Cold Snap
    key = 'cold_snap',
    name = 'Cold Snap',
	loc_txt = {
        name = 'Cold Snap',
        text = {
            '{C:attention}Frozen{} cards',
            'give {C:money}+$1#{} when',
            'thawed out'
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 4 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    enhancement_gate = 'm_bloons_frozen',
    config = {
        base = 'ice',
        extra = { money = 1 } --Variables: money = dollars
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        return { vars = { card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        if context.after then
            for k, v in ipairs(G.hand.cards) do
                if v.ability.name == 'Frozen Card' and not v.debuff then
                    ease_dollars(card.ability.extra.money)
                    card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('$')..card.ability.extra.money,colour = G.C.MONEY, delay = 0.45})
                end
            end
        end
    end
}

SMODS.Joker { --Ice Shards
    key = 'ice_shards',
    name = 'Ice Shards',
	loc_txt = {
        name = 'Ice Shards',
        text = {
            'This {C:attention}Joker{} gains {C:mult}+#1#{}',
            'Mult whenever a {C:attention}Frozen Card{}',
            'thaws out or is destroyed',
            '{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 4 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    perishable_compat = false,
    enhancement_gate = 'm_bloons_frozen',
    config = {
        base = 'ice',
        extra = { mult = 1, current = 0 } --Variables: mult = +mult per thawed frozen card, current = current +mult
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        return { vars = { card.ability.extra.mult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.current
            }
        elseif context.after and not context.blueprint then
            local frozens = 0
            for k, v in ipairs(G.hand.cards) do
                if v.ability.name == 'Frozen Card' then
                    frozens = frozens + 1
                end
            end
            if frozens > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult*frozens
                                return true
                            end
                        }))
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.current + card.ability.extra.mult*frozens}}})
                        return true
                    end
                }))
            end
        elseif context.cards_destroyed and not context.blueprint then
            local frozens = 0
            for k, v in ipairs(context.glass_shattered) do
                if v.ability.name == 'Frozen Card' then
                    frozens = frozens + 1
                end
            end
            if frozens > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult*frozens
                                return true
                            end
                        }))
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.current + card.ability.extra.mult*frozens}}})
                        return true
                    end
                }))
            end
        elseif context.remove_playing_cards and not context.blueprint then
            local frozens = 0
            for k, v in ipairs(context.removed) do
                if v.ability.name == 'Frozen Card' then
                    frozens = frozens + 1
                end
            end
            if frozens > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult*frozens
                                return true
                            end
                        }))
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.current + card.ability.extra.mult*frozens}}})
                        return true
                    end
                }))
            end
        end
    end
}

SMODS.Joker { --Embrittlement
    key = 'embrittlement',
    name = 'Embrittlement',
	loc_txt = {
        name = 'Embrittlement',
        text = {
            'This {C:attention}Joker{} gains',
            '{X:mult,C:white}X#1#{} Mult whenever a',
            '{C:attention}Frozen Card{} is destroyed',
            '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)'
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 4 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    perishable_compat = false,
    enhancement_gate = 'm_bloons_frozen',
    config = {
        base = 'ice',
        extra = { Xmult = 0.5, current = 1 } --Variables: Xmult = Xmult per destroyed frozen card, current = current Xmult
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        return { vars = { card.ability.extra.Xmult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.current
            }
        elseif context.cards_destroyed and not context.blueprint then
            local frozens = 0
            for k, v in ipairs(context.glass_shattered) do
                if v.ability.name == 'Frozen Card' then
                    frozens = frozens + 1
                end
            end
            if frozens > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult*frozens
                                return true
                            end
                        }))
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.current + card.ability.extra.Xmult*frozens}}})
                        return true
                    end
                }))
            end
        elseif context.remove_playing_cards and not context.blueprint then
            local frozens = 0
            for k, v in ipairs(context.removed) do
                if v.ability.name == 'Frozen Card' then
                    frozens = frozens + 1
                end
            end
            if frozens > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult*frozens
                                return true
                            end
                        }))
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.current + card.ability.extra.Xmult*frozens}}})
                        return true
                    end
                }))
            end
        end
    end
}

SMODS.Joker { --Super Brittle
    key = 'super_brittle',
    name = 'Super Brittle',
	loc_txt = {
        name = 'Super Brittle',
        text = {
            '{C:attention}Frozen Cards{} give',
            '{X:mult,C:white}X#1#{} Mult when',
            'held in hand and',
            '{C:green}#2# in #3#{} chance to be destroyed',
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 4 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    enhancement_gate = 'm_bloons_frozen',
    config = {
        base = 'ice',
        extra = { Xmult = 1.5, num = 1, denom = 4 } --Variables: Xmult = Xmult, num/denom = probability fraction
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'super_brittle')
        return { vars = { card.ability.extra.Xmult, n, d } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and context.other_card.ability.name == 'Frozen Card' and not context.end_of_round then
            return {
                x_mult = card.ability.extra.Xmult
            }
        elseif context.destroy_card and context.cardarea == G.hand and not context.blueprint then
            if context.destroy_card.ability.name == 'Frozen Card' and not context.destroy_card.debuff and SMODS.pseudorandom_probability(card, 'super_brittle', card.ability.extra.num, card.ability.extra.denom, 'super_brittle') then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    func = function()
                        context.destroy_card:shatter()
                        return true
                    end
                }))
                return true
            end
            return nil
        end
    end
}

SMODS.Joker { --Enhanced Freeze
    key = 'enhanced_freeze',
    name = 'Enhanced Freeze',
	loc_txt = {
        name = 'Enhanced Freeze',
        text = {
            '{C:chips}+#1#{} Chips and',
            '{C:attention}Freeze{} all scoring cards',
            'every {C:attention}#2#{} hands played',
            '{C:inactive}(#3#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 6, y = 4 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'ice',
        extra = { chips = 40, limit = 2, counter = 2 } --Variables: chips = +chips, limit = number of hands for freeze, counter = hand index
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        local function process_var(count, cap)
			if count == cap - 1 then
				return 'Active!'
			end
			return cap - count%cap - 1 .. ' remaining'
		end
		return {
			vars = {
				card.ability.extra.chips,
				card.ability.extra.limit,
                process_var(card.ability.extra.counter, card.ability.extra.limit)
			},
		}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.counter = (G.GAME.hands_played - card.ability.hands_played_at_create)%(card.ability.extra.limit) + 1
            if not context.blueprint then
                local eval = function()
                    return card.ability.extra.counter == card.ability.extra.limit - 1
                end
                juice_card_until(card, eval, true)
            end
            if card.ability.extra.counter == card.ability.extra.limit then
                for k, v in ipairs(context.scoring_hand) do
                    if not v.debuff then
                        v:set_ability('m_bloons_frozen', nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v:juice_up()
                                return true
                            end
                        }))
                    end
                end
                return {
                    chips = card.ability.extra.chips,
                }
            end
        end
    end
}
SMODS.Joker { --Deep Freeze
    key = 'deep_freeze',
    name = 'Deep Freeze',
	loc_txt = {
        name = 'Deep Freeze',
        text = {
            '{C:attention}Frozen{} cards have',
            'a {C:green}#1# in #2#{} chance',
            'to remain frozen',
        }
    },
	atlas = 'Joker',
	pos = { x = 7, y = 4 },
    rarity = 1,
	cost = 4,
    blueprint_compat = false,
    enhancement_gate = 'm_bloons_frozen',
    config = {
        base = 'ice',
        extra = { num = 1, denom = 2 } --Variables: num/denom = probability fraction
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'deep_freeze')
        return { vars = { n, d } }
    end,
}

SMODS.Joker { --Arctic Wind
    key = 'arctic_wind',
    name = 'Arctic Wind',
	loc_txt = {
        name = 'Arctic Wind',
        text = {
            '{C:attention}+#1#{} hand size',
            '{C:attention}Freeze{} all scoring',
            'cards on {C:attention}first{}',
            '{C:attention}hand{} of round',
        }
    },
	atlas = 'Joker',
	pos = { x = 8, y = 4 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'ice',
        h_size = 1, --Variables: h_size == hand size
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        return { vars = { card.ability.h_size } }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function()
                return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES
            end
            juice_card_until(card, eval, true)
        elseif context.before and G.GAME.current_round.hands_played == 0 and not context.blueprint then
            for k, v in ipairs(context.scoring_hand) do
                if not v.debuff then
                    v:set_ability('m_bloons_frozen', nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:juice_up()
                            return true
                        end
                    }))
                end
            end
        end
    end
}

SMODS.Joker { --Snowstorm
    key = 'snowstorm',
    name = 'Snowstorm',
	loc_txt = {
        name = 'Snowstorm',
        text = {
            '{C:attention}Freeze{} all scoring cards',
            'on {C:attention}first hand{} of round, gain',
            '{C:attention}+#1#{} hand size this round',
            'per {C:attention}#2#{} cards frozen',
        }
    }, 
	atlas = 'Joker',
	pos = { x = 9, y = 4 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'ice',
        extra = { hand_size = 1, rate = 2 } --Variables: hand_size = extra hand size, rate = hand size rate
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        return { vars = { card.ability.extra.hand_size, card.ability.extra.rate } }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function()
                return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES
            end
            juice_card_until(card, eval, true)
        elseif context.before and G.GAME.current_round.hands_played == 0 and not context.blueprint then
            local count = 0
            for k, v in ipairs(context.scoring_hand) do
                if not v.debuff then
                    count = count + 1
                    v:set_ability('m_bloons_frozen', nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:juice_up()
                            return true
                        end
                    }))
                end
            end
            count = math.floor(count / 2)
            G.hand:change_size(card.ability.extra.hand_size * count)
            G.GAME.round_resets.temp_handsize = (G.GAME.round_resets.temp_handsize or 0) + card.ability.extra.hand_size * count
            return {
                message = localize({ type = "variable", key = "a_handsize", vars = {card.ability.extra.hand_size * count}}),
                colour = G.C.FILTER,
            }
		elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker { --Absolute Zero
    key = 'absolute_zero',
    name = 'Absolute Zero',
	loc_txt = {
        name = 'Absolute Zero',
        text = {
            '{C:attention}Frozen{} cards permanently',
            'gain {X:mult,C:white}X#1#{} Mult',
            'when thawed out',
        }
    },
	atlas = 'Joker',
	pos = { x = 10, y = 4 },
    rarity = 3,
	cost = 7,
    blueprint_compat = true,
    enhancement_gate = 'm_bloons_frozen',
    config = {
        base = 'ice',
        extra = { Xmult = 0.25 } --Variables: Xmult = Xmult gain
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.after then
            for k, v in ipairs(G.hand.cards) do
                if v.ability.name == 'Frozen Card' and not v.debuff then
                    v.ability.perma_h_x_mult = v.ability.perma_h_x_mult or 1
                    v.ability.perma_h_x_mult = v.ability.perma_h_x_mult + card.ability.extra.Xmult
                end
            end
        end
    end
}

SMODS.Joker { --Larger Radius
    key = 'larger_radius',
    name = 'Larger Radius',
    loc_txt = {
        name = 'Larger Radius',
        text = {
            '{C:mult}+#1#{} Mult and',
            '{C:attention}Freeze{} all scoring cards',
            'every {C:attention}#2#{} hands played',
            '{C:inactive}(#3#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 11, y = 4 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'ice',
        extra = { mult = 10, limit = 3, counter = 3 } --Variables: mult = +mult, limit = number of hands for freeze, counter = hand index
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        local function process_var(count, cap)
			if count == cap - 1 then
				return 'Active!'
			end
			return cap - count%cap - 1 .. ' remaining'
		end
		return {
			vars = {
				card.ability.extra.mult,
				card.ability.extra.limit,
                process_var(card.ability.extra.counter, card.ability.extra.limit)
			},
		}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.counter = (G.GAME.hands_played - card.ability.hands_played_at_create)%(card.ability.extra.limit) + 1
            if not context.blueprint then
                local eval = function()
                    return card.ability.extra.counter == card.ability.extra.limit - 1
                end
                juice_card_until(card, eval, true)
            end
            if card.ability.extra.counter == card.ability.extra.limit then
                for k, v in ipairs(context.scoring_hand) do
                    if not v.debuff then
                        v:set_ability('m_bloons_frozen', nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v:juice_up()
                                return true
                            end
                        }))
                    end
                end
                return {
                    mult = card.ability.extra.mult,
                }
            end
        end
    end
}

SMODS.Joker { --Re-freeze
    key = 're_freeze',
    name = 'Re-Freeze',
    loc_txt = {
        name = 'Re-Freeze',
        text = {
            'Retrigger {C:attention}Frozen Cards{}',
            'held in hand'
        }
    },
    atlas = 'Joker',
	pos = { x = 12, y = 4 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    enhancement_gate = 'm_bloons_frozen',
    config = {
        base = 'ice',
        extra = { retrigger = 1 } --Variables = retrigger = retrigger amount
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.hand and context.other_card.ability.name == 'Frozen Card' then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger
            }
        end
    end
}

SMODS.Joker { --Cryo Cannon
    key = 'cryo_cannon',
    name = 'Cryo Cannon',
    loc_txt = {
        name = 'Cryo Cannon',
        text = {
            '{C:attention}Frozen Cards{} give {C:mult}+#1#{}',
            'Mult when held in hand',
            '{C:green}#2# in #3#{} chance to',
            '{C:attention}Freeze discarded{} cards'
        }
    },
	atlas = 'Joker',
	pos = { x = 13, y = 4 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'ice',
        extra = { mult = 10, num = 1, denom = 3 } --Variables: mult = +mult, num/denom = probability fraction
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'cryo_cannon')
        return { vars = { card.ability.extra.mult, n, d } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and context.other_card.ability.name == 'Frozen Card' and not context.end_of_round then
            return {
                mult = card.ability.extra.mult
            }
        elseif context.discard and not context.other_card.debuff and SMODS.pseudorandom_probability(card, 'cryo_cannon', card.ability.extra.num, card.ability.extra.denom, 'cryo_cannon') then
            context.other_card:set_ability('m_bloons_frozen', nil, true)
            return {
                message = 'Freeze!',
                colour = G.C.CHIPS
            }
        end
    end
}

SMODS.Joker { --Icicles
    key = 'icicles',
    name = 'Icicles',
    loc_txt = {
        name = 'Icicles',
        text = {
            '{C:attention}Frozen Cards{} give {X:mult,C:white}X#1#{}',
            'Mult when held in hand',
            '{C:green}#2# in #3#{} chance to',
            '{C:attention}Freeze discarded{} cards'
        }
    },
	atlas = 'Joker',
	pos = { x = 14, y = 4 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'ice',
        extra = { Xmult = 1.3, num = 1, denom = 2 } --Variables: Xmult = Xmult, num/denom = probability fraction
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'icicles')
        return { vars = { card.ability.extra.Xmult, n, d } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and context.other_card.ability.name == 'Frozen Card' and not context.end_of_round then
            return {
                x_mult = card.ability.extra.Xmult
            }
        elseif context.discard and not context.other_card.debuff and SMODS.pseudorandom_probability(card, 'icicles', card.ability.extra.num, card.ability.extra.denom, 'icicles') then
            context.other_card:set_ability('m_bloons_frozen', nil, true)
            return {
                message = 'Freeze!',
                colour = G.C.CHIPS
            }
        end
    end
}

SMODS.Joker { --Icicle Impale
    key = 'icicle_impale',
    name = 'Icicle Impale',
    loc_txt = {
        name = 'Icicle Impale',
        text = {
            '{X:mult,C:white}X#1#{} Mult if {C:attention}Frozen{}',
            '{C:attention}Cards{} are held in hand',
            '{C:attention}Freeze{} all {C:attention}discarded{} cards',
        }
    },
	atlas = 'Joker',
	pos = { x = 15, y = 4 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        base = 'ice',
        extra = { Xmult = 2 } --Variables: Xmult = Xmult, num/denom = probability fraction
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            for k, v in ipairs(G.hand.cards) do
                if v.ability.name == 'Frozen Card' and not v.debuff then
                    return {
                        x_mult = card.ability.extra.Xmult
                    }
                end
            end
        elseif context.discard and not context.other_card.debuff then
            context.other_card:set_ability('m_bloons_frozen', nil, true)
            return {
                message = 'Freeze!',
                colour = G.C.CHIPS
            }
        end
    end
}
