SMODS.Joker { --Boomerang Monkey
    key = 'boomer',
    name = 'Boomerang Monkey',
	loc_txt = {
        name = 'Boomerang Monkey',
        text = {
            'Retrigger {C:attention}last{}',
            'played card used',
            'in scoring'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 1 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        base = 'boomer',
        extra = { retrigger = 1 } --Variables: retrigger = retrigger amount
    },

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[#context.scoring_hand] then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger,
            }
        end
    end
}

SMODS.Joker { --Improved Rangs
    key = 'improved',
    name = 'Improved Rangs',
    loc_txt = {
        name = 'Improved Rangs',
        text = {
            'Retrigger {C:attention}last{}',
            '{C:attention}#1#{} played cards',
            'used in scoring'
        }
    },
    atlas = 'Joker',
	pos = { x = 1, y = 1 },
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
	pos = { x = 2, y = 1 },
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

SMODS.Joker { --Glaive Ricochet
    key = 'rico',
    name = 'Glaive Ricochet',
    loc_txt = {
        name = 'Glaive Ricochet',
        text = {
            'This Joker gains {C:chips}+#1#{} Chips',
            'when each card with a',
            'new rank is scored',
            '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips{C:inactive}){}'
        }
    },
    atlas = 'Joker',
	pos = { x = 3, y = 1 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'boomer',
        extra = { chips = 2, current = 0, ranks = {} } --Variables: chips = +chips per continuing card, current = current +chips
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.other_card.debuff and not context.blueprint then
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
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.chips
            end
        elseif context.joker_main then
            return {
                chips = card.ability.extra.current
            }
        elseif context.after and not context.blueprint then
            card.ability.extra.ranks = {}
        end
    end
}

SMODS.Joker { --MOAR Glaives
    key = 'moar',
    name = 'MOAR Glaives',
    loc_txt = {
        name = 'MOAR Glaives',
        text = {
            'This Joker gains {C:chips}+#1#{} Chips',
            'when each card with a',
            'new suit is scored',
            '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips{C:inactive}){}'
        }
    },
    atlas = 'Joker',
	pos = { x = 4, y = 1 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'boomer',
        extra = { chips = 2, current = 0, suits = { ['Wild'] = 0, ['Hearts'] = 0, ['Diamonds'] = 0, ['Spades'] = 0, ['Clubs'] = 0 } } --Variables: chips = +chips per continuing card, current = current +chips
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.other_card.debuff and not context.blueprint then
            if SMODS.has_any_suit(context.other_card) then
                card.ability.extra.suits['Wild'] = card.ability.extra.suits['Wild'] + 1
            elseif context.other_card:is_suit('Hearts') and card.ability.extra.suits['Hearts'] == 0 then
                card.ability.extra.suits['Hearts'] = card.ability.extra.suits['Hearts'] + 1
            elseif context.other_card:is_suit('Diamonds') and card.ability.extra.suits['Diamonds'] == 0 then
                card.ability.extra.suits['Diamonds'] = card.ability.extra.suits['Diamonds'] + 1
            elseif context.other_card:is_suit('Spades') and card.ability.extra.suits['Spades'] == 0 then
                card.ability.extra.suits['Spades'] = card.ability.extra.suits['Spades'] + 1
            elseif context.other_card:is_suit('Clubs') and card.ability.extra.suits['Clubs'] == 0 then
                card.ability.extra.suits['Clubs'] = card.ability.extra.suits['Clubs'] + 1
            end
        elseif context.joker_main then
            while card.ability.extra.suits['Wild'] > 0 do
                card.ability.extra.suits['Wild'] = card.ability.extra.suits['Wild'] - 1
                if card.ability.extra.suits['Hearts'] == 0 then
                    card.ability.extra.suits['Hearts'] = card.ability.extra.suits['Hearts'] + 1
                elseif card.ability.extra.suits['Diamonds'] == 0 then
                    card.ability.extra.suits['Diamonds'] = card.ability.extra.suits['Diamonds'] + 1
                elseif card.ability.extra.suits['Spades'] == 0 then
                    card.ability.extra.suits['Spades'] = card.ability.extra.suits['Spades'] + 1
                elseif card.ability.extra.suits['Clubs'] == 0 then
                    card.ability.extra.suits['Clubs'] = card.ability.extra.suits['Clubs'] + 1
                end
            end
            local count = 0
            for k, v in pairs(card.ability.extra.suits) do
                count = count + v
            end
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.chips * count
            return {
                chips = card.ability.extra.current
            }
        elseif context.after and not context.blueprint then
            card.ability.extra.suits = { ['Wild'] = 0, ['Hearts'] = 0, ['Diamonds'] = 0, ['Spades'] = 0, ['Clubs'] = 0 }
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
	pos = { x = 5, y = 1 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'boomer',
        extra = { chips = 3, current = 0, suits = { ['Wild'] = 0, ['Hearts'] = 0, ['Diamonds'] = 0, ['Spades'] = 0, ['Clubs'] = 0 }, ranks = {} } --Variables: chips = +chips per continuing card, current = current +chips
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.other_card.debuff and not context.blueprint then
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

            local new_suit = true
            if SMODS.has_any_suit(context.other_card) and card.ability.extra.suits['Wild'] < 4 then
                card.ability.extra.suits['Wild'] = card.ability.extra.suits['Wild'] + 1
                new_suit = false
            elseif context.other_card:is_suit('Hearts') and card.ability.extra.suits['Hearts'] == 0 then
                card.ability.extra.suits['Hearts'] = card.ability.extra.suits['Hearts'] + 1
            elseif context.other_card:is_suit('Diamonds') and card.ability.extra.suits['Diamonds'] == 0 then
                card.ability.extra.suits['Diamonds'] = card.ability.extra.suits['Diamonds'] + 1
            elseif context.other_card:is_suit('Spades') and card.ability.extra.suits['Spades'] == 0 then
                card.ability.extra.suits['Spades'] = card.ability.extra.suits['Spades'] + 1
            elseif context.other_card:is_suit('Clubs') and card.ability.extra.suits['Clubs'] == 0 then
                card.ability.extra.suits['Clubs'] = card.ability.extra.suits['Clubs'] + 1
            else
                new_suit = false
            end

            if new_rank or new_suit then
                card.ability.extra.current = card.ability.extra.current + card.ability.extra.chips
            end
        elseif context.joker_main then
            local new_suit = true
            while card.ability.extra.suits['Wild'] > 0 do
                card.ability.extra.suits['Wild'] = card.ability.extra.suits['Wild'] - 1
                new_suit = true
                if card.ability.extra.suits['Hearts'] == 0 then
                    card.ability.extra.suits['Hearts'] = card.ability.extra.suits['Hearts'] + 1
                elseif card.ability.extra.suits['Diamonds'] == 0 then
                    card.ability.extra.suits['Diamonds'] = card.ability.extra.suits['Diamonds'] + 1
                elseif card.ability.extra.suits['Spades'] == 0 then
                    card.ability.extra.suits['Spades'] = card.ability.extra.suits['Spades'] + 1
                elseif card.ability.extra.suits['Clubs'] == 0 then
                    card.ability.extra.suits['Clubs'] = card.ability.extra.suits['Clubs'] + 1
                else
                    new_suit = false
                end
                if new_suit then
                    card.ability.extra.current = card.ability.extra.current + card.ability.extra.chips
                end
            end
            return {
                chips = card.ability.extra.current
            }
        elseif context.after and not context.blueprint then
            card.ability.extra.suits = { ['Wild'] = 0, ['Hearts'] = 0, ['Diamonds'] = 0, ['Spades'] = 0, ['Clubs'] = 0 }
            card.ability.extra.ranks = {}
        end
    end
}

SMODS.Joker { --Faster Throwing
    key = 'fastboomer',
    name = 'Faster Throwing (Boomerang)',
	loc_txt = {
        name = 'Faster Throwing',
        text = {
            'Retrigger {C:attention}last{}',
            'card held in hand',
        }
    },
	atlas = 'Joker',
	pos = { x = 6, y = 1 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        base = 'boomer',
        extra = { retrigger = 1 } --Variables: retrigger = retrigger amount
    },

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.hand and context.other_card == G.hand.cards[#G.hand.cards] and not context.other_card.debuff then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger
            }
        end
    end
}

SMODS.Joker { --Faster Rangs
    key = 'fastrangs',
    name = 'Faster Rangs',
	loc_txt = {
        name = 'Faster Rangs',
        text = {
            'Retrigger {C:attention}last #1#{}',
            'cards held in hand',
        }
    },
	atlas = 'Joker',
	pos = { x = 7, y = 1 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'boomer',
        extra = { retrigger = 1, number = 2 } --Variables: retrigger = retrigger amount
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.number} }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.hand and (context.other_card == G.hand.cards[#G.hand.cards] or context.other_card == G.hand.cards[#G.hand.cards-1]) and not context.other_card.debuff then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger
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
            'Chips for each {C:attention}Steel{}',
            'card held in hand',
            '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)'
        }
    },
	atlas = 'Joker',
	pos = { x = 8, y = 1 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    perishable_compat = false,
    enhancement_gate = 'm_steel',
    config = {
        base = 'boomer',
        extra = { chips = 3, current = 0 } --Variables: chips = +chips gain if steel is held, current = current +chips
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
		return { vars = { card.ability.extra.chips, card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and context.other_card.ability.name == 'Steel Card' and not context.other_card.debuff and not context.end_of_round and not context.blueprint then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.chips
        elseif context.joker_main then
            return {
                chips = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Turbo Charge
    key = 'tcharge',
    name = 'Turbo Charge',
	loc_txt = {
        name = 'Turbo Charge',
        text = {
            'Retrigger {C:attention}last{}',
            'card held in hand',
            '{C:attention}#1#{} additional times on',
            'final hand of round'
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 1 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'boomer',
        extra = { retrigger = 3 } --Variables: retrigger = retrigger amount
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.retrigger } }
    end,
    calculate = function(self, card, context)
        if context.repetition and G.GAME.current_round.hands_left == 0 and context.cardarea == G.hand and context.other_card == G.hand.cards[#G.hand.cards] and not context.other_card.debuff then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger
            }
        end
    end
}

SMODS.Joker { --Perma Charge
    key = 'pcharge',
    name = 'Perma Charge',
	loc_txt = {
        name = 'Perma Charge',
        text = {
            'Retrigger {C:attention}last{}',
            'card held in hand',
            '{C:attention}#1#{} additional times',
        }
    },
	atlas = 'Joker',
	pos = { x = 10, y = 1 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        base = 'boomer',
        extra = { retrigger = 3 } --Variables: retrigger = retrigger amount
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.retrigger } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.hand and context.other_card == G.hand.cards[#G.hand.cards] and not context.other_card.debuff then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger
            }
        end
    end
}

SMODS.Joker { --Long Range Rangs
    key = 'rangerangs',
    name = 'Long Range Rangs',
    loc_txt = {
        name = 'Long Range Rangs',
        text = {
            'Retrigger {C:attention}first{}',
            'played card used',
            'in scoring'
        }
    },
    atlas = 'Joker',
	pos = { x = 11, y = 1 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        base = 'boomer',
        extra = { retrigger = 1 } --Variables: retrigger = retrigger amount
    },

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            if context.other_card == context.scoring_hand[1] then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.retrigger,
                }
            end
        end
    end
}

SMODS.Joker { --Red Hot Rangs
    key = 'redhot',
    name = 'Red Hot Rangs',
    loc_txt = {
        name = 'Red Hot Rangs',
        text = {
            'Retrigger {C:attention}first{}',
            'and {C:attention}last{} played cards',
            'used in scoring'
        }
    },
    atlas = 'Joker',
	pos = { x = 12, y = 1 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'boomer',
        extra = { retrigger = 1 } --Variables: retrigger = retrigger amount
    },

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            if #context.scoring_hand == 1 and context.other_card == context.scoring_hand[1] then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.retrigger * 2,
                }
            elseif context.other_card == context.scoring_hand[1] or context.other_card == context.scoring_hand[#context.scoring_hand] then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.retrigger,
                }
            end
        end
    end
}

SMODS.Joker { --Kylie Boomerang
    key = 'kylie',
    name = 'Kylie Boomerang',
    loc_txt = {
        name = 'Kylie Boomerang',
        text = {
            'Retrigger all cards',
            'except {C:attention}last{} played card',
            'used in scoring'
        }
    },
    atlas = 'Joker',
	pos = { x = 13, y = 1 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'boomer',
        extra = { retrigger = 1 } --Variables: retrigger = retrigger amount
    },

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card ~= context.scoring_hand[#context.scoring_hand] then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger,
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
            'Retrigger all',
            'played cards against',
            '{C:attention}Boss Blinds{}',
        }
    },
	atlas = 'Joker',
	pos = { x = 14, y = 1 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'boomer',
        extra = { retrigger = 1 } --Variables: retrigger = retrigger amount
    },

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and G.GAME.blind.boss then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger,
            }
        end
    end
}

--[[
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
	pos = { x = 14, y = 1 },
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
]]