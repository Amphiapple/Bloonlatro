SMODS.Joker { --Banana Farm
    key = 'farm',
    name = 'Banana Farm',
	loc_txt = {
        name = 'Banana Farm',
        text = {
            'Earn {C:money}$#1#{} for each other',
            '{C:attention}Joker{} card at end of round',
            '{C:inactive}(Currently {C:money}$#2#{C:inactive}){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 1 },
    rarity = 1,
	cost = 5,
    blueprint_compat = false,
    config = {
        base = 'farm',
        extra = { money = 1, current = 0 } --Variables: money = dollars per joker, current = current end of round dollars
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money, card.ability.extra.current } }
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            card.ability.extra.current = #G.jokers.cards
            if #find_joker('Banana Farm') > 0 then
                card.ability.extra.current = #G.jokers.cards - 1
            end
        end
    end,
    calc_dollar_bonus = function(self, card)
        if card.ability.extra.current > 0 then
            return card.ability.extra.current
        end
    end
}

SMODS.Joker { --Valuable Bananas
    key = 'valuable',
    name = 'Valuable Bananas',
    loc_txt = {
        name = 'Valuable Bananas',
        text = {
            '{C:green}#1# in #2#{} chance to',
            'destroy {C:attention}1{} banana and',
            'earn {C:money}$#3#{} at end of round',
            '{C:inactive}(#4# remaining){}'
        }
    },
    atlas = 'Joker',
	pos = { x = 7, y = 5 },
    rarity = 1,
	cost = 5,
    blueprint_compat = false,
    eternal_compat = false,
    config = {
        base = 'farm',
        extra = { num = 1, denom = 4, money = 15, bananas = 3 } --Variables: money = dollars, bananas = bananas remaining
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'valuable')
        return { vars = { n, d, card.ability.extra.money, card.ability.extra.bananas } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'valuable', card.ability.extra.num, card.ability.extra.denom, 'valuable') then
                card.ability.extra.bananas = card.ability.extra.bananas - 1
                if card.ability.extra.bananas <= 0 then
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
                end
                return {
                    dollars = card.ability.extra.money,
                    colour = G.C.MONEY
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
        end
    end
}

SMODS.Joker { --Banana Salvage
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
    blueprint_compat = false,
    config = {
        base = 'farm',
        extra = { cost = 2 } --Variables: cost = extra sell price
    },

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

SMODS.Joker { --Monkey Bank
    key = 'bank',
    name = 'Monkey Bank',
	loc_txt = {
        name = 'Monkey Bank',
        text = {
            'Gain sell value equal to',
            'interest at end of round',
            'Sell this card for {C:money}$#1#{} or more',
            'to create a {C:attention}Monkey Bank{}',
            '{C:inactive}(Max capacity of {C:money}$#2#{C:inactive})'
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 7 },
    rarity = 2,
	cost = 7,
    blueprint_compat = false,
    eternal_compat = false,
    config = {
        base = 'farm',
        extra = { sell_limit = 10, capacity = 20 } --Variables: sell_limit = required sell price to create bank, capacity = max sell price from interest
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.sell_limit, card.ability.extra.capacity } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and G.GAME.dollars >= to_big(5) and not context.individual and not context.repetition and not context.blueprint then
            local dollars = to_big(math.floor(G.GAME.dollars / 5))
            if G.GAME.dollars >= to_big(G.GAME.interest_cap) then
                dollars = to_big(math.floor(G.GAME.interest_cap / 5))
            end
            if dollars > to_big(card.ability.extra.capacity - card.sell_cost) then
                dollars = to_big(card.ability.extra.capacity - card.sell_cost)
            end
            if dollars > to_big(0) then
                card.ability.extra_value = card.ability.extra_value + dollars
                card:set_cost()
                return {
                    message = localize('k_val_up'),
                    colour = G.C.MONEY
                }
            end
        elseif context.selling_self and to_big(card.sell_cost) >= to_big(card.ability.extra.sell_limit) and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local card = create_card('j_bloons_bank', G.jokers, nil, nil, nil, nil, 'j_bloons_bank', 'bank')
                    card.ability.extra_value = card.ability.extra_value - card.sell_cost
                    card:set_cost()
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

SMODS.Joker { --BRF
    key = 'brf',
    name = 'Banana Research Facility',
	loc_txt = {
        name = 'Banana Research Facility',
        text = {
            'Gives {X:mult,C:white}X#1#{} Mult for each',
            '{C:attention}voucher{} redeemed this run',
            '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 10 },
    rarity = 3,
	cost = 7,
    blueprint_compat = true,
    config = {
        base = 'farm',
        extra = { Xmult = 0.5, current = 1 } --Variables: Xmult = Xmult gain/loss, current = current Xmult
    }, 

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.current } }
    end,
    update = function(self, card, dt)
        local count = 0
        for k, v in pairs(G.GAME.used_vouchers) do
            local redeemed = v
            if G.GAME.selected_back.effect and G.GAME.selected_back.effect.config and G.GAME.selected_back.effect.config.vouchers then
                for i, j in pairs(G.GAME.selected_back.effect.config.vouchers) do
                    if k == j then
                        redeemed = false
                    end
                end
            end
            if redeemed then
                count = count + 1
            end
        end
        card.ability.extra.current = (1 + card.ability.extra.Xmult * count) or 1
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Wall Street
    key = 'wallstreet',
    name = 'Monkey Wall Street',
    loc_txt = {
        name = 'Monkey Wall Street',
        text = {
            'All Booster Packs become',
            '{C:attention}MEGA{} and cost half',
        }
    },
    atlas = 'Joker',
	pos = { x = 9, y = 13 },
    rarity = 3,
	cost = 10,
    blueprint_compat = false,
    config = {
        base = 'farm',
        extra = { slots = 1 } --Variables: slots = extra booster slots, cost_multiplier = pack cost multiplier
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.slots } }
    end,
    add_to_deck = function(self, card, from_debuff)
        recalc_all_costs()
    end,
    remove_from_deck = function(self, card, from_debuff)
        recalc_all_costs()
    end,
}
