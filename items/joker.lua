--Pex function
local set_cost_old = Card.set_cost
Card.set_cost = function(self, ...)
    local ret = set_cost_old(self, ...)
    if self.ability.set == 'Joker' and self.config.center.rarity == 1 and #find_joker('Primary Expertise') > 0 then
            self.cost = 0
    end
    return ret
end

SMODS.Atlas {
    key = 'Joker',
    path = 'jokers.png',
    px = 71,
    py = 95,
}

SMODS.Joker { --Dart
    key = 'j_dart',
    name = 'Dart Monkey',
	loc_txt = {
        name = 'Dart Monkey',
        text = {
            '{C:chips}+#1#{} Chips',
            '{C:mult}+#2#{} Mult',
        }
    },
	atlas = 'Joker',
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
    end
}

SMODS.Joker { --Boomer
    key = 'j_boomer',
    name = 'Boomerang Monkey',
	loc_txt = {
        name = 'Boomerang Monkey',
        text = {
            'Retrigger {C:attention}first{} card',
            'held in hand',
            '{C:attention}#1#{} additional times',
        }
    },
	atlas = 'Joker',
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
        if context.repetition and context.cardarea == G.hand and context.other_card == G.hand.cards[1] and (next(context.card_effects[1]) or #context.card_effects > 1) then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra
            }
        end
    end
}

SMODS.Joker { --Bomb
    key = 'j_bomb',
    name = 'Bomb Shooter',
	loc_txt = {
        name = 'Bomb Shooter',
        text = {
            '{C:gray}Steel{} cards give',
            '{X:mult,C:white}X#1#{} Mult when scored',
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 0 },
    rarity = 1,
	cost = 5,
	order = 153,
	blueprint_compat = true,
    enhancement_gate = 'm_steel',
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
    end
}

SMODS.Joker { --Tack
    key = 'j_tack',
    name = 'Tack Shooter',
	loc_txt = {
        name = 'Tack Shooter',
        text = {
            'Each played {C:attention}8{} gives',
            '{C:chips}+#1#{} Chips and',
            '{C:mult}+#2#{} Mult when scored',
        }
    },
	atlas = 'Joker',
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
    end
}

SMODS.Joker { --Sniper
    key = 'j_sniper',
    name = 'Sniper Monkey',
	loc_txt = {
        name = 'Sniper Monkey',
        text = {
            '{C:mult}+#1#{} Mult every',
            '{C:attention}#2#{} hands played',
            '{C:inactive}#3#',
        }
    },
	atlas = 'Joker',
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
				return 'Active!'
			end
			return cap - count%cap - 1 .. ' remaining'
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
            if card.ability.counter == card.ability.limit then
                return {
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                    mult_mod = card.ability.extra.mult,
                }
            end
        end
    end
}

SMODS.Joker { --Sub
    key = 'j_sub',
    name = 'Monkey Sub',
	loc_txt = {
        name = 'Monkey Sub',
        text = {
            'Each card',
            'held in hand',
            'gives {C:mult}+#1#{} Mult',
        }
    },
	atlas = 'Joker',
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
        if context.individual and context.cardarea == G.hand and not context.end_of_round then
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
}

SMODS.Joker { --Boat
    key = 'j_boat',
    name = 'Monkey Buccaneer',
	loc_txt = {
        name = 'Monkey Buccaneer',
        text = {
            'Earn {C:money}$#1#{} for every',
            '{C:money}$#2#{} of sell value of all other',
            '{C:attention}Jokers{} at end of round',
            '{C:inactive}(Currently {C:money}$#3#{C:inactive}){}',
        }
    },
	atlas = 'Joker',
	pos = { x = 8, y = 0 },
    rarity = 1,
	cost = 4,
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
        --Variables: money = end of round dollars per rate, rate = sell cost required for money, current = current end of round dollars
        return { vars = { center.ability.extra.money, center.ability.extra.rate, center.ability.extra.current } }
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.current
    end
}

SMODS.Joker { --Ace
    key = 'j_ace',
    name = 'Monkey Ace',
	loc_txt = {
        name = 'Monkey Ace',
        text = {
            'Each {C:attention}Ace{}',
            'held in hand',
            'gives {C:chips}+#1#{} Chips',
        }
    },
	atlas = 'Joker',
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

SMODS.Joker { --Heli
    key = 'j_heli',
    name = 'Heli Pilot',
	loc_txt = {
        name = 'Heli Pilot',
        text = {
            '{C:attention}Last{} played {C:attention}number{}',
            'card gives {X:mult,C:white}X#1#{} Mult',
            'when scored',
        }
    },
	atlas = 'Joker',
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
        if context.individual and context.cardarea == G.play then
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
}

SMODS.Joker { --Mortar
    key = 'j_mortar',
    name = 'Mortar Monkey',
	loc_txt = {
        name = 'Mortar Monkey',
        text = {
            '{C:green}#1# in #2#{} chance for',
            'played cards to give',
            '{C:mult}+#3#{} Mult when scored',
        }
    },
	atlas = 'Joker',
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
        if context.individual and context.cardarea == G.play then
            if pseudorandom('bloodstone') < G.GAME.probabilities.normal/card.ability.extra.odds then
                return {
                    message = '+' .. card.ability.extra.mult,
                    mult_mod = card.ability.extra.mult,
                    colour = G.C.MULT
                }
            end
		end
    end
}

SMODS.Joker { --Dartling
    key = 'j_dartling',
    name = 'Dartling Gunner',
	loc_txt = {
        name = 'Dartling Gunner',
        text = {
            '{C:chips}+???{} Chips',
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 1 },
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
    end
}

SMODS.Joker { --Wiz
    key = 'j_wiz',
    name = 'Wizard Monkey',
	loc_txt = {
        name = 'Wizard Monkey',
        text = {
            'Add a random ',
            '{C:enhanced}Enhancement{} to first played',
            'card when scored',
        }
    },
	atlas = 'Joker',
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
            local enhancement = pseudorandom_element(G.P_CENTER_POOLS['Enhanced'], pseudoseed('cry_brittle'))
            context.scoring_hand[1]:set_ability(enhancement, nil, true)
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
    end
}

SMODS.Joker { --Ninja
    key = 'j_ninja',
    name = 'Ninja Monkey',
	loc_txt = {
        name = 'Ninja Monkey',
        text = {
            '{C:mult}+#1#{} Mult',
            '{C:dark_edition}+#2#{} Joker Slot',
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 1 },
    rarity = 1,
	cost = 4,
	order = 166,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { mult = 4, slots = 1} },
    loc_vars = function(self, info_queue, center)
        --Variables: mult = +mult, slots = extra joker slots
        return { vars = { center.ability.extra.mult, center.ability.extra.slots } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                h_mult = card.ability.extra.mult,
                colour = G.C.MULT
            }
        end
    end
}

SMODS.Joker { --Alch
    key = 'j_alch',
    name = 'Alchemist',
	loc_txt = {
        name = 'Alchemist',
        text = {
            'Create a {C:tarot}Tarot{} card',
            'on {C:attention}final hand{} of round',
            '{C:green}#1# in #2#{} chance to create',
            'a {C:spectral}Spectral{} card instead',
        }
    },
	atlas = 'Joker',
	pos = { x = 6, y = 1 },
    rarity = 1,
	cost = 5,
	order = 167,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { odds = 2 } },
    loc_vars = function(self, info_queue, center)
        --Variables: odds = probability cases
        return { vars = { G.GAME.probabilities.normal or 1, center.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.before and G.GAME.current_round.hands_left == 0 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            if pseudorandom('halu') < G.GAME.probabilities.normal/card.ability.extra.odds then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        local card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'alch')
                            card:add_to_deck()
                            G.consumeables:emplace(card)
                            G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
            else
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, 'alch')
                            card:add_to_deck()
                            G.consumeables:emplace(card)
                            G.GAME.consumeable_buffer = 0
                        return true
                    end
                )}))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
            end
        end
    end
}

SMODS.Joker { --Druid
    key = 'j_druid',
    name = 'Druid',
    loc_txt = {
        name = 'Druid',
        text = {
            "{C:mult}+#1#{} Mult if played",
            "hand contains",
            "a {C:attention}Full House{}",
        }
    },
    atlas = 'Joker',
	pos = { x = 7, y = 1 },
    rarity = 1,
	cost = 4,
	order = 169,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { mult = 20 } },
    loc_vars = function(self, info_queue, center)
        --Variables: mult = +mult
        return { vars = { center.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands['Full House']) then
            return {
                h_mult = card.ability.extra.mult,
            }
        end
    end
}

SMODS.Joker { --Farm
    key = 'j_farm',
    name = 'Banana Farm',
	loc_txt = {
        name = 'Banana Farm',
        text = {
            'Earn {C:money}$#1#{} for each {C:attention}Joker{}',
            'card at end of round',
            '{C:inactive}(Currently {C:money}$#2#{C:inactive}){}',
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 1 },
    rarity = 1,
	cost = 5,
	order = 170,
	blueprint_compat = false,
    unlocked = true,

    config = { extra = { money = 1, current = 0 } },
    loc_vars = function(self, info_queue, center)
        if G.STAGE == G.STAGES.RUN then
            center.ability.extra.current = #G.jokers.cards
        end
        --Variables: money = end of round dollars per joker, current = current end of round dollars
        return { vars = { center.ability.extra.money, center.ability.extra.current } }
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.current
    end
}

SMODS.Joker {--Village
    key = 'j_village',
    name = 'Monkey Village',
    loc_txt = {
        name = 'Monkey Village',
        text = {
            '{C:blue}Common{} Jokers',
            'each give {C:mult}+#1#{} Mult',
        }
    },
    atlas = 'Joker',
	pos = { x = 1, y = 2 },
    rarity = 2,
	cost = 6,
	order = 172,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { mult = 10 } },
    loc_vars = function(self, info_queue, center)
        --Variables: mult = +mult
        return { vars = { center.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.other_joker and context.other_joker.config.center.rarity == 1 and card ~= context.other_joker then
            G.E_MANAGER:add_event(Event({
                func = function()
                    context.other_joker:juice_up(0.5, 0.5)
                    return true
                end
            }))
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --Engi
    key = 'j_engi',
    name = 'Engineer Monkey',
	loc_txt = {
        name = 'Engineer Monkey',
        text = {
            'Earn {C:money}$#1#{} if {C:attention}poker hand{}',
            'contains a {C:attention}Straight{}',
            'or a {C:attention}Flush{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 2 },
    rarity = 1,
	cost = 4,
	order = 173,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { money = 3 } },
    loc_vars = function(self, info_queue, center)
        --Variables: money = money earned
        return { vars = { center.ability.extra.money } }
    end,
    calculate = function(self, card, context)
		if context.before and context.poker_hands then
            if next(context.poker_hands['Straight']) and next(context.poker_hands['Flush']) then
                return {
                    dollars = card.ability.extra.money * 2,
                    colour = G.C.MONEY
                }
            elseif next(context.poker_hands['Straight']) or next(context.poker_hands['Flush']) then
                return {
                    dollars = card.ability.extra.money,
                    colour = G.C.MONEY
                }
            end
        end
	end
}

SMODS.Joker { --Jugg
    key = 'j_jugg',
    name = 'Juggernaut',
	loc_txt = {
        name = 'Juggernaut',
        text = {
            'Each played card gives',
            '{C:mult}+#1#{} more Mult when scored',
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 3 },
    rarity = 2,
	cost = 7,
	order = 181,
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
    end
}

SMODS.Joker { --Dprec
    key = 'j_dprec',
    name = 'Deadly Precision',
	loc_txt = {
        name = 'Deadly Precision',
        text = {
            '{X:mult,C:white}X#1#{} Mult every',
            '{C:attention}#2#{} hands played',
            '{C:inactive}#3#',
        }
    },
	atlas = 'Joker',
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
				return 'Active!'
			end
			return cap - count%cap - 1 .. ' remaining'
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
            if card.ability.counter == card.ability.limit then
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                    Xmult_mod = card.ability.extra.Xmult,
                }
            end
        end
    end
}

SMODS.Joker { --Buckshot
    key = 'j_buckshot',
    name = 'Buckshot',
	loc_txt = {
        name = 'Buckshot',
        text = {
            '{X:mult,C:white}X?.?{} Mult',
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 4 },
    rarity = 2,
	cost = 7,
	order = 193,
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
    end
}

SMODS.Joker { --Amast
    key = 'j_amast',
    name = 'Arcane Mastery',
	loc_txt = {
        name = 'Arcane Mastery',
        text = {
            'Retrigger all played',
            'cards with {C:enhanced}Enhancements{}',
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 4 },
    rarity = 2,
	cost = 7,
	order = 194,
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
    end
}

SMODS.Joker { --DoW
    key = 'j_dow',    
    name = 'Druid of Wrath',
	loc_txt = {
        name = 'Druid of Wrath',
        text = {
            'This Joker gains {X:mult,C:white}X#1#{}',
            'Mult for every hand',
            'played this round',
            '{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)',
        }
    },
	atlas = 'Joker',
	pos = { x = 7, y = 4 },
    rarity = 2,
	cost = 6,
	order = 198,
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
            if card.ability.set == 'Joker' and card.ability.extra.current > 1 then
                card.ability.extra.current = 1
                return {
                    message = localize('k_reset'),
                    colour = G.C.RED
                }
            end
        end
    end
}

SMODS.Joker { --XBM
    key = 'j_xbm',
    name = 'Crossbow Master',
	loc_txt = {
        name = 'Crossbow Master',
        text = {
            '{X:mult,C:white}X#1#{} Mult Every',
            '{C:attention}#2#{} cards scored',
            '{C:inactive}#3#',
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 9 },
    rarity = 2,
	cost = 8,
	order = 241,
	blueprint_compat = false,
    unlocked = true,

    config = { 
        extra = { Xmult = 2 },
        limit = 5,
        counter = 1,
    },
    loc_vars = function(self, info_queue, center)
        local function process_var(count, cap)
			if count == cap then
				return 'Next!'
			end
			return cap - count%cap .. ' remaining'
		end
        --Variables: Xmult = Xmult, limit = number of cards scored for Xmult, counter = card index
		return {
			vars = {
				center.ability.extra.Xmult,
				center.ability.limit,
                process_var(center.ability.counter, center.ability.limit),
			},
		}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if card.ability.counter == card.ability.limit then
                card.ability.counter = 1
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                    Xmult_mod = card.ability.extra.Xmult,
                }
            else
                card.ability.counter = card.ability.counter + 1
            end
        end
    end
}

SMODS.Joker { --Solver
    key = 'j_solver',
    name = 'The Bloon Solver',
	loc_txt = {
        name = 'The Bloon Solver',
        text = {
            'Every played {C:attention}card{}',
            'becomes {C:money}Glued{} and',
            'permanently gains {C:mult}+#1#{}',
            'Mult when scored',
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 9 },
    rarity = 3,
	cost = 8,
	order = 246,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { mult = 2 } },
    loc_vars = function(self, info_queue, center)
        --Variables: mult = permanent +mult
        return { vars = { center.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult or 0
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult + card.ability.extra.mult
            return {
                extra = {message = localize('k_upgrade_ex'), colour = G.C.MULT},
                colour = G.C.CMULT,
            }
        end
    end
}

SMODS.Joker { --Cin
    key = 'j_cin',
    name = 'Blooncineration',
	loc_txt = {
        name = 'Blooncineration',
        text = {
            'Destroy all played',
            'cards with {C:enhanced}Enhancements{},',
            '{C:dark_edition}Editions{} or {C:attention}Seals{}',
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 10 },
    rarity = 3,
	cost = 9,
	order = 252,
	blueprint_compat = false,
    unlocked = true,

    config = { },
    --Variables:
    calculate = function(self, card, context)
        if context.destroying_card and
                (context.destroying_card.config.center ~= G.P_CENTERS.c_base or
                context.destroying_card.edition or
                context.destroying_card.seal) and
                not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card:juice_up(0.3, 0.4)
                    return true
                end
            }))
            return true
        end
    end
}

SMODS.Joker { --GMN
    key = 'j_gmn',
    name = 'Grandmaster Ninja',
	loc_txt = {
        name = 'Grandmaster Ninja',
        text = {
            'Gives {X:mult,C:white}X#1#{} Mult for',
            'each scoring {C:diamonds}Diamond{}',
            'in played {C:attention}poker hand{}',
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 10 },
    rarity = 3,
	cost = 8,
	order = 256,
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
    end
}


SMODS.Joker {--Pex
    key = 'j_pex',
    name = 'Primary Expertise',
    loc_txt = {
        name = 'Primary Expertise',
        text = {
            '{C:blue}Common{} Jokers are free',
            '{C:green}#1# in #2#{} chance for {X:mult,C:white}X#3#{} Mult,',
            '{C:green}probability{} increases for',
            'each {C:blue}Common{} Joker'
        }
    },
    atlas = 'Joker',
	pos = { x = 1, y = 11 },
    rarity = 3,
	cost = 8,
	order = 262,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { commons = 1, odds = 5, Xmult = 4 } },
    loc_vars = function(self, info_queue, center)
        if G.STAGE == G.STAGES.RUN then
            local commons = 1
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].config.center.rarity == 1 then
                    commons = commons + 1
                end
            end
            center.ability.extra.commons = commons
        end
        --Variables: commons = extra commons +1, odds = probability cases, Xmult = Xmult
        return { vars = { center.ability.extra.commons*(G.GAME.probabilities.normal or 1), center.ability.extra.odds, center.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if pseudorandom('cry_critical') < card.ability.extra.commons*G.GAME.probabilities.normal/card.ability.extra.odds then
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                    Xmult_mod = card.ability.extra.Xmult
                }
            end
        end
    end
}