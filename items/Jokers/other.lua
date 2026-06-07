SMODS.Sound({key = "sentryexplode", path = "sentryexplode.ogg",})

SMODS.Joker { --Marine
    key = 'marine',
    name = 'Marine',
	atlas = 'Joker',
	pos = { x = 0, y = 25 },
    rarity = 3,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Marine", category = "military" },
        extra = { Xmult = 2, slots = 1, hands = 6 } --Variables: retrigger = retrigger amount, slots = joker slots, hands = hands remaining
    },

    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.slots, card.ability.extra.hands } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.Xmult
            }
        elseif context.after and not context.blueprint then
            card.ability.extra.hands = card.ability.extra.hands - 1
            if card.ability.extra.hands <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.destroy_cards(card, nil, nil, true)
                        card:remove()
                        return true
                    end
                }))
            end
        end
    end
}

SMODS.Joker { --Sentry
    key = 'sentry',
    name = 'Nail Sentry',
	atlas = 'Joker',
	pos = { x = 1, y = 25 },
    rarity = 1,
	cost = 1,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Sentry", category = "support" },
        extra = { chips = 20, mult = 2, slots = 1, rounds = 2 } --Variables: slots = joker slots, rounds = rounds remaining
    },

    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.slots, card.ability.extra.rounds } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.rounds = card.ability.extra.rounds - 1
            if card.ability.extra.rounds <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.destroy_cards(card, nil, nil, true)
                        card:remove()
                        return true
                    end
                }))
            end
        end
    end
}

SMODS.Joker { --Crushing Sentry
    key = 'crushing_sentry',
    name = 'Crushing Sentry',
	atlas = 'Joker',
	pos = { x = 2, y = 25 },
    rarity = 2,
	cost = 1,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Sentry", category = "support" },
        extra = { mult = 4, slots = 1, rounds = 3 } --Variables: mult = +mult each card, slots = joker slots, rounds = rounds remaining
    },

    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.slots, card.ability.extra.rounds } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.other_card.debuff then
            return {
                mult = card.ability.extra.mult
            }
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.rounds = card.ability.extra.rounds - 1
            if card.ability.extra.rounds <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.destroy_cards(card, nil, nil, true)
                        card:remove()
                        return true
                    end
                }))
            end
        end
    end
}

SMODS.Joker { --Boom Sentry
    key = 'boom_sentry',
    name = 'Boom Sentry',
	atlas = 'Joker',
	pos = { x = 3, y = 25 },
    rarity = 2,
	cost = 1,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Sentry", category = "support" },
        extra = { Xmult = 1.5, slots = 1, rounds = 3 } --Variables: Xmult = Xmult, slots = joker slots, rounds = rounds remaining
    },

    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.slots, card.ability.extra.rounds } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and context.other_card == G.hand.cards[1] and not context.end_of_round then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED
                }
            else
                return {
                    x_mult = card.ability.extra.Xmult
                }
			end
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.rounds = card.ability.extra.rounds - 1
            if card.ability.extra.rounds <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.destroy_cards(card, nil, nil, true)
                        card:remove()
                        return true
                    end
                }))
            end
        end
    end
}

SMODS.Joker { --Cold Sentry
    key = 'cold_sentry',
    name = 'Cold Sentry',
	atlas = 'Joker',
	pos = { x = 4, y = 25 },
    rarity = 2,
	cost = 1,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Sentry", category = "support" },
        extra = { retrigger = 1, slots = 1, rounds = 3 } --Variables: retrigger = retrigger amount, slots = joker slots, rounds = rounds remaining
    },

    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        return { vars = { card.ability.extra.slots, card.ability.extra.rounds } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local frozen_card = G.hand.cards[1]
            if frozen_card and not frozen_card.debuff then
                frozen_card:set_ability('m_bloons_frozen', nil, true)
            end
        elseif context.repetition and context.cardarea == G.hand and context.other_card == G.hand.cards[1] and not context.other_card.debuff then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger
            }
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.rounds = card.ability.extra.rounds - 1
            if card.ability.extra.rounds <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.destroy_cards(card, nil, nil, true)
                        card:remove()
                        return true
                    end
                }))
            end
        end
    end
}

SMODS.Joker { --Energy Sentry
    key = 'energy_sentry',
    name = 'Energy Sentry',
	atlas = 'Joker',
	pos = { x = 5, y = 25 },
    rarity = 2,
	cost = 1,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Sentry", category = "support" },
        extra = { chips = 40, mult = 4, slots = 1, rounds = 3 } --Variables: slots = joker slots, rounds = rounds remaining
    },

    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.slots, card.ability.extra.rounds } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.rounds = card.ability.extra.rounds - 1
            if card.ability.extra.rounds <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.destroy_cards(card, nil, nil, true)
                        card:remove()
                        return true
                    end
                }))
            end
        end
    end
}

SMODS.Joker { --Champion Sentry
    key = 'champion_sentry',
    name = 'Champion Sentry',
	atlas = 'Joker',
	pos = { x = 6, y = 25 },
    rarity = 3,
	cost = 1,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Sentry", category = "support" },
        extra = { Xmult = 1.25, slots = 1, rounds = 3, percent = 40, max = 20000 } --Variables: slots = joker slots, rounds = rounds remaining, 
    },

    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.slots, card.ability.extra.rounds, card.ability.extra.percent, card.ability.extra.max } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.Xmult
            }
        elseif context.selling_self then
            local score = card.ability.extra.max
            if G.GAME.blind.key ~= 'bl_mp_nemesis' then
                score = math.min(score, G.GAME.blind.chips * card.ability.percent / 100.0)
            end
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                func = function()
                    if G.GAME.chips/G.GAME.blind.chips >= to_big(1) and G.STATE == G.STATES.SELECTING_HAND then
                        G.GAME.current_round.semicolon = true
                        G.STATE = G.STATES.HAND_PLAYED
                        G.STATE_COMPLETE = true
                        end_round()
                        return true
                    end
                    return false
                end,
            }), "other")
            return {
                score = score,
                sound = 'bloons_sentryexplode',
                volume = 0.5
            }
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.rounds = card.ability.extra.rounds - 1
            if card.ability.extra.rounds <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.destroy_cards(card, nil, nil, true)
                        card:remove()
                        return true
                    end
                }))
            end
        end
    end
}

SMODS.Joker { --Mega Green Sentry
    key = 'mega_green_sentry',
    name = 'Mega Green Sentry',
	atlas = 'Joker',
	pos = { x = 7, y = 25 },
    rarity = 4,
	cost = 1,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Sentry", category = "support" },
        extra = { slots = 1, Xmult = 2, poker_hand = 'Straight', percent = 40, max = 40000 } --Variables: slots = joker slots,
    },

    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.slots,
                card.ability.extra.Xmult,
                localize(card.ability.extra.poker_hand, 'poker_hands'),
                card.ability.extra.percent,
                card.ability.extra.max
            }
        }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
        local score = card.ability.extra.max
        if G.GAME.blind.key ~= 'bl_mp_nemesis' then
            score = math.min(score, G.GAME.blind.chips * card.ability.percent / 100.0)
        end
        G.GAME.chips = G.GAME.chips + score
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('bloons_sentryexplode', 1, 0.5)
                delay(0.1)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'ease',
            blocking = false,
            ref_table = G.GAME,
            ref_value = 'chips',
            ease_to = G.GAME.chips,
            delay = 0.5,
            func = function(t)
                return math.floor(t)
            end
        }))
        G.E_MANAGER:add_event(
            Event({
                trigger = "immediate",
                func = function()
                    if G.GAME.chips/G.GAME.blind.chips >= to_big(1) and G.STATE == G.STATES.SELECTING_HAND then
                        G.GAME.current_round.semicolon = true
                        G.STATE = G.STATES.HAND_PLAYED
                        G.STATE_COMPLETE = true
                        end_round()
                        return true
                    end
                    return false
                end,
            }),
            "other"
        )
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.poker_hands and next(context.poker_hands[card.ability.extra.poker_hand]) then
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --Mega Red Sentry
    key = 'mega_red_sentry',
    name = 'Mega Red Sentry',
	atlas = 'Joker',
	pos = { x = 8, y = 25 },
    rarity = 4,
	cost = 1,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Sentry", category = "support" },
        extra = { slots = 1, Xmult = 2, poker_hand = 'Flush', percent = 40, max = 40000 } --Variables: slots = joker slots
    },

    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.slots,
                card.ability.extra.Xmult,
                localize(card.ability.extra.poker_hand, 'poker_hands'),
                card.ability.extra.percent,
                card.ability.extra.max
            }
        }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
        local score = card.ability.extra.max
        if G.GAME.blind.key ~= 'bl_mp_nemesis' then
            score = math.min(score, G.GAME.blind.chips * card.ability.percent / 100.0)
        end
        G.GAME.chips = G.GAME.chips + score
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('bloons_sentryexplode', 1, 0.5)
                delay(0.1)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'ease',
            blocking = false,
            ref_table = G.GAME,
            ref_value = 'chips',
            ease_to = G.GAME.chips,
            delay = 0.5,
            func = function(t)
                return math.floor(t)
            end
        }))
        G.E_MANAGER:add_event(
            Event({
                trigger = "immediate",
                func = function()
                    if G.GAME.chips/G.GAME.blind.chips >= to_big(1) and G.STATE == G.STATES.SELECTING_HAND then
                        G.GAME.current_round.semicolon = true
                        G.STATE = G.STATES.HAND_PLAYED
                        G.STATE_COMPLETE = true
                        end_round()
                        return true
                    end
                    return false
                end,
            }),
            "other"
        )
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.poker_hands and next(context.poker_hands[card.ability.extra.poker_hand]) then
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --Mega Blue Sentry
    key = 'mega_blue_sentry',
    name = 'Mega Blue Sentry',
	atlas = 'Joker',
	pos = { x = 9, y = 25 },
    rarity = 4,
	cost = 1,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Sentry", category = "support" },
        extra = { slots = 1, Xmult = 2, percent = 40, max = 40000 } --Variables: slots = joker slots,
    },

    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.slots,
                card.ability.extra.Xmult,
                card.ability.extra.percent,
                card.ability.extra.max
            }
        }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
        local score = card.ability.extra.max
        if G.GAME.blind.key ~= 'bl_mp_nemesis' then
            score = math.min(score, G.GAME.blind.chips * card.ability.percent / 100.0)
        end
        G.GAME.chips = G.GAME.chips + score
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('bloons_sentryexplode', 1, 0.5)
                delay(0.1)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'ease',
            blocking = false,
            ref_table = G.GAME,
            ref_value = 'chips',
            ease_to = G.GAME.chips,
            delay = 0.5,
            func = function(t)
                return math.floor(t)
            end
        }))
        G.E_MANAGER:add_event(
            Event({
                trigger = "immediate",
                func = function()
                    if G.GAME.chips/G.GAME.blind.chips >= to_big(1) and G.STATE == G.STATES.SELECTING_HAND then
                        G.GAME.current_round.semicolon = true
                        G.STATE = G.STATES.HAND_PLAYED
                        G.STATE_COMPLETE = true
                        end_round()
                        return true
                    end
                    return false
                end,
            }),
            "other"
        )
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.blind.boss then
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --Bloonprint
    key = 'bloonprint',
    name = 'Bloonprint',
	atlas = 'Joker',
	pos = { x = 14, y = 25 },
    rarity = 3,
	cost = 10,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Bloonprint", category = "misc" },
        extra = { current = 1 } --Variables: current = current retrigger position, blueprint_compat = blueprint copyable
    },

    loc_vars = function(self, info_queue, card)
        if card.area and card.area == G.jokers then
			local other_joker = G.jokers.cards[card.ability.extra.current]
			local compatible = other_joker and other_joker ~= card and other_joker.config.center.blueprint_compat
			main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
		end
        return { vars = { card.ability.extra.current }, main_end = main_end }
    end,
    calculate = function(self, card, context)
        if context.blind_defeated and not context.blueprint then
            card.ability.extra.current = pseudorandom('bloonprint'..G.GAME.round_resets.ante, 1, #G.jokers.cards)
        end
        return SMODS.blueprint_effect(card, G.jokers.cards[card.ability.extra.current], context)
    end
}

SMODS.Joker { --Card Storm
    key = 'card_storm',
    name = 'Card Storm',
	atlas = 'Joker',
	pos = { x = 15, y = 25 },
    rarity = 3,
	cost = 10,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Card Storm", category = "misc" },
        extra = { current = 1 } --Variables: current = current retrigger position, blueprint_compat = blueprint copyable
    },

    loc_vars = function(self, info_queue, card)
        local function process_var(pos)
			if pos == 1 then
				return 'rightmost'
            end
			return 'leftmost'
		end
        if card.area and card.area == G.jokers then
            local other_joker = nil
            if card.ability.extra.current == 1 then
                other_joker = G.jokers.cards[#G.jokers.cards]
            else
                other_joker = G.jokers.cards[1]
            end
            local compatible = other_joker and other_joker ~= card and other_joker.config.center.blueprint_compat
            main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
        end
        return { vars = { process_var(card.ability.extra.current) }, main_end = main_end }
    end,
    calculate = function(self, card, context)
        if context.blind_defeated and not context.blueprint then
            card.ability.extra.current = pseudorandom('card_storm'..G.GAME.round_resets.ante) > 0.5 and 1 or -1
        end
        local other_joker = nil
        if card.ability.extra.current == 1 then
            other_joker = G.jokers.cards[#G.jokers.cards]
        else
            other_joker = G.jokers.cards[1]
        end
        return SMODS.blueprint_effect(card, other_joker, context)
    end
}
