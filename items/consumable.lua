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

SMODS.Consumable { --Super Monkey Storm
    key = 'super_monkey_storm',
    set = 'Power',
    name = 'Super Monkey Storm',
    atlas = 'Consumable',
    pos = { x = 0, y = 0 },
    config = { percent = 80, max = 20000 }, --Variables: percent = percent of required chips scored, max = maximum chips cap

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.percent, card.ability.max } }
    end,
    can_use = function(self, card)
        return G.GAME.blind and to_big(G.GAME.blind.chips) > to_big(0)
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
        G.E_MANAGER:add_event(
            Event({
                trigger = "immediate",
                func = function()
                    if G.GAME.chips/G.GAME.blind.chips >= to_big(1) and G.STATE == G.STATES.SELECTING_HAND then
                        G.GAME.current_round.semicolon = true
                        G.STATE = G.STATES.HAND_PLAYED
                        G.STATE_COMPLETE = true
                        end_round()
                        return true
                    end
                    return false
                end,
            }),
            "other"
        )
    end
}

SMODS.Consumable { --Monkey_boost
    key = 'monkey_boost',
    set = 'Power',
    name = 'Monkey Boost',
    atlas = 'Consumable',
    pos = { x = 1, y = 0 },
    config = { Xmult = 2, active = false }, --Variables: Xmult = Xmult

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.Xmult } }
    end,
    can_use = function(self, card)
        return G.GAME.blind and to_big(G.GAME.blind.chips) > to_big(0) and not card.ability.active
    end,
    use = function(self, card, area, copier)
        if not card.ability.active then
			G.GAME.DESTROY_CARD = copy_card(card)
            if not (card.edition and card.edition.negative) then
                G.GAME.DESTROY_CARD:set_edition({negative = true}, true)
                G.GAME.DESTROY_CARD.sell_cost = card.sell_cost
            end
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
    atlas = 'Consumable',
    pos = { x = 2, y = 0 },
    config = { retrigger = 1, active = false }, --Variables: retrigger = retrigger count

    can_use = function(self, card)
        return G.GAME.blind and to_big(G.GAME.blind.chips) > to_big(0) and not card.ability.active
    end,
    use = function(self, card, area, copier)
        if not card.ability.active then
			G.GAME.DESTROY_CARD = copy_card(card)
            if not (card.edition and card.edition.negative) then
                G.GAME.DESTROY_CARD:set_edition({negative = true}, true)
                G.GAME.DESTROY_CARD.sell_cost = card.sell_cost
            end
			G.consumeables:emplace(G.GAME.DESTROY_CARD)
			G.GAME.DESTROY_CARD.ability.active = true
            local eval = function()
                return true
            end
            juice_card_until(G.GAME.DESTROY_CARD, eval, true)
        end
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.hand and card.ability.active then
            return {
                repetitions = card.ability.retrigger
            }
        elseif context.after and card.ability.active and (hand_chips*mult + G.GAME.chips)/G.GAME.blind.chips < to_big(1) then
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
        elseif context.end_of_round and card.ability.active and not context.individual and not context.repetition then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
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

SMODS.Consumable { --Time Stop
    key = 'time_stop',
    set = 'Power',
    name = 'Time Stop',
    atlas = 'Consumable',
    pos = { x = 3, y = 0 },
    config = { hands = 3 }, --Variables: hands = extra hands

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.hands } }
    end,
    can_use = function(self, card)
        return G.GAME.blind and to_big(G.GAME.blind.chips) > to_big(0)
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function()
                ease_hands_played(card.ability.hands)
                return true
            end
        }))
    end,
}

SMODS.Consumable { --Cash Drop
    key = 'cash_drop',
    set = 'Power',
    name = 'Cash Drop',
    atlas = 'Consumable',
    pos = { x = 4, y = 0 },
    config = { money = 15 }, --Variables: money = dollars

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.money } }
    end,
    can_use = function(self, card)
        return true
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

SMODS.Consumable { --Banana Farmer
    key = 'banana_farmer',
    set = 'Power',
    name = 'Banana Farmer',
    atlas = 'Consumable',
    pos = { x = 0, y = 1 },
    config = { money = 4, rounds = 5, current = 5 }, --Variables: money = dollars, rounds = total lifespan, current = lifespan remaining

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.money, card.ability.current } }
    end,
    calc_dollar_bonus = function(self, card)
        local money = card.ability.money
        card.ability.current = card.ability.current - 1
        if card.ability.current <= 0 then
            G.E_MANAGER:add_event(Event({
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = 'Used!',
                    colour = G.C.FILTER
                }),
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
        return money
    end
}

SMODS.Consumable { --Portable Lake
    key = 'portable_lake',
    set = 'Power',
    name = 'Portable Lake',
    atlas = 'Consumable',
    pos = { x = 1, y = 1 },
    config = { slots = 1, active = false }, --Variables: slots = extra joker slots

    loc_vars = function(self, info_queue, card)
        local function process_num(active)
            return active and '+' .. card.ability.slots or ''
        end
        local function process_var1(active)
            return active and ' Joker slot' or ''
        end
        local function process_var2(active)
            return active and '' or 'Does nothing?'
        end
        return { vars = { process_num(card.ability.active), process_var1(card.ability.active), process_var2(card.ability.active) } }
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

SMODS.Consumable { --Road Spikes
    key = 'road_spikes',
    set = 'Power',
    name = 'Road Spikes',
    atlas = 'Consumable',
    pos = { x = 2, y = 1 },
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

SMODS.Consumable { --Glue Trap
    key = 'glue_trap',
    set = 'Power',
    name = 'Glue Trap',
    atlas = 'Consumable',
    pos = { x = 3, y = 1 },
    config = { mod_conv = "m_bloons_glued", max_highlighted = 5 },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_glued
        return { vars = { card and card.ability.max_highlighted or self.config.max_highlighted } }
    end,
}

SMODS.Consumable { --Freezing Trap
    key = 'freezing_trap',
    set = 'Power',
    name = 'Freezing Trap',
    atlas = 'Consumable',
    pos = { x = 4, y = 1 },
    config = { mod_conv = "m_bloons_frozen", max_highlighted = 5 },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bloons_frozen
        return { vars = { card and card.ability.max_highlighted or self.config.max_highlighted } }
    end,
}

SMODS.Consumable { --Camo Trap
    key = 'camo_trap',
    set = 'Power',
    name = 'Camo Trap',
    atlas = 'Consumable',
    pos = { x = 0, y = 2 },
    config = { discards = 3 }, --Variables: discards = extra discards

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.discards } }
    end,
    can_use = function(self, card)
        return G.GAME.blind and to_big(G.GAME.blind.chips) > to_big(0)
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function()
                ease_discard(card.ability.discards)
                return true
            end
        }))
    end,
}

SMODS.Consumable { --Pontoon
    key = 'pontoon',
    set = 'Power',
    name = 'Pontoon',
    atlas = 'Consumable',
    pos = { x = 1, y = 2 },
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

SMODS.Consumable { --Tech Bot
    key = 'tech_bot',
    set = 'Power',
    name = 'Tech Bot',
    atlas = 'Consumable',
    pos = { x = 2, y = 2 },
    config = { retrigger = 1, active = false }, --Variables: retrigger = retrigger count

    can_use = function(self, card)
        return G.GAME.blind and to_big(G.GAME.blind.chips) > to_big(0) and not card.ability.active
    end,
    use = function(self, card, area, copier)
        if not card.ability.active then
			G.GAME.DESTROY_CARD = copy_card(card)
            if not (card.edition and card.edition.negative) then
                G.GAME.DESTROY_CARD:set_edition({negative = true}, true)
                G.GAME.DESTROY_CARD.sell_cost = card.sell_cost
            end
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

SMODS.Consumable { --Energizing Totem
    key = 'energizing_totem',
    set = 'Power',
    name = 'Energizing Totem',
    atlas = 'Consumable',
    pos = { x = 3, y = 2 },
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
    key = 'cave_monkey',
    set = 'Power',
    name = 'Cave Monkey',
    atlas = 'Consumable',
    pos = { x = 4, y = 2 },

    can_use = function(self, card)
        return true
    end,
    use = function (self, card, area, copier)
        local front = pseudorandom_element(G.P_CARDS, pseudoseed('cave_monkey'))
        local stone = SMODS.add_card({
            set = 'Playing Card',
            front = front,
            area = G.deck,
            skip_materialize = false,
        })
        stone:set_ability(G.P_CENTERS.m_stone, nil, true)
        local edition = poll_edition('cave_monkey', nil, true, true)
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

SMODS.Consumable { --Storm of Arrows
    key = 'storm_of_arrows',
    set = 'Power',
    name = 'Storm of Arrows',
    atlas = 'Consumable',
    pos = { x = 0, y = 3 },
    config = { num = 1, denom = 2, Xmult = 2, active = false }, --Variables: num/denom = probability fraction, Xmult = Xmult

    in_pool = function(self, args)
        return G.GAME.selected_back.name == 'Quincy Deck'
    end,
    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(self, self.config.num, self.config.denom, 'storm_of_arrows')
        return { vars = { n, d, card.ability.Xmult } }
    end,
    can_use = function(self, card)
        return G.GAME.blind and to_big(G.GAME.blind.chips) > to_big(0) and not card.ability.active
    end,
    use = function(self, card, area, copier)
        if not card.ability.active then
			G.GAME.DESTROY_CARD = copy_card(card)
            if not (card.edition and card.edition.negative) then
                G.GAME.DESTROY_CARD:set_edition({negative = true}, true)
                G.GAME.DESTROY_CARD.sell_cost = card.sell_cost
            end
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
            if SMODS.pseudorandom_probability(card, 'storm_of_arrows', card.ability.num, card.ability.denom, 'storm_of_arrows') then
                return {
                    x_mult = card.ability.Xmult
                }
            end
        elseif context.end_of_round and card.ability.active and not context.individual and not context.repetition then
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

SMODS.Consumable { --Firestorm
    key = 'firestorm',
    set = 'Power',
    name = 'Firestorm',
    atlas = 'Consumable',
    pos = { x = 1, y = 3 },
    config = { mult = 10, active = false }, --Variables: mult = score multiplier

    in_pool = function(self, args)
        return G.GAME.selected_back.name == 'Gwendolin Deck'
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.mult } }
    end,
    can_use = function(self, card)
        return G.GAME.blind and to_big(G.GAME.blind.chips) > to_big(0) and not card.ability.active
    end,
    use = function(self, card, area, copier)
        if not card.ability.active then
			G.GAME.DESTROY_CARD = copy_card(card)
            if not (card.edition and card.edition.negative) then
                G.GAME.DESTROY_CARD:set_edition({negative = true}, true)
                G.GAME.DESTROY_CARD.sell_cost = card.sell_cost
            end
			G.consumeables:emplace(G.GAME.DESTROY_CARD)
			G.GAME.DESTROY_CARD.ability.active = true
            local eval = function()
                return true
            end
            juice_card_until(G.GAME.DESTROY_CARD, eval, true)
        end
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and card.ability.active then
            return {
                mult = card.ability.mult
            }
        elseif context.destroying_card and card.ability.active and not context.destroying_card.debuff then
            return true
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

SMODS.Consumable { --Artillery Command
    key = 'artillery_command',
    set = 'Power',
    name = 'Artillery Command',
    atlas = 'Consumable',
    pos = { x = 2, y = 3 },
    config = { cost = 0 },

    in_pool = function(self, args)
        return G.GAME.selected_back.name == 'Jones Deck'
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.cost } }
    end,
    can_use = function(self, card)
        return G.STATE == G.STATES.SHOP
    end,
    use = function(self, card, area)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                G.GAME.round_resets.temp_reroll_cost = 0
                G.GAME.current_round.reroll_cost_increase = 0
                calculate_reroll_cost(true)
                return true
            end
        }))
    end
}

SMODS.Consumable { --Wall of Trees
    key = 'wall_of_trees',
    set = 'Power',
    name = 'Wall of Trees',
    atlas = 'Consumable',
    pos = { x = 3, y = 3 },
    config = { money = 1, percent = 5, capacity = 20 },

    in_pool = function(self, args)
        return G.GAME.selected_back.name == 'Obyn Deck'
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.money, card.ability.percent, card.ability.capacity } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition then
            local percent_extra = (G.GAME.chips - G.GAME.blind.chips)/G.GAME.blind.chips * 100
            local money = card.ability.money * math.floor(percent_extra / card.ability.percent)
            card.ability.extra_value = card.ability.extra_value + money
            card:set_cost()
            if card.sell_cost >= card.ability.capacity then
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
                    dollars = card.ability.capacity
                }
            end
            if money > 0 then
                return {
                    message = localize('k_val_up'),
                    colour = G.C.MONEY
                }
            end
        end
    end
}

SMODS.Consumable { --MOAB Barrage
    key = 'moab_barrage',
    set = 'Power',
    name = 'MOAB Barrage',
    atlas = 'Consumable',
    pos = { x = 4, y = 3 },
    config = { Xmult = 2 },

    in_pool = function(self, args)
        return G.GAME.selected_back.name == 'Churchill Deck'
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.Xmult } }
    end,
    use = function(self, card, area)
        
    end
}

SMODS.Consumable { --Siphon Funding
    key = 'siphon_funding',
    set = 'Power',
    name = 'Siphon Funding',
    atlas = 'Consumable',
    pos = { x = 0, y = 4 },
    config = { max_highlighted = 4, money = 1 },

    in_pool = function(self, args)
        return G.GAME.selected_back.name == 'Benjamin Deck'
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted, card.ability.money } }
    end,
    use = function(self, card, area)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for k, v in ipairs(G.hand.highlighted) do
            local percent = 1.15 - (k-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    v:flip();
                    play_sound('card1', percent);
                    v:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        delay(0.2)
        for k, v in ipairs(G.hand.highlighted) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    local suit_prefix = string.sub(v.base.suit, 1, 1)..'_'
                    local rank_suffix = v.base.id == 2 and 14 or math.max(v.base.id-1, 2)
                    if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
                    elseif rank_suffix == 10 then rank_suffix = 'T'
                    elseif rank_suffix == 11 then rank_suffix = 'J'
                    elseif rank_suffix == 12 then rank_suffix = 'Q'
                    elseif rank_suffix == 13 then rank_suffix = 'K'
                    elseif rank_suffix == 14 then rank_suffix = 'A'
                    end
                    v:set_base(G.P_CARDS[suit_prefix..rank_suffix])
                    v.ability.perma_p_dollars = v.ability.perma_p_dollars or 0
                    v.ability.perma_p_dollars = v.ability.perma_p_dollars + card.ability.money
                    return true
                end
            }))
        end
        for k, v in ipairs(G.hand.highlighted) do
            local percent = 0.85 + (k-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    v:flip();
                    play_sound('tarot2', percent, 0.6);
                    v:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all();
                return true
            end
        }))
        delay(0.5)
    end
}

SMODS.Consumable { --MOAB Hex
    key = 'moab_hex',
    set = 'Power',
    name = 'MOAB Hex',
    atlas = 'Consumable',
    pos = { x = 1, y = 4 },
    config = { max_highlighted = 1 },

    in_pool = function(self, args)
        return G.GAME.selected_back.name == 'Ezili Deck'
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,
    can_use = function(self, card)
        return 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and not G.jokers.highlighted[1].edition
    end,
    use = function(self, card, area)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                G.jokers.highlighted[1]:set_edition('e_polychrome', true)
                if not G.jokers.highlighted[1].ability.perishable then
                    G.jokers.highlighted[1]:set_perishable()
                end
                return true
            end
        }))
    end
}

SMODS.Consumable { --Big Squeeze
    key = 'big_squeeze',
    set = 'Power',
    name = 'Big Squeeze',
    atlas = 'Consumable',
    pos = { x = 2, y = 4 },
    config = { hand_size = 2 },

    in_pool = function(self, args)
        return G.GAME.selected_back.name == 'Pat Fusty Deck'
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.hand_size } }
    end,
    can_use = function(self, card)
        return G.GAME.blind and to_big(G.GAME.blind.chips) > to_big(0)
    end,
    use = function(self, card, area)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        G.hand:change_size(card.ability.hand_size)
        G.GAME.round_resets.temp_handsize = (G.GAME.round_resets.temp_handsize or 0) + card.ability.hand_size
    end
}

SMODS.Consumable { --Blood Sacrifice
    key = 'blood_sacrifice',
    set = 'Power',
    name = 'Blood Sacrifice',
    atlas = 'Consumable',
    pos = { x = 3, y = 4 },
    config = { max_highlighted = 1 },

    in_pool = function(self, args)
        return G.GAME.selected_back.name == 'Adora Deck'
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,
    can_use = function(self, card)
        return 1 <= #G.jokers.highlighted and #G.jokers.highlighted <= card.ability.max_highlighted and not G.jokers.highlighted[1].ability.eternal
    end,
    use = function(self, card, area)
        local sliced_card = G.jokers.highlighted[1]
        sliced_card.getting_sliced = true
        G.GAME.joker_buffer = G.GAME.joker_buffer - 1
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_all_hands'),chips = '...', mult = '...', level=''})
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                G.TAROT_INTERRUPT_PULSE = true
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                return true
            end
        }))
        update_hand_text({delay = 0}, {mult = '+', StatusText = true})
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.9,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                return true
            end
        }))
        update_hand_text({delay = 0}, {chips = '+', StatusText = true})
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.9,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                G.TAROT_INTERRUPT_PULSE = nil
                return true
            end
        }))
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level='+1'})
        delay(1.3)
        for k, v in pairs(G.GAME.hands) do
            level_up_hand(card, k, true)
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end
}

SMODS.Consumable { --Mega Mine
    key = 'mega_mine',
    set = 'Power',
    name = 'Mega Mine',
    atlas = 'Consumable',
    pos = { x = 4, y = 4 },
    config = { Xmult = 2, active = false },

    in_pool = function(self, args)
        return G.GAME.selected_back.name == 'Brickell Deck'
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.Xmult } }
    end,
    can_use = function(self, card)
        return not card.ability.active
    end,
    use = function(self, card, area, copier)
        if not card.ability.active then
			G.GAME.DESTROY_CARD = copy_card(card)
            if not (card.edition and card.edition.negative) then
                G.GAME.DESTROY_CARD:set_edition({negative = true}, true)
                G.GAME.DESTROY_CARD.sell_cost = card.sell_cost
            end
			G.consumeables:emplace(G.GAME.DESTROY_CARD)
			G.GAME.DESTROY_CARD.ability.active = true
            local eval = function()
                return true
            end
            juice_card_until(G.GAME.DESTROY_CARD, eval, true)
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_left == 0 and card.ability.active then
            return {
                x_mult = card.ability.Xmult
            }
        elseif context.after and G.GAME.current_round.hands_left == 0 and card.ability.active then
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

SMODS.Consumable { --UCAV
    key = 'ucav',
    set = 'Power',
    name = 'UCAV',
    atlas = 'Consumable',
    pos = { x = 0, y = 5 },
    config = {  },

    in_pool = function(self, args)
        return G.GAME.selected_back.name == 'Etienne Deck'
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        
    end
}

SMODS.Consumable { --Sword Charge
    key = 'sword_charge',
    set = 'Power',
    name = 'Sword Charge',
    atlas = 'Consumable',
    pos = { x = 0, y = 5 },
    config = {  },

    in_pool = function(self, args)
        return G.GAME.selected_back.name == 'Sauda Deck'
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        
    end
}

SMODS.Consumable { --Psionic Scream
    key = 'psionic_scream',
    set = 'Power',
    name = 'Psionic Scream',
    atlas = 'Consumable',
    pos = { x = 2, y = 5 },
    config = { max_highlighted = 4 },

    in_pool = function(self, args)
        return G.GAME.selected_back.name == 'Psi Deck'
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,
    can_use = function(self, card)
        return G.GAME.blind and to_big(G.GAME.blind.chips) > to_big(0) and 1 <= #G.hand.highlighted and #G.hand.highlighted <= card.ability.max_highlighted
    end,
    use = function(self, card, area)
        local destroyed_cards = {}
        local discarded_cards = {}
        for k, v in ipairs(G.hand.cards) do
            if v.highlighted then
                destroyed_cards[#destroyed_cards+1] = v
            else
                discarded_cards[#discarded_cards+1] = v
            end
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function() 
                for i=#G.hand.highlighted, 1, -1 do
                    local card = G.hand.highlighted[i]
                    if SMODS.shatters(card) then
                        card:shatter()
                    else
                        card:start_dissolve(nil, i == #G.hand.highlighted)
                    end
                end
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                stop_use()
                G.CONTROLLER.interrupt.focus = true
                G.CONTROLLER:save_cardarea_focus('hand')
                for k, v in ipairs(discarded_cards) do
                    v.ability.forced_selection = nil
                end
                if G.CONTROLLER.focused.target and G.CONTROLLER.focused.target.area == G.hand then G.card_area_focus_reset = {area = G.hand, rank = G.CONTROLLER.focused.target.rank} end
                local count = #discarded_cards
                if count > 0 then
                    table.sort(discarded_cards, function(a,b) return a.T.x < b.T.x end)
                    inc_career_stat('c_cards_discarded', count)
                    for j = 1, #G.jokers.cards do
                        G.jokers.cards[j]:calculate_joker({pre_discard = true, full_hand = discarded_cards, hook = false})
                    end
                    local cards = {}
                    local destroyed_cards = {}
                    for i=1, count do
                        discarded_cards[i]:calculate_seal({discard = true})

                        if discarded_cards[i].seal == 'Purple' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                            G.E_MANAGER:add_event(Event({
                                trigger = 'before',
                                delay = 0.0,
                                func = (function()
                                        local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, '8ba')
                                        card:add_to_deck()
                                        G.consumeables:emplace(card)
                                        G.GAME.consumeable_buffer = 0
                                    return true
                                end)}))
                            card_eval_status_text(discarded_cards[i], 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
                        end

                        local removed = false
                        for j = 1, #G.jokers.cards do
                            local eval = nil
                            eval = G.jokers.cards[j]:calculate_joker({discard = true, other_card =  discarded_cards[i], full_hand = discarded_cards,})
                            if eval then
                                if eval.remove then removed = true end
                                card_eval_status_text(G.jokers.cards[j], 'jokers', nil, 1, nil, eval)
                            end
                        end
                        table.insert(cards, discarded_cards[i])
                        if removed then
                            destroyed_cards[#destroyed_cards + 1] = discarded_cards[i]
                            discarded_cards[i]:start_dissolve()
                        else 
                            discarded_cards[i].ability.discarded = true
                            discarded_cards[i]:set_ability(G.P_CENTERS.c_base, nil, true)
                            draw_card(G.hand, G.discard, i*100/count, 'down', false, discarded_cards[i])
                        end
                    end

                    if destroyed_cards[1] then 
                        for j=1, #G.jokers.cards do
                            eval_card(G.jokers.cards[j], {cardarea = G.jokers, remove_playing_cards = true, removed = destroyed_cards})
                        end
                    end

                    G.GAME.round_scores.cards_discarded.amt = G.GAME.round_scores.cards_discarded.amt + #cards
                    check_for_unlock({type = 'discard_custom', cards = cards})
                end
                return true
            end
        }))
    end
}

SMODS.Consumable { --Volcano
    key = 'volcano',
    set = 'Spectral',
    name = 'Volcano',
    atlas = 'Consumable',
    pos = { x = 0, y = 7 },
    cost = 4,
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
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                local card = destroyed_card
                if SMODS.shatters(card) then
                    card:shatter()
                else
                    card:start_dissolve()
                end
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function()
                for k, v in pairs(volcano_cards) do
                    v:set_ability('m_bloons_meteor', nil, true)
                    v:juice_up()
                end
                SMODS.calculate_context({ remove_playing_cards = true, removed = { destroyed_card } })
                return true
            end
        }))
    end
}
