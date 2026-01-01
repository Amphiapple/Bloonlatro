JokerDisplay.Definitions["j_bloons_bomb"] = { --Bomb Shooter
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { text = "Steel", colour = G.C.ORANGE },
        { text = ")" }
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card.ability.name == 'Steel Card' then
                    count = count +
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.Xmult = card.ability.extra.Xmult ^ count
    end,
}

JokerDisplay.Definitions["j_bloons_missile"] = { --Missile launcher
    text = {
        { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
        { text = "x", scale = 0.35 },
        { text = "$", colour = G.C.MONEY },
        { ref_table = "card.ability.extra", ref_value = "money", colour = G.C.MONEY }
    },
    reminder_text = {
        { text = "(4)"}
    },
    extra = {
        {
            { text = "(", colour = G.C.GREEN, scale = 0.3 },
            { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
            { text = ")", colour = G.C.GREEN, scale = 0.3 },
        }
    },
    calc_function = function(card)
        local count = 0
        local hand = G.hand.highlighted
        for _, playing_card in pairs(hand) do
            if playing_card.facing and not (playing_card.facing == 'back') and not playing_card.debuff and playing_card:get_id() and playing_card:get_id() == 4 then
                count = count + 1
            end
        end
        card.joker_display_values.count = count

        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'missile')
        card.joker_display_values.odds = numerator .. " in " .. denominator
    end
}

JokerDisplay.Definitions["j_bloons_frags"] = { --Frag Bombs
    reminder_text = {
        { text = "(4)"}
    },
    extra = {
        {
            { text = "(", colour = G.C.GREEN, scale = 0.3 },
            { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
            { text = ")", colour = G.C.GREEN, scale = 0.3 },
        }
    },
    calc_function = function(card)
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'frags')
        card.joker_display_values.odds = numerator .. " in " .. denominator
    end
}

JokerDisplay.Definitions["j_bloons_mauler"] = { --MOAB Mauler
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "active_text" },
    },
    calc_function = function(card)
        local boss_active = G.GAME and G.GAME.blind and G.GAME.blind.get_type and
            ((not G.GAME.blind.disabled) and (G.GAME.blind:get_type() == 'Boss'))
        card.joker_display_values.active = boss_active

        card.joker_display_values.Xmult = boss_active and card.ability.extra.Xmult or 1
        card.joker_display_values.active_text = boss_active and "active" or "no boss active"
    end,
    style_function = function(card, text, reminder_text, extra)
        if reminder_text and reminder_text.children[1] and card.joker_display_values then
            reminder_text.children[1].config.colour = card.joker_display_values.active and G.C.GREEN or
                G.C.RED
            reminder_text.children[1].config.scale = card.joker_display_values.active and 0.35 or 0.3
            return true
        end
        return false
    end
}

JokerDisplay.Definitions["j_bloons_blimpact"] = { --Bloon Impact
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "current", colour = G.C.MULT }
    },
    reminder_text = {
        { text = "(" },
        { text = "Stunned", colour = G.C.ORANGE },
        { text = ")" }
    },
}

JokerDisplay.Definitions["j_bloons_blitz"] = { --Bomb Blitz
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        local blind_percent = to_big(G.GAME.chips / G.GAME.blind.chips * 100)
        card.joker_display_values.active = G.GAME and G.GAME.chips and G.GAME.blind.chips and
            blind_percent and blind_percent ~= to_big(0) and blind_percent >= to_big(card.ability.extra.scored_percent)
            and "Active!" or "Inactive"
    end
}