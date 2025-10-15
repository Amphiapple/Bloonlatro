SMODS.Joker { --Super Monkey
    key = 'super',
    name = 'Super Monkey',
	loc_txt = {
        name = 'Super Monkey',
        text = {
            '{X:mult,C:white}X#1#{} Mult'
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 1 },
    rarity = 1,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'super',
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

SMODS.Joker { --Laser Blasts
    key = 'laser',
    name = 'Laser Blasts',
	loc_txt = {
        name = 'Laser Blasts',
        text = {
            '{X:mult,C:white}X#1#{} Base Mult',
            '{X:mult,C:white}X#1#{} Mult'
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 2 },
    rarity = 1,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'super',
        extra = { Xmult = 1.25 } --Variables: Xmult = Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.initial_scoring_step then
            return {
                x_mult = card.ability.extra.Xmult,
            }
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.Xmult,
            }
        end
    end
}

SMODS.Joker { --Ultravision
    key = 'uv',
    name = 'Ultravision',
    loc_txt = {
        name = 'Ultravision',
        text = {
            '{C:attention}+#1#{} consumable slots',
            '{C:red}#2#{} discard'
        }
    },
    atlas = 'Joker',
	pos = { x = 4, y = 4 },
    rarity = 2,
	cost = 6,
    blueprint_compat = false,
    config = {
        base = 'super',
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


SMODS.Joker { --Sun Avatar
    key = 'sav',
    name = 'Sun Avatar',
    loc_txt = {
        name = 'Sun Avatar',
        text = {
            '{C:planet}Planet{} cards in your',
            '{C:attention}consumable{} area give {X:red,C:white}X#1#{} Mult',
            'for their specified {C:attention}poker hand{}',
            'and {X:red,C:white}X#2#{} Mult otherwise',
        }
    },
    atlas = 'Joker',
    pos = { x = 4, y = 7 },
    rarity = 2,
    cost = 8,
    blueprint_compat = true,
    config = {
        base = 'super',
        extra = { Xmult_match = 2, Xmult = 1.5 } --Variables: Xmult_match = Xmult if planet matches, Xmult = Xmult otherwise
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult_match, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.other_consumeable
            and context.other_consumeable.ability.set == "Planet"
            and not context.other_consumeable.debuff then
            local sav_mult = (context.other_consumeable.ability.consumeable.hand_type == context.scoring_name)
                and card.ability.extra.Xmult_match
                or card.ability.extra.Xmult
            return {
                x_mult = sav_mult,
                message_card = context.other_consumeable
            }
        end
    end
}

SMODS.Joker { --Tech Terror
    key = 'tech',
    name = 'Tech Terror',
	loc_txt = {
        name = 'Tech Terror',
        text = {
            'Retrigger all played cards',
            'between {C:attention}first{} and {C:attention}last{}',
            'scoring card {C:attention}#1#{} times'
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 10 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        base = 'super',
        extra = { retrigger = 2 } --Variables: retrigger = retrigger count
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.retrigger } }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and (context.other_card ~= context.scoring_hand[1] and context.other_card ~= context.scoring_hand[#context.scoring_hand]) then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retrigger
            }
        end
    end
}

SMODS.Joker { --Legend of the Night
    key = 'lotn',
    name = 'Legend of the Night',
	loc_txt = {
        name = 'Legend of the Night',
        text = {
            'Prevents Death on',
            '{C:attention}Small Blind{} or {C:attention}Big Blind{}',
            'and create a {C:spectral}Black Hole{}',
            '{C:inactive}(Must have room){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 13 },
    rarity = 3,
	cost = 10,
    blueprint_compat = false,
    config = {
        base = 'super',
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
                        local card = create_card('c_black_hole', G.consumeables, nil, nil, nil, nil, 'c_black_hole', 'lotn')
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