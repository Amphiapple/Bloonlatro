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

SMODS.Consumable { --Top Path Upgrade
    key = 'upgrade_top',
    set = 'Upgrade',
    name = 'Upgrade Skill',
    atlas = 'Consumable',
    pos = { x = 0, y = 4 },
    config = { max_highlighted = 1 },

    can_use = function(self, card)
        return 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and get_tower_upgrade(G.jokers.highlighted[1], nil, nil, 1, 1) ~= nil
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
                local end_key = get_tower_upgrade(start_joker, nil, nil, 1, 1)
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

SMODS.Consumable { --Middle Path Upgrade
    key = 'upgrade_middle',
    set = 'Upgrade',
    name = 'Upgrade Ability',
    atlas = 'Consumable',
    pos = { x = 1, y = 4 },
    config = { max_highlighted = 1 },

    can_use = function(self, card)
        return 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and get_tower_upgrade(G.jokers.highlighted[1], nil, nil, 2, 1) ~= nil
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
                local end_key = get_tower_upgrade(start_joker, nil, nil, 2, 1)
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

SMODS.Consumable { --Bottom Path Upgrade
    key = 'upgrade_bottom',
    set = 'Upgrade',
    name = 'Upgrade Specialty',
    atlas = 'Consumable',
    pos = { x = 2, y = 4 },
    config = { max_highlighted = 1 },

    can_use = function(self, card)
        return 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and get_tower_upgrade(G.jokers.highlighted[1], nil, nil, 3, 1) ~= nil
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
                local end_key = get_tower_upgrade(start_joker, nil, nil, 3, 1)
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

SMODS.Consumable { --Primary Upgrade
    key = 'upgrade_primary',
    set = 'Upgrade',
    name = 'Primary Upgrade',
    atlas = 'Consumable',
    pos = { x = 3, y = 4 },
    config = { max_highlighted = 1 },

    can_use = function(self, card)
        return 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and get_tower_upgrade(G.jokers.highlighted[1], nil, 'primary', 0, 1) ~= nil
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
                local end_key = get_tower_upgrade(start_joker, nil, 'primary', 0, 1)
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

SMODS.Consumable { --Military Upgrade
    key = 'upgrade_military',
    set = 'Upgrade',
    name = 'Military Upgrade',
    atlas = 'Consumable',
    pos = { x = 4, y = 4 },
    config = { max_highlighted = 1 },

    can_use = function(self, card)
        return 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and get_tower_upgrade(G.jokers.highlighted[1], nil, 'military', 0, 1) ~= nil
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
                local end_key = get_tower_upgrade(start_joker, nil, 'military', 0, 1)
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

SMODS.Consumable { --Magic Upgrade
    key = 'upgrade_magic',
    set = 'Upgrade',
    name = 'Magical Upgrade',
    atlas = 'Consumable',
    pos = { x = 5, y = 4 },
    config = { max_highlighted = 1 },

    can_use = function(self, card)
        return 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and get_tower_upgrade(G.jokers.highlighted[1], nil, 'magic', 0, 1) ~= nil
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
                local end_key = get_tower_upgrade(start_joker, nil, 'magic', 0, 1)
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

SMODS.Consumable { --Support Upgrade
    key = 'upgrade_support',
    set = 'Upgrade',
    name = 'Supportive Upgrade',
    atlas = 'Consumable',
    pos = { x = 6, y = 4 },
    config = { max_highlighted = 1 },

    can_use = function(self, card)
        return 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and get_tower_upgrade(G.jokers.highlighted[1], nil, 'support', 0, 1) ~= nil
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
                local end_key = get_tower_upgrade(start_joker, nil, 'support', 0, 1)
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

SMODS.Consumable { --$5 Select Upgrade
    key = 'upgrade_select',
    set = 'Upgrade',
    name = 'Custom Construction',
    atlas = 'Consumable',
    pos = { x = 10, y = 4 },
    config = { max_highlighted = 1, money = 5 },

    can_use = function(self, card)
        return 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and get_tower_upgrade(G.jokers.highlighted[1], nil, nil, 0, 1) ~= nil and G.GAME.dollars >= card.ability.money
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.money, card.ability.max_highlighted } }
    end,
    use = function(self, card, area)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local start_joker = G.jokers.highlighted[1]
                local end_key = get_tower_upgrade(start_joker, nil, nil, 0, 1)
                if end_key then
                    tower_upgrade(start_joker, end_key, nil)
                    ease_dollars(-card.ability.money, true)
                end
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
    end
}

SMODS.Consumable { --$15 Select Upgrade
    key = 'upgrade_double_select',
    set = 'Upgrade',
    name = 'Premium Build',
    atlas = 'Consumable',
    pos = { x = 11, y = 4 },
    config = { max_highlighted = 2, money = 10 },

    can_use = function(self, card)
        local usable = 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted
        for k, v in ipairs(G.jokers.highlighted) do
            if get_tower_upgrade(v, nil, nil, 0, 1) == nil then
                usable = false
            end
        end
        return usable and G.GAME.dollars >= card.ability.money
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.money, card.ability.max_highlighted } }
    end,
    use = function(self, card, area)
        for i = 1, #G.jokers.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    local start_joker = G.jokers.highlighted[i]
                    local end_key = get_tower_upgrade(start_joker, nil, nil, 0, 1)
                    if end_key then
                        tower_upgrade(start_joker, end_key, nil)
                    end
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                ease_dollars(-card.ability.money, true)
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
    end
}

SMODS.Consumable { --Downgrade
    key = 'downgrade',
    set = 'Upgrade',
    name = 'Sell and Rebuy',
    atlas = 'Consumable',
    pos = { x = 12, y = 4 },
    config = { max_highlighted = 1 },

    can_use = function(self, card)
        return 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and get_tower_upgrade(G.jokers.highlighted[1], nil, nil, 0, -1) ~= nil
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
                local end_key = get_tower_upgrade(start_joker, nil, nil, 0, -1)
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

SMODS.Consumable { --Double Upgrade Sacrifice
    key = 'upgrade_sacrifice',
    set = 'Upgrade',
    name = 'Full Sell',
    atlas = 'Consumable',
    pos = { x = 13, y = 4 },
    config = { max_highlighted = 1, tiers = 2 },

    can_use = function(self, card)
        local usable = 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and not SMODS.is_eternal(G.jokers.highlighted[1], card)
        for k, v in ipairs(G.jokers.cards) do
            if v == G.jokers.highlighted[1] then
                return usable and k < #G.jokers.cards and get_tower_upgrade(G.jokers.cards[k+1], nil, nil, 0, card.ability.tiers) ~= nil
            end
        end
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted, card.ability.tiers } }
    end,
    use = function(self, card, area)
        local start_joker
        for k, v in ipairs(G.jokers.cards) do
            if v == G.jokers.highlighted[1] then
                start_joker = G.jokers.cards[k+1]
            end
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local end_key = get_tower_upgrade(start_joker, nil, nil, 0, card.ability.tiers)
                if end_key then
                    tower_upgrade(start_joker, end_key, nil)
                    G.jokers.highlighted[1].getting_sliced = true
                    G.jokers.highlighted[1]:start_dissolve()
                end
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
    end
}

SMODS.Consumable { --Upgrade Insta
    key = 'upgrade_insta',
    set = 'Upgrade',
    name = 'Insta-Monkey',
    atlas = 'Consumable',
    hidden = true,
    soul_set = 'Upgrade',
    soul_rate = .01,
    pos = { x = 14, y = 4 },
    config = { max_highlighted = 1 },

    can_use = function(self, card)
        return 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and get_tower_upgrade(G.jokers.highlighted[1], nil, nil, 0, 5) ~= nil
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
                local end_key = get_tower_upgrade(start_joker, nil, nil, 0, 5)
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

--[[
Random Tower 1 tier
50% chance random 1 Tower 2 tiers
25% chance All Towers 1 tier

Select 1 Tower 1 tier, pay $5
Select 2 Towers 1 tier, pay $15
Select Tower -1 tier
Select 1 Tower 2 tiers, destroy tower to the right

Legendary:
Select Tower 5 tiers (1%)
Upgrade to Paragon (0.3%)
]]