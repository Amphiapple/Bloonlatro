
SMODS.Consumable { --Volcano
    key = 'volcano',
    set = 'Spectral',
    name = 'Volcano',
    atlas = 'Consumable',
    cost = 4,
    pos = { x = 0, y = 5 },
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
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                local card = destroyed_card
                if SMODS.shatters(card) then
                    card:shatter()
                else
                    card:start_dissolve()
                end
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.9,
            func = function()
                for k, v in pairs(volcano_cards) do
                    v:set_ability('m_bloons_meteor', nil, true)
                    v:juice_up()
                end
                SMODS.calculate_context({ remove_playing_cards = true, removed = { destroyed_card } })
                return true
            end
        }))
    end
}

SMODS.Consumable { --Thunder
    key = 'thunder',
    set = 'Spectral',
    name = 'Thunder',
    atlas = 'Consumable',
    cost = 4,
    pos = { x = 1, y = 5 },
    config = { number = 3 },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_foil
        info_queue[#info_queue + 1] = G.P_CENTERS.e_holo
        info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_stunned
        return { vars = { card.ability.number } }
    end,
    can_use = function(self, card)
        return G.hand and #G.hand.cards > 0
    end,
    use = function(self, card, area)
        local shocked_cards = {}
        local temp_hand = {}
        for k, v in ipairs(G.hand.cards) do
            if not v.edition then
                temp_hand[#temp_hand+1] = v
            end
        end
        table.sort(temp_hand, function (a, b) return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card end)
        pseudoshuffle(temp_hand, pseudoseed('thunder'))
        for i = 1, card.ability.number do
            shocked_cards[#shocked_cards+1] = temp_hand[i]
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                for k, v in ipairs(shocked_cards) do
                    local edition = poll_edition('thunder', nil, true, true)
                    v:set_edition(edition, true)
                    v:set_ability(G.P_CENTERS.m_bloons_stunned, nil, true)
                    end
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
    end
}

SMODS.Consumable { --Paragon
    key = 'paragon',
    set = 'Spectral',
    name = 'Paragon',
    atlas = 'Consumable',
    cost = 4,
    hidden = true,
    soul_set = 'Upgrade',
    soul_rate = .003,
    pos = { x = 14, y = 5 },
    config = { max_highlighted = 1 },

    can_use = function(self, card)
        return 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and get_tower_upgrade(G.jokers.highlighted[1], true, nil, 0, 1) ~= nil
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
                local end_key = get_tower_upgrade(start_joker, true, nil, 0, 1)
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
