SMODS.Atlas {
    key = 'Enhancement',
    path = 'enhancement.png',
    px = 71,
    py = 95,
}

SMODS.Enhancement ({ --Frozen
    key = 'frozen',
    name = 'Frozen Card',
    loc_txt = {
        name = 'Frozen Card',
        text = {
            '{C:chips}+#1#{} Chips and',
            'thaws when held in hand',
            'no rank or suit'
        }
    },
	atlas = "Enhancement",
	pos = { x = 0, y = 0 },
    order = 10,
    no_rank = true,
    no_suit = true,
    shatters = true,
    config = { h_chips = 40 }, --Variables: h_chips = +chips when held in hand
    
    loc_vars = function(self, info_queue, center)
        return { vars = { self.config.h_chips } }
    end,
    calculate = function(self, card, context)
        if context.after and context.cardarea == G.hand then
            card:set_ability(G.P_CENTERS.c_base, nil, true)
            G.E_MANAGER:add_event(Event({
                func = function()
                    card:juice_up()
                    return true
                end
            })) 
        end
    end
})


SMODS.Enhancement ({ --Glued
    key = 'glued',
    name = 'Glued Card',
    loc_txt = {
        name = 'Glued Card',
        text = {
            '{C:mult}+#1#{} Mult and',
            'wears off when scored',
            'Lose {C:money}$#2#{} when discarded'
        }
    },
	atlas = 'Enhancement',
	pos = { x = 1, y = 0 },
    order = 11,
    config = { mult = 5, cost = 1 }, --Variables: mult = +mult, cost = money loss when discarded
    
    loc_vars = function(self, info_queue, center)
        return { vars = { self.config.mult, self.config.cost } }
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
    config = { Xmult = 3 }, --Variables: x_mult = Xmult

    in_pool = function()
        return #find_joker('Inferno Ring') > 0 or #find_joker('Wizard Lord Phoenix') > 0
    end,
    loc_vars = function(self, info_queue, center)
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
