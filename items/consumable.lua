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

SMODS.Consumable { --Freezing Trap
    key = 'ftrap',
    set = 'Tarot',
    name = 'Freezing Trap',
    loc_txt = {
        name = 'Freezing Trap',
        text = {
            '{C:attention}Freezes #1#{}',
            'selected cards'
        }
    },
    atlas = 'Consumable',
	pos = { x = 1, y = 0 },
	order = 24,
    config = { mod_conv = "m_bloons_frozen", max_highlighted = 3 },

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
		return { vars = { card and card.ability.max_highlighted or self.config.max_highlighted } }
	end,
}

SMODS.Consumable { --Thunderbolt
    key = 'thunder',
    set = 'Tarot',
    name = 'Thunderbolt',
    loc_txt = {
        name = 'Thunderbolt',
        text = {
            '{C:attention}Stuns #1#{}',
            'selected cards'
        }
    },
    atlas = 'Consumable',
	pos = { x = 2, y = 0 },
	order = 24,
    config = { mod_conv = "m_bloons_frozen", max_highlighted = 2 },

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_stunned
		return { vars = { card and card.ability.max_highlighted or self.config.max_highlighted } }
	end,
}

SMODS.Consumable { --Volcano
    key = 'volcano',
    set = 'Spectral',
    name = 'Volcano',
    loc_txt = {
        name = 'Volcano',
        text = {
            'Destroy {C:attention}1{} selected',
            'card in hand',
            'Adjacent cards become',
            '{C:attention}Meteor{} cards'
        }
    },
    atlas = 'Consumable',
	pos = { x = 0, y = 2 },
    cost = 4,
	order = 51,
    config = { max_highlighted = 1 },

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_meteor
		return { vars = { card and card.ability.max_highlighted or self.config.max_highlighted } }
	end,
    use = function(self, card, area)
        local destroyed_card = G.hand.highlighted[1]
        local volcano_cards = {}
        for i = 1, #G.hand.cards do
            if G.hand.cards[i] == destroyed_card then
                if i > 1 then 
                    volcano_cards[#volcano_cards+1] = G.hand.cards[i-1]
                end
                if i < #G.hand.cards then
                    volcano_cards[#volcano_cards+1] = G.hand.cards[i+1]
                end
            end
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.4, func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end 
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.1, func = function()
                if destroyed_card.ability.name == 'Glass Card' then 
                    destroyed_card:shatter()
                else
                    destroyed_card:start_dissolve()
                end
                return true
            end 
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.7, func = function()
                for k, v in pairs(volcano_cards) do
                    v:set_ability('m_bloons_meteor', nil, true)
                    v:juice_up()
                end
                return true
            end
        }))
    end
}