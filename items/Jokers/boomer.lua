SMODS.Joker { --Boomerang Monkey
    key = 'boomerang_monkey',
    name = 'Boomerang Monkey',
	atlas = 'Joker',
	pos = { x = 0, y = 1 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Boomerang Monkey", category = "primary" },
        extra = { retrigger = 1 } --Variables: retrigger = retrigger amount
    },

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[#context.scoring_hand] then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger,
            }
        end
    end
}

SMODS.Joker { --Improved Rangs
    key = 'improved_rangs',
    name = 'Improved Rangs',
    atlas = 'Joker',
	pos = { x = 1, y = 1 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Boomerang Monkey", category = "primary" },
        extra = { retrigger = 1, number = 2 } --Variables: retrigger = retrigger amount, number = number of cards retriggered
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.number } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and (context.other_card == context.scoring_hand[#context.scoring_hand] or context.other_card == context.scoring_hand[#context.scoring_hand-1]) then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger,
            }
        end
    end
}

SMODS.Joker { --Glaives
    key = 'glaives',
    name = 'Glaives',
    atlas = 'Joker',
	pos = { x = 2, y = 1 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        tower_info = { base = "Boomerang Monkey", category = "primary" },
        extra = { chips = 1, current = 0 } --Variables: chips = +chips per continuing card, current = current +chips
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.other_card.debuff and not context.blueprint then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.chips
        elseif context.joker_main then
            return {
                chips = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Glaive Ricochet
    key = 'glaive_ricochet',
    name = 'Glaive Ricochet',
    atlas = 'Joker',
	pos = { x = 3, y = 1 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        tower_info = { base = "Boomerang Monkey", category = "primary" },
        extra = { chips = 2, current = 0 } --Variables: chips = +chips per continuing card, current = current +chips
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.other_card.debuff and not context.blueprint then
            local last_card = nil
            for k, v in ipairs(context.scoring_hand) do
                if v == context.other_card then
                    last_card = context.scoring_hand[k-1]
                end
            end
            if last_card and context.other_card:get_id() == last_card:get_id() and not SMODS.has_no_rank(context.other_card) then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "current",
                    scalar_value = "chips",
                    no_message = true
                })
                return {
                    extra = {focus = card, message = localize('k_upgrade_ex')},
                }
            end
        elseif context.joker_main then
            return {
                chips = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --MOAR Glaives
    key = 'moar_glaives',
    name = 'MOAR Glaives',
    atlas = 'Joker',
	pos = { x = 4, y = 1 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        tower_info = { base = "Boomerang Monkey", category = "primary" },
        extra = { chips = 2, current = 0 } --Variables: chips = +chips per continuing card, current = current +chips
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.other_card.debuff and not context.blueprint then
            local last_card = nil
            for k, v in ipairs(context.scoring_hand) do
                if v == context.other_card then
                    last_card = context.scoring_hand[k-1]
                end
            end
            if last_card and not SMODS.has_no_rank(context.other_card) then
                local id1 = context.other_card:get_id()
                local id2 = last_card:get_id()
                local diff = math.abs(id1 - id2)
                if diff <= 1 or diff >= 12 then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "current",
                        scalar_value = "chips",
                        no_message = true
                    })
                    return {
                        extra = {focus = card, message = localize('k_upgrade_ex')},
                    }
                end
            end
        elseif context.joker_main then
            return {
                chips = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Glaive Lord
    key = 'glaive_lord',
    name = 'Glaive Lord',
	atlas = 'Joker',
	pos = { x = 5, y = 1 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        tower_info = { base = "Boomerang Monkey", category = "primary" },
        extra = { chips = 2, current = 0 } --Variables: chips = +chips per continuing card, current = current +chips
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.other_card.debuff and not context.blueprint then
            local last_card = nil
            for k, v in ipairs(context.scoring_hand) do
                if v == context.other_card then
                    last_card = context.scoring_hand[k-1]
                end
            end
            if last_card and not SMODS.has_no_rank(context.other_card) then
                local id1 = context.other_card:get_id()
                local id2 = last_card:get_id()
                local diff = math.abs(id1 - id2)
                if diff <= 2 or (diff >= 11 and id1 + id2 >= 16) then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "current",
                        scalar_value = "chips",
                        no_message = true
                    })
                    return {
                        extra = {focus = card, message = localize('k_upgrade_ex')},
                    }
                end
            end
        elseif context.joker_main then
            return {
                chips = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Faster Throwing
    key = 'faster_throwing_boomerang',
    name = 'Faster Throwing (Boomerang)',
	atlas = 'Joker',
	pos = { x = 6, y = 1 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Boomerang Monkey", category = "primary" },
        extra = { retrigger = 1 } --Variables: retrigger = retrigger amount
    },

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.hand and context.other_card == G.hand.cards[#G.hand.cards] and not context.other_card.debuff then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger,
                card = card
            }
        end
    end
}

SMODS.Joker { --Faster Rangs
    key = 'faster_rangs',
    name = 'Faster Rangs',
	atlas = 'Joker',
	pos = { x = 7, y = 1 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Boomerang Monkey", category = "primary" },
        extra = { retrigger = 1, number = 2 } --Variables: retrigger = retrigger amount
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.number} }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.hand and (context.other_card == G.hand.cards[#G.hand.cards] or context.other_card == G.hand.cards[#G.hand.cards-1]) and not context.other_card.debuff then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger,
                card = card
            }
        end
    end
}

SMODS.Joker { --Bionic Boomerang
    key = 'bionic_boomerang',
    name = 'Bionic Boomerang',
	atlas = 'Joker',
	pos = { x = 8, y = 1 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    enhancement_gate = 'm_steel',
    config = {
        tower_info = { base = "Boomerang Monkey", category = "primary" },
        extra = { retrigger = 1 } --Variables: retrigger = retrigger amount
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.hand and context.other_card.ability.name == 'Steel Card' and not context.other_card.debuff then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger,
                card = card
            }
        end
    end
}

SMODS.Joker { --Turbo Charge
    key = 'turbo_charge',
    name = 'Turbo Charge',
	atlas = 'Joker',
	pos = { x = 9, y = 1 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Boomerang Monkey", category = "primary" },
        extra = { retrigger = 1 } --Variables: retrigger = retrigger amount
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.retrigger } }
    end,
    calculate = function(self, card, context)
        if context.repetition and G.GAME.current_round.hands_left == 0 and context.cardarea == G.hand and not context.other_card.debuff then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger,
                card = card
            }
        end
    end
}

SMODS.Joker { --Perma Charge
    key = 'perma_charge',
    name = 'Perma Charge',
	atlas = 'Joker',
	pos = { x = 10, y = 1 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Boomerang Monkey", category = "primary" },
        extra = { retrigger = 3 } --Variables: retrigger = retrigger amount
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.retrigger } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.hand and context.other_card == G.hand.cards[#G.hand.cards] and not context.other_card.debuff then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger,
                card = card
            }
        end
    end
}

SMODS.Joker { --Long Range Rangs
    key = 'long_range_rangs',
    name = 'Long Range Rangs',
    atlas = 'Joker',
	pos = { x = 11, y = 1 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Boomerang Monkey", category = "primary" },
        extra = { retrigger = 1 } --Variables: retrigger = retrigger amount
    },

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[1] then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger,
            }
        end
    end
}

SMODS.Joker { --Red Hot Rangs
    key = 'red_hot_rangs',
    name = 'Red Hot Rangs',
    atlas = 'Joker',
	pos = { x = 12, y = 1 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Boomerang Monkey", category = "primary" },
        extra = { retrigger = 1 } --Variables: retrigger = retrigger amount
    },

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            if #context.scoring_hand == 1 and context.other_card == context.scoring_hand[1] then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.retrigger * 2,
                }
            elseif context.other_card == context.scoring_hand[1] or context.other_card == context.scoring_hand[#context.scoring_hand] then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.retrigger,
                }
            end
        end
    end
}

SMODS.Joker { --Kylie Boomerang
    key = 'kylie_boomerang',
    name = 'Kylie Boomerang',
    atlas = 'Joker',
	pos = { x = 13, y = 1 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Boomerang Monkey", category = "primary" },
        extra = { retrigger = 1 } --Variables: retrigger = retrigger amount
    },

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card ~= context.scoring_hand[1] and context.other_card ~= context.scoring_hand[#context.scoring_hand] then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger,
            }
        end
    end
}

SMODS.Joker { --MOAB Press
    key = 'moab_press',
    name = 'MOAB Press',
	atlas = 'Joker',
	pos = { x = 14, y = 1 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Boomerang Monkey", category = "primary" },
        extra = { retrigger = 1 } --Variables: retrigger = retrigger amount
    },

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and G.GAME.blind.boss then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger,
            }
        end
    end
}

SMODS.Joker { --MOAB Domination
    key = 'moab_domination',
    name = 'MOAB Domination',
	atlas = 'Joker',
	pos = { x = 15, y = 1 },
    rarity = 3,
	cost = 9,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Boomerang Monkey", category = "primary" },
        extra = { retrigger = 1, Xmult = 2, exploded = nil } --Variables: retrigger = retrigger amount, Xmult = Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and not card.ability.extra.exploded then
            local last_card = nil
            for k, v in ipairs(context.scoring_hand) do
                if v == context.other_card then
                    last_card = context.scoring_hand[k-1]
                end
            end
            if not (last_card and context.other_card:get_id() >= last_card:get_id() or SMODS.has_no_rank(context.other_card)) then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.retrigger,
                }
            end
        elseif context.individual and context.cardarea == G.play then
            if not card.ability.extra.exploded then
                local last_card = nil
                for k, v in ipairs(context.scoring_hand) do
                    if v == context.other_card then
                        last_card = context.scoring_hand[k-1]
                    end
                end
                if last_card and context.other_card:get_id() >= last_card:get_id() or SMODS.has_no_rank(context.other_card) then
                    card.ability.extra.exploded = context.other_card
                end
            end
            if card.ability.extra.exploded == context.other_card then
                return {
                    x_mult = card.ability.extra.Xmult
                }
            end
        elseif context.after then
            card.ability.extra.exploded = nil
        end
    end
}
