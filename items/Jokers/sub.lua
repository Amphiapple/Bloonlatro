SMODS.Joker { --Monkey Sub
    key = 'monkey_sub',
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
	pos = { x = 0, y = 8 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        base = 'sub',
        extra = { mult = 2 } --Variables: mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult * (G.GAME.subcom_mult or 1) } }
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
                    h_mult = card.ability.extra.mult * (G.GAME.subcom_mult or 1)
                }
			end
		end
    end
}

SMODS.Joker { --Longer Range
    key = 'longer_range',
    name = 'Longer Range',
    loc_txt = {
        name = 'Longer Range',
        text = {
            'Initial shop has {C:attention}+#1#{}',
            'card slot available'
        }
    },
    atlas = 'Joker',
	pos = { x = 1, y = 8 },
    rarity = 1,
	cost = 3,
    blueprint_compat = false,
    config = {
        base = 'sub',
        extra = { slots = 1 } --Variables: slots = extra shop slots
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.slots } }
    end,
    remove_from_deck = function(self, card, from_debuff)
        if G.shop_jokers and G.shop_jokers.cards then
            G.shop_jokers.T.w = G.GAME.shop.joker_max*1.01*G.CARD_W
            G.shop:recalculate()
        end
    end,
    calculate = function(self, card, context)
        if context.starting_shop and not context.blueprint then
            change_shop_size(card.ability.extra.slots)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                func = function()
                    G.GAME.shop.joker_max = G.GAME.shop.joker_max - card.ability.extra.slots
                    G.shop_jokers.config.card_limit = G.GAME.shop.joker_max
                    G.shop:recalculate()
                    return true
                end
            }))
        elseif context.reroll_shop and not context.blueprint then
            G.shop_jokers.T.w = G.GAME.shop.joker_max*1.01*G.CARD_W
            G.shop:recalculate()
        end
    end
}

SMODS.Joker { --Advanced Intel
    key = 'advanced_intel',
    name = 'Advanced Intel',
    loc_txt = {
        name = 'Advanced Intel',
        text = {
            '{C:attention}#1#{} free {C:green}Reroll{}',
            'per shop',
        }
    },
    atlas = 'Joker',
	pos = { x = 2, y = 8 },
    rarity = 1,
	cost = 5,
    blueprint_compat = false,
    config = {
        base = 'sub',
        extra = { freerolls = 1 } --Variables: freerolls = free rerolls
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.freerolls } }
    end,
    add_to_deck = function(self, card, from_debuff)
        SMODS.change_free_rerolls(card.ability.extra.freerolls)
        calculate_reroll_cost(true)
    end,
    remove_from_deck = function(self, card, from_debuff)
        SMODS.change_free_rerolls(-card.ability.extra.freerolls)
        calculate_reroll_cost(true)
    end
}

SMODS.Joker { --Submerge and Support
    key = 'submerge_and_support',
    name = 'Submerge and Support',
    loc_txt = {
        name = 'Submerge and Support',
        text = {
            '{C:green}Rerolls{} cost {C:money}$#1#{} less',
        }
    },
    atlas = 'Joker',
	pos = { x = 3, y = 8 },
    rarity = 2,
	cost = 5,
    blueprint_compat = false,
    config = {
        base = 'sub',
        extra = { money = 2 } --Variables: money = reroll discount
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost - card.ability.extra.money
                G.GAME.current_round.reroll_cost = math.max(0, G.GAME.current_round.reroll_cost - card.ability.extra.money)
                return true
            end
        }))
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost + card.ability.extra.money
                G.GAME.current_round.reroll_cost = math.max(0, G.GAME.current_round.reroll_cost + card.ability.extra.money)
                return true
            end
        }))
    end
}

SMODS.Joker { --Bloontonium Reactor
    key = 'bloontonium_reactor',
    name = 'Bloontonium Reactor',
    loc_txt = {
        name = 'Bloontonium Reactor',
        text = {
            'This Joker gains {C:chips}+#1#{} Chips',
            'per {C:green}Reroll{} in the shop',
            '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)',
        }
    },
    atlas = 'Joker',
	pos = { x = 4, y = 8 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'sub',
        extra = { chips = 8, current = 0 } --Variables: chips = +chips per reroll, current = current +chips
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips * (G.GAME.subcom_mult or 1), card.ability.extra.current * (G.GAME.subcom_mult or 1) } }
    end,
    calculate = function(self, card, context)
        if context.reroll_shop and not context.blueprint then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.chips
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}}
            }
        elseif context.joker_main then
            return {
                chips = card.ability.extra.current * (G.GAME.subcom_mult or 1)
            }
        end
    end
}

SMODS.Joker { --Energizer
    key = 'energizer',
    name = 'Energizer',
	loc_txt = {
        name = 'Energizer',
        text = {
            '{C:green}Rerolls{} cost half',
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 8 },
    rarity = 3,
	cost = 8,
    blueprint_compat = false,
    config = {
        base = 'sub',
    },

    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                calculate_reroll_cost(true)
                return true
            end
        }))
    end,
    remove_from_deck = function(self, card, from_debuff)
        calculate_reroll_cost(true)
    end,
}

SMODS.Joker { --Barbed Darts
    key = 'barbed_darts',
    name = 'Barbed Darts',
	loc_txt = {
        name = 'Barbed Darts',
        text = {
            'Each card',
            'held in hand',
            'gives {C:mult}+#1#{} Mult'
        }
    },
	atlas = 'Joker',
	pos = { x = 6, y = 8 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'sub',
        extra = { mult = 3 } --Variables: mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult * (G.GAME.subcom_mult or 1) } }
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
                    h_mult = card.ability.extra.mult * (G.GAME.subcom_mult or 1)
                }
			end
		end
    end
}

SMODS.Joker { --Heat-tipped Darts
    key = 'heat_tipped_darts',
    name = 'Heat-tipped Darts',
	loc_txt = {
        name = 'Heat-tipped Darts',
        text = {
            'Each card',
            'held in hand',
            'gives {C:chips}+#1#{} Chips'
        }
    },
	atlas = 'Joker',
	pos = { x = 7, y = 8 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'sub',
        extra = { chips = 12 } --Variables: mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips * (G.GAME.subcom_mult or 1) } }
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
                    h_chips = card.ability.extra.chips * (G.GAME.subcom_mult or 1)
                }
			end
		end
    end
}

SMODS.Joker { --Ballistic Missile
    key = 'ballistic_missile',
    name = 'Ballistic Missile',
	loc_txt = {
        name = 'Ballistic Missile',
        text = {
            'Gives {X:mult,C:white}X#1#{} for each card',
            'with the {C:attention}most common{}',
            'rank held in hand',
        }
    },
	atlas = 'Joker',
	pos = { x = 8, y = 8 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'sub',
        extra = { Xmult = 0.75 } --Variables: Xmult = Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult * (G.GAME.subcom_mult or 1) } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local max = 1
            local idx_by_id = {}
            for k, v in ipairs(G.hand.cards) do
                local id = v:get_id()
                if idx_by_id[id] then
                    idx_by_id[id] = idx_by_id[id] + 1
                    if idx_by_id[id] > max then
                        max = idx_by_id[id]
                    end
                else
                    idx_by_id[id] = 1
                end
            end
            if max > 1 then
                return {
                    x_mult = card.ability.extra.Xmult * max * (G.GAME.subcom_mult or 1)
                }
            end
		end
    end
}

SMODS.Joker { --First Strike Capability
    key = 'first_strike_capability',
    name = 'First Strike Capability',
	loc_txt = {
        name = 'First Strike Capability',
        text = {
            'This {C:attention}Joker{} gains {X:mult,C:white}X#1#{} ',
            'if {C:attention}Blind{} is defeated',
            'on {C:attention}first hand{} of round',
            '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 8 },
    rarity = 2,
	cost = 8,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'sub',
        extra = { Xmult = 0.25, current = 1 } --Variables: Xmult = Xmult gain/loss, current = current Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult * (G.GAME.subcom_mult or 1), card.ability.extra.current * (G.GAME.subcom_mult or 1) } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition and G.GAME.current_round.hands_played <= 1 and not context.blueprint then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.current}},
            }
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current * (G.GAME.subcom_mult or 1),
            }
        end
    end
}

SMODS.Joker { --Pre-emptive Strike
    key = 'pre_emptive_strike',
    name = 'Pre-emptive Strike',
	loc_txt = {
        name = 'Pre-emptive Strike',
        text = {
            '{X:mult,C:white}X#1#{} Mult before',
            'cards score',
        }
    },
	atlas = 'Joker',
	pos = { x = 10, y = 8 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        base = 'sub',
        extra = { Xmult = 3 } --Variables: Xmult = Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult * (G.GAME.subcom_mult or 1) } }
    end,
    calculate = function(self, card, context)
        if context.initial_scoring_step then
            return {
                x_mult = card.ability.extra.Xmult * (G.GAME.subcom_mult or 1),
            }
        end
    end
}

SMODS.Joker { --Twin Guns
    key = 'twin_guns',
    name = 'Twin Guns',
	loc_txt = {
        name = 'Twin Guns',
        text = {
            'Each {C:attention}Pair{}',
            'held in hand',
            'gives {C:mult}+#1#{} Mult'
        }
    },
	atlas = 'Joker',
	pos = { x = 11, y = 8 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'sub',
        extra = { mult = 10, pairs = {} } --Variables: mult = mult per held pair
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult * (G.GAME.subcom_mult or 1) } }
    end,
    calculate = function(self, card, context)
        if context.before then
            local idx_by_id = {}
            for k, v in ipairs(G.hand.cards) do
                local id = v:get_id()
                if idx_by_id[id] then
                    card.ability.extra.pairs[#card.ability.extra.pairs+1] = v
                    idx_by_id[id] = nil
                else
                    idx_by_id[id] = k
                end
            end
        elseif context.individual and context.cardarea == G.hand and not context.other_card.debuff and not context.end_of_round then
            for k, v in pairs(card.ability.extra.pairs) do
                if context.other_card == v then
                    return {
                        mult = card.ability.extra.mult * (G.GAME.subcom_mult or 1),
                    }
                end
            end
        elseif context.after then
            card.ability.extra.pairs = {}
        end
    end
}

SMODS.Joker { --Airburst Darts
    key = 'airburst_darts',
    name = 'Airburst Darts',
    loc_txt = {
        name = 'Airburst Darts',
        text = {
            'This {C:attention}Joker{} gains {C:mult}+#1#{}',
            'Mult if a {C:attention}Pair{}',
            'is held in hand',
            '{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)'
        }
    },
	atlas = 'Joker',
	pos = { x = 12, y = 8 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'sub',
        extra = { mult = 1, current = 0 } --Variables: mult = mult gain if pair is held, current = current mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult * (G.GAME.subcom_mult or 1), card.ability.extra.current * (G.GAME.subcom_mult or 1) } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local ranks = {}
            local has_pair = false
            for i, j in ipairs(G.hand.cards) do
                local new = true
                local id = j:get_id()
                for k, v in pairs(ranks) do
                    if id == k then
                        ranks[k] = v + 1
                        if ranks[k] == 2 then
                            has_pair = true
                        end
                        new = false
                    end
                end
                if new then
                    ranks[id] = 1
                end
            end
            if has_pair then
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult
                return {
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.current * (G.GAME.subcom_mult or 1)}}
                }
            end
        elseif context.joker_main then
            return {
                mult = card.ability.extra.current * (G.GAME.subcom_mult or 1)
            }
        end
    end
}

SMODS.Joker { --Triple Guns
    key = 'triple_guns',
    name = 'Triple Guns',
    loc_txt = {
        name = 'Triple Guns',
        text = {
            'This {C:attention}Joker{} gains {X:mult,C:white}X#1#{}',
            'Mult if a {C:attention}Three of a Kind{}',
            'is held in hand',
            '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)'
        }
    },
	atlas = 'Joker',
	pos = { x = 13, y = 8 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'sub',
        extra = { Xmult = 0.1, current = 1 } --Variables: Xmult = Xmult gain if 3oak is held, current = current Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult * (G.GAME.subcom_mult or 1), card.ability.extra.current * (G.GAME.subcom_mult or 1) } }
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
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.current * (G.GAME.subcom_mult or 1)}}
                }
            end
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current * (G.GAME.subcom_mult or 1)
            }
        end
    end
}

SMODS.Joker { --Armor Piercing Darts
    key = 'armor_piercing_darts',
    name = 'Armor Piercing Darts',
    loc_txt = {
        name = 'Armor Piercing Darts',
        text = {
            'Each {C:attention}Three of a Kind{}',
            'held in hand',
            'gives {X:mult,C:white}X#1#{} Mult',
        }
    },
	atlas = 'Joker',
	pos = { x = 14, y = 8 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'sub',
        extra = { Xmult = 3, _3oaks = {} } --Variables: Xmult = Xmult if 3oak is held
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult * (G.GAME.subcom_mult or 1) } }
    end,
    calculate = function(self, card, context)
        if context.before then
            local idx_by_id = {}
            for k, v in ipairs(G.hand.cards) do
                local id = v:get_id()
                if idx_by_id[id] then
                    idx_by_id[id] = idx_by_id[id] + 1
                else
                    idx_by_id[id] = 1
                end
                if idx_by_id[id] == 3 then
                    card.ability.extra._3oaks[#card.ability.extra._3oaks+1] = v
                    idx_by_id[id] = 0
                end
            end
        elseif context.individual and context.cardarea == G.hand and not context.other_card.debuff and not context.end_of_round then
            for k, v in pairs(card.ability.extra._3oaks) do
                if context.other_card == v then
                    return {
                        x_mult = card.ability.extra.Xmult * (G.GAME.subcom_mult or 1),
                    }
                end
            end
        elseif context.after then
            card.ability.extra._3oaks = {}
        end
    end
}

SMODS.Joker { --Sub Commander
    key = 'sub_commander',
    name = 'Sub Commander',
    loc_txt = {
        name = 'Sub Commander',
        text = {
            'Doubles the {C:chips}+chips{}, {C:mult}+mult{},',
            'and {X:mult,C:white}Xmult{} effects of',
            'all {C:attention}Monkey Subs{}',
        }
    },
	atlas = 'Joker',
	pos = { x = 15, y = 8 },
    rarity = 3,
	cost = 7,
    blueprint_compat = true,
    config = {
        base = 'sub',
        extra = { multiplier = 2 } --Variables: multiplier = effect multiplier
    },

    add_to_deck = function(self, card, from_debuff)
        G.GAME.subcom_mult = G.GAME.subcom_mult * 2
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.subcom_mult = G.GAME.subcom_mult / 2
    end
}
