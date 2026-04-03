SMODS.Joker { --Mermonkey
    key = 'mermonkey',
    name = 'Mermonkey',
	loc_txt = {
        name = 'Mermonkey',
        text = {
            '{C:mult}+#1#{} Mult for',
            'each {C:attention}Joker{} card',
            '{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)',
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 20 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Mermonkey", category = "magic" },
        extra = { mult = 2, current = 0 } --Variables: mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.current } }
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            card.ability.extra.current = card.ability.extra.mult * #G.jokers.cards
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Trident Efficiency
    key = 'trident_efficiency',
    name = 'Trident Efficiency',
	loc_txt = {
        name = 'Trident Efficiency',
        text = {
            '{C:mult}+#1#{} Mult for',
            'each {C:attention}Joker{} card',
            '{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)',
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 20 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Mermonkey", category = "magic" },
        extra = { mult = 3, current = 0 } --Variables: mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.current } }
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            card.ability.extra.current = card.ability.extra.mult * #G.jokers.cards
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Trident Swiftness
    key = 'trident_swiftness',
    name = 'Trident Swiftness',
	loc_txt = {
        name = 'Trident Swiftness',
        text = {
            '{C:mult}+#1#{} Mult for each',
            'common {C:attention}Joker{} card',
            '{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)',
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 20 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Mermonkey", category = "magic" },
        extra = { mult = 5, current = 0 } --Variables: mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.current } }
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            local count = 0
            for k, v in ipairs(G.jokers.cards) do
                if v:is_rarity('Common') then
                    count = count + 1
                end
            end
            card.ability.extra.current = card.ability.extra.mult * count
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Abyss Dweller
    key = 'abyss_dweller',
    name = 'Abyss Dweller',
    loc_txt = {
        name = 'Abyss Dweller',
        text = {
            '{C:attention}Adjacent{} Jokers',
            'give {C:mult}+#1#{} Mult',
        }
    },
    atlas = 'Joker',
	pos = { x = 3, y = 20 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Mermonkey", category = "magic" },
        extra = { mult = 9 } --Variables: mult = +mult per adjacent joker
    },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.other_joker then
            local left_joker = nil
            local right_joker = nil
            for k, v in ipairs(G.jokers.cards) do
                if v == card then
                    if k > 1 then
                        left_joker = G.jokers.cards[k - 1]
                    end
                    if k < #G.jokers.cards then
                        right_joker = G.jokers.cards[k + 1]
                    end
                end
            end
            if left_joker and context.other_joker == left_joker or right_joker and context.other_joker == right_joker then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    end
}

SMODS.Joker { --Abyssal Warrior
    key = 'abyssal_warrior',
    name = 'Abyss Dweller',
    loc_txt = {
        name = 'Abyss Dweller',
        text = {
            '{X:mult,C:white}X#1#{} Mult',
            '{C:attention}Adjacent{} Jokers',
            'give {X:mult,C:white}X#1#{} Mult',
        }
    },
    atlas = 'Joker',
	pos = { x = 4, y = 20 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Mermonkey", category = "magic" },
        extra = { Xmult = 1.2 } --Variables: Xmult = Xmult and per adjacent joker
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.Xmult
            }
        elseif context.other_joker then
            local left_joker = nil
            local right_joker = nil
            for k, v in ipairs(G.jokers.cards) do
                if v == card then
                    if k > 1 then
                        left_joker = G.jokers.cards[k - 1]
                    end
                    if k < #G.jokers.cards then
                        right_joker = G.jokers.cards[k + 1]
                    end
                end
            end
            if left_joker and context.other_joker == left_joker or right_joker and context.other_joker == right_joker then
                return {
                    x_mult = card.ability.extra.Xmult
                }
            end
        end
    end
}

SMODS.Joker { --Lord of the Abyss
    key = 'lord_of_the_abyss',
    name = 'Lord of the Abyss',
    loc_txt = {
        name = 'Lord of the Abyss',
        text = {
            '{X:mult,C:white}X#1#{} Mult',
            '{C:attention}Adjacent{} Jokers',
            'give {X:mult,C:white}X#1#{} Mult',
            'when scored',
        }
    },
    atlas = 'Joker',
	pos = { x = 5, y = 20 },
    rarity = 3,
	cost = 7,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Mermonkey", category = "magic" },
        extra = { Xmult = 1.2 } --Variables: Xmult = Xmult and per adjacent joker
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.Xmult
            }
        elseif context.post_trigger then
            local left_joker = nil
            local right_joker = nil
            for k, v in ipairs(G.jokers.cards) do
                if v == card then
                    if k > 1 then
                        left_joker = G.jokers.cards[k - 1]
                    end
                    if k < #G.jokers.cards then
                        right_joker = G.jokers.cards[k + 1]
                    end
                end
            end
            local return_list = {
                'chips', 'h_chips', 's_chips', 't_chips', 'chips_mod',
                'mult', 'h_mult', 's_mult', 't_mult', 'mult_mod',
                'xmult', 'Xmult', 'x_mult', 'x_mult_mod', 'Xmult_mod',
            }
            if left_joker and context.other_card == left_joker or right_joker and context.other_card == right_joker then
                for k, v in ipairs(return_list) do
                    if context.other_ret.jokers[v] then
                        return {
                            x_mult = card.ability.extra.Xmult,
                        }
                    end
                end
            end
        end
    end
}

SMODS.Joker { --Sharper Prongs
    key = 'sharper_prongs',
    name = 'Sharper Prongs',
	loc_txt = {
        name = 'Sharper Prongs',
        text = {
            '{C:chips}+#1#{} Chips for',
            'each {C:attention}Joker{} card',
            '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)'
        }
    },
	atlas = 'Joker',
	pos = { x = 6, y = 20 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Mermonkey", category = "magic" },
        extra = { chips = 15, current = 0 } --Variables: mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.current } }
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            card.ability.extra.current = card.ability.extra.chips * #G.jokers.cards
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main then
           return {
                chips = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Tidal Chill
    key = 'tidal_chill',
    name = 'Tidal Chill',
	loc_txt = {
        name = 'Tidal Chill',
        text = {
            '{C:attention}Freeze{} a random',
            'card held in hand',
            'per hand played',
        }
    },
	atlas = 'Joker',
	pos = { x = 7, y = 20 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Mermonkey", category = "magic" },
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
    end,
    calculate = function(self, card, context)
        if context.before then
            local valid_cards = {}
            for k, v in ipairs(G.hand.cards) do
                if v.ability.effect ~= 'Frozen_card' and not v.debuff then
                    valid_cards[#valid_cards+1] = v
                end
            end
            if next(valid_cards) then
                local frozen_card = pseudorandom_element(valid_cards, 'tidal_chill')
                frozen_card:set_ability('m_bloons_frozen', nil, true)
            end
        end
    end
}

SMODS.Joker { --Riptide Champion
    key = 'riptide_champion',
    name = 'Riptide Champion',
	loc_txt = {
        name = 'Riptide Champion',
        text = {
            '{C:attention}Freeze{} a random',
            'card and ones adjacent',
            'to it held in hand',
            'per hand played',
        }
    },
	atlas = 'Joker',
	pos = { x = 8, y = 20 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Mermonkey", category = "magic" },
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
    end,
    calculate = function(self, card, context)
        if context.before then
            local valid_cards = {}
            for k, v in ipairs(G.hand.cards) do
                if v.ability.effect ~= 'Frozen_card' and not v.debuff then
                    valid_cards[#valid_cards+1] = v
                end
            end
            if next(valid_cards) then
                local frozen_card = pseudorandom_element(valid_cards, 'riptide_champion')
                local left_card = nil
                local right_card = nil
                for k, v in ipairs(G.hand.cards) do
                    if v == frozen_card then
                        if k > 1 then
                            left_card = G.hand.cards[k - 1]
                        end
                        if k < #G.hand.cards then
                            right_card = G.hand.cards[k + 1]
                        end
                    end
                end
                frozen_card:set_ability('m_bloons_frozen', nil, true)
                if left_card and not left_card.debuff then
                    left_card:set_ability('m_bloons_frozen', nil, true)
                end
                if right_card and not right_card.debuff then
                    right_card:set_ability('m_bloons_frozen', nil, true)
                end
            end
        end
    end
}

SMODS.Joker { --Arctic Knight
    key = 'arctic_knight',
    name = 'Arctic Knight',
	loc_txt = {
        name = 'Arctic Knight',
        text = {
            '{C:green}#1# in #2#{} chance to',
            '{C:attention}Freeze{} each card',
            'played or held in hand',
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 20 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Mermonkey", category = "magic" },
        extra = { num = 1, denom = 2 } --Variables: num/denom = probability fraction
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'arctic_knight')
        return { vars = { n, d } }
    end,
    calculate = function(self, card, context)
        if context.before then
            for k, v in ipairs(context.scoring_hand) do
                if SMODS.pseudorandom_probability(card, 'arctic_knight', card.ability.extra.num, card.ability.extra.denom, 'arctic_knight') and not v.debuff then
                    v:set_ability('m_bloons_frozen', nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:juice_up()
                            return true
                        end
                    }))
                end
            end
            for k, v in ipairs(G.hand.cards) do
                if SMODS.pseudorandom_probability(card, 'arctic_knight', card.ability.extra.num, card.ability.extra.denom, 'arctic_knight') and not v.debuff then
                    v:set_ability('m_bloons_frozen', nil, true)
                end
            end
        end
    end
}

SMODS.Joker { --Popseidon
    key = 'popseidon',
    name = 'Popseidon',
	loc_txt = {
        name = 'Popseidon',
        text = {
            '{C:attention}Freeze{} all cards',
            'drawn in first hand',
            '{C:attention}Frozen Cards{} give',
            '{C:chips}+#1#{} more Chips',
        }
    },
	atlas = 'Joker',
	pos = { x = 10, y = 20 },
    rarity = 3,
	cost = 9,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Mermonkey", category = "magic" },
        extra = { chips = 40 } --Variables: chips = +chips per frozen card
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.hand_drawn and G.GAME.current_round.hands_played == 0 and G.GAME.current_round.discards_used == 0 and not context.blueprint then
            for k, v in pairs(G.hand.cards) do
                if not v.debuff then
                    v:set_ability('m_bloons_frozen', nil, true)
                    v:juice_up()
                end
            end
        elseif context.individual and context.cardarea == G.hand and context.other_card.ability.name == 'Frozen Card' and not context.end_of_round then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
}

SMODS.Joker { --Echosense Precision
    key = 'echosense_precision',
    name = 'Echosense Precision',
    loc_txt = {
        name = 'Echosense Precision',
        text = {
            'Every {C:attention}played card{}',
            'counts in scoring',
        }
    },
    atlas = 'Joker',
	pos = { x = 11, y = 20 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Mermonkey", category = "magic" },
    },
}

SMODS.Joker { --Echosense Network
    key = 'echosense_network',
    name = 'Echosense Network',
    loc_txt = {
        name = 'Echosense Network',
        text = {
            '{C:mult}+#1#{} Mult for',
            'each {C:attention}Mermonkey{}',
            '{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)',
        }
    },
    atlas = 'Joker',
	pos = { x = 12, y = 20 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Mermonkey", category = "magic" },
        extra = { mult = 10, current = 0 } --Variables: mult = +mult per mermonkey
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.current } }
    end,
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            local count = 0
            for k, v in ipairs(G.jokers.cards) do
                if v.ability.tower_info and v.ability.tower_info.base and v.ability.tower_info.base == "Mermonkey" then
                    count = count + 1
                end
            end
            card.ability.extra.current = card.ability.extra.mult * count
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Alluring Melody
    key = 'alluring_melody',
    name = 'Alluring Melody',
    loc_txt = {
        name = 'Alluring Melody',
        text = {
            "This Joker gains {C:mult}+#1#{} Mult",
            "per scoring {C:enhanced}Enhanced{} card played,",
            "removes card {C:enhanced}Enhancement",
            "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
        }
    },
    atlas = 'Joker',
	pos = { x = 13, y = 20 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        tower_info = { base = "Mermonkey", category = "magic" },
        extra = { mult = 3, current = 0 } --Variables: mult = +mult per enhanced card, current = current mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local enhanced = {}
            for k, v in ipairs(context.scoring_hand) do
                if v.config.center ~= G.P_CENTERS.c_base and not v.debuff and not v.vampired then
                    enhanced[#enhanced+1] = v
                    v.vampired = true
                    v:set_ability(G.P_CENTERS.c_base, nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:juice_up()
                            v.vampired = nil
                            return true
                        end
                    }))
                end
            end
            if #enhanced > 0 then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "current",
                    scalar_value = "mult",
                    message_key = 'a_mult',
                    message_colour = G.C.MULT,
                    operation = function(ref_table, ref_value, initial, scaling)
                        ref_table[ref_value] = initial + scaling*#enhanced
                    end,
                    scaling_message = {
                        message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.current+card.ability.extra.mult*#enhanced}},
                        colour = G.C.RED,
                    }
                })
                return nil, true
            end
        elseif context.joker_main then
            return {
                mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Symphonic Resonance
    key = 'symphonic_resonance',
    name = 'Symphonic Resonance',
    loc_txt = {
        name = 'Symphonic Resonance',
        text = {
            "This Joker gains {X:mult,C:white}X#1#{} Mult",
            "per scoring {C:enhanced}Enhanced{} card played,",
            "removes card {C:enhanced}Enhancement",
            'and returns card to hand',
            "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
        }
    },
    atlas = 'Joker',
	pos = { x = 14, y = 20 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        tower_info = { base = "Mermonkey", category = "magic" },
        extra = { Xmult = 0.1, current = 1 } --Variables: mult = +mult per enhanced card, current = current mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local enhanced = {}
            for k, v in ipairs(context.scoring_hand) do
                if v.config.center ~= G.P_CENTERS.c_base and not v.debuff and not v.vampired then
                    enhanced[#enhanced+1] = v
                    v.vampired = true
                    v.tranced = true
                    v:set_ability(G.P_CENTERS.c_base, nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:juice_up()
                            v.vampired = nil
                            return true
                        end
                    }))
                end
            end
            if #enhanced > 0 then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "current",
                    scalar_value = "Xmult",
                    message_key = 'a_xmult',
                    message_colour = G.C.MULT,
                    operation = function(ref_table, ref_value, initial, scaling)
                        ref_table[ref_value] = initial + scaling*#enhanced
                    end
                })
                return nil, true
            end
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --The Final Harmonic
    key = 'the_final_harmonic',
    name = 'The Final Harmonic',
    loc_txt = {
        name = 'The Final Harmonic',
        text = {
            'Return {C:enhanced}Enhanced{}',
            'cards to hand after',
            'being scored',
        }
    },
    atlas = 'Joker',
	pos = { x = 15, y = 20 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Mermonkey", category = "magic" },
    },

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            for k, v in ipairs(context.scoring_hand) do
                if v.config.center ~= G.P_CENTERS.c_base and not v.debuff and not v.vampired then
                    v.tranced = true
                end
            end
        end
    end
}