

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

SMODS.Enhancement ({ --Glued
    key = 'm_glued',
    name = 'Glued Card',
    loc_txt = {
        name = 'Glued Card',
        text = {
            "Can't be discarded",
            'played card that scores',
            'Enables Corvus\' {C:spectral}Spellbook{}',
            '{C:inactive}unimplemented{}',
        }
    },
    order = 11,
	atlas = "Misc",
	pos = { x = 1, y = 0 },
    unlocked = true,

    config = { },
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.main_scoring then
            card.config.center = G.P_CENTERS.c_base
            return {
				Emult_mod = card.ability.extra.Emult,
				colour = G.C.DARK_EDITION,
            }
        end
    end
})

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