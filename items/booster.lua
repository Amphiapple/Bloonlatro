SMODS.Atlas {
    key = 'Booster',
    path = 'boosters.png',
    px = 71,
    py = 95,
}

SMODS.Booster {
    key = "power_normal_1",
    loc_txt = {
        name = 'Power Pack',
        group_name = 'Power Pack',
        text = {
            'Choose {C:attention}#1#{} of {C:attention}#2#{}',
            '{C:power}Power{} cards to add',
            'to your consumables'
        }
    },
    atlas = 'Booster',
	pos = { x = 0, y = 0 },
	cost = 4,
	weight = 1.2,
    kind = 'power',
    select_card = 'consumeables',
	config = { choose = 1, extra = 2 },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.choose, card.ability.extra } }
    end,
    create_card = function(self, card)
        return SMODS.create_card {
            set = 'Power',
            area = G.pack_cards,
            skip_materialize = true,
            key_append = 'p_bloons_power_normal_1'
        }
    end
}

SMODS.Booster {
    key = "power_normal_2",
    loc_txt = {
        name = 'Power Pack',
        group_name = 'Power Pack',
        text = {
            'Choose {C:attention}#1#{} of {C:attention}#2#{}',
            '{C:power}Power{} cards to add',
            'to your consumables'
        }
    },
    atlas = 'Booster',
	pos = { x = 1, y = 0 },
	cost = 4,
	weight = 1.2,
    kind = 'power',
    select_card = 'consumeables',
    config = { choose = 1, extra = 2 },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.choose, card.ability.extra } }
    end,
    create_card = function(self, card)
        return SMODS.create_card {
            set = 'Power',
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = 'p_bloons_power_normal_2'
        }
    end
}

SMODS.Booster {
    key = "power_jumbo_1",
    loc_txt = {
        name = 'Jumbo Power Pack',
        group_name = 'Power Pack',
        text = {
            'Choose {C:attention}#1#{} of {C:attention}#2#{}',
            '{C:power}Power{} cards to add',
            'to your consumables'
        }
    },
    atlas = 'Booster',
	pos = { x = 2, y = 0 },
	cost = 6,
	weight = 0.6,
    kind = 'power',
    select_card = 'consumeables',
    config = { choose = 1, extra = 4 },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.choose, card.ability.extra } }
    end,
    create_card = function(self, card)
        return SMODS.create_card {
            set = 'Power',
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = 'p_bloons_power_jumbo_1'
        }
    end
}

SMODS.Booster {
    key = "power_mega_1",
    loc_txt = {
        name = 'Mega Power Pack',
        group_name = 'Power Pack',
        text = {
            'Choose {C:attention}#1#{} of {C:attention}#2#{}',
            '{C:power}Power{} cards to add',
            'to your consumables'
        }
    },
    atlas = 'Booster',
	pos = { x = 3, y = 0 },
	cost = 8,
	weight = 0.15,
    kind = 'power',
    select_card = 'consumeables',
    config = { choose = 2, extra = 4 },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.choose, card.ability.extra } }
    end,
    create_card = function(self, card)
        return SMODS.create_card {
            set = 'Power',
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = 'p_bloons_power_mega_2'
        }
    end
}