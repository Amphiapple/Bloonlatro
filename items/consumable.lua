SMODS.Atlas {
    key = 'Consumable',
    path = 'consumable.png',
    px = 71,
    py = 95,
}

SMODS.Consumable { --Glue Trap
    key = 'gtrap',
    set = 'Tarot',
    name = 'Glue Trap',
    loc_txt = {
        name = 'Glue Trap',
        text = {
            '{C:attention}Glues #1#{}',
            'selected cards'
        }
    },
    atlas = 'Consumable',
	pos = { x = 0, y = 0 },
	order = 23,
    config = { mod_conv = "m_bloons_glued", max_highlighted = 3 },

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued

		return { vars = { card and card.ability.max_highlighted or self.config.max_highlighted } }
	end,
}