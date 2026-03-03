JokerDisplay.Definitions["j_bloons_ice_monkey"] = { --Ice Monkey
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        if card.ability.extra.counter == card.ability.extra.limit - 1 then
            card.joker_display_values.chips = card.ability.extra.chips
            card.joker_display_values.active = "Active!"
        else
            card.joker_display_values.chips = 0
            card.joker_display_values.active = card.ability.extra.limit - card.ability.extra.counter % card.ability.extra.limit - 1 .. " remaining"
        end
    end
}

JokerDisplay.Definitions["j_bloons_permafrost"] = { --Permafrost
}

JokerDisplay.Definitions["j_bloons_cold_snap"] = { --Cold Snap
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.joker_display_values", ref_value = "money", colour = G.C.MONEY }
    },
    reminder_text = {
        { text = "(" },
        { text = "Frozen", colour = G.C.ORANGE },
        { text = ")" }
    },
    calc_function = function(card)
        local playing_hand = next(G.play.cards)
        if playing_hand then
            card.joker_display_values.Xmult = card.joker_display_values and card.joker_display_values.money or 0
            return
        end
        local count = 0
        for _, playing_card in ipairs(G.hand.cards) do
            if not playing_card.highlighted then
                if not (playing_card.facing == 'back') and not playing_card.debuff and playing_card.ability and playing_card.ability.name == 'Frozen Card' then
                    count = count + JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                end
            end
        end
        card.joker_display_values.money = count * card.ability.extra.money
    end
}

JokerDisplay.Definitions["j_bloons_ice_shards"] = { --Ice Shards
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MULT }
    },
}

JokerDisplay.Definitions["j_bloons_embrittlement"] = { --Embrittlement
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current", retrigger_type = "exp" }
            }
        }
    },
}

JokerDisplay.Definitions["j_bloons_super_brittle"] = { --Super Brittle
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'super_brittle')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { n, d } }
    end
}

JokerDisplay.Definitions["j_bloons_enhanced_freeze"] = { --Enhanced Freeze
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        if card.ability.extra.counter == card.ability.extra.limit - 1 then
            card.joker_display_values.chips = card.ability.extra.chips
            card.joker_display_values.active = "Active!"
        else
            card.joker_display_values.chips = 0
            card.joker_display_values.active = card.ability.extra.limit - card.ability.extra.counter % card.ability.extra.limit - 1 .. " remaining"
        end
    end
}

JokerDisplay.Definitions["j_bloons_deep_freeze"] = { --Deep Freeze
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'deep_freeze')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { n, d } }
    end
}

JokerDisplay.Definitions["j_bloons_arctic_wind"] = { --Arctic Wind
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        local first_hand = G.GAME and G.GAME.current_round.hands_played == 0
        card.joker_display_values.active = first_hand and localize("jdis_active") or localize("jdis_inactive")
    end
}

JokerDisplay.Definitions["j_bloons_snowstorm"] = { --Snowstorm
    text = {
        { text = "+", colour = G.C.ORANGE },
        { ref_table = "card.joker_display_values", ref_value = "hand_size", colour = G.C.ORANGE },
    },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local first_hand = G.GAME and G.GAME.current_round.hands_played == 0
        card.joker_display_values.hand_size = first_hand and text ~= 'Unknown' and math.ceil(#scoring_hand / 2) or 0
    end
}

JokerDisplay.Definitions["j_bloons_absolute_zero"] = { --Absolute Zero
    text = {
        { text = "+", colour = G.C.SECONDARY_SET.Spectral },
        { ref_table = "card.joker_display_values", ref_value = "spectrals", colour = G.C.SECONDARY_SET.Spectral }
    },
    calc_function = function(card)
        local cards_needed = false
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            cards_needed = #scoring_hand == card.ability.extra.number
        end
        local first_hand = G.GAME and G.GAME.current_round.hands_played == 0
        card.joker_display_values.spectrals = first_hand and cards_needed and 1 or 0
    end
}

JokerDisplay.Definitions["j_bloons_larger_radius"] = { --Larger Radius
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        if card.ability.extra.counter == card.ability.extra.limit - 1 then
            card.joker_display_values.mult = card.ability.extra.mult
            card.joker_display_values.active = "Active!"
        else
            card.joker_display_values.mult = 0
            card.joker_display_values.active = card.ability.extra.limit - card.ability.extra.counter % card.ability.extra.limit - 1 .. " remaining"
        end
    end
}

JokerDisplay.Definitions["j_bloons_re_freeze"] = { --Refreeze
    reminder_text = {
        { text = "(" },
        { text = "Frozen", colour = G.C.ORANGE },
        { text = ")" }
    },
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        local held_cards = {}
        for i = 1, #G.hand.cards do
            if not G.hand.cards[i].highlighted then
                table.insert(held_cards, G.hand.cards[i])
            end
        end
        for _, card in ipairs(held_cards) do
            if card == playing_card and card.ability and card.ability.name == 'Frozen Card' then
                return joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card)
            end
        end
        return 0
    end
}

JokerDisplay.Definitions["j_bloons_cryo_cannon"] = { --Cryo Cannon
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT }
    },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        local playing_hand = next(G.play.cards)
        if playing_hand then
            card.joker_display_values.Xmult = card.joker_display_values and card.joker_display_values.Xmult or 1
            local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'cryo_cannon')
            card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { n, d } }
            return
        end
        local count = 0
        for _, playing_card in ipairs(G.hand.cards) do
            if not playing_card.highlighted then
                if not (playing_card.facing == 'back') and not playing_card.debuff and playing_card.ability and playing_card.ability.name == 'Frozen Card' then
                    count = count + JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                end
            end
        end
        card.joker_display_values.mult = card.ability.extra.mult * count
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'cryo_cannon')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { n, d } }
    end
}

JokerDisplay.Definitions["j_bloons_icicles"] = { --Icicles
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
            }
        }
    },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        local playing_hand = next(G.play.cards)
        if playing_hand then
            card.joker_display_values.Xmult = card.joker_display_values and card.joker_display_values.Xmult or 1
            local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'icicles')
            card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { n, d } }
            return
        end
        local count = 0
        for _, playing_card in ipairs(G.hand.cards) do
            if not playing_card.highlighted then
                if not (playing_card.facing == 'back') and not playing_card.debuff and playing_card.ability and playing_card.ability.name == 'Frozen Card' then
                    count = count + JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                end
            end
        end
        card.joker_display_values.Xmult = card.ability.extra.Xmult ^ count
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'icicles')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { n, d } }
    end
}

JokerDisplay.Definitions["j_bloons_icicle_impale"] = { --Icicle Impale
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
            }
        }
    },
    calc_function = function(card)
        local playing_hand = next(G.play.cards)
        if playing_hand then
            card.joker_display_values.Xmult = card.joker_display_values and card.joker_display_values.Xmult or 1
            return
        end
        local has_frozen = false
        for _, playing_card in ipairs(G.hand.cards) do
            if not playing_card.highlighted then
                if not (playing_card.facing == 'back') and not playing_card.debuff and playing_card.ability and playing_card.ability.name == 'Frozen Card' then
                    has_frozen = true
                end
            end
        end
        card.joker_display_values.Xmult = has_frozen and card.ability.extra.Xmult or 1
    end
}
