JokerDisplay.Definitions["j_bloons_apex_plasma_master"] = { --Apex Plasma Master
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
        { ref_table = "card.joker_display_values", ref_value = "counter" },
        { text = ")" }
    },
    calc_function = function(card)
        local limit = card.ability.extra.limit
        local counter = card.ability.extra.counter
        local playing_hand = next(G.play.cards)
        if playing_hand then
            card.joker_display_values.Xmult = card.joker_display_values and card.joker_display_values.Xmult or 1
            card.joker_display_values.counter = counter > 1 and counter .. " remaining" or "Next!"
            return
        end
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= "Unknown" and type(scoring_hand) == "table" then
            for _, scoring_card in pairs(scoring_hand) do
                count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
            end
        end
        local activations = math.floor((count + limit - counter) / limit)
        card.joker_display_values.Xmult = card.ability.extra.current + (2 * card.ability.extra.Xmult + (activations - 1) * card.ability.extra.Xmult_scaling) * activations / 2
        card.joker_display_values.counter = counter > 1 and counter .. " remaining" or "Next!"
    end
}

JokerDisplay.Definitions["j_bloons_glaive_dominus"] = { --Glaive Dominus
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current" }
            }
        }
    }
}

JokerDisplay.Definitions["j_bloons_crucible_of_steel_and_flame"] = { --Crucible of Steel and Flame
}

JokerDisplay.Definitions["j_bloons_nautic_siege_core"] = { --Nautic Siege Core
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "charge" },
        { text = "/" },
        { ref_table = "card.ability.extra", ref_value = "hands" },
        { text = ")" },
    },
    calc_function = function(card)
        local charged = card.ability.extra.charge == 0 and not card.ability.extra.submerged
        card.joker_display_values.Xmult = charged and 6 or not card.ability.extra.submerged and 2 or 1
        card.joker_display_values.active = card.ability.extra.submerged and "Submerged" or "Unsubmerged"
    end
}

JokerDisplay.Definitions["j_bloons_goliath_doomship"] = { --Goliath Doomship
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.joker_display_values", ref_value = "money", colour = G.C.MONEY, retrigger_type = "mult" },
        { text = " +", colour = G.C.SECONDARY_SET.Tarot },
        { ref_table = "card.joker_display_values", ref_value = "tarots", colour = G.C.SECONDARY_SET.Tarot },
        { text = " +", colour = G.C.SECONDARY_SET.Planet },
        { ref_table = "card.joker_display_values", ref_value = "planets", colour = G.C.SECONDARY_SET.Planet },
    },
    reminder_text = {
        { text = "(Ace)" }
    },
    calc_function = function(card)
        local held_count, scoring_count = 0, 0
        local highlighted_aces = {}
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local playing_hand = next(G.play.cards)
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:get_id() == 14 then
                    scoring_count = scoring_count + JokerDisplay.calculate_card_triggers(scoring_card, nil, true)
                end
            end
        end
        for _, hand_card in pairs(G.hand.cards) do
            if hand_card:get_id() == 14 and not (hand_card.facing == 'back') and not hand_card.debuff then
                if hand_card.highlighted then
                    if not playing_hand then
                        table.insert(highlighted_aces, hand_card)
                    end
                else
                    held_count = held_count + JokerDisplay.calculate_card_triggers(hand_card, nil, true)
                end
            end
        end

        card.joker_display_values.money = card.ability.extra.money * scoring_count
        card.joker_display_values.tarots = #highlighted_aces
        card.joker_display_values.planets = held_count
    end,
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        return (playing_card:get_id() == 14) and
            joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
    end
}

JokerDisplay.Definitions["j_bloons_magus_perfectus"] = { --Magus Perfectus
}

JokerDisplay.Definitions["j_bloons_ascended_shadow"] = { --Ascended Shadow
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
            }
        }
    },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local stickied = false
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card.ability.ascended_shadow then
                    stickied = true
                end
            end
        end
        card.joker_display_values.Xmult = stickied and card.ability.extra.Xmult or 1
    end
}

JokerDisplay.Definitions["j_bloons_mega_massive_munitions_factory"] = { --Mega Massive Munitions Factory
    text = {
        { text = "(", colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 },
        { ref_table = "card.ability.extra", ref_value = "mines", colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 },
        { text = " mines)", colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        local counter = card.ability.extra.counter
        local limit = card.ability.extra.limit

        card.joker_display_values.active =
            (counter % limit == limit - 1 and "Next!") or ((limit - (counter % limit) - 1) .. " remaining")
    end
}

JokerDisplay.Definitions["j_bloons_master_builder"] = { --Master Builder
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current", retrigger_type = "exp" }
            }
        }
    },
}

JokerDisplay.Definitions["j_bloons_vengeful_true_sun_god"] = { --Vengeful True Sun God
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "sacrifices" },
        { text = ")" },
    },
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        local retrigger = math.floor(joker_card.ability.extra.sacrifices['military'] * 2 / 9)
        return joker_card.ability.extra.retrigger * retrigger * JokerDisplay.calculate_joker_triggers(joker_card)
    end,
    calc_function = function(card)
        local sacs = card.ability.extra.sacrifices
        card.joker_display_values.sacrifices =
            (sacs["primary"] or 0) .. " " ..
            (sacs["military"] or 0) .. " " ..
            (sacs["magic"] or 0) .. " " ..
            (sacs["support"] or 0)
    end
}
