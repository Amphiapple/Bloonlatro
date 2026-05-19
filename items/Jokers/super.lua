SMODS.Joker { --Super Monkey
    key = 'super_monkey',
    name = 'Super Monkey',
	atlas = 'Joker',
	pos = { x = 0, y = 15 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Super Monkey", category = "magic" },
        extra = { mult = 12 } --Variables: mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult,
            }
        end
    end
}

SMODS.Joker { --Laser Blasts
    key = 'laser_blasts',
    name = 'Laser Blasts',
	atlas = 'Joker',
	pos = { x = 1, y = 15 },
    rarity = 1,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Super Monkey", category = "magic" },
        extra = { mult = 16 } --Variables: mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult,
            }
        end
    end
}

SMODS.Joker { --Plasma Blasts
    key = 'plasma_blasts',
    name = 'Plasma Blasts',
	atlas = 'Joker',
	pos = { x = 2, y = 15 },
    rarity = 1,
	cost = 7,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Super Monkey", category = "magic" },
        extra = { Xmult = 1.5 } --Variables: Xmult = Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.Xmult,
            }
        end
    end
}

SMODS.Joker { --Sun Avatar
    key = 'sun_avatar',
    name = 'Sun Avatar',
	atlas = 'Joker',
	pos = { x = 3, y = 15 },
    rarity = 2,
	cost = 8,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Super Monkey", category = "magic" },
        extra = { Xmult = 2 } --Variables: Xmult = Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local red_suits = 0
            for k, v in ipairs(context.full_hand) do
                if v:is_suit('Hearts', nil, true) or v:is_suit('Diamonds', nil, true) then
                    red_suits = red_suits + 1
                end
            end
            if red_suits > 0 and red_suits == #context.full_hand then
                return {
                    x_mult = card.ability.extra.Xmult,
                }
            end
        end
    end
}

SMODS.Joker { --Super Range
    key = 'super_range',
    name = 'Super Range',
	atlas = 'Joker',
	pos = { x = 6, y = 15 },
    rarity = 1,
	cost = 6,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Super Monkey", category = "magic" },
        extra = { slots = 1 } --Variables: slots = extra shop slots
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.slots } }
    end,
    add_to_deck = function(self, card, from_debuff)
        change_shop_size(card.ability.extra.slots)
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

SMODS.Joker { --Epic Range
    key = 'epic_range',
    name = 'Epic Range',
	atlas = 'Joker',
	pos = { x = 7, y = 15 },
    rarity = 1,
	cost = 6,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Super Monkey", category = "magic" },
        extra = { booster_slots = 1 } --Variables: shop_slots = extra shop slots, booster_slots = reduced booster slots
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.booster_slots } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                SMODS.change_booster_limit(card.ability.extra.booster_slots)
                return true
            end
        }))
    end,
    remove_from_deck = function(self, card, from_debuff)
        SMODS.change_booster_limit(-card.ability.extra.booster_slots)
    end
}

SMODS.Joker { --Robo Monkey
    key = 'robo_monkey',
    name = 'Robo Monkey',
	atlas = 'Joker',
	pos = { x = 8, y = 15 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Super Monkey", category = "magic" },
        extra = { copy = nil } --Variables: copy = copied joker
    },

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local eligible_jokers = {}
            for k, v in ipairs(G.jokers.cards) do
                if v ~= card then
                    table.insert(eligible_jokers, v)
                end
            end
            if next(eligible_jokers) then
                card.ability.extra.copy = pseudorandom_element(eligible_jokers, 'robo_monkey'..G.GAME.round_resets.ante)
            end
        elseif context.after and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function() 
                    card.ability.extra.copy = nil
                    return true
                end
            }))
        end
        if card.ability.extra.copy then
            return SMODS.blueprint_effect(card, card.ability.extra.copy, context)
        end
    end
}

SMODS.Joker { --Tech Terror
    key = 'tech_terror',
    name = 'Tech Terror',
	atlas = 'Joker',
	pos = { x = 9, y = 15 },
    rarity = 2,
	cost = 8,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Super Monkey", category = "magic" },
        extra = { copy = nil } --Variables: copy = copied joker
    },

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local pos = 0
            for k, v in ipairs(G.jokers.cards) do
                if v == card then
                    pos = k
                end
            end
            local r = pseudorandom('tech_terror')
            if r < 0.5 then
                card.ability.extra.copy = G.jokers.cards[pos + 1]
            else
                card.ability.extra.copy = G.jokers.cards[pos - 1]
            end
        elseif context.after and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function() 
                    card.ability.extra.copy = nil
                    return true
                end
            }))
        end
        if card.ability.extra.copy then
            return SMODS.blueprint_effect(card, card.ability.extra.copy, context)
        end
    end
}

SMODS.Joker { --The Anti-Bloon
    key = 'the_anti_bloon',
    name = 'The Anti-Bloon',
	atlas = 'Joker',
	pos = { x = 10, y = 15 },
    rarity = 3,
	cost = 10,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Super Monkey", category = "magic" },
        extra = { current = 1 } --Variables: copy = copied joker
    },

    loc_vars = function(self, info_queue, card)
        local function process_var(pos)
			if pos == 1 then
				return 'right'
            end
			return 'left'
		end
        if card.area and card.area == G.jokers then
            local other_joker
            for k, v in ipairs(G.jokers.cards) do
                if G.jokers.cards[k] == card then other_joker = G.jokers.cards[k + card.ability.extra.current] end
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
            card.ability.extra.current = pseudorandom('the_anti_bloon') > 0.5 and 1 or -1
        end
        local other_joker = nil
        for k, v in ipairs(G.jokers.cards) do
            if G.jokers.cards[k] == card then other_joker = G.jokers.cards[k + card.ability.extra.current] end
        end
        return SMODS.blueprint_effect(card, other_joker, context)
    end,
}

SMODS.Joker { --Knockback
    key = 'knockback',
    name = 'Knockback',
    atlas = 'Joker',
	pos = { x = 11, y = 15 },
    rarity = 1,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Super Monkey", category = "magic" },
        extra = { retrigger = 1, retriggered_cards = {} } --Variables: counter = card index
    },

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            for k, v in ipairs(context.scoring_hand) do
                if k % 2 == 0 then
                    card.ability.extra.retriggered_cards[#card.ability.extra.retriggered_cards+1] = v
                end
            end
        elseif context.repetition and context.cardarea == G.play then
            for k, v in ipairs(card.ability.extra.retriggered_cards) do
                if context.other_card == v then
                    return {
                        message = localize('k_again_ex'),
                        repetitions = card.ability.extra.retrigger,
                    }
                end
            end
        elseif context.after then
            card.ability.extra.retriggered_cards = {}
        end
    end,
}

SMODS.Joker { --Ultravision
    key = 'ultravision',
    name = 'Ultravision',
    atlas = 'Joker',
	pos = { x = 12, y = 15 },
    rarity = 1,
	cost = 6,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Super Monkey", category = "magic" },
        extra = { slots = 2 , discards = -1 } --Variables: slots = extra consumable slots, d_size = discard change
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.slots, card.ability.extra.discards } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.slots
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discards
        ease_discard(card.ability.extra.discards)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.slots
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discards
        ease_discard(-card.ability.extra.discards)
    end,
}

SMODS.Joker { --Dark Knight
    key = 'dark_knight',
    name = 'Dark Knight',
	atlas = 'Joker',
	pos = { x = 13, y = 15 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Super Monkey", category = "magic" },
        extra = { Xmult = 3 } --Variables: Xmult = Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local black_suits = 0
            for k, v in ipairs(G.hand.cards) do
                if v:is_suit('Spades', nil, true) or v:is_suit('Clubs', nil, true) then
                    black_suits = black_suits + 1
                end
            end
            if black_suits == #G.hand.cards then
                return {
                    x_mult = card.ability.extra.Xmult,
                }
            end
        end
    end
}

SMODS.Joker { --Dark Champion
    key = 'dark_champion',
    name = 'Dark Champion',
	atlas = 'Joker',
	pos = { x = 14, y = 15 },
    rarity = 2,
	cost = 9,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Super Monkey", category = "magic" },
        extra = { Xmult = 1.33 } --Variables: Xmult = Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and (context.other_card:is_suit('Spades', nil, true) or context.other_card:is_suit('Clubs', nil, true)) and not context.end_of_round then
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --Legend of the Night
    key = 'legend_of_the_night',
    name = 'Legend of the Night',
	atlas = 'Joker',
	pos = { x = 15, y = 15 },
    rarity = 3,
	cost = 10,
    blueprint_compat = false,
    config = {
        tower_info = { base = "Super Monkey", category = "magic" },
    },

    loc_vars =function (self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_black_hole
    end,
    calculate = function(self, card, context)
        if context.game_over and not G.GAME.blind.boss and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.saved_text = "Saved by Legend of the Night!"
                    return true
                end
            }))
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        local card = create_card('c_black_hole', G.consumeables, nil, nil, nil, nil, 'c_black_hole', 'legend_of_the_night')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
            end
            return {
                message = localize('k_saved_ex'),
                saved = true,
                colour = G.C.RED
            }
        end
    end
}
