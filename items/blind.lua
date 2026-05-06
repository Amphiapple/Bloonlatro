SMODS.Atlas {
    key = 'Blind',
    path = 'blinds.png',
    px = 34,
    py = 34,
    atlas_table = 'ANIMATION_ATLAS',
    frames = 21,
}
--[[
SMODS.Blind {
    name = 'The Red',
    loc_txt = {
        name = 'The Red',
        text = {
            '-#1# discard'
        }
    },
    key = 'red',
    atlas = 'Blind',
    pos = { y = 0 },
    dollars = 4,
    mult = 1.5,
    boss_colour = HEX("FF0000"),

    loc_vars = function(self)
        return { vars = { 1 } }
    end,
    collection_loc_vars = function(self)
        return { vars = { 1 } }
    end,
    set_blind = function(self)
        ease_discard(-1)
    end,
}

SMODS.Blind {
    name = 'The Blue',
    loc_txt = {
        name = 'The Blue',
        text = {
            '-#1# hand'
        }
    },
    key = 'blue',
    atlas = 'Blind',
    pos = { y = 1 },
    dollars = 4,
    mult = 1.5,
    boss_colour = HEX("7777FF"),

    loc_vars = function(self)
        return { vars = { 1 } }
    end,
    collection_loc_vars = function(self)
        return { vars = { 1 } }
    end,
    set_blind = function(self)
        ease_hands_played(-1)
    end,
}

SMODS.Blind {
    name = 'The Green',
    loc_txt = {
        name = 'The Green',
        text = {
            'Playing hands and',
            'discarding costs $#1#'
        }
    },
    key = 'green',
    atlas = 'Blind',
    pos = { y = 2 },
    dollars = 4,
    mult = 1.5,
    boss_colour = HEX("77FF77"),

    loc_vars = function(self)
        return { vars = { 1 } }
    end,
    collection_loc_vars = function(self)
        return { vars = { 1 } }
    end,
    press_play = function(self)
        ease_dollars(-1)
    end,
    calculate = function (self, blind, context)
        if context.pre_discard then
            ease_dollars(-1)
        end
    end
}

SMODS.Blind {
    name = 'The Dark',
    loc_txt = {
        name = 'The Dark',
        text = {
            'Base Chips are halved',
            'for Spades or Clubs'
        }
    },
    key = 'black',
    atlas = 'Blind',
    pos = { y = 5 },
    dollars = 4,
    mult = 1.5,
    boss_colour = HEX("333333"),

    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        for k, v in ipairs(cards) do
            if v:is_suit('Spades', true) or v:is_suit('Clubs', true) then
                return mult, math.max(math.floor(hand_chips * 0.5 + 0.5), 0), true
            end
        end
        return mult, hand_chips, false
    end
}

SMODS.Blind {
    name = 'The Light',
    loc_txt = {
        name = 'The Light',
        text = {
            'Base Chips are halved',
            'for Hearts or Diamonds'
        }
    },
    key = 'white',
    atlas = 'Blind',
    pos = { y = 6 },
    dollars = 4,
    mult = 1.5,
    boss_colour = HEX("cccccc"),

    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        for k, v in ipairs(cards) do
            if v:is_suit('Hearts', true) or v:is_suit('Diamonds', true) then
                return mult, math.max(math.floor(hand_chips * 0.5 + 0.5), 0), true
            end
        end
        return mult, hand_chips, false
    end
}

SMODS.Blind {
    name = 'The Magic',
    loc_txt = {
        name = 'The Magic',
        text = {
            'Destroy all consumeables',
        }
    },
    key = 'purple',
    atlas = 'Blind',
    pos = { y = 7 },
    dollars = 4,
    mult = 1.5,
    boss_colour = HEX("9955bb"),

    set_blind = function(self)
        for k, v in ipairs(G.consumeables.cards) do
            v:start_dissolve({G.C.RED}, nil)
            v:remove_from_deck()
        end
    end,
}
]]

SMODS.Blind {
    name = 'Massive MOAB',
    loc_txt = {
        name = 'Massive MOAB',
        text = {
            'Halve Hands and Discards',
        }
    },
    key = 'final_moab',
    atlas = 'Blind',
    pos = { y = 12 },
    dollars = 8,
    mult = 2,
    boss = { showdown = true },
    boss_colour = HEX("2ecaf7"),
    config = { extra = { hands = 0, discards = 0 } },

    set_blind = function(self)
        self.config.extra.hands = math.floor(G.GAME.current_round.hands_left/2)
        self.config.extra.discards = math.floor(G.GAME.current_round.discards_left/2)
        ease_hands_played(-self.config.extra.hands)
        ease_discard(-self.config.extra.discards)
    end,
    disable = function(self)
        ease_hands_played(self.config.extra.hands)
        ease_discard(self.config.extra.discards)
    end
}

SMODS.Blind {
    name = 'Brutal Behemoth',
    loc_txt = {
        name = 'Brutal Behemoth',
        text = {
            'Disable the rightmost',
            'Joker per hand played'
        }
    },
    key = 'final_bfb',
    atlas = 'Blind',
    pos = { y = 13 },
    dollars = 8,
    mult = 2,
    boss = { showdown = true },
    boss_colour = HEX("d10705"),

    calculate = function(self, blind, context)
        if context.final_scoring_step and not blind.disabled then
            local card = nil
            for _,joker in ipairs(G.jokers.cards) do
                if not joker.debuffed_by_blind then
                    card = joker
                end
            end
            if card then
                card:set_debuff(true)
                if card.debuff then
                    card.debuffed_by_blind = true
                end
            end
        end
    end,
    recalc_debuff = function(self, card, from_blind)
        return card.debuff and not self.disabled
    end,
    disable = function(self)
        for _,joker in ipairs(G.jokers.cards) do
            if joker.debuffed_by_blind then
                joker:set_debuff()
            end
        end
    end
}

SMODS.Blind {
    name = 'Dark Titan',
    loc_txt = {
        name = 'Dark Titan',
        text = {
            '#1# in #2# cards',
            'are debuffed'
        }
    },
    key = 'final_ddt',
    atlas = 'Blind',
    pos = { y = 14 },
    dollars = 8,
    mult = 2,
    boss = { showdown = true },
    boss_colour = HEX("4a4b4a"),

    loc_vars = function(self)
        local n, d = SMODS.get_probability_vars(self, 1, 3, 'ddt')
        return { vars = { n, d } }
    end,
    collection_loc_vars = function(self)
        local n, d = SMODS.get_probability_vars(self, 1, 3, 'ddt')
        return { vars = { n, d } }
    end,

    calculate = function(self, blind, context)
        if context.hand_drawn and not blind.disabled then
            for _, card in ipairs(context.hand_drawn) do
                 if SMODS.pseudorandom_probability(G.GAME.blind, 'ddt', 1, 3) then
                    card:set_debuff(true)
                    if card.debuff then
                        card.debuffed_by_blind = true
                    end
                end
            end
        end
    end,
    recalc_debuff = function(self, card, from_blind)
        return card.debuff and not self.disabled
    end,
    disable = function(self)
        for _,card in ipairs(G.hand) do
            if card.debuffed_by_blind then
                card:set_debuff()
            end
        end
    end
}

SMODS.Blind {
    name = 'Green Gargantuan',
    loc_txt = {
        name = 'Green Gargantuan',
        text = {
            'All Jokers debuffed',
            'until 1 Joker sold'
        }
    },
    key = 'final_zomg',
    atlas = 'Blind',
    pos = { y = 15 },
    dollars = 8,
    mult = 2,
    boss = { showdown = true },
    boss_colour = HEX("b8f700"),

    drawn_to_hand = function(self)
        for _,joker in ipairs(G.jokers.cards) do
            joker:set_debuff(true)
            if joker.debuff then
                joker.debuffed_by_blind = true
            end
        end
    end,
    calculate = function (self, blind, context)
        if context.card_added and not blind.disabled then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.05,
                func = function()
                    for _,joker in ipairs(G.jokers.cards) do
                        joker:set_debuff(true)
                        if joker.debuff then
                            joker.debuffed_by_blind = true
                        end
                    end
                    return true
                end
            }))
        end
    end,
    recalc_debuff = function(self, card, from_blind)
        return card.debuff and not self.disabled
    end,
    disable = function(self)
        for _,joker in ipairs(G.jokers.cards) do
            if joker.debuffed_by_blind then
                joker:set_debuff()
            end
        end
    end
}

SMODS.Blind {
    name = 'B.A.D',
    loc_txt = {
        name = 'B.A.D',
        text = {
            'X1.5 blind requirement',
            'after each hand'
        }
    },
    key = 'final_bad',
    atlas = 'Blind',
    pos = { y = 16 },
    dollars = 8,
    mult = 2,
    boss = { showdown = true },
    boss_colour = HEX("aa04aa"),

    set_blind = function(self)
        self.prepped = false
    end,
    press_play = function (self)
        self.prepped = true
    end,
    drawn_to_hand = function(self)
        if self.prepped and not self.disabled then
            G.GAME.blind.chips = math.floor(G.GAME.blind.chips * 1.5)
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            self.prepped = false
        end
    end,
}

SMODS.Blind {
    loc_txt = {
        name = 'Bloonarius',
        text = {
            'Fills deck with random',
            'cards until deck size',
            'reaches #1# cards'
        }
    },
    key = 'bloonarius',
    atlas = 'Blind',
    pos = { y = 17 },
    dollars = 8,
    mult = 100, -- 100x base score (5 million)
    boss = { showdown = true },
    boss_colour = HEX("94D708"),
    bloonlatro_boss = {
        title = 'Bloonarius the Inflator',
        index = 1,
    },

    loc_vars = function(self)
        return { vars = { 100 } }
    end,

    collection_loc_vars = function(self)
        return { vars = { 100 } }
    end,

    in_pool = function()
        return Bloonlatro.boss_id == 'bl_bloons_bloonarius'
    end,
    set_blind = function(self)
        while #G.deck.cards < 100 do
            local card_front = pseudorandom_element(G.P_CARDS, pseudoseed('add_card_' .. tostring(#G.deck.cards)))
            SMODS.add_card({
                set = 'Playing Card',
                front = card_front,
                area = G.deck,
                skip_materialize = false,
                enhanced_poll = 1
            })
        end
    end
}

SMODS.Blind {
    loc_txt = {
        name = 'Lych',
        text = {
            'Revives and resets hands once',
            'Removes enhancements from all',
            'played and held in hand cards',
            'Heals back #2#',
            '#3# enhancement removed'
        }
    },
    key = 'lych',
    atlas = 'Blind',
    pos = { y = 18 },
    dollars = 8,
    mult = 40, -- 40x base score (2 million)
    boss = { showdown = true },
    boss_colour = HEX("BA58BD"),
    bloonlatro_boss = {
        title = 'Gravelord Lych',
        index = 2,
        challenge_params = {
            vouchers = {
                {id = 'v_hone'},
                {id = 'v_glow_up'}
            }
        }
    },

    in_pool = function()
        return Bloonlatro.boss_id == 'bl_bloons_lych'
    end,

    loc_vars = function(self)
        return { vars = { 0, 0.05 * get_blind_amount(G.GAME.round_resets.ante) * 40 * G.GAME.starting_params.ante_scaling .. ' chips for', 'each' } }
    end,

    collection_loc_vars = function(self)
        return { vars = { 0, '5% of total blind size', 'for each' } }
    end,

    set_blind = function(self)
        self.revive = true
    end,

    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        local removal_count = 0
        local played_cards = {}

        for _, card in ipairs(cards) do
            played_cards[card] = true
            if card.config.center ~= G.P_CENTERS.c_base then
                card:set_ability(G.P_CENTERS.c_base, nil, true)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:juice_up()
                        play_sound('cancel', 0.9, 0.6)
                        return true
                    end
                }))
                removal_count = removal_count + 1
            end
        end

        for _, card in ipairs(G.hand.cards) do
            if not played_cards[card] then
                if card.config.center ~= G.P_CENTERS.c_base then
                    card:set_ability(G.P_CENTERS.c_base, nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card:juice_up()
                            play_sound('cancel', 0.9, 0.6)
                            return true
                        end,
                    }))
                    removal_count = removal_count + 1
                end
            end
        end

        local penalty = math.floor(G.GAME.blind.chips / 20 * removal_count)
        if penalty > 0 then
            local new_total = math.max(0, G.GAME.chips - penalty)
            G.E_MANAGER:add_event(Event({
                trigger = 'ease',
                blocking = false,
                ref_table = G.GAME,
                ref_value = 'chips',
                ease_to = new_total,
                delay = 0.5,
                func = function(t) return math.floor(t) end
            }))
            G.GAME.chips = new_total
        end

        return mult, hand_chips, false
    end,

    calculate = function(self, blind, context)
        if context.after and (hand_chips*mult + G.GAME.chips)/G.GAME.blind.chips >= 1 then
            if self.revive then
                self.revive = false
                G.E_MANAGER:add_event(Event({
                    trigger = 'ease',
                    blocking = false,
                    ref_table = G.GAME,
                    ref_value = 'chips',
                    ease_to = 0,
                    delay = 0.5,
                    func = (function(t)
                        return math.floor(t)
                    end)
                }))
                local FINAL_HAND = 1
                ease_hands_played(G.GAME.current_round.hands_played + FINAL_HAND)
            end
        end
    end,
}

SMODS.Blind {
    loc_txt = {
        name = 'Vortex',
        text = {
            'Cards are stunned',
            'when drawn to hand',
            '-#1# hand'
        }
    },
    key = 'vortex',
    atlas = 'Blind',
    pos = { y = 19 },
    dollars = 8,
    mult = 25, -- 25x base score (500k)
    boss = { showdown = true },
    boss_colour = HEX("63E0FF"),
    bloonlatro_boss = {
        title = 'Vortex Master of Air',
        index = 3,
        challenge_params = {
            win_ante = 6
        }
    },

    loc_vars = function(self)
        return { vars = { 1 } }
    end,

    collection_loc_vars = function(self)
        return { vars = { 1 } }
    end,

    in_pool = function()
        return Bloonlatro.boss_id == 'bl_bloons_vortex'
    end,

    set_blind = function(self)
        ease_hands_played(-1)
    end,

    drawn_to_hand = function(self)
        for _, card in ipairs(G.hand.cards) do
            if card.config.center ~= G.P_CENTERS.m_bloons_stunned then
                card:juice_up()
                card:set_ability(G.P_CENTERS.m_bloons_stunned, nil, true)
            end
        end
    end
}

SMODS.Blind {
    loc_txt = {
        name = 'Dreadbloon',
        text = {
            'Score is capped at #1#',
            'Halves base chips and mult',
            'Debuffs Jokers by rarity',
            'Debuffed rarity increases',
            'after each hand played'
        }
    },

    loc_vars = function(self)
        return { vars = { 0.3 * get_blind_amount(G.GAME.round_resets.ante) * 8 * G.GAME.starting_params.ante_scaling } }
    end,

    collection_loc_vars = function(self)
        return { vars = { '30% of blind size' } }
    end,

    key = 'dreadbloon',
    atlas = 'Blind',
    pos = { y = 20 },
    dollars = 8,
    mult = 8, -- 8x base score (400k)
    boss = { showdown = true },
    boss_colour = HEX("FFDC3F"),
    bloonlatro_boss = {
        title = 'Dreadbloon the Armored Behemoth',
        index = 4,
        challenge_params = {
            banned_ids = {
                {id = 'j_bloons_downdraft'},
                {id = 'j_bloons_support_chinook'},
                {id = 'j_bloons_moab_shove'},
                {id = 'j_bloons_counter_espionage'},
                {id = 'j_bloons_long_reach'},
                {id = 'j_bloons_perma_spike'},
                {id = 'j_burglar'},
                {id = 'j_troubadour'},
                {id = 'v_grabber'},
                {id = 'v_nacho_tong'},
                {id = 'v_hieroglyph'},
                {id = 'c_bloons_time_stop'},
            }
        }
    },

    in_pool = function()
        return Bloonlatro.boss_id == 'bl_bloons_dreadbloon'
    end,

    set_blind = function(self)
		SMODS.set_scoring_calculation("bloons_dreadbloon")
	end,
	defeat = function(self)
		SMODS.set_scoring_calculation("multiply")
	end,
	disable = function(self)
		SMODS.set_scoring_calculation("multiply")
	end,

    drawn_to_hand = function(self)
        for _,joker in ipairs(G.jokers.cards) do
            SMODS.recalc_debuff(joker)
        end
    end,

    recalc_debuff = function(self, card, from_blind)
        if card.area == G.jokers then
            return card.config.center.rarity == G.GAME.current_round.hands_played + 1
        end
    end,

    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        return math.max(math.floor(mult * 0.5 + 0.5), 1),
               math.max(math.floor(hand_chips * 0.5 + 0.5), 0),
               true
    end,
}

SMODS.Blind {
    loc_txt = {
        name = 'Phayze',
        text = {
            'Moves a random Joker to the leftmost',
            'position when a hand is played',
            'Debuffs all Jokers and cards',
            'without an edition.'
        }
    },
    key = 'phayze',
    atlas = 'Blind',
    pos = { y = 21 },
    dollars = 8,
    mult = 20, -- 20x base score (1 million)
    boss = { showdown = true },
    boss_colour = HEX("000000"),
    bloonlatro_boss = {
        title = 'The Reality Warper Phayze',
        index = 5,
    },

    in_pool = function()
        return Bloonlatro.boss_id == 'bl_bloons_phayze'
    end,
    press_play = function(self)
        if #G.jokers.cards > 1 then
            local random_index = pseudorandom(2, #G.jokers.cards, pseudoseed('phayze'))
            local selected = G.jokers.cards[random_index]
            for i = random_index, 2, -1 do
                G.jokers.cards[i] = G.jokers.cards[i-1]
            end
            G.jokers.cards[1] = selected
        end
        for _, joker in ipairs(G.jokers.cards) do
            SMODS.recalc_debuff(joker)
        end
    end,

    recalc_debuff = function(self, card, from_blind)
        return not card.edition
    end
}

SMODS.Blind {
    loc_txt = {
        name = 'Blastapopoulos',
        text = {
            'Card draw adds a Meteor card to deck',
            'Score is reduced by #1#% per heat point',
            'Played scoring cards increase heat by #2#',
            'Scoring Meteor cards increase heat by #3#',
            'Held Frozen cards decrease heat by #4#'
        }
    },
    key = 'blastapopoulos',
    atlas = 'Blind',
    pos = { y = 22 },
    dollars = 8,
    mult = 60, -- 60x base score (3 million)
    boss = { showdown = true },
    boss_colour = HEX("FF862E"),
    bloonlatro_boss = {
        title = 'Blastapopoulos Demon of the Core',
        index = 6,
    },
    loc_vars = function(self)
        return {
            vars = { 10, 1, 3, 3 }
        }
    end,

    collection_loc_vars = function(self)
        return {
            vars = { 10, 1, 3, 3 }
        }
    end,

    in_pool = function()
        return Bloonlatro.boss_id == 'bl_bloons_blastapopoulos'
    end,

    set_blind = function(self)
		SMODS.set_scoring_calculation("bloons_blastapopoulos")
	end,
	defeat = function(self)
		SMODS.set_scoring_calculation("multiply")
	end,
	disable = function(self)
		SMODS.set_scoring_calculation("multiply")
	end,

    drawn_to_hand = function(self)
        local card_front = pseudorandom_element(G.P_CARDS, pseudoseed('blastapopoulos'))
        local card = SMODS.add_card({
            set = 'Playing Card',
            front = card_front,
            area = G.deck,
            skip_materialize = false,
        })
        card:set_ability(G.P_CENTERS.m_bloons_meteor, nil, true)

        G.E_MANAGER:add_event(Event({
            func = function() 
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                return true
            end
        }))
        draw_card(G.play,G.deck, 90,'up', nil)
    end,
}

SMODS.Blind {
    loc_txt = {
        name = 'Diamondback Head',
        text = {
            '1'
        }
    },
    key = 'diamondback_head',
    atlas = 'Blind',
    pos = { y = 1 },
    dollars = 8,
    mult = 60, -- 60x base score (3 million)
    boss = { showdown = true },
    boss_colour = G.C.WHITE,
    bloonlatro_boss = {
        title = 'Diamondback the Village Devourer',
        index = 7,
        parts = {
            main = "diamondback",
            segment = "head",
            order = 1
        }
    },

    in_pool = function()
        return Bloonlatro.boss_id == 'bl_bloons_diamondback'
    end
}

SMODS.Blind {
    loc_txt = {
        name = 'Diamondback Body',
        text = {
            '2'
        }
    },
    key = 'diamondback_body',
    atlas = 'Blind',
    pos = { y = 2 },
    dollars = 8,
    mult = 60, -- 60x base score (3 million)
    boss = { showdown = true },
    boss_colour = G.C.WHITE,
    bloonlatro_boss = {
        index = 7,
        parts = {
            main = "diamondback",
            segment = "body",
            order = 2
        }
    },

    in_pool = function()
        return Bloonlatro.boss_id == 'bl_bloons_diamondback'
    end
}

SMODS.Blind {
    loc_txt = {
        name = 'Diamondback Tail',
        text = {
            '3'
        }
    },
    key = 'diamondback_tail',
    atlas = 'Blind',
    pos = { y = 3 },
    dollars = 8,
    mult = 60, -- 60x base score (3 million)
    boss = { showdown = true },
    boss_colour = G.C.WHITE,
    bloonlatro_boss = {
        index = 7,
        parts = {
            main = "diamondback",
            segment = "tail",
            order = 3
        }
    },

    in_pool = function()
        return Bloonlatro.boss_id == 'bl_bloons_diamondback'
    end
}