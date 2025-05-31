-- Forced messages for evaluation
local function event(config)
    local e = Event(config)
    G.E_MANAGER:add_event(e)
    return e
end

local function forced_message(message, card, color, delay)
    if delay == true then
        delay = 1
    elseif delay == nil then
        delay = 0
    end

    event({trigger = 'before', delay = delay, func = function()

        card_eval_status_text(
            card,
            'extra',
            nil, nil, nil,
            {message = message, colour = color, instant = true}
        )
        return true
    end})
end

SMODS.Atlas{
    key = 'Joker',
    path = 'jokers.png',
    px = 71,
    py = 95,
}

SMODS.Joker { --Dart
    name = "Dart Monkey",
	key = "dart",
	loc_txt = {
        name = 'Dart Monkey',
        text = {
            '{C:chips}+#1#{} Chips',
            '{C:mult}+#2#{} Mult',
        }
    },
	atlas = "Joker",
	pos = { x = 0, y = 0 },
    rarity = 1,
	cost = 2,
	order = 151,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { chips = 20, mult = 2} },
    loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.extra.chips, center.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            hand_chips = mod_chips(hand_chips + card.ability.extra.chips)
            update_hand_text( { delay = 0 }, { chips = hand_chips } )
            forced_message('+'..tostring(card.ability.extra.chips), card, G.C.CHIPS, true)
            return {
                message = '+' .. card.ability.extra.mult,
                mult_mod = card.ability.extra.mult,
                colour = G.C.MULT,
            }
        end
    end,
}

SMODS.Joker { --Boomer
    name = "Boomerang Monkey",
	key = "boomer",
	loc_txt = {
        name = 'Boomerang Monkey',
        text = {
            'Retrigger {C:attention}first{} card',
            'held in hand',
            '{C:attention}#1#{} additional times',
        }
    },
	atlas = "Joker",
	pos = { x = 1, y = 0 },
    rarity = 1,
	cost = 4,
	order = 152,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = 2 },
    loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.extra} }
    end,
    calculate = function(self, card, context)
        if context.repetition then
            if context.cardarea == G.hand and context.other_card == G.hand.cards[1] then
                if (next(context.card_effects[1]) or #context.card_effects > 1) then
                    return {
                        message = "Again!",
                        repetitions = card.ability.extra,
                    }
                end
            end
        end
    end,
}

SMODS.Joker { --Bomb
    name = "Bomb Shooter",
	key = "bomb",
	loc_txt = {
        name = 'Bomb Shooter',
        text = {
            'Played cards give',
            '{C:chips}+#1#{} Chips when scored',
        }
    },
	atlas = "Joker",
	pos = { x = 2, y = 0 },
    rarity = 1,
	cost = 5,
	order = 153,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { chips = 20} },
    loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.extra.chips} }
    end,
    calculate = function(self, card, context)
        if context.individual then
			if context.cardarea == G.play then
				return {
                    message = '+' .. card.ability.extra.chips,
					chip_mod = card.ability.extra.chips,
					colour = G.C.CHIPS,
				}
			end
		end
    end,
}

SMODS.Joker { --Tack
    name = "Tack Shooter",
	key = "tack",
	loc_txt = {
        name = 'Tack Shooter',
        text = {
            'Each played {C:attention}8{} gives',
            '{C:chips}+#1#{} Chips and',
            '{C:mult}+#2#{} Mult when scored',
        }
    },
	atlas = "Joker",
	pos = { x = 3, y = 0 },
    rarity = 1,
	cost = 4,
	order = 154,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { chips = 25, mult = 2} },
    loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.extra.chips, center.ability.extra.mult} }
    end,
    calculate = function(self, card, context)
        if context.individual then
			if context.cardarea == G.play and context.other_card:get_id() == 8 then
                hand_chips = mod_chips(hand_chips + card.ability.extra.chips)
                update_hand_text( { delay = 0 }, { chips = hand_chips } )
                forced_message('+'..tostring(card.ability.extra.chips), context.other_card, G.C.CHIPS, true)
				return {
                    message = '+' .. card.ability.extra.mult,
					mult_mod = card.ability.extra.mult,
					colour = G.C.MULT,
				}
			end
		end
    end,
}

SMODS.Joker { --Sniper
    name = "Sniper Monkey",
	key = "sniper",
	loc_txt = {
        name = 'Sniper Monkey',
        text = {
            '{C:mult}+#1#{} Mult every',
            '{C:attention}#2#{} hands',
            '{C:inactive}#3#',
        }
    },
	atlas = "Joker",
	pos = { x = 6, y = 0 },
    rarity = 1,
	cost = 5,
	order = 157,
	blueprint_compat = true,
    unlocked = true,

    config = { 
        extra = { mult = 20 },
        limit = 2,
        counter = 2,
    },
    loc_vars = function(self, info_queue, center)
        local function process_var(count, cap)
			if count == cap - 1 then
				return "Active!"
			end
			return cap - count%cap - 1 .. " remaining"
		end
		return {
			vars = {
				center.ability.extra.mult,
				center.ability.limit,
                process_var(center.ability.counter, center.ability.limit),
			},
		}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.counter = (G.GAME.hands_played - card.ability.hands_played_at_create)%(card.ability.limit) + 1
            if context.blueprint then
                if card.ability.counter == card.ability.limit then
                    return {
                        message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                        mult_mod = card.ability.extra.mult
                    }
                end
            elseif card.ability.counter == card.ability.limit then
                return {
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                    mult_mod = card.ability.extra.mult,
                    colour = G.C.MULT,
                }
            end
        end
    end,
}

SMODS.Joker { --Sub
    name = "Monkey Sub",
	key = "sub",
	loc_txt = {
        name = 'Monkey Sub',
        text = {
            'Each card',
            'held in hand',
            'gives {C:mult}+#1#{} Mult',
        }
    },
	atlas = "Joker",
	pos = { x = 7, y = 0 },
    rarity = 1,
	cost = 4,
	order = 158,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { mult = 2 } },
    loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and not context.end_of_round then
			if context.cardarea == G.hand then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED,
                    }
                else
                    return {
                        h_mult = card.ability.extra.mult,
                    }
                end
			end
		end
    end,
}

SMODS.Joker { --Ace
    name = "Monkey Ace",
	key = "ace",
	loc_txt = {
        name = 'Monkey Ace',
        text = {
            'Each {C:attention}Ace{}',
            'held in hand',
            'gives {C:chips}+#1#{} Chips',
        }
    },
	atlas = "Joker",
	pos = { x = 9, y = 0 },
    rarity = 2,
	cost = 6,
	order = 160,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { chips = 80 } },
    loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.individual and not context.end_of_round then
			if context.cardarea == G.hand and context.other_card:get_id() == 14 then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED,
                    }
                else
                    return {
                        h_chips = card.ability.extra.chips,
                    }
                end
			end
		end
    end,
}

SMODS.Joker { --Heli
    name = "Heli Pilot",
	key = "heli",
	loc_txt = {
        name = 'Heli Pilot',
        text = {
            'Last played {C:attention}number{}',
            'card gives {X:mult,C:white}X#1#{} Mult',
            'when scored',
        }
    },
	atlas = "Joker",
	pos = { x = 0, y = 1 },
    rarity = 2,
	cost = 6,
	order = 161,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { Xmult = 2} },
    loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.extra.Xmult} }
    end,
    calculate = function(self, card, context)
        if context.individual then
			if context.cardarea == G.play then
                local last_number = nil
                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i]:get_id() >= 0 and
                        (context.scoring_hand[i]:get_id() <= 10 or
                        context.scoring_hand[i]:get_id() == 14) then
                        last_number = context.scoring_hand[i];
                    end
                end
                if context.other_card == last_number then
                    return {
                        x_mult = card.ability.extra.Xmult,
                        colour = G.C.MULT,
                    }
                end
            end
		end
    end,
}

SMODS.Joker { --Mortar
    name = "Mortar Monkey",
	key = "mortar",
	loc_txt = {
        name = 'Mortar Monkey',
        text = {
            '{C:green}1 in 3{} chance for',
            'played cards to give',
            '{C:mult}+#1#{} Mult when scored',
        }
    },
	atlas = "Joker",
	pos = { x = 1, y = 1 },
    rarity = 1,
	cost = 5,
	order = 162,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { mult = 8 }, hit_rate = 0.333 },
    loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.extra.mult} }
    end,
    calculate = function(self, card, context)
        if context.individual then
			if context.cardarea == G.play then
                local crit_poll = pseudorandom(pseudoseed("cry_critical"))
			    crit_poll = crit_poll / (G.GAME.probabilities.normal or 1)
			    if crit_poll < self.config.hit_rate then
                    return {
                        message = '+' .. card.ability.extra.mult,
                        mult_mod = card.ability.extra.mult,
                        colour = G.C.MULT,
                    }
                end
			end
		end
    end,
}

SMODS.Joker { --Dartling
    name = "Dartling Gunner",
	key = "dartling",
	loc_txt = {
        name = 'Dartling Gunner',
        text = {
            '{C:chips}+???{} Chips',
        }
    },
	atlas = "Joker",
	pos = { x = 2, y = 1 },
    rarity = 1,
	cost = 5,
	order = 163,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { max = 123, min = 0 } },
    calculate = function(self, card, context)
        if context.joker_main then
            local temp_Chips = pseudorandom('misprint', card.ability.extra.min, card.ability.extra.max)
            return {
                message = localize{type='variable',key='a_chips',vars={temp_Chips}},
                chip_mod = temp_Chips
            }
		end
    end,
}

SMODS.Joker { --Wizard
    name = "Wizard Monkey",
	key = "wiz",
	loc_txt = {
        name = 'Wizard Monkey',
        text = {
            'First played {C:attention}number{}',
            'card gains',
            'when scored',
        }
    },
	atlas = "Joker",
	pos = { x = 0, y = 1 },
    rarity = 2,
	cost = 6,
	order = 161,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { Xmult = 2} },
    loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.extra.Xmult} }
    end,
    calculate = function(self, card, context)
        if context.individual then
			if context.cardarea == G.play then
                if context.other_card == context.scoring_hand[#context.scoring_hand] then
                    return {
                        x_mult = card.ability.extra.Xmult,
                        colour = G.C.MULT,
                    }
                end
            end
		end
    end,
}

SMODS.Joker { --Dprec
    name = "Deadly Precision",
	key = "dprec",
	loc_txt = {
        name = 'Deadly Precision',
        text = {
            '{X:mult,C:white}X#1#{} Mult every',
            '{C:attention}#2#{} hands',
            '{C:inactive}#3#',
        }
    },
	atlas = "Joker",
	pos = { x = 0, y = 3 },
    rarity = 2,
	cost = 7,
	order = 206,
	blueprint_compat = true,
    unlocked = true,

    config = { 
        extra = { Xmult = 3 },
        limit = 3,
        counter = 3,
    },
    loc_vars = function(self, info_queue, center)
        local function process_var(count, cap)
			if count == cap - 1 then
				return "Active!"
			end
			return cap - count%cap - 1 .. " remaining"
		end
		return {
			vars = {
				center.ability.extra.Xmult,
				center.ability.limit,
                process_var(center.ability.counter, center.ability.limit),
			},
		}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.counter = (G.GAME.hands_played - card.ability.hands_played_at_create)%(card.ability.limit) + 1
            if context.blueprint then
                if card.ability.counter == card.ability.limit then
                    return {
                        message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                        Xmult_mod = card.ability.extra.Xmult
                    }
                end
            elseif card.ability.counter == card.ability.limit then
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                    Xmult_mod = card.ability.extra.Xmult,
                    colour = G.C.MULT,
                }
            end
        end
    end,
}

SMODS.Joker { --Buckshot
    name = "Buckshot",
	key = "buckshot",
	loc_txt = {
        name = 'Buckshot',
        text = {
            '{X:mult,C:white}X?.?{} Mult',
        }
    },
	atlas = "Joker",
	pos = { x = 6, y = 3 },
    rarity = 2,
	cost = 8,
	order = 212,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { max = 33, min = 10 } },
    calculate = function(self, card, context)
        if context.joker_main then
            local temp_Xmult = pseudorandom('misprint', card.ability.extra.min, card.ability.extra.max) / 10.0
            return {
                message = localize{type='variable',key='a_xmult',vars={temp_Xmult}},
                Xmult_mod = temp_Xmult
            }
		end
    end,
}