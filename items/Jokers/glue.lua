SMODS.Joker { --Glue Gunner
    key = 'glue',
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
        base = 'glue',
        extra = { mult = 10 } --Variables: mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card == context.scoring_hand[1] and not context.other_card.debuff then
            context.other_card:set_ability('m_bloons_glued', nil, true)
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --Corrosive Glue
    key = 'corrosive',
    name = 'Corrosive Glue',
    loc_txt = {
        name = 'Corrosive Glue',
        text = {
            'This Joker gains',
            '{C:chips}+#1#{} Chips for every played',
            '{C:attention}Glued{} card that scores',
            '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)'
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
        base = 'glue',
        extra = { chips = 8, current = 0 } --Variables: chips = +chip gain for each glued card, current = current +chips
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
        return { vars = { card.ability.extra.chips, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            for k, v in ipairs(context.scoring_hand) do
                if v.ability.name == 'Glued Card' then
                    card.ability.extra.current = card.ability.extra.current + card.ability.extra.chips
                end
            end
        elseif context.joker_main then
            return {
                chips = card.ability.extra.current,
            }
        end
    end
}

SMODS.Joker { --MOAB Glue
    key = 'mglue',
    name = 'MOAB Glue',
	loc_txt = {
        name = 'MOAB Glue',
        text = {
            'If scoring hand',
            'contains {C:attention}face{} cards,',
            '{C:attention}Glue{} them all and',
            'give {X:mult,C:white}X#1#{} Mult',
        }
    },
	atlas = 'Joker',
	pos = { x = 13, y = 5 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'glue',
        extra = { Xmult = 2, face = false } --Variables: Xmult = 2, face = if face cards score
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_face() and not context.other_card.debuff then
            context.other_card:set_ability('m_bloons_glued', nil, true)
            card.ability.extra.face = true
        elseif context.joker_main and card.ability.extra.face then
            return {
                x_mult = card.ability.extra.Xmult
            }
        elseif context.after and not context.blueprint then
            card.ability.extra.face = false
        end
    end
}

SMODS.Joker { --Glue Hose
    key = 'glose',
    name = 'Glue Hose',
	loc_txt = {
        name = 'Glue Hose',
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
        base = 'glue',
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
    end,
    calculate = function(self, card, context)
        if context.discard and G.GAME.current_round.discards_used == 0 and not context.other_card.debuff and not context.blueprint then
            context.other_card:set_ability('m_bloons_glued', nil, true)
            return {
                message = 'Glued!',
                colour = G.C.MONEY
            }
        end
    end
}

SMODS.Joker { --Relentless Glue
    key = 'relentless',
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
	cost = 6,
    blueprint_compat = true,
    enhancement_gate = 'm_bloons_glued',
    config = {
        base = 'glue',
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

SMODS.Joker { --The Bloon Solver
    key = 'solver',
    name = 'The Bloon Solver',
	loc_txt = {
        name = 'The Bloon Solver',
        text = {
            'Played {C:attention}cards{}',
            'become {C:attention}Glued{} and',
            'permanently gain {C:mult}+#1#{}',
            'Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 5 },
    rarity = 3,
	cost = 7,
    blueprint_compat = true,
    config = {
        base = 'glue',
        extra = { mult = 2 } --Variables: mult = permanent +mult
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            context.other_card:set_ability('m_bloons_glued', nil, true)
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult or 0
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult + card.ability.extra.mult
            return {
                extra = {message = localize('k_upgrade_ex'), colour = G.C.MULT},
                colour = G.C.CMULT,
            }
        end
    end
}
