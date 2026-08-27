JokerDisplay.Definitions["j_bloons_skywarden"] = { --Skywarden
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current" }
    },
    text_config = { colour = G.C.MULT },
}

JokerDisplay.Definitions["j_bloons_aerial_attunement"] = { --Aerial Attunement
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current" }
    },
    text_config = { colour = G.C.MULT },
}

JokerDisplay.Definitions["j_bloons_zephyr_sense"] = { --Zephyr Sense
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current" }
    },
    text_config = { colour = G.C.MULT },
}

JokerDisplay.Definitions["j_bloons_wind_weaver"] = { --Wind Weaver
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        if not next(G.play.cards) then
            joker_card.joker_display_values.count = joker_card.ability.extra.current
        end
        local count = joker_card.joker_display_values.count or 0
        local sorted_cards = JokerDisplay.sort_cards(scoring_hand)
        for k, v in ipairs(sorted_cards) do
            if v == playing_card then
                break
            end
            count = count + JokerDisplay.calculate_card_triggers(v, scoring_hand)
        end
        return count >= joker_card.ability.extra.retrigger_limit - 1 and
                joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}

JokerDisplay.Definitions["j_bloons_galesage"] = { --Galesage
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        return #scoring_hand == 5 and
                joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}

JokerDisplay.Definitions["j_bloons_farwind_seer"] = { --Farwind Seer
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        return joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card)
    end
}

JokerDisplay.Definitions["j_bloons_storms_pulse"] = { --Storm's Pulse
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current" }
    },
    text_config = { colour = G.C.MULT },
}

JokerDisplay.Definitions["j_bloons_thundering_arc"] = { --Thundering Arc
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current" }
    },
    text_config = { colour = G.C.MULT },
}

JokerDisplay.Definitions["j_bloons_galvanic_conduit"] = { --Galvanic Conduit
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult" }
    },
    text_config = { colour = G.C.MULT },
    calc_function = function(card)
        if not next(G.play.cards) then
            card.joker_display_values.count = card.ability.extra.current
        end
        local current = card.joker_display_values.count or 0
        current = current + 1
        local mult = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            local sorted_cards = JokerDisplay.sort_cards(scoring_hand)
            for k, v in ipairs(sorted_cards) do
                local triggers = JokerDisplay.calculate_card_triggers(v, scoring_hand)
                mult = mult + (2 * current + triggers - 1) * triggers / 2
                current = current + triggers
            end
        end
        card.joker_display_values.mult = mult
    end
}

JokerDisplay.Definitions["j_bloons_thunders_decree"] = { --Thunder's Decree
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if SMODS.has_enhancement(scoring_card, 'm_bloons_stunned') and not scoring_card.debuff then
                    count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
            local last_card = JokerDisplay.calculate_rightmost_card(scoring_hand)
            if last_card and not SMODS.has_enhancement(last_card, 'm_bloons_stunned') and not last_card.debuff then
                count = count + JokerDisplay.calculate_card_triggers(last_card, scoring_hand)
            end
        end
        card.joker_display_values.Xmult = card.ability.extra.Xmult ^ count
    end
}

JokerDisplay.Definitions["j_bloons_stormwrath_archon"] = { --Stormwrath Archon
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT },
        { text = " ", colour = G.C.MULT },
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    calc_function = function(card)
        local mult_count = 0
        local stunned_count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            local sorted_cards = JokerDisplay.sort_cards(scoring_hand)
            for k, v in ipairs(sorted_cards) do
                local triggers = JokerDisplay.calculate_card_triggers(v, scoring_hand)
                local left = sorted_cards[k-1]
                local right = sorted_cards[k+1]
                if left and SMODS.has_enhancement(left, 'm_bloons_stunned') and not left.debuff or
                    right and SMODS.has_enhancement(right, 'm_bloons_stunned') and not right.debuff then
                    mult_count = mult_count + triggers
                end
                if SMODS.has_enhancement(v, 'm_bloons_stunned') and not v.debuff then
                    stunned_count = stunned_count + 1
                end
            end
        end
        card.joker_display_values.mult = card.ability.extra.mult * mult_count
        card.joker_display_values.Xmult = card.ability.extra.Xmult ^ stunned_count
    end
}

JokerDisplay.Definitions["j_bloons_shatterpoint"] = { --Shatterpoint
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "mult" }
    },
    text_config = { colour = G.C.MULT },
    reminder_text = {
        { text = "(2, 3, 4, 5)" },
    }
}

JokerDisplay.Definitions["j_bloons_icebore"] = { --Icebore
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult" }
    },
    text_config = { colour = G.C.MULT },
    calc_function = function(card)
        local playing_hand = next(G.play.cards)
        local mult = card.ability.extra.mult
        for _, playing_card in ipairs(G.hand.cards) do
            if playing_hand or not playing_card.highlighted then
                if playing_card.facing and not (playing_card.facing == 'back') and SMODS.has_enhancement(playing_card, 'm_bloons_frozen') and not playing_card.debuff then
                    mult = mult + card.ability.extra.frozen_mult * JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                end
            end
        end
        card.joker_display_values.mult = mult
    end
}

JokerDisplay.Definitions["j_bloons_coldchain"] = { --Coldchain
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "chips" }
    },
    text_config = { colour = G.C.CHIPS },
    calc_function = function(card)
        if not next(G.play.cards) then
            card.joker_display_values.count = card.ability.extra.current or 0
        end
        local current = card.joker_display_values.count or 0
        current = current + 1
        local chips = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            local sorted_cards = JokerDisplay.sort_cards(scoring_hand)
            for k, v in ipairs(sorted_cards) do
                local triggers = JokerDisplay.calculate_card_triggers(v, scoring_hand)
                chips = chips + (2 * current + triggers - 1) * triggers / 2 * 6
                current = current + triggers
            end
        end
        card.joker_display_values.chips = chips
    end
}

JokerDisplay.Definitions["j_bloons_frozen_verdict"] = { --Frozen Verdict
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current" }
            }
        }
    },
}

JokerDisplay.Definitions["j_bloons_winters_mercy"] = { --Winter's Mercy
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current" }
            }
        }
    },
}

