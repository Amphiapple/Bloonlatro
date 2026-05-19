SMODS.Joker { --Engineer Monkey
    key = 'engineer_monkey',
    name = 'Engineer Monkey',
	atlas = 'Joker',
	pos = { x = 0, y = 23 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Engineer Monkey", category = "support" },
        extra = { money = 3 } --Variables: money = dollars
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
		if context.before and context.poker_hands then
            if next(context.poker_hands['Straight Flush']) then
                return {
                    dollars = card.ability.extra.money * 2,
                    colour = G.C.MONEY
                }
            elseif next(context.poker_hands['Straight']) or next(context.poker_hands['Flush']) then
                return {
                    dollars = card.ability.extra.money,
                    colour = G.C.MONEY
                }
            end
        end
	end
}

SMODS.Joker { --Sentry Gun
    key = 'sentry_gun',
    name = 'Sentry Gun',
    atlas = 'Joker',
	pos = { x = 1, y = 23 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Engineer Monkey", category = "support" },
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_bloons_sentry
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local joker = create_card('j_bloons_sentry', G.jokers, nil, 0, nil, nil, 'j_bloons_sentry', 'sentry_gun')
                    joker:add_to_deck()
                    G.jokers:emplace(joker)
                    joker:start_materialize()
                    return true
                end
            }))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
        end
    end
}

SMODS.Joker { --Faster Engineering
    key = 'faster_engineering',
    name = 'Faster Engineering',
    atlas = 'Joker',
	pos = { x = 2, y = 23 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Engineer Monkey", category = "support" },
        extra = { num = 1, denom = 2 } --Variables: num/denom = probability fraction
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_bloons_sentry
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'faster_engineering')
        return { vars = { n, d } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced then
            local num = SMODS.pseudorandom_probability(card, 'faster_engineering', card.ability.extra.num, card.ability.extra.denom, 'faster_engineering') and 2 or 1
            for i = 1, num do
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local joker = create_card('j_bloons_sentry', G.jokers, nil, 0, nil, nil, 'j_bloons_sentry', 'faster_engineering')
                        joker:add_to_deck()
                        G.jokers:emplace(joker)
                        joker:start_materialize()
                        return true
                    end
                }))
            end
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = '+'..num..' Joker', colour = G.C.BLUE})
        end
    end
}

SMODS.Joker { --Sprockets
    key = 'sprockets',
    name = 'Sprockets',
    atlas = 'Joker',
	pos = { x = 3, y = 23 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Engineer Monkey", category = "support" },
        extra = { multiplier = 2 } --Variables: multiplier = sentry stat multiplier
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_bloons_sentry
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local joker = create_card('j_bloons_sentry', G.jokers, nil, 0, nil, nil, 'j_bloons_sentry', 'sprockets')
                    joker:add_to_deck()
                    joker.ability.extra.chips = joker.ability.extra.chips * card.ability.extra.multiplier
                    joker.ability.extra.mult = joker.ability.extra.mult * card.ability.extra.multiplier
                    G.jokers:emplace(joker)
                    joker:start_materialize()
                    return true
                end
            }))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
        end
    end
}

SMODS.Joker { --Sentry Expert
    key = 'sentry_expert',
    name = 'Sentry Expert',
	atlas = 'Joker',
	pos = { x = 4, y = 23 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Engineer Monkey", category = "support" },
        extra = { sentries = { 'j_bloons_crushing_sentry', 'j_bloons_boom_sentry', 'j_bloons_cold_sentry', 'j_bloons_energy_sentry' } }
    },

    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_bloons_crushing_sentry
        info_queue[#info_queue + 1] = G.P_CENTERS.j_bloons_boom_sentry
        info_queue[#info_queue + 1] = G.P_CENTERS.j_bloons_cold_sentry
        info_queue[#info_queue + 1] = G.P_CENTERS.j_bloons_energy_sentry
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced then
            local sentry = pseudorandom_element(card.ability.extra.sentries, 'sentry_expert')
            G.E_MANAGER:add_event(Event({
                func = function()
                    local joker = create_card(sentry, G.jokers, nil, 0, nil, nil, sentry, 'sentry_expert')
                    joker:add_to_deck()
                    G.jokers:emplace(joker)
                    joker:start_materialize()
                    return true
                end
            }))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
        end
    end
}

SMODS.Joker { --Sentry Champion
    key = 'sentry_champion',
    name = 'Sentry Champion',
	atlas = 'Joker',
	pos = { x = 5, y = 23 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Engineer Monkey", category = "support" },
    },

    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.j_bloons_champion_sentry
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local joker = create_card('j_bloons_champion_sentry', G.jokers, nil, 0, nil, nil, 'j_bloons_champion_sentry', 'sentry_champion')
                    joker:add_to_deck()
                    G.jokers:emplace(joker)
                    joker:start_materialize()
                    return true
                end
            }))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
        end
    end
}

SMODS.Joker { --Larger Service Area
    key = 'larger_service_area',
    name = 'Larger Service Area',
    atlas = 'Joker',
	pos = { x = 6, y = 23 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Engineer Monkey", category = "support" },
        extra = { money = 3, number = 5 } --Variables: money = dollars, number = required cards
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money, card.ability.extra.number } }
    end,
    calculate = function(self, card, context)
        if context.before and #context.scoring_hand == 5 then
            return {
                dollars = card.ability.extra.money,
                colour = G.C.MONEY
            }
        end
    end
}

SMODS.Joker { --Deconstruction
    key = 'deconstruction',
    name = 'Deconstruction',
    atlas = 'Joker',
	pos = { x = 7, y = 23 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Engineer Monkey", category = "support" },
        extra = { mult = 4 } --Variables: mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.other_joker and 
            (context.other_joker.ability.tower_info and context.other_joker.ability.tower_info.base and context.other_joker.ability.tower_info.base == 'Engineer Monkey' or 
             context.other_joker.ability.tower_info and context.other_joker.ability.tower_info.base and context.other_joker.ability.tower_info.base == 'Sentry') then
            G.E_MANAGER:add_event(Event({
                func = function()
                    context.other_joker:juice_up(0.5, 0.5)
                    return true
                end
            }))
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --Cleansing Foam
    key = 'cleansing_foam',
    name = 'Cleansing Foam',
    atlas = 'Joker',
	pos = { x = 8, y = 23 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Engineer Monkey", category = "support" },
        extra = { poker_hand = 'Straight Flush' }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_TAGS.tag_bloons_cleansing
        return { vars = { localize(card.ability.extra.poker_hand, 'poker_hands') } }
    end,
    calculate = function(self, card, context)
        if context.before and next(context.poker_hands[card.ability.extra.poker_hand]) then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    add_tag(Tag('tag_bloons_cleansing'))
                    play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                    return true
                end)
            }))
            return nil, true
        end
    end
}

SMODS.Joker { --Overclock
    key = 'overclock',
    name = 'Overclock',
    atlas = 'Joker',
	pos = { x = 9, y = 23 },
    rarity = 2,
	cost = 8,
    blueprint_compat = true,
    eternal_compat = false,
    config = {
        tower_info = { base = "Engineer Monkey", category = "support" },
        extra = { Xmult = 3, hands = 10 } --Variables: Xmult = Xmult, hands = hands remaining
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.hands } }
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
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.RED
                }
            else
                return {
                    message = card.ability.extra.hands..'',
                }
            end
        end
    end
}

SMODS.Joker { --Ultraboost
    key = 'ultraboost',
    name = 'Ultraboost',
	atlas = 'Joker',
	pos = { x = 10, y = 23 },
    rarity = 3,
	cost = 9,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Engineer Monkey", category = "support" },
        extra = { Xmult = 0.1, Xmult_max = 1 } --Variables: Xmult = permanent Xmult on cards, Xmult_max = maximum Xmult,
    }, 

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.Xmult_max + 1 } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            context.other_card.ability.perma_x_mult = context.other_card.ability.perma_x_mult or 1
            if context.other_card.ability.perma_x_mult + card.ability.extra.Xmult > card.ability.extra.Xmult_max then
                context.other_card.ability.perma_x_mult = card.ability.extra.Xmult_max
            else
                context.other_card.ability.perma_x_mult = context.other_card.ability.perma_x_mult + card.ability.extra.Xmult
            end
            return {
                extra = {message = localize('k_upgrade_ex'), colour = G.C.MULT},
                colour = G.C.CMULT,
            }
        end
    end

}

SMODS.Joker { --Oversize Nails
    key = 'oversize_nails',
    name = 'Oversize Nails',
	atlas = 'Joker',
	pos = { x = 11, y = 23 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Engineer Monkey", category = "support" },
        extra = { money = 4 } --Variables: money = dollars
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money, card.ability.extra.number } }
    end,
    calculate = function(self, card, context)
		if context.before and context.poker_hands then
            if next(context.poker_hands['Straight Flush']) then
                return {
                    dollars = card.ability.extra.money * 2,
                    colour = G.C.MONEY
                }
            elseif next(context.poker_hands['Straight']) or next(context.poker_hands['Flush']) then
                return {
                    dollars = card.ability.extra.money,
                    colour = G.C.MONEY
                }
            end
        end
	end
}

SMODS.Joker { --Pin
    key = 'pin',
    name = 'Pin',
	atlas = 'Joker',
	pos = { x = 12, y = 23 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Engineer Monkey", category = "support" },
        extra = { Xmult = 1.5 } --Variables: Xmult = Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    add_to_deck = function(self, card, from_debuff)
        card.pinned = true
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --Double Gun
    key = 'double_gun',
    name = 'Double Gun',
	atlas = 'Joker',
	pos = { x = 13, y = 23 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Engineer Monkey", category = "support" },
        extra = { money = 1, pairs = {} } --Variables: money = dollars per held pair, pairs = held pairs
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        if context.before then
            local idx_by_id = {}
            for k, v in ipairs(G.hand.cards) do
                local id = v:get_id()
                if idx_by_id[id] then
                    card.ability.extra.pairs[#card.ability.extra.pairs+1] = v
                    idx_by_id[id] = nil
                else
                    idx_by_id[id] = k
                end
            end
        elseif context.individual and context.cardarea == G.hand and not context.other_card.debuff and not context.end_of_round then
            for k, v in pairs(card.ability.extra.pairs) do
                if context.other_card == v then
                    G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.money
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            G.GAME.dollar_buffer = 0;
                            return true
                        end)
                    }))
                    return {
                        dollars = card.ability.extra.money,
                    }
                end
            end
        elseif context.after then
            card.ability.extra.pairs = {}
        end
    end
}

SMODS.Joker { --Bloon Trap
    key = 'bloon_trap',
    name = 'Bloon Trap',
	atlas = 'Joker',
	pos = { x = 14, y = 23 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Engineer Monkey", category = "support" },
        extra = { money = 4, current = 0 } --Variables: money = dollars per card, current = current collected money
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money, card.ability.extra.current } }
    end,
    
    calc_dollar_bonus = function(self, card)
        if card.ability.extra.current > 0 and G.GAME.last_blind and G.GAME.last_blind.boss then
            local money = card.ability.extra.current
            card.ability.extra.current = 0
            return money
        end
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function()
                return (G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES)
            end
            juice_card_until(card, eval, true)
        elseif context.discard and G.GAME.current_round.discards_used == 0 and #context.full_hand == 1 then
            card.ability.extra.current = card.ability.extra.current + card.ability.extra.money
            return {
                message = localize('$')..card.ability.extra.current,
                colour = G.C.MONEY,
                delay = 0.45,
                remove = true,
            }
        end
    end,
}

SMODS.Joker { --XXXL Trap
    key = 'xxxl_trap',
    name = 'XXXL Trap',
	atlas = 'Joker',
	pos = { x = 15, y = 23 },
    rarity = 3,
	cost = 9,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Engineer Monkey", category = "support" },
        extra = { current = 0 } --Variables: current = current collected money
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current } }
    end,
    
    calc_dollar_bonus = function(self, card)
        if card.ability.extra.current > 0 and G.GAME.last_blind and G.GAME.last_blind.boss then
            local money = card.ability.extra.current
            card.ability.extra.current = 0
            return money
        end
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function()
                return (G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES)
            end
            juice_card_until(card, eval, true)
        elseif context.discard and G.GAME.current_round.discards_used == 0 and #context.full_hand == 1 then
            local money = SMODS.has_no_rank(context.full_hand[1]) and 0 or context.full_hand[1].base.nominal
            card.ability.extra.current = card.ability.extra.current + money
            return {
                message = localize('$')..card.ability.extra.current,
                colour = G.C.MONEY,
                delay = 0.45,
                remove = true,
            }
        end
    end,
}
