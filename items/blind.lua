SMODS.Atlas {
    key = 'Blind',
    path = 'blind.png',
    px = 34,
    py = 34,
    atlas_table = 'ANIMATION_ATLAS',
    frames = 21,
}

function Blind:bloons_modify_score(score)
    if not self.disabled then
        local obj = self.config and self.config.blind or self
        if obj.bloons_modify_score and type(obj.bloons_modify_score) == "function" then
            return obj:bloons_modify_score(score)
        end
    end
    return score
end

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
    pos = { y = 10 },
    dollars = 8,
    mult = 100, -- 100x base score (5 million)
    boss = { showdown = true },
    boss_colour = HEX("94D708"),
    discovered = true,

    loc_vars = function(self)
        return { vars = { 100 } }
    end,

    collection_loc_vars = function(self)
        return { vars = { 100 } }
    end,

    in_pool = function()
        return G.GAME.challenge == 'c_bloons_bloonarius'
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
    pos = { y = 8 },
    dollars = 8,
    mult = 20, -- 20x base score (1 million)
    boss = { showdown = true },
    boss_colour = HEX("000000"),
    discovered = true,

    in_pool = function()
        return G.GAME.challenge == 'c_bloons_phayze'
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
    pos = { y = 12 },
    dollars = 8,
    mult = 8, -- 8x base score (400k)
    boss = { showdown = true },
    boss_colour = HEX("FFDC3F"),
    discovered = true,

    in_pool = function()
        return G.GAME.challenge == 'c_bloons_dreadbloon'
    end,

    set_blind = function(self)
        self.debuff_rarity = 1
        for _,joker in ipairs(G.jokers.cards) do
            SMODS.recalc_debuff(joker)
        end
    end,

    press_play = function(self)
        self.prepped = true
    end,

    drawn_to_hand = function(self)
        if self.prepped == true then
            self.prepped = false
            self.debuff_rarity = self.debuff_rarity + 1
            for _,joker in ipairs(G.jokers.cards) do
                SMODS.recalc_debuff(joker)
            end
        end
    end,

    recalc_debuff = function(self, card, from_blind)
        if card.area == G.jokers then
            return card.config.center.rarity == self.debuff_rarity
        end
    end,

    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        return math.max(math.floor(mult * 0.5 + 0.5), 1),
               math.max(math.floor(hand_chips * 0.5 + 0.5), 0),
               true
    end,

    bloons_modify_score = function(self, score)
		return math.floor(math.min(0.3 * G.GAME.blind.chips, score) + 0.5)
	end,
}

SMODS.Blind {
    loc_txt = {
        name = 'Vortex',
        text = {
            '-#1# hand'
        }
    },
    key = 'vortex',
    atlas = 'Blind',
    pos = { y = 5 },
    dollars = 8,
    mult = 25, -- 25x base score (500k)
    boss = { showdown = true },
    boss_colour = HEX("63E0FF"),
    discovered = true,

    loc_vars = function(self)
        return { vars = { 1 } }
    end,

    collection_loc_vars = function(self)
        return { vars = { 1 } }
    end,

    in_pool = function()
        return G.GAME.challenge == 'c_bloons_vortex'
    end,

    set_blind = function(self)
        self.hands_removed = 1
        ease_hands_played(-self.hands_removed)
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
    pos = { y = 9 },
    dollars = 8,
    mult = 40, -- 40x base score (2 million)
    boss = { showdown = true },
    boss_colour = HEX("BA58BD"),
    discovered = true,

    in_pool = function()
        return G.GAME.challenge == 'c_bloons_lych'
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
    pos = { y = 24 },
    dollars = 8,
    mult = 60, -- 60x base score (3 million)
    boss = { showdown = true },
    boss_colour = HEX("FF862E"),
    discovered = true,

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
        return G.GAME.challenge == 'c_bloons_blastapopoulos'
    end,

    press_play = function(self)
        self.checked = {}
    end,

    drawn_to_hand = function(self)
        self.heat = 0
        local card_front = pseudorandom_element(G.P_CARDS, pseudoseed('blastapopoulos'))
        local card = SMODS.add_card({
            set = 'Playing Card',
            front = card_front,
            area = G.deck,
            skip_materialize = false,
        })
        card:set_ability(G.P_CENTERS.m_bloons_meteor, nil, true)
    end,

    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        for _, card in ipairs(G.hand.cards) do
            if not self.checked[card] and card.config.center == G.P_CENTERS.m_bloons_frozen then
                self.checked[card] = true
                self.heat = self.heat - 3
                return  mult, hand_chips, true
            end
        end
        return mult, hand_chips, false
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if not self.checked[context.other_card] then
                self.checked[context.other_card] = true
                if context.other_card.ability.name == 'Meteor Card' then
                    self.heat = self.heat + 5
                else
                    self.heat = self.heat + 1
                end
            end
        end
    end,

    bloons_modify_score = function(self, score)
        if self.heat <= 0 then
            return score
        end
        local reduction = 1 - math.min(self.heat * 0.05, 1)
        local reduced_score = math.floor(score * reduction + 0.5)
        return reduced_score
    end,
}