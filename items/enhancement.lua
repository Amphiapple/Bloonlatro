SMODS.Atlas {
    key = 'Enhancement',
    path = 'enhancement.png',
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
	atlas = "Enhancement",
	pos = { x = 0, y = 0 },
    order = 10,
    overrides_base_rank = true,
	replace_base_card = true,
    shatters = true,
    force_no_face = true,
    unlocked = true,
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
	atlas = 'Enhancement',
	pos = { x = 1, y = 0 },
    order = 11,
    unlocked = true,
    config = { cost = 1 },
    
    loc_vars = function(self, info_queue, center)
        --Variables: cost = money loss when discarded
        return { vars = { self.config.cost } }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.main_scoring and #find_joker('Relentless Glue') == 0 then
            card:set_ability(G.P_CENTERS.c_base, nil, true)
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
	atlas = "Enhancement",
	pos = { x = 2, y = 0 },
    order = 12,
    unlocked = true,

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
	atlas = "Enhancement",
	pos = { x = 3, y = 0 },
    order = 13,
	replace_base_card = true,
    no_rank = true,
    no_suit = true,
    always_scores = true,
    unlocked = true,
    config = { Xmult = 3 },

    in_pool = function()
        return #find_joker('Inferno Ring') > 0
    end,
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
    end
})