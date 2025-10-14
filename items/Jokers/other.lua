SMODS.Joker { --Bloonprint
    key = 'bloonprint',
    name = 'Bloonprint',
	loc_txt = {
        name = 'Bloonprint',
        text = {
            'Copies ability of',
            '{C:attention}Joker{} in position {C:attention}#1#{}',
            '{S:0.8}position changes{}',
            '{S:0.8}at end of round{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 11 },
    rarity = 3,
	cost = 10,
    blueprint_compat = true,
    config = {
        base = 'other',
        extra = {current = 1 } --Variables: current = current retrigger position, blueprint_compat = blueprint copyable
    },

    loc_vars = function(self, info_queue, card)
        if card.area and card.area == G.jokers then
			local other_joker = G.jokers.cards[card.ability.extra.current]
			local compatible = other_joker and other_joker ~= card and other_joker.config.center.blueprint_compat
			main_end = {{
                n = G.UIT.C,
                config = { align = "bm", minh = 0.4 },
                nodes = {{
                    n = G.UIT.C,
                    config = {
                        ref_table = card,
                        align = "m",
                        colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8),
                        r = 0.05,
                        padding = 0.06,
                    },
                    nodes = {{
                        n = G.UIT.T,
                        config = {
                            text = " " .. localize("k_" .. (compatible and "compatible" or "incompatible")) .. " ",
                            colour = G.C.UI.TEXT_LIGHT,
                            scale = 0.32 * 0.8,
                        }
                    }}
                }}
			}}
		end
        return { vars = { card.ability.extra.current }, main_end = main_end }
    end,
    calculate = function(self, card, context)
        if context.blind_defeated and not context.blueprint then
            card.ability.extra.current = pseudorandom('bloonprint', 1, #G.jokers.cards)
        end
        return SMODS.blueprint_effect(card, G.jokers.cards[card.ability.extra.current], context)
    end
}

SMODS.Joker { --Sentry
    key = 'sentry',
    name = 'Nail Sentry',
	loc_txt = {
        name = 'Nail Sentry',
        text = {
            '{C:chips}+#1#{} Chips',
            '{C:mult}+#2#{} Mult',
            '{C:dark_edition}+#3#{} Joker Slot',
            'Lasts {C:attention}#4#{} rounds'
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 5 },
    rarity = 1,
	cost = 1,
    blueprint_compat = true,
    config = {
        base = 'other',
        extra = { chips = 30, mult = 2, slots = 1, rounds = 2 } --Variables: slots = joker slots, rounds = rounds remaining
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
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                G.consumeables:remove_card(card)
                                card:remove()
                                card = nil
                                return true;
                            end
                        })) 
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
	loc_txt = {
        name = 'Crushing Sentry',
        text = {
            'Played cards give',
            '{C:mult}+#1#{} Mult when scored',
            '{C:dark_edition}+#2#{} Joker Slot',
            'Lasts {C:attention}#3#{} rounds'
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 11 },
    rarity = 2,
	cost = 1,
    blueprint_compat = true,
    config = {
        base = 'other',
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
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                G.consumeables:remove_card(card)
                                card:remove()
                                card = nil
                                return true;
                            end
                        })) 
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
	loc_txt = {
        name = 'Boom Sentry',
        text = {
            'First card held',
            'in hand gives {X:mult,C:white}X#1#{} Mult',
            '{C:dark_edition}+#2#{} Joker Slot',
            'Lasts {C:attention}#3#{} rounds'
        }
    },
	atlas = 'Joker',
	pos = { x = 6, y = 11 },
    rarity = 2,
	cost = 1,
    blueprint_compat = true,
    config = {
        base = 'other',
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
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                G.consumeables:remove_card(card)
                                card:remove()
                                card = nil
                                return true;
                            end
                        })) 
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
	loc_txt = {
        name = 'Cold Sentry',
        text = {
            '{C:attention}Freeze{} and retrigger',
            'first played card when scored',
            '{C:dark_edition}+#1#{} Joker Slot',
            'Lasts {C:attention}#2#{} rounds'
        }
    },
	atlas = 'Joker',
	pos = { x = 7, y = 11 },
    rarity = 2,
	cost = 1,
    blueprint_compat = true,
    config = {
        base = 'other',
        extra = { retrigger = 1, slots = 1, rounds = 3 } --Variables: retrigger = retrigger amount, slots = joker slots, rounds = rounds remaining
    },

    in_pool = function(self, args)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.slots, card.ability.extra.rounds } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
    end,
    calculate = function(self, card, context)
        if context.before and context.scoring_hand[1] and not context.blueprint then
            context.scoring_hand[1]:set_ability('m_bloons_frozen', nil, true)
        elseif context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[1] and not context.other_card.debuff then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger
            }
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.rounds = card.ability.extra.rounds - 1
            if card.ability.extra.rounds <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                G.consumeables:remove_card(card)
                                card:remove()
                                card = nil
                                return true;
                            end
                        })) 
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
	loc_txt = {
        name = 'Energy Sentry',
        text = {
            '{C:chips}+#1#{} Chips',
            '{C:mult}+#2#{} Mult',
            '{C:dark_edition}+#3#{} Joker Slot',
            'Lasts {C:attention}#4#{} rounds'
        }
    },
	atlas = 'Joker',
	pos = { x = 8, y = 11 },
    rarity = 2,
	cost = 1,
    blueprint_compat = true,
    config = {
        base = 'other',
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
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                G.consumeables:remove_card(card)
                                card:remove()
                                card = nil
                                return true;
                            end
                        })) 
                        return true
                    end
                }))
            end
        end
    end
}