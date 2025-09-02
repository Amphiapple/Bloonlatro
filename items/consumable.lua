SMODS.ConsumableType { --Power Cards
    key = 'Power',
    primary_colour = HEX('DD9900'),
    secondary_colour = HEX('FFBB00'),
    loc_txt = {
        name = 'Power',
        collection = 'Power Cards',
        undiscovered = { -- description for undiscovered cards in the collection
 			name = 'Not Discovered',
 			text = { 
                'Purchase or use',
                'this card in an',
                'unseeded run to',
                'learn what it does',
            },
 		},
    },
    collection_rows = {4, 5},
    shop_rate = 0,
}

SMODS.Atlas {
    key = 'Consumable',
    path = 'consumables.png',
    px = 71,
    py = 95,
}

SMODS.Consumable { --Volcano
    key = 'volcano',
    set = 'Spectral',
    name = 'Volcano',
    loc_txt = {
        name = 'Volcano',
        text = {
            'Destroy {C:attention}1{} selected',
            'card in hand',
            'Adjacent cards become',
            '{C:attention}Meteor{} cards'
        }
    },
    atlas = 'Consumable',
	pos = { x = 0, y = 3 },
    cost = 4,
	order = 19,
    config = { max_highlighted = 1 },

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_meteor
		return { vars = { card and card.ability.max_highlighted or self.config.max_highlighted } }
	end,
    use = function(self, card, area)
        local destroyed_card = G.hand.highlighted[1]
        local volcano_cards = {}
        for i = 1, #G.hand.cards do
            if G.hand.cards[i] == destroyed_card then
                if i > 1 then 
                    volcano_cards[#volcano_cards+1] = G.hand.cards[i-1]
                end
                if i < #G.hand.cards then
                    volcano_cards[#volcano_cards+1] = G.hand.cards[i+1]
                end
            end
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.4, func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end 
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.1, func = function()
                if destroyed_card.ability.name == 'Glass Card' then 
                    destroyed_card:shatter()
                else
                    destroyed_card:start_dissolve()
                end
                return true
            end 
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.7, func = function()
                for k, v in pairs(volcano_cards) do
                    v:set_ability('m_bloons_meteor', nil, true)
                    v:juice_up()
                end
                return true
            end
        }))
    end
}

SMODS.Consumable { --SMS
    key = 'sms',
    set = 'Power',
    name = 'Super Monkey Storm',
    loc_txt = {
        name = 'Super Monkey Storm',
        text = {
            'Score {C:attention}#1#%{} of the',
            'required chips',
            '{C:inactive}(Max of {C:attention}#2#{C:inactive}){}'
        }
    },
    atlas = 'Consumable',
	pos = { x = 0, y = 0 },
	order = 1,
    config = { percent = 50, max = 20000 }, --Variables: percent = cercent of required chips scored, max = maximum chips cap

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.percent, card.ability.max } }
	end,
    can_use = function(self, card)
        if G.GAME.blind and to_big(G.GAME.blind.chips) > to_big(0) then
            return true
        end
    end,
    use = function(self, card, area, copier)
        local score = G.GAME.blind.chips * card.ability.percent / 100.0
        if score > to_big(card.ability.max) then
            score = to_big(card.ability.max)
        end
        G.GAME.chips = G.GAME.chips + score
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
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('whoosh1')
                delay(0.1)                
                return true
            end
        }))
        if G.GAME.chips/G.GAME.blind.chips >= to_big(1) then
            G.E_MANAGER:add_event(
                Event({
                    trigger = "immediate",
                    func = function()
                        if G.STATE ~= G.STATES.SELECTING_HAND then
                            return false
                        end
                        G.GAME.current_round.semicolon = true
                        G.STATE = G.STATES.HAND_PLAYED
                        G.STATE_COMPLETE = true
                        end_round()
                        return true
                    end,
                }),
                "other"
            )
        end
    end
}

SMODS.Consumable { --Mboost
    key = 'mboost',
    set = 'Power',
    name = 'Monkey Boost',
    loc_txt = {
        name = 'Monkey Boost',
        text = {
            '{X:mult,C:white}X#1#{} Mult next hand',
        }
    },
    atlas = 'Consumable',
	pos = { x = 1, y = 0 },
	order = 2,
    config = { Xmult = 2, active = false }, --Variables: Xmult = Xmult

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.Xmult } }
	end,
    can_use = function(self, card)
        return not card.ability.active
    end,
    use = function(self, card, area, copier)
        if not card.ability.active then
			G.GAME.DESTROY_CARD = copy_card(card)
			G.consumeables:emplace(G.GAME.DESTROY_CARD)
			G.GAME.DESTROY_CARD.ability.active = true
            local eval = function()
                return true
            end
            juice_card_until(G.GAME.DESTROY_CARD, eval, true)
		end
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.active then
            return {
                x_mult = card.ability.Xmult
            }
        elseif context.after and card.ability.active then
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
            delay(0.5)
        end
    end
}

SMODS.Consumable { --Thrive
    key = 'thrive',
    set = 'Power',
    name = 'Thrive',
    loc_txt = {
        name = 'Thrive',
        text = {
            'Retrigger all cards',
            'held in hand and',
            'played next hand',
        }
    },
    atlas = 'Consumable',
	pos = { x = 2, y = 0 },
	order = 3,
    config = { retrigger = 1, active = false }, --Variables: retrigger = retrigger count

    can_use = function(self, card)
        return not card.ability.active
    end,
    use = function(self, card, area, copier)
        if not card.ability.active then
			G.GAME.DESTROY_CARD = copy_card(card)
			G.consumeables:emplace(G.GAME.DESTROY_CARD)
			G.GAME.DESTROY_CARD.ability.active = true
            local eval = function()
                return true
            end
            juice_card_until(G.GAME.DESTROY_CARD, eval, true)
		end
    end,
    calculate = function(self, card, context)
        if context.repetition and (context.cardarea == G.hand or context.cardarea == G.play) and card.ability.active then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.retrigger
            }
        elseif context.after and card.ability.active then
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
            delay(0.5)
        end
    end
}

SMODS.Consumable { --Time
    key = 'time',
    set = 'Power',
    name = 'Time Stop',
    loc_txt = {
        name = 'Time Stop',
        text = {
            'Gain {C:blue}+#1#{} hands',
        }
    },
    atlas = 'Consumable',
	pos = { x = 3, y = 0 },
	order = 4,
    config = { hands = 3 }, --Variables: hands = extra hands

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.hands, card.ability.discards } }
	end,
    can_use = function(self, card)
        if G.GAME.blind and to_big(G.GAME.blind.chips) > to_big(0) then
            return true
        end
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({func = function()
            ease_hands_played(card.ability.hands)
        return true end }))
    end,
}

SMODS.Consumable { --Cash
    key = 'cash',
    set = 'Power',
    name = 'Cash Drop',
    loc_txt = {
        name = 'Cash Drop',
        text = {
            'Gives {C:money}$#1#{} during blinds',
        }
    },
    atlas = 'Consumable',
	pos = { x = 4, y = 0 },
	order = 5,
    config = { money = 15 }, --Variables: money = dollars

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.money } }
	end,
    can_use = function(self, card)
        if G.GAME.blind and to_big(G.GAME.blind.chips) > to_big(0) then
            return true
        end
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)
                ease_dollars(card.ability.money, true)
                return true
            end
        }))
        delay(0.6)
    end
}

SMODS.Consumable { --Farmer
    key = 'farmer',
    set = 'Power',
    name = 'Banana Farmer',
    loc_txt = {
        name = 'Banana Farmer',
        text = {
            'Earn {C:money}$#1#{} at',
            'end of round',
            'Lasts {C:attention}#2#{} rounds',
        }
    },
    atlas = 'Consumable',
	pos = { x = 0, y = 1 },
	order = 6,
    config = { money = 4, rounds = 5, current = 5 }, --Variables: money = dollars, rounds = total lifespan, current = lifespan remaining

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.money, card.ability.current } }
	end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition then
            ease_dollars(card.ability.money, true)
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('$')..card.ability.money,colour = G.C.MONEY, delay = 0.45})
            delay(0.3)
            card.ability.current = card.ability.current - 1
            if card.ability.current <= 0 then
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
                return {
                    message = 'Used!',
                    colour = G.C.FILTER
                }
            end
        end
    end
}

SMODS.Consumable { --Lake
    key = 'lake',
    set = 'Power',
    name = 'Portable Lake',
    loc_txt = {
        name = 'Portable Lake',
        text = {
            '{C:dark_edition}#1#{}#2#'
        }
    },
    atlas = 'Consumable',
	pos = { x = 1, y = 1 },
	order = 7,
    config = { slots = 1, active = false }, --Variables: slots = extra joker slots

    loc_vars = function(self, info_queue, card)
        local function process_num(active)
            if active then
				return '+' .. card.ability.slots
            else
			    return ''
            end
        end
        local function process_var(active)
			if active then
				return ' Joker slot'
            else
			    return 'Does nothing?'
            end
		end
		return { vars = { process_num(card.ability.active), process_var(card.ability.active) } }
	end,
    add_to_deck = function (self, card, from_debuff)
        card.ability.active = false
    end,
    remove_from_deck = function (self, card, from_debuff)
        if card.ability.active then
            G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.slots
        end
    end
}

SMODS.Consumable { --Spikes
    key = 'spikes',
    set = 'Power',
    name = 'Road Spikes',
    loc_txt = {
        name = 'Road Spikes',
        text = {
            'Retrigger each played card',
            '{C:inactive}({C:attention}#1#{C:inactive} remaining)'
        }
    },
    atlas = 'Consumable',
	pos = { x = 2, y = 1 },
	order = 8,
    config = { retrigger = 1, spikes = 10 }, --Variables: retrigger = retrigger count, spikes = number of uses

    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.spikes } }
	end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and card.ability.spikes > 0 then
            card.ability.spikes = card.ability.spikes - 1
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.retrigger
            }
        elseif context.after and card.ability.spikes <= 0 then
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
            delay(0.5)
        end
    end
}

SMODS.Consumable { --Glue
    key = 'gtrap',
    set = 'Power',
    name = 'Glue Trap',
    loc_txt = {
        name = 'Glue Trap',
        text = {
            '{C:attention}Glues #1#{}',
            'selected cards'
        }
    },
    atlas = 'Consumable',
	pos = { x = 3, y = 1 },
	order = 9,
    config = { mod_conv = "m_bloons_glued", max_highlighted = 5 },

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
		return { vars = { card and card.ability.max_highlighted or self.config.max_highlighted } }
	end,
}

SMODS.Consumable { --Psychic
    key = 'psychic',
    set = 'Power',
    name = 'Psychic Blast',
    loc_txt = {
        name = 'Psychic Blast',
        text = {
            '{C:attention}Stuns #1#{}',
            'selected cards',
            'Gain {C:red}+#2#{} discards'
        }
    },
    atlas = 'Consumable',
	pos = { x = 4, y = 1 },
	order = 10,
    config = { max_highlighted = 5, discards = 2 }, --Variables: discards = extra discards

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_stunned
		return { vars = { card and card.ability.max_highlighted or self.config.max_highlighted, card.ability.discards } }
	end,
    use = function (self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4, func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i=1, #G.hand.highlighted do
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function() 
                    G.hand.highlighted[i]:flip();
                    play_sound('card1', percent);
                    G.hand.highlighted[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        delay(0.2)
        for i=1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand.highlighted[i]:set_ability(G.P_CENTERS.m_bloons_stunned);
                    return true
                end
            }))
        end
        for i=1, #G.hand.highlighted do
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip();
                    play_sound('tarot2', percent, 0.6);
                    G.hand.highlighted[i]:juice_up(0.3, 0.3);
                    return true 
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                ease_discard(card.ability.discards, nil, true)
                G.hand:unhighlight_all();
                return true
            end
        }))
        delay(0.5)
    end
}

SMODS.Consumable { --Freezing
    key = 'ftrap',
    set = 'Power',
    name = 'Freezing Trap',
    loc_txt = {
        name = 'Freezing Trap',
        text = {
            '{C:attention}Freezes #1#{}',
            'selected cards'
        }
    },
    atlas = 'Consumable',
	pos = { x = 0, y = 2 },
	order = 11,
    config = { mod_conv = "m_bloons_frozen", max_highlighted = 5 },

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
		return { vars = { card and card.ability.max_highlighted or self.config.max_highlighted } }
	end,
}

SMODS.Consumable { --Pontoon
    key = 'pontoon',
    set = 'Power',
    name = 'Pontoon',
    loc_txt = {
        name = 'Pontoon',
        text = {
            'Use with a {C:attention}Portable Lake{} to',
            'gain {C:dark_edition}+1{} Joker Slot'
        }
    },
    atlas = 'Consumable',
	pos = { x = 1, y = 2 },
	order = 12,
    config = { slots = 1 }, --Variables: slots = extra joker slots

    in_pool = function (self, args)
        local lakes = find_joker('Portable Lake')
        for k, v in pairs(lakes) do
            if not v.ability.active then
                return true
            end
        end
        return false
    end,
    can_use = function(self, card)
        local lakes = find_joker('Portable Lake')
        for k, v in pairs(lakes) do
            if not v.ability.active then
                return true
            end
        end
        return false
    end,
    use = function(self, card, area, copier)
        local lakes = find_joker('Portable Lake')
        for k, v in pairs(lakes) do
            if not v.ability.active then
                v.ability.active = true
                G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.slots
                v:juice_up()
                play_sound('negative', 1.5, 0.4)
                
                break
            end
        end
    end,
}

SMODS.Consumable { --Tech
    key = 'tech',
    set = 'Power',
    name = 'Tech Bot',
    loc_txt = {
        name = 'Tech Bot',
        text = {
            'Copies the ability',
            'of rightmost {C:attention}Joker{}',
            'next hand',
        }
    },
    atlas = 'Consumable',
	pos = { x = 2, y = 2 },
	order = 13,
    config = { retrigger = 1, active = false }, --Variables: retrigger = retrigger count

    can_use = function(self, card)
        return not card.ability.active
    end,
    use = function(self, card, area, copier)
        if not card.ability.active then
			G.GAME.DESTROY_CARD = copy_card(card)
			G.consumeables:emplace(G.GAME.DESTROY_CARD)
			G.GAME.DESTROY_CARD.ability.active = true
            local eval = function()
                return true
            end
            juice_card_until(G.GAME.DESTROY_CARD, eval, true)
		end
    end,
    calculate = function(self, card, context)
        if context.after and card.ability.active then
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
        if card.ability.active then
            return SMODS.blueprint_effect(card, G.jokers.cards[#G.jokers.cards], context)
        end
    end
}

SMODS.Consumable { --Totem
    key = 'etotem',
    set = 'Power',
    name = 'Energizing Totem',
    loc_txt = {
        name = 'Energizing Totem',
        text = {
            '{X:mult,C:white}X#1#{} Mult while in your',
            '{C:attention}consumable{} area',
            'Lasts {C:attention}#2#{} rounds',

        }
    },
    atlas = 'Consumable',
	pos = { x = 3, y = 2 },
	order = 14,
    config = { Xmult = 1.5, rounds = 5, current = 5 }, --Variables: Xmult = Xmult, rounds = total lifespan, current = lifespan remaining

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.Xmult, card.ability.current } }
	end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.Xmult
            }
        elseif context.end_of_round and not context.individual and not context.repetition then
            card.ability.current = card.ability.current - 1
            if card.ability.current <= 0 then
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
                return {
                    message = 'Used!',
                    colour = G.C.FILTER
                }
            end
        end
    end
}

SMODS.Consumable { --Cave Monkey
    key = 'cave',
    set = 'Power',
    name = 'Cave Monkey',
    loc_txt = {
        name = 'Cave Monkey',
        text = {
            'Add a {C:attention}Stone{} card with',
            'an {C:dark_edition}Edition{} to your deck'
        }
    },
    atlas = 'Consumable',
	pos = { x = 4, y = 2 },
	order = 15,

    can_use = function(self, card)
        return true
    end,
    use = function (self, card, area, copier)
        local front = pseudorandom_element(G.P_CARDS, pseudoseed('cave'))
        local stone = SMODS.add_card({
            set = 'Playing Card',
            front = front,
            area = G.deck,
            skip_materialize = false,
        })
        stone:set_ability(G.P_CENTERS.m_stone, nil, true)
        local edition = poll_edition('cave', nil, true, true)
        stone:set_edition(edition, true)
        card_eval_status_text(stone, 'extra', nil, nil, nil, {message = localize('k_plus_stone'), colour = G.C.SECONDARY_SET.Enhanced})

        G.E_MANAGER:add_event(Event({
            func = function()
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                return true
            end
        }))
        draw_card(G.play,G.deck, 90,'up', nil)
        playing_card_joker_effects({true})
    end
}