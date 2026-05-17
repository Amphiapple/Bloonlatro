SMODS.Joker { --Monkey Buccaneer
    key = 'monkey_buccaneer',
    name = 'Monkey Buccaneer',
	loc_txt = {
        name = 'Monkey Buccaneer',
        text = {
            'Earn {C:money}$#1#{} per',
            'hand played',
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 9 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Monkey Buccaneer", category = "military" },
        extra = { money = 1 } --Variables: money = dollars per hand
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                dollars = card.ability.extra.money,
                colour = G.C.MONEY
            }
        end
    end
}

SMODS.Joker { --Faster Shooting
    key = 'faster_shooting_buccaneer',
    name = 'Faster Shooting (Buccaneer)',
	loc_txt = {
        name = 'Faster Shooting',
        text = {
            '{C:green}#1# in #2#{} chance to',
            'earn {C:money}$#3#{} per',
            'hand played',
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 9 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Monkey Buccaneer", category = "military" },
        extra = { num = 1, denom = 2, money = 3 } --Variables: num/denom = probability fraction, money = dollars per hand
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'faster_shooting_buccaneer')
        return { vars = { n, d, card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and SMODS.pseudorandom_probability(card, 'faster_shooting_buccaneer', card.ability.extra.num, card.ability.extra.denom, 'faster_shooting_buccaneer') then
            return {
                dollars = card.ability.extra.money,
                colour = G.C.MONEY
            }
        end
    end
}

SMODS.Joker { --Double Shot
    key = 'double_shot_buccaneer',
    name = 'Double Shot (Buccaneer)',
	loc_txt = {
        name = 'Double Shot',
        text = {
            'Each {C:attention}Pair{} in',
            'scoring hand',
            'gives {C:money}$#1#{}',
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 9 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Monkey Buccaneer", category = "military" },
        extra = { money = 2, pairs = {} } --Variables: money = dollars per pair, pairs = played pairs
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        if context.before then
            local idx_by_id = {}
            for k, v in ipairs(context.scoring_hand) do
                local id = v:get_id()
                if idx_by_id[id] then
                    card.ability.extra.pairs[#card.ability.extra.pairs+1] = v
                    idx_by_id[id] = nil
                else
                    idx_by_id[id] = k
                end
            end
        elseif context.individual and context.cardarea == G.play and not context.other_card.debuff then
            for k, v in pairs(card.ability.extra.pairs) do
                if context.other_card == v then
                    G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.money
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            G.GAME.dollar_buffer = 0;
                            return true
                        end)
                    }))
                    return {
                        dollars = card.ability.extra.money,
                        colour = G.C.MONEY
                    }
                end
            end
        elseif context.after then
            card.ability.extra.pairs = {}
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
        tower_info = { base = "Monkey Buccaneer", category = "military" },
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

SMODS.Joker { --Aircraft Carrier
    key = 'aircraft_carrier',
    name = 'Aircraft Carrier',
    loc_txt = {
        name = 'Aircraft Carrier',
        text = {
            '{C:green}#1# in #2#{} chance to give {X:mult,C:white}X#3#{} Mult',
            '{C:green}#1# in #2#{} chance to give {X:mult,C:white}X#3#{} Mult',
            '{C:green}#1# in #2#{} chance to give {X:mult,C:white}X#3#{} Mult',
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 9 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Monkey Buccaneer", category = "military" },
        extra = { num = 1, denom = 3, Xmult = 1.75, planes = 3 } --Variables: num/denom = probability fraction, money = dollars per hand, planes = Xmult retriggers
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'aircraft_carrier')
        return { vars = { n, d, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            for i = 1, card.ability.extra.planes do
                if SMODS.pseudorandom_probability(card, 'aircraft_carrier', card.ability.extra.num, card.ability.extra.denom, 'aircraft_carrier') then
                    mult = mod_mult(mult * card.ability.extra.Xmult)
                    update_hand_text( { delay = 0 }, { mult = mult } )
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('multhit2')
                            return true
                        end
                    }))
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {
                        message = localize{
                            type = 'variable',
                            key = 'a_xmult',
                            vars = {card.ability.extra.Xmult}
                        }
                    })
                else
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot2', 1, 0.4)
                            return true
                        end
                    }))
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_nope_ex')})
                end
            end
        end
    end
}

SMODS.Joker { --Carrier Flagship
    key = 'carrier_flagship',
    name = 'Carrier Flagship',
    loc_txt = {
        name = 'Carrier Flagship',
        text = {
            '{C:green}#1# in #2#{} chance to give {X:mult,C:white}X#3#{} Mult',
            '{C:green}#1# in #2#{} chance to give {X:mult,C:white}X#3#{} Mult',
            '{C:green}#1# in #2#{} chance to give {X:mult,C:white}X#3#{} Mult',
            '{C:dark_edition}+#4#{} Joker Slot on this {C:attention}Joker{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 9 },
    rarity = 3,
	cost = 7,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Monkey Buccaneer", category = "military" },
        extra = { num = 1, denom = 3, Xmult = 1.5, slots = 1, planes = 3 } --Variables: num/denom = probability fraction, money = dollars per hand, slots = extra joker slots, planes = Xmult retriggers
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'carrier_flagship')
        return { vars = { n, d, card.ability.extra.Xmult, card.ability.extra.slots } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            for i = 1, card.ability.extra.planes do
                if SMODS.pseudorandom_probability(card, 'carrier_flagship', card.ability.extra.num, card.ability.extra.denom, 'carrier_flagship') then
                    mult = mod_mult(mult * card.ability.extra.Xmult)
                    update_hand_text( { delay = 0 }, { mult = mult } )
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('multhit2')
                            return true
                        end
                    }))
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {
                        message = localize{
                            type = 'variable',
                            key = 'a_xmult',
                            vars = {card.ability.extra.Xmult}
                        }
                    })
                else
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot2', 1, 0.4)
                            return true
                        end
                    }))
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {
                        message = localize('k_nope_ex')
                    })
                end
            end
        end
    end
}

SMODS.Joker { --Grape Shot
    key = 'grape_shot',
    name = 'Grape Shot',
    loc_txt = {
        name = 'Grape Shot',
        text = {
            'Earn {C:money}$#1#{} at',
            'end of round',
            '{C:money}-$#2#{} each round',
        }
    },
    atlas = 'Joker',
	pos = { x = 6, y = 9 },
    rarity = 1,
	cost = 5,
    blueprint_compat = false,
    eternal_compat = false,
    config = {
        tower_info = { base = "Monkey Buccaneer", category = "military" },
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
                        SMODS.destroy_cards(card, nil, nil, true)
                        card:remove()
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
                    colour = G.C.MONEY
                }
            end
        end
    end
}

SMODS.Joker { --Hot Shot
    key = 'hot_shot',
    name = 'Hot Shot',
    loc_txt = {
        name = 'Hot Shot',
        text = {
            'Earn {C:money}$#3#{} at',
            'end of round',
            '{C:green}#1# in #2#{} chance to',
            '{s:1.1,C:red,E:2}self destruct{}'
        }
    },
    atlas = 'Joker',
	pos = { x = 7, y = 9 },
    rarity = 1,
	cost = 5,
    blueprint_compat = false,
    eternal_compat = false,
    config = {
        tower_info = { base = "Monkey Buccaneer", category = "military" },
        extra = { num = 1, denom = 3, money = 5 } --Variables: num/denom = probability fraction, money = dollars
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'hot_shot')
		return { vars = { n, d, card.ability.extra.money } }
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.money
    end,
    calculate = function(self, card, context)
        if context.starting_shop and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'hot_shot', card.ability.extra.num, card.ability.extra.denom, 'hot_shot') then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.destroy_cards(card, nil, nil, true)
                        card:remove()
                        return true
                    end
                }))
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.RED
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
        end
    end
}

SMODS.Joker { --Cannon Ship
    key = 'cannon_ship',
    name = 'Cannon Ship',
    loc_txt = {
        name = 'Cannon Ship',
        text = {
            '{C:mult}+#1#{} Mult',
            'Earn {C:money}$#2#{} at',
            'end of round',
        }
    },
    atlas = 'Joker',
	pos = { x = 8, y = 9 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Monkey Buccaneer", category = "military" },
        extra = { mult = 12, money = 3 } --Variables: mult = +mult, money = dollars
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.money
    end,
}

SMODS.Joker { --Monkey Pirates
    key = 'monkey_pirates',
    name = 'Monkey Pirates',
    loc_txt = {
        name = 'Monkey Pirates',
        text = {
            'If chips scored are at least',
            '{C:attention}#1#%{} of required chips',
            'on {C:attention}final hand{} of round,',
            'take down the {C:attention}Blind{}'
        }
    },
    atlas = 'Joker',
	pos = { x = 9, y = 9 },
    rarity = 2,
	cost = 7,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Monkey Buccaneer", category = "military" },
        extra = { percent = 50 } --Variables: percent = percent of required chips scored
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.percent } }
    end,
    calculate = function(self, card, context)
        if context.after and G.GAME.current_round.hands_left == 0 and not context.blueprint and
                (G.GAME.chips + hand_chips*mult)/G.GAME.blind.chips >= to_big(card.ability.extra.percent / 100.0) and
                (G.GAME.chips + hand_chips*mult)/G.GAME.blind.chips < to_big(1) then
            G.E_MANAGER:add_event(Event({
                trigger = 'ease',
                blocking = false,
                ref_table = G.GAME,
                ref_value = 'chips',
                ease_to = G.GAME.blind.chips,
                delay = 0.5,
                func = function(t)
                    return math.floor(t)
                end
            }))
            return {
                message = 'Takedown!'
            }
        end
    end
}

SMODS.Joker { --Pirate Lord
    key = 'pirate_lord',
    name = 'Pirate Lord',
	loc_txt = {
        name = 'Pirate Lord',
        text = {
            'If chips scored are at least',
            '{C:attention}#1#%{} of required chips,',
            'take down the {C:attention}Blind{} and',
            'plunder its reward money'
        }
    },
	atlas = 'Joker',
	pos = { x = 10, y = 9 },
    rarity = 3,
	cost = 8,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Monkey Buccaneer", category = "military" },
        extra = { percent = 50, money = 0 } --Variables: percent = percent of required chips scored, money = reward dollars
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.percent } }
    end,
    calc_dollar_bonus = function(self, card)
        if card.ability.extra.money > 0 then
            local money = card.ability.extra.money
            card.ability.extra.money = 0
            return money
        end
    end,
    calculate = function(self, card, context)
        if context.after and not context.blueprint and 
                (G.GAME.chips + hand_chips*mult)/G.GAME.blind.chips >= to_big(card.ability.extra.percent / 100.0) and
                (G.GAME.chips + hand_chips*mult)/G.GAME.blind.chips < to_big(1) then
            card.ability.extra.money = G.GAME.blind.dollars
            G.E_MANAGER:add_event(Event({
                trigger = 'ease',
                blocking = false,
                ref_table = G.GAME,
                ref_value = 'chips',
                ease_to = G.GAME.blind.chips,
                delay = 0.5,
                func = function(t)
                    return math.floor(t)
                end
            }))
            return {
                message = 'Takedown!'
            }
        end
    end
}

SMODS.Joker { --Long Range
    key = 'long_range',
    name = 'Long Range',
	loc_txt = {
        name = 'Long Range',
        text = {
            'Earn {C:money}$#1#{} per',
            'discard used',
        }
    },
	atlas = 'Joker',
	pos = { x = 11, y = 9 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Monkey Buccaneer", category = "military" },
        extra = { money = 1 } --Variables: money = dollars per hand
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card == context.full_hand[#context.full_hand] then
            return {
                dollars = card.ability.extra.money,
                colour = G.C.MONEY
            }
        end
    end
}

SMODS.Joker { --Crow's Nest
    key = 'crows_nest',
    name = "Crow's Nest",
	loc_txt = {
        name = "Crow's Nest",
        text = {
            'Earn {C:money}$#1#{} if',
            'discard contains',
            'only {C:attention}1{} card'
        }
    },
	atlas = 'Joker',
	pos = { x = 12, y = 9 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Monkey Buccaneer", category = "military" },
        extra = { money = 2 } --Variables: money = dollars per hand
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        if context.discard and #context.full_hand == 1 and context.other_card == context.full_hand[1] then
            return {
                dollars = card.ability.extra.money,
                colour = G.C.MONEY
            }
        end
    end
}

SMODS.Joker { --Merchantman
    key = 'merchantman',
    name = "Merchantman",
	loc_txt = {
        name = "Merchantman",
        text = {
            'After defeating each',
            '{C:attention}Boss Blind{}, gain a',
            '{C:attention}Voucher Tag{}',
        }
    },
	atlas = 'Joker',
	pos = { x = 13, y = 9 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Monkey Buccaneer", category = "military" },
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_TAGS.tag_voucher
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.beat_boss and not context.individual and not context.repetition then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    add_tag(Tag('tag_voucher'))
                    play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                    return true
                end)
            }))
        end
    end
}

SMODS.Joker { --Favored Trades
    key = 'favored_trades',
    name = "Favored Trades",
	loc_txt = {
        name = "Favored Trades",
        text = {
            'Gives {X:mult,C:white}X#1#{} Mult for each',
            '{C:attention}voucher{} redeemed this run',
            '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 14, y = 9 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Monkey Buccaneer", category = "military" },
        extra = { Xmult = 0.25, current = 1 } --Variables: Xmult = Xmult per voucher, current = current Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.current } }
    end,
    update = function(self, card, dt)
        card.ability.extra.current = 1 + card.ability.extra.Xmult * (#G.vouchers.cards - #G.GAME.selected_back.effect.config.voucher)
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Trade Empire
    key = 'trade_empire',
    name = "Trade Empire",
	loc_txt = {
        name = "Trade Empire",
        text = {
            '{C:attention}+#1#{} Voucher slot',
            '{C:attention}Vouchers{} cost half',
        }
    },
	atlas = 'Joker',
	pos = { x = 15, y = 9 },
    rarity = 3,
	cost = 7,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Monkey Buccaneer", category = "military" },
        extra = { slots = 1 } --Variables: slots = extra voucher slots
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.slots } }
    end,
    add_to_deck = function(self, card, from_debuff)
        SMODS.change_voucher_limit(card.ability.extra.slots)
        recalc_all_costs()
    end,
    remove_from_deck = function(self, card, from_debuff)
        SMODS.change_voucher_limit(-card.ability.extra.slots)
        recalc_all_costs()
    end
}
