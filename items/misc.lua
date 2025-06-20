

SMODS.Atlas {
    key = 'Misc',
    path = 'misc.png',
    px = 71,
    py = 95,
}
--[[
SMODS.Enhancement ({ --Frozen
    key = 'm_frozen',
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
--[[
SMODS.Enhancement ({ --Glued
    key = 'm_glued',
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
        if context.cardarea == G.play then
            for k, v in ipairs(context.scoring_hand) do
                if true then
                    v.config.center = G.P_CENTERS.c_base
                end
            end
        elseif context.cardarea == G.discard then
            ease_dollars(-1*card.ability.cost)
        
        end
    end
})
]]
--[[
SMODS.Enhancement ({ --Stunned
    key = 'm_stunned',
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
