SMODS.ConsumableType { --Upgrade Cards
    key = 'Upgrade',
    primary_colour = HEX('339900'),
    secondary_colour = HEX('44DD00'),
    loc_txt = {
        name = 'Upgrade',
        collection = 'Upgrade Cards',
        undiscovered = { -- description for undiscovered cards in the collection
            name = 'Not Discovered',
            text = {
                'Purchase or use',
                'this card in an',
                'unseeded run to',
                'learn what it does',
            },
        },
    },
    collection_rows = {6, 6},
    shop_rate = 0,
}

SMODS.Consumable { --Upgrade
    key = 'upgrade_basic',
    set = 'Upgrade',
    name = 'Upgrade!',
    atlas = 'Consumable',
    pos = { x = 0, y = 4 },
    config = { max_highlighted = 1 },

    can_use = function(self, card)
        return 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and get_tower_upgrade(G.jokers.highlighted[1], nil, 0, 1) ~= nil
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,
    use = function(self, card, area)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local start_joker = G.jokers.highlighted[1]
                local end_key = get_tower_upgrade(start_joker, nil, 0, 1)
                if end_key then
                    tower_upgrade(start_joker, end_key, nil)
                end
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        
    end
}