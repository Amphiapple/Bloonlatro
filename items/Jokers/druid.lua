SMODS.Joker { --Druid
    key = 'druid',
    name = 'Druid',
    loc_txt = {
        name = 'Druid',
        text = {
            'Create a {C:planet}Planet{} card',
            'when {C:attention}Blind{} is selected',
            '{C:inactive}(Must have room)',
        }
    },
    atlas = 'Joker',
	pos = { x = 0, y = 18 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Druid", category = "magic" },
    },

    calculate = function(self, card, context)
        if context.setting_blind and not (context.blueprint_card or card).getting_sliced and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = function()
                    local planet = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'druid')
                    planet:add_to_deck()
                    G.consumeables:emplace(planet)
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.SECONDARY_SET.Planet})
        end
    end
}

SMODS.Joker { --Hard Thorns
    key = 'hard_thorns',
    name = 'Hard Thorns',
    loc_txt = {
        name = 'Hard Thorns',
        text = {
            'Create {C:attention}#1#{C:planet} Planet{} cards',
            'when {C:attention}Blind{} is selected',
            '{C:inactive}(Must have room)',
        }
    },
    atlas = 'Joker',
	pos = { x = 1, y = 18 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Druid", category = "magic" },
        extra = { number = 2 } --Variables: number = number of planets
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.number } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not (context.blueprint_card or card).getting_sliced then
            local count = 0
            for i = 1, card.ability.extra.number do
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local planet = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'hard_thorns')
                            planet:add_to_deck()
                            G.consumeables:emplace(planet)
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                end
                count = count + 1
            end
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = '+'.. count .. ' Planets', colour = G.C.SECONDARY_SET.Planet})  
        end
    end
}

SMODS.Joker { --Heart of Thunder
    key = 'heart_of_thunder',
    name = 'Heart of Thunder',
    loc_txt = {
        name = 'Heart of Thunder',
        text = {
            'Upgrade level of another',
            '{C:attention}poker hand{} every time',
            'a {C:planet}Planet{} card is used',
        }
    },
    atlas = 'Joker',
	pos = { x = 2, y = 18 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Druid", category = "magic" },
    },

    calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.ability.set == 'Planet' then
            local visible = {}
            for k, v in pairs(G.handlist) do
                if G.GAME.hands[v].visible then
                    table.insert(visible, v)
                end
            end
            local hand = pseudorandom_element(visible, pseudoseed(''))
            update_hand_text(
                { sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 },
                { handname = localize(hand, 'poker_hands'),
                    chips = G.GAME.hands[hand].chips,
                    mult = G.GAME.hands[hand].mult,
                    level = G.GAME.hands[hand].level
                }
            )
            level_up_hand(card, hand)
            update_hand_text(
                {sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''}
            )
        end
    end
}

SMODS.Joker { --Druid of the Storm
    key = 'druid_of_the_storm',
    name = 'Druid of the Storm',
	loc_txt = {
        name = 'Druid of the Storm',
        text = {
            '{C:green}#1# in #2#{} chance to',
            'create the {C:planet}Planet{} card',
            'for played {C:attention}poker hand{}',
            '{C:inactive}(Must have room)'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 18 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Druid", category = "magic" },
        extra = { num = 1, denom = 4 } --Variables: num/denom = probability fraction
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'druid_of_the_storm')
        return { vars = { n, d } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and
                SMODS.pseudorandom_probability(card, 'druid_of_the_storm', card.ability.extra.num, card.ability.extra.denom, 'druid_of_the_storm') then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = (function()
                    local planet = nil
                    for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                        if v.config.hand_type == context.scoring_name then
                            planet = v.key
                        end
                    end
                    local card = create_card('Planet', G.consumeables, nil, nil, nil, nil, planet, 'druid_of_the_storm')
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                    G.GAME.consumeable_buffer = 0
                    return true
                end)
            }))
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})
        end
    end
}

SMODS.Joker { --Ball Lightning
    key = 'ball_lightning',
    name = 'Ball Lightning',
	loc_txt = {
        name = 'Ball Lightning',
        text = {
            '{C:planet}Planet{} cards in your',
            '{C:attention}consumable{} area give {X:red,C:white}X#1#{} Mult',
            'for their specified {C:attention}poker hand{}',
            'and {X:red,C:white}X#2#{} Mult otherwise',
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 18 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Druid", category = "magic" },
        extra = { Xmult_match = 1.5, Xmult = 1.25 } --Variables: Xmult_match = Xmult if planet matches, Xmult = Xmult otherwise
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult_match, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.other_consumeable
            and context.other_consumeable.ability.set == "Planet"
            and not context.other_consumeable.debuff then
            local Xmult = (context.other_consumeable.ability.consumeable.hand_type == context.scoring_name)
                and card.ability.extra.Xmult_match
                or card.ability.extra.Xmult
            return {
                x_mult = Xmult,
                message_card = context.other_consumeable
            }
        end
    end
}

SMODS.Joker { --Monarch of Storms
    key = 'monarch_of_storms',
    name = 'Monarch of Storms',
	loc_txt = {
        name = 'Monarch of Storms',
        text = {
            'Create the {C:planet}Planet{} card',
            'for final played {C:attention}poker hand{}',
            'at end of round',
            '{C:inactive}(Must have room)'
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 18 },
    rarity = 3,
	cost = 9,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Druid", category = "magic" },
    },

    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = (function()
                    if G.GAME.last_hand_played then
                        local planet = nil
                        for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                            if v.config.hand_type == G.GAME.last_hand_played then
                                planet = v.key
                            end
                        end
                        local card = create_card('Planet', G.consumeables, nil, nil, nil, nil, planet, 'monarch_of_storms')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        G.GAME.consumeable_buffer = 0
                    end
                    return true
                end)
            }))
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})
        end
    end
}

SMODS.Joker { --Thorn Swarm
    key = 'thorn_swarm',
    name = 'Thorn Swarm',
    loc_txt = {
        name = 'Thorn Swarm',
        text = {
            'Create a {C:planet}Planet{} card when',
            'any {C:attention}Booster Pack{} is opened',
            '{C:inactive}(Must have room)'
        }
    },
    atlas = 'Joker',
	pos = { x = 6, y = 18 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Druid", category = "magic" },
    },

    calculate = function(self, card, context)
        if context.open_booster and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = function()
                    local planet = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'thorn_swarm')
                    planet:add_to_deck()
                    G.consumeables:emplace(planet)
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.SECONDARY_SET.Planet})
        end
    end
}

SMODS.Joker { --Heart of Oak
    key = 'heart_of_oak',
    name = 'Heart of Oak',
    loc_txt = {
        name = 'Heart of Oak',
        text = {
            'Earn {C:attention}$#1#{} whenever',
            'a {C:planet}Planet{} card is used',
        }
    },
    atlas = 'Joker',
	pos = { x = 7, y = 18 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Druid", category = "magic" },
        extra = { money = 2 } --Variables: money = money per used planet
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.ability.set == 'Planet' then
            return {
                dollars = card.ability.extra.money,
                colour = G.C.MONEY
            }
        end
    end
}

SMODS.Joker { --Druid of the Jungle
    key = 'druid_of_the_jungle',
    name = 'Druid of the Jungle',
    loc_txt = {
        name = 'Druid of the Jungle',
        text = {
            '{C:planet}Planet{} cards in your',
            '{C:attention}consumable{} area earn {C:money}$#1#{}',
            'at end of round',
        }
    },
    atlas = 'Joker',
	pos = { x = 8, y = 18 },
    rarity = 2,
	cost = 5,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Druid", category = "magic" },
        extra = { money = 4 } --Variables: money = money per planet held
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calc_dollar_bonus = function(self, card)
        local count = 0
        for k, v in ipairs(G.consumeables.cards) do
            if v.ability.set == 'Planet' then
                count = count + 1
            end
        end
        return card.ability.extra.money * count
    end
}

SMODS.Joker { --Jungle's Bounty
    key = 'jungles_bounty',
    name = "Jungle's Bounty",
	loc_txt = {
        name = "Jungle's Bounty",
        text = {
            'Destroy all {C:planet}Planet{}',
            'cards in your {C:attention}consumable{}',
            'area and earn {C:money}$#1#{} for each',
            'at end of round',
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 18 },
    rarity = 2,
	cost = 7,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Druid", category = "magic" },
        extra = { money = 7 } --Variables: money = money per planet destroyed
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calc_dollar_bonus = function(self, card)
        local count = 0
        for k, v in ipairs(G.consumeables.cards) do
            if v.ability.set == 'Planet' then
                count = count + 1
                v:start_dissolve({G.C.RED}, nil)
            end
        end
        return card.ability.extra.money * count
    end
}

SMODS.Joker { --Spirit of the Forest
    key = 'spirit_of_the_forest',
    name = 'Spirit of the Forest',
	loc_txt = {
        name = 'Spirit of the Forest',
        text = {
            'Earn money equal to the',
            'level of played {C:attention}poker hand{}',
            '{C:inactive}(Max of {C:money}$#1#{C:inactive}){}',
        }
    },
	atlas = 'Joker',
	pos = { x = 10, y = 18 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Druid", category = "magic" },
        extra = { max = 7 } --Variables: max = max money
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.max } }
    end,
    calculate = function(self, card, context)
        if context.before then
            local dollars = G.GAME.hands[context.scoring_name].level
            if dollars > card.ability.extra.max then
                dollars = card.ability.extra.max
            end
            return {
                dollars = dollars,
                colour = G.C.MONEY
            }
        end
    end
}

SMODS.Joker { --Druidic Reach
    key = 'druidic_reach',
    name = 'Druidic Reach',
    loc_txt = {
        name = 'Druidic Reach',
        text = {
            'Create a {C:planet}Planet{} card',
            'at end of round',
            '{C:inactive}(Must have room)',
        }
    },
    atlas = 'Joker',
	pos = { x = 11, y = 18 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Druid", category = "magic" },
    },

    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = function()
                    local planet = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'druidic_reach')
                    card:add_to_deck()
                    G.consumeables:emplace(planet)
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.SECONDARY_SET.Planet})
        end
    end
}

SMODS.Joker { --Heart of Vengeance
    key = 'heart_of_vengeance',
    name = 'Heart of Vengeance',
    loc_txt = {
        name = 'Heart of Vengeance',
        text = {
            '{C:red}+#1#{} Mult per {C:planet}Planet{}',
            'card used this run',
            '{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)'
        }
    },
    atlas = 'Joker',
	pos = { x = 12, y = 18 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Druid", category = "magic" },
        extra = { mult = 1 } --Variables: mult = +mult when using planet, current = current +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.planet or 0) } }
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.ability.set == 'Planet' and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_mult',vars={G.GAME.consumeable_usage_total.planet}}});
                    return true
                end
            }))
        elseif context.joker_main and G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.planet > 0 then
            return {
                mult = G.GAME.consumeable_usage_total.planet
            }
        end
    end
}

SMODS.Joker { --Druid of Wrath
    key = 'druid_of_wrath',
    name = 'Druid of Wrath',
    loc_txt = {
        name = 'Druid of Wrath',
        text = {
            '{X:mult,C:white}X#1#{} Mult times the number',
            'of times {C:attention}poker hand{} has',
            'been played this run'
        }
    },
    atlas = 'Joker',
	pos = { x = 13, y = 18 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Druid", category = "magic" },
        extra = { Xmult = 0.03 } --Variables: Xmult per time hand is played
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local temp_Xmult = 1 + card.ability.extra.Xmult * G.GAME.hands[context.scoring_name].played
            return {
                x_mult = temp_Xmult
            }
        end
    end
}

SMODS.Joker { --Poplust
    key = 'poplust',
    name = 'Poplust',
	loc_txt = {
        name = 'Poplust',
        text = {
            '{C:attention}Druids{} give {X:mult,C:white}X#1#{} Mult',
        }
    },
	atlas = 'Joker',
	pos = { x = 14, y = 18 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Druid", category = "magic" },
        extra = { Xmult = 1.5 } --Variables: Xmult = Xmult for each druid
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.other_joker and context.other_joker.ability.tower_info and context.other_joker.ability.tower_info.base == 'Druid' then
            G.E_MANAGER:add_event(Event({
                func = function()
                    context.other_joker:juice_up(0.5, 0.5)
                    return true
                end
            }))
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --Avatar of Wrath
    key = 'avatar_of_wrath',
    name = 'Avatar of Wrath',
	loc_txt = {
        name = 'Avatar of Wrath',
        text = {
            '{X:mult,C:white}X#1#{} Mult,',
            'loses {X:mult,C:white}X0.02{} Mult for every',
            '{C:attention}1%{} of chips scored this round',
        }
    },
	atlas = 'Joker',
	pos = { x = 15, y = 18 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Druid", category = "magic" },
        extra = { Xmult = 3, current = 3 } --Variables: Xmult = starting Xmult, current = current Xmult,
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current, card.ability.extra.loss } }
    end,
    update = function(self, card, dt)
        if G.GAME.blind and to_big(G.GAME.blind.chips) > to_big(0) then
            if G.GAME.chips/G.GAME.blind.chips > to_big(1) then
                card.ability.extra.current = 1
            else
                card.ability.extra.current = card.ability.extra.Xmult - 2 * G.GAME.chips/G.GAME.blind.chips
            end
        else
            card.ability.extra.current = card.ability.extra.Xmult
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.current,
            }
        end
    end
}
