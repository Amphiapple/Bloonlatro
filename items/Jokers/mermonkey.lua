SMODS.Joker { --Mermonkey
    key = 'merm',
    name = 'Mermonkey',
	loc_txt = {
        name = 'Mermonkey',
        text = {
            '{C:mult}+#1#{} Mult if played',
            'hand contains',
            'a {C:attention}Bonus Card{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 8, y = 1 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    enhancement_gate = 'm_bonus',
    config = {
        base = 'mermonkey',
        extra = { mult = 15 } --Variables: mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            for k, v in ipairs(context.scoring_hand) do
                if v.ability.name == 'Bonus' then
                    return {
                        mult = card.ability.extra.mult,
                    }
                end
            end
        end
    end
}

SMODS.Joker { --Echosense Network'
    key = 'network',
    name = 'Echosense Network',
    loc_txt = {
        name = 'Echosense Network',
        text = {
            'Create a random {C:planet}Planet{}',
            'card if {C:attention}scoring hand{}',
            'contains {C:attention}#1# Bonus Cards{}',
            '{C:inactive}(Must have room){}'
        }
    },
    atlas = 'Joker',
	pos = { x = 8, y = 4 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    enhancement_gate = 'm_bonus',
    config = {
        base = 'mermonkey',
        extra = { number = 2 } --Variables: required = required bonus cards for planet
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
        return { vars = { card.ability.extra.number } }
    end,
    calculate = function(self, card, context)
        if context.before and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            local count = 0
            for k, v in ipairs(context.scoring_hand) do
                if v.ability.name == 'Bonus' then
                    count = count + 1
                end
            end
            if count >= card.ability.extra.number then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        local card = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'network')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})
            end
        end
    end
}

SMODS.Joker { --Alluring Melody
    key = 'melody',
    name = 'Alluring Melody',
	loc_txt = {
        name = 'Alluring Melody',
        text = {
            '{C:enhanced}Enhanced{} cards become',
            '{C:attention}Bonus{} cards when scored',
            '{C:attention}Bonus{} cards give {C:chips}+#1#{} more Chips'
        }
    },
	atlas = 'Joker',
	pos = { x = 8, y = 7 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'mermonkey',
        extra = { chips = 30 } --Variables: chips = +chips if bonus card
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            for k, v in ipairs(context.scoring_hand) do
                if v.config.center ~= G.P_CENTERS.c_base and v.ability.name ~= 'Bonus' and not v.debuff then
                    v:set_ability('m_bonus', nil, true)
                end
            end
        elseif context.individual and context.cardarea == G.play and context.other_card.ability.name == 'Bonus' and not context.other_card.debuff then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
}

SMODS.Joker { --Arctic Knight'
    key = 'arknight',
    name = 'Arctic Knight',
	loc_txt = {
        name = 'Arctic Knight',
        text = {
            'Retrigger played',
            'cards adjacent to',
            '{C:attention}Bonus{} cards'
        }
    },
	atlas = 'Joker',
	pos = { x = 8, y = 10 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    enhancement_gate = 'm_bonus',
    config = {
        base = 'mermonkey',
        extra = { retrigger = 1 } --Variables: retrigger = retrigger amount
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
        return { vars = { card.ability.extra.retrigger } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            for i = 1, #context.scoring_hand do
                if context.other_card == context.scoring_hand[i] and
                ((i > 1 and context.scoring_hand[i-1].ability.name == 'Bonus') or
                (i < #context.scoring_hand and context.scoring_hand[i+1].ability.name == 'Bonus')) then
                    return {
                        message = localize('k_again_ex'),
                        repetitions = card.ability.extra.retrigger
                    }
                end
            end
        end
    end
}

SMODS.Joker { --Lord of the Abyss
    key = 'lota',
    name = 'Lord of the Abyss',
    loc_txt = {
        name = 'Lord of the Abyss',
        text = {
            '{C:mult}+#1#{} Mult if you have',
            'at least {C:attention}#2# Bonus{}',
            'cards in your full deck',
            '{C:inactive}(Currently {C:attention}#3#{C:inactive})'
        }
    },
    atlas = 'Joker',
	pos = { x = 8, y = 13 },
    rarity = 2,
	cost = 8,
    blueprint_compat = false,
    enhancement_gate = 'm_bonus',
    config = {
        base = 'mermonkey',
        extra = { mult = 50, limit = 8, number = 0 } --Variables: mult = +mult, limit = number of bonus required, number = number of bonus cards in deck
    },
    
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_bonus
        return { vars = { card.ability.extra.mult, card.ability.extra.limit, card.ability.extra.number } }
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            local count = 0
            for k, v in pairs(G.playing_cards) do
                if v.ability.name == 'Bonus' then
                    count = count + 1
                end
            end
            card.ability.extra.number = count
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.number >= card.ability.extra.limit then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}
