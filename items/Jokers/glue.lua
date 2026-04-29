SMODS.Joker { --Glue Gunner
    key = 'glue_gunner',
    name = 'Glue Gunner',
	loc_txt = {
        name = 'Glue Gunner',
        text = {
            '{C:attention}First{} played card',
            'becomes {C:attention}Glued{} and gives',
            '{C:mult}+#1#{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 5 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Glue Gunner", category = "primary" },
        extra = { mult = 10 } --Variables: mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card == context.scoring_hand[1] then
            context.other_card:set_ability(G.P_CENTERS.m_bloons_glued, nil, true)
            if not context.other_card.glued then
                context.other_card.glued = true
            end
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --Glue Soak
    key = 'glue_soak',
    name = 'Glue Soak',
	loc_txt = {
        name = 'Glue Soak',
        text = {
            '{C:attention}Glued{} cards have',
            'a {C:green}#1# in #2#{} chance',
            'to remain glued',
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 5 },
    rarity = 1,
	cost = 3,
    blueprint_compat = false,
    enhancement_gate = 'm_bloons_glued',
    config = {
        tower_info = { base = "Glue Gunner", category = "primary" },
        extra = { num = 1, denom = 2 } --Variables: num/denom = probability fraction
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'glue_soak')
        return { vars = { n, d } }
    end,
}

SMODS.Joker { --Corrosive Glue
    key = 'corrosive_glue',
    name = 'Corrosive Glue',
    loc_txt = {
        name = 'Corrosive Glue',
        text = {
            'This {C:attention}Joker{} gains',
            '{C:mult}+#1#{} Mult for every played',
            '{C:attention}Glued{} card that scores',
            '{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)'
        }
    },
    atlas = 'Joker',
	pos = { x = 2, y = 5 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    perishable_compat = false,
    enhancement_gate = 'm_bloons_glued',
    config = {
        tower_info = { base = "Glue Gunner", category = "primary" },
        extra = { mult = 1, current = 0 } --Variables: mult = +mult for each glued card, current = current +mult
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
        return { vars = { card.ability.extra.mult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            for k, v in ipairs(context.scoring_hand) do
                if v.ability.name == 'Glued Card' then
                    card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult
                end
            end
        elseif context.joker_main then
            return {
                mult = card.ability.extra.current,
            }
        end
    end
}

SMODS.Joker { --Bloon Dissolver
    key = 'bloon_dissolver',
    name = 'Bloon Dissolver',
    loc_txt = {
        name = 'Bloon Dissolver',
        text = {
            '{C:attention}Glued{} cards',
            'permanently gain {C:mult}+#1#{}',
            'Mult when scored'
        }
    },
    atlas = 'Joker',
	pos = { x = 3, y = 5 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    enhancement_gate = 'm_bloons_glued',
    config = {
        tower_info = { base = "Glue Gunner", category = "primary" },
        extra = { p_mult = 2 } --Variables: mult = permanent +mult
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
        return { vars = { card.ability.extra.p_mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.ability.name == 'Glued Card' then
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult or 0
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult + card.ability.extra.p_mult
            return {
                extra = {message = localize('k_upgrade_ex'), colour = G.C.MULT},
                colour = G.C.CMULT,
            }
        end
    end
}

SMODS.Joker { --Bloon Liquefier
    key = 'bloon_liquefier',
    name = 'Bloon Liquefier',
    loc_txt = {
        name = 'Bloon Liquefier',
        text = {
            '{C:attention}Glued{} cards',
            'give {C:mult}+#1#{} Mult and',
            'permanently gain {C:mult}+#2#{}',
            'Mult when scored'
        }
    },
    atlas = 'Joker',
	pos = { x = 4, y = 5 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    enhancement_gate = 'm_bloons_glued',
    config = {
        tower_info = { base = "Glue Gunner", category = "primary" },
        extra = { mult = 10, p_mult = 1 } --Variables: mult = permanent +mult
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
        return { vars = { card.ability.extra.mult, card.ability.extra.p_mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.ability.name == 'Glued Card' then
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult or 0
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult + card.ability.extra.p_mult
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --The Bloon Solver
    key = 'the_bloon_solver',
    name = 'The Bloon Solver',
	loc_txt = {
        name = 'The Bloon Solver',
        text = {
            'This {C:attention}Joker{} gains',
            '{X:mult,C:white}X#1#{} Mult for every played',
            '{C:attention}Glued{} card that scores',
            '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)'
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 5 },
    rarity = 3,
	cost = 7,
    blueprint_compat = true,
    enhancement_gate = 'm_bloons_glued',
    config = {
        tower_info = { base = "Glue Gunner", category = "primary" },
        extra = { Xmult = 0.1, current = 1 } --Variables: Xmult = Xmult per glued card, current = current Xmult
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
        return { vars = { card.ability.extra.Xmult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            for k, v in ipairs(context.scoring_hand) do
                if v.ability.name == 'Glued Card' then
                    card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult
                end
            end
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current,
            }
        end
    end
}

SMODS.Joker { --Bigger Globs
    key = 'bigger_globs',
    name = 'Bigger Globs',
	loc_txt = {
        name = 'Bigger Globs',
        text = {
            '{C:attention}First #1#{} played cards',
            'becomes {C:attention}Glued{} and give',
            '{C:mult}+#2#{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 6, y = 5 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Glue Gunner", category = "primary" },
        extra = { number = 2, mult = 5 } --Variables: mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
        return { vars = { card.ability.extra.number, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and (context.other_card == context.scoring_hand[1] or context.other_card == context.scoring_hand[2]) then
            context.other_card:set_ability(G.P_CENTERS.m_bloons_glued, nil, true)
            if not context.other_card.glued then
                context.other_card.glued = true
            end
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --Glue Splatter
    key = 'glue_splatter',
    name = 'Glue Splatter',
	loc_txt = {
        name = 'Glue Splatter',
        text = {
            '{C:mult}+#1#{} Mult and',
            '{C:attention}Glue{} all cards in',
            '{C:attention}first hand{} of round',
        }
    },
	atlas = 'Joker',
	pos = { x = 7, y = 5 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Glue Gunner", category = "primary" },
        extra = { mult = 10 },
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and G.GAME.current_round.hands_played == 0 then
            context.other_card:set_ability(G.P_CENTERS.m_bloons_glued, nil, true)
            if not context.other_card.glued then
                context.other_card.glued = true
            end
        elseif context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --Glue Hose
    key = 'glue_hose',
    name = 'Glue Hose',
	loc_txt = {
        name = '#1#',
        text = {
            '{C:attention}Glue{} all cards',
            'in first discard',
            '{C:attention}Glued{} cards no longer',
            'lose money when discarded'
        }
    },
	atlas = 'Joker',
	pos = { x = 8, y = 5 },
    rarity = 2,
	cost = 6,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Glue Gunner", category = "primary" },
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
        local horse = SMODS.Mods['horse_mod'] and SMODS.Mods['horse_mod'].can_load and HORSEMOD
        return { vars = { horse and 'Glue Horse' or 'Glue Hose' } }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function()
                return (G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES)
            end
            juice_card_until(card, eval, true)
        elseif context.discard and G.GAME.current_round.discards_used == 0 and not context.other_card.debuff and not context.blueprint then
            context.other_card:set_ability(G.P_CENTERS.m_bloons_glued, nil, true)
            return {
                message = 'Glued!',
                colour = G.C.YELLOW
            }
        end
    end
}

SMODS.Joker { --Glue Strike
    key = 'glue_strike',
    name = 'Glue Strike',
	loc_txt = {
        name = 'Glue Strike',
        text = {
            '{C:attention}Glue{} all cards',
            'drawn in first hand',
            '{C:attention}Glued{} cards no longer',
            'lose money when discarded'
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 5 },
    rarity = 2,
	cost = 7,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Glue Gunner", category = "primary" },
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
    end,
    calculate = function(self, card, context)
        if context.hand_drawn and G.GAME.current_round.hands_played == 0 and G.GAME.current_round.discards_used == 0 and not context.blueprint then
            for k, v in pairs(G.hand.cards) do
                if not v.debuff then
                    v:set_ability(G.P_CENTERS.m_bloons_glued, nil, true)
                    v:juice_up()
                end
            end
        end
    end
}

SMODS.Joker { --Glue Storm
    key = 'glue_storm',
    name = 'Glue Storm',
	loc_txt = {
        name = 'Glue Storm',
        text = {
            '{C:attention}Glue{} all discarded cards',
            '{C:attention}Glued{} cards no longer',
            'lose money when discarded'
        }
    },
	atlas = 'Joker',
	pos = { x = 10, y = 5 },
    rarity = 3,
	cost = 7,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Glue Gunner", category = "primary" },
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
    end,
    calculate = function(self, card, context)
        if context.discard and not context.other_card.debuff and not context.blueprint then
            context.other_card:set_ability(G.P_CENTERS.m_bloons_glued, nil, true)
            return {
                message = 'Glued!',
                colour = G.C.YELLOW
            }
        end
    end
}

SMODS.Joker { --Stickier Glue
    key = 'stickier_glue',
    name = 'Stickier Glue',
	loc_txt = {
        name = 'Stickier Glue',
        text = {
            '{C:attention}First{} played card',
            'becomes {C:attention}Glued{} and gives',
            '{C:mult}+#1#{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 11, y = 5 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Glue Gunner", category = "primary" },
        extra = { mult = 15 } --Variables: mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card == context.scoring_hand[1] then
            context.other_card:set_ability(G.P_CENTERS.m_bloons_glued, nil, true)
            if not context.other_card.glued then
                context.other_card.glued = true
            end
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --Stronger Glue
    key = 'stronger_glue',
    name = 'Stronger Glue',
	loc_txt = {
        name = 'Stronger Glue',
        text = {
            '{C:attention}Glued{} cards give',
            '{C:mult}+#1#{} more Mult but lose',
            '{C:money}$#2#{} when discarded'
        }
    },
	atlas = 'Joker',
	pos = { x = 12, y = 5 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    enhancement_gate = 'm_bloons_glued',
    config = {
        tower_info = { base = "Glue Gunner", category = "primary" },
        extra = { mult = 10, money = 2 } --Variables: mult = +mult, money = new money loss
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
        return { vars = { card.ability.extra.mult, card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.ability.name == 'Glued Card' then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --MOAB Glue
    key = 'moab_glue',
    name = 'MOAB Glue',
	loc_txt = {
        name = 'MOAB Glue',
        text = {
            '{X:mult,C:white}X#1#{} Mult and',
            '{C:attention}Glue{} all scoring cards',
            'against {C:attention}Boss Blinds{}',
        }
    },
	atlas = 'Joker',
	pos = { x = 13, y = 5 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Glue Gunner", category = "primary" },
        extra = { Xmult = 2 } --Variables: Xmult = Xmult
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and G.GAME.blind.boss then
            context.other_card:set_ability(G.P_CENTERS.m_bloons_glued, nil, true)
            if not context.other_card.glued then
                context.other_card.glued = true
            end
            card.ability.extra.face = true
        elseif context.joker_main and G.GAME.blind.boss then
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --Relentless Glue
    key = 'relentless_glue',
    name = 'Relentless Glue',
    loc_txt = {
        name = 'Relentless Glue',
        text = {
            '{C:attention}Glue{} never wears off',
            'Retrigger all played',
            '{C:attention}Glued{} cards'
        }
    },
	atlas = 'Joker',
	pos = { x = 14, y = 5 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    enhancement_gate = 'm_bloons_glued',
    config = {
        tower_info = { base = "Glue Gunner", category = "primary" },
        extra = { retrigger = 1 } --Variables: retrigger = retrigger amount
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card.ability.name == 'Glued Card' then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger
            }
        end
    end
}

SMODS.Joker { --Super Glue
    key = 'super_glue',
    name = 'Super Glue',
    loc_txt = {
        name = 'Super Glue',
        text = {
            '{C:attention}Glue{} never wears off,',
            'give {X:mult,C:white}X#1#{} Mult when scored,',
            'and loses {C:money}$#2#{} when discarded'
        }
    },
	atlas = 'Joker',
	pos = { x = 15, y = 5 },
    rarity = 3,
	cost = 7,
    blueprint_compat = true,
    enhancement_gate = 'm_bloons_glued',
    config = {
        tower_info = { base = "Glue Gunner", category = "primary" },
        extra = { Xmult = 1.5, money = 3 } --Variables: retrigger = retrigger amount
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
        return { vars = { card.ability.extra.Xmult, card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.ability.name == 'Glued Card' then
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}
