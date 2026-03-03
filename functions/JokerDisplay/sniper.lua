JokerDisplay.Definitions["j_bloons_sniper_monkey"] = { --Sniper Monkey
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

JokerDisplay.Definitions["j_bloons_full_metal_jacket"] = { --Full Metal Jacket
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

JokerDisplay.Definitions["j_bloons_large_calibre"] = { --Large Calibre
    text = {
        { text = "+", colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS },
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
            card.joker_display_values.chips = card.ability.extra.chips
            card.joker_display_values.mult = card.ability.extra.mult
            card.joker_display_values.active = "Active!"
        else
            card.joker_display_values.chips = 0
            card.joker_display_values.mult = 0
            card.joker_display_values.active = card.ability.extra.limit - card.ability.extra.counter % card.ability.extra.limit - 1 .. " remaining"
        end
    end
}

JokerDisplay.Definitions["j_bloons_deadly_precision"] = { --Deadly Precision
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
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" }
    },
    calc_function = function(card)
        if card.ability.extra.counter == card.ability.extra.limit - 1 then
            card.joker_display_values.active = "Active!"
            card.joker_display_values.Xmult = card.ability.extra.Xmult
        else
            card.joker_display_values.active = card.ability.extra.limit - card.ability.extra.counter % card.ability.extra.limit - 1 .. " remaining"
            card.joker_display_values.Xmult = 1
        end
    end
}

JokerDisplay.Definitions["j_bloons_maim_moab"] = { --Maim MOAB
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
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" }
    },
    calc_function = function(card)
        if card.ability.extra.counter == card.ability.extra.limit - 1 then
            card.joker_display_values.active = "Active!"
            if G.GAME.blind.boss then
                card.joker_display_values.Xmult = card.ability.extra.Xmult_boss
            else
                card.joker_display_values.Xmult = card.ability.extra.Xmult
            end
        else
            card.joker_display_values.active = card.ability.extra.limit - card.ability.extra.counter % card.ability.extra.limit - 1 .. " remaining"
            card.joker_display_values.Xmult = 1
        end
    end
}

JokerDisplay.Definitions["j_bloons_cripple_moab"] = { --Cripple MOAB
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
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" }
    },
    calc_function = function(card)
        if card.ability.extra.counter == card.ability.extra.limit - 1 then
            card.joker_display_values.active = "Active!"
            card.joker_display_values.Xmult = card.ability.extra.Xmult
        else
            card.joker_display_values.active = card.ability.extra.limit - card.ability.extra.counter % card.ability.extra.limit - 1 .. " remaining"
            card.joker_display_values.Xmult = 1
        end
    end
}

JokerDisplay.Definitions["j_bloons_night_vision_goggles"] = { --Night Vision Goggles
}

JokerDisplay.Definitions["j_bloons_shrapnel_shot"] = { --Shrapnel Shot
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT },
    },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local mult_value = 0
        local right_card = nil
        local mult_card = nil
        if text ~= 'Unknown' and #scoring_hand >= 2 then
            local sorted_cards = JokerDisplay.sort_cards(scoring_hand)
            right_card = sorted_cards[#sorted_cards]
            mult_card = sorted_cards[#sorted_cards - 1]
            if mult_card and mult_card.facing ~= 'back' and not SMODS.has_no_rank(mult_card) then
                mult_value = mult_card.base.nominal
            end
        end
        card.joker_display_values.mult = right_card and JokerDisplay.calculate_card_triggers(right_card, scoring_hand, false) * mult_value or 0
    end
}

JokerDisplay.Definitions["j_bloons_bouncing_bullet"] = { --Bouncing Bullet
    text = {
        { text = "+", colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT },
    },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local total_mult = 0
        local mult_value = 0
        if text ~= 'Unknown' then
            local sorted_cards = JokerDisplay.sort_cards(scoring_hand)
            for i, scoring_card in ipairs(sorted_cards) do
                total_mult = total_mult + JokerDisplay.calculate_card_triggers(scoring_card, sorted_cards, false) * mult_value
                if scoring_card.facing ~= 'back' and not SMODS.has_no_rank(scoring_card) then
                    mult_value = scoring_card.base.nominal
                else
                    mult_value = 0
                end
            end
        end
        card.joker_display_values.mult = total_mult
    end
}

JokerDisplay.Definitions["j_bloons_supply_drop"] = { --Supply Drop
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.joker_display_values", ref_value = "money", colour = G.C.MONEY },
        { text = "+", colour = G.C.SECONDARY_SET.Tarot },
        { ref_table = "card.joker_display_values", ref_value = "tarots", colour = G.C.SECONDARY_SET.Tarot }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" }
    },
    calc_function = function(card)
        if card.ability.extra.counter == card.ability.extra.limit - 1 then
            card.joker_display_values.active = "Next!"
            card.joker_display_values.money = card.ability.extra.money
            card.joker_display_values.tarots = 1
        else
            card.joker_display_values.active = card.ability.extra.limit - card.ability.extra.counter % card.ability.extra.limit - 1 .. " remaining"
            card.joker_display_values.money = 0
            card.joker_display_values.tarots = 0
        end
    end
}

JokerDisplay.Definitions["j_bloons_elite_sniper"] = { --Elite Sniper
    text = {
        { text = "+$", colour = G.C.MONEY },
        { ref_table = "card.joker_display_values", ref_value = "money", colour = G.C.MONEY },
        { text = "+", colour = G.C.YELLOW },
        { ref_table = "card.joker_display_values", ref_value = "powers", colour = G.C.YELLOW }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" }
    },
    calc_function = function(card)
        if card.ability.extra.counter == card.ability.extra.limit - 1 then
            card.joker_display_values.active = "Next!"
            card.joker_display_values.money = card.ability.extra.money
            card.joker_display_values.powers = 1
        else
            card.joker_display_values.active = card.ability.extra.limit - card.ability.extra.counter % card.ability.extra.limit - 1 .. " remaining"
            card.joker_display_values.money = 0
            card.joker_display_values.powers = 0
        end
    end
}

JokerDisplay.Definitions["j_bloons_fast_firing_sniper"] = { --Fast Firing
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
        if card.ability.extra.counter >= card.ability.extra.limit - 1 and card.ability.extra.counter < card.ability.extra.limit then
            card.joker_display_values.mult = card.ability.extra.mult
            card.joker_display_values.active = "Active!"
        else
            card.joker_display_values.mult = 0
            card.joker_display_values.active = math.ceil(card.ability.extra.limit - card.ability.extra.counter % card.ability.extra.limit - 1) .. " remaining"
        end
    end
}

JokerDisplay.Definitions["j_bloons_even_faster_firing"] = { --Even Faster Firing
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

JokerDisplay.Definitions["j_bloons_semi_automatic"] = { --Semi Automatic
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
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" }
    },
    calc_function = function(card)
        if card.ability.extra.counter == card.ability.extra.limit - 1 then
            card.joker_display_values.active = "Active!"
            card.joker_display_values.Xmult = card.ability.extra.Xmult
        else
            card.joker_display_values.active = card.ability.extra.limit - card.ability.extra.counter % card.ability.extra.limit - 1 .. " remaining"
            card.joker_display_values.Xmult = 1
        end
    end
}

JokerDisplay.Definitions["j_bloons_full_auto_rifle"] = { --Full Auto Rifle
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    calc_function = function(card)
        local active = G.GAME and (G.GAME.current_round.hands_played == 1 and not next(G.play.cards) or G.GAME.current_round.hands_played > 1)
        card.joker_display_values.Xmult = active and card.ability.extra.Xmult or 1
    end
}

JokerDisplay.Definitions["j_bloons_elite_defender"] = { --Elite Defender
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "Xmult" }
            }
        }
    },
    calc_function = function(card)
        local playing_hand = next(G.play.cards)
        local Xmult = 1
        if G.GAME and G.GAME.blind and to_big(G.GAME.blind.chips) > to_big(0) then
            if (G.GAME.current_round.hands_left == 1 and not playing_hand or G.GAME.current_round.hands_left == 0 and playing_hand) then
                if G.GAME.chips/G.GAME.blind.chips <= to_big(0.25) then
                    Xmult = card.ability.extra.Xmult3
                else
                    Xmult = card.ability.extra.Xmult2
                end
            elseif (G.GAME.current_round.hands_played == 1 and not playing_hand or G.GAME.current_round.hands_played > 1) then
                Xmult = card.ability.extra.Xmult1
            end
        end

        card.joker_display_values.Xmult = Xmult
    end
}