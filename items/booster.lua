SMODS.Atlas {
    key = 'Booster',
    path = 'boosters.png',
    px = 71,
    py = 95,
}

SMODS.Booster {
    key = "power1",
    loc_txt = {
        name = 'Power Pack',
        text = {
            'Choose {C:attention}#1#{} of {C:attention}#2#{}',
            '{C:power}Power{} cards to add',
            'to your consumables'
        }
    },
    atlas = 'Booster',
	pos = { x = 0, y = 0 },
    group_key = "k_bloons_power",
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
            key_append = 'p_bloons_power_mega'
        }
    end
}

SMODS.Booster {
    key = "power2",
    loc_txt = {
        name = 'Power Pack',
        text = {
            'Choose {C:attention}#1#{} of {C:attention}#2#{}',
            '{C:power}Power{} cards to add',
            'to your consumables'
        }
    },
    atlas = 'Booster',
	pos = { x = 1, y = 0 },
    group_key = "k_bloons_power",
	cost = 4,
	weight = 2,
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
            key_append = 'p_bloons_power_mega'
        }
    end
}

SMODS.Booster {
    key = "jumbopower",
    loc_txt = {
        name = 'Jumbo Power Pack',
        text = {
            'Choose {C:attention}#1#{} of {C:attention}#2#{}',
            '{C:power}Power{} cards to add',
            'to your consumables'
        }
    },
    atlas = 'Booster',
	pos = { x = 2, y = 0 },
    group_key = "k_bloons_power",
	cost = 6,
	weight = 1,
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
            key_append = 'p_bloons_power_mega'
        }
    end
}

SMODS.Booster {
    key = "megapower",
    loc_txt = {
        name = 'Mega Power Pack',
        text = {
            'Choose {C:attention}#1#{} of {C:attention}#2#{}',
            '{C:power}Power{} cards to add',
            'to your consumables'
        }
    },
    atlas = 'Booster',
	pos = { x = 3, y = 0 },
    group_key = "k_bloons_power",
	cost = 8,
	weight = 0.25,
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
            key_append = 'p_bloons_power_mega'
        }
    end
}