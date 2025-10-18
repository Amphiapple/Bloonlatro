SMODS.Joker { --Beast Handler
    key = 'beast',
    name = 'Beast Handler',
	loc_txt = {
        name = 'Beast Handler',
        text = {
            '{C:chips}+#1#{} Chips if played',
            'hand contains',
            'a {C:attention}Mult Card{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 2 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    enhancement_gate = 'm_mult',
    config = {
        base = 'beast',
        extra = { chips = 90 } --Variables: chips = +chips
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            for k, v in ipairs(context.scoring_hand) do
                if v.ability.name == 'Mult' then
                    return {
                        chips = card.ability.extra.chips,
                    }
                end
            end
        end
    end
}

SMODS.Joker { --Horned Owl
    key = 'owl',
    name = 'Horned Owl',
    loc_txt = {
        name = 'Horned Owl',
        text = {
            'Create a random {C:tarot}Tarot{}',
            'card if {C:attention}scoring hand{}',
            'contains {C:attention}#1# Mult Cards{}',
            '{C:inactive}(Must have room){}'
        }
    },
    atlas = 'Joker',
	pos = { x = 3, y = 5 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    enhancement_gate = 'm_mult',
    config = {
        base = 'beast',
        extra = { number = 2 } --Variables: number = required bonus cards for planet
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
        return { vars = { card.ability.extra.number } }
    end,
    calculate = function(self, card, context)
        if context.before and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            local count = 0
            for k, v in ipairs(context.scoring_hand) do
                if v.ability.name == 'Mult' then
                    count = count + 1
                end
            end
            if count >= card.ability.extra.number then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, 'owl')
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

SMODS.Joker { --Velociraptor
    key = 'velo',
    name = 'Velociraptor',
	loc_txt = {
        name = 'Velociraptor',
        text = {
            '{C:attention}First{} card in scoring',
            'hand becomes {C:attention}Mult{}',
            '{C:attention}Mult{} cards give {C:mult}+#1#{} more Mult'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 8 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'beast',
        extra = { mult = 4 } --Variables: mult = +mult if mult card
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.scoring_hand[1].debuff and not context.blueprint then
            context.scoring_hand[1]:set_ability('m_mult', nil, true)
        elseif context.individual and context.cardarea == G.play and context.other_card.ability.name == 'Mult' then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --Giant Condor
    key = 'condor',
    name = 'Giant Condor',
	loc_txt = {
        name = 'Giant Condor',
        text = {
            '{C:green}#1# in #2#{} chance to',
            'gain {C:red}+#3#{} hand size this',
            'round when each played',
            '{C:attention}Mult{} card is scored',
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 11 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    enhancement_gate = 'm_mult',
    config = {
        base = 'beast',
        extra = { num = 1, denom = 2, hand_size = 1, current = 0 } --Variables: num/denom = probability fraction, hand_size = extra hand size, current = current increased hand size
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'condor')
        return { vars = { n, d, card.ability.extra.hand_size } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
			if context.other_card.ability.name == 'Mult' and SMODS.pseudorandom_probability(card, 'condor', card.ability.extra.num, card.ability.extra.denom, 'condor') then
                G.hand:change_size(card.ability.extra.hand_size)
                G.GAME.round_resets.temp_handsize = (G.GAME.round_resets.temp_handsize or 0) + card.ability.extra.hand_size
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.hand_size
                return {
                    message = localize({ type = "variable", key = "a_handsize", vars = {card.ability.extra.hand_size}}),
                    colour = G.C.FILTER,
                }
			end
		elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = 0
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker { --Megalodon
    key = 'meg',
    name = 'Megalodon',
	loc_txt = {
        name = 'Megalodon',
        text = {
            'This Joker gains {C:chips}+#1#{} Chips when',
            'each played {C:attention}Bonus Card{} is scored',
            'and {C:mult}+#2#{} Mult when each played',
            '{C:attention}Mult Card{} is scored',
            '{C:inactive}(Currently {C:chips}+#3#{C:inactive} Chips {C:mult}+#4#{C:inactive} Mult){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 14 },
    rarity = 3,
	cost = 9,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'beast',
        extra = { chips = 10, mult = 2, current_chips = 0, current_mult = 0 } --Variables: chips = +chips for each bonus card, mult = +mult for each mult card, current_chips/mult = current +chips/+mult
    },
    
    in_pool = function(self, args)
        for k, v in pairs(G.playing_cards) do
            if v.ability.name == 'Mult' or v.ability.name == 'Bonus' then
                return true
            end
        end
        return false
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
        info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
        return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.current_chips, card.ability.extra.current_mult } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            for k, v in ipairs(context.scoring_hand) do
                if v.ability.name == 'Bonus' then
                    card.ability.extra.current_chips = card.ability.extra.current_chips + card.ability.extra.chips
                elseif v.ability.name == 'Mult' then
                    card.ability.extra.current_mult = card.ability.extra.current_mult + card.ability.extra.mult
                end
            end
        elseif context.joker_main then
            return {
                chips = card.ability.extra.current_chips,
                mult = card.ability.extra.current_mult
            }
        end
    end
}
