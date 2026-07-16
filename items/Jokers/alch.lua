SMODS.Joker { --Alchemist
    key = 'alchemist',
    name = 'Alchemist',
	atlas = 'Joker',
	pos = { x = 0, y = 17 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Alchemist", category = "magic" },
        extra = {}
    },

    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_left == 0 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = function()
                    local tarot = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'alchemist')
                    tarot:add_to_deck()
                    G.consumeables:emplace(tarot)
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
        end
    end
}

SMODS.Joker { --Larger Potions
    key = 'larger_potions',
    name = 'Larger Potions',
	atlas = 'Joker',
	pos = { x = 1, y = 17 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Alchemist", category = "magic" },
        extra = { num = 1, denom = 2, number = 2 } --Variables: number = number of tarots
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'larger_potions')
        return { vars = { n, d, card.ability.extra.number } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_left == 0 then
            local count = 0
            local number = SMODS.pseudorandom_probability(card, 'larger_potions', card.ability.extra.num, card.ability.extra.denom, 'larger_potions') and not context.blueprint and card.ability.extra.number or 1
            for i = 1, number do
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            local tarot = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'larger_potions')
                            tarot:add_to_deck()
                            G.consumeables:emplace(tarot)
                            G.GAME.consumeable_buffer = 0
                            return true
                        end)
                    }))
                end
                count = count + 1
            end
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = '+'.. count .. ' Tarots', colour = G.C.PURPLE})
        end
    end
}

SMODS.Joker { --Acidic Mixture Dip
    key = 'acidic_mixture_dip',
    name = 'Acidic Mixture Dip',
    atlas = 'Joker',
	pos = { x = 2, y = 17 },
    rarity = 1,
	cost = 6,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Alchemist", category = "magic" },
        extra = { num = 1, denom = 4 } --Variables: num/denom = probability fraction
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_foil
        info_queue[#info_queue + 1] = G.P_CENTERS.e_holo
        info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'acidic_mixture_dip')
        return { vars = { n, d } }
    end,
    calculate = function(self, card, context)
        if context.before and SMODS.pseudorandom_probability(card, 'acidic_mixture_dip', card.ability.extra.num, card.ability.extra.denom, 'acidic_mixture_dip') and not context.blueprint then
            local other_card = context.scoring_hand[# context.scoring_hand]
            if not other_card.edition and not other_card.debuff then
                local edition = poll_edition('acidic_mixture_dip', nil, true, true)
                other_card:set_edition(edition, true)
            end
        end
    end
}

SMODS.Joker { --Berserker Brew
    key = 'berserker_brew',
    name = 'Berserker Brew',
	atlas = 'Joker',
	pos = { x = 3, y = 17 },
    rarity = 2,
	cost = 6,
    blueprint_compat = false,
    eternal_compat = false,
    config = {
        tower_info = { base = "Alchemist", category = "magic" },
        eligible_jokers = {} --Variables: eligible_jokers = possible jokers to give polychrome
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_foil
        info_queue[#info_queue + 1] = G.P_CENTERS.e_holo
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
                    local joker = pseudorandom_element(card.eligible_jokers, 'berserker_brew')
                    if joker then
                        local edition = poll_edition('berserker_brew', nil, true, true)
                        joker:set_edition(edition, true)
                    end
                    return true
                end
            }))
        end
    end
}

SMODS.Joker { --Stronger Stimulant
    key = 'stronger_stimulant',
    name = 'Stronger Stimulant',
	atlas = 'Joker',
	pos = { x = 4, y = 17 },
    rarity = 2,
	cost = 7,
    blueprint_compat = false,
    eternal_compat = false,
    config = {
        tower_info = { base = "Alchemist", category = "magic" },
        eligible_jokers = {} --Variables: eligible_jokers = possible jokers to give polychrome
    },

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
                    local joker = pseudorandom_element(card.eligible_jokers, 'stronger_stimulant')
                    if joker then
                        joker:set_edition('e_polychrome', true)
                    end
                    return true
                end
            }))
        end
    end
}

SMODS.Joker { --Permanent Brew
    key = 'permanent_brew',
    name = 'Permanent Brew',
	atlas = 'Joker',
	pos = { x = 5, y = 17 },
    rarity = 3,
	cost = 9,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Alchemist", category = "magic" },
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_foil
        info_queue[#info_queue + 1] = G.P_CENTERS.e_holo
        info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local other_card = context.scoring_hand[#context.scoring_hand]
            if not other_card.debuff then
                local edition = poll_edition('permanent_brew', nil, true, true)
                other_card:set_edition(edition, true)
            end
        end
    end
}

SMODS.Joker { --Stronger Acid
    key = 'stronger_acid',
    name = 'Stronger Acid',
	atlas = 'Joker',
	pos = { x = 6, y = 17 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Alchemist", category = "magic" },
        extra = { num = 1, denom = 2 } --Variables: num/denom = probability fraction
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'stronger_acid')
        return { vars = { n, d } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_left == 0 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            if SMODS.pseudorandom_probability(card, 'stronger_acid', card.ability.extra.num, card.ability.extra.denom, 'stronger_acid') then
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        local spectral = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'stronger_acid')
                        spectral:add_to_deck()
                        G.consumeables:emplace(spectral)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
            else
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        local tarot = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'stronger_acid')
                        tarot:add_to_deck()
                        G.consumeables:emplace(tarot)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
            end
        end
    end
}

SMODS.Joker { --Perishing Potions
    key = 'perishing_potions',
    name = 'Perishing Potions',
	atlas = 'Joker',
	pos = { x = 7, y = 17 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    eternal_compat = false,
    config = {
        tower_info = { base = "Alchemist", category = "magic" },
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
    end,
    add_to_deck = function(self, card, from_debuff)
        if from_debuff then return end
        G.E_MANAGER:add_event(Event({
            func = (function()
                card:set_edition('e_polychrome', true)
                card:set_perishable()
                return true
            end)
        }))
    end
}

SMODS.Joker { --Unstable Concoction
    key = 'unstable_concoction',
    name = 'Unstable Concoction',
	atlas = 'Joker',
	pos = { x = 8, y = 17 },
    rarity = 2,
	cost = 6,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Alchemist", category = "magic" },
    },

    calculate = function(self, card, context)
        if context.before and G.GAME.current_round.hands_played == 0 and #context.full_hand == 1 and not context.full_hand[1].debuff and not context.blueprint then
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
                        local seal = SMODS.poll_seal({type_key = 'unstable_concoction', guaranteed = true})
                        context.full_hand[1]:set_seal(seal, nil, true)
                        card:juice_up(0.8, 0.8)
                        sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                        play_sound('tarot2', 0.96+math.random()*0.08)
                        G.GAME.joker_buffer = 0
                        return true
                    end
                }))
                delay(0.5)
            end
        end
    end
}

SMODS.Joker { --Transforming Tonic
    key = 'transforming_tonic',
    name = 'Transforming Tonic',
	atlas = 'Joker',
	pos = { x = 9, y = 17 },
    rarity = 2,
	cost = 7,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Alchemist", category = "magic" },
    },

    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function()
                return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES
            end
            juice_card_until(card, eval, true)
        elseif context.before and G.GAME.current_round.hands_played == 0 and #context.full_hand == 2 and not context.blueprint then
            local rightmost = context.full_hand[#context.full_hand]
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    for i=1, #context.full_hand do
                        context.full_hand[i]:flip()
                    end
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    for i=1, #context.full_hand do
                        if context.full_hand[i] ~= rightmost then
                            copy_card(rightmost, context.full_hand[i])
                        end
                    end
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    for i=1, #context.full_hand do
                        context.full_hand[i]:flip()
                    end
                    return true
                end
            }))
        end
    end
}

SMODS.Joker { --Total Transformation
    key = 'total_transformation',
    name = 'Total Transformation',
	atlas = 'Joker',
	pos = { x = 10, y = 17 },
    rarity = 3,
	cost = 8,
    blueprint_compat = false,
    eternal_compat = false,
    config = {
        tower_info = { base = "Alchemist", category = "magic" },
        extra = { rounds = 2, current = 0 } --Variables: rounds = rounds until active, current = current rounds
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.rounds, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.selling_self and card.ability.extra.current >= card.ability.extra.rounds and card ~= G.jokers.cards[1] and card ~= G.jokers.cards[#G.jokers.cards] and not context.blueprint then
            local left, right
            for k, v in ipairs(G.jokers.cards) do
                if v == card then
                    left = G.jokers.cards[k-1]
                    right = G.jokers.cards[k+1]
                end
            end
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = 'Transformed!'})
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    left:flip()
                    right:flip()
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    -- Remove stickers
                    left:set_eternal(nil)
                    left.ability.perishable = nil
                    left:set_rental(nil)
					left.pinned = nil

                    -- Copy card
                    left = copy_card(right, left, nil, nil, right.edition and right.edition.negative)

                    -- Recalculate cost for rental
                    left:set_cost()

                    -- Update JokerDisplay`
                    if JokerDisplay then left:update_joker_display() end
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    left:flip()
                    right:flip()
                    return true
                end
            }))
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = card.ability.extra.current + 1
            if card.ability.extra.current == card.ability.extra.rounds then
                local eval = function()
                    return not card.REMOVED
                end
                juice_card_until(card, eval, true)
            end
            return {
                message = (card.ability.extra.current < card.ability.extra.rounds) and (card.ability.extra.current..'/'..card.ability.extra.rounds) or localize('k_active_ex'),
                colour = G.C.FILTER
            }
        end
    end
}

SMODS.Joker { --Faster Throwing
    key = 'faster_throwing_alchemist',
    name = 'Faster Throwing (Alchemist)',
	atlas = 'Joker',
	pos = { x = 11, y = 17 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Alchemist", category = "magic" },
    },

    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_left == 1 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = (function()
                    local tarot = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'faster_throwing_alchemist')
                    tarot:add_to_deck()
                    G.consumeables:emplace(tarot)
                    G.GAME.consumeable_buffer = 0
                    return true
                end)
            }))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
        end
    end
}

SMODS.Joker { --Acid Pools
    key = 'acid_pools',
    name = 'Acid Pools',
	atlas = 'Joker',
	pos = { x = 12, y = 17 },
    rarity = 1,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Alchemist", category = "magic" },
    },

    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition and G.GAME.current_round.hands_left > 0 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = (function()
                    local tarot = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'acid_pools')
                    tarot:add_to_deck()
                    G.consumeables:emplace(tarot)
                    G.GAME.consumeable_buffer = 0
                    return true
                end)
            }))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
        end
    end
}

SMODS.Joker { --Lead to Gold
    key = 'lead_to_gold',
    name = 'Lead to Gold',
	atlas = 'Joker',
	pos = { x = 13, y = 17 },
    rarity = 2,
	cost = 6,
    blueprint_compat = false,
    enhancement_gate = 'm_steel',
    config = {
        tower_info = { base = "Alchemist", category = "magic" },
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
        info_queue[#info_queue + 1] = G.P_SEALS.Gold
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.ability.name == 'Steel Card' and not context.other_card.debuff and not context.blueprint then
            context.other_card:set_seal('Gold', nil, true)
        end
    end
}

SMODS.Joker { --Rubber to Gold
    key = 'rubber_to_gold',
    name = 'Rubber to Gold',
	atlas = 'Joker',
	pos = { x = 14, y = 17 },
    rarity = 2,
	cost = 6,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Alchemist", category = "magic" },
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS.Gold
    end,
    calculate = function(self, card, context)
        if context.discard and G.GAME.current_round.discards_left <= 1 and #context.full_hand == 1 and not context.full_hand[1].debuff and not context.blueprint then
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
}

SMODS.Joker { --Bloon Master Alchemist
    key = 'bloon_master_alchemist',
    name = 'Bloon Master Alchemist',
	atlas = 'Joker',
	pos = { x = 15, y = 17 },
    rarity = 3,
	cost = 8,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Alchemist", category = "magic" },
    },

    calculate = function(self, card, context)
        if context.before and G.GAME.current_round.hands_left == 0 then
            for k, v in ipairs(context.scoring_hand) do
                v:set_seal(SMODS.poll_seal({type_key = 'bloon_master_alchemist', guaranteed = true}), nil, true)
            end

            G.GAME.dollar_buffer = G.GAME.dollar_buffer or 0
            if G.GAME.dollars + G.GAME.dollar_buffer ~= 0 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        G.GAME.dollar_buffer = 0
                        return true
                    end
                }))
                return {
                    dollars = -G.GAME.dollars,
                    func = function()
                        G.GAME.dollar_buffer = G.GAME.dollar_buffer - G.GAME.dollars
                        return true
                    end,
                    colour = G.C.MONEY
                }
            end
        end
    end
}
