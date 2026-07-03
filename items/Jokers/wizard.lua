SMODS.Joker { --Wizard Monkey
    key = 'wizard_monkey',
    name = 'Wizard Monkey',
	atlas = 'Joker',
	pos = { x = 0, y = 14 },
    rarity = 1,
	cost = 3,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Wizard Monkey", category = "magic" },
    },

    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.scoring_hand[1].debuff then
            local enhancement_pool = G.P_CENTER_POOLS['Enhanced']
            local enhancement = pseudorandom_element(enhancement_pool, 'wiz')
            context.scoring_hand[1]:set_ability(enhancement, nil, true)
            G.E_MANAGER:add_event(Event({
                func = function()
                    context.scoring_hand[1]:juice_up()
                    return true
                end
            })) 
            return {
                message = 'Magic!',
                colour = G.C.MONEY
            }
        end
    end
}

SMODS.Joker { --Guided Magic
    key = 'guided_magic',
    name = 'Guided Magic',
	atlas = 'Joker',
	pos = { x = 1, y = 14 },
    rarity = 1,
	cost = 3,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Wizard Monkey", category = "magic" },
        extra = { enhancement = G.P_CENTERS.m_bonus } --Variables: enhancement = enhancement to apply
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = card.ability.extra.enhancement
        local function process_var(e)
            return e.effect or e.name
        end
        return {
            vars = {
                process_var(card.ability.extra.enhancement)
            }
        }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.scoring_hand[1].debuff then
            context.scoring_hand[1]:set_ability(card.ability.extra.enhancement, nil, true)
            G.E_MANAGER:add_event(Event({
                func = function()
                    context.scoring_hand[1]:juice_up()
                    return true
                end
            })) 
            return {
                message = 'Magic!',
                colour = G.C.MONEY
            }
        elseif context.after then
            local enhancement_pool = G.P_CENTER_POOLS['Enhanced']
            card.ability.extra.enhancement = pseudorandom_element(enhancement_pool, 'guided')
        end
    end
}

SMODS.Joker { --Arcane Blast
    key = 'arcane_blast',
    name = 'Arcane Blast',
	atlas = 'Joker',
	pos = { x = 2, y = 14 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Wizard Monkey", category = "magic" },
        extra = { chips = 30 } --Variables: chips = +chips for enhanced cards
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.config.center ~= G.P_CENTERS.c_base then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
}

SMODS.Joker { --Arcane Mastery
    key = 'arcane_mastery',
    name = 'Arcane Mastery',
	atlas = 'Joker',
	pos = { x = 3, y = 14 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Wizard Monkey", category = "magic" },
    },

    calculate = function(self, card, context)
        if context.setting_blind and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    local enhancements = { 'c_magician', 'c_empress', 'c_heirophant', 'c_lovers', 'c_chariot', 'c_justice', 'c_devil', 'c_tower' }
                    local tarots = get_current_pool('Tarot')
                    for k, v in ipairs(enhancements) do
                        local in_pool = false
                        for i, j in ipairs(tarots) do
                            if v == j then
                                in_pool = true
                            end
                        end
                        if not in_pool then
                            enhancements[k] = nil
                        end
                    end
                    if next(enhancements) == nil then
                        enhancements[1] = 'c_strength'
                    end
                    local tarot = pseudorandom_element(enhancements, 'amast')
                    local card = create_card(tarot, G.consumeables, nil, nil, nil, nil, tarot, 'amast')
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

SMODS.Joker { --Arcane Spike
    key = 'arcane_spike',
    name = 'Arcane Spike',
	atlas = 'Joker',
	pos = { x = 4, y = 14 },
    rarity = 2,
	cost = 7,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Wizard Monkey", category = "magic" },
        extra = { retrigger = 1, enhancements = {} } --Variables: retrigger = retrigger amount
    },

    calculate = function(self, card, context)
        if context.repetition and (context.cardarea == G.play or context.cardarea == G.hand) and not context.other_card.debuff then
            local e = context.other_card.config.center.name
            local new_enhancement = e ~= 'Default Base'
            for k, v in pairs(card.ability.extra.enhancements) do
                if e == k then
                    new_enhancement = false
                end
            end
            if new_enhancement then
                card.ability.extra.enhancements[e] = true
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.retrigger
                }
            end
        elseif context.after and not context.blueprint then
            card.ability.extra.enhancements = {}
        elseif context.starting_shop and not context.blueprint then
            card.ability.extra.enhancements = {}
        end
    end
}

SMODS.Joker { --Archmage
    key = 'archmage',
    name = 'Archmage',
	atlas = 'Joker',
	pos = { x = 5, y = 14 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Wizard Monkey", category = "magic" },
        extra = { retrigger = 1 } --Variables: retrigger = retrigger amount
    },

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card.config.center ~= G.P_CENTERS.c_base and not context.other_card.debuff then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger
            }
        end
    end
}

SMODS.Joker { --Fireball
    key = 'fireball',
    name = 'Fireball',
	atlas = 'Joker',
	pos = { x = 6, y = 14 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    enhancement_gate = 'm_stone',
    config = {
        tower_info = { base = "Wizard Monkey", category = "magic" },
        extra = { mult = 12 } --Variables: mult = +mult for stone cards
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.ability.name == 'Stone Card' then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --Wall of Fire
    key = 'wall_of_fire',
    name = 'Wall of Fire',
    atlas = 'Joker',
	pos = { x = 7, y = 14 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Wizard Monkey", category = "magic" },
        extra = { num = 1, denom = 3 } --Variables: num/denom = probability fraction
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'wof')
        return { vars = { n, d } }
    end,
    calculate = function(self, card, context)
        if context.before then
            for k, v in pairs(context.full_hand) do
                if not SMODS.in_scoring(v, context.scoring_hand) then
                    if SMODS.pseudorandom_probability(card, 'wof', card.ability.extra.num, card.ability.extra.denom, 'wof') then
                        v:set_ability('m_stone', nil, true)
                        return {
                            message = 'Stone!'
                        }
                    else
                        return nil
                    end
                end
            end
        end
    end
}

SMODS.Joker { --Dragon's Breath
    key = 'dragons_breath',
    name = "Dragon's Breath",
    loc_txt = {
        name = "Dragon's Breath",
        text = {
            'This {C:attention}Joker{} gains',
            '{X:mult,C:white}X#1#{} Mult when each',
            'played {C:attention}Stone Card{} is scored',
            '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)'
        }
    },
    atlas = 'Joker',
	pos = { x = 8, y = 14 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    perishable_compat = false,
    enhancement_gate = 'm_stone',
    config = {
        tower_info = { base = "Wizard Monkey", category = "magic" },
        extra = { Xmult = 0.1, current = 1 } --Variables: Xmult = Xmult gain for each stone, current = current Xmult
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
        return { vars = { card.ability.extra.Xmult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.ability.name == 'Stone Card' and not context.end_of_round and not context.blueprint then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current,
            }
        end
    end
}

SMODS.Joker { --Summon Phoenix
    key = 'summon_phoenix',
    name = "Summon Phoenix",
    atlas = 'Joker',
	pos = { x = 9, y = 14 },
    rarity = 2,
	cost = 7,
    blueprint_compat = false,
    enhancement_gate = 'm_stone',
    config = {
        tower_info = { base = "Wizard Monkey", category = "magic" },
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_meteor
    end,
    calculate = function(self, card, context)
        if context.before then
            for k, v in pairs(context.full_hand) do
                if v.ability.name == 'Stone Card' then
                    v:set_ability('m_bloons_meteor', nil, true)
                end
            end
        end
    end
}

SMODS.Joker { --Wizard Lord Phoenix
    key = 'wizard_lord_phoenix',
    name = 'Wizard Lord Phoenix',
	atlas = 'Joker',
	pos = { x = 10, y = 14 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Wizard Monkey", category = "magic" },
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_bloons_volcano
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.beat_boss and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and not context.individual and not context.repetition then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    local card = create_card('c_bloons_volcano', G.consumeables, nil, nil, nil, nil, 'c_bloons_volcano', 'wizard_lord_phoenix')
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                    G.GAME.consumeable_buffer = 0
                    return true
                end)
            }))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
        end
    end
}

SMODS.Joker { --Intense Magic
    key = 'intense_magic',
    name = 'Intense Magic',
	atlas = 'Joker',
	pos = { x = 11, y = 14 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Wizard Monkey", category = "magic" },
        extra = { mult = 6 } --Variables: mult = +mult for enhanced cards
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.config.center ~= G.P_CENTERS.c_base then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --Monkey Sense
    key = 'monkey_sense',
    name = 'Monkey Sense',
    atlas = 'Joker',
	pos = { x = 12, y = 14 },
    rarity = 1,
	cost = 4,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Wizard Monkey", category = "magic" },
    },

    update = function(self, card, dt)
        if G.playing_cards then
            for k, v in pairs(G.playing_cards) do
                if v.debuff then
                    v.debuff = false
                end
            end
        end
    end
}

SMODS.Joker { --Shimmer
    key = 'shimmer',
    name = 'Shimmer',
	atlas = 'Joker',
	pos = { x = 13, y = 14 },
    rarity = 2,
	cost = 5,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Wizard Monkey", category = "magic" },
        extra = { num = 1, denom = 2 } --Variables: num/denom = probability fraction
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
        info_queue[#info_queue + 1] = G.P_CENTERS.c_fool
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'shimmer')
        return { vars = { n, d } }
    end,
    calculate = function(self, card, context)
        if context.starting_shop and SMODS.pseudorandom_probability(card, 'shimmer', card.ability.extra.num, card.ability.extra.denom, 'shimmer')then
            local fool = create_card('c_fool', G.consumeables, nil, nil, nil, nil, 'c_fool', 'shimmer')
            fool:set_edition({negative = true}, true)
            fool.extra_cost = -card.base_cost
            fool.sell_cost = 0
            fool:add_to_deck()
            fool.ability.shimmer = true
            G.consumeables:emplace(fool)
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
        elseif context.ending_shop then
            for k, v in ipairs(G.consumeables.cards) do
                if v.ability.shimmer then
                    v.ability.shimmer = false
                    v:start_dissolve({G.C.RED}, nil)
                    break
                end
            end
        end
    end
}

SMODS.Joker { --Necromancer
    key = 'necromancer',
    name = 'Necromancer',
	atlas = 'Joker',
	pos = { x = 14, y = 14 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Wizard Monkey", category = "magic" },
    },

    calculate = function(self, card, context)
        if (context.cards_destroyed or context.remove_playing_cards) and #G.hand.cards >= 1 then
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            local front = copy_card(G.hand.cards[#G.hand.cards], nil, nil, G.playing_card)
            front:add_to_deck()
            G.deck.config.card_limit = G.deck.config.card_limit + 1
            table.insert(G.playing_cards, front)
            G.hand:emplace(front)
            front.states.visible = nil

            G.E_MANAGER:add_event(Event({
                func = function()
                    front:start_materialize()
                    return true
                end
            })) 
            return {
                message = localize('k_copied_ex'),
                colour = G.C.CHIPS,
                playing_cards_created = {true}
            }
        end
    end
}

SMODS.Joker { --Prince of Darkness
    key = 'prince_of_darkness',
    name = 'Prince of Darkness',
	atlas = 'Joker',
	pos = { x = 15, y = 14 },
    rarity = 3,
	cost = 7,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Wizard Monkey", category = "magic" },
    },

    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then my_pos = i; break end
            end
            if my_pos and G.jokers.cards[my_pos+1] and not SMODS.is_eternal(G.jokers.cards[my_pos+1], self) and not G.jokers.cards[my_pos+1].getting_sliced then
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1

                local sliced_card = G.jokers.cards[my_pos+1]
                sliced_card.getting_sliced = true

                G.E_MANAGER:add_event(Event(
                    {func = function()
                        card:juice_up(0.8, 0.8)
                        sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                        play_sound('tarot2', 0.96+math.random()*0.08)
                        return true
                    end
                }))
                delay(0.5)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local key = sliced_card.config.center_key
                        local card = create_card(key, G.jokers, nil, nil, nil, nil, key, 'pod')
                        card:add_to_deck()
                        G.jokers:emplace(card)
                        card:start_materialize()

                        G.GAME.joker_buffer = 0
                        return true
                    end
                }))
                return nil, true
            end
        end
    end
}
