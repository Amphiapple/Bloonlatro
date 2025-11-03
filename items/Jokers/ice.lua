SMODS.Joker { --Ice Monkey
    key = 'ice',
    name = 'Ice Monkey',
	loc_txt = {
        name = 'Ice Monkey',
        text = {
            '{C:chips}+#1#{} Chips and {C:attention}Freeze{}',
            'all scoring cards on',
            '{C:attention}first hand{} of round'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 4 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,

    config = {
        base = 'ice',
        extra = { chips = 50 } --Variables: chips = +chips
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function()
                return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES
            end
            juice_card_until(card, eval, true)
        elseif context.before and G.GAME.current_round.hands_played == 0 and not context.blueprint then
            for k, v in ipairs(context.scoring_hand) do
                if not v.debuff then
                    v:set_ability('m_bloons_frozen', nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:juice_up()
                            return true
                        end
                    }))
                end
            end
        elseif context.joker_main and G.GAME.current_round.hands_played == 0 then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
}

SMODS.Joker { --Permafrost
    key = 'pfrost',
    name = 'Permafrost',
	loc_txt = {
        name = 'Permafrost',
        text = {
            '{C:attention}Frozen{} cards earn {C:money}$#1#{}',
            'and permanently gain',
            '{C:chips}+#2#{} Hand Chips',
            'when thawed out'
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 4 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    enhancement_gate = 'm_bloons_frozen',
    config = {
        base = 'ice',
        extra = { money = 2, chips = 10 } --Variables: money = dollars, chips = +chips
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        return { vars = { card.ability.extra.money, card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.after then
            for k, v in ipairs(G.hand.cards) do
                if v.ability.name == 'Frozen Card' then
                    v.ability.perma_h_chips = v.ability.perma_h_chips or 0
                    v.ability.perma_h_chips = v.ability.perma_h_chips + card.ability.extra.chips

                    ease_dollars(card.ability.extra.money)
                    card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('$')..card.ability.extra.money,colour = G.C.MONEY, delay = 0.45})
                end
            end
        end
    end
}

SMODS.Joker { --Refreeze
    key = 'refreeze',
    name = 'Re-Freeze',
    loc_txt = {
        name = 'Re-Freeze',
        text = {
            'Retrigger {C:attention}Frozen{} cards',
            'that are held in hand'
        }
    },
    atlas = 'Joker',
	pos = { x = 12, y = 4 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    enhancement_gate = 'm_bloons_frozen',
    config = {
        base = 'ice',
        extra = { retrigger = 1 } --Variables = retrigger = retrigger amount
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.hand and context.other_card.ability.name == 'Frozen Card' then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger
            }
        end
    end
}

SMODS.Joker { --Ice Shards
    key = 'shards',
    name = 'Ice Shards',
	loc_txt = {
        name = 'Ice Shards',
        text = {
            'This {C:attention}Joker{} gains {C:mult}+#1#{} ',
            'Mult whenever a {C:attention}Frozen Card{}',
            'thaws out or is destroyed',
            '{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 4 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    perishable_compat = false,
    enhancement_gate = 'm_bloons_frozen',
    config = {
        base = 'ice',
        extra = { mult = 2, current = 0 }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        return { vars = { card.ability.extra.mult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.current
            }
        elseif context.after and not context.blueprint then
            local frozens = 0
            for k, v in ipairs(G.hand.cards) do
                if v.ability.name == 'Frozen Card' then
                    frozens = frozens + 1
                end
            end
            if frozens > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult*frozens
                                return true
                            end
                        }))
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.current + card.ability.extra.mult*frozens}}})
                        return true
                    end
                }))
            end
        elseif context.cards_destroyed and not context.blueprint then
            local frozens = 0
            for k, v in ipairs(context.glass_shattered) do
                if v.ability.name == 'Frozen Card' then
                    frozens = frozens + 1
                end
            end
            if frozens > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult*frozens
                                return true
                            end
                        }))
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.current + card.ability.extra.mult*frozens}}})
                        return true
                    end
                }))
            end
        elseif context.remove_playing_cards and not context.blueprint then
            local frozens = 0
            for k, v in ipairs(context.removed) do
                if v.ability.name == 'Frozen Card' then
                    frozens = frozens + 1
                end
            end
            if frozens > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                card.ability.extra.current = card.ability.extra.current + card.ability.extra.mult*frozens
                                return true
                            end
                        }))
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.current + card.ability.extra.mult*frozens}}})
                        return true
                    end
                }))
            end
        end
    end
}

SMODS.Joker { --Icicles
    key = 'icicles',
    name = 'Icicles',
    loc_txt = {
        name = 'Icicles',
        text = {
            '{C:attention}Frozen{} cards give {X:mult,C:white}X#1#{}',
            'Mult when held in hand',
            '{C:green}#2# in #3#{} chance to {C:attention}Freeze{}',
            'each {C:attention}discarded{} card'
        }
    },
	atlas = 'Joker',
	pos = { x = 14, y = 4 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'ice',
        extra = { Xmult = 1.3, num = 1, denom = 2 } --Variables: Xmult = Xmult, num/denom = probability fraction
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'icicles')
        return { vars = { card.ability.extra.Xmult, n, d } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and context.other_card.ability.name == "Frozen Card" and not context.other_card.debuff and not context.end_of_round then
            return {
                x_mult = card.ability.extra.Xmult
            }
        elseif context.discard and not context.other_card.debuff and SMODS.pseudorandom_probability(card, 'icicles', card.ability.extra.num, card.ability.extra.denom, 'icicles') then
            context.other_card:set_ability('m_bloons_frozen', nil, true)
            return {
                message = 'Freeze!',
                colour = G.C.CHIPS
            }
        end
    end
}

SMODS.Joker { --Absolute Zero
    key = 'az',
    name = 'Absolute Zero',
	loc_txt = {
        name = 'Absolute Zero',
        text = {
            'If {C:attention}first hand{} of round has',
            '{C:attention}#1#{} scoring cards, score {C:attention}#1#{} chips,',
            '{C:attention}Freeze{} all scoring cards, and',
            'create a {C:spectral}Spectral{} card',
            '{C:inactive}(Must have room){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 10, y = 4 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        base = 'ice',
        extra = { chips = 0, number = 5 } --Variables: number = required cards for spectral
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        return { vars = { card.ability.extra.chips, card.ability.extra.number } }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function()
                return (G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES)
            end
            juice_card_until(card, eval, true)
        elseif context.before and #context.scoring_hand == 5 and G.GAME.current_round.hands_played == 0 then
            if not context.blueprint then
                for k, v in pairs(context.scoring_hand) do
                    if not v.debuff then
                        v:set_ability('m_bloons_frozen', nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v:juice_up()
                                return true
                            end
                        }))
                    end
                end
            end
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        local card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'az')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
            end
        elseif context.final_scoring_step and #context.scoring_hand == 5 and G.GAME.current_round.hands_played == 0 and not context.blueprint then
            hand_chips = mod_chips(card.ability.extra.chips)
            hand_mult = mod_mult(card.ability.extra.chips)
            update_hand_text( { delay = 0 }, { chips = hand_chips, mult = hand_mult } )
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound("timpani", 1)
                    attention_text({
                        scale = 1.4,
                        text = "Frozen",
                        hold = 0.45,
                        align = "cm",
                        offset = { x = 0, y = -2.7 },
                        major = G.play,
                    })
                    return true
                end,
            }))
            delay(0.6)
        end
    end
}
