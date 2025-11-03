SMODS.Joker { --Monkey Buccaneer
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
	pos = { x = 0, y = 9 },
    rarity = 1,
	cost = 4,
    blueprint_compat = false,
    config = {
        base = 'boat',
        extra = { money = 1, rate = 3, current = 0 } --Variables: money = dollars per sell cost, rate = sell cost rate, current = current end of round dollars
    },

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
        if card.ability.extra.current > 0 then
            return card.ability.extra.current
        end
    end
}

SMODS.Joker { --Grape Shot
    key = 'grape',
    name = 'Grape Shot',
    loc_txt = {
        name = 'Grape Shot',
        text = {
            'Earn {C:money}$#1#{} at end of round',
            '{C:money}-$#2#{} each round',
        }
    },
    atlas = 'Joker',
	pos = { x = 6, y = 9 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    eternal_compat = false,
    config = {
        base = 'boat',
        extra = { money = 5, loss = 1 } --Variables: money = dollars, loss = money reduction
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money, card.ability.extra.loss } }
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.money
    end,
    calculate = function(self, card, context)
        if context.starting_shop and not context.blueprint then
            if card.ability.extra.money - card.ability.extra.loss <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil
                                return true;
                            end
                        })) 
                        return true
                    end
                })) 
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.RED
                }
            else
                card.ability.extra.money = card.ability.extra.money - card.ability.extra.loss
                return {
                    message = localize{type='variable',key='a_chips_minus',vars={card.ability.extra.loss}},
                    colour = G.C.YELLOW
                }
            end
        end
    end
}

SMODS.Joker { --Destroyer
    key = 'destroyer',
    name = 'Destroyer',
    loc_txt = {
        name = 'Destroyer',
        text = {
            'When {C:attention}Blind{} is selected,',
            'destroy {C:attention}Joker{} to the right',
            'and this {C:attention}Joker{} gives',
            '{X:mult,C:white}X#1#{} Mult this {C:attention}Ante{}',
            '{C:inactive}(#2#)',
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 9 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        base = 'boat',
        extra = { Xmult = 2.5, active = false } --Variables: Xmult = Xmult, active = joker destroyed
    },

    loc_vars = function(self, info_queue, card)
        local function process_var(active)
			if active then
				return 'Active!'
			end
			return 'Inactive'
		end
		return { vars = { card.ability.extra.Xmult, process_var(card.ability.extra.active) } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and card.ability.extra.active == false then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then my_pos = i; break end
            end
            if my_pos and G.jokers.cards[my_pos+1] and not card.getting_sliced and not G.jokers.cards[my_pos+1].ability.eternal and not G.jokers.cards[my_pos+1].getting_sliced then 
                local sliced_card = G.jokers.cards[my_pos+1]
                sliced_card.getting_sliced = true
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                G.E_MANAGER:add_event(Event({func = function()
                    G.GAME.joker_buffer = 0
                    card.ability.extra.active = true
                    card:juice_up(0.8, 0.8)
                    sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                    play_sound('slice1', 0.96+math.random()*0.08)
                return true end }))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}}, colour = G.C.RED, no_juice = true})
            end
        elseif context.joker_main and card.ability.extra.active then
            return {
                x_mult = card.ability.extra.Xmult
            }
        elseif context.end_of_round and context.beat_boss and card.ability.extra.active and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.active = false
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker { --Favored Trades
    key = 'flavored',
    name = 'Favored Trades',
	loc_txt = {
        name = 'Favored Trades',
        text = {
            'If {C:attention}first hand{} of round',
            'has only {C:attention}1{} card, destroy',
            '{C:attention}Joker{} to the right to',
            'add a {C:attention}Blue Seal{} to it',
        }
    },
	atlas = 'Joker',
	pos = { x = 14, y = 9 },
    rarity = 2,
	cost = 7,
    blueprint_compat = false,
    category = {
        base = 'boat',
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS.Blue
    end,
    calculate = function(self, card, context)
        if context.before and G.GAME.current_round.hands_played == 0 and #context.full_hand == 1 and not context.full_hand[1].debuff and not context.blueprint then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then my_pos = i; break end
            end
            if my_pos and G.jokers.cards[my_pos+1] and not G.jokers.cards[my_pos+1].ability.eternal then
                local sliced_card = G.jokers.cards[my_pos+1]
                sliced_card.getting_sliced = true
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.GAME.joker_buffer = 0
                        context.full_hand[1]:set_seal('Blue', nil, true)
                        card:juice_up(0.8, 0.8)
                        sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                        play_sound('coin6', 0.96+math.random()*0.08)
                        return true
                    end
                }))
                delay(0.5)
            end
        end
    end
}

SMODS.Joker { --Pirate Lord
    key = 'plord',
    name = 'Pirate Lord',
	loc_txt = {
        name = 'Pirate Lord',
        text = {
            '{C:attention}Lucky{} cards have a',
            '{C:green}#1# in #2#{} chance to give Mult',
            'and have a {C:green}#3# in #4#{}',
            'chance to win {C:money}money{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 10, y = 9 },
    rarity = 2,
	cost = 8,
    blueprint_compat = true,
    enhancement_gate = 'm_lucky',
    config = {
        base = 'boat',
        extra = { num = 1, denom1 = 2, denom2 = 10 } --Variables: num/denom1, num/denom2 = probability fraction for lucky cards
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
        local m, d1 = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom1, 'plord')
        local n, d2 = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom2, 'plord')
        return { vars = { m, d1, n, d2 } }
    end,
}