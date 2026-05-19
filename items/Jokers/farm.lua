SMODS.Joker { --Banana Farm
    key = 'banana_farm',
    name = 'Banana Farm',
	atlas = 'Joker',
	pos = { x = 0, y = 20 },
    rarity = 1,
	cost = 4,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Banana Farm", category = "support" },
        extra = { money = 2 } --Variables: money = current end of round dollars
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.money
    end
}

SMODS.Joker { --Increased Production
    key = 'increased_production',
    name = 'Increased Production',
	atlas = 'Joker',
	pos = { x = 1, y = 20 },
    rarity = 1,
	cost = 5,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Banana Farm", category = "support" },
        extra = { money = 3 } --Variables: money = current end of round dollars
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.money
    end
}

SMODS.Joker { --Greater Production
    key = 'greater_production',
    name = 'Greater Production',
	atlas = 'Joker',
	pos = { x = 2, y = 20 },
    rarity = 1,
	cost = 6,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Banana Farm", category = "support" },
        extra = { money = 4 } --Variables: money = current end of round dollars
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.money
    end
}

SMODS.Joker { --Banana Plantation
    key = 'banana_plantation',
    name = 'Banana Plantation',
    atlas = 'Joker',
	pos = { x = 3, y = 20 },
    rarity = 2,
	cost = 7,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Banana Farm", category = "support" },
        extra = { min = 1, max = 10 } --Variables: max = max possible dollars, min = min possible dollars
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.min, card.ability.extra.max } }
    end,
    calc_dollar_bonus = function(self, card)
        local dollars = pseudorandom('banana_plantation', card.ability.extra.min, card.ability.extra.max)
        return dollars
    end
}

SMODS.Joker { --BRF
    key = 'banana_research_facility',
    name = 'Banana Research Facility',
    atlas = 'Joker',
	pos = { x = 4, y = 20 },
    rarity = 2,
	cost = 8,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Banana Farm", category = "support" },
        extra = { min = 1, crates = 5, money = 2 } --Variables: max = max possible dollars, min = min possible dollars
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.min, card.ability.extra.crates, card.ability.extra.money } }
    end,
    calc_dollar_bonus = function(self, card)
        local dollars = card.ability.extra.money * card.ability.extra.min
        for i = card.ability.extra.min + 1, card.ability.extra.crates do
            if pseudorandom('banana_research_facility') > 0.5 then
                dollars = dollars + card.ability.extra.money
            end
        end
        return dollars
    end
}

SMODS.Joker { --Banana Central
    key = 'banana_central',
    name = 'Banana Central',
    atlas = 'Joker',
	pos = { x = 5, y = 20 },
    rarity = 3,
	cost = 10,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Banana Farm", category = "support" },
        extra = { money = 8, current = 0 } --Variables: money = dollars per farm
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money, card.ability.extra.current } }
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            local count = 0
            for k, v in ipairs(G.jokers.cards) do
                if v.ability.tower_info and v.ability.tower_info.base and v.ability.tower_info.base == "Banana Farm" then
                    count = count + 1
                end
            end
            card.ability.extra.current = card.ability.extra.money * count
        end
    end,
    calc_dollar_bonus = function(self, card)
        if card.ability.extra.current > 0 then
            return card.ability.extra.current
        end
    end
}

SMODS.Joker { --Long Life Bananas
    key = 'long_life_bananas',
    name = 'Long Life Bananas',
    atlas = 'Joker',
	pos = { x = 6, y = 20 },
    rarity = 1,
	cost = 4,
    blueprint_compat = false,
    eternal_compat = false,
    config = {
        tower_info = { base = "Banana Farm", category = "support" },
        extra = { num = 1, denom = 3, money = 10, bananas = 2 } --Variables: money = dollars, bananas = bananas remaining
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'long_life_bananas')
        return { vars = { n, d, card.ability.extra.money, card.ability.extra.bananas } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'long_life_bananas', card.ability.extra.num, card.ability.extra.denom, 'long_life_bananas') then
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

SMODS.Joker { --Valuable Bananas
    key = 'valuable_bananas',
    name = 'Valuable Bananas',
    atlas = 'Joker',
	pos = { x = 7, y = 20 },
    rarity = 1,
	cost = 5,
    blueprint_compat = false,
    eternal_compat = false,
    config = {
        tower_info = { base = "Banana Farm", category = "support" },
        extra = { num = 1, denom = 4, money = 15, bananas = 3 } --Variables: money = dollars, bananas = bananas remaining
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'valuable_bananas')
        return { vars = { n, d, card.ability.extra.money, card.ability.extra.bananas } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'valuvaluable_bananasable', card.ability.extra.num, card.ability.extra.denom, 'valuable_bananas') then
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

SMODS.Joker { --Monkey Bank
    key = 'monkey_bank',
    name = 'Monkey Bank',
	atlas = 'Joker',
	pos = { x = 8, y = 20 },
    rarity = 2,
	cost = 7,
    blueprint_compat = false,
    eternal_compat = false,
    config = {
        tower_info = { base = "Banana Farm", category = "support" },
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
                    local card = create_card('j_bloons_monkey_bank', G.jokers, nil, nil, nil, nil, 'j_bloons_monkey_bank', 'monkey_bank')
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

SMODS.Joker { --IMF Loan
    key = 'imf_loan',
    name = 'IMF Loan',
	atlas = 'Joker',
	pos = { x = 9, y = 20 },
    rarity = 2,
	cost = 7,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Banana Farm", category = "support" },
        extra = { bankrupt = 10, money = 4 } --Variables: bankrupt = max amount of debt, money = sell value per round
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.bankrupt, card.ability.extra.money } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.bankrupt_at = G.GAME.bankrupt_at - card.ability.extra.bankrupt
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.bankrupt_at = G.GAME.bankrupt_at + card.ability.extra.bankrupt
    end,
    calculate = function(self, card, context)
        if context.setting_blind and G.GAME.dollars < to_big(0) and not card.getting_sliced and not context.blueprint then
            card.ability.extra_value = card.ability.extra_value + G.GAME.dollars
            card:set_cost()
            return {
                dollars = -G.GAME.dollars,
                colour = G.C.MONEY
            }
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra_value = card.ability.extra_value + card.ability.extra.money
            card:set_cost()
            return {
                message = localize('k_val_up'),
                colour = G.C.MONEY
            }
        end
    end
}

SMODS.Joker { --Monkey-Nomics
    key = 'monkey_nomics',
    name = 'Monkey-Nomics',
	atlas = 'Joker',
	pos = { x = 10, y = 20 },
    rarity = 3,
	cost = 10,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Banana Farm", category = "support" },
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_hermit
    end,
    calculate = function(self, card, context)
        if context.setting_blind and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and not context.blind.boss then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    local card = create_card('c_hermit', G.consumeables, nil, nil, nil, nil, 'c_hermit', 'monkey_nomics')
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

SMODS.Joker { --EZ Collect
    key = 'ez_collect',
    name = 'EZ Collect',
	atlas = 'Joker',
	pos = { x = 11, y = 20 },
    rarity = 1,
	cost = 5,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Banana Farm", category = "support" },
        extra = { money = 1, current = 0 } --Variables: money = dollars per joker, current = current end of round dollars
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money, card.ability.extra.current } }
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            card.ability.extra.current = card.ability.extra.money * #G.jokers.cards
            if #find_joker('EZ Collect') > 0 then
                card.ability.extra.current = card.ability.extra.current - card.ability.extra.money
            end
        end
    end,
    calc_dollar_bonus = function(self, card)
        if card.ability.extra.current > 0 then
            return card.ability.extra.current
        end
    end
}

SMODS.Joker { --Banana Salvage
    key = 'banana_salvage',
    name = 'Banana Salvage',
    atlas = 'Joker',
	pos = { x = 12, y = 20 },
    rarity = 1,
	cost = 5,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Banana Farm", category = "support" },
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
            if context.card.set_cost then
                context.card:set_cost()
            end
        end
    end
}

SMODS.Joker { --Marketplace
    key = 'marketplace',
    name = 'Marketplace',
	atlas = 'Joker',
	pos = { x = 13, y = 20 },
    rarity = 2,
	cost = 7,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Banana Farm", category = "support" },
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

SMODS.Joker { --Central Market
    key = 'central_market',
    name = 'Central Market',
	atlas = 'Joker',
	pos = { x = 14, y = 20 },
    rarity = 2,
	cost = 8,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Banana Farm", category = "support" },
        extra = { money = 2, current = 0 } --Variables: Xmult = Xmult gain/loss, current = current Xmult
    }, 

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money, card.ability.extra.current } }
    end,
    update = function(self, card, dt)
        local count = 0
        for k, v in pairs(G.GAME.used_vouchers) do
            local redeemed = v
            if G.GAME.selected_back.effect and G.GAME.selected_back.effect.config then
                if k == G.GAME.selected_back.effect.config.voucher then
                    redeemed = false
                elseif G.GAME.selected_back.effect.config.vouchers then
                    for i, j in pairs(G.GAME.selected_back.effect.config.vouchers) do
                        if k == j then
                            redeemed = false
                        end
                    end
                end
            end
            if redeemed then
                count = count + 1
            end
        end
        card.ability.extra.current = card.ability.extra.money * count
    end,
    calc_dollar_bonus = function(self, card)
        if card.ability.extra.current > 0 then
            return card.ability.extra.current
        end
    end
}

SMODS.Joker { --Monkey Wall Street
    key = 'monkey_wall_street',
    name = 'Monkey Wall Street',
    atlas = 'Joker',
	pos = { x = 15, y = 20 },
    rarity = 3,
	cost = 9,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Banana Farm", category = "support" },
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
