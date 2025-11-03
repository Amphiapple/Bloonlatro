SMODS.Joker { --Monkey Sub
    key = 'sub',
    name = 'Monkey Sub',
	loc_txt = {
        name = 'Monkey Sub',
        text = {
            'Each card',
            'held in hand',
            'gives {C:mult}+#1#{} Mult'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 8 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        base = 'sub',
        extra = { mult = 2 } --Variables: mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round then
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

SMODS.Joker { --Advanced Intel
    key = 'intel',
    name = 'Advanced Intel',
    loc_txt = {
        name = 'Advanced Intel',
        text = {
            '{C:attention}+#1#{} card slot',
            'available in shop',
        }
    },
    atlas = 'Joker',
	pos = { x = 2, y = 8 },
    rarity = 1,
	cost = 5,
    blueprint_compat = false,
    config = {
        base = 'sub',
        extra = { slots = 1 } --Variables: mult = +mult, slots = extra shop slots
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.slots } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                change_shop_size(card.ability.extra.slots)
                return true
            end
        }))
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.shop.joker_max = G.GAME.shop.joker_max - card.ability.extra.slots
        if G.shop_jokers and G.shop_jokers.cards then
            G.shop_jokers.config.card_limit = G.GAME.shop.joker_max
            G.shop_jokers.T.w = G.GAME.shop.joker_max*1.01*G.CARD_W
            G.shop:recalculate()
        end
    end
}

SMODS.Joker { --Triple Guns
    key = 'tripguns',
    name = 'Triple Guns',
    loc_txt = {
        name = 'Triple Guns',
        text = {
            'This {C:attention}Joker{} gains {X:mult,C:white}X#1#{} ',
            'Mult if a {C:attention}Three of a Kind{}',
            'is held in hand',
            '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)'
        }
    },
	atlas = 'Joker',
	pos = { x = 13, y = 8 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'sub',
        extra = { Xmult = 0.1, current = 1 } --Variables: Xmult = Xmult gain for each 3oak held, current = current Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local ranks = {}
            local has_3oak = false
            for i, j in ipairs(G.hand.cards) do
                local new = true
                local id = j:get_id()
                for k, v in pairs(ranks) do
                    if id == k then
                        ranks[k] = v + 1
                        if ranks[k] == 3 then
                            has_3oak = true
                        end
                        new = false
                    end
                end
                if new then
                    ranks[id] = 1
                end
            end
            if has_3oak then
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.current}}
                }
            end
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --First Strike Capability
    key = 'fs',
    name = 'First Strike Capability',
	loc_txt = {
        name = 'First Strike Capability',
        text = {
            'This {C:attention}Joker{} gains {X:mult,C:white}X#1#{} ',
            'if {C:attention}Blind{} is defeated',
            'on {C:attention}first hand{} of round',
            '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 8 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'sub',
        extra = { Xmult = 0.25, current = 1 } --Variables: Xmult = Xmult gain/loss, current = current Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition and G.GAME.current_round.hands_played <= 1 and not context.blueprint then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.Xmult
            return {
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.current}},
                colour = G.C.MULT,
                delay = 0.45,
            }
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current,
            }
        end
    end
}

SMODS.Joker { --Energizer
    key = 'gizer',
    name = 'Energizer',
	loc_txt = {
        name = 'Energizer',
        text = {
            '{C:green}Rerolls{} cost half',
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 8 },
    rarity = 3,
	cost = 8,
    blueprint_compat = false,
    config = {
        base = 'sub',
    },

    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.0,
        func = (function()
            calculate_reroll_cost(true)
            return true
        end)
    }))
    end,
    remove_from_deck = function(self, card, from_debuff)
        calculate_reroll_cost(true)
    end,
}
