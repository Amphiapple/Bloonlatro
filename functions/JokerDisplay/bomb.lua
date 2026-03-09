JokerDisplay.Definitions["j_bloons_bomb_shooter"] = { --Bomb Shooter
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local mult = 0
        local _, poker_hands, _ = JokerDisplay.evaluate_hand()
        if poker_hands[card.ability.extra.poker_hand] and next(poker_hands[card.ability.extra.poker_hand]) then
            mult = card.ability.extra.mult
        end
        card.joker_display_values.mult = mult
        card.joker_display_values.localized_text = localize(card.ability.extra.poker_hand, 'poker_hands')
    end
}

JokerDisplay.Definitions["j_bloons_bigger_bombs"] = { --Bigger Bombs
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local mult = 0
        local _, poker_hands, _ = JokerDisplay.evaluate_hand()
        if poker_hands[card.ability.extra.poker_hand] and next(poker_hands[card.ability.extra.poker_hand]) then
            mult = card.ability.extra.mult
        end
        card.joker_display_values.mult = mult
        card.joker_display_values.localized_text = localize(card.ability.extra.poker_hand, 'poker_hands')
    end
}

JokerDisplay.Definitions["j_bloons_heavy_bombs"] = { --Heavy Bombs
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local mult = 0
        local _, poker_hands, _ = JokerDisplay.evaluate_hand()
        if poker_hands[card.ability.extra.poker_hand] and next(poker_hands[card.ability.extra.poker_hand]) then
            mult = card.ability.extra.mult
        end
        card.joker_display_values.mult = mult
        card.joker_display_values.localized_text = localize(card.ability.extra.poker_hand, 'poker_hands')
    end
}

JokerDisplay.Definitions["j_bloons_really_big_bombs"] = { --Really Big Bombs
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
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local Xmult = 1
        local _, poker_hands, _ = JokerDisplay.evaluate_hand()
        card.joker_display_values.localized_text = localize(card.ability.extra.poker_hand1, 'poker_hands')
        if poker_hands[card.ability.extra.poker_hand1] and next(poker_hands[card.ability.extra.poker_hand1]) then
            if poker_hands[card.ability.extra.poker_hand2] and next(poker_hands[card.ability.extra.poker_hand2]) then
                Xmult = card.ability.extra.Xmult2
            else
                Xmult = card.ability.extra.Xmult1
            end
            card.joker_display_values.localized_text = localize(card.ability.extra.poker_hand2, 'poker_hands')
        end
        card.joker_display_values.Xmult = Xmult
    end
}

JokerDisplay.Definitions["j_bloons_bloon_impact"] = { --Bloon Impact
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

JokerDisplay.Definitions["j_bloons_bloon_crush"] = { --Bloon Crush
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
        local stunned = false
        for _, playing_card in ipairs(G.hand.cards) do
            if playing_hand or not playing_card.highlighted then
                if not (playing_card.facing == 'back') and not playing_card.debuff and playing_card.ability.name == 'Stunned Card' then
                    stunned = true
                    break
                end
            end
        end
        card.joker_display_values.Xmult = stunned and card.ability.extra.Xmult or 1
    end
}

JokerDisplay.Definitions["j_bloons_faster_reload_bomb"] = { --Faster Reload
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local mult = 0
        local _, poker_hands, _ = JokerDisplay.evaluate_hand()
        if poker_hands[card.ability.extra.poker_hand] and next(poker_hands[card.ability.extra.poker_hand]) then
            mult = card.ability.extra.mult
        end
        card.joker_display_values.mult = mult
        card.joker_display_values.localized_text = localize(card.ability.extra.poker_hand, 'poker_hands')
    end
}

JokerDisplay.Definitions["j_bloons_missile_launcher"] = { --Missile launcher
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local mult = 0
        local _, poker_hands, _ = JokerDisplay.evaluate_hand()
        if poker_hands[card.ability.extra.poker_hand] and next(poker_hands[card.ability.extra.poker_hand]) then
            mult = card.ability.extra.mult
        end
        card.joker_display_values.mult = mult
        card.joker_display_values.localized_text = localize(card.ability.extra.poker_hand, 'poker_hands')
    end
}

JokerDisplay.Definitions["j_bloons_moab_mauler"] = { --MOAB Mauler
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

JokerDisplay.Definitions["j_bloons_moab_assassin"] = { --MOAB Assassin
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
        local ready = card.ability.extra.counter == card.ability.extra.limit - 1
        card.joker_display_values.active = boss_active and ready

        card.joker_display_values.Xmult = boss_active and ready and card.ability.extra.Xmult or 1
        if boss_active then
            card.joker_display_values.active_text = ready and "active" or "inactive"
        else
            card.joker_display_values.active_text = "no boss active"
        end
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

JokerDisplay.Definitions["j_bloons_moab_eliminator"] = { --MOAB Eliminator
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

        card.joker_display_values.Xmult = boss_active and card.ability.extra.Xmult1 or card.ability.extra.Xmult2
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

JokerDisplay.Definitions["j_bloons_extra_range"] = { --Extra Range
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.CHIPS },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local chips = 0
        local _, poker_hands, _ = JokerDisplay.evaluate_hand()
        if poker_hands[card.ability.extra.poker_hand] and next(poker_hands[card.ability.extra.poker_hand]) then
            chips = card.ability.extra.chips
        end
        card.joker_display_values.chips = chips
        card.joker_display_values.localized_text = localize(card.ability.extra.poker_hand, 'poker_hands')
    end
}

JokerDisplay.Definitions["j_bloons_frag_bombs"] = { --Frag Bombs
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.CHIPS },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local max = 0
        local _, poker_hands, scoring_hand = JokerDisplay.evaluate_hand()
        if poker_hands[card.ability.extra.poker_hand] and next(poker_hands[card.ability.extra.poker_hand]) then
            local idx_by_id = {}
            local max = 0
            for k, v in ipairs(scoring_hand) do
                local id = v:get_id()
                local rank = SMODS.has_no_rank(v) and 0 or v.base.nominal
                if idx_by_id[id] and rank > max then
                    max = rank
                else
                    idx_by_id[id] = k
                end
            end
        end
        card.joker_display_values.chips = max * card.ability.extra.chips
        card.joker_display_values.localized_text = localize(card.ability.extra.poker_hand, 'poker_hands')
    end
}

JokerDisplay.Definitions["j_bloons_cluster_bombs"] = { --Cluster Bombs
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.CHIPS },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "poker_hand", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local text, _, _ = JokerDisplay.evaluate_hand()
        local repeat_hand = text == card.ability.extra.poker_hand
        card.joker_display_values.chips = repeat_hand and card.ability.extra.chips or 0
        card.joker_display_values.poker_hand = card.ability.extra.poker_hand ~= "" and card.ability.extra.poker_hand or "None"
    end,
}

JokerDisplay.Definitions["j_bloons_recursive_cluster"] = { --Recursive Cluster
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
        { ref_table = "card.joker_display_values", ref_value = "poker_hands", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local text, _, _ = JokerDisplay.evaluate_hand()
        local repeat_hand = text == card.ability.extra.poker_hands[1] and text == card.ability.extra.poker_hands[2]
        card.joker_display_values.Xmult = repeat_hand and card.ability.extra.Xmult or 1
        card.joker_display_values.poker_hands = card.ability.extra.poker_hands[1] and card.ability.extra.poker_hands[1] or "None"
        if card.ability.extra.poker_hands[2] then
            card.joker_display_values.poker_hands = card.joker_display_values.poker_hands .. ' ' .. card.ability.extra.poker_hands[2]
        end
    end,
}

JokerDisplay.Definitions["j_bloons_bomb_blitz"] = { --Bomb Blitz
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        local blind_percent = to_big(G.GAME.chips / G.GAME.blind.chips * 100)
        card.joker_display_values.active = G.GAME and G.GAME.chips and G.GAME.blind.chips and
            blind_percent and blind_percent ~= to_big(0) and blind_percent >= to_big(card.ability.extra.percent)
            and "Active!" or "Inactive"
    end
}