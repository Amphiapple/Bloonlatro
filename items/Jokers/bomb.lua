SMODS.Joker { --Bomb Shooter
    key = 'bomb_shooter',
    name = 'Bomb Shooter',
	loc_txt = {
        name = 'Bomb Shooter',
        text = {
            '{C:mult}+#1#{} Mult if played',
            'hand contains',
            'a {C:attention}#2#{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 2 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Bomb Shooter", category = "primary" },
        extra = { mult = 8, poker_hand = 'Pair' } --Variables: mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, localize(card.ability.extra.poker_hand, 'poker_hands') } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.poker_hands and next(context.poker_hands[card.ability.extra.poker_hand]) then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --Bigger Bombs
    key = 'bigger_bombs',
    name = 'Bigger Bombs',
	loc_txt = {
        name = 'Bigger Bombs',
        text = {
            '{C:mult}+#1#{} Mult if played',
            'hand contains',
            'a {C:attention}#2#{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 1, y = 2 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Bomb Shooter", category = "primary" },
        extra = { mult = 15, poker_hand = 'Three of a Kind' } --Variables: mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, localize(card.ability.extra.poker_hand, 'poker_hands') } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.poker_hands and next(context.poker_hands[card.ability.extra.poker_hand]) then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --Heavy Bombs
    key = 'heavy_bombs',
    name = 'Heavy Bombs',
	loc_txt = {
        name = 'Heavy Bombs',
        text = {
            '{C:mult}+#1#{} Mult if played',
            'hand contains',
            'a {C:attention}#2#{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 2, y = 2 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Bomb Shooter", category = "primary" },
        extra = { mult = 20, poker_hand = 'Three of a Kind' } --Variables: mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, localize(card.ability.extra.poker_hand, 'poker_hands') } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.poker_hands and next(context.poker_hands[card.ability.extra.poker_hand]) then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --Really Big Bombs
    key = 'really_big_bombs',
    name = 'Really Big Bombs',
	loc_txt = {
        name = 'Really Big Bombs',
        text = {
            '{X:mult,C:white}X#1#{} Mult if played hand',
            'contains a {C:attention}#2#{}',
            '{X:mult,C:white}X#3#{} Mult instead if played hand',
            'contains a {C:attention}#4#{}',
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 2 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Bomb Shooter", category = "primary" },
        extra = { Xmult1 = 2, Xmult2 = 3, poker_hand1 = 'Three of a Kind', poker_hand2 = 'Four of a Kind' } --Variables: Xmult 1 = Xmult if 3oak, Xmult 2 = Xmult if 4oak
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult1, localize(card.ability.extra.poker_hand1, 'poker_hands'), card.ability.extra.Xmult2, localize(card.ability.extra.poker_hand2, 'poker_hands') } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.poker_hands then
            if next(context.poker_hands[card.ability.extra.poker_hand2]) then
                return {
                    x_mult = card.ability.extra.Xmult2
                }
            elseif next(context.poker_hands[card.ability.extra.poker_hand1]) then
                return {
                    x_mult = card.ability.extra.Xmult1
                }
            end
        end
    end
}

SMODS.Joker { --Bloon Impact
    key = 'bloon_impact',
    name = 'Bloon Impact',
    loc_txt = {
        name = 'Bloon Impact',
        text = {
            '{C:attention}Stun{} all cards in',
            '{C:attention}first discard{} of round',
            '{C:mult}+#1#{} Mult if any {C:attention}Stunned{}',
            'cards wear off',
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 2 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Bomb Shooter", category = "primary" },
        extra = { mult = 20 } --Variables: mult = +mult if any stunned
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_bloons_stunned
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function()
                return (G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES)
            end
            juice_card_until(card, eval, true)
        elseif context.discard and not context.hook and not context.other_card.debuff and not context.blueprint then
            if G.GAME.current_round.discards_used == 0 then
                context.other_card:set_ability('m_bloons_stunned', nil, true)
                return {
                    message = 'Stunned!',
                    colour = G.C.RED
                }
            end
        elseif context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --Bloon Crush
    key = 'bloon_crush',
    name = 'Bloon Crush',
    loc_txt = {
        name = 'Bloon Crush',
        text = {
            '{C:attention}Stun{} all cards in',
            '{C:attention}first discard{} of round',
            '{X:mult,C:white}X#1#{} Mult if any {C:attention}Stunned{}',
            'cards wear off',
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 2 },
    rarity = 3,
	cost = 9,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Bomb Shooter", category = "primary" },
        extra = { Xmult = 3 } --Variables: Xmult = Xmult if any stunned
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_bloons_stunned
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function()
                return (G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES)
            end
            juice_card_until(card, eval, true)
        elseif context.discard and not context.hook and not context.other_card.debuff and not context.blueprint then
            if G.GAME.current_round.discards_used == 0 then
                context.other_card:set_ability('m_bloons_stunned', nil, true)
                return {
                    message = 'Stunned!',
                    colour = G.C.RED
                }
            end
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --Faster Reload
    key = 'faster_reload_bomb',
    name = 'Faster Reload (Bomb)',
    loc_txt = {
        name = 'Faster Reload',
        text = {
            '{C:mult}+#1#{} Mult if played',
            'hand contains',
            'a {C:attention}#2#{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 6, y = 2 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Bomb Shooter", category = "primary" },
        extra = { mult = 12, poker_hand = 'Pair' } --Variables: mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, localize(card.ability.extra.poker_hand, 'poker_hands') } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.poker_hands and next(context.poker_hands[card.ability.extra.poker_hand]) then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --Missile Launcher
    key = 'missile_launcher',
    name = 'Missile Launcher',
    loc_txt = {
        name = 'Missile Launcher',
        text = {
            '{C:mult}+#1#{} Mult if played',
            'hand contains',
            'a {C:attention}#2#{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 7, y = 2 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Bomb Shooter", category = "primary" },
        extra = { mult = 15, poker_hand = 'Two Pair' } --Variables: mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, localize(card.ability.extra.poker_hand, 'poker_hands') } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.poker_hands and next(context.poker_hands[card.ability.extra.poker_hand]) then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --MOAB Mauler
    key = 'moab_mauler',
    name = 'MOAB Mauler',
	loc_txt = {
        name = 'MOAB Mauler',
        text = {
            '{X:mult,C:white}X#1#{} Mult against',
            '{C:attention}Boss Blinds{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 8, y = 2 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Bomb Shooter", category = "primary" },
        extra = { Xmult = 2 } --Variables: Xmult = Xmult
    },

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.blind.boss then
            return {
                x_mult = card.ability.extra.Xmult
            }
        end
    end
}

SMODS.Joker { --MOAB Assassin
    key = 'moab_assassin',
    name = 'MOAB Assassin',
	loc_txt = {
        name = 'MOAB Assassin',
        text = {
            '{X:mult,C:white}X#1#{} Mult against',
            '{C:attention}Boss Blinds{} every',
            '{C:attention}#2#{} hands played',
            '{C:inactive}(#3#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 2 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Bomb Shooter", category = "primary" },
        extra = { Xmult = 3, limit = 2, counter = 2 } --Variables: Xmult = Xmult, limit = number of hands for tarot, counter = hand index
    },

    loc_vars = function(self, info_queue, card)
        local function process_var(count, cap)
			if count == cap - 1 then
				return 'Active!'
			end
			return cap - count%cap - 1 .. ' remaining'
		end
		return {
			vars = {
				card.ability.extra.Xmult,
				card.ability.extra.limit,
                process_var(card.ability.extra.counter, card.ability.extra.limit)
			},
		}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.counter = (G.GAME.hands_played - card.ability.hands_played_at_create)%(card.ability.extra.limit) + 1
            if not context.blueprint then
                local eval = function()
                    return (card.ability.extra.counter == card.ability.extra.limit - 1 and G.GAME.blind and G.GAME.blind.boss)
                end
                juice_card_until(card, eval, true)
            end
            if card.ability.extra.counter == card.ability.extra.limit and G.GAME.blind.boss then
                return {
                    x_mult = card.ability.extra.Xmult,
                }
            end
        end
    end
}

SMODS.Joker { --MOAB Eliminator
    key = 'moab_eliminator',
    name = 'MOAB Eliminator',
	loc_txt = {
        name = 'MOAB Eliminator',
        text = {
            '{X:mult,C:white}X#1#{} Mult against',
            '{C:attention}Boss Blinds{}',
            '{X:mult,C:white}X#2#{} Mult otherwise',
        }
    },
	atlas = 'Joker',
	pos = { x = 10, y = 2 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Bomb Shooter", category = "primary" },
        extra = { Xmult1 = 4, Xmult2 = 0.75 } --Variables: Xmult1 = Xmult for bosses, Xmult2 = Xmult for non-bosses
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult1, card.ability.extra.Xmult2 } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if G.GAME.blind.boss then
                return {
                    x_mult = card.ability.extra.Xmult1,
                }
            else
                return {
                    x_mult = card.ability.extra.Xmult2,
                }
            end
        end
    end
}

SMODS.Joker { --Extra Range
    key = 'extra_range',
    name = 'Extra Range',
	loc_txt = {
        name = 'Extra Range',
        text = {
            '{C:chips}+#1#{} Chips if played',
            'hand contains',
            'a {C:attention}#2#{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 11, y = 2 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Bomb Shooter", category = "primary" },
        extra = { chips = 50, poker_hand = 'Pair' } --Variables: chips = +chips
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, localize(card.ability.extra.poker_hand, 'poker_hands') } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.poker_hands and next(context.poker_hands[card.ability.extra.poker_hand]) then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
}

SMODS.Joker { --Frag Bombs
    key = 'frag_bombs',
    name = 'Frag Bombs',
	loc_txt = {
        name = 'Frag Bombs',
        text = {
            '{C:chips}+#1#{} Chips times the',
            'rank of the highest',
            'played {C:attention}#2#{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 12, y = 2 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Bomb Shooter", category = "primary" },
        extra = { chips = 8, poker_hand = 'Pair' } --Variables: chips = +chips
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, localize(card.ability.extra.poker_hand, 'poker_hands') } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands[card.ability.extra.poker_hand]) then
            local idx_by_id = {}
            local max = 0
            for k, v in ipairs(context.scoring_hand) do
                local id = v:get_id()
                local rank = SMODS.has_no_rank(v) and 0 or v.base.nominal
                if idx_by_id[id] and rank > max then
                    max = rank
                else
                    idx_by_id[id] = k
                end
            end
            return {
                chips = card.ability.extra.chips * max
            }
        end
    end
}

SMODS.Joker { --Cluster Bombs
    key = 'cluster_bombs',
    name = 'Cluster Bombs',
	loc_txt = {
        name = 'Cluster Bombs',
        text = {
            '{C:chips}+#1#{} Chips if',
            '{C:attention}poker hand{} is the',
            'same as previous',
            '{C:attention}poker hand {C:inactive}#2#{}',
        }
    },
	atlas = 'Joker',
	pos = { x = 13, y = 2 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Bomb Shooter", category = "primary" },
        extra = { chips = 100, poker_hand = '' } --Variables: chips = +chips, poker_hand = previous poker hand
    },

    loc_vars = function(self, info_queue, card)
        local function process_var(poker_hand)
            return poker_hand ~= '' and '[' .. poker_hand .. ']' or poker_hand
        end
		return { vars = { card.ability.extra.chips, process_var(card.ability.extra.poker_hand) } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if context.scoring_name == card.ability.extra.poker_hand then
                return {
                    chips = card.ability.extra.chips
                }
            else
                card.ability.extra.poker_hand = context.scoring_name
            end
        end
    end
}

SMODS.Joker { --Recursive Cluster
    key = 'recursive_cluster',
    name = 'Recursive Cluster',
	loc_txt = {
        name = 'Recursive Cluster',
        text = {
            '{X:mult,C:white}X#1#{} Mult if',
            '{C:attention}poker hand{} is the same',
            '{C:attention}3{} times in a row',
            '{C:inactive}(#2#){}',
        }
    },
	atlas = 'Joker',
	pos = { x = 14, y = 2 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Bomb Shooter", category = "primary" },
        extra = { Xmult = 2.5, poker_hands = {} } --Variables: Xmult = Xmult, poker_hand1 = previous poker hand
    },

    loc_vars = function(self, info_queue, card)
        local function process_var(poker_hands)
			if next(poker_hands) == nil then
				return 'None'
			end
            local hands_string = poker_hands[1]
            if poker_hands[2] then
                hands_string = hands_string .. ' ' .. poker_hands[2]
            end
			return hands_string
		end
		return { vars = { card.ability.extra.Xmult, process_var(card.ability.extra.poker_hands) } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.poker_hands[#card.ability.extra.poker_hands+1] = context.scoring_name
            if #card.ability.extra.poker_hands >= 3 then
                local active = false
                if context.scoring_name == card.ability.extra.poker_hands[1] and context.scoring_name == card.ability.extra.poker_hands[2] then
                    active = true
                end
                table.remove(card.ability.extra.poker_hands, 1)
                if active then
                    return {
                        x_mult = card.ability.extra.Xmult
                    }
                end
            end
        end
    end
}

SMODS.Joker { --Bomb Blitz
    key = 'bomb_blitz',
    name = 'Bomb Blitz',
	loc_txt = {
        name = 'Bomb Blitz',
        text = {
            'Prevents Death if chips scored',
            'are at least {C:attention}#1#%{} of required chips',
            'and destroy all cards held in hand',
            '{s:1.1,C:red,E:2}self destructs{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 15, y = 2 },
    rarity = 3,
	cost = 8,
    blueprint_compat = false,
    eternal_compat = false,
    config = {
        tower_info = { base = "Bomb Shooter", category = "primary" },
        extra = { percent = 25 } --Variables: percent = percent of required chips scored
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.percent } }
    end,
    calculate = function(self, card, context)
        if context.game_over and G.GAME.chips/G.GAME.blind.chips >= to_big(card.ability.extra.percent / 100.0) and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.saved_text = "Saved by Bomb Blitz!"
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand_text_area.blind_chips:juice_up()
                    G.hand_text_area.game_chips:juice_up()
                    play_sound('tarot1')
                    card:start_dissolve({G.C.RED}, nil)
                    return true
                end
            }))
            local destroyed_cards = {}
            for k, v in ipairs(G.hand.cards) do
                destroyed_cards[#destroyed_cards+1] = v
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
            return {
                message = localize('k_saved_ex'),
                saved = true,
                colour = G.C.RED
            }
        end
    end
}