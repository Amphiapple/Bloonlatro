JokerDisplay.Definitions["j_bloons_super_monkey"] = { --Super Monkey
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult", },
    },
    text_config = { colour = G.C.MULT },
}

JokerDisplay.Definitions["j_bloons_laser_blasts"] = { --Laser Blasts
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult", },
    },
    text_config = { colour = G.C.MULT },
}

JokerDisplay.Definitions["j_bloons_plasma_blasts"] = { --Plasma Blasts
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult", retrigger_type = "exp" }
            }
        }
    },
}

JokerDisplay.Definitions["j_bloons_sun_avatar"] = { --Sun Avatar
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
    calc_function = function(card)
        local text, _, _ = JokerDisplay.evaluate_hand()
        local playing_hand = next(G.play.cards)
        local red_suits = 0
        local is_all_red_suits = false
        if playing_hand then
            for _, playing_card in ipairs(G.play.cards) do
                if playing_card:is_suit('Hearts', nil, true) or playing_card:is_suit('Diamonds', nil, true) then
                    red_suits = red_suits + 1
                end
            end
            is_all_red_suits = red_suits > 0 and red_suits == #G.play.cards
        elseif text ~= 'Unknown' then
            for _, playing_card in ipairs(G.hand.cards) do
                if playing_card.highlighted and playing_card.facing and not (playing_card.facing == 'back') and (playing_card:is_suit('Hearts', nil, true) or playing_card:is_suit('Diamonds', nil, true)) then
                    red_suits = red_suits + 1
                end
            end
            is_all_red_suits = red_suits > 0 and red_suits == #G.hand.highlighted
        end
        card.joker_display_values.x_mult = is_all_red_suits and card.ability.extra.Xmult or 1
    end
}

JokerDisplay.Definitions["j_bloons_sun_temple"] = { --Sun Temple
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current", retrigger_type = "exp" }
            }
        }
    },
}

JokerDisplay.Definitions["j_bloons_true_sun_god"] = { --True Sun God
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current", retrigger_type = "exp" }
            }
        }
    },
}

JokerDisplay.Definitions["j_bloons_super_range"] = { --Super Range
}

JokerDisplay.Definitions["j_bloons_epic_range"] = { --Epic Range
}

JokerDisplay.Definitions["j_bloons_robo_monkey"] = { --Robo Monkey
    calc_function = function(card)
        local copied_joker, copied_debuff = JokerDisplay.calculate_blueprint_copy(card)
        JokerDisplay.copy_display(card, copied_joker, copied_debuff)
    end,
    get_blueprint_joker = function(card)
        return card.ability.extra.copy
    end
}

JokerDisplay.Definitions["j_bloons_tech_terror"] = { --Tech Terror
    calc_function = function(card)
        local copied_joker, copied_debuff = JokerDisplay.calculate_blueprint_copy(card)
        JokerDisplay.copy_display(card, copied_joker, copied_debuff)
    end,
    get_blueprint_joker = function(card)
        return card.ability.extra.copy
    end
}

JokerDisplay.Definitions["j_bloons_the_anti_bloon"] = { --The Anti-Bloon
    text = {
        { text = "(", colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 },
        { ref_table = "card.joker_display_values", ref_value = "blueprint_compat", colour = G.C.RED, scale = 0.3 },
        { text = ")", colour = G.C.UI.TEXT_INACTIVE, scale = 0.3 }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "copy_pos", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local copied_joker, copied_debuff = JokerDisplay.calculate_blueprint_copy(card)
        card.joker_display_values.blueprint_compat = localize('k_incompatible')
        card.joker_display_values.copy_pos = card.ability.extra.current == 1 and 'right' or 'left'
        JokerDisplay.copy_display(card, copied_joker, copied_debuff)
    end,
    get_blueprint_joker = function(card)
        local other_joker = nil
        for k, v in ipairs(G.jokers.cards) do
            if G.jokers.cards[k] == card then other_joker = G.jokers.cards[k + card.ability.extra.current] end
        end
        return other_joker
    end
}

JokerDisplay.Definitions["j_bloons_knockback"] = { --Knockback
    retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
        if held_in_hand then return 0 end
        local _, _, scoring_hand = JokerDisplay.evaluate_hand()
        local sorted_cards = JokerDisplay.sort_cards(scoring_hand)
        for k, v in ipairs(sorted_cards) do
            if playing_card == v then
                return k % 2 == 0 and joker_card.ability.extra.retrigger * JokerDisplay.calculate_joker_triggers(joker_card) or 0
            end
        end
    end
}

JokerDisplay.Definitions["j_bloons_ultravision"] = { --Ultravision
}

JokerDisplay.Definitions["j_bloons_dark_knight"] = { --Dark Knight
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
            }
        }
    },
    calc_function = function(card)
        local playing_hand = next(G.play.cards)
        local black_suits, all_cards = 0, 0
        local is_all_black_suits = false
        for _, playing_card in ipairs(G.hand.cards) do
            if playing_hand or not playing_card.highlighted then
                all_cards = all_cards + 1
                if playing_card.facing and not (playing_card.facing == 'back') and (playing_card:is_suit('Clubs', nil, true) or playing_card:is_suit('Spades', nil, true)) then
                    black_suits = black_suits + 1
                end
            end
        end
        is_all_black_suits = black_suits == all_cards
        card.joker_display_values.x_mult = is_all_black_suits and card.ability.extra.Xmult or 1
    end
}

JokerDisplay.Definitions["j_bloons_dark_champion"] = { --Dark Champion
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
        local count = 0
        for _, playing_card in ipairs(G.hand.cards) do
            if playing_hand or not playing_card.highlighted then
                if playing_card.facing and not (playing_card.facing == 'back') and not playing_card.debuff and (playing_card:is_suit('Clubs', nil, true) or playing_card:is_suit('Spades', nil, true)) then
                    count = count + JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                end
            end
        end
        card.joker_display_values.Xmult = card.ability.extra.Xmult ^ count
    end
}

JokerDisplay.Definitions["j_bloons_legend_of_the_night"] = { --Legend of the Night
}