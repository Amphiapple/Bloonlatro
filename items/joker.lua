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

--Recalculate cost function
function recalc_all_costs()
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.0,
        func = (function()
            for k, v in pairs(G.I.CARD) do
                if v.set_cost then
                    v:set_cost()
                end
            end
            return true
        end)
    }))
end

--Cost changing function
local set_cost_old = Card.set_cost
Card.set_cost = function(self, ...)
    local ret = set_cost_old(self, ...)
    self.sell_cost = self.sell_cost + 2 * #find_joker('Banana Salvage')
    if #find_joker('Monkey Commerce') > 0 then
        if #find_joker('Monkey Commerce') > self.cost then
            self.cost = 0
        else
            self.cost = self.cost - #find_joker('Monkey Commerce')
        end
    end
    if self.ability.set == 'Joker' and self.config.center.rarity == 1 and #find_joker('Primary Expertise') > 0 then
        self.cost = 0
    end
    return ret
end

--New end_round if Mdom is active
function end_round_new(mdoms)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.2,
        func = function()
            local game_over = true
            local game_won = false
            G.RESET_BLIND_STATES = true
            G.RESET_JIGGLES = true
            if G.GAME.chips - G.GAME.blind.chips >= 0 then
                game_over = false
            end
            for i = 1, #G.jokers.cards do
                local eval = nil
                eval = G.jokers.cards[i]:calculate_joker({end_of_round = true, game_over = game_over})
                if eval then
                    if eval.saved then
                        game_over = false
                    end
                    card_eval_status_text(G.jokers.cards[i], 'jokers', nil, nil, nil, eval)
                end
                G.jokers.cards[i]:calculate_rental()
                G.jokers.cards[i]:calculate_perishable()
            end
            if game_over then
                G.STATE = G.STATES.GAME_OVER
                if not G.GAME.won and not G.GAME.seeded and not G.GAME.challenge then 
                    G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
                end
                G:save_settings()
                G.FILE_HANDLER.force = true
                G.STATE_COMPLETE = false
            else
                G.GAME.unused_discards = (G.GAME.unused_discards or 0) + G.GAME.current_round.discards_left
                if G.GAME.blind and G.GAME.blind.config.blind then 
                    discover_card(G.GAME.blind.config.blind)
                end

                if G.GAME.blind:get_type() == 'Boss' and not G.GAME.seeded and not G.GAME.challenge  then
                    G.GAME.current_boss_streak = G.GAME.current_boss_streak + 1
                    check_and_set_high_score('boss_streak', G.GAME.current_boss_streak)
                end
                
                if G.GAME.current_round.hands_played == 1 then 
                    inc_career_stat('c_single_hand_round_streak', 1)
                else
                    if not G.GAME.seeded and not G.GAME.challenge  then
                        G.PROFILES[G.SETTINGS.profile].career_stats.c_single_hand_round_streak = 0
                        G:save_settings()
                    end
                end

                check_for_unlock({type = 'round_win'})
                set_joker_usage()
                for i=1, #G.hand.cards do
                    --Check for hand doubling
                    local reps = {1}
                    local j = 1
                    while j <= #reps do
                        local percent = (i-0.999)/(#G.hand.cards-0.998) + (j-1)*0.1
                        if reps[j] ~= 1 then card_eval_status_text((reps[j].jokers or reps[j].seals).card, 'jokers', nil, nil, nil, (reps[j].jokers or reps[j].seals)) end
    
                        --calculate the hand effects
                        local effects = {G.hand.cards[i]:get_end_of_round_effect()}
                        for k=1, #G.jokers.cards do
                            --calculate the joker individual card effects
                            local eval = G.jokers.cards[k]:calculate_joker({cardarea = G.hand, other_card = G.hand.cards[i], individual = true, end_of_round = true})
                            if eval then 
                                table.insert(effects, eval)
                            end
                        end

                        if reps[j] == 1 then 
                            --Check for hand doubling
                            --From Red seal
                            local eval = eval_card(G.hand.cards[i], {end_of_round = true,cardarea = G.hand, repetition = true, repetition_only = true})
                            if next(eval) and (next(effects[1]) or #effects > 1)  then 
                                for h = 1, eval.seals.repetitions do
                                    reps[#reps+1] = eval
                                end
                            end

                            --from Jokers
                            for j=1, #G.jokers.cards do
                                --calculate the joker effects
                                local eval = eval_card(G.jokers.cards[j], {cardarea = G.hand, other_card = G.hand.cards[i], repetition = true, end_of_round = true, card_effects = effects})
                                if next(eval) then 
                                    for h  = 1, eval.jokers.repetitions do
                                        reps[#reps+1] = eval
                                    end
                                end
                            end
                        end
        
                        for ii = 1, #effects do
                            --if this effect came from a joker
                            if effects[ii].card then
                                G.E_MANAGER:add_event(Event({
                                    trigger = 'immediate',
                                    func = (function() effects[ii].card:juice_up(0.7);return true end)
                                }))
                            end
                            
                            --If dollars
                            if effects[ii].h_dollars then 
                                ease_dollars(effects[ii].h_dollars)
                                card_eval_status_text(G.hand.cards[i], 'dollars', effects[ii].h_dollars, percent)
                            end

                            --Any extras
                            if effects[ii].extra then
                                card_eval_status_text(G.hand.cards[i], 'extra', nil, percent, nil, effects[ii].extra)
                            end
                        end
                        j = j + 1
                    end
                end
                delay(0.3)

                G.FUNCS.draw_from_hand_to_discard()
                G.FUNCS.draw_from_discard_to_deck()
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = function()
                        G.STATE = G.STATES.ROUND_EVAL
                        G.STATE_COMPLETE = false

                        if G.GAME.round_resets.blind == G.P_BLINDS.bl_small then
                            G.GAME.round_resets.blind_states.Small = 'Defeated'
                        elseif G.GAME.round_resets.blind == G.P_BLINDS.bl_big then
                            G.GAME.round_resets.blind_states.Big = 'Defeated'
                        else
                            for k, v in pairs(mdoms) do
                                v.ability.extra.active = false
                            end
                        end

                        if G.GAME.round_resets.temp_handsize then G.hand:change_size(-G.GAME.round_resets.temp_handsize); G.GAME.round_resets.temp_handsize = nil end
                        if G.GAME.round_resets.temp_reroll_cost then G.GAME.round_resets.temp_reroll_cost = nil; calculate_reroll_cost(true) end

                        reset_idol_card()
                        reset_mail_rank()
                        reset_ancient_card()
                        reset_castle_card()
                        for k, v in ipairs(G.playing_cards) do
                            v.ability.discarded = nil
                            v.ability.forced_selection = nil
                        end
                    return true
                    end
                }))
            end
        return true
        end
    }))
end

--Mdom replay boss function
local end_round_old = end_round
end_round = function()
    local mdoms = find_joker('MOAB Domination')
    if #mdoms > 0 then
        local active = true
        for k, v in pairs(mdoms) do
            if v.ability.extra.active == false then
                active = false
            end
        end
        if active then
            local ret = end_round_new(mdoms)
            return ret
        end
    end
    local ret = end_round_old()
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
    config = { extra = { chips = 30, mult = 3 } }, --Variables: chips = +chips, mult = +mult

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
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
    config = { extra = { retrigger = 2 } }, --Variables: retrigger = retrigger amount

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.retrigger } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.hand and context.other_card == G.hand.cards[1] and (next(context.card_effects[1]) or #context.card_effects > 1) then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger
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
    config = { extra = { Xmult = 1.5 } }, --Variables: Xmult = Xmult

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult} }
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
    config = { extra = { chips = 24, mult = 4 } }, --Variables: chips = +chips, mult = +mult

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 8 then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
            }
        end
    end
}

SMODS.Joker { --Ice
    key = 'ice',
    name = 'Ice Monkey',
	loc_txt = {
        name = 'Ice Monkey',
        text = {
            '{C:chips}+#1#{} Chips and {C:attention}Freeze{}',
            'all scoring cards on',
            '{C:attention}first hand{} of round'
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 0 },
    rarity = 1,
	cost = 3,
	order = 156,
	blueprint_compat = true,
    config = { extra = { chips = 50 } }, --Variables: chips = +chips

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function()
                return (G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES)
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
        elseif context.joker_main and G.GAME.current_round.hands_played == 0 then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
}

SMODS.Joker { --Glue
    key = 'glue',
    name = 'Glue Gunner',
	loc_txt = {
        name = 'Glue Gunner',
        text = {
            '{C:attention}First{} played card',
            'becomes {C:attention}Glued{} and gives',
            '{C:mult}+#1#{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 0 },
    rarity = 1,
	cost = 3,
	order = 156,
	blueprint_compat = true,
    config = { extra = { mult = 10 } }, --Variables: mult = +mult

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card == context.scoring_hand[1] and not context.other_card.debuff then
            context.other_card:set_ability('m_bloons_glued', nil, true)
            return {
                mult = card.ability.extra.mult
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
            '{C:inactive}(#3#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 6, y = 0 },
    rarity = 1,
	cost = 4,
	order = 157,
	blueprint_compat = true,
    config = { extra = { mult = 20, limit = 2, counter = 2 } }, --Variables: mult = +mult, limit = number of hands for +mult, counter = hand index

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
                    return (card.ability.extra.counter == card.ability.extra.limit - 1 and not G.RESET_JIGGLES)
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
	cost = 3,
	order = 158,
	blueprint_compat = true,
    config = { extra = { mult = 2 } }, --Variables: mult = +mult

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
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
    config = { extra = { money = 1, rate = 3, current = 0 } }, --Variables: money = dollars per sell cost, rate = sell cost rate, current = current end of round dollars

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money, card.ability.extra.rate, card.ability.extra.current } }
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            local sell_cost = 0
            for k, v in ipairs(G.jokers.cards) do
                if v ~= card then
                    sell_cost = sell_cost + v.sell_cost
                end
            end
            card.ability.extra.current = card.ability.extra.money * math.floor(sell_cost / card.ability.extra.rate)
        end
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
    config = { extra = { chips = 50 } }, --Variables: chips = +chips

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
    config = { extra = { Xmult = 2 } }, --Variables: Xmult = Xmult

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult} }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local last_number = nil
            for k, v in ipairs(context.scoring_hand) do
                if v:get_id() >= 0 and
                    (v:get_id() <= 10 or
                    v:get_id() == 14) then
                    last_number = v
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
    config = { extra = { num = 1, denom = 2, mult = 8 } }, --Variables: num/denom = probability fraction, mult = +mult

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'mortar')
        return { vars = { n, d, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and SMODS.pseudorandom_probability(card, 'mortar', card.ability.extra.num, card.ability.extra.denom, 'mortar') then
            return {
                mult = card.ability.extra.mult,
            }
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
    config = { extra = { max = 150, min = 0 } }, --Variables: max = max possible +chips, min = min possible +chips

    calculate = function(self, card, context)
        if context.joker_main then
            local temp_chips = pseudorandom('dartling', card.ability.extra.min, card.ability.extra.max)
            return {
                chips = temp_chips
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
            '{C:enhanced}Enhancement{} to {C:attention}first{} played',
            'card when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 1 },
    rarity = 1,
	cost = 4,
	order = 164,
	blueprint_compat = false,

    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.scoring_hand[1].debuff then
            local enhancement = pseudorandom_element(G.P_CENTER_POOLS['Enhanced'], pseudoseed('wiz'))
            context.scoring_hand[1]:set_ability(enhancement, nil, true)
            G.E_MANAGER:add_event(Event({
                func = function()
                    context.scoring_hand[1]:juice_up()
                    return true
                end
            })) 
            return {
                message = 'Magic!',
                colour = G.C.MONEY
            }
        end
    end
}

SMODS.Joker { --Super
    key = 'super',
    name = 'Super Monkey',
	loc_txt = {
        name = 'Super Monkey',
        text = {
            '{X:mult,C:white}X#1#{} Mult'
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 1 },
    rarity = 1,
	cost = 6,
	order = 165,
	blueprint_compat = true,
    config = { extra = { Xmult = 1.5 } }, --Variables: Xmult = Xmult

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.Xmult,
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
    soul_pos = { x = 0, y = 15 },
    rarity = 1,
	cost = 4,
	order = 166,
	blueprint_compat = true,
    config = { extra = { mult = 4, slots = 1} }, --Variables: mult = +mult, slots = extra joker slots

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.slots } }
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
                mult = card.ability.extra.mult,
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
            'a {C:spectral}Spectral{} card instead',
            '{C:inactive}(Must have room){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 6, y = 1 },
    rarity = 1,
	cost = 5,
	order = 167,
	blueprint_compat = true,
    config = { extra = { num = 1, denom = 2 } }, --Variables: num/denom = probability fraction

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'alch')
        return { vars = { n, d } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_left == 0 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            if SMODS.pseudorandom_probability(card, 'alch', card.ability.extra.num, card.ability.extra.denom, 'alch') then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        local card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'alch')
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
                        local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'alch')
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
    config = { extra = { mult = 20 } }, --Variables: mult = +mult

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands['Full House']) then
            return {
                mult = card.ability.extra.mult,
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
            '{C:mult}+#1#{} Mult if played',
            'hand contains',
            'a {C:attention}Bonus Card{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 8, y = 1 },
    rarity = 1,
	cost = 3,
	order = 169,
	blueprint_compat = true,
    enhancement_gate = 'm_bonus',
    config = { extra = { mult = 15 } }, --Variables: mult = +mult

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            for k, v in ipairs(context.scoring_hand) do
                if v.ability.name == 'Mult' then
                    return {
                        mult = card.ability.extra.mult,
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
    config = { extra = { money = 1, current = 0 } }, --Variables: money = dollars per joker, current = current end of round dollars

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money, card.ability.extra.current } }
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            card.ability.extra.current = #G.jokers.cards
        end
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.current
    end
}

SMODS.Joker { --Spac
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
    config = { extra = { chips = 25, current = 0 } }, --Variables: chips = +chips for each discard used, current = current +chips

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card == context.full_hand[#context.full_hand] and not context.blueprint then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.chips
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.current}},
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

SMODS.Joker { --Village
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
    config = { extra = { mult = 5 } }, --Variables: mult = +mult

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
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
                mult = card.ability.extra.mult
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
    config = { extra = { money = 3 } }, --Variables: money = dollars

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
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
            '{C:chips}+#1#{} Chips if played',
            'hand contains',
            'a {C:attention}Mult Card{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 2 },
    rarity = 1,
	cost = 3,
	order = 174,
	blueprint_compat = true,
    enhancement_gate = 'm_mult',
    config = { extra = { chips = 90 } }, --Variables: chips = +chips

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            for k, v in ipairs(context.scoring_hand) do
                if v.ability.name == 'Bonus' then
                    return {
                        chips = card.ability.extra.chips,
                    }
                end
            end
        end
    end
}

SMODS.Joker { --Desp
    key = 'desp',
    name = 'Desperado',
    loc_txt = {
        name = 'Desperado',
        text = {
            '{C:attention}First #1#{} played',
            'cards give {C:chips}+#2#{}',
            'Chips when scored'
        }
    },
    atlas = 'Joker',
	pos = { x = 4, y = 2 },
    rarity = 1,
	cost = 3,
	order = 175,
	blueprint_compat = true,
    config = { extra = { number = 2, chips = 20 } }, --Variables: number = number of cards, chips = +chips

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.number, card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            for i = 1, card.ability.extra.number do
                if context.other_card == context.scoring_hand[i] then
                    if context.other_card.debuff then
                        return {
                            message = localize('k_debuffed'),
                            colour = G.C.RED
                        }
                    else
                        return {
                            chips = card.ability.extra.chips
                        }
                    end
                end
            end
		end
    end
}

SMODS.Joker { --Cave
    key = 'cave',
    name = 'Cave Monkey',
    loc_txt = {
        name = 'Cave Monkey',
        text = {
            'Me Hit {C:attention}Rock{}'
        }
    },
    atlas = 'Joker',
	pos = { x = 5, y = 2 },
    rarity = 1,
	cost = 1,
	order = 176,
	blueprint_compat = false,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
    end,
    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function() 
                local front = pseudorandom_element(G.P_CARDS, pseudoseed('cave'))
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                local card = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS.m_stone, {playing_card = G.playing_card})
                card:start_materialize({G.C.SECONDARY_SET.Enhanced})
                G.play:emplace(card)
                table.insert(G.playing_cards, card)
                return true
            end
        }))
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_stone'), colour = G.C.SECONDARY_SET.Enhanced})

        G.E_MANAGER:add_event(Event({
            func = function()
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                return true
            end
        }))
        draw_card(G.play,G.deck, 90,'up', nil)
        playing_card_joker_effects({true})
    end,
}

SMODS.Joker { --Eyesight
    key = 'eyesight',
    name = 'Enhanced Eyesight',
    loc_txt = {
        name = 'Enhanced Eyesight',
        text = {
            '{C:attention}+#1#{} consumable slot'
        }
    },
    atlas = 'Joker',
	pos = { x = 0, y = 3 },
    rarity = 1,
	cost = 4,
	order = 181,
	blueprint_compat = false,
    config = { extra = { slots = 1 } }, --Variables: slots = extra consumable slots

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.slots } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.slots
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.slots
    end,
}

SMODS.Joker { --Red Hot
    key = 'redhot',
    name = 'Red Hot Rangs',
    loc_txt = {
        name = 'Red Hot Rangs',
        text = {
            'Retrigger {C:attention}last{} scored card',
            '{C:attention}#1#{} times if scoring hand',
            'contains {C:attention}#2#{} or more cards'
        }
    },
    atlas = 'Joker',
	pos = { x = 1, y = 3 },
    rarity = 1,
	cost = 4,
	order = 182,
	blueprint_compat = true,
    config = { extra = { retrigger = 2, number = 3 } }, --Variables: retrigger = retrigger amount, number = cards required for retrigger

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.retrigger, card.ability.extra.number } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and #context.scoring_hand >= card.ability.extra.number and context.other_card == context.scoring_hand[#context.scoring_hand] then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger,
            }
        end
    end
}

SMODS.Joker { --More Tacks
    key = 'moretacks',
    name = 'More Tacks',
	loc_txt = {
        name = 'More Tacks',
        text = {
            'Each played {C:attention}10{} gives',
            '{C:chips}+#1#{} Chips and',
            '{C:mult}+#2#{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 3 },
    rarity = 1,
	cost = 4,
	order = 184,
	blueprint_compat = true,
    config = { extra = { chips = 20, mult = 5 } }, --Variables: chips = +chips, mult = +mult

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 10 then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
            }
        end
    end
}

SMODS.Joker { --Refreeze
    key = 'refreeze',
    name = 'Re-Freeze',
    loc_txt = {
        name = 'Re-Freeze',
        text = {
            'Retrigger {C:attention}Frozen{} cards',
            'that are held in hand'
        }
    },
    atlas = 'Joker',
	pos = { x = 4, y = 3 },
    rarity = 1,
	cost = 4,
	order = 185,
	blueprint_compat = true,
    enhancement_gate = 'm_bloons_frozen',
    config = { extra = { retrigger = 1 } }, --Variables = retrigger = retrigger amount

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

SMODS.Joker { --Corrosive
    key = 'corrosive',
    name = 'Corrosive Glue',
    loc_txt = {
        name = 'Corrosive Glue',
        text = {
            'This Joker gains',
            '{C:chips}+#1#{} Chips for every played',
            '{C:attention}Glued{} card that scores',
            '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)'
        }
    },
    atlas = 'Joker',
	pos = { x = 5, y = 3 },
    rarity = 1,
	cost = 4,
	order = 186,
	blueprint_compat = true,
    perishable_compat = false,
    enhancement_gate = 'm_bloons_glued',
    config = { extra = { chips = 10, current = 0 } }, --Variables: chips = +chip gain for each glued card, current = current +chips

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
        return { vars = { card.ability.extra.chips, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            for k, v in ipairs(context.scoring_hand) do
                if v.ability.name == 'Glued Card' then
                    card.ability.extra.current = card.ability.extra.current + card.ability.extra.chips
                end
            end
        elseif context.joker_main then
            return {
                chips = card.ability.extra.current,
            }
        end
    end
}

SMODS.Joker { --Burny
    key = 'burny',
    name = 'Burny Stuff',
    loc_txt = {
        name = 'Burny Stuff',
        text = {
            '{C:green}#1# in #2#{} chance to',
            'destroy {C:attention}first{} played',
            'card that scores'
        }
    },
    atlas = 'Joker',
	pos = { x = 1, y = 4 },
    rarity = 1,
	cost = 5,
	order = 192,
	blueprint_compat = true,
    config = { extra = { num = 1, denom = 4 } }, --Variables: num/denom = probability fraction 

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'burny')
        return { vars = { n, d } }
    end,
    calculate = function(self, card, context)
        if context.destroying_card and context.scoring_hand[1] and context.destroying_card == context.scoring_hand[1] and SMODS.pseudorandom_probability(card, 'burny', card.ability.extra.num, card.ability.extra.denom, 'burny') then
            return true
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
            'card if {C:attention}scoring hand{}',
            'contains {C:attention}#1# Bonus Cards{}',
            '{C:inactive}(Must have room){}'
        }
    },
    atlas = 'Joker',
	pos = { x = 8, y = 4 },
    rarity = 1,
	cost = 5,
	order = 199,
	blueprint_compat = true,
    enhancement_gate = 'm_bonus',
    config = { extra = { number = 2 } }, --Variables: required = required bonus cards for planet

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
        return { vars = { card.ability.extra.number } }
    end,
    calculate = function(self, card, context)
        if context.before and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            local count = 0
            for k, v in ipairs(context.scoring_hand) do
                if v.ability.name == 'Bonus' then
                    count = count + 1
                end
            end
            if count >= card.ability.extra.number then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        local card = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'enetwork')
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

SMODS.Joker { --Salvage
    key = 'salvage',
    name = 'Banana Salvage',
    loc_txt = {
        name = 'Banana Salvage',
        text = {
            'All cards sell for {C:money}$#1#{} more'
        }
    },
    atlas = 'Joker',
	pos = { x = 9, y = 4 },
    rarity = 1,
	cost = 5,
	order = 200,
	blueprint_compat = false,
    config = { extra = { cost = 2 } }, --Variables: cost = extra sell price

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cost } }
    end,
    add_to_deck = function(self, card, from_debuff)
        recalc_all_costs()
    end,
    remove_from_deck = function(self, card, from_debuff)
        recalc_all_costs()
    end,
    calculate = function(self, card, context)
        if context.buying_card then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.0,
                func = (function()
                    for k, v in ipairs(G.jokers.cards) do
                        if v.set_cost then 
                            v:set_cost()
                        end
                    end
                    for k, v in ipairs(G.consumeables.cards) do
                        if v.set_cost then
                            v:set_cost()
                        end
                    end
                    return true
                end)
            }))
        end
    end
}

SMODS.Joker { --Discount
    key = 'discount',
    name = 'Monkey Commerce',
    loc_txt = {
        name = 'Monkey Commerce',
        text = {
            'Shop items cost {C:attention}$#1#{} less'
        }
    },
    atlas = 'Joker',
	pos = { x = 1, y = 5 },
    rarity = 1,
	cost = 5,
	order = 203,
	blueprint_compat = false,
    config = { extra = { cost = 1 } }, --Variables: cost = discount amount

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cost } }
    end,
    add_to_deck = function(self, card, from_debuff)
        recalc_all_costs()
    end,
    remove_from_deck = function(self, card, from_debuff)
        recalc_all_costs()
    end,
}

SMODS.Joker { --Owl
    key = 'owl',
    name = 'Horned Owl',
    loc_txt = {
        name = 'Horned Owl',
        text = {
            'Create a random {C:tarot}Tarot{}',
            'card if {C:attention}scoring hand{}',
            'contains {C:attention}#1# Mult Cards{}',
            '{C:inactive}(Must have room){}'
        }
    },
    atlas = 'Joker',
	pos = { x = 3, y = 5 },
    rarity = 1,
	cost = 5,
	order = 204,
	blueprint_compat = true,
    enhancement_gate = 'm_mult',
    config = { extra = { number = 2 } }, --Variables: number = required bonus cards for planet

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
        return { vars = { card.ability.extra.number } }
    end,
    calculate = function(self, card, context)
        if context.before and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            local count = 0
            for k, v in ipairs(context.scoring_hand) do
                if v.ability.name == 'Mult' then
                    count = count + 1
                end
            end
            if count >= card.ability.extra.number then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, 'owl')
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
            'Create {C:attention}#1# {C:tarot}Tarot{} cards',
            'if {C:attention}played hand{} is a',
            '{C:attention}Three of a Kind #2#{} times',
            '{C:inactive}(#3# remaining){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 6 },
    rarity = 1,
	cost = 5,
	order = 211,
	blueprint_compat = true,
    config = { extra = { tarots = 3, limit = 3, counter = 3 } }, --Variables: tarots = number of tarots, limit = number of 3oaks for tarots, counter = current count index

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.tarots, card.ability.extra.limit, card.ability.extra.counter } }
    end,
    calculate = function(self, card, context)
        if context.before and next(context.poker_hands['Three of a Kind']) and not
                next(context.poker_hands['Flush']) and not
                next(context.poker_hands['Full House']) and not
                next(context.poker_hands['Four of a Kind']) then
            if not context.blueprint then
                card.ability.extra.counter = card.ability.extra.counter - 1
                local eval = function()
                    return (card.ability.extra.counter == 1 and not G.RESET_JIGGLES)
                end
                juice_card_until(card, eval, true)
            end
            if card.ability.extra.counter == 0 then
                card.ability.extra.counter = card.ability.extra.limit
                for i = 1, card.ability.extra.tarots do
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

SMODS.Joker { --Bioboomer
    key = 'bioboomer',
    name = 'Bionic Boomerang',
	loc_txt = {
        name = 'Bionic Boomerang',
        text = {
            'This {C:attention}Joker{} gains {C:mult}+#1#{}',
            'Mult if a {C:attention}Steel{} card',
            'is held in hand',
            '{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)'
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 6 },
    rarity = 1,
	cost = 6,
	order = 212,
	blueprint_compat = true,
    perishable_compat = false,
    enhancement_gate = 'm_steel',
    config = { extra = { mult = 1, current = 0 } }, --Variables: mult = +mult gain if steel is held, current = current +mult

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
		return { vars = { card.ability.extra.mult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local has_steel = false
            for k, v in ipairs(G.hand.cards) do
                if v.ability.name == 'Steel Card' then
                    has_steel = true
                    break
                end
            end
            if has_steel then
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult
            end
        elseif context.joker_main then
            return {
                mult = card.ability.extra.current
            }
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
    config = { extra = { Xmult = 2.5 } }, --Variables: Xmult = Xmult

    loc_vars = function(self, info_queue, card)
        
		return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.blind.boss then
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --Shards
    key = 'shards',
    name = 'Ice Shards',
	loc_txt = {
        name = 'Ice Shards',
        text = {
            'This {C:attention}Joker{} gains {C:mult}+#1#{} ',
            'Mult whenever a {C:attention}Frozen Card{}',
            'thaws out or is destroyed',
            '{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)'
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 6 },
    rarity = 2,
	cost = 6,
	order = 215,
	blueprint_compat = true,
    perishable_compat = false,
    enhancement_gate = 'm_bloons_frozen',
    config = { extra = { mult = 2, current = 0 } },

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

SMODS.Joker { --Glose
    key = 'glose',
    name = 'Glue Hose',
	loc_txt = {
        name = 'Glue Hose',
        text = {
            '{C:attention}Glue{} all discarded cards',
            '{C:attention}Glued{} cards no longer',
            'lose money when discarded'
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 6 },
    rarity = 2,
	cost = 6,
	order = 216,
	blueprint_compat = true,
    enhancement_gate = 'm_bloons_glued',

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
    end,
    calculate = function(self, card, context)
        if context.discard and not context.other_card.debuff then
            context.other_card:set_ability('m_bloons_glued', nil, true)
            return {
                message = 'Glued!',
                colour = G.C.MONEY
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
            '{C:inactive}(#3#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 6, y = 6 },
    rarity = 2,
	cost = 7,
	order = 217,
	blueprint_compat = true,
    config = { extra = { Xmult = 3, limit = 3, counter = 3 } }, --Variables: Xmult = Xmult, limit = number of hands for Xmult, counter = hand index

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
                    return (card.ability.extra.counter == card.ability.extra.limit - 1 and not G.RESET_JIGGLES)
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
    config = { extra = { Xmult = 0.1, current = 1 } }, --Variables: Xmult = Xmult gain for each 3oak held, current = current Xmult

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local ranks = {}
            local has_3oak = false
            for i, j in ipairs(G.hand.cards) do
                local new = true
                local id = j:get_id()
                for k, v in pairs(ranks) do
                    if id == k then
                        ranks[k] = v + 1
                        if ranks[k] == 3 then
                            has_3oak = true
                        end
                        new = false
                    end
                end
                if new then
                    ranks[id] = 1
                end
            end
            if has_3oak then
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult
            end
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Nevamiss
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
	order = 221,
	blueprint_compat = true,
    config = { extra = { percent_min = 80, percent_max = 120 } }, --Variables: percent_min = minimum percent of required chips scored, percent_max = maximum percent of required chips scored

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.percent_min, card.ability.extra.percent_max } }
    end,
    calculate = function(self, card, context)
        if context.after and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and
                (hand_chips*mult + G.GAME.chips)/G.GAME.blind.chips >= card.ability.extra.percent_min / 100.0 and
                (hand_chips*mult + G.GAME.chips)/G.GAME.blind.chips <= card.ability.extra.percent_max / 100.0 then
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

SMODS.Joker { --Draft
    key = 'draft',
    name = 'Downdraft',
    loc_txt = {
        name = 'Downdraft',
        text = {
            '{C:blue}+#1#{} hand',
            '{C:blue}+2#{} hands against {C:attention}Boss Blinds{}',
            'Extra hands score no chips',
            '{C:inactive}(#3# remaining{C:inactive})'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 7 },
    rarity = 2,
	cost = 7,
	order = 221,
	blueprint_compat = true,
    config = { extra = { hands = 1, boss_hands = 2, counter = 0 } }, --Variables: hands = extra hands, scored_chips = chips for first hands, current = amount of blowback hands left

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.hands, card.ability.extra.boss_hands, card.ability.extra.counter } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced then
            local hands
            if G.GAME.blind.boss then
                hands = card.ability.extra.boss_hands
            else
                hands = card.ability.extra.hands
            end
            card.ability.extra.counter = card.ability.extra.counter + hands
            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_hands_played(hands)
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_hands', vars = {hands}}})
                    return true 
                end 
            }))
        elseif context.first_hand_drawn and not context.blueprint then
            local eval = function()
                return (card.ability.extra.counter > 0 and not G.RESET_JIGGLES)
            end
            juice_card_until(card, eval, true)
        elseif context.final_scoring_step and card.ability.extra.counter > 0 and not context.blueprint then
            hand_chips = mod_chips(0)
            hand_mult = mod_mult(0)
            card.ability.extra.counter = card.ability.extra.counter - 1
            update_hand_text( { delay = 0 }, { chips = hand_chips, mult = hand_mult } )
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("timpani", 1)
					attention_text({
						scale = 1.4,
						text = "Blowback",
						hold = 0.45,
						align = "cm",
						offset = { x = 0, y = -2.7 },
						major = G.play,
					})
					return true
				end,
			}))
            delay(0.6)
        end
    end
}

SMODS.Joker { --Shell Shock
    key = 'shock',
    name = 'Shell Shock',
    loc_txt = {
        name = 'Shell Shock',
        text = {
            '{C:green}#1# in #2#{} chance to',
            '{C:attention}stun{} and retrigger',
            'each scoring card'
        }
    },
    atlas = 'Joker',
	pos = { x = 1, y = 7 },
    rarity = 1,
	cost = 5,
	order = 222,
	blueprint_compat = true,
    config = { extra = { num = 1, denom = 2, retrigger = 1 } }, --Variables: num/denom = probability fraction 

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_bloons_stunned
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'shock')
        return { vars = { n, d } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and SMODS.pseudorandom_probability(card, 'shock', card.ability.extra.num, card.ability.extra.denom, 'shock') then
            context.other_card:set_ability('m_bloons_stunned', nil, true)
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger
            }
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
    config = { extra = { max = 33, min = 10 } }, --Variables: max = max possible Xmult *10, min = min possible Xmult *10

    calculate = function(self, card, context)
        if context.joker_main then
            local temp_Xmult = pseudorandom('buckshot', card.ability.extra.min, card.ability.extra.max) / 10.0
            return {
                x_mult = temp_Xmult
            }
		end
    end
}

SMODS.Joker { --Amast
    key = 'amast',
    name = 'Arcane Mastery',
	loc_txt = {
        name = 'Arcane Mastery',
        text = {
            'Retrigger all scoring',
            'cards with {C:enhanced}Enhancements{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 7 },
    rarity = 3,
	cost = 7,
	order = 284,
	blueprint_compat = true,
    config = { extra = { retrigger = 1 } }, --Variables: retrigger = retrigger amount

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card.config.center ~= G.P_CENTERS.c_base then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger
            }
        end
    end
}

SMODS.Joker { --Flash
    key = 'flash',    
    name = 'Flash Bomb',
	loc_txt = {
        name = 'Flash Bomb',
        text = {
            '{C:mult}+#1#{} Mult and {C:attention}Stun{}',
            'all scoring {C:spades}Spades{}',
            'every {C:attention}#2#{} hands',
            '{C:inactive}(#3#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 7 },
    rarity = 2,
	cost = 6,
	order = 286,
	blueprint_compat = false,
    eternal_compat = false,
    config = { extra = { mult = 30, limit = 4, counter = 4 } }, --Variables: Xmult = Xmult, limit = number of hands for Xmult, counter = hand index

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_bloons_stunned
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
                process_var(card.ability.extra.counter, card.ability.extra.limit),
			},
		}
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            card.ability.extra.counter = (G.GAME.hands_played - card.ability.hands_played_at_create)%(card.ability.extra.limit) + 1
            local eval = function()
                return (card.ability.extra.counter == card.ability.extra.limit - 1 and not G.RESET_JIGGLES)
            end
            juice_card_until(card, eval, true)
            if card.ability.extra.counter == card.ability.extra.limit then
                for k, v in ipairs(context.scoring_hand) do
                    if v:is_suit('Spades', true) then
                        v:set_ability(G.P_CENTERS.m_bloons_stunned)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v:juice_up()
                                return true
                            end
                        }))
                    end
                end
            end
        elseif context.joker_main and card.ability.extra.counter == card.ability.extra.limit then
            return {
                x_mult = card.ability.extra.mult,
            }
        end
    end
}

SMODS.Joker { --Brew
    key = 'brew',    
    name = 'Berserker Brew',
	loc_txt = {
        name = 'Berserker Brew',
        text = {
            'Sell this card',
            'to give a random',
            '{C:attention}Joker {C:dark_edition}Polychrome{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 6, y = 7 },
    rarity = 2,
	cost = 6,
	order = 227,
	blueprint_compat = false,
    eternal_compat = false,
    config = { eligible_jokers = {} }, --Variables: eligible_jokers = possible jokers to give polychrome
    
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
    end,
    calculate = function(self, card, context)
        if context.selling_self and not context.blueprint then
            card.eligible_jokers = EMPTY(card.eligible_jokers)
            for k, v in pairs(G.jokers.cards) do
                if v.ability.set == 'Joker' and not v.edition and v ~= card then
                    table.insert(card.eligible_jokers, v)
                end
            end
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    local joker = pseudorandom_element(card.eligible_jokers, pseudoseed('brew'))
                    if joker then
                        joker:set_edition('e_polychrome', true)
                    end
                    return true
                end
            }))
        end
    end
}

SMODS.Joker { --Bank
    key = 'bank',
    name = 'Monkey Bank',
	loc_txt = {
        name = 'Monkey Bank',
        text = {
            'Gain sell value equal to',
            'interest at end of round',
            'Sell this Joker for {C:money}$#1#{} or more',
            'to create a {C:attention}Monkey Bank{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 7 },
    rarity = 2,
	cost = 7,
	order = 230,
	blueprint_compat = false,
    eternal_compat = false,
    config = { extra = { sell_limit = 10 } }, --Variables: money = required sell price to create bank

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.sell_limit } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and G.GAME.dollars > 5 and not context.individual and not context.repetition and not context.blueprint then
            if G.GAME.dollars >= G.GAME.interest_cap then
                card.ability.extra_value = card.ability.extra_value + math.floor(G.GAME.interest_cap / 5)
            else 
                card.ability.extra_value = card.ability.extra_value + math.floor(G.GAME.dollars / 5)
            end
            card:set_cost()
            return {
                message = localize('k_val_up'),
                colour = G.C.MONEY
            }
        elseif context.selling_self and card.sell_cost >= card.ability.extra.sell_limit and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local card = create_card('j_bloons_bank', G.jokers, nil, nil, nil, nil, 'j_bloons_bank', 'bank')
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    card:start_materialize()
                    return true
                end
            }))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE}) 
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
    perishable_compat = false,
    config = { extra = { mult = 1, loss = 5, current = 0 } }, --Variables: mult = +mult per spade discarded, current = current +mult, loss = -mult at end of round

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.loss, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card:is_suit('Spades', true) and not context.blueprint then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.current}},
                colour = G.C.MULT,
                delay = 0.45,
            }
        elseif context.joker_main and card.ability.extra.current > 0 then
            return {
            mult = card.ability.extra.current,
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

SMODS.Joker { --MIB
    key = 'mib',
    name = 'Monkey Intelligence Bureau ',
    loc_txt = {
        name = 'Monkey Intelligence Bureau',
        text = {
            '{C:attention}Listed {C:green,E:1,S:1.1}probabilities{} are',
            'multiplied by the number of unique ',
            'rarities in other owned {C:attention}Jokers',
            '{C:inactive}(Currently {C:green}X#1#{C:inactive})',
        }
    },
    atlas = 'Joker',
    pos = { x = 1, y = 8 },
    rarity = 2,
    cost = 7,
    order = 232,
    blueprint_compat = false,
    config = { extra = { num = 1 } },

    loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.extra.num } }
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            local probability = 0
            local rarity_list = {}
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= card then
                    local rarity = G.jokers.cards[i].config.center.rarity
                    local new_rarity = true
                    for k, v in pairs(rarity_list) do
                        if rarity == v then
                            new_rarity = false
                        end
                    end
                    if new_rarity then
                        rarity_list[#rarity_list+1] = rarity
                    end
                end
            end
            card.ability.extra.num = #rarity_list
        end
    end,
    calculate = function(self, card, context)
        if context.mod_probability and not context.blueprint then
            return {
                numerator = context.numerator * card.ability.extra.num
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
	cost = 5,
	order = 241,
	blueprint_compat = true,
    config = { extra = { mult = 2, current = 0 } }, --Variables: mult = +mult for each card scored, current = current +mult

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.individual then
			if context.cardarea == G.play then
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult
                return {
                    mult = card.ability.extra.current
                }
            end
		elseif context.after then
            card.ability.extra.current = 0
        end
    end
}

SMODS.Joker { --Press
    key = 'Press',
    name = 'MOAB Press',
    loc_txt = {
        name = 'MOAB Press',
        text = {
            'If played hand is a',
            'single {C:attention}face{} card',
            'on the {C:attention}Boss Blind{},',
            'add a {C:attention}Red Seal{} to it',
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 9 },
    rarity = 2,
	cost = 5,
	order = 242,
	blueprint_compat = false,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS.Red
    end,
    calculate = function(self, card, context)
        if context.before and G.GAME.blind.boss and #context.full_hand == 1 and not context.full_hand[1].debuff and context.full_hand[1]:is_face() and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    context.full_hand[1]:set_seal('Red', nil, true)
                    return true
                end
            }))
            delay(0.5)
        end
    end
}

SMODS.Joker { --Blimpact
    key = 'blimpact',
    name = 'Bloon Impact',
    loc_txt = {
        name = 'Bloon Impact',
        text = {
            '{C:attention}Stun{} all scoring cards on',
            '{C:attention}first hand{} of round'
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 9 },
    rarity = 2,
	cost = 6,
	order = 244,
	blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_bloons_stunned
    end,
    calculate = function(self, card, context)
        if context.before and G.GAME.current_round.hands_played == 0 then
            for k, v in pairs(context.scoring_hand) do
                if not v.debuff then
                    v:set_ability('m_bloons_stunned', nil, true)
                    v:juice_up()
                end
            end
            if context.other_card == context.scoring_hand[1] then
                return {
                    message = 'Stunned!',
                    colour = G.C.RED
                }
            end
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
            '{X:mult,C:white}X#1#{} Mult for every {C:attention}8{}',
            'played this round',
            '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 9 },
    rarity = 2,
	cost = 6,
	order = 244,
	blueprint_compat = true,
    config = { extra = { Xmult = 0.5, current = 1 } }, --Variables: Xmult = Xmult gain for each 8, current = current Xmult

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            for k, v in ipairs(context.scoring_hand) do
                if v:get_id() == 8 then
                    card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult
                end
            end
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

SMODS.Joker { --Icicles
    key = 'icicles',
    name = 'Icicles',
    loc_txt = {
        name = 'Icicles',
        text = {
            '{X:mult,C:white}X#1#{} Mult',
            '{C:green}#2# in #3#{} chance to {C:attention}Freeze{}',
            'each {C:attention}discarded{} card'
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 9 },
    rarity = 2,
	cost = 6,
	order = 245,
	blueprint_compat = true,

    config = { extra = { Xmult = 2, num = 1, denom = 2 } }, --Variables: Xmult = Xmult, num/denom = probability fraction
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'icicles')
        return { vars = { card.ability.extra.Xmult, n, d } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return{
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

SMODS.Joker { --Relentless
    key = 'relentless',
    name = 'Relentless Glue',
    loc_txt = {
        name = 'Relentless Glue',
        text = {
            '{C:attention}Glue{} never wears off',
            'Retrigger all played',
            '{C:attention}Glued{} cards'
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 9 },
    rarity = 2,
	cost = 6,
	order = 246,
	blueprint_compat = true,
    enhancement_gate = 'm_bloons_glued',
    config = { extra = { retrigger = 1 } }, --Variables: retrigger = retrigger amount

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card.ability.name == 'Glued Card' then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger
            }
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
	pos = { x = 6, y = 9 },
    rarity = 2,
	cost = 7,
	order = 247,
	blueprint_compat = true,
    config = { extra = { limit = 4, counter = 4 } }, --Variables: Xmult = Xmult, limit = number of hands for Xmult, counter = hand index

    loc_vars = function(self, info_queue, card)
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
                    return (card.ability.extra.counter == card.ability.extra.limit - 1 and not G.RESET_JIGGLES)
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

SMODS.Joker { --Flavored
    key = 'flavored',
    name = 'Favored Trades',
	loc_txt = {
        name = 'Favored Trades',
        text = {
            'If {C:attention}first hand{} of round',
            'is a single {C:diamond}Diamond{},',
            'add a {C:attention}Purple Seal{} to it',
        }
    },
	atlas = 'Joker',
	pos = { x = 8, y = 9 },
    rarity = 2,
	cost = 7,
	order = 249,
	blueprint_compat = false,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS.Purple
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function()
                return (G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES)
            end
            juice_card_until(card, eval, true)
        elseif context.before and G.GAME.current_round.hands_played == 0 and #context.full_hand == 1 and context.full_hand[1]:is_suit('Diamonds') and not context.full_hand[1].debuff and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    context.full_hand[1]:set_seal('Purple', nil, true)
                    return true
                end
            }))
            delay(0.5)
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
	cost = 7,
	order = 250,
	blueprint_compat = true,
    config = { extra = { chips = 350 } }, --Variables: chips = +chips

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

SMODS.Joker { --Comdef
    key = 'comdef',
    name = 'Comanche Defense',
	loc_txt = {
        name = 'Comanche Defense',
        text = {
            '{C:chips}+#1#{} Chips',
            'This Joker gains {C:chips}+#2#{} Chips after',
            '{C:attention}first hand{} of round, resets when',
            '{C:attention}Boss Blind{} is defeated'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 10 },
    rarity = 2,
	cost = 7,
	order = 251,
	blueprint_compat = true,
    config = { extra = { chips = 30, current = 30, mini_chips = 40 } }, --Variables: chips = base chips

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current, card.ability.extra.mini_chips } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.current
            }
        elseif context.after and G.GAME.current_round.hands_played == 0 and not context.blueprint then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.mini_chips
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.current}},
                colour = G.C.CHIPS,
            }
        elseif context.end_of_round and context.beat_boss and card.ability.extra.current > card.ability.extra.chips and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = card.ability.extra.chips
            return {
                message = localize('k_reset'),
                colour = G.C.RED
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
            'scoring cards to give',
            '{C:chips}+#3#{} Chips, {C:mult}+#4#{} Mult, and',
            '{X:mult,C:white}X#5#{} Mult independently'
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 10 },
    rarity = 2,
	cost = 7,
	order = 252,
	blueprint_compat = true,
    config = { extra = { num = 1, denom = 3, chips = 33, mult = 8, Xmult = 1.3 } }, --Variables: num/denom = probabiltiy fraction, chips = +chips, mult = +mult, Xmult = Xmult

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'abatt')
        return {
            vars = {
                n,
                d,
                card.ability.extra.chips,
                card.ability.extra.mult,
                card.ability.extra.Xmult
            }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local temp_chips, temp_mult, temp_Xmult = 0, 0, 1
            if SMODS.pseudorandom_probability(card, 'abatt1', card.ability.extra.num, card.ability.extra.denom, 'abatt') then
                temp_chips = card.ability.extra.chips
            end
            if SMODS.pseudorandom_probability(card, 'abatt2', card.ability.extra.num, card.ability.extra.denom, 'abatt') then
                temp_mult = card.ability.extra.mult
            end
            if SMODS.pseudorandom_probability(card, 'abatt3', card.ability.extra.num, card.ability.extra.denom, 'abatt') then
                temp_Xmult = card.ability.extra.Xmult
            end
                return {
                    chips = temp_chips,
                    mult = temp_mult,
                    x_mult = temp_Xmult
                }
		end
    end
}

SMODS.Joker { --Rorm
    key = 'rorm',
    name = 'Rocket Storm',
	loc_txt = {
        name = 'Rocket Storm',
        text = {
            'This Joker gains {X:mult,C:white}X0.??{}',
            'Mult per {C:attention}consecutive{} hand',
            'played containing a {C:attention}Pair{}',
            '{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 10 },
    rarity = 2,
	cost = 7,
	order = 253,
	blueprint_compat = true,
    perishable_compat = false,
    config = { extra = { max = 15, min = 0, current = 1 } }, --Variables: max = max possible Xmult gain *100, min = min possible Xmult gain *100, current = current Xmult
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and context.poker_hands then
            if next(context.poker_hands['Pair']) then
                local temp_Xmult = pseudorandom('rorm', card.ability.extra.min, card.ability.extra.max) / 100.0
                card.ability.extra.current = card.ability.extra.current + temp_Xmult
            else
                if card.ability.extra.current > 1 then
                    card.ability.extra.current = 1
                    return {
                        message = localize('k_reset'),
                        colour = G.C.RED,
                    }
                end
            end
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Necro
    key = 'necro',
    name = 'Necromancer',
	loc_txt = {
        name = 'Necromancer',
        text = {
            'Whenever cards are',
            'destroyed, create a ',
            'copy of the {C:attention}last{}',
            'card held in hand'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 10 },
    rarity = 2,
	cost = 6,
	order = 254,
	blueprint_compat = true,

    calculate = function(self, card, context)
        if (context.cards_destroyed or context.remove_playing_cards) and #G.hand.cards >= 1 then
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            local front = copy_card(G.hand.cards[#G.hand.cards], nil, nil, G.playing_card)
            front:add_to_deck()
            G.deck.config.card_limit = G.deck.config.card_limit + 1
            table.insert(G.playing_cards, front)
            G.hand:emplace(front)
            front.states.visible = nil

            G.E_MANAGER:add_event(Event({
                func = function()
                    front:start_materialize()
                    return true
                end
            })) 
            return {
                message = localize('k_copied_ex'),
                colour = G.C.CHIPS,
                playing_cards_created = {true}
            }
        end
    end
}

SMODS.Joker { --Sabo
    key = 'sabo',
    name = 'Bloon Sabotage',
	loc_txt = {
        name = 'Bloon Sabotage',
        text = {
            '{C:green}#1# in #2#{} chance to',
            'gain {C:red}+#3#{} discard if',
            'played hand has a scoring',
            '{C:hearts}Heart{} and a scoring',
            'card of any other {C:attention}suit{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 10 },
    rarity = 2,
	cost = 6,
	order = 256,
	blueprint_compat = true,
    config = { extra = { num = 1, denom = 2, discards = 1 } }, --Variables: num/denom = probability fraction, discards = number of discards gained

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'pex')
        return { vars = { n, d, card.ability.extra.discards } }
    end,

    calculate = function(self, card, context)
        if context.before and SMODS.pseudorandom_probability(card, 'sabo', card.ability.extra.num, card.ability.extra.denom, 'sabo') then
            local suits = {
                ['Hearts'] = 0,
                ['Diamonds'] = 0,
                ['Spades'] = 0,
                ['Clubs'] = 0
            }
            for k, v in ipairs(context.scoring_hand) do
                if v.ability.name ~= 'Wild Card' then
                    if v:is_suit('Hearts') then suits["Hearts"] = suits["Hearts"] + 1 end
                    if v:is_suit('Diamonds') then suits["Diamonds"] = suits["Diamonds"] + 1 end
                    if v:is_suit('Spades') then suits["Spades"] = suits["Spades"] + 1 end
                    if v:is_suit('Clubs') then suits["Clubs"] = suits["Clubs"] + 1 end
                end
            end
            for k, v in ipairs(context.scoring_hand) do
                if v.ability.name == 'Wild Card' then
                    if v:is_suit('Clubs') and suits["Clubs"] == 0 then suits["Clubs"] = suits["Clubs"] + 1
                    elseif v:is_suit('Diamonds') and suits["Diamonds"] == 0  then suits["Diamonds"] = suits["Diamonds"] + 1
                    elseif v:is_suit('Spades') and suits["Spades"] == 0  then suits["Spades"] = suits["Spades"] + 1
                    elseif v:is_suit('Hearts') and suits["Hearts"] == 0  then suits["Hearts"] = suits["Hearts"] + 1 end
                end
            end
            if suits["Hearts"] > 0 and
            (suits["Diamonds"] > 0 or
            suits["Spades"] > 0 or
            suits["Clubs"] > 0) then
                ease_discard(card.ability.extra.discards)
                return {
                    message = '+1 Discard'
                }
            end
        end
    end
}

SMODS.Joker { --R2g
    key = 'r2g',
    name = 'Rubber to Gold',
	loc_txt = {
        name = 'Rubber to Gold',
        text = {
            'If {C:attention}final discard{} of',
            'round has only {C:attention}1{} card,',
            'add a {C:attention}Gold Seal{} to it'
        }
    },
	atlas = 'Joker',
	pos = { x = 6, y = 10 },
    rarity = 2,
	cost = 6,
	order = 257,
	blueprint_compat = false,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS.Gold
    end,
    calculate = function(self, card, context)
        if context.discard and not context.blueprint then
            local eval = function()
                return (G.GAME.current_round.discards_left == 1 and not G.RESET_JIGGLES)
            end
            juice_card_until(card, eval, true)
            if G.GAME.current_round.discards_left <= 1 and #context.full_hand == 1 and not context.blueprint then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        context.full_hand[1]:set_seal('Gold', nil, true)
                        return true
                    end
                }))
                delay(0.5)
            end
        end
    end
}

SMODS.Joker { --Jbounty
    key = 'jbounty',
    name = "Jungle's Bounty",
	loc_txt = {
        name = "Jungle's Bounty",
        text = {
            'If {C:attention}first discard{} of',
            'round is a single {C:attention}2{},',
            'add a {C:attention}Blue Seal{} to it',
        }
    },
	atlas = 'Joker',
	pos = { x = 7, y = 10 },
    rarity = 2,
	cost = 7,
	order = 258,
	blueprint_compat = false,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS.Blue
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function()
                return (G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES)
            end
            juice_card_until(card, eval, true)
        elseif context.discard and G.GAME.current_round.discards_used == 0 and #context.full_hand == 1 and context.full_hand[1]:get_id() == 2 and not context.full_hand[1].debuff and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    context.full_hand[1]:set_seal('Blue', nil, true)
                    return true
                end
            }))
            delay(0.5)
        end
    end
}

SMODS.Joker { --Arknight
    key = 'arknight',
    name = 'Arctic Knight',
	loc_txt = {
        name = 'Arctic Knight',
        text = {
            'Retrigger played',
            'cards adjacent to',
            '{C:attention}Bonus{} cards {C:attention}#1#{} times'
        }
    },
	atlas = 'Joker',
	pos = { x = 8, y = 10 },
    rarity = 2,
	cost = 7,
	order = 259,
	blueprint_compat = true,
    enhancement_gate = 'm_bonus',
    config = { extra = 2 }, --Variables: extra = retrigger amount

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
        return { vars = { card.ability.extra } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            for i = 1, #context.scoring_hand do
                if context.other_card == context.scoring_hand[i] and
                ((i > 1 and context.scoring_hand[i-1].ability.name == 'Bonus') or
                (i < #context.scoring_hand and context.scoring_hand[i+1].ability.name == 'Bonus')) then
                    return {
                        message = localize('k_again_ex'),
                        repetitions = card.ability.extra
                    }
                end
            end
        end
    end
}

SMODS.Joker { --City
    key = 'city',
    name = 'Monkey City',
	loc_txt = {
        name = 'Monkey City',
        text = {
            'Create a free {C:attention}Dart Monkey{}',
            'card at start of round',
            'Earn {C:money}$#1#{} for each {C:attention}Dart Monkey{}',
            'card at end of round',
            '{C:inactive}(Currently {C:money}$#2#{C:inactive}){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 11 },
    rarity = 2,
	cost = 7,
	order = 262,
	blueprint_compat = true,
    config = { extra = { money = 2, current = 0 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money, card.ability.extra.current } } --Variables: money = dollars per dart, current = current end of round dollars
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            card.ability.extra.current = #find_joker('Dart Monkey') * card.ability.extra.money
        end
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.current
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
            G.GAME.joker_buffer = G.GAME.joker_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = function() 
                    local card = create_card('j_bloons_dart', G.jokers, nil, nil, nil, nil, 'j_bloons_dart', 'city')
                    card.sell_cost = 0
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    card:start_materialize()
                    G.GAME.joker_buffer = 0
                    return true
                end
            }))   
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE}) 
        end
    end
}

SMODS.Joker { --Twix
    key = 'twix',
    name = 'Twin Sixes',
	loc_txt = {
        name = 'Twin Sixes',
        text = {
            '{X:mult,C:white}X#1#{} Mult if',
            'scoring hand contains',
            'exactly {C:attention}#2# 6{}s'
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 11 },
    rarity = 2,
	cost = 6,
	order = 265,
	blueprint_compat = true,
    config = { extra = { Xmult = 3, number = 2 } }, --Variables: Xmult = Xmult, number = required 6s for Xmult

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.number } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local count = 0
            if not context.blueprint then
                for k, v in ipairs(context.scoring_hand) do
                    if v:get_id() == 6 then
                        count = count + 1
                    end
                end
            end
            if count == card.ability.extra.number then
                return {
                    x_mult = card.ability.extra.Xmult
                }
            end
        end
    end
}

SMODS.Joker { --Bloonprint
    key = 'bloonprint',
    name = 'Bloonprint',
	loc_txt = {
        name = 'Bloonprint',
        text = {
            'Copies ability of',
            '{C:attention}Joker{} in position {C:attention}#1#{}',
            '{S:0.8}position changes{}',
            '{S:0.8}at end of round{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 11 },
    rarity = 3,
	cost = 10,
	order = 270,
	blueprint_compat = true,
    config = { extra = { min = 1, max = 5, current = 1 } }, --Variables: min = minimum position, max = maximum position, current = current retrigger position, blueprint_compat = blueprint copyable

    loc_vars = function(self, info_queue, card)
        if card.area and card.area == G.jokers then
			local other_joker = G.jokers.cards[card.ability.extra.current]
			local compatible = other_joker and other_joker ~= card and other_joker.config.center.blueprint_compat
			main_end = {{
                n = G.UIT.C,
                config = { align = "bm", minh = 0.4 },
                nodes = {{
                    n = G.UIT.C,
                    config = {
                        ref_table = card,
                        align = "m",
                        colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8),
                        r = 0.05,
                        padding = 0.06,
                    },
                    nodes = {{
                        n = G.UIT.T,
                        config = {
                            text = " " .. localize("k_" .. (compatible and "compatible" or "incompatible")) .. " ",
                            colour = G.C.UI.TEXT_LIGHT,
                            scale = 0.32 * 0.8,
                        }
                    }}
                }}
			}}
		end
        return { vars = { card.ability.extra.current }, main_end = main_end }
    end,
    calculate = function(self, card, context)
        if context.blind_defeated and not context.blueprint then
            local max = card.ability.extra.max
            if #G.jokers.cards < card.ability.extra.max then
                max = #G.jokers.cards
            end
            card.ability.extra.current = pseudorandom('bloonprint', card.ability.extra.min, max)
        end
        return SMODS.blueprint_effect(card, G.jokers.cards[card.ability.extra.current], context)
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
            '{C:inactive}(#3#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 12 },
    rarity = 2,
	cost = 7,
	order = 271,
	blueprint_compat = false,
    config = { extra = { Xmult = 2, limit = 5, counter = 1 } }, --Variables: Xmult = Xmult, limit = number of cards scored for Xmult, counter = card index

    loc_vars = function(self, info_queue, card)
        local function process_var(count, cap)
			if count == cap then
				return 'Next!'
			end
			return cap - count%cap .. ' remaining'
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
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if card.ability.extra.counter == card.ability.extra.limit then
                card.ability.extra.counter = 1
                return {
                    x_mult = card.ability.extra.Xmult,
                }
            else
                card.ability.extra.counter = card.ability.extra.counter + 1
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
            'are at least {C:attention}#1#%{} of required chips',
            'and destroy all cards held in hand',
            '{S:1.1,C:red,E:2}self destructs{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 12 },
    rarity = 3,
	cost = 7,
	order = 273,
	blueprint_compat = false,
    eternal_compat = false,
    config = { extra = { scored_percent = 50 } }, --Variables: scored_percent = percent of required chips scored

    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.scored_percent } }
    end,
    calculate = function(self, card, context)
        if context.game_over and G.GAME.chips/G.GAME.blind.chips >= card.ability.extra.scored_percent / 100.0 and not context.blueprint then
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
	cost = 8,
	order = 274,
	blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_meteor
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced then
            G.E_MANAGER:add_event(Event({
                func = function() 
                    local front = pseudorandom_element(G.P_CARDS, pseudoseed('iring'))
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    local card = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS.m_bloons_meteor, {playing_card = G.playing_card})
                    card:start_materialize({G.C.SECONDARY_SET.Enhanced})
                    G.play:emplace(card)
                    table.insert(G.playing_cards, card)
                    return true
                end
            }))
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

SMODS.Joker { --AZ
    key = 'az',
    name = 'Absolute Zero',
	loc_txt = {
        name = 'Absolute Zero',
        text = {
            'If {C:attention}first hand{} of round has ',
            '{C:attention}#1#{} scoring cards, score no chips,',
            '{C:attention}Freeze{} all scoring cards, and',
            'create a {C:spectral}Spectral{} card',
            '{C:inactive}(Must have room){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 12 },
    rarity = 2,
	cost = 7,
	order = 275,
	blueprint_compat = true,
    config = { extra = { number = 5 } }, --Variables: number = required cards for spectral

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        return { vars = { card.ability.extra.number } }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function()
                return (G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES)
            end
            juice_card_until(card, eval, true)
        elseif context.before and #context.scoring_hand == 5 and G.GAME.current_round.hands_played == 0 then
            if not context.blueprint then
                for k, v in pairs(context.scoring_hand) do
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
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        local card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'az')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
            end
        elseif context.final_scoring_step and #context.scoring_hand == 5 and G.GAME.current_round.hands_played == 0 and not context.blueprint then
            hand_chips = mod_chips(0)
            hand_mult = mod_mult(0)
            update_hand_text( { delay = 0 }, { chips = hand_chips, mult = hand_mult } )
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound("timpani", 1)
                    attention_text({
                        scale = 1.4,
                        text = "Frozen",
                        hold = 0.45,
                        align = "cm",
                        offset = { x = 0, y = -2.7 },
                        major = G.play,
                    })
                    return true
                end,
            }))
            delay(0.6)
        end
    end
}

SMODS.Joker { --Solver
    key = 'solver',
    name = 'The Bloon Solver',
	loc_txt = {
        name = 'The Bloon Solver',
        text = {
            'Played {C:attention}cards{}',
            'become {C:attention}Glued{} and',
            'permanently gain {C:mult}+#1#{}',
            'Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 12 },
    rarity = 3,
	cost = 7,
	order = 276,
	blueprint_compat = true,
    config = { extra = { mult = 2 } }, --Variables: mult = permanent +mult

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
        return { vars = { card.ability.extra.mult } }
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
	cost = 7,
	order = 277,
	blueprint_compat = true,
    config = { extra = { Xmult1 = 1.5, Xmult2 = 2, Xmult3 = 4 } }, --Variables: Xmult1 = Xmult after first hand, Xmult2 = Xmult on final hand, Xmult3 = XMult if under 25%

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult1, card.ability.extra.Xmult2, card.ability.extra.Xmult3 } }
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

SMODS.Joker { --Aprime
    key = 'aprime',
    name = 'Apache Prime',
	loc_txt = {
        name = 'Apache Prime',
        text = {
            'Each played {C:attention}2{}, {C:attention}3{}, {C:attention}5{},',
            'or {C:attention}7{} gives {X:mult,C:white}X#1#{}, {X:mult,C:white}X#2#{},',
            '{X:mult,C:white}X#3#{}, or {X:mult,C:white}X#4#{} Mult',
            'respectively when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 13 },
    rarity = 3,
	cost = 9,
	order = 281,
	blueprint_compat = true,
    config = { extra = { Xmult1 = 1.2, Xmult2 = 1.3, Xmult3 = 1.5, Xmult4 = 1.7 } }, --Variables: Xmult = Xmult for each rank

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult1, card.ability.extra.Xmult2, card.ability.extra.Xmult3, card.ability.extra.Xmult4 } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 2 then
                return {
                    x_mult = card.ability.extra.Xmult1
                }
            elseif context.other_card:get_id() == 3 then
                return {
                    x_mult = card.ability.extra.Xmult2
                }
            elseif context.other_card:get_id() == 5 then
                return {
                    x_mult = card.ability.extra.Xmult3
                }
            elseif context.other_card:get_id() == 7 then
                return {
                    x_mult = card.ability.extra.Xmult4
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
            'Gives {X:mult,C:white}X#1#{} Mult for each'
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 13 },
    rarity = 3,
	cost = 8,
	order = 282,
	blueprint_compat = false,
    config = { extra = { Xmult = 1 } }, --Variables: Xmult = Xmult

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local total = 1
            for ik, v in ipairs(context.scoring_hand) do
                if v.config.center ~= G.P_CENTERS.c_base or
                        v.edition or
                        v.seal then
                    total = total + card.ability.extra.Xmult
                end
            end
            if total > 1 then
                return {
                    x_mult = total
                }
            end
        elseif context.destroying_card and
                (context.destroying_card.config.center ~= G.P_CENTERS.c_base or
                context.destroying_card.edition or
                context.destroying_card.seal) and
                not context.blueprint then
            return true
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
    config = { extra = { max = 43, min = 20, ranks = {} } }, --Variables: max = max possible Xmult *20, min = min possible Xmult *20

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            for i = 1, #card.ability.extra.ranks do
                if context.other_card:get_id() == card.ability.extra.ranks[i] then
                    local temp_Xmult = pseudorandom('rod', card.ability.extra.min, card.ability.extra.max) / 20.0
                    return {
                        x_mult = temp_Xmult
                    }
                end
            end
            card.ability.extra.ranks[#card.ability.extra.ranks+1] = context.other_card:get_id()
        elseif context.after and not context.blueprint then
            card.ability.extra.ranks = {}
        end
    end
}

SMODS.Joker { --WLP
    key = 'wlp',
    name = 'Wizard Lord Phoenix',
	loc_txt = {
        name = 'Wizard Lord Phoenix',
        text = {
            'After defeating each {C:attention}Boss Blind{},',
            'create a {C:spectral}Volcano{} card',
            '{C:inactive}(Must have room){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 13 },
    rarity = 3,
	cost = 8,
	order = 284,
	blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_bloons_volcano
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.beat_boss and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and not context.individual and not context.repetition then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    local card = create_card('c_bloons_volcano', G.consumeables, nil, nil, nil, nil, 'c_bloons_volcano', 'wlp')
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                    G.GAME.consumeable_buffer = 0
                    return true
                end)
            }))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
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
    config = { extra = { Xmult = 0.5 } },

    loc_vars = function(self, info_queue, card)
        --Variables: Xmult = Xmult
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local total = 1
            for k, v in ipairs(context.scoring_hand) do
                if v:is_suit('Diamonds', true) then
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

SMODS.Joker { --AoW
    key = 'aow',    
    name = 'Avatar of Wrath',
	loc_txt = {
        name = 'Avatar of Wrath',
        text = {
            '{X:mult,C:white}X#1#{} Mult,',
            'loses {X:mult,C:white}X#2#{} Mult for every',
            '{C:attention}0.5%{} of chips scored this round',
        }
    },
	atlas = 'Joker',
	pos = { x = 7, y = 13 },
    rarity = 3,
	cost = 8,
	order = 288,
	blueprint_compat = true,
    config = { extra = { Xmult = 3, current = 3, loss = 0.01 } }, --Variables: Xmult = starting Xmult, current = current Xmult, loss = Xmult loss per percent, 

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current, card.ability.extra.loss } }
    end,
    update = function(self, card, dt)
        if G.GAME.blind and G.GAME.blind.chips > 0 then
            if G.GAME.chips/G.GAME.blind.chips > 1 then
                card.ability.extra.current = 1
            else
                card.ability.extra.current = card.ability.extra.Xmult - 2 * G.GAME.chips/G.GAME.blind.chips
            end
        else
            card.ability.extra.current = card.ability.extra.Xmult
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.current,
            }
        end
    end
}

SMODS.Joker { --Pex
    key = 'pex',
    name = 'Primary Expertise',
    loc_txt = {
        name = 'Primary Expertise',
        text = {
            '{C:blue}Common{} Jokers are free',
            '{C:green}#1# in #2#{} chance for {X:mult,C:white}X#3#{} Mult,',
            '{C:green,E:1,S:1.1}Probability{} increases for',
            'each {C:blue}Common{} Joker'
        }
    },
    atlas = 'Joker',
	pos = { x = 1, y = 14 },
    rarity = 3,
	cost = 8,
	order = 291,
	blueprint_compat = true,
    config = { extra = { num = 1, denom = 5, Xmult = 4 } }, --Variables: num/denom = probability fraction, Xmult = Xmult
    
    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'pex')
        return { vars = { n, d, card.ability.extra.Xmult } }
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            local commons = 0
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].config.center.rarity == 1 then
                    commons = commons + 1
                end
            end
            card.ability.extra.num = commons + 1
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        recalc_all_costs()
    end,
    remove_from_deck = function(self, card, from_debuff)
        recalc_all_costs()
    end,
    calculate = function(self, card, context)
        if context.joker_main and SMODS.pseudorandom_probability(card, 'pex', card.ability.extra.num, card.ability.extra.denom, 'pex') then
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

--[[
SMODS.Joker { --Uboost
    key = 'uboost',
    name = 'Ultraboost',
    loc_txt = {
        name = 'Ultraboost',
        text = {
            '{C:cark_edition}Boost{} {C:attention}Joker{} to the left',
            'by {X:mult,C:white}X#1#{} Mult every hand played'
        }
    },
    atlas = 'Joker',
	pos = { x = 2, y = 14 },
    rarity = 3,
	cost = 9,
	order = 293,
	blueprint_compat = true,
    config = { extra = { Xmult = 0.1 } }, --Variables: Xmult = Xmult per boost

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.before and card ~= G.jokers.cards[1] then
            local other_joker
            for k, v in ipairs(G.jokers.cards) do
                if v == card then
                    other_joker = G.jokers.cards[k-1]
                end
            end
            if not other_joker.edition then
                other_joker:set_edition('e_bloons_boosted', true)
                other_joker.edition.boost = true
                other_joker.edition.type = 'bloons_boosted'
            end
            if other_joker.edition.boost then
                other_joker.edition.Xmult = other_joker.edition.Xmult + card.ability.extra.Xmult
            end
        end
    end
}
]]

SMODS.Joker { --Meg
    key = 'meg',
    name = 'Megalodon',
	loc_txt = {
        name = 'Megalodon',
        text = {
            'This joker gains {C:chips}+#1#{} Chips when',
            'each played {C:attention}Bonus Card{} is scored',
            'and {C:mult}+#2#{} Mult when each played',
            '{C:attention}Mult Card{} is scored',
            '{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips {C:mult}+#4#{C:inactive} Mult){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 14 },
    rarity = 3,
	cost = 9,
	order = 294,
	blueprint_compat = true,
    perishable_compat = false,
    config = { extra = { chips = 15, mult = 2, current_chips = 0, current_mult = 0 } }, --Variables: chips = +chips for each bonus card, mult = +mult for each mult card, current_chips/mult = current +chips/+mult
    
    in_pool = function(self, args)
        for k, v in pairs(G.playing_cards) do
            if v.ability.name == 'Mult' or v.ability.name == 'Bonus' then
                return true
            end
        end
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.current_chips, card.ability.extra.current_mult } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            for k, v in ipairs(context.scoring_hand) do
                if v.ability.name == 'Bonus' then
                    card.ability.extra.current_chips = card.ability.extra.current_chips + card.ability.extra.chips
                elseif v.ability.name == 'Mult' then
                    card.ability.extra.current_mult = card.ability.extra.current_mult + card.ability.extra.mult
                end
            end
        elseif context.joker_main then
            return {
                chips = card.ability.extra.current_chips,
                mult = card.ability.extra.current_mult
            }
        end
    end
}

SMODS.Joker { --Gustice
    key = 'gustice',
    name = 'Golden Justice',
	loc_txt = {
        name = 'Golden Justice',
        text = {
            '{C;attention}Gold{} cards give {X:mult,C:white}X#1#{} Mult when scored,',
            '{C:green}#2# in #3#{} chance to destroy card',
            '{C:attention}Glass{} cards give {C:money}$#4#{} if',
            'held in hand at end of round',
            'Both give {C:money}$#5#{} when destroyed',
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 14 },
    rarity = 3,
	cost = 8,
	order = 295,
	blueprint_compat = false,
    config = { extra = { Xmult = 2, num = 1, denom = 4, gold_dollars = 3, destroy_dollars = 15 } }, --Variables = Xmult = glass Xmult, num/denom = probability fraction, gold_dollars = gold dollars, destroy dollars = dollars when destroyed

    in_pool = function(self, args)
        for k, v in pairs(G.playing_cards) do
            if v.ability.name == 'Gold Card' or v.ability.name == 'Glass Card' then
                return true
            end
        end
        return false
    end,
    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'gustice')
        return { vars = { card.ability.extra.Xmult, n, d, card.ability.extra.gold_dollars, card.ability.extra.destroy_dollars } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.ability.name == 'Gold Card' and not context.other_card.debuff and not context.blueprint then
            return {
                x_mult = card.ability.extra.Xmult
            }
        elseif context.after and not context.blueprint then
            local gold = 0
            for k, v in ipairs(context.scoring_hand) do
                if v.ability.name == 'Gold Card' and not v.shattered and not v.removed and not v.debuff and SMODS.pseudorandom_probability(card, 'gustice', card.ability.extra.num, card.ability.extra.denom, 'gustice') then
                    gold = gold + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        func = function()
                            v:shatter()
                            return true
                        end
                    }))
                end
            end
        elseif context.end_of_round and context.individual and context.cardarea == G.hand and context.other_card.ability.name == 'Glass Card' and not context.other_card.debuff and not context.blueprint then
            ease_dollars(card.ability.extra.gold_dollars)
            card_eval_status_text(context.other_card, 'extra', nil, nil, nil, {message = localize('$')..card.ability.extra.gold_dollars,colour = G.C.MONEY, delay = 0.45})
            delay(0.3)
        elseif context.cards_destroyed and not context.blueprint then
            local glass = 0
            for k, v in ipairs(context.glass_shattered) do
                if v.ability.name == 'Glass Card' or v.ability.name == 'Gold Card' then
                    glass = glass + 1
                end
            end
            if glass > 0 then
                ease_dollars(card.ability.extra.destroy_dollars*glass)
                card_eval_status_text(create_dynatext_pips, 'extra', nil, nil, nil, {message = localize('$')..card.ability.extra.destroy_dollars*glass,colour = G.C.MONEY, delay = 0.45})
            end
        elseif context.remove_playing_cards and not context.blueprint then
            local glass = 0
            for k, v in ipairs(context.removed) do
                if v.ability.name == 'Glass Card' or v.ability.name == 'Gold Card' then
                    glass = glass + 1
                end
            end
            if glass > 0 then
                ease_dollars(card.ability.extra.destroy_dollars*glass)
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('$')..card.ability.extra.destroy_dollars*glass,colour = G.C.MONEY, delay = 0.45})
            end
        end
    end
}

SMODS.Joker { --MOAB Domination
    key = 'mdom',
    name = 'MOAB Domination',
	loc_txt = {
        name = 'MOAB Domination',
        text = {
            'Play each {C:attention}Boss Blind{} twice,',
            'This Joker gains {X:mult,C:white}X#1#{} Mult',
            'when {C:attention}Boss Blind{} is defeated',
            '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive}){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 14 },
    soul_pos = { x = 5, y = 15 },
    rarity = 4,
	cost = 20,
	order = 296,
	blueprint_compat = true,
    config = { extra = { Xmult = 1, current = 1, active = true } }, --Variables = Xmult = Xmult per boss defeated the second time, current = current Xmult, active = if next boss will be repeated

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.current
            }
        elseif context.end_of_round and context.beat_boss and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult
            card.ability.extra.active = true
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.RED,
                delay = 0.45,
            }
        end            
    end
}

SMODS.Joker { --Fortress
    key = 'fortress',
    name = 'Flying Fortress',
	loc_txt = {
        name = 'Flying Fortress',
        text = {
            'Apply the effects',
            'of all {C:attention}Seals{} to {C:attention}Aces{}',
        }
    },
	atlas = 'Joker',
	pos = { x = 6, y = 14 },
    soul_pos = { x = 6, y = 15 },
    rarity = 4,
	cost = 20,
	order = 297,
	blueprint_compat = false,
    config = { extra = { reps = 1, money = 3 } }, --Variables: reps = retrigger amount (red), money = dollars (gold)

    calculate = function(self, card, context)
        if context.individual and context.other_card:get_id() == 14 and not context.blueprint then
            if context.cardarea == G.play then
                return {
                    p_dollars = card.ability.extra.money
                }
            end
        elseif context.discard and context.other_card:get_id() == 14 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and not context.blueprint then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, '8ba')
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                    G.GAME.consumeable_buffer = 0
                    return true
                end)
            }))
            card_eval_status_text(context.other_card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
        elseif context.end_of_round and context.cardarea == G.hand and context.other_card:get_id() == 14 and not context.other_card.debuff and not context.blueprint then
            for i = 0, card.ability.extra.reps do
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                            if G.GAME.last_hand_played then
                                local _planet = 0
                                for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                                    if v.config.hand_type == G.GAME.last_hand_played then
                                        _planet = v.key
                                    end
                                end
                                local card = create_card('Planet',G.consumeables, nil, nil, nil, nil, _planet, 'blusl')
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                            end
                            return true
                        end)
                    }))
                    card_eval_status_text(context.other_card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})
                end
            end
        elseif context.repetition and context.other_card:get_id() == 14 and (context.cardarea == G.play or context.cardarea == G.hand) and not context.blueprint then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.reps
            }
        end
    end
}

