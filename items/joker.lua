--Ninja full slots functions
local check_for_buy_space_old = G.FUNCS.check_for_buy_space
G.FUNCS.check_for_buy_space = function(card)
    if card.ability.set == 'Joker' and card.ability.name == 'Ninja Monkey' then
        return true
    else
        local ret = check_for_buy_space_old(card)
        return ret
    end
end

local can_select_card_old = G.FUNCS.can_select_card
G.FUNCS.can_select_card = function(e)
    if e.config.ref_table.ability.name == 'Ninja Monkey' then 
        e.config.colour = G.C.GREEN
        e.config.button = 'use_card'
    else
        local ret = can_select_card_old(e)
        return ret
    end
  end

--[[
--Shinobi multiple appear function
local get_current_pool_old = get_current_pool
get_current_pool = function(self, ...)
    local ret, ret_key = get_current_pool_old(self, ...)
    if #find_joker('Shinobi Tactics') > 0 and ret[1].ability.set == 'Joker' then
        if ret[1].ability.rarity == 1 then
            ret[#ret+1] = 'ninja'
        elseif ret[1].ability.rarity == 2 then
            ret[#ret+1] = 'shinobi'
        end
    end
end
]]

--Pex common cost to 0 function
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
    key = 'dart',
    name = 'Dart Monkey',
	loc_txt = {
        name = 'Dart Monkey',
        text = {
            '{C:chips}+#1#{} Chips',
            '{C:mult}+#2#{} Mult'
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
            }
        end
    end
}

SMODS.Joker { --Boomer
    key = 'boomer',
    name = 'Boomerang Monkey',
	loc_txt = {
        name = 'Boomerang Monkey',
        text = {
            'Retrigger {C:attention}first{} card',
            'held in hand',
            '{C:attention}#1#{} additional times'
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
    key = 'bomb',
    name = 'Bomb Shooter',
	loc_txt = {
        name = 'Bomb Shooter',
        text = {
            '{C:gray}Steel{} cards give',
            '{X:mult,C:white}X#1#{} Mult when scored'
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
        if context.individual and context.cardarea == G.play and context.other_card.ability.name == 'Steel Card' then
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --Tack
    key = 'tack',
    name = 'Tack Shooter',
	loc_txt = {
        name = 'Tack Shooter',
        text = {
            'Each played {C:attention}8{} gives',
            '{C:chips}+#1#{} Chips and',
            '{C:mult}+#2#{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 0 },
    rarity = 1,
	cost = 3,
	order = 154,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { chips = 40, mult = 4} },
    loc_vars = function(self, info_queue, center)
        --Variables: chips = +chips, mult = +mult
        return { vars = { center.ability.extra.chips, center.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 8 then
            return {
                h_chips = card.ability.extra.chips,
                h_mult = card.ability.extra.mult,
            }
        end
    end
}

SMODS.Joker { --Sniper
    key = 'sniper',
    name = 'Sniper Monkey',
	loc_txt = {
        name = 'Sniper Monkey',
        text = {
            '{C:mult}+#1#{} Mult every',
            '{C:attention}#2#{} hands played',
            '{C:inactive}#3#'
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
                    h_mult = card.ability.extra.mult,
                }
            end
        end
    end
}

SMODS.Joker { --Sub
    key = 'sub',
    name = 'Monkey Sub',
	loc_txt = {
        name = 'Monkey Sub',
        text = {
            'Each card',
            'held in hand',
            'gives {C:mult}+#1#{} Mult'
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
    key = 'boat',
    name = 'Monkey Buccaneer',
	loc_txt = {
        name = 'Monkey Buccaneer',
        text = {
            'Earn {C:money}$#1#{} for every',
            '{C:money}$#2#{} of sell value of all other',
            '{C:attention}Jokers{} at end of round',
            '{C:inactive}(Currently {C:money}$#3#{C:inactive}){}'
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
    key = 'heli',
    name = 'Heli Pilot',
	loc_txt = {
        name = 'Heli Pilot',
        text = {
            '{C:attention}Last{} played {C:attention}number{}',
            'card gives {X:mult,C:white}X#1#{} Mult',
            'when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 1 },
    rarity = 1,
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
    key = 'mortar',
    name = 'Mortar Monkey',
	loc_txt = {
        name = 'Mortar Monkey',
        text = {
            '{C:green}#1# in #2#{} chance for',
            'played cards to give',
            '{C:mult}+#3#{} Mult when scored'
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
                    h_mult = card.ability.extra.mult,
                }
            end
		end
    end
}

SMODS.Joker { --Dartling
    key = 'dartling',
    name = 'Dartling Gunner',
	loc_txt = {
        name = 'Dartling Gunner',
        text = {
            '{C:chips}+???{} Chips'
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
            local temp_chips = pseudorandom('misprint', card.ability.extra.min, card.ability.extra.max)
            return {
                h_chips = temp_chips
            }
		end
    end
}

SMODS.Joker { --Wiz
    key = 'wiz',
    name = 'Wizard Monkey',
	loc_txt = {
        name = 'Wizard Monkey',
        text = {
            'Add a random ',
            '{C:enhanced}Enhancement{} to first played',
            'card when scored'
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
    key = 'ninja',
    name = 'Ninja Monkey',
	loc_txt = {
        name = 'Ninja Monkey',
        text = {
            '{C:mult}+#1#{} Mult',
            '{C:dark_edition}+#2#{} Joker Slot'
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
            }
        end
    end
}

SMODS.Joker { --Alch
    key = 'alch',
    name = 'Alchemist',
	loc_txt = {
        name = 'Alchemist',
        text = {
            'Create a {C:tarot}Tarot{} card',
            'on {C:attention}final hand{} of round',
            '{C:green}#1# in #2#{} chance to create',
            'a {C:spectral}Spectral{} card instead'
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
                    end)
                }))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
            end
        end
    end
}

SMODS.Joker { --Druid
    key = 'druid',
    name = 'Druid',
    loc_txt = {
        name = 'Druid',
        text = {
            '{C:mult}+#1#{} Mult if played',
            'hand contains',
            'a {C:attention}Full House{}'
        }
    },
    atlas = 'Joker',
	pos = { x = 7, y = 1 },
    rarity = 1,
	cost = 4,
	order = 168,
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

SMODS.Joker { --Merm
    key = 'merm',
    name = 'Mermonkey',
	loc_txt = {
        name = 'Mermonkey',
        text = {
            '{C:chips}+#1#{} Chips if played',
            'hand contains',
            'a {C:attention}Bonus Card{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 8, y = 1 },
    rarity = 1,
	cost = 4,
	order = 169,
	blueprint_compat = true,
    enhancement_gate = 'm_bonus',
    unlocked = true,

        config = { extra = { chips = 90 } },
    loc_vars = function(self, info_queue, center)
        --Variables: chips = +chips
        return { vars = { center.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i].ability.name == 'Bonus' then
                    return {
                        h_chips = card.ability.extra.chips,
                    }
                end
            end
        end
    end
}

SMODS.Joker { --Farm
    key = 'farm',
    name = 'Banana Farm',
	loc_txt = {
        name = 'Banana Farm',
        text = {
            'Earn {C:money}$#1#{} for each {C:attention}Joker{}',
            'card at end of round',
            '{C:inactive}(Currently {C:money}$#2#{C:inactive}){}'
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

SMODS.Joker {--Spac
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
	pos = { x = 0, y = 2 },
    rarity = 1,
	cost = 5,
	order = 171,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { chips = 25, current = 0 } },
    loc_vars = function(self, info_queue, center)
        --Variables: chips = +chips for each discard used, current = current +chips
        return { vars = { center.ability.extra.chips, center.ability.extra.current } }
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
                h_chips = card.ability.extra.current,
            }
        elseif context.end_of_round and card.ability.name == 'Spike Factory' and card.ability.extra.current > 0 and not context.blueprint then
            card.ability.extra.current = 0
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker {--Village
    key = 'village',
    name = 'Monkey Village',
    loc_txt = {
        name = 'Monkey Village',
        text = {
            '{C:blue}Common{} Jokers',
            'each give {C:mult}+#1#{} Mult'
        }
    },
    atlas = 'Joker',
	pos = { x = 1, y = 2 },
    rarity = 1,
	cost = 5,
	order = 172,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { mult = 5 } },
    loc_vars = function(self, info_queue, center)
        --Variables: mult = +mult
        return { vars = { center.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.other_joker and context.other_joker.config.center.rarity == 1 then
            G.E_MANAGER:add_event(Event({
                func = function()
                    context.other_joker:juice_up(0.5, 0.5)
                    return true
                end
            }))
            return {
                h_mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --Engi
    key = 'engi',
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

SMODS.Joker { --Beast
    key = 'beast',
    name = 'Beast Handler',
	loc_txt = {
        name = 'Beast Handler',
        text = {
            '{C:mult}+#1#{} Mult if played',
            'hand contains',
            'a {C:attention}Mult Card{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 2 },
    rarity = 1,
	cost = 4,
	order = 174,
	blueprint_compat = true,
    enhancement_gate = 'm_mult',
    unlocked = true,

        config = { extra = { mult = 12 } },
    loc_vars = function(self, info_queue, center)
        --Variables: mult = +mult
        return { vars = { center.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i].ability.name == 'Mult' then
                    return {
                        h_mult = card.ability.extra.mult,
                    }
                end
            end
        end
    end
}

SMODS.Joker { --Enetwork
    key = 'enetwork',
    name = 'Echosense Network',
    loc_txt = {
        name = 'Echosense Network',
        text = {
            'Create a random {C:planet}Planet{}',
            'card if {C:attention}played hand{}',
            'contains {C:attention}#1# Bonus Cards{}'
        }
    },
    atlas = 'Joker',
	pos = { x = 8, y = 4 },
    rarity = 1,
	cost = 5,
	order = 199,
	blueprint_compat = true,
    enhancement_gate = 'm_bonus',
    unlocked = true,

    config = { extra = 2 },
    loc_vars = function(self, info_queue, center)
        --Variables: extra = required bonus cards for planet
        return { vars = { center.ability.extra } }
    end,
    calculate = function(self, card, context)
        if context.before and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            local count = 0
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i].ability.name == 'Bonus' then
                    count = count + 1
                end
            end
            if count >= card.ability.extra then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        local card = create_card('Planet',G.consumeables, nil, nil, nil, nil, nil, 'alch')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})
            end
        end
    end
}

SMODS.Joker { --Owl
    key = 'owl',
    name = 'Horned Owl',
    loc_txt = {
        name = 'Horned Owl',
        text = {
            'Create a random {C:tarot}Tarot{}',
            'card if {C:attention}played hand{}',
            'contains {C:attention}#1# Mult Cards{}'
        }
    },
    atlas = 'Joker',
	pos = { x = 3, y = 5 },
    rarity = 1,
	cost = 5,
	order = 204,
	blueprint_compat = true,
    enhancement_gate = 'm_mult',
    unlocked = true,

    config = { extra = 2 },
    loc_vars = function(self, info_queue, center)
        --Variables: extra = required bonus cards for planet
        return { vars = { center.ability.extra } }
    end,
    calculate = function(self, card, context)
        if context.before and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            local count = 0
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i].ability.name == 'Mult' then
                    count = count + 1
                end
            end
            if count >= card.ability.extra then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, 'alch')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
            end
        end
    end
}

SMODS.Joker { --Trip shot
    key = 'tripshot',
    name = 'Triple Shot',
	loc_txt = {
        name = 'Triple Shot',
        text = {
            'Create {C:attention}#1# {C:spectral}Tarot{} cards',
            'if {C:attention}played hand{} is a',
            '{C:attention}Three of a Kind #2#{} times',
            '{C:inactive}#3# remaining{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 6 },
    rarity = 1,
	cost = 5,
	order = 211,
	blueprint_compat = true,
    unlocked = true,

    config = { tarots = 3, limit = 3, counter = 3 },
    loc_vars = function(self, info_queue, center)
        --Variables: tarots = nnumber of tarots, limit = number of 3oaks for tarots, counter = current count index
		return { vars = { center.ability.tarots, center.ability.limit, center.ability.counter } }
    end,
    calculate = function(self, card, context)
        if context.before and next(context.poker_hands['Three of a Kind']) and not 
                next(context.poker_hands['Flush']) and not
                next(context.poker_hands['Full House']) and not
                next(context.poker_hands['Four of a Kind']) then
            if not context.blueprint then
                card.ability.counter = card.ability.counter - 1
            end
            if card.ability.counter == 0 then
                card.ability.counter = card.ability.limit
                for i = 1, card.ability.tarots do
                    if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                        G.E_MANAGER:add_event(Event({
                            trigger = 'before',
                            delay = 0.0,
                            func = (function()
                                local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, 'tripshot')
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                                return true
                            end)
                        }))
                    end
                end
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = '+3 Tarots', colour = G.C.PURPLE})
            end
        end
    end
}

SMODS.Joker { --Mauler
    key = 'mauler',
    name = 'MOAB Mauler',
	loc_txt = {
        name = 'MOAB Mauler',
        text = {
            '{X:mult,C:white}X#1#{} Mult against',
            '{C:attention}Boss Blinds{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 6 },
    rarity = 2,
	cost = 5,
	order = 213,
	blueprint_compat = true,
    unlocked = true,
    config = { extra = { Xmult = 3 } },
    loc_vars = function(self, info_queue, center)
        --Variables: tarots = nnumber of tarots, limit = number of 3oaks for tarots, counter = current count index
		return { vars = { center.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.blind.boss then
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --Dprec
    key = 'dprec',
    name = 'Deadly Precision',
	loc_txt = {
        name = 'Deadly Precision',
        text = {
            '{X:mult,C:white}X#1#{} Mult every',
            '{C:attention}#2#{} hands played',
            '{C:inactive}#3#'
        }
    },
	atlas = 'Joker',
	pos = { x = 6, y = 6 },
    rarity = 2,
	cost = 6,
	order = 217,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { Xmult = 3 }, limit = 3, counter = 3 },
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
                    x_mult = card.ability.extra.Xmult,
                }
            end
        end
    end
}

SMODS.Joker { --Trip guns
    key = 'tripguns',
    name = 'Triple Guns',
    loc_txt = {
        name = 'Triple Guns',
        text = {
            'This {C:attention}Joker{} gains {X:mult,C:white}X#1#{} ',
            'Mult if a {C:attention}Three of a Kind{}',
            'is held in hand',
            '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)'
        }
    },
	atlas = 'Joker',
	pos = { x = 7, y = 6 },
    rarity = 2,
	cost = 6,
	order = 218,
	blueprint_compat = true,
    perishable_compat = false,
    unlocked = true,

    config = { extra = { Xmult = 0.1, current = 1 } },
    loc_vars = function(self, info_queue, center)
        --Variables: Xmult = Xmult gain for each 3oak held, current = current Xmult
        return { vars = { center.ability.extra.Xmult, center.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local ranks = {}
            for i, j in ipairs(G.hand.cards) do
                local new = true
                local id = j:get_id()
                for k, v in pairs(ranks) do
                    if id == k then
                        ranks[k] = v + 1
                        if ranks[k] % 3 == 0 then
                            card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult
                        end
                        new = false
                    end
                end
                if new then
                    ranks[id] = 1
                end
            end
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Draft
    key = 'draft',
    name = 'Downdraft',
    loc_txt = {
        name = 'Downdraft',
        text = {
            '{C:blue}+#1#{} hands',
            'First {C:attention}#1#{} hands',
            'score {C:attention}#2#{} chips',
            '{C:inactive}#3# remaining{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 7 },
    rarity = 2,
	cost = 7,
	order = 221,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { hands = 2, scored_chips = 0, counter = 2 } },
    loc_vars = function(self, info_queue, center)
        --Variables: hands = extra hands, scored_chips = chips for first hands, current = amount of blowback hands left
		return { vars = { center.ability.extra.hands, center.ability.extra.scored_chips, center.ability.extra.counter } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            G.E_MANAGER:add_event(Event({func = function()
                ease_hands_played(card.ability.extra.hands)
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_hands', vars = {card.ability.extra.hands}}})
            return true end }))
        elseif context.final_scoring_step and card.ability.extra.counter > 0 then
            hand_chips = mod_chips(card.ability.extra.scored_chips)
            card.ability.extra.counter = card.ability.extra.counter - 1
            update_hand_text( { delay = 0 }, { chips = hand_chips } )
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("timpani", 1)
					attention_text({
						scale = 1.4,
						text = "Blowback",
						hold = 2,
						align = "cm",
						offset = { x = 0, y = -2.7 },
						major = G.play,
					})
					return true
				end,
			}))
        elseif context.end_of_round then
            card.ability.extra.counter = card.ability.extra.hands
        end
    end
}

SMODS.Joker { --Buckshot
    key = 'buckshot',
    name = 'Buckshot',
	loc_txt = {
        name = 'Buckshot',
        text = {
            '{X:mult,C:white}X?.?{} Mult'
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 7 },
    rarity = 2,
	cost = 7,
	order = 223,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { max = 33, min = 10 } },
    --Variables: max = max possible Xmult *10, min = min possible Xmult *10
    calculate = function(self, card, context)
        if context.joker_main then
            local temp_Xmult = pseudorandom('misprint', card.ability.extra.min, card.ability.extra.max) / 10.0
            return {
                x_mult = temp_Xmult
            }
		end
    end
}

--[[
SMODS.Joker { --Shinobi
    key = 'shinobi',    
    name = 'Shinobi Tactics',
	loc_txt = {
        name = 'Shinobi Tactics',
        text = {
            'All {C:attention}Ninjas{} may appear multiple times',
            'Gives {X:mult,C:white}X#1#{} Mult for each one',
            '{C:inactive}Currently {X:mult,C:white}X#2#{C:inactive} Mult{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 7 },
    rarity = 2,
	cost = 5,
	order = 226,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { Xmult = 0.5, current = 1 } },
    loc_vars = function(self, info_queue, center)
        if G.STAGE == G.STAGES.RUN then
            local ninjas = 0
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.name == 'Ninja Monkey' or G.jokers.cards[i].ability.name == 'Shinobi Tactics' then
                    ninjas = ninjas + 1
                end
            end
            center.ability.extra.current = ninjas * center.ability.extra.Xmult + 1
        end
        --Variables = Xmult = Xmult for each ninja, current = current Xmult
        return { vars = { center.ability.extra.Xmult, center.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.current
            }
        end
    end
}
]]

SMODS.Joker { --DoW
    key = 'dow',    
    name = 'Druid of Wrath',
	loc_txt = {
        name = 'Druid of Wrath',
        text = {
            'This Joker gains {X:mult,C:white}X#1#{}',
            'Mult for every hand',
            'played this round',
            '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)'
        }
    },
	atlas = 'Joker',
	pos = { x = 7, y = 7 },
    rarity = 2,
	cost = 5,
	order = 228,
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
        elseif context.after and not context.blueprint then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult
            return {
                message = 'Wrath',
                colour = G.C.RED,
                delay = 0.45
            }
        elseif context.end_of_round and card.ability.name == 'Druid of Wrath' and card.ability.extra.current > 1 and not context.blueprint then
            card.ability.extra.current = 1
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker { --LLS
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
	pos = { x = 0, y = 8 },
    rarity = 2,
	cost = 6,
	order = 231,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { mult = 1, loss = 4, current = 0 } },
    loc_vars = function(self, info_queue, center)
        --Variables: mult = +mult per spade discarded, current = current +mult, loss = -mult at end of round
        return { vars = { center.ability.extra.mult, center.ability.extra.loss, center.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card:is_suit('Spades', true) and not context.blueprint then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                colour = G.C.MULT,
                delay = 0.45,
            }
        elseif context.joker_main and card.ability.extra.current > 0 then
            return {
                h_mult = card.ability.extra.current,
            }
        end
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            if card.ability.extra.current > card.ability.extra.loss then
                card.ability.extra.current = card.ability.extra.current - card.ability.extra.loss
            else
                card.ability.extra.current = 0
            end
            return {
                message = localize{type='variable',key='a_mult_minus',vars={card.ability.extra.loss}},
                colour = G.C.MULT
            }
        end
    end
}

SMODS.Joker { --Jugg
    key = 'jugg',
    name = 'Juggernaut',
	loc_txt = {
        name = 'Juggernaut',
        text = {
            'Each played card gives',
            '{C:mult}+#1#{} more Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 9 },
    rarity = 2,
	cost = 6,
	order = 241,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { mult = 2, current = 0 } },
    loc_vars = function(self, info_queue, center)
        --Variables: mult = +mult for each card scored, current = current +mult
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

SMODS.Joker { --Od
    key = 'od',
    name = 'Overdrive',
    loc_txt = {
        name = 'Overdrive',
        text = {
            'This Joker gains',
            '{X:mult,C:white} X#1# {} Mult for every {C:attention}8{}',
            'played this round',
            '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 9 },
    rarity = 2,
	cost = 7,
	order = 244,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { Xmult = 0.5, current = 1 } },
    loc_vars = function(self, info_queue, center)
        --Variables: Xmult = Xmult gain for each 8, current = current Xmult
        return { vars = { center.ability.extra.Xmult, center.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == 8 then
                    card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult
                end
            end
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current,
            }
        elseif context.end_of_round and card.ability.name == 'Overdrive' and card.ability.extra.current > 1 and not context.blueprint then
            card.ability.extra.current = 1
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker { --GZ   
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
	cost = 8,
	order = 220,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { chips = 350 } },
    loc_vars = function(self, info_queue, center)
        --Variables: chips = +chips, mult = +mult
        return { vars = { center.ability.extra.chips, center.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_played == 0 then
            return {
                h_chips = card.ability.extra.chips,
            }
        end
    end
}

SMODS.Joker { --Abatt
    key = 'abatt',
    name = 'Artillery Battery',
	loc_txt = {
        name = 'Artillery Battery',
        text = {
            '{C:green}#1# in #2#{} chance for',
            'played cards to give',
            '{C:chips}+#3#{} Chips, {C:mult}+#4#{} Mult, and',
            '{X:mult,C:white}X#5#{} Mult independently'
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 10 },
    rarity = 2,
	cost = 7,
	order = 222,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { odds = 3, chips = 33, mult = 8, Xmult = 1.3 }, },
    loc_vars = function(self, info_queue, center)
        --Variables: odds = probability cases, chips = +chips, mult = +mult, Xmult = Xmult
        return {
            vars = {
                G.GAME.probabilities.normal or 1,
                center.ability.extra.odds,
                center.ability.extra.chips,
                center.ability.extra.mult,
                center.ability.extra.Xmult
            }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local temp_chips, temp_mult, temp_Xmult = 0, 0, 1
            if pseudorandom('bloodstone') < G.GAME.probabilities.normal/card.ability.extra.odds then
                temp_chips = card.ability.extra.chips
            end
            if pseudorandom('bloodstone') < G.GAME.probabilities.normal/card.ability.extra.odds then
                temp_mult = card.ability.extra.mult
            end
            if pseudorandom('bloodstone') < G.GAME.probabilities.normal/card.ability.extra.odds then
                temp_Xmult = card.ability.extra.Xmult
            end
            if {temp_chips, temp_mult, temp_Xmult} ~= {0, 0, 1} then
                return {
                    h_chips = temp_chips,
                    h_mult = temp_mult,
                    x_mult = temp_Xmult
                }
            end
		end
    end
}

SMODS.Joker { --XBM
    key = 'xbm',
    name = 'Crossbow Master',
	loc_txt = {
        name = 'Crossbow Master',
        text = {
            '{X:mult,C:white}X#1#{} Mult Every',
            '{C:attention}#2#{} cards scored',
            '{C:inactive}#3#'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 12 },
    rarity = 2,
	cost = 8,
	order = 271,
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
                    x_mult = card.ability.extra.Xmult,
                }
            else
                card.ability.counter = card.ability.counter + 1
            end
        end
    end
}

SMODS.Joker { --Blitz
    key = 'blitz',
    name = 'Bomb Blitz',
	loc_txt = {
        name = 'Bomb Blitz',
        text = {
            'Prevents Death if chips scored',
            'are at least {C:attention}50%{} of required chips',
            'and destroy all cards held in hand',
            '{S:1.1,C:red,E:2}self destructs{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 12 },
    rarity = 3,
	cost = 8,
	order = 273,
	blueprint_compat = false,
    eternal_compat = false,
    unlocked = true,

    config = { },
    --Variables:

    calculate = function(self, card, context)
        if context.game_over and G.GAME.chips/G.GAME.blind.chips >= 0.5 and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand_text_area.blind_chips:juice_up()
                    G.hand_text_area.game_chips:juice_up()
                    play_sound('tarot1')
                    card:start_dissolve()
                    return true
                end
            }))
            local destroyed_cards = {}
            for k, v in ipairs(G.hand.cards) do
                destroyed_cards[#destroyed_cards+1] = v
            end
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function() 
                    for i=#destroyed_cards, 1, -1 do
                        local card = destroyed_cards[i]
                        if card.ability.name == 'Glass Card' then 
                            card:shatter()
                        else
                            card:start_dissolve(nil, i == #destroyed_cards)
                        end
                    end
                    return true
                end
            }))
            return {
                message = localize('k_saved_ex'),
                saved = true,
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker { --Iring
    key = 'iring',
    name = 'Inferno Ring',
	loc_txt = {
        name = 'Inferno Ring',
        text = {
            "Adds one {C:attention}Meteor{} card",
            "to deck when",
            "{C:attention}Blind{} is selected",
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 12 },
    rarity = 3,
	cost = 9,
	order = 274,
	blueprint_compat = true,
    unlocked = true,

    config = {},
    calculate = function(self, card, context)
        if context.setting_blind then
            G.E_MANAGER:add_event(Event({
                func = function() 
                    local front = pseudorandom_element(G.P_CARDS, pseudoseed('marb_fr'))
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    local card = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS.m_bloons_meteor, {playing_card = G.playing_card})
                    card:start_materialize({G.C.SECONDARY_SET.Enhanced})
                    G.play:emplace(card)
                    table.insert(G.playing_cards, card)
                    return true
                end}))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = '+1 Meteor', colour = G.C.SECONDARY_SET.Enhanced})

            G.E_MANAGER:add_event(Event({
                func = function() 
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    return true
                end
            }))
            draw_card(G.play,G.deck, 90,'up', nil)
            playing_card_joker_effects({true})
        end
    end

}

SMODS.Joker { --Solver
    key = 'solver',
    name = 'The Bloon Solver',
	loc_txt = {
        name = 'The Bloon Solver',
        text = {
            'Every played {C:attention}card{}',
            'becomes {C:money}Glued{} and',
            'permanently gains {C:mult}+#1#{}',
            'Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 12 },
    rarity = 3,
	cost = 8,
	order = 276,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { mult = 2 } },
    loc_vars = function(self, info_queue, center)
        --Variables: mult = permanent +mult
        return { vars = { center.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            context.other_card:set_ability('m_bloons_glued', nil, true)
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult or 0
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult + card.ability.extra.mult
            return {
                extra = {message = localize('k_upgrade_ex'), colour = G.C.MULT},
                colour = G.C.CMULT,
            }
        end
    end
}

SMODS.Joker { --Edef
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
	pos = { x = 6, y = 12 },
    rarity = 2,
	cost = 8,
	order = 277,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { Xmult1 = 1.5, Xmult2 = 2, Xmult3 = 4 } },
    loc_vars = function(self, info_queue, center)
        --Variables: Xmult1 = Xmult after first hand, Xmult2 = Xmult on final hand, Xmult3 = XMult if under 25%
        return { vars = { center.ability.extra.Xmult1, center.ability.extra.Xmult2, center.ability.extra.Xmult3 } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if G.GAME.current_round.hands_left == 0 then
                if G.GAME.chips/G.GAME.blind.chips <= 0.25 then
                    return {
                        x_mult = card.ability.extra.Xmult3
                    }
                else
                    return {
                        x_mult = card.ability.extra.Xmult2
                    }
                end
            elseif G.GAME.current_round.hands_played ~= 0 then
                return {
                    x_mult = card.ability.extra.Xmult1
                }
            end
        end
    end
}

SMODS.Joker { --Cin
    key = 'cin',
    name = 'Blooncineration',
	loc_txt = {
        name = 'Blooncineration',
        text = {
            'Destroy all played',
            'cards with {C:enhanced}Enhancements{},',
            '{C:dark_edition}Editions{} or {C:attention}Seals{}',
            '{X:mult,C:white}X#2#{} Mult for each one'
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 13 },
    rarity = 3,
	cost = 9,
	order = 282,
	blueprint_compat = false,
    unlocked = true,

    config = { extra = { Xmult = 2 } },
    loc_vars = function(self, info_queue, center)
        --Variables: Xmult = Xmult
        return { vars = { center.ability.extra.Xmult } }
    end,
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
            return {
                xmult = card.ability.extra.Xmult,
                remove = true
            }
        end
    end
}

SMODS.Joker { --Rod
    key = 'rod',
    name = 'Ray of Doom',
	loc_txt = {
        name = 'Ray of Doom',
        text = {
            'Each repeated card rank',
            'in {C:attention}played hand{} gives',
            '{X:mult,C:white}X?.?{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 13 },
    rarity = 3,
	cost = 10,
	order = 283,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { max = 43, min = 20 }, ranks = {} },
    --Variables: max = max possible Xmult *20, min = min possible Xmult *20
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            for i=1, #card.ability.ranks do
                if context.other_card:get_id() == card.ability.ranks[i] then
                    local temp_Xmult = pseudorandom('misprint', card.ability.extra.min, card.ability.extra.max) / 20.0
                    return {
                        x_mult = temp_Xmult
                    }
                end
            end
            card.ability.ranks[#card.ability.ranks+1] = context.other_card:get_id()
        end
        if context.after then
            card.ability.ranks = {}
        end
    end
}

SMODS.Joker { --Arch
    key = 'archt',
    name = 'Archmage',
	loc_txt = {
        name = 'Archmage',
        text = {
            'Retrigger all played',
            'cards with {C:enhanced}Enhancements{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 7 },
    rarity = 3,
	cost = 8,
	order = 284,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = 1 },
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

SMODS.Joker { --GMN
    key = 'gmn',
    name = 'Grandmaster Ninja',
	loc_txt = {
        name = 'Grandmaster Ninja',
        text = {
            'Gives {X:mult,C:white}X#1#{} Mult for',
            'each scoring {C:diamonds}Diamond{}',
            'in played {C:attention}poker hand{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 13 },
    rarity = 3,
	cost = 8,
	order = 286,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { Xmult = 0.5 } },
    loc_vars = function(self, info_queue, center)
        --Variables: Xmult = Xmult
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
                    x_mult = total
                }
            end
		end
    end
}

SMODS.Joker {--Pex
    key = 'pex',
    name = 'Primary Expertise',
    loc_txt = {
        name = 'Primary Expertise',
        text = {
            '{C:blue}Common{} Jokers are free',
            '{C:green}#1# in #2#{} chance for {X:mult,C:white}X#3#{} Mult,',
            '{C:green}Probability{} increases for',
            'each {C:blue}Common{} Joker'
        }
    },
    atlas = 'Joker',
	pos = { x = 1, y = 14 },
    rarity = 3,
	cost = 8,
	order = 291,
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
                    x_mult = card.ability.extra.Xmult
                }
            end
        end
    end
}

--[[
SMODS.Joker {--Uboost
    key = 'uboost',
    name = 'Ultraboost',
    loc_txt = {
        name = 'Ultraboost',
        text = {
            '{C:attention}Joker{} to the left',
            'becomes {C:cark_edition}Overclocked{} and',
            'permanently gains {X:mult,C:white}X#1#{} Mult',
            '{C:inactive}unimplemented{}'
        }
    },
    atlas = 'Joker',
	pos = { x = 2, y = 11 },
    rarity = 3,
	cost = 10,
	order = 263,
	blueprint_compat = true,
    unlocked = true,

    config = { extra = { Xmult = 0.1 } },
    loc_vars = function(self, info_queue, center)
        --Variables: Xmult = permanent Xmult
        return { vars = { center.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and card ~= G.jokers.cards[1] then
            local other_joker
            for i = 2, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    other_joker = G.jokers.cards[i-1]
                end
            end
            return {
                extra = {message = localize('k_upgrade_ex'), colour = G.C.MULT},
                colour = G.C.CMULT,
            }
        end
    end
}
]]