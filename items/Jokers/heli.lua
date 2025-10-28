SMODS.Joker { --Heli Pilot
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
    blueprint_compat = true,
    config = {
        base = 'heli',
        extra = { Xmult = 2 } --Variables: Xmult = Xmult
    },

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

SMODS.Joker { --Quad Darts
    key = 'quad',
    name = 'Quad Darts',
    loc_txt = {
        name = 'Quad Darts',
        text = {
            '{C:mult}+#1#{} Mult per played hand',
            'with exactly {C:attention}#2#{} cards',
            '{C:mult}-#1#{} Mult otherwise',
            '{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)'
        }
    },
    atlas = 'Joker',
	pos = { x = 0, y = 4 },
    rarity = 1,
	cost = 6,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'heli',
        extra = { mult = 1, number = 4, current = 0 } --Variables: mult = +mult gain or loss, current = current +mult
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.number, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if #context.full_hand == card.ability.extra.number then
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult
                return {
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}}
                }
            elseif card.ability.extra.current > 0 then
                card.ability.extra.current = card.ability.extra.current - card.ability.extra.mult
                return {
                    message = localize{type='variable',key='a_mult_minus',vars={card.ability.extra.mult}},
                    colour = G.C.RED,   
                }
            end
        elseif context.joker_main then
            return {
                mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Downdraft
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
    blueprint_compat = true,
    config = {
        base = 'heli',
        extra = { hands = 1, boss_hands = 2, counter = 0 } --Variables: hands = extra hands, scored_chips = chips for first hands, counter = amount of blowback hands left
    },

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

SMODS.Joker { --Comanche Defense
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
    blueprint_compat = true,
    config = {
        base = 'heli',
        extra = { chips = 30, current = 30, mini_chips = 40 } --Variables: chips = base chips
    },

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
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
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

SMODS.Joker { --Special Poperations
    key = 'spop',
    name = 'Special Poperations',
	loc_txt = {
        name = 'Special Poperations',
        text = {
            'Create a {C:attention}Marine{} every',
            '{C:attention}#1#{} {C:inactive}[#2#]{} hands played',
            'Create a {C:attention}Cash Drop{} every',
            '{C:attention}#3#{} {C:inactive}[#4#]{} hands played'
        }
    },
	atlas = 'Joker',
	pos = { x = 8, y = 8 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        base = 'heli',
        extra = {marine = 5, cash = 9, counter = 0 } --Variables: hands = extra hands, marine = hands for marine, cash = hands for cash drop, current = current hands
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.j_bloons_marine
        info_queue[#info_queue+1] = G.P_CENTERS.c_bloons_cash
        local function process_var(count, cap)
			return count % cap
		end
		return {
			vars = {
                card.ability.extra.marine,
                process_var(card.ability.extra.counter, card.ability.extra.marine),
                card.ability.extra.cash,
                process_var(card.ability.extra.counter, card.ability.extra.cash),
			},
		}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.counter = G.GAME.hands_played - card.ability.hands_played_at_create + 1
            if card.ability.extra.counter % card.ability.extra.marine == 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local card = create_card('j_bloons_marine', G.jokers, nil, 0, nil, nil, 'j_bloons_marine', 'spop')
                        card:add_to_deck()
                        G.jokers:emplace(card)
                        card:start_materialize()
                        return true
                    end
                }))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
            elseif card.ability.extra.counter % card.ability.extra.cash == 0 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        local card = create_card('c_bloons_cash', G.consumeables, nil, nil, nil, nil, 'c_bloons_cash', 'spop')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = '+1 Power', colour = G.C.POWER})
            end
        end
    end
}

SMODS.Joker { --Apache Prime
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
    blueprint_compat = true,
    config = {
        base = 'heli',
        extra = { Xmult1 = 1.2, Xmult2 = 1.3, Xmult3 = 1.5, Xmult4 = 1.7 } --Variables: Xmult = Xmult for each rank
    },

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
