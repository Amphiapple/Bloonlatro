SMODS.Joker { --Sniper Monkey
    key = 'sniper',
    name = 'Sniper Monkey',
	loc_txt = {
        name = 'Sniper Monkey',
        text = {
            '{C:mult}+#1#{} Mult every',
            '{C:attention}#2#{} hands played',
            '{C:inactive}(#3#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 7 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'sniper',
        extra = { mult = 20, limit = 2, counter = 2 } --Variables: mult = +mult, limit = number of hands for +mult, counter = hand index
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
                return {
                    mult = card.ability.extra.mult,
                }
            end
        end
    end
}

SMODS.Joker { --Shrapnel Shot
    key = 'shraps',
    name = 'Shrapnel Shot',
    loc_txt = {
        name = 'Shrapnel Shot',
        text = {
            '{C:attention}Last{} played card',
            'gives Mult equal to',
            'the rank of the previous',
            'card when scored'
        }
    },
    atlas = 'Joker',
	pos = { x = 7, y = 7 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'sniper',
    },

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and #context.scoring_hand > 1 and
                context.other_card == context.scoring_hand[#context.scoring_hand] and
                not SMODS.has_no_rank(context.scoring_hand[#context.scoring_hand-1]) then
            local last_number = context.scoring_hand[#context.scoring_hand-1].base.nominal
            return {
                mult = last_number
            }
        end
    end
}

SMODS.Joker { --Deadly Precision
    key = 'dprec',
    name = 'Deadly Precision',
	loc_txt = {
        name = 'Deadly Precision',
        text = {
            '{X:mult,C:white}X#1#{} Mult every',
            '{C:attention}#2#{} hands played',
            '{C:inactive}(#3#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 7 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        base = 'sniper',
        extra = { Xmult = 3, limit = 3, counter = 3 } --Variables: Xmult = Xmult, limit = number of hands for Xmult, counter = hand index
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
        if context.joker_main then
            card.ability.extra.counter = (G.GAME.hands_played - card.ability.hands_played_at_create)%(card.ability.extra.limit) + 1
            if not context.blueprint then
                local eval = function()
                    return card.ability.extra.counter == card.ability.extra.limit - 1
                end
                juice_card_until(card, eval, true)
            end
            if card.ability.extra.counter == card.ability.extra.limit then
                return {
                    x_mult = card.ability.extra.Xmult,
                }
            end
        end
    end
}

SMODS.Joker { --Supply Drop
    key = 'supply',
    name = 'Supply Drop',
    loc_txt = {
        name = 'Supply Drop',
        text = {
            'Create a {C:dark_edition}Negative {C:tarot}Tarot{}',
            'card every {C:attention}#1#{} hands played',
            '{C:inactive}(#2#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 7 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        base = 'sniper',
        extra = { limit = 4, counter = 4 } --Variables: Xmult = Xmult, limit = number of hands for Xmult, counter = hand index
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
        local function process_var(count, cap)
			if count == cap - 1 then
				return 'Active!'
			end
			return cap - count%cap - 1 .. ' remaining'
		end
		return {
			vars = {
				card.ability.extra.limit,
                process_var(card.ability.extra.counter, card.ability.extra.limit),
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
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, 'supply')
                        card:set_edition({negative = true}, true)
                        card:add_to_deck()
                        G.consumeables:emplace(card) 
                        return true
                    end}))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
            end
        end
    end
}

SMODS.Joker { --Elite Defender
    key = 'edef',
    name = 'Elite Defender',
    loc_txt = {
        name = 'Elite Defender',
        text = {
            '{X:mult,C:white}X#1#{} after {C:attention}first hand{} of round',
            '{X:mult,C:white}X#2#{} on {C:attention}final hand{} of round,',
            '{X:mult,C:white}X#3#{} on {C:attention}final hand{} of round if',
            'chips scored are under',
            '{C:attention}25%{} of required chips'
        }
    },
	atlas = 'Joker',
	pos = { x = 15, y = 7 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        base = 'sniper',
        extra = { Xmult1 = 1.5, Xmult2 = 2, Xmult3 = 4 } --Variables: Xmult1 = Xmult after first hand, Xmult2 = Xmult on final hand, Xmult3 = XMult if under 25%
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult1, card.ability.extra.Xmult2, card.ability.extra.Xmult3 } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if G.GAME.current_round.hands_left == 0 then
                if G.GAME.chips/G.GAME.blind.chips <= to_big(0.25) then
                    return {
                        x_mult = card.ability.extra.Xmult3
                    }
                else
                    return {
                        x_mult = card.ability.extra.Xmult2
                    }
                end
            elseif G.GAME.current_round.hands_played > 0 then
                return {
                    x_mult = card.ability.extra.Xmult1
                }
            end
        end
    end
}
