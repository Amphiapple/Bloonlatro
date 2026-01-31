SMODS.Joker { --Alchemist
    key = 'alch',
    name = 'Alchemist',
	loc_txt = {
        name = 'Alchemist',
        text = {
            'Create a {C:tarot}Tarot{} card',
            'on {C:attention}final hand{} of round',
            '{C:inactive}(Must have room){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 17 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'alch',
        extra = {}
    },

    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_left == 0 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    local tarot = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'alch')
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

SMODS.Joker { --Larger Potions
    key = 'largerpots',
    name = 'Larger Potions',
	loc_txt = {
        name = 'Larger Potions',
        text = {
            'Create {C:attention}#1# {C:tarot}Tarot{} cards',
            'on {C:attention}final hand{} of round',
            '{C:inactive}(Must have room){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 17 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'alch',
        extra = { number = 2 } --Variables: number = number of tarots
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.number } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_left == 0 then
            local count = 0
            for i = 1, card.ability.extra.number do
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                            local tarot = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'alch')
                            tarot:add_to_deck()
                            G.consumeables:emplace(tarot)
                            G.GAME.consumeable_buffer = 0
                            return true
                        end)
                    }))
                end
                count = count + 1
            end
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = '+'.. count .. ' Tarot', colour = G.C.PURPLE})
        end
    end
}

SMODS.Joker { --Acidic Mixture Dip
    key = 'amd',
    name = 'Acidic Mixture Dip',
    loc_txt = {
        name = 'Acidic Mixture Dip',
        text = {
            '{C:green}#1# in #2#{} chance to',
            'add {C:dark_edition}Foil{}, {C:dark_edition}Holographic{},',
            'or {C:dark_edition}Polychrome{} effect to',
            '{C:attention}last{} played card that scores'
        }
    },
    atlas = 'Joker',
	pos = { x = 2, y = 17 },
    rarity = 1,
	cost = 6,
    blueprint_compat = false,
    config = {
        base = 'alch',
        extra = { num = 1, denom = 4 } --Variables: num/denom = probability fraction
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_foil
        info_queue[#info_queue + 1] = G.P_CENTERS.e_holo
        info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'amd')
        return { vars = { n, d } }
    end,
    calculate = function(self, card, context)
        if context.before and SMODS.pseudorandom_probability(card, 'amd', card.ability.extra.num, card.ability.extra.denom, 'amd') and not context.blueprint then
            local other_card = context.scoring_hand[# context.scoring_hand]
            if not other_card.edition and not other_card.debuff then
                local edition = poll_edition('amd', nil, true, true)
                other_card:set_edition(edition, true)
            end
        end
    end
}

SMODS.Joker { --Berserker Brew
    key = 'brew',
    name = 'Berserker Brew',
	loc_txt = {
        name = 'Berserker Brew',
        text = {
            'Sell this card to add',
            '{C:dark_edition}Foil{}, {C:dark_edition}Holographic{}, or',
            '{C:dark_edition}Polychrome{} edition',
            'to a random {C:attention}Joker{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 17 },
    rarity = 2,
	cost = 6,
    blueprint_compat = false,
    eternal_compat = false,
    config = {
        base = 'alch',
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
                    local joker = pseudorandom_element(card.eligible_jokers, pseudoseed('brew'))
                    if joker then
                        local edition = poll_edition('brew', nil, true, true)
                        joker:set_edition(edition, true)
                    end
                    return true
                end
            }))
        end
    end
}

SMODS.Joker { --Stronger Stimulant
    key = 'stim',
    name = 'Stronger Stimulant',
	loc_txt = {
        name = 'Stronger Stimulant',
        text = {
            'Sell this card to add',
            '{C:dark_edition}Polychrome{} edition',
            'to a random {C:attention}Joker{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 17 },
    rarity = 2,
	cost = 7,
    blueprint_compat = false,
    eternal_compat = false,
    config = {
        base = 'alch',
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

SMODS.Joker { --Stronger Acid
    key = 'acid',
    name = 'Stronger Acid',
	loc_txt = {
        name = 'Stronger Acid',
        text = {
            'Create a {C:tarot}Tarot{} card',
            'on {C:attention}final hand{} of round',
            '{C:green}#1# in #2#{} chance to create',
            'a {C:spectral}Spectral{} card instead',
            '{C:inactive}(Must have room){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 6, y = 17 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'alch',
        extra = { num = 1, denom = 2 } --Variables: num/denom = probability fraction
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'acid')
        return { vars = { n, d } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_left == 0 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            if SMODS.pseudorandom_probability(card, 'acid', card.ability.extra.num, card.ability.extra.denom, 'acid') then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        local spectral = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'acid')
                        spectral:add_to_deck()
                        G.consumeables:emplace(spectral)
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
                        local tarot = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'acid')
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
    key = 'perishing',
    name = 'Perishing Potions',
	loc_txt = {
        name = 'Perishing Potions',
        text = {
            'Add {C:dark_edition}Polychrome{}',
            'edition and {C:attention}Perishable{}',
            'to this {C:attention}Joker{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 7, y = 17 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    eternal_compat = false,
    config = {
        base = 'alch',
    },

    add_to_deck = function(self, card, from_debuff)
        card:set_edition('e_polychrome', true)
        card:set_perishable()
    end
}

SMODS.Joker { --Unstable Concoction
    key = 'conc',
    name = 'Unstable Concoction',
	loc_txt = {
        name = 'Unstable Concoction',
        text = {
            'If {C:attention}first hand{} of round',
            'has only {C:attention}1{} card, destroy',
            '{C:attention}Joker{} to the right to',
            'add a random {C:attention}seal{} to it',
        }
    },
	atlas = 'Joker',
	pos = { x = 8, y = 17 },
    rarity = 2,
	cost = 6,
    blueprint_compat = false,
    config = {
        base = 'alch',
    },

    calculate = function(self, card, context)
        if context.before and G.GAME.current_round.hands_played == 0 and #context.full_hand == 1 and not context.full_hand[1].debuff and not context.blueprint then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then my_pos = i; break end
            end
            if my_pos and G.jokers.cards[my_pos+1] and not SMODS.is_eternal(G.jokers.cards[my_pos+1], self) then
                local sliced_card = G.jokers.cards[my_pos+1]
                sliced_card.getting_sliced = true
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.GAME.joker_buffer = 0
                        context.full_hand[1]:set_seal(SMODS.poll_seal({type_key = 'conc', guaranteed = true}), nil, true)
                        card:juice_up(0.8, 0.8)
                        sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                        play_sound('tarot2', 0.96+math.random()*0.08)
                        return true
                    end
                }))
                delay(0.5)
            end
        end
    end
}

SMODS.Joker { --Transforming Tonic
    key = 'tt4',
    name = 'Transforming Tonic',
	loc_txt = {
        name = 'Transforming Tonic',
        text = {
            'If {C:attention}first hand{} of round is',
            '{C:attention}2{} cards with the same rank,',
            '{C:attention}Transform{} the {C:attention}left{} card',
            'into the {C:attention}right{} card',
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 17 },
    rarity = 2,
	cost = 7,
    blueprint_compat = false,
    config = {
        base = 'alch',
    },

    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function()
                return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES
            end
            juice_card_until(card, eval, true)
        elseif context.before and G.GAME.current_round.hands_played == 0 and #context.full_hand == 2 and context.full_hand[1]:get_id() == context.full_hand[2]:get_id() and not context.blueprint then
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
    key = 'tt5',
    name = 'Total Transformation',
	loc_txt = {
        name = 'Total Transformation',
        text = {
            'After {C:attention}#1#{} rounds,',
            'sell this card to {C:attention}Transform{}',
            'the {C:attention}Joker{} to the {C:attention}left{} into ',
            'the {C:attention}Joker{} to the {C:attention}right{}',
            '{C:inactive}(Currently {C:attention}#2#{C:inactive}/#1#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 10, y = 17 },
    rarity = 3,
	cost = 8,
    blueprint_compat = false,
    eternal_compat = false,
    config = {
        base = 'alch',
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
                    -- Remove Bunco stickers
                    left:set_scattering(nil)
                    left:set_hindered(nil)
                    left:set_reactive(nil)
                    
                    copy_card(right, left, nil, nil, right.edition and right.edition.negative)
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
    key = 'fastalch',
    name = 'Faster Throwing',
	loc_txt = {
        name = 'Faster Throwing',
        text = {
            'Create a {C:tarot}Tarot{} card',
            'on hand before',
            '{C:attention}final hand{} of round',
            '{C:inactive}(Must have room){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 11, y = 17 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'alch',
    },

    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_left == 1 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    local tarot = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'fastalch')
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
    key = 'pools',
    name = 'Acid Pools',
	loc_txt = {
        name = 'Acid Pools',
        text = {
            'Create a {C:tarot}Tarot{} card',
            'at end of round',
            '{C:inactive}(Must have room){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 12, y = 17 },
    rarity = 1,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'alch',
    },

    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    local tarot = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'pools')
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
    key = 'l2g',
    name = 'Lead to Gold',
	loc_txt = {
        name = 'Lead to Gold',
        text = {
            'Remove {C:attention}Steel{} from',
            'and add a {C:attention}Gold Seal{} to',
            'played cards when scored',
        }
    },
	atlas = 'Joker',
	pos = { x = 13, y = 17 },
    rarity = 2,
	cost = 6,
    blueprint_compat = false,
    enhancement_gate = 'm_steel',
    config = {
        base = 'alch',
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
        info_queue[#info_queue + 1] = G.P_SEALS.Gold
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.ability.name == 'Steel Card' and not context.other_card.debuff and not context.blueprint then
            context.other_card:set_ability(G.P_CENTERS.c_base, nil, true)
            context.other_card:set_seal('Gold', nil, true)
        end
    end
}

SMODS.Joker { --Rubber to Gold
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
	pos = { x = 14, y = 17 },
    rarity = 2,
	cost = 6,
    blueprint_compat = false,
    config = {
        base = 'alch',
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
    key = 'bma',
    name = 'Bloon Master Alchemist',
	loc_txt = {
        name = 'Bloon Master Alchemist',
        text = {
            'Set money to {C:money}$0{}',
            'and add random {C:attention}seals{}',
            'to all scoring cards on',
            '{C:attention}final hand{} of round'
        }
    },
	atlas = 'Joker',
	pos = { x = 15, y = 17 },
    rarity = 3,
	cost = 8,
    blueprint_compat = false,
    config = {
        base = 'alch',
    },

    calculate = function(self, card, context)
        if context.before and G.GAME.current_round.hands_left == 0 then
            ease_dollars(-G.GAME.dollars, true)
            for k, v in ipairs(context.scoring_hand) do
                v:set_seal(SMODS.poll_seal({type_key = 'bma', guaranteed = true}), nil, true)
            end
        end
    end
}
