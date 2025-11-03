SMODS.Joker { --Monkey Village
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
	pos = { x = 0, y = 22 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'village',
        extra = { mult = 5 } --Variables: mult = +mult
    },

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

SMODS.Joker { --Monkey Business
    key = 'discount',
    name = 'Monkey Business',
    loc_txt = {
        name = 'Monkey Business',
        text = {
            'Shop items cost {C:attention}$#1#{} less'
        }
    },
    atlas = 'Joker',
	pos = { x = 11, y = 22 },
    rarity = 1,
	cost = 5,
    blueprint_compat = false,
    config = {
        base = 'village',
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

SMODS.Joker { --Jungle Drums
    key = 'drums',
    name = 'Jungle Drums',
    loc_txt = {
        name = 'Jungle Drums',
        text = {
            'Other {C:attention}Jokers{} each',
            'give {X:mult,C:white}X#1#{} Mult'
        }
    },
    atlas = 'Joker',
	pos = { x = 2, y = 22 },
    rarity = 1,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'village',
        extra = { Xmult = 1.15 } --Variables: Xmult = Xmult per joker
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

SMODS.Joker { --Monkey Intelligence Bureau
    key = 'mib',
    name = 'Monkey Intelligence Bureau',
    loc_txt = {
        name = 'Monkey Intelligence Bureau',
        text = {
            '{C:attention}Listed {C:green,E:1,S:1.1}probabilities{} are',
            'multiplied by the number of unique ',
            'rarities in other owned {C:attention}Jokers',
            '{C:inactive}(Currently {X:green,C:white}X#1#{C:inactive})',
        }
    },
    atlas = 'Joker',
    pos = { x = 8, y = 22 },
    rarity = 2,
    cost = 7,
    blueprint_compat = false,
    config = {
        base = 'village',
        extra = { num = 1 } --Variables: num = number of different rarities
    },

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

SMODS.Joker { --Monkey City
    key = 'city',
    name = 'Monkey City',
	loc_txt = {
        name = 'Monkey City',
        text = {
            'Create a free {C:attention}Dart Monkey{}',
            'card at start of round',
            'Earn {C:money}$#1#{} for each {C:attention}Dart Monkey{}',
            'created at end of round',
            '{C:inactive}(Currently {C:money}$#2#{C:inactive}){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 14, y = 22 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        base = 'village',
        extra = { money = 1, current = 0 } --Variables: money = dollars per dart, current = current dollars
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.j_bloons_dart
        return { vars = { card.ability.extra.money, card.ability.extra.current } } --Variables: money = dollars per dart, current = current end of round dollars
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
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.money
        end
    end
}

SMODS.Joker { --Primary Expertise
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
	pos = { x = 5, y = 22 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        base = 'village',
        extra = { num = 1, denom = 5, Xmult = 3 } --Variables: num/denom = probability fraction, Xmult = Xmult
    },
    
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
