JokerDisplay.Definitions["j_bloons_ace"] = { --Monkey Ace
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult", colour = G.C.CHIPS },
    },
    reminder_text = {
        { text = "(Ace)"}
    },
    calc_function = function(card)
        local playing_hand = next(G.play.cards)
        local chips = 0
        for _, playing_card in ipairs(G.hand.cards) do
            if playing_hand or not playing_card.highlighted then
                if playing_card.facing and not (playing_card.facing == 'back') and not playing_card.debuff and playing_card:get_id() == 14 then
                    chips = chips + card.ability.extra.chips * JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                end
            end
        end
        card.joker_display_values.chips = chips
    end
}

JokerDisplay.Definitions["j_bloons_pineapple"] = { --Exploding Pineapple
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "counter" },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.counter = card.ability.extra.hands == 1 and "Next!" or card.ability.extra.hands .. " remaining"
    end,
}

JokerDisplay.Definitions["j_bloons_nevamiss"] = { --Nevamiss Targeting
    text = {
        { text = "+", colour = G.C.SECONDARY_SET.Tarot },
        { ref_table = "card.joker_display_values", ref_value = "tarots", colour = G.C.SECONDARY_SET.Tarot }
    },
    calc_function = function(card) 
        local blind_percent = to_big(G.GAME.chips / G.GAME.blind.chips * 100)
        card.joker_display_values.tarots = G.GAME and G.GAME.chips and G.GAME.blind.chips and blind_percent
            and blind_percent >= to_big(card.ability.extra.percent_min) and blind_percent <= to_big(card.ability.extra.percent_max)
            and 1 or 0
    end
}

JokerDisplay.Definitions["j_bloons_gz"] = { --Ground Zero
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS }
    },
    calc_function = function(card)
        card.joker_display_values.chips = G.GAME.current_round.hands_played == 0 and card.ability.extra.chips or 0
    end
}

JokerDisplay.Definitions["j_bloons_shredder"] = { --Sky Shredder
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "current" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "counter" },
        { text = "/" },
        { ref_table = "card.ability.extra", ref_value = "limit" },
        { text = " Aces)" },
    },
}