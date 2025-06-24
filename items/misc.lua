

SMODS.Atlas {
    key = 'Misc',
    path = 'misc.png',
    px = 71,
    py = 95,
}
--[[
SMODS.Enhancement ({ --Frozen
    key = 'frozen',
    name = 'Frozen Card',
    loc_txt = {
        name = 'Frozen Card',
        text = {
            '',
            '{C:inactive}unimplemented{}',
        }
    },
    order = 10,
	atlas = "Misc",
	pos = { x = 0, y = 0 },
    overrides_base_rank = true,
	replace_base_card = true,
    shatters = true,
    force_no_face = true,
    unlocked = true,
    config = { },

})
]]

SMODS.Enhancement ({ --Glued
    key = 'glued',
    name = 'Glued Card',
    loc_txt = {
        name = 'Glued Card',
        text = {
            'Lose {C:money}$#1#{} when discarded',
            'Wears off when played'
        }
    },
    order = 11,
	atlas = "Misc",
	pos = { x = 1, y = 0 },
    unlocked = true,

    config = { cost = 1 },
    loc_vars = function(self, info_queue, center)
        --Variables: cost = money loss when discarded
        return { vars = { self.config.cost } }
    end,
    calculate = function(self, card, context)
        if context.before then
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i].ability.name == 'Glued Card' and not card.debuff then
                    context.scoring_hand[i]:set_ability(G.P_CENTERS.c_base, nil, true)
                end
            end
        elseif context.discard and context.other_card == card then
            ease_dollars(-1*card.ability.cost)
        end
    end
})

--[[
SMODS.Enhancement ({ --Stunned
    key = 'stunned',
    name = 'Stunned Card',
    loc_txt = {
        name = 'Stunned Card',
        text = {
            '{C:inactive}unimplemented{}',
        }
    },
    order = 12,
	atlas = "Misc",
	pos = { x = 2, y = 0 },
    unlocked = true,

    config = { },
    calculate = function(self, card, context)

    end
})
]]

SMODS.Enhancement ({ --Meteor
    key = 'meteor',
    name = 'Meteor Card',
    loc_txt = {
        name = 'Meteor Card',
        text = {
            '',
            '{X:mult,C:white}X#1#{} Mult',
            'destroys card',
            'no rank or suit'
        }
    },
    order = 13,
	atlas = "Misc",
	pos = { x = 3, y = 0 },
	replace_base_card = true,
    no_rank = true,
    no_suit = true,
    always_scores = true,
    unlocked = true,

    config = { Xmult = 3 },
    loc_vars = function(self, info_queue, center)
        --Variables: x_mult = Xmult
        return { vars = { self.config.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual then
            return {
                x_mult = card.ability.Xmult
            }
        elseif context.destroying_card then
            return { remove = context.destroying_card.ability.name == 'Meteor Card' }
        end
    end,
})