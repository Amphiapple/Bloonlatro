SMODS.Joker { --Boomerang Monkey
    key = 'boomer',
    name = 'Boomerang Monkey',
	loc_txt = {
        name = 'Boomerang Monkey',
        text = {
            'Retrigger {C:attention}first{} card',
            'held in hand',
            '{C:attention}#1#{} additional times'
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 0 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'boomer',
        extra = { retrigger = 2 } --Variables: retrigger = retrigger amount
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.retrigger } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.hand and context.other_card == G.hand.cards[1] and not context.other_card.debuff then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger
            }
        end
    end
}

SMODS.Joker { --Glaives
    key = 'glaives',
    name = 'Glaives',
    loc_txt = {
        name = 'Glaives',
        text = {
            'This Joker gains {C:chips}+#1#{} Chips',
            'whenever a card is scored',
            '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)'
        }
    },
    atlas = 'Joker',
	pos = { x = 6, y = 5 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'boomer',
        extra = { chips = 1, current = 0 } --Variables: chips = +chips per continuing card, current = current +chips
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.other_card.debuff and not context.blueprint then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.chips
        elseif context.joker_main then
            return {
                chips = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Red Hot Rangs
    key = 'redhot',
    name = 'Red Hot Rangs',
    loc_txt = {
        name = 'Red Hot Rangs',
        text = {
            'Retrigger {C:attention}last{}',
            '{C:attention}#1#{} played cards',
            'used in scoring'
        }
    },
    atlas = 'Joker',
	pos = { x = 1, y = 3 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'boomer',
        extra = { retrigger = 1, number = 2 } --Variables: retrigger = retrigger amount, number = number of cards retriggered
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.number } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and (context.other_card == context.scoring_hand[#context.scoring_hand] or context.other_card == context.scoring_hand[#context.scoring_hand-1] ) then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger,
            }
        end
    end
}

SMODS.Joker { --Bionic Boomerang
    key = 'bioboomer',
    name = 'Bionic Boomerang',
	loc_txt = {
        name = 'Bionic Boomerang',
        text = {
            'This {C:attention}Joker{} gains {C:chips}+#1#{}',
            'Chips if a {C:attention}Steel{} card',
            'is held in hand',
            '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)'
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 6 },
    rarity = 1,
	cost = 6,
    blueprint_compat = true,
    perishable_compat = false,
    enhancement_gate = 'm_steel',
    config = {
        base = 'boomer',
        extra = { chips = 5, current = 0 } --Variables: chips = +chips gain if steel is held, current = current +chips
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
		return { vars = { card.ability.extra.chips, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local has_steel = false
            for k, v in ipairs(G.hand.cards) do
                if v.ability.name == 'Steel Card' then
                    has_steel = true
                    break
                end
            end
            if has_steel then
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.chips
                return {
                    message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}}
                }
            end
        elseif context.joker_main then
            return {
                chips = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --MOAB Press
    key = 'press',
    name = 'MOAB Press',
    loc_txt = {
        name = 'MOAB Press',
        text = {
            'If played hand',
            'contains only {C:attention}1{} card',
            'on the {C:attention}Boss Blind{},',
            'add a {C:attention}Red Seal{} to it',
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 9 },
    rarity = 2,
	cost = 5,
    blueprint_compat = false,
    config = {
        base = 'boomer',
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS.Red
    end,
    calculate = function(self, card, context)
        if context.before and G.GAME.blind.boss and #context.full_hand == 1 and not context.full_hand[1].debuff and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    context.full_hand[1]:set_seal('Red', nil, true)
                    return true
                end
            }))
            delay(0.5)
        end
    end
}


SMODS.Joker { --Glaive Lord
    key = 'glord',
    name = 'Glaive Lord',
	loc_txt = {
        name = 'Glaive Lord',
        text = {
            'This Joker gains {C:chips}+#1#{} Chips',
            'when each card with a new',
            'suit or rank is scored',
            '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips{C:inactive}){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 12 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'boomer',
        extra = { chips = 3, current = 0, suits = {}, ranks = {} } --Variables: chips = +chips per continuing card, current = current +chips
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.other_card.debuff and not context.blueprint then
            local new_suit = true
            local suit = 'None'
            if context.other_card.ability.name == 'Wild Card' then
                suit = 'Wild'
            elseif context.other_card:is_suit('Hearts') then
                suit = 'Hearts'
            elseif context.other_card:is_suit('Diamonds') then
                suit = 'Diamonds'
            elseif context.other_card:is_suit('Spades') then
                suit = 'Spades'
            elseif context.other_card:is_suit('Clubs') then
                suit =' Clubs'
            else
                new_suit = false
            end
            for k, v in pairs(card.ability.extra.suits) do
                if suit == k then
                    new_suit = false
                end
            end
            if new_suit then
                card.ability.extra.suits[suit] = true
            end

            local new_rank = true
            local id = context.other_card:get_id()
            if id < 0 then
                new_rank = false
            end
            for k, v in pairs(card.ability.extra.ranks) do
                if id == k then
                    new_rank = false
                end
            end
            if new_rank then
                card.ability.extra.ranks[id] = true
            end
            if new_suit or new_rank then
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.chips
            end
        elseif context.joker_main then
            return {
                chips = card.ability.extra.current
            }
        elseif context.after and not context.blueprint then
            card.ability.extra.suits = {}
            card.ability.extra.ranks = {}
        end
    end
}
