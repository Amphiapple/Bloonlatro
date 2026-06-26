SMODS.Joker { --Monkey Village
    key = 'monkey_village',
    name = 'Monkey Village',
    atlas = 'Joker',
	pos = { x = 0, y = 22 },
    rarity = 1,
	cost = 5,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Monkey Village", category = "support" },
    },
}

SMODS.Joker { --Bigger Radius
    key = 'bigger_radius',
    name = 'Bigger Radius',
    atlas = 'Joker',
	pos = { x = 1, y = 22 },
    rarity = 1,
	cost = 5,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Monkey Village", category = "support" },
    },
}

SMODS.Joker { --Jungle Drums
    key = 'jungle_drums',
    name = 'Jungle Drums',
    atlas = 'Joker',
	pos = { x = 2, y = 22 },
    rarity = 1,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Monkey Village", category = "support" },
        extra = { Xmult = 1.1 } --Variables: Xmult = Xmult per joker
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.other_joker and context.other_joker ~= card then
            G.E_MANAGER:add_event(Event({
                func = function()
                    context.other_joker:juice_up(0.5, 0.5)
                    return true
                end
            }))
            return {
                Xmult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --Primary Training
    key = 'primary_training',
    name = 'Primary Training',
    atlas = 'Joker',
	pos = { x = 3, y = 22 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Monkey Village", category = "support" },
        extra = { Xmult = 1.25 } --Variables: Xmult = Xmult per primary joker
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.other_joker and context.other_joker.ability.tower_info and context.other_joker.ability.tower_info.category == 'primary' then
            G.E_MANAGER:add_event(Event({
                func = function()
                    context.other_joker:juice_up(0.5, 0.5)
                    return true
                end
            }))
            return {
                Xmult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --Primary Mentoring
    key = 'primary_mentoring',
    name = 'Primary Mentoring',
    atlas = 'Joker',
	pos = { x = 4, y = 22 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Monkey Village", category = "support" },
        extra = { Xmult = 1.2 } --Variables: Xmult = Xmult per primary joker
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.other_joker and context.other_joker.ability.tower_info and context.other_joker.ability.tower_info.category == 'primary' then
            G.E_MANAGER:add_event(Event({
                func = function()
                    context.other_joker:juice_up(0.5, 0.5)
                    return true
                end
            }))
            return {
                Xmult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --Primary Expertise
    key = 'primary_expertise',
    name = 'Primary Expertise',
    atlas = 'Joker',
	pos = { x = 5, y = 22 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Monkey Village", category = "support" },
        extra = { num = 1, denom = 5, Xmult = 3 } --Variables: num/denom = probability fraction, Xmult = Xmult
    },
    
    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'primary_expertise')
        return { vars = { n, d, card.ability.extra.Xmult } }
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            local primaries = 0
            for i = 1, #G.jokers.cards do
                local joker = G.jokers.cards[i]
                if joker.ability.tower_info and joker.ability.tower_info.category == 'primary' then
                    primaries = primaries + 1
                end
            end
            card.ability.extra.num = primaries + 1
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        recalc_all_costs()
    end,
    remove_from_deck = function(self, card, from_debuff)
        recalc_all_costs()
    end,
    calculate = function(self, card, context)
        if context.joker_main and SMODS.pseudorandom_probability(card, 'primary_expertise', card.ability.extra.num, card.ability.extra.denom, 'primary_expertise') then
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --Grow Blocker
    key = 'grow_blocker',
    name = 'Grow Blocker',
    atlas = 'Joker',
    pos = { x = 6, y = 22 },
    rarity = 1,
    cost = 5,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Monkey Village", category = "support" },
    },

    calculate = function(self, card, context)
        if context.mod_probability and not context.blueprint then
            return {
                numerator = context.numerator / 2
            }
        end
    end
}

SMODS.Joker { --Radar Scanner
    key = 'radar_scanner',
    name = 'Radar Scanner',
    atlas = 'Joker',
    pos = { x = 7, y = 22 },
    rarity = 1,
    cost = 6,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Monkey Village", category = "support" },
    },

    calculate = function(self, card, context)
        if context.mod_probability and not context.blueprint then
            return {
                numerator = context.numerator * 2
            }
        end
    end
}

SMODS.Joker { --Monkey Intelligence Bureau
    key = 'monkey_intelligence_bureau',
    name = 'Monkey Intelligence Bureau',
    atlas = 'Joker',
    pos = { x = 8, y = 22 },
    rarity = 2,
    cost = 7,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Monkey Village", category = "support" },
        extra = { num = 1 } --Variables: num = number of different rarities
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.num } }
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

SMODS.Joker { --Call to Arms
    key = 'call_to_arms',
    name = 'Call to Arms',
    atlas = 'Joker',
    pos = { x = 9, y = 22 },
    rarity = 2,
    cost = 8,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Monkey Village", category = "support" },
    },

    calculate = function(self, card, context)
        if context.mod_probability and not context.blueprint then
            if (G.GAME.current_round.hands_left == 1 and not next(G.play.cards) or G.GAME.current_round.hands_left == 0 and next(G.play.cards)) then
                return {
                    numerator = context.numerator * 4
                }
            end
        end
    end
}

SMODS.Joker { --Homeland Defense
    key = 'homeland_defense',
    name = 'Homeland Defense',
    atlas = 'Joker',
    pos = { x = 10, y = 22 },
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Monkey Village", category = "support" },
    },

    calculate = function(self, card, context)
        if context.mod_probability and not context.blueprint then
            return {
                denominator = 2
            }
        end
    end
}

SMODS.Joker { --Monkey Business
    key = 'monkey_business',
    name = 'Monkey Business',
    atlas = 'Joker',
	pos = { x = 11, y = 22 },
    rarity = 1,
	cost = 5,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Monkey Village", category = "support" },
        extra = { cost = 1 } --Variables: cost = discount amount
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
}

SMODS.Joker { --Monkey Commerce
    key = 'monkey_commerce',
    name = 'Monkey Commerce',
    atlas = 'Joker',
	pos = { x = 12, y = 22 },
    rarity = 1,
	cost = 5,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Monkey Village", category = "support" },
        extra = { percent = 25 } --Variables: percent = discount percent
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.percent } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.discount_percent = G.GAME.discount_percent + card.ability.extra.percent
                return true
            end
        }))
        recalc_all_costs()
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.discount_percent = G.GAME.discount_percent - card.ability.extra.percent
                return true
            end
        }))
        recalc_all_costs()
    end,
}

SMODS.Joker { --Monkey Town
    key = 'monkey_town',
    name = 'Monkey Town',
	atlas = 'Joker',
	pos = { x = 13, y = 22 },
    rarity = 2,
	cost = 8,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Monkey Village", category = "support" },
        extra = { percent = 50 } --Variables: percent = percent extra money
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.percent } }
    end,
}

SMODS.Joker { --Monkey City
    key = 'monkey_city',
    name = 'Monkey City',
	atlas = 'Joker',
	pos = { x = 14, y = 22 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Monkey Village", category = "support" },
        extra = { money = 1, current = 0 } --Variables: money = dollars per dart, current = current dollars
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.j_bloons_dart_monkey
        return { vars = { card.ability.extra.money, card.ability.extra.current } }
    end,
    calc_dollar_bonus = function(self, card)
        if card.ability.extra.current > 0 then
            return card.ability.extra.current
        end
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
            G.GAME.joker_buffer = G.GAME.joker_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = function()
                    local card = create_card('j_bloons_dart_monkey', G.jokers, nil, nil, nil, nil, 'j_bloons_dart_monkey', 'monkey_city')
                    card.extra_cost = -card.base_cost
                    card.sell_cost = 0
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    card:start_materialize()
                    G.GAME.joker_buffer = 0
                    return true
                end
            }))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.money
        end
    end
}

SMODS.Joker { --Monkeyopolis
    key = 'monkeyopolis',
    name = 'Monkeyopolis',
	atlas = 'Joker',
	pos = { x = 15, y = 22 },
    rarity = 3,
	cost = 1,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Monkey Village", category = "support" },
    },

    calc_dollar_bonus = function(self, card)
        if card.sell_cost > 0 then
            return math.floor(card.sell_cost / 2)
        end
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then my_pos = i; break end
            end
            if my_pos and G.jokers.cards[my_pos+1] and not SMODS.is_eternal(G.jokers.cards[my_pos+1], card) and not G.jokers.cards[my_pos+1].getting_sliced then
                local sliced_card = G.jokers.cards[my_pos+1]
                sliced_card.getting_sliced = true
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.GAME.joker_buffer = 0
                        card:juice_up(0.8, 0.8)
                        sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                        play_sound('slice1', 0.96+math.random()*0.08)
                        return true
                    end
                }))
                SMODS.scale_card(card, {
                    ref_table = card.ability,
                    ref_value = "extra_value",
                    scalar_table = sliced_card,
                    scalar_value = "sell_cost",
                    scaling_message = {
                        message = localize('k_val_up'),
                        colour = G.C.MONEY
                    }
                })
                if card.set_cost then
                    card:set_cost()
                end
                return nil, true
            end
        end
    end
}
