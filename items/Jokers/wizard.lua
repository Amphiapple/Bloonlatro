SMODS.Joker { --Wizard Monkey
    key = 'wiz',
    name = 'Wizard Monkey',
	loc_txt = {
        name = 'Wizard Monkey',
        text = {
            'Add a random ',
            '{C:enhanced}Enhancement{} to {C:attention}first{} played',
            'card when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 1 },
    rarity = 1,
	cost = 4,
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

SMODS.Joker { --Wall of Fire
    key = 'wof',
    name = 'Wall of Fire',
    loc_txt = {
        name = 'Wall of Fire',
        text = {
            'Playing cards',
            'cannot be debuffed'
        }
    },
    atlas = 'Joker',
	pos = { x = 3, y = 4 },
    rarity = 1,
	cost = 5,
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
	pos = { x = 3, y = 7 },
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
	pos = { x = 3, y = 10 },
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
	pos = { x = 3, y = 13 },
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
