JokerDisplay.Definitions["j_bloons_dart_monkey"] = { --Dart Monkey
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
        { text = " +", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT },
    }
}

JokerDisplay.Definitions["j_bloons_sharp_shots"] = { --Sharp Shots
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
        { text = " +", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT },
    }
}

JokerDisplay.Definitions["j_bloons_razor_sharp_shots"] = { --Razor Sharp Shots
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
        { text = " +", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT },
    }
}

JokerDisplay.Definitions["j_bloons_spike_o_pult"] = { --Spike-o-pult
    text = {
        { text = "+", colour = G.C.MULT }, 
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT },
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                count = count +
                    JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
            end
        end
        card.joker_display_values.mult = card.ability.extra.mult * count
    end
}

JokerDisplay.Definitions["j_bloons_juggernaut"] = { --Juggernaut
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT },
    },
    calc_function = function(card)
        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                count = count +
                    JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
            end
        end
        card.joker_display_values.mult = card.ability.extra.mult * (count * (count + 1)) / 2
    end
}

JokerDisplay.Definitions["j_bloons_ultra_juggernaut"] = { --Ultra-Juggernaut
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
                count = count +
                    JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
            end
        end
        local total_Xmult = 1
        for i = 1, count do
            total_Xmult = total_Xmult * (i / 10 + 1)
        end
        card.joker_display_values.Xmult = total_Xmult
    end
}

JokerDisplay.Definitions["j_bloons_quick_shots"] = { --Quick Shots
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
        { text = " +", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT },
    }
}

JokerDisplay.Definitions["j_bloons_very_quick_shots"] = { --Quick Shots
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
        { text = " +", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT },
    }
}

JokerDisplay.Definitions["j_bloons_triple_shot"] = { --Triple shot
    text = {
        { text = "+", colour = G.C.SECONDARY_SET.Tarot },
        { ref_table = "card.joker_display_values", ref_value = "tarots", colour = G.C.SECONDARY_SET.Tarot }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)

        if card.ability.extra.counter == 1 then
            card.joker_display_values.active = "Next!"
            card.joker_display_values.tarots = card.ability.extra.tarots
        else
            card.joker_display_values.active = card.ability.extra.counter .. " remaining"
            card.joker_display_values.tarots = 0
        end
    end
}

JokerDisplay.Definitions["j_bloons_super_monkey_fan_club"] = { --Super Monkey Fan Club
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "count", colour = G.C.ORANGE },
        { text = "x" },
        { text = "Fan Clubs", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local count = 0
        if G.jokers then
            for _, joker_card in ipairs(G.jokers.cards) do
                if joker_card.ability.tower_info and joker_card.ability.tower_info.base and joker_card.ability.tower_info.base == 'Dart Monkey' and
                        joker_card.config.center.rarity and joker_card.config.center.rarity == 1 or
                        joker_card.ability.name == "Triple Shot" or
                        joker_card.ability.name == "Super Monkey Fan Club" or
                        joker_card.ability.name == "Plasma Monkey Fan Club" then
                    count = count + 1
                end
            end
        end
        card.joker_display_values.count = count
    end,
    mod_function = function(card, mod_joker)
        return { x_mult = ((card.ability.tower_info and card.ability.tower_info.base and card.ability.tower_info.base == 'Dart Monkey' and
                card.config.center.rarity and card.config.center.rarity == 1 or card.ability.name == "Triple Shot" or
                card.ability.name == "Super Monkey Fan Club" or card.ability.name == "Plasma Monkey Fan Club") and
                mod_joker.ability.extra.Xmult ^ JokerDisplay.calculate_joker_triggers(mod_joker) or nil) }
    end
}

JokerDisplay.Definitions["j_bloons_plasma_monkey_fan_club"] = { --Plasma Monkey Fan Club
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "count", colour = G.C.ORANGE },
        { text = "x" },
        { text = "Fan Clubs", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local count = 0
        if G.jokers then
            for _, joker_card in ipairs(G.jokers.cards) do
                if joker_card.ability.tower_info and joker_card.ability.tower_info.base and joker_card.ability.tower_info.base == 'Dart Monkey' and
                        joker_card.config.center.rarity and joker_card.config.center.rarity == 1 or
                        joker_card.ability.name == "Triple Shot" or
                        joker_card.ability.name == "Super Monkey Fan Club" or
                        joker_card.ability.name == "Plasma Monkey Fan Club" then
                    count = count + 1
                end
            end
        end
        card.joker_display_values.count = count
    end,
    mod_function = function(card, mod_joker)
        return { x_mult = ((card.ability.tower_info and card.ability.tower_info.base and card.ability.tower_info.base == 'Dart Monkey' and
                card.config.center.rarity and card.config.center.rarity == 1 or card.ability.name == "Triple Shot" or
                card.ability.name == "Super Monkey Fan Club" or card.ability.name == "Plasma Monkey Fan Club") and
                mod_joker.ability.extra.Xmult ^ JokerDisplay.calculate_joker_triggers(mod_joker) or nil) }
    end
}

JokerDisplay.Definitions["j_bloons_long_range_darts"] = { --Long Range Darts
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.ability.extra", ref_value = "current_chips", colour = G.C.CHIPS },
        { text = " +", colour = G.C.MULT },
        { ref_table = "card.ability.extra", ref_value = "current_mult", colour = G.C.MULT },
    }
}

JokerDisplay.Definitions["j_bloons_enhanced_eyesight"] = { --Enhanced Eyesight
}

JokerDisplay.Definitions["j_bloons_crossbow"] = { --Crossbow
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS },
        { text = " +", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT },
    },
    calc_function = function(card)
        card.joker_display_values.chips = card.ability.extra.chips *
            (G.GAME and #G.consumeables.cards + G.GAME.consumeable_buffer > 0 and 1 or 0)
        card.joker_display_values.mult = card.ability.extra.mult *
            (G.GAME and #G.consumeables.cards + G.GAME.consumeable_buffer > 0 and 1 or 0)
    end
}

JokerDisplay.Definitions["j_bloons_sharp_shooter"] = { --Sharp Shooter
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT },
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
            card.joker_display_values.mult = card.joker_display_values and card.joker_display_values.mult or 0
            card.joker_display_values.counter = counter <= limit - 1 and limit - counter % limit .. " remaining" or "Next!"
            return
        end

        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()

        if text ~= "Unknown" and type(scoring_hand) == "table" then
            for _, scoring_card in pairs(scoring_hand) do
                count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
            end
        end

        local activations = (count + counter - 1 >= limit) and 1 + math.floor((count + counter - 1 - limit) / limit) or 0

        card.joker_display_values.mult = (activations > 0 and (card.ability.extra.mult * activations) or 0)

        card.joker_display_values.counter =
            counter <= limit - 1 and limit - counter % limit .. " remaining" or "Next!"
    end
}

JokerDisplay.Definitions["j_bloons_crossbow_master"] = { --Crossbow Master
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
            card.joker_display_values.counter = counter <= limit - 1 and limit - counter % limit .. " remaining" or "Next!"
            return
        end

        local count = 0
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()

        if text ~= "Unknown" and type(scoring_hand) == "table" then
            for _, scoring_card in pairs(scoring_hand) do
                count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
            end
        end

        local activations = (count + counter - 1 >= limit) and 1 + math.floor((count + counter - 1 - limit) / limit) or 0

        card.joker_display_values.Xmult = (activations > 0 and (card.ability.extra.Xmult ^ activations) or 1)

        card.joker_display_values.counter =
            counter <= limit - 1 and limit - counter % limit .. " remaining" or "Next!"
    end
}