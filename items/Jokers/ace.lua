SMODS.Joker { --Monkey Ace
    key = 'monkey_ace',
    name = 'Monkey Ace',
	loc_txt = {
        name = 'Monkey Ace',
        text = {
            'Each {C:attention}Ace{}',
            'held in hand',
            'gives {C:chips}+#1#{} Chips'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 10 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'ace',
        extra = { chips = 50 } --Variables: chips = +chips
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and context.other_card:get_id() == 14 and not context.end_of_round then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED
                }
            else
                return {
                    h_chips = card.ability.extra.chips
                }
			end
		end
    end
}

SMODS.Joker { --Rapid Fire
    key = 'rapid_fire',
    name = 'Rapid Fire',
	loc_txt = {
        name = 'Rapid Fire',
        text = {
            'Each played {C:attention}Ace{}',
            'gives {C:chips}+#1#{} Chips',
            'when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 10 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'ace',
        extra = { chips = 30 } --Variables: chips = +chips
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 14 then
            return {
                chips = card.ability.extra.chips
            }
		end
    end
}

SMODS.Joker { --Lots More Darts
    key = 'lots_more_darts',
    name = 'Lots More Darts',
	loc_txt = {
        name = 'Lots More Darts',
        text = {
            'Each played {C:attention}Ace{}',
            'gives {C:chips}+#1#{} Chips',
            'when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 10 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'ace',
        extra = { chips = 50 } --Variables: chips = +chips
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 14 then
            return {
                chips = card.ability.extra.chips
            }
		end
    end
}

SMODS.Joker { --Fighter Plane
    key = 'fighter_plane',
    name = 'Fighter Plane',
	loc_txt = {
        name = 'Fighter Plane',
        text = {
            'Increase rank of all',
            'scoring {C:attention}face{} cards on',
            '{C:attention}first hand{} of round',
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 10 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'ace',
    },
    calculate = function(self, card, context)
        if context.before and G.GAME.current_round.hands_played == 0 then
            local faces = {}
            for k, v in ipairs(context.scoring_hand) do
                if v:is_face() then
                    faces[#faces+1] = v
                end
            end
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    for k, v in ipairs(faces) do
                        v:flip()
                    end
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    for k, v in ipairs(faces) do
                        local suit_prefix = string.sub(v.base.suit, 1, 1)..'_'
                        local rank_suffix = v.base.id == 14 and 2 or math.min(v.base.id+1, 14)
                        if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
                        elseif rank_suffix == 10 then rank_suffix = 'T'
                        elseif rank_suffix == 11 then rank_suffix = 'J'
                        elseif rank_suffix == 12 then rank_suffix = 'Q'
                        elseif rank_suffix == 13 then rank_suffix = 'K'
                        elseif rank_suffix == 14 then rank_suffix = 'A'
                        end
                        v:set_base(G.P_CARDS[suit_prefix..rank_suffix])
                    end
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    for k, v in ipairs(faces) do
                        v:flip()
                    end
                    return true
                end
            }))
		end
    end
}

SMODS.Joker { --Operation: Dart Storm
    key = 'operation_dart_storm',
    name = 'Operation: Dart Storm',
	loc_txt = {
        name = 'Operation: Dart Storm',
        text = {
            'This Joker gains {C:chips}+#1#{} Chips',
            'when each played {C:attention}Ace{} is scored',
            '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)',
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 10 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'ace',
        extra = { chips = 6, current = 0 } --Variables: chips = chip gain, current = current chips
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 14 then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "current",
                scalar_value = "chips",
                no_message = true
            })
		elseif context.joker_main then
            return {
                chips = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Sky Shredder
    key = 'sky_shredder',
    name = 'Sky Shredder',
	loc_txt = {
        name = 'Sky Shredder',
        text = {
            'This Joker gains {X:mult,C:white}X#1#{} Mult after',
            '{C:attention}#2#{C:inactive} (#3#){} scoring {C:attention}Aces{} are played',
            'Requirement doubles each increment',
            '{C:inactive}(Currently {X:mult,C:white}X#4#{C:inactive} Mult)',
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 10 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'ace',
        extra = { Xmult = 1, limit = 4, counter = 0, current = 1 } --Variables: Xmult = Xmult gain, limit = aces for next level, counter = aces scored, current = current Xmult
    },

    loc_vars = function(self, info_queue, card)
        local function process_var(count)
			if count == 32 then
				return 'Max!'
			end
			return count
		end
        return { vars = { card.ability.extra.Xmult, card.ability.extra.limit, process_var(card.ability.extra.counter), card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local upgrade = false
            for k, v in ipairs(context.scoring_hand) do
                if card.ability.extra.counter < 32 and v:get_id() == 14 and not v.debuff then
                    card.ability.extra.counter = card.ability.extra.counter + 1
                    if card.ability.extra.counter >= card.ability.extra.limit then
                        upgrade = true
                        card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult
                        if card.ability.extra.current < 5 then
                            card.ability.extra.limit = card.ability.extra.limit * 2
                        end
                    end
                end
            end
            if upgrade then
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.RED,
                    delay = 0.45,
                }
            end
        elseif context.joker_main and card.ability.extra.current > 1 then
            return {
                x_mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Exploding Pineapple
    key = 'exploding_pineapple',
    name = 'Exploding Pineapple',
    loc_txt = {
        name = 'Exploding Pineapple',
        text = {
            'Destroy all scoring',
            'cards after {C:attention}#1#{} hands',
            '{S:1.1,C:red,E:2}self destructs{}'
        }
    },
    atlas = 'Joker',
	pos = { x = 6, y = 10 },
    rarity = 1,
	cost = 5,
    blueprint_compat = false,
    eternal_compat = false,
    config = {
        base = 'ace',
        extra = { hands = 3 } --Variables: hands = hands remaining
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.hands } }
    end,
    calculate = function(self, card, context)
        if context.destroying_card and card.ability.extra.hands <= 1 and not context.blueprint then
            SMODS.destroy_cards(card, nil, nil, true)
        elseif context.after and card.ability.extra.hands > 1 and not context.blueprint then
            card.ability.extra.hands = card.ability.extra.hands - 1
            return {
                message = localize{type='variable',key='a_chips_minus',vars={1}},
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker { --Spy Plane
    key = 'spy_plane',
    name = 'Spy Plane',
    loc_txt = {
        name = 'Spy Plane',
        text = {
            'Reveal the top {C:attention}#1#{}',
            'cards in your deck',
            '{C:inactive}#2# #3#{}'
        }
    },
    atlas = 'Joker',
	pos = { x = 7, y = 10 },
    rarity = 1,
	cost = 5,
    blueprint_compat = false,
    config = {
        base = 'ace',
        extra = { number = 2 } --Variables: number = number of cards revealed
    },

    loc_vars = function(self, info_queue, card)
        local function process_var(pos)
            local card_string = '#@'
            if #find_joker('Spy Plane') > 0 then
                card_string = card_string..(G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards-pos+1].base.id or 11)..(G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards-pos+1].base.suit:sub(1,1) or 'D')
            end
            return card_string
        end
		return {
            vars = {
                card.ability.extra.number,
                process_var(1),
                process_var(2)
            }
        }
    end,
}

SMODS.Joker { --Bomber Ace
    key = 'bomber_ace',
    name = 'Bomber Ace',
    loc_txt = {
        name = 'Bomber Ace',
        text = {
            'On {C:attention}final hand{} of round,',
            'Destroy all {C:attention}Aces{} and cards',
            'adjacent to them held in hand',
        }
    },
    atlas = 'Joker',
	pos = { x = 8, y = 10 },
    rarity = 2,
	cost = 5,
    blueprint_compat = false,
    config = {
        base = 'ace',
    },

    calculate = function(self, card, context)
        if context.after and G.GAME.current_round.hands_left == 0 and not context.blueprint then
            local destroyed_cards = {}
            for k, v in ipairs(G.hand.cards) do
                if v:get_id() == 14 or
                        (k > 1 and G.hand.cards[k-1]:get_id() == 14) or
                        (k < #G.hand.cards and G.hand.cards[k+1]:get_id() == 14) then
                    destroyed_cards[#destroyed_cards+1] = v
                end
            end
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    for i=#destroyed_cards, 1, -1 do
                        local card = destroyed_cards[i]
                        if card.ability.name == 'Glass Card' then
                            card:shatter()
                        else
                            card:start_dissolve(nil, i == #destroyed_cards)
                        end
                    end
                    return true
                end
            }))
        end
    end
}

SMODS.Joker { --Ground Zero 
    key = 'ground_zero',
    name = 'Ground Zero',
	loc_txt = {
        name = 'Ground Zero',
        text = {
            '{C:chips}+#1#{} Chips on',
            '{C:attention}final hand{} of round'
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 10 },
    rarity = 2,
	cost = 8,
    blueprint_compat = true,
    config = {
        base = 'ace',
        extra = { chips = 300 } --Variables: chips = +chips
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_left == 0 then
            return {
                chips = card.ability.extra.chips,
            }
        end
    end
}

SMODS.Joker { --Tsar Bomba
    key = 'tsar_bomba',
    name = 'Tsar Bomba',
	loc_txt = {
        name = 'Tsar Bomba',
        text = {
            '{X:mult,C:white}X#1#{} Mult and {C:attention}Stun{}',
            'all cards held in hand on',
            '{C:attention}final hand{} of round',
        }
    },
	atlas = 'Joker',
	pos = { x = 10, y = 10 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        base = 'ace',
        extra = { Xmult = 4 } --Variables: chips = +chips
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_bloons_stunned
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_left == 0 then
            return {
                x_mult = card.ability.extra.Xmult,
            }
        elseif context.after and G.GAME.current_round.hands_left == 0 then
            G.E_MANAGER:add_event(Event({
                func = function()
                    for k, v in ipairs(G.hand.cards) do
                        v:set_ability(G.P_CENTERS.m_bloons_stunned)
                    end
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {
                        message = 'Stunned!'
                    })
                    return true
                end
            }))
        end
    end
}

SMODS.Joker { --Sharper Darts
    key = 'sharper_darts',
    name = 'Sharper Darts',
	loc_txt = {
        name = 'Sharper Darts',
        text = {
            'Each {C:attention}Ace{}',
            'held in hand',
            'gives {C:mult}+#1#{} Mult'
        }
    },
	atlas = 'Joker',
	pos = { x = 11, y = 10 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'ace',
        extra = { mult = 15 } --Variables: mult = +mult
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and context.other_card:get_id() == 14 and not context.end_of_round then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED
                }
            else
                return {
                    h_mult = card.ability.extra.mult
                }
			end
		end
    end
}

SMODS.Joker { --Centered Path
    key = 'centered_path',
    name = 'Centered Path',
    loc_txt = {
        name = 'Centered Path',
        text = {
            'Create a {C:tarot}Tarot{} card',
            'if chips scored are',
            'between {C:attention}#1#%{} and {C:attention}#2#%{}',
            'of required chips'
        }
    },
	atlas = 'Joker',
	pos = { x = 12, y = 10 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'ace',
        extra = { percent_min = 40, percent_max = 60 } --Variables: percent_min = minimum percent of required chips scored, percent_max = maximum percent of required chips scored
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.percent_min, card.ability.extra.percent_max } }
    end,
    calculate = function(self, card, context)
        if context.after and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and
                (hand_chips*mult + G.GAME.chips)/G.GAME.blind.chips >= to_big(card.ability.extra.percent_min / 100.0) and
                (hand_chips*mult + G.GAME.chips)/G.GAME.blind.chips <= to_big(card.ability.extra.percent_max / 100.0) then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'centered_path')
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                    G.GAME.consumeable_buffer = 0
                    return true
                end)
            }))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
        end
    end
}

SMODS.Joker { --Neva-Miss Targeting
    key = 'neva_miss_targeting',
    name = 'Neva-Miss Targeting',
    loc_txt = {
        name = 'Neva-Miss Targeting',
        text = {
            'Create a {C:tarot}Tarot{} card',
            'if chips scored are',
            'between {C:attention}#1#%{} and {C:attention}#2#%{}',
            'of required chips'
        }
    },
	atlas = 'Joker',
	pos = { x = 13, y = 10 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'ace',
        extra = { percent_min = 75, percent_max = 125 } --Variables: percent_min = minimum percent of required chips scored, percent_max = maximum percent of required chips scored
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.percent_min, card.ability.extra.percent_max } }
    end,
    calculate = function(self, card, context)
        if context.after and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and
                (hand_chips*mult + G.GAME.chips)/G.GAME.blind.chips >= to_big(card.ability.extra.percent_min / 100.0) and
                (hand_chips*mult + G.GAME.chips)/G.GAME.blind.chips <= to_big(card.ability.extra.percent_max / 100.0) then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'nevamiss')
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                    G.GAME.consumeable_buffer = 0
                    return true
                end)
            }))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
        end
    end
}

SMODS.Joker { --Spectre
    key = 'spectre',
    name = 'Spectre',
    loc_txt = {
        name = 'Spectre',
        text = {
            'Create a {C:spectral}Spectral{} card',
            'if scoring hand contains',
            'at least {C:attention}#1# Aces{}',
        }
    },
	atlas = 'Joker',
	pos = { x = 14, y = 10 },
    rarity = 2,
	cost = 8,
    blueprint_compat = true,
    config = {
        base = 'ace',
        extra = { number = 4 } --Variables: number = required aces for spectral
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.number } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local count = 0
            if not context.blueprint then
                for k, v in ipairs(context.scoring_hand) do
                    if v:get_id() == 14 and not v.debuff then
                        count = count + 1
                    end
                end
            end
            if count >= card.ability.extra.number and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        local spectral = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'spectre')
                        spectral:add_to_deck()
                        G.consumeables:emplace(spectral)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
            end
        end
    end
}
