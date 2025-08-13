SMODS.ConsumableType { --Power Cards
    key = 'Power',
    primary_colour = HEX('DD9900'),
    secondary_colour = HEX('FFBB00'),
    loc_txt = {
        name = 'Power',
        collection = 'Power Cards',
    },
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
    config = { percent = 50, max = 10000 },

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.percent, card.ability.max } }
	end,
    can_use = function(self, card)
        if G.GAME.blind and G.GAME.blind.chips > 0 then
            return true
        end
    end,
    use = function(self, card, area, copier)
        local score = G.GAME.blind.chips * card.ability.percent / 100.0
        if score > card.ability.max then
            score = card.ability.max
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
        if G.GAME.chips >= G.GAME.blind.chips then
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
    config = { Xmult = 3, active = false },

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
                return (not G.RESET_JIGGLES)
            end
            juice_card_until(G.GAME.DESTROY_CARD, eval, true)
		end
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.active then
            return {
                x_mult = card.ability.Xmult
            }
        elseif context.end_of_round and not context.individual and not context.repetition and card.ability.active then
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
}

SMODS.Consumable { --Time
    key = 'time',
    set = 'Power',
    name = 'Time Stop',
    loc_txt = {
        name = 'Time Stop',
        text = {
            'Gain {C:blue}+#1#{} hand and {C:red}+#2#{} discards',
        }
    },
    atlas = 'Consumable',
	pos = { x = 3, y = 0 },
	order = 4,
    config = { hands = 1, discards = 2 },

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.hands, card.ability.discards } }
	end,
    can_use = function(self, card)
        if G.GAME.blind and G.GAME.blind.chips > 0 then
            return true
        end
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({func = function()
            ease_hands_played(card.ability.hands)
            ease_discard(card.ability.discards, nil, true)
        return true end }))
    end,
}

SMODS.Consumable { --Cash Drop
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
    config = { dollars = 15 },

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.dollars } }
	end,
    can_use = function(self, card)
        if G.GAME.blind and G.GAME.blind.chips > 0 then
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
                ease_dollars(card.ability.dollars, true)
                return true
            end
        }))
        delay(0.6)
    end
}

SMODS.Consumable { --Glue Trap
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
            'selected cards'
        }
    },
    atlas = 'Consumable',
	pos = { x = 4, y = 1 },
	order = 10,
    config = { mod_conv = "m_bloons_stunned", max_highlighted = 5 },

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_stunned
		return { vars = { card and card.ability.max_highlighted or self.config.max_highlighted } }
	end,
}

SMODS.Consumable { --Freezing Trap
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

SMODS.Consumable { --Energizing Totem
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
	pos = { x = 1, y = 2 },
	order = 12,
    config = { Xmult = 1.5, rounds = 5, current = 5 },

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