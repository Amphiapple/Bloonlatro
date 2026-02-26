JokerDisplay.Definitions["j_bloons_mermonkey"] = { --Mermonkey
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current", retrigger_type = "mult", },
    },
    text_config = { colour = G.C.MULT },
}

JokerDisplay.Definitions["j_bloons_trident_efficiency"] = { --Trident Efficiency
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current", retrigger_type = "mult", },
    },
    text_config = { colour = G.C.MULT },
}

JokerDisplay.Definitions["j_bloons_trident_swiftness"] = { --Trident Swiftness
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current", retrigger_type = "mult", },
    },
    text_config = { colour = G.C.MULT },
}

JokerDisplay.Definitions["j_bloons_abyss_dweller"] = { --Abyss Dweller
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult", },
    },
    text_config = { colour = G.C.MULT },
    calc_function = function(card)
        local count = 0
        if card ~= G.jokers.cards[1] then
            count = count + 1
        end
        if card ~= G.jokers.cards[#G.jokers.cards] then
            count = count + 1
        end
        card.joker_display_values.mult = card.ability.extra.mult * count
    end
}

JokerDisplay.Definitions["j_bloons_abyssal_warrior"] = { --Abyssal Warrior
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
            }
        }
    },
    calc_function = function(card)
        local count = 1
        if card ~= G.jokers.cards[1] then
            count = count + 1
        end
        if card ~= G.jokers.cards[#G.jokers.cards] then
            count = count + 1
        end
        card.joker_display_values.Xmult = card.ability.extra.Xmult ^ count
    end
}

JokerDisplay.Definitions["j_bloons_lord_of_the_abyss"] = { --Lord of the Abyss
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult", retrigger_type = "exp" }
            }
        }
    },
    reminder_text = {
        { text = "(per trigger)" },
    },
}

JokerDisplay.Definitions["j_bloons_sharper_prongs"] = { --Sharper Prongs
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current", retrigger_type = "mult", },
    },
    text_config = { colour = G.C.CHIPS },
}

JokerDisplay.Definitions["j_bloons_tidal_chill"] = { --Tidal Chill
}

JokerDisplay.Definitions["j_bloons_riptide_champion"] = { --Riptide Champion
}

JokerDisplay.Definitions["j_bloons_arctic_knight"] = { --Arctic Knight
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'arknight')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { n, d } }
    end
}

JokerDisplay.Definitions["j_bloons_popseidon"] = { --Popseidon
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "chips" }
    },
    text_config = { colour = G.C.CHIPS },
    calc_function = function(card)
        local playing_hand = next(G.play.cards)
        local count = 0
        for _, playing_card in ipairs(G.hand.cards) do
            if playing_hand or not playing_card.highlighted then
                if not (playing_card.facing == 'back') and not playing_card.debuff and playing_card.ability and playing_card.ability.name == 'Frozen Card' then
                    count = count + JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                end
            end
        end
        card.joker_display_values.chips = card.ability.extra.chips * count
    end
}

JokerDisplay.Definitions["j_bloons_echosense_precision"] = { --Echosense Precision
}

JokerDisplay.Definitions["j_bloons_echosense_network"] = { --Echosense Network
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current", retrigger_type = "mult", },
    },
    text_config = { colour = G.C.MULT },
}

JokerDisplay.Definitions["j_bloons_alluring_melody"] = { --Alluring Melody
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current", retrigger_type = "mult", },
    },
    text_config = { colour = G.C.MULT },
}

JokerDisplay.Definitions["j_bloons_symphonic_resonance"] = { --Symphonic Resonance
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current", retrigger_type = "exp" }
            }
        }
    },
}

JokerDisplay.Definitions["j_bloons_the_final_harmonic"] = { --The Final Harmonic
}
