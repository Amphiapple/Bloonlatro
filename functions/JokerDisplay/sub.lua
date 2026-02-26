JokerDisplay.Definitions["j_bloons_monkey_sub"] = { --Monkey Sub
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
    },
    calc_function = function(card)
        local playing_hand = next(G.play.cards)
        local mult = 0
        for _, playing_card in ipairs(G.hand.cards) do
            if playing_hand or not playing_card.highlighted then
                if playing_card.facing and not (playing_card.facing == 'back') and not playing_card.debuff then
                    mult = mult + card.ability.extra.mult * JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                end
            end
        end
        card.joker_display_values.mult = mult * (G.GAME.subcom_mult or 1)
    end
}

JokerDisplay.Definitions["j_bloons_longer_range"] = { --Longer Range
}

JokerDisplay.Definitions["j_bloons_advanced_intel"] = { --Advanced Intel
}

JokerDisplay.Definitions["j_bloons_submerge_and_support"] = { --Submerge and Support
}

JokerDisplay.Definitions["j_bloons_bloontonium_reactor"] = { --Bloontonium Reactor
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult", colour = G.C.CHIPS },
    },
    calc_function = function(card)
        card.joker_display_values.chips = card.ability.extra.current * (G.GAME.subcom_mult or 1)
    end
}

JokerDisplay.Definitions["j_bloons_energizer"] = { --Energizer
}

JokerDisplay.Definitions["j_bloons_barbed_darts"] = { --Barbed Darts
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
    },
    calc_function = function(card)
        local playing_hand = next(G.play.cards)
        local mult = 0
        for _, playing_card in ipairs(G.hand.cards) do
            if playing_hand or not playing_card.highlighted then
                if playing_card.facing and not (playing_card.facing == 'back') and not playing_card.debuff then
                    mult = mult + card.ability.extra.mult * JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                end
            end
        end
        card.joker_display_values.mult = mult * (G.GAME.subcom_mult or 1)
    end
}

JokerDisplay.Definitions["j_bloons_heat_tipped_darts"] = { --Heat-tipped Darts
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult", colour = G.C.CHIPS },
    },
    calc_function = function(card)
        local playing_hand = next(G.play.cards)
        local chips = 0
        for _, playing_card in ipairs(G.hand.cards) do
            if playing_hand or not playing_card.highlighted then
                if playing_card.facing and not (playing_card.facing == 'back') and not playing_card.debuff then
                    chips = chips + card.ability.extra.chips * JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                end
            end
        end
        card.joker_display_values.chips = chips * (G.GAME.subcom_mult or 1)
    end
}

JokerDisplay.Definitions["j_bloons_ballistic_missile"] = { --Ballistic Missile
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    calc_function = function(card)
        local held_cards = {}
        for i = 1, #G.hand.cards do
            local hand_card = G.hand.cards[i]
            if not hand_card.highlighted and hand_card.facing ~= 'back' then
                table.insert(held_cards, hand_card)
            end
        end
        local max = 1
        local idx_by_id = {}
        for k, v in ipairs(held_cards) do
            local id = v:get_id()
            if idx_by_id[id] then
                idx_by_id[id] = idx_by_id[id] + 1
                if idx_by_id[id] > max then
                    max = idx_by_id[id]
                end
            else
                idx_by_id[id] = 1
            end
        end
        card.joker_display_values.Xmult = max > 1 and max * card.ability.extra.Xmult * (G.GAME.subcom_mult or 1) or 1
    end
}

JokerDisplay.Definitions["j_bloons_first_strike_capability"] = { --First Strike Capability
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    calc_function = function(card)
        card.joker_display_values.Xmult = card.ability.extra.current * (G.GAME.subcom_mult or 1)
    end
}

JokerDisplay.Definitions["j_bloons_pre_emptive_strike"] = { --Pre-emptive Strike
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    calc_function = function(card)
        card.joker_display_values.Xmult = card.ability.extra.Xmult * (G.GAME.subcom_mult or 1)
    end
}

JokerDisplay.Definitions["j_bloons_twin_guns"] = { --Twin Guns
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
    },
    calc_function = function(card)
        local held_cards = {}
        for i = 1, #G.hand.cards do
            local hand_card = G.hand.cards[i]
            if not hand_card.highlighted and hand_card.facing ~= 'back' then
                table.insert(held_cards, hand_card)
            end
        end
        local count = 0
        local idx_by_id = {}
        for k, v in ipairs(held_cards) do
            local id = v:get_id()
            if idx_by_id[id] then
                count = count + JokerDisplay.calculate_card_triggers(v, nil, true)
                idx_by_id[id] = nil
            else
                idx_by_id[id] = k
            end
        end
        card.joker_display_values.mult = count * card.ability.extra.mult * (G.GAME.subcom_mult or 1)
    end
}

JokerDisplay.Definitions["j_bloons_airburst_darts"] = { --Airburst Darts
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", colour = G.C.MULT },
    },
    calc_function = function(card)
        card.joker_display_values.mult = card.ability.extra.current * (G.GAME.subcom_mult or 1)
    end
}

JokerDisplay.Definitions["j_bloons_triple_guns"] = { --Triple guns
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    calc_function = function(card)
        card.joker_display_values.Xmult = card.ability.extra.current * (G.GAME.subcom_mult or 1)
    end
}

JokerDisplay.Definitions["j_bloons_armor_piercing_darts"] = { --Armor Piercing Darts
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    calc_function = function(card)
        local held_cards = {}
        for i = 1, #G.hand.cards do
            local hand_card = G.hand.cards[i]
            if not hand_card.highlighted and hand_card.facing ~= 'back' then
                table.insert(held_cards, hand_card)
            end
        end
        local count = 0
        local idx_by_id = {}
        for k, v in ipairs(held_cards) do
            local id = v:get_id()
            if idx_by_id[id] then
                idx_by_id[id] = idx_by_id[id] + 1
            else
                idx_by_id[id] = 1
            end
            if idx_by_id[id] == 3 then
                count = count + JokerDisplay.calculate_card_triggers(v, nil, true)
                idx_by_id[id] = 0
            end
        end
        card.joker_display_values.Xmult = card.ability.extra.Xmult ^ (count * (G.GAME.subcom_mult or 1))
    end
}

JokerDisplay.Definitions["j_bloons_sub_commander"] = { --Sub Commander
}