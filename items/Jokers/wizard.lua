SMODS.Joker { --Wizard Monkey
    key = 'wiz',
    name = 'Wizard Monkey',
	loc_txt = {
        name = 'Wizard Monkey',
        text = {
            'Enhances {C:attention}first{} played card',
            'into a random {C:enhanced}Enhancement{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 14 },
    rarity = 1,
	cost = 3,
    blueprint_compat = false,
    config = {
        base = 'wizard',
    },

    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.scoring_hand[1].debuff then
            local enhancement_pool = G.P_CENTER_POOLS['Enhanced']
            if G.GAME.modifiers.abracadabmonkey then
                local i = 1
                while i <= #enhancement_pool do
                    local enhancement = enhancement_pool[i]
                    if enhancement.key == 'm_bloons_frozen' or enhancement.key == 'm_bloons_glued' or enhancement.key == 'm_bloons_stunned' then
                        table.remove(enhancement_pool, i)
                    else
                        i = i + 1
                    end
                end
            end
            local enhancement = pseudorandom_element(enhancement_pool, pseudoseed('wiz'))
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
    key = 'guided',
    name = 'Guided Magic',
	loc_txt = {
        name = 'Guided Magic',
        text = {
            'Enhances {C:attention}first{} played card',
            'into a {C:attention}#1#{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 14 },
    rarity = 1,
	cost = 3,
    blueprint_compat = false,
    config = {
        base = 'wizard',
        extra = { enhancement = G.P_CENTERS.m_bonus } --Variables: enhancement = enhancement to apply
    },

    loc_vars = function(self, info_queue, card)
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
            if G.GAME.modifiers.abracadabmonkey then
                local i = 1
                while i <= #enhancement_pool do
                    local enhancement = enhancement_pool[i]
                    if enhancement.key == 'm_bloons_frozen' or enhancement.key == 'm_bloons_glued' or enhancement.key == 'm_bloons_stunned' then
                        table.remove(enhancement_pool, i)
                    else
                        i = i + 1
                    end
                end
            end
            card.ability.extra.enhancement = pseudorandom_element(enhancement_pool, pseudoseed('guided'))
        end
    end
}

SMODS.Joker { --Arcane Blast
    key = 'ablast',
    name = 'Arcane Blast',
	loc_txt = {
        name = 'Arcane Blast',
        text = {
            'Played enhanced cards give',
            '{C:chips}+#1#{} Chips when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 14 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'wizard',
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
    key = 'amast',
    name = 'Arcane Mastery',
	loc_txt = {
        name = 'Arcane Mastery',
        text = {
            'Create an enhancement {C:tarot}Tarot{}',
            'when {C:attention}Blind{} is selected',
            '{C:inactive}(Must have room){}',
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 14 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'wizard',
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
                    local tarot = pseudorandom_element(enhancements, pseudoseed('amast'))
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

--[[
SMODS.Joker { --Arcane Mastery
    key = 'amast',
    name = 'Arcane Mastery',
	loc_txt = {
        name = 'Arcane Mastery',
        text = {
            'If {C:attention}first discard{} of round',
            'contains only {C:attention}1{} card,',
            'destroy first {C:attention}Consumable{} to',
            'add a {C:attention}Purple Seal{} to it',
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 14 },
    rarity = 2,
	cost = 6,
    blueprint_compat = false,
    config = {
        base = 'wizard',
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS.Purple
    end,
    calculate = function(self, card, context)
        if context.discard and G.GAME.current_round.discards_used == 0 and
                #context.full_hand == 1 and not context.full_hand[1].debuff and
                G.consumeables.cards[1] and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    G.consumeables.cards[1]:start_dissolve({G.C.RED}, nil)
                    G.consumeables.cards[1]:remove_from_deck()
                    context.full_hand[1]:set_seal('Purple', nil, true)
                    return true
                end
            }))
            delay(0.5)
        end
    end
}
]]

SMODS.Joker { --Arcane Spike
    key = 'aspike',
    name = 'Arcane Spike',
	loc_txt = {
        name = 'Arcane Spike',
        text = {
            'Retrigger the',
            'first card with each',
            'new {C:enhanced}Enhancement{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 14 },
    rarity = 2,
	cost = 7,
    blueprint_compat = false,
    config = {
        base = 'wizard',
        extra = { retrigger = 1, enhancements = {} } --Variables: retrigger = retrigger amount
    },

    calculate = function(self, card, context)
        if context.repetition and (context.cardarea == G.play or context.cardarea == G.hand) and context.other_card.config.center ~= G.P_CENTERS.c_base and not context.other_card.debuff then
            local new_enhancement = true
            local e = context.other_card.config.center
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
    key = 'arch',
    name = 'Archmage',
	loc_txt = {
        name = 'Archmage',
        text = {
            'Retrigger all played',
            'enhanced cards',
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 14 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        base = 'wizard',
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
	loc_txt = {
        name = 'Fireball',
        text = {
            'Played {C:attention}Stone{} cards give',
            '{C:mult}+#1#{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 6, y = 14 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    enhancement_gate = 'm_stone',
    config = {
        base = 'wizard',
        extra = { mult = 10 } --Variables: mult = +mult for stone cards
    },

    loc_vars = function(self, info_queue, card)
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
    key = 'wof',
    name = 'Wall of Fire',
    loc_txt = {
        name = 'Wall of Fire',
        text = {
            '{C:green}#1# in #2#{} chance to',
            'enhance first unscoring',
            'card into a {C:attention}Stone{} card'
        }
    },
    atlas = 'Joker',
	pos = { x = 7, y = 14 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'wizard',
        extra = { num = 1, denom = 4 } --Variables: num/denom = probability fraction
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'wof')
        return { vars = { n, d } }
    end,
    calculate = function(self, card, context)
        if context.before then
            for k, v in pairs(context.full_hand) do
                if not SMODS.in_scoring(v, context.scoring_hand) and SMODS.pseudorandom_probability(card, 'wof', card.ability.extra.num, card.ability.extra.denom, 'wof') then
                    v:set_ability('m_stone', nil, true)
                    break
                end
            end
        end
    end
}

SMODS.Joker { --Dragon's Breath
    key = 'dbreath',
    name = "Dragon's Breath",
    loc_txt = {
        name = "Dragon's Breath",
        text = {
            'This Joker gains',
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
    enhancement_gate = 'm_stone',
    config = {
        base = 'wizard',
        extra = { Xmult = 0.1, current = 1 } --Variables: Xmult = Xmult gain for each stone, current = current Xmult
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
        return { vars = { card.ability.extra.Xmult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.other_card.debuff and not context.end_of_round and not context.blueprint then
            if context.other_card.ability.name == 'Stone Card' then
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult
            end
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current,
            }
        end
    end
}

SMODS.Joker { --Summon Phoenix
    key = 'phoenix',
    name = "Summon Phoenix",
    loc_txt = {
        name = "Summon Phoenix",
        text = {
            'Enhance played {C:attention}Stone{} cards',
            'into {C:attention}Meteor{} Cards',
        }
    },
    atlas = 'Joker',
	pos = { x = 9, y = 14 },
    rarity = 2,
	cost = 7,
    blueprint_compat = false,
    enhancement_gate = 'm_stone',
    config = {
        base = 'wizard',
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
    key = 'wlp',
    name = 'Wizard Lord Phoenix',
	loc_txt = {
        name = 'Wizard Lord Phoenix',
        text = {
            'After defeating each {C:attention}Boss Blind{},',
            'create a {C:spectral}Volcano{} card',
            '{C:inactive}(Must have room){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 10, y = 14 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        base = 'wizard',
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
                    local card = create_card('c_bloons_volcano', G.consumeables, nil, nil, nil, nil, 'c_bloons_volcano', 'wlp')
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
    key = 'intense',
    name = 'Intense Magic',
	loc_txt = {
        name = 'Intense Magic',
        text = {
            'Played enhanced cards give',
            '{C:mult}+#1#{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 11, y = 14 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'wizard',
        extra = { mult = 5 } --Variables: mult = +mult for enhanced cards
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
    key = 'sense',
    name = 'Monkey Sense',
    loc_txt = {
        name = 'Monkey Sense',
        text = {
            'Playing cards',
            'cannot be {C:attention}debuffed{}'
        }
    },
    atlas = 'Joker',
	pos = { x = 12, y = 14 },
    rarity = 1,
	cost = 4,
    blueprint_compat = false,
    config = {
        base = 'wizard',
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
	loc_txt = {
        name = 'Shimmer',
        text = {
            'Create a free {C:dark_edition}Negative{}',
            '{C:attention}Fool{} at start of shop',
            'Destroy it at end of shop'
        }
    },
	atlas = 'Joker',
	pos = { x = 13, y = 14 },
    rarity = 2,
	cost = 5,
    blueprint_compat = false,
    config = {
        base = 'wizard',
        extra = { fool = nil } --Variables: fool = temporary fool
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
        info_queue[#info_queue + 1] = G.P_CENTERS.c_fool
    end,
    calculate = function(self, card, context)
        if context.starting_shop then
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    card.ability.extra.fool = create_card('c_fool', G.consumeables, nil, nil, nil, nil, 'c_fool', 'shimmer')
                    card.ability.extra.fool:set_edition({negative = true}, true)
                    card.ability.extra.fool.extra_cost = -card.base_cost
                    card.ability.extra.fool.sell_cost = 0
                    card.ability.extra.fool:add_to_deck()
                    G.consumeables:emplace(card.ability.extra.fool)
                    return true
                end)
            }))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
        elseif context.ending_shop and card.ability.extra.fool then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    card.ability.extra.fool:start_dissolve({G.C.RED}, nil)
                    card.ability.extra.fool:remove_from_deck()
                    return true
                end
            }))
        end
    end
}

SMODS.Joker { --Necromancer
    key = 'necro',
    name = 'Necromancer',
	loc_txt = {
        name = 'Necromancer',
        text = {
            'Whenever cards are',
            'destroyed, create a ',
            'copy of the {C:attention}last{}',
            'card held in hand'
        }
    },
	atlas = 'Joker',
	pos = { x = 14, y = 14 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'wizard',
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
    key = 'pod',
    name = 'Prince of Darkness',
	loc_txt = {
        name = 'Prince of Darkness',
        text = {
            'When {C:attention}Blind{} is selected,',
            'destroy {C:attention}Joker{} to the',
            'right and recreate it'
        }
    },
	atlas = 'Joker',
	pos = { x = 15, y = 14 },
    rarity = 3,
	cost = 7,
    blueprint_compat = false,
    config = {
        base = 'wizard',
    },

    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then my_pos = i; break end
            end
            if my_pos and G.jokers.cards[my_pos+1] and not SMODS.is_eternal(G.jokers.cards[my_pos+1], self) and not G.jokers.cards[my_pos+1].getting_sliced then
                local sliced_card = G.jokers.cards[my_pos+1]
                sliced_card.getting_sliced = true
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                G.E_MANAGER:add_event(Event(
                    {func = function()
                        G.GAME.joker_buffer = 0
                        card:juice_up(0.8, 0.8)
                        sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                        play_sound('slice1', 0.96+math.random()*0.08)
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
                        return true
                    end
                }))
                return nil, true
            end
        end
    end
}
