JokerDisplay.Definitions["j_bloons_monkey_ace"] = { --Monkey Ace
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" },
    },
    text_config = { colour = G.C.CHIPS },
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

JokerDisplay.Definitions["j_bloons_rapid_fire"] = { --Rapid Fire
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" },
    },
    text_config = { colour = G.C.CHIPS },
    reminder_text = {
        { text = "(Ace)" }
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:get_id() == 14 then
                    count = count +
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.chips = card.ability.extra.chips * count
    end,
}

JokerDisplay.Definitions["j_bloons_lots_more_darts"] = { --Lots More Darts
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" },
    },
    text_config = { colour = G.C.CHIPS },
    reminder_text = {
        { text = "(Ace)" }
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:get_id() == 14 then
                    count = count +
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.chips = card.ability.extra.chips * count
    end,
}

JokerDisplay.Definitions["j_bloons_fighter_plane"] = { --Fighter Plane
}

JokerDisplay.Definitions["j_bloons_operation_dart_storm"] = { --Operation: Dart Storm
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "current", retrigger_type = "mult" },
    },
    text_config = { colour = G.C.CHIPS },
}

JokerDisplay.Definitions["j_bloons_sky_shredder"] = { --Sky Shredder
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

JokerDisplay.Definitions["j_bloons_exploding_pineapple"] = { --Exploding Pineapple
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "counter" },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.counter = card.ability.extra.hands == 1 and "Next!" or card.ability.extra.hands .. " remaining"
    end,
}

JokerDisplay.Definitions["j_bloons_spy_plane"] = { --Spy Plane
    text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "cards" },
        { text = ")" },
    },
    text_config = { colour = G.C.GREY },
    calc_function = function(card)
        local card_string = (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.id or 11)..
                (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.suit:sub(1,1) or 'D') .. ' ' ..
                (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards-1].base.id or 11) ..
                (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards-1].base.suit:sub(1,1) or 'D')
        card.joker_display_values.cards = card_string
    end,
    
}

JokerDisplay.Definitions["j_bloons_bomber_ace"] = { --Bomber Ace
}

JokerDisplay.Definitions["j_bloons_ground_zero"] = { --Ground Zero
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS }
    },
    calc_function = function(card)
        local active = G.GAME and (G.GAME.current_round.hands_left == 1 and not next(G.play.cards) or G.GAME.current_round.hands_left == 0 and next(G.play.cards))
        card.joker_display_values.chips = active and card.ability.extra.chips or 0
    end
}

JokerDisplay.Definitions["j_bloons_tsar_bomba"] = { --Tsar Bomba
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    calc_function = function(card)
        local active = G.GAME and (G.GAME.current_round.hands_left == 1 and not next(G.play.cards) or G.GAME.current_round.hands_left == 0 and next(G.play.cards))
        card.joker_display_values.chips = active and card.ability.extra.Xmult or 1
    end
}

JokerDisplay.Definitions["j_bloons_sharper_darts"] = { --Sharper Darts
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" },
    },
    text_config = { colour = G.C.MULT },
    calc_function = function(card)
        local playing_hand = next(G.play.cards)
        local mult = 0
        for _, playing_card in ipairs(G.hand.cards) do
            if playing_hand or not playing_card.highlighted then
                if playing_card.facing and not (playing_card.facing == 'back') and not playing_card.debuff and playing_card:get_id() == 14 then
                    mult = mult + card.ability.extra.mult * JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                end
            end
        end
        card.joker_display_values.mult = mult
    end
}

JokerDisplay.Definitions["j_bloons_centered_path"] = { --Centered Path
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "tarots", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.SECONDARY_SET.Tarot },
    calc_function = function(card) 
        local blind_percent = to_big(G.GAME.chips / G.GAME.blind.chips * 100)
        card.joker_display_values.tarots = G.GAME and G.GAME.chips and G.GAME.blind.chips and blind_percent
            and blind_percent >= to_big(card.ability.extra.percent_min) and blind_percent <= to_big(card.ability.extra.percent_max)
            and 1 or 0
    end
}

JokerDisplay.Definitions["j_bloons_neva_miss_targeting"] = { --Neva-miss Targeting
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "tarots", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.SECONDARY_SET.Tarot },
    calc_function = function(card) 
        local blind_percent = to_big(G.GAME.chips / G.GAME.blind.chips * 100)
        card.joker_display_values.tarots = G.GAME and G.GAME.chips and G.GAME.blind.chips and blind_percent
            and blind_percent >= to_big(card.ability.extra.percent_min) and blind_percent <= to_big(card.ability.extra.percent_max)
            and 1 or 0
    end
}

JokerDisplay.Definitions["j_bloons_spectre"] = { --Spectre
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.SECONDARY_SET.Spectral },
    calc_function = function(card) 
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:get_id() == 14 then
                    count = count + 1
                end
            end
        end
        card.joker_display_values.count = count >= card.ability.extra.number and 1 or 0
    end
}

JokerDisplay.Definitions["j_bloons_flying_fortress"] = { --Flying Fortress
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
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local count = 0
        if text ~= 'Unknown' then
            for _, scoring_card in ipairs(scoring_hand) do
                if not scoring_card.debuff and scoring_card:get_id() == 14 then
                    count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        for _, playing_card in ipairs(G.hand.cards) do
            if playing_hand or not playing_card.highlighted then
                if playing_card.facing and not (playing_card.facing == 'back') and not playing_card.debuff and playing_card:get_id() == 14 then
                    count = count + JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                end
            end
        end
        card.joker_display_values.Xmult = card.ability.extra.Xmult ^ count
    end
}
