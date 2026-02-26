SMODS.Joker { --Beast Handler
    key = 'beast_handler',
    name = 'Beast Handler',
	loc_txt = {
        name = 'Beast Handler',
        text = {
            '{C:chips}+#1#{} Chips',
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 24 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        base = 'beast',
        extra = { chips = 40 } --Variables: chips = +chips
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
            }
        end
    end
}

SMODS.Joker { --Piranha
    key = 'piranha',
    name = 'Piranha',
	loc_txt = {
        name = 'Piranha',
        text = {
            '{C:mult}+#1#{} Mult if played',
            'hand contains a',
            'scoring {C:attention}Bonus Card{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 24 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    enhancement_gate = 'm_bonus',
    config = {
        base = 'beast',
        extra = { mult = 16 } --Variables: mult = +mult
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

SMODS.Joker { --Barracuda
    key = 'barracuda',
    name = 'Barracuda',
	loc_txt = {
        name = 'Barracuda',
        text = {
            '{C:attention}Bonus Cards{} give',
            '{C:mult}+#1#{} Mult when scored',
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 24 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    enhancement_gate = 'm_bonus',
    config = {
        base = 'beast',
        extra = { mult = 8 } --Variables: mult = +mult per bonus card
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.ability.name == 'Bonus' then
            return {
                mult = card.ability.extra.mult,
            }
        end
    end
}

SMODS.Joker { --Great White
    key = 'great_white',
    name = 'Great White',
	loc_txt = {
        name = 'Great White',
        text = {
            'Retrigger played',
            'cards adjacent to',
            '{C:attention}Bonus Card{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 24 },
    rarity = 2,
	cost = 6,
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
            for k, v in ipairs(context.scoring_hand) do
                if context.other_card == context.scoring_hand[k] and
                ((k > 1 and context.scoring_hand[i-1].ability.name == 'Bonus') or
                (k < #context.scoring_hand and context.scoring_hand[k+1].ability.name == 'Bonus')) then
                    return {
                        message = localize('k_again_ex'),
                        repetitions = card.ability.extra.retrigger
                    }
                end
            end
        end
    end
}

SMODS.Joker { --Orca
    key = 'orca',
    name = 'Orca',
	loc_txt = {
        name = 'Orca',
        text = {
            '{X:mult,C:white}X#1#{} Mult if you have',
            'at least {C:attention}#2# Bonus{}',
            '{C:attention}Cards{} in your full deck',
            '{C:inactive}(Currently {C:attention}#3#{C:inactive})'
        }
    },
    atlas = 'Joker',
	pos = { x = 4, y = 24 },
    rarity = 2,
	cost = 8,
    blueprint_compat = true,
    enhancement_gate = 'm_bonus',
    config = {
        base = 'mermonkey',
        extra = { Xmult = 3, limit = 7, number = 0 } --Variables: mult = +mult, limit = number of bonus required, number = number of bonus cards in deck
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_bonus
        return { vars = { card.ability.extra.Xmult, card.ability.extra.limit, card.ability.extra.number } }
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
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --Megalodon
    key = 'megalodon',
    name = 'Megalodon',
	loc_txt = {
        name = 'Megalodon',
        text = {
            '{C:attention}Bonus Cards{} give {X:mult,C:white}X#1#{}',
            'Mult when scored and',
            'have a {C:green}#2# in #3#{}',
            'chance to be destroyed',
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 24 },
    rarity = 3,
	cost = 9,
    blueprint_compat = true,
    enhancement_gate = 'm_bonus',
    config = {
        base = 'beast',
        extra = { Xmult = 2, num = 1, denom = 4 } --Variables: Xmult = Xmult, num/denom = probability fraction
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'meg')
        return { vars = { card.ability.extra.Xmult, n, d } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.ability.name == 'Bonus' then
            return {
                x_mult = card.ability.extra.Xmult
            }
        elseif context.destroying_card and not context.blueprint then
            if context.destroying_card.ability.name == 'Bonus' and not context.destroying_card.debuff and SMODS.pseudorandom_probability(card, 'meg', card.ability.extra.num, card.ability.extra.denom, 'meg') then
                return true
            end
            return nil
        end
    end
}

SMODS.Joker { --Microraptor
    key = 'microraptor',
    name = 'Microraptor',
	loc_txt = {
        name = 'Microraptor',
        text = {
            '{C:chips}+#1#{} Chips if played',
            'hand contains a',
            'scoring {C:attention}Mult Card{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 6, y = 24 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    enhancement_gate = 'm_mult',
    config = {
        base = 'beast',
        extra = { chips = 60 } --Variables: chips = +chips
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

SMODS.Joker { --Adasaurus
    key = 'adasaurus',
    name = 'Adasaurus',
	loc_txt = {
        name = 'Adasaurus',
        text = {
            '{C:attention}Mult Cards{} give',
            '{C:chips}+#1#{} Chips when scored',
        }
    },
	atlas = 'Joker',
	pos = { x = 7, y = 24 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    enhancement_gate = 'm_mult',
    config = {
        base = 'beast',
        extra = { chips = 30 } --Variables: chips = +chips per mult card
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.ability.name == 'Mult' then
            return {
                chips = card.ability.extra.chips,
            }
        end
    end
}

SMODS.Joker { --Velociraptor
    key = 'velociraptor',
    name = 'Velociraptor',
	loc_txt = {
        name = 'Velociraptor',
        text = {
            'Create the {C:planet}Planet{} card for',
            'played {C:attention}poker hand{} if it',
            'contains {C:attention}#1# Mult Cards{}',
            '{C:inactive}(Must have room){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 8, y = 24 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    enhancement_gate = 'm_mult',
    config = {
        base = 'beast',
        extra = { number = 2 } --Variables: number = required mult cards for planet
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
                        local planet = nil
                        for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                            if v.config.hand_type == context.scoring_name then
                                planet = v.key
                            end
                        end
                        local card = create_card('Planet', G.consumeables, nil, nil, nil, nil, planet, 'velo')
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

SMODS.Joker { --Tyrannosaurus Rex
    key = 'tyrannosaurus_rex',
    name = 'Tyrannosaurus Rex',
	loc_txt = {
        name = 'Tyrannosaurus Rex',
        text = {
            '{C:attention}Mult Cards{} permanently',
            'gain {C:mult}+#1#{} Mult when scored',
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 24 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    enhancement_gate = 'm_mult',
    config = {
        base = 'beast',
        extra = { mult = 4 } --Variables: mult = permanent +mult
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
        return { vars = { card.ability.extra.mult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.ability.name == 'Mult' then
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult or 0
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult + card.ability.extra.mult
            return {
                extra = {message = localize('k_upgrade_ex'), colour = G.C.MULT},
                colour = G.C.CMULT,
            }
        end
    end
}

SMODS.Joker { --Giganotosaurus
    key = 'giganotosaurus',
    name = 'Giganotosaurus',
	loc_txt = {
        name = 'Giganotosaurus',
        text = {
            '{C:attention}Mult Cards{} give',
            '{X:mult,C:white}X#1#{} Mult when scored',
            '{C:green}#2# in #3#{} chance to give',
            '{X:mult,C:white}X#4#{} Mult instead',
        }
    },
	atlas = 'Joker',
	pos = { x = 10, y = 24 },
    rarity = 3,
	cost = 9,
    blueprint_compat = true,
    enhancement_gate = 'm_mult',
    config = {
        base = 'beast',
        extra = { Xmult1 = 1.5, Xmult2 = 2, num = 1, denom = 4 } --Variables: Xmult1 = Xmult, Xmult2 = chance Xmult, num/denom = probability fraction
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'giga')
        return { vars = { card.ability.extra.Xmult1, n, d, card.ability.extra.Xmult2 } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.ability.name == 'Mult' and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'giga', card.ability.extra.num, card.ability.extra.denom, 'giga') then
                return {
                    x_mult = card.ability.extra.Xmult2
                }
            else
                return {
                    x_mult = card.ability.extra.Xmult1
                }
            end
        end
    end
}

SMODS.Joker { --Gyrfalcon
    key = 'gyrfalcon',
    name = 'Gyrfalcon',
    loc_txt = {
        name = 'Gyrfalcon',
        text = {
            '{C:chips}+#1#{} Chips and',
            '{C:mult}+#2#{} Mult if played',
            'hand contains a',
            'scoring {C:attention}Wild Card{}'
        }
    },
    atlas = 'Joker',
	pos = { x = 11, y = 24 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    enhancement_gate = 'm_wild',
    config = {
        base = 'beast',
        extra = {chips = 30, mult = 8 } --Variables: chips = +chips, mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            for k, v in ipairs(context.scoring_hand) do
                if v.ability.name == 'Wild Card' then
                    return {
                        chips = card.ability.extra.chips,
                        mult = card.ability.extra.mult
                    }
                end
            end
            
        end
    end
}

SMODS.Joker { --Horned Owl
    key = 'horned_owl',
    name = 'Horned Owl',
    loc_txt = {
        name = 'Horned Owl',
        text = {
            'Create a random {C:tarot}Tarot{} card',
            'if played hand contains',
            'a scoring {C:attention}Wild Card{}',
            '{C:inactive}(Must have room){}'
        }
    },
    atlas = 'Joker',
	pos = { x = 12, y = 24 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    enhancement_gate = 'm_mult',
    config = {
        base = 'beast',
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
    end,
    calculate = function(self, card, context)
        if context.before and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            local has_wild = false
            for k, v in ipairs(context.scoring_hand) do
                if v.ability.name == 'Wild Card' then
                    has_wild = true
                end
            end
            if has_wild then
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

SMODS.Joker { --Golden Eagle
    key = 'golden_eagle',
    name = 'Golden Eagle',
    loc_txt = {
        name = 'Golden Eagle',
        text = {
            '{C:attention}Wild Cards{}',
            'cannot be {C:attention}debuffed{}',
            'and retrigger',
            'when played',
        }
    },
    atlas = 'Joker',
	pos = { x = 13, y = 24 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    enhancement_gate = 'm_wild',
    config = {
        base = 'beast',
        extra = { retrigger = 1 } --Variables: retrigger = retrigger count
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
    end,
    update = function(self, card, dt)
        if G.playing_cards then
            for k, v in pairs(G.playing_cards) do
                if v.ability.name == 'Wild Card' and v.debuff then
                    v.debuff = false
                end
            end
        end
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card.ability.name == 'Wild Card' then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger
            }
        end
    end
}

SMODS.Joker { --Giant Condor
    key = 'giant_condor',
    name = 'Giant Condor',
	loc_txt = {
        name = 'Giant Condor',
        text = {
            '{C:green}#1# in #2#{} chance to',
            'gain {C:red}+#3#{} hand size this',
            'round when each played',
            '{C:attention}Wild Card{} is scored',
        }
    },
	atlas = 'Joker',
	pos = { x = 14, y = 24 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    enhancement_gate = 'm_wild',
    config = {
        base = 'beast',
        extra = { num = 1, denom = 2, hand_size = 1 } --Variables: num/denom = probability fraction, hand_size = extra hand size
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'condor')
        return { vars = { n, d, card.ability.extra.hand_size } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
			if context.other_card.ability.name == 'Wild Card' and SMODS.pseudorandom_probability(card, 'condor', card.ability.extra.num, card.ability.extra.denom, 'condor') then
                G.hand:change_size(card.ability.extra.hand_size)
                G.GAME.round_resets.temp_handsize = (G.GAME.round_resets.temp_handsize or 0) + card.ability.extra.hand_size
                return {
                    message = localize({ type = "variable", key = "a_handsize", vars = {card.ability.extra.hand_size}}),
                    colour = G.C.FILTER,
                }
			end
		elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker { --Pouākai
    key = 'pouakai',
    name = 'Pouākai',
	loc_txt = {
        name = 'Pouākai',
        text = {
            '{X:mult,C:white}X#1#{} Mult for each',
            'hand size you have',
            '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)'
        }
    },
	atlas = 'Joker',
	pos = { x = 15, y = 24 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        base = 'beast',
        extra = { Xmult = 0.2, current = 1 } --Variables: Xmult = Xmult per handsize, current = current handsize
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.current } }
    end,

    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            card.ability.extra.current = 1 + G.hand.config.card_limit * card.ability.extra.Xmult
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.current
            }
        end
    end
}

