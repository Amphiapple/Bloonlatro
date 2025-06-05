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

    config = { extra = { chips = 30, mult = 3} },
    loc_vars = function(self, info_queue, center)
        --Variables: chips = +chips, mult = +mult
        return { vars = { center.ability.extra.chips, center.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                h_chips = card.ability.extra.chips,
                h_mult = card.ability.extra.mult,
                colour = G.C.MULT
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
        --Variables: extra = retrigger amount
        return { vars = { center.ability.extra} }
    end,
    calculate = function(self, card, context)
        if context.repetition then
            if context.cardarea == G.hand and context.other_card == G.hand.cards[1] then
                if (next(context.card_effects[1]) or #context.card_effects > 1) then
                    return {
                        message = localize('k_again_ex'),
                        repetitions = card.ability.extra
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
            'Played {C:attention}Steel{} cards give',
            '{X:mult,C:white}X#1#{} Mult when scored',
        }
    },
	atlas = "Joker",
	pos = { x = 2, y = 0 },
    rarity = 1,
	cost = 5,
	order = 153,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { Xmult = 1.5 } },
    loc_vars = function(self, info_queue, center)
        --Variables: Xmult = Xmult
        return { vars = { center.ability.extra.Xmult} }
    end,
    calculate = function(self, card, context)
        if context.individual then
			if context.cardarea == G.play and context.other_card.ability.name == 'Steel Card' then
                return {
                    x_mult = card.ability.extra.Xmult
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

    config = { extra = { chips = 40, mult = 4} },
    loc_vars = function(self, info_queue, center)
        --Variables: chips = +chips, mult = +mult
        return { vars = { center.ability.extra.chips, center.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual then
			if context.cardarea == G.play and context.other_card:get_id() == 8 then
				return {
                    h_chips = card.ability.extra.chips,
					h_mult = card.ability.extra.mult,
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
	cost = 4,
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
        --Variables: mult = +mult, limit = number of hands for +mult, counter = hand index
		return {
			vars = {
				center.ability.extra.mult,
				center.ability.limit,
                process_var(center.ability.counter, center.ability.limit)
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
                    colour = G.C.MULT
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
    --Variables: mult = +mult
    loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and not context.end_of_round then
			if context.cardarea == G.hand then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED
                    }
                else
                    return {
                        h_mult = card.ability.extra.mult
                    }
                end
			end
		end
    end,
}

SMODS.Joker { --Boat
    name = "Monkey Buccaneer",
	key = "boat",
	loc_txt = {
        name = 'Monkey Buccaneer',
        text = {
            'Earn {C:money}$#1#{} for every {C:money}$#2#{} of',
            'sell value of all other owned',
            '{C:attention}Jokers{} at end of round',
            '{C:inactive}(Currently {C:money}$#3#{C:inactive}){}',
        }
    },
	atlas = "Joker",
	pos = { x = 7, y = 0 },
    rarity = 1,
	cost = 5,
	order = 159,
	blueprint_compat = false,
    unlocked = true,

    config = { extra = { money = 1, rate = 3, current = 0 } },
    loc_vars = function(self, info_queue, center)
        if G.STAGE == G.STAGES.RUN then
            local sell_cost = 0
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= center and (G.jokers.cards[i].area == G.jokers) then
                    sell_cost = sell_cost + G.jokers.cards[i].sell_cost
                end
            end
            center.ability.extra.current = center.ability.extra.money * math.floor(sell_cost / center.ability.extra.rate)
        end
        --Variables: money = end of round dollars oer rate, rate = sell cost required for money, current = current end of round dollars
        return { vars = { center.ability.extra.money, center.ability.extra.rate, center.ability.extra.current } }
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.current
    end
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
        --Variables: chips = +chips
        return { vars = { center.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.individual and not context.end_of_round then
			if context.cardarea == G.hand and context.other_card:get_id() == 14 then
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
    end,
}

SMODS.Joker { --Heli
    name = "Heli Pilot",
	key = "heli",
	loc_txt = {
        name = 'Heli Pilot',
        text = {
            '{C:attention}Last{} played {C:attention}number{}',
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

    config = { extra = { Xmult = 2 } },
    loc_vars = function(self, info_queue, center)
        --Variables: Xmult = Xmult
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
                        last_number = context.scoring_hand[i]
                    end
                end
                if context.other_card == last_number then
                    return {
                        x_mult = card.ability.extra.Xmult,
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
            '{C:green}#1# in #2#{} chance for',
            'played cards to give',
            '{C:mult}+#3#{} Mult when scored',
        }
    },
	atlas = "Joker",
	pos = { x = 1, y = 1 },
    rarity = 1,
	cost = 5,
	order = 162,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { odds = 2, mult = 8 }, },
    loc_vars = function(self, info_queue, center)
        --Variables: odds = probability cases, mult = +mult
        return { vars = { G.GAME.probabilities.normal or 1, center.ability.extra.odds, center.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual then
			if context.cardarea == G.play then
                if pseudorandom('bloodstone') < G.GAME.probabilities.normal/card.ability.extra.odds then
                    return {
                        message = '+' .. card.ability.extra.mult,
                        mult_mod = card.ability.extra.mult,
                        colour = G.C.MULT
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
	pos = { x = 2, y = 4 },
    rarity = 1,
	cost = 5,
	order = 163,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { max = 150, min = 0 } },
    --Variables: max = max possible +chips, min = min possible +chips
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

SMODS.Joker { --Wiz
    name = "Wizard Monkey",
	key = "wiz",
	loc_txt = {
        name = 'Wizard Monkey',
        text = {
            'Add a random ',
            '{C:attention}Enhancement{} to first played',
            'card when scored',
        }
    },
	atlas = "Joker",
	pos = { x = 3, y = 1 },
    rarity = 1,
	cost = 4,
	order = 164,
	blueprint_compat = false,
    unlocked = true,

    config = { },
    --Variables:
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.scoring_hand[1].debuff then
            local enhancement = pseudorandom_element({ 'm_bonus', 'm_mult', 'm_wild', 'm_glass', 'm_steel', 'm_stone', 'm_gold', 'm_lucky' }, pseudoseed("cry_brittle"))
            context.scoring_hand[1]:set_ability(G.P_CENTERS[enhancement], nil, true)
            G.E_MANAGER:add_event(Event({
                func = function()
                    context.scoring_hand[1]:juice_up()
                    return true
                end
            })) 
            return {
                message = 'Magic',
                colour = G.C.MONEY
            }
        end
    end,
}

SMODS.Joker { --Jugg
    name = "Juggernaut",
	key = "jugg",
	loc_txt = {
        name = 'Juggernaut',
        text = {
            'Each played card gives',
            '{C:mult}+#1#{} more Mult when scored',
        }
    },
	atlas = "Joker",
	pos = { x = 0, y = 0 },
    rarity = 2,
	cost = 7,
	order = 151,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { mult = 2, current = 0 } },
    loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.extra.mult, center.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.individual then
			if context.cardarea == G.play then
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult
                return {
                    h_mult = card.ability.extra.current
                }
            end
		elseif context.after then
            card.ability.extra.current = 0
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
	pos = { x = 6, y = 3 },
    rarity = 2,
	cost = 7,
	order = 187,
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
        --Variables: Xmult = Xmult, limit = number of hands for Xmult, counter = hand index
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
                    colour = G.C.MULT
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
	pos = { x = 2, y = 4 },
    rarity = 2,
	cost = 8,
	order = 192,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { max = 33, min = 10 } },
    --Variables: max = max possible Xmult *10, min = min possible Xmult *10
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

SMODS.Joker { --Amast
    name = "Arcane Mastery",
	key = "amast",
	loc_txt = {
        name = 'Arcane Mastery',
        text = {
            'Retrigger all played',
            'cards with {C:attention}Enhancements{}',
        }
    },
	atlas = "Joker",
	pos = { x = 3, y = 1 },
    rarity = 2,
	cost = 7,
	order = 193,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = 1},
    loc_vars = function(self, info_queue, center)
        --Variables: extra = retrigger amount
        return { vars = { center.ability.extra } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card.config.center ~= G.P_CENTERS.c_base then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra
            }
        end
    end,
}

SMODS.Joker { --DoW
    name = "Druid of Wrath",
	key = "dow",
	loc_txt = {
        name = 'Druid of Wrath',
        text = {
            'This Joker gains {X:mult,C:white}X#1#{}',
            'Mult for every hand',
            'played this round',
            '{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)',
        }
    },
	atlas = "Joker",
	pos = { x = 7, y = 4 },
    rarity = 2,
	cost = 6,
	order = 197,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { Xmult = 0.5, current = 1 } },
    loc_vars = function(self, info_queue, center)
        --Variables: Xmult = Xmult gain for each hand, current = current Xmult
        return { vars = { center.ability.extra.Xmult, center.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.current,
            }
        elseif context.after then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult
            return {
                message = 'Wrath',
                colour = G.C.RED,
                delay = 0.45
            }
        elseif context.end_of_round then
            if card.ability.set == "Joker" and card.ability.extra.current > 1 then
                card.ability.extra.current = 1
                return {
                    message = localize('k_reset'),
                    colour = G.C.RED
                }
            end
        end
    end,
}

SMODS.Joker { --GMN
    name = "Grandmaster Ninja",
	key = "gmn",
	loc_txt = {
        name = 'Grandmaster Ninja',
        text = {
            'Has {C:mult}+{X:mult,C:white}X#1#{} Mult for',
            'each scoring {C:diamonds}Diamond{}',
            'in played {C:attention}poker hand{}',
        }
    },
	atlas = "Joker",
	pos = { x = 5, y = 4 },
    rarity = 3,
	cost = 9,
	order = 215,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { Xmult = 0.5 } },
    loc_vars = function(self, info_queue, center)
        --Variables: Xmult = +Xmult
        return { vars = { center.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local total = 1
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i].ability.name == 'Wild Card' or context.scoring_hand[i]:is_suit('Diamonds', true) then
                    total = total + card.ability.extra.Xmult
                end
            end
            if total > 1 then
                return {
                    message = localize{type='variable',key='a_xmult',vars={total}},
                    Xmult_mod = total
                }
            end
		end
    end,
}