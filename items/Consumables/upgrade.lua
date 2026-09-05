BTD = Bloonlatro

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
    collection_rows = {5, 5},
    shop_rate = 0,
}

SMODS.Consumable { --Top Path Upgrade
    key = 'upgrade_top',
    set = 'Upgrade',
    name = 'Upgrade Skill',
    atlas = 'Consumable',
    pos = { x = 0, y = 4 },
    config = { max_highlighted = 1 },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,
    can_use = function(self, card)
        return 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and BTD.get_tower_upgrade(G.jokers.highlighted[1], nil, nil, nil, 1, 1) ~= nil
    end,
    use = function(self, card, area)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local start_joker = G.jokers.highlighted[1]
                local end_key = BTD.get_tower_upgrade(start_joker, nil, nil, nil, 1, 1)
                if end_key then
                    BTD.upgrade_tower(start_joker, end_key, nil)
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

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,
    can_use = function(self, card)
        return 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and BTD.get_tower_upgrade(G.jokers.highlighted[1], nil, nil, nil, 2, 1) ~= nil
    end,
    use = function(self, card, area)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local start_joker = G.jokers.highlighted[1]
                local end_key = BTD.get_tower_upgrade(start_joker, nil, nil, nil, 2, 1)
                if end_key then
                    BTD.upgrade_tower(start_joker, end_key, nil)
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

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,
    can_use = function(self, card)
        return 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and BTD.get_tower_upgrade(G.jokers.highlighted[1], nil, nil, nil, 3, 1) ~= nil
    end,
    use = function(self, card, area)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local start_joker = G.jokers.highlighted[1]
                local end_key = BTD.get_tower_upgrade(start_joker, nil, nil, nil, 3, 1)
                if end_key then
                    BTD.upgrade_tower(start_joker, end_key, nil)
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

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,
    can_use = function(self, card)
        return 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and BTD.get_tower_upgrade(G.jokers.highlighted[1], nil, nil, 'primary', 0, 1) ~= nil
    end,
    use = function(self, card, area)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local start_joker = G.jokers.highlighted[1]
                local end_key = BTD.get_tower_upgrade(start_joker, nil, nil, 'primary', 0, 1)
                if end_key then
                    BTD.upgrade_tower(start_joker, end_key, nil)
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

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,
    can_use = function(self, card)
        return 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and BTD.get_tower_upgrade(G.jokers.highlighted[1], nil, nil, 'military', 0, 1) ~= nil
    end,
    use = function(self, card, area)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local start_joker = G.jokers.highlighted[1]
                local end_key = BTD.get_tower_upgrade(start_joker, nil, nil, 'military', 0, 1)
                if end_key then
                    BTD.upgrade_tower(start_joker, end_key, nil)
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

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,
    can_use = function(self, card)
        return 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and BTD.get_tower_upgrade(G.jokers.highlighted[1], nil, nil, 'magic', 0, 1) ~= nil
    end,
    use = function(self, card, area)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local start_joker = G.jokers.highlighted[1]
                local end_key = BTD.get_tower_upgrade(start_joker, nil, nil, 'magic', 0, 1)
                if end_key then
                    BTD.upgrade_tower(start_joker, end_key, nil)
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

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,
    can_use = function(self, card)
        return 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and BTD.get_tower_upgrade(G.jokers.highlighted[1], nil, 'support', 0, 1) ~= nil
    end,
    use = function(self, card, area)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local start_joker = G.jokers.highlighted[1]
                local end_key = BTD.get_tower_upgrade(start_joker, nil, nil, 'support', 0, 1)
                if end_key then
                    BTD.upgrade_tower(start_joker, end_key, nil)
                end
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
    end
}

SMODS.Consumable { --Random Upgrade
    key = 'upgrade_random',
    set = 'Upgrade',
    name = 'Improvisation',
    atlas = 'Consumable',
    pos = { x = 7, y = 4 },

    can_use = function(self, card)
        local usable = false
        for k, v in ipairs(G.jokers.cards) do
            if BTD.get_tower_upgrade(v, nil, nil, nil, 0, 1) ~= nil then
                usable = true
            end
        end
        return usable
    end,
    use = function(self, card, area)
        local eligible_jokers = {}
        for k, v in ipairs(G.jokers.cards) do
            if BTD.get_tower_upgrade(v, nil, nil, nil, 0, 1) ~= nil then
                table.insert(eligible_jokers, v)
            end
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local start_joker = pseudorandom_element(eligible_jokers, 'upgrade_random')
                local end_key = start_joker and BTD.get_tower_upgrade(start_joker, nil, nil, nil, 0, 1)
                if end_key then
                    BTD.upgrade_tower(start_joker, end_key, nil)
                end
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
    end
}

SMODS.Consumable { --Random Double Upgrade
    key = 'upgrade_double_random',
    set = 'Upgrade',
    name = 'Risky Play',
    atlas = 'Consumable',
    pos = { x = 8, y = 4 },
    config = { num = 1, denom = 2, tiers = 2 },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.num, card.ability.denom, 'upgrade_double_random')
        return { vars = { n, d, card.ability.tiers } }
    end,
    can_use = function(self, card)
        local usable = false
        for k, v in ipairs(G.jokers.cards) do
            if BTD.get_tower_upgrade(v, nil, nil, nil, 0, card.ability.tiers) ~= nil then
                usable = true
            end
        end
        return usable
    end,
    use = function(self, card, area)
        if SMODS.pseudorandom_probability(card, 'upgrade_double_random', card.ability.num, card.ability.denom, 'upgrade_double_random') then
            local eligible_jokers = {}
            for k, v in ipairs(G.jokers.cards) do
                if BTD.get_tower_upgrade(v, nil, nil, nil, 0, card.ability.tiers) ~= nil then
                    table.insert(eligible_jokers, v)
                end
            end
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    local start_joker = pseudorandom_element(eligible_jokers, 'upgrade_double_random')
                    local end_key = start_joker and BTD.get_tower_upgrade(start_joker, nil, nil, nil, 0, card.ability.tiers)
                    if end_key then
                        BTD.upgrade_tower(start_joker, end_key, nil)
                    end
                    play_sound('tarot1')
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        else
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    attention_text({
                        text = localize('k_nope_ex'),
                        scale = 1.3,
                        hold = 1.4,
                        major = card,
                        backdrop_colour = G.C.PALE_GREEN,
                        align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and 'tm' or 'cm',
                        offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0},
                        silent = true
                    }) 
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.06*G.SETTINGS.GAMESPEED,
                        blockable = false,
                        blocking = false,
                        func = function()
                            play_sound('tarot2', 0.76, 0.4);
                            return true
                        end
                    }))
                    play_sound('tarot2', 1, 0.4)
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end
    end
}

SMODS.Consumable { --Wheel Upgrade
    key = 'upgrade_wheel',
    set = 'Upgrade',
    name = 'Spin the Wheel',
    atlas = 'Consumable',
    pos = { x = 9, y = 4 },
    config = { num = 1, denom = 4 },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.num, card.ability.denom, 'upgrade_wheel')
        return { vars = { n, d } }
    end,
    can_use = function(self, card)
        local usable = false
        for k, v in ipairs(G.jokers.cards) do
            if BTD.get_tower_upgrade(v, nil, nil, nil, 0, 1) ~= nil then
                usable = true
            end
        end
        return usable
    end,
    use = function(self, card, area)
        if SMODS.pseudorandom_probability(card, 'upgrade_wheel', card.ability.num, card.ability.denom, 'upgrade_wheel') then
            local eligible_jokers = {}
            for k, v in ipairs(G.jokers.cards) do
                if BTD.get_tower_upgrade(v, nil, nil, nil, 0, 1) ~= nil then
                    table.insert(eligible_jokers, v)
                end
            end
            for k, v in ipairs(eligible_jokers) do
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    local start_joker = v
                    local end_key = BTD.get_tower_upgrade(start_joker, nil, nil, nil, 0, 1)
                    if end_key then
                        BTD.upgrade_tower(start_joker, end_key, nil)
                    end
                    return true
                end
            }))
        end
        else
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    attention_text({
                        text = localize('k_nope_ex'),
                        scale = 1.3,
                        hold = 1.4,
                        major = card,
                        backdrop_colour = G.C.PALE_GREEN,
                        align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and 'tm' or 'cm',
                        offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0},
                        silent = true
                    }) 
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.06*G.SETTINGS.GAMESPEED,
                        blockable = false,
                        blocking = false,
                        func = function()
                            play_sound('tarot2', 0.76, 0.4);
                            return true
                        end
                    }))
                    play_sound('tarot2', 1, 0.4)
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end
    end
}

SMODS.Consumable { --$5 Select Upgrade
    key = 'upgrade_select',
    set = 'Upgrade',
    name = 'Custom Construction',
    atlas = 'Consumable',
    pos = { x = 10, y = 4 },
    config = { max_highlighted = 1, money = 5 },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.money, card.ability.max_highlighted } }
    end,
    can_use = function(self, card)
        return 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and BTD.get_tower_upgrade(G.jokers.highlighted[1], nil, nil, nil, 0, 1) ~= nil and G.GAME.dollars >= card.ability.money
    end,
    use = function(self, card, area)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local start_joker = G.jokers.highlighted[1]
                local end_key = BTD.get_tower_upgrade(start_joker, nil, nil, nil, 0, 1)
                if end_key then
                    BTD.upgrade_tower(start_joker, end_key, nil)
                    ease_dollars(-card.ability.money, true)
                end
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
    pos = { x = 11, y = 4 },
    config = { max_highlighted = 1 },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,
    can_use = function(self, card)
        return 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and BTD.get_tower_upgrade(G.jokers.highlighted[1], nil, nil, nil, 0, -1) ~= nil
    end,
    use = function(self, card, area)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local start_joker = G.jokers.highlighted[1]
                local end_key = BTD.get_tower_upgrade(start_joker, nil, nil, nil, 0, -1)
                if end_key then
                    BTD.upgrade_tower(start_joker, end_key, nil)
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
    pos = { x = 12, y = 4 },
    config = { max_highlighted = 1, tiers = 2 },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted, card.ability.tiers } }
    end,
    can_use = function(self, card)
        local usable = 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and not SMODS.is_eternal(G.jokers.highlighted[1], card)
        for k, v in ipairs(G.jokers.cards) do
            if v == G.jokers.highlighted[1] then
                return usable and k < #G.jokers.cards and BTD.get_tower_upgrade(G.jokers.cards[k+1], nil, nil, nil, 0, card.ability.tiers) ~= nil
            end
        end
        return false
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
                local end_key = BTD.get_tower_upgrade(start_joker, nil, nil, nil, 0, card.ability.tiers)
                if end_key then
                    BTD.upgrade_tower(start_joker, end_key, nil)
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

SMODS.Consumable { --T5 Upgrade
    key = 'upgrade_ultimate',
    set = 'Upgrade',
    name = 'Ultimate Power',
    atlas = 'Consumable',
    pos = { x = 13, y = 4 },
    config = { max_highlighted = 1 },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,
    can_use = function(self, card)
        return 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and BTD.get_tower_upgrade(G.jokers.highlighted[1], nil, true, nil, 0, 1) ~= nil
    end,
    use = function(self, card, area)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local start_joker = G.jokers.highlighted[1]
                local end_key = BTD.get_tower_upgrade(start_joker, nil, true, nil, 0, 1)
                if end_key then
                    BTD.upgrade_tower(start_joker, end_key, nil)
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
    soul_rate = .006,
    pos = { x = 14, y = 4 },
    config = { max_highlighted = 1 },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,
    can_use = function(self, card)
        return 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and BTD.get_tower_upgrade(G.jokers.highlighted[1], nil, true, nil, 0, 5) ~= nil
    end,
    use = function(self, card, area)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local start_joker = G.jokers.highlighted[1]
                local end_key = BTD.get_tower_upgrade(start_joker, nil, true, nil, 0, 5)
                if end_key then
                    BTD.upgrade_tower(start_joker, end_key, nil)
                end
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
    end
}
