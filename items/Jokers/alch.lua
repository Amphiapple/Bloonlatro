SMODS.Joker { --Alchemist
    key = 'alch',
    name = 'Alchemist',
	loc_txt = {
        name = 'Alchemist',
        text = {
            'Create a {C:tarot}Tarot{} card',
            'on {C:attention}final hand{} of round',
            '{C:green}#1# in #2#{} chance to create',
            'a {C:spectral}Spectral{} card instead',
            '{C:inactive}(Must have room){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 6, y = 1 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'alch',
        extra = { num = 1, denom = 2 } --Variables: num/denom = probability fraction
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_foil
        info_queue[#info_queue + 1] = G.P_CENTERS.e_holo
        info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'alch')
        return { vars = { n, d } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_left == 0 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            if SMODS.pseudorandom_probability(card, 'alch', card.ability.extra.num, card.ability.extra.denom, 'alch') then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        local card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'alch')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
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
                        local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'alch')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
            end
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
	pos = { x = 6, y = 4 },
    rarity = 1,
	cost = 6,
    blueprint_compat = false,
    config = {
        base = 'alch',
        extra = { num = 1, denom = 4 } --Variables: num/denom = probability fraction
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'amd')
        return { vars = { n, d } }
    end,
    calculate = function(self, card, context)
        if context.before and SMODS.pseudorandom_probability(card, 'amd', card.ability.extra.num, card.ability.extra.denom, 'amd') and not context.blueprint then
            local other_card = context.scoring_hand[# context.scoring_hand]
            if not other_card.edition then
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
	pos = { x = 6, y = 7 },
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
	pos = { x = 6, y = 10 },
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
        if context.discard and G.GAME.current_round.discards_left <= 1 and #context.full_hand == 1 and not context.blueprint then
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
	pos = { x = 6, y = 13 },
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
                    left:set_eternal(nil)
                    left.ability.eternal = nil
                    left:set_perishable(nil)
                    left.ability.perishable = nil
                    left:set_rental(nil)
                    left.ability.rental = nil
					left.pinned = nil
					left.ability.pinned = nil
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
        end
    end
}