SMODS.Atlas {
    key = 'Blind',
    path = 'blind.png',
    px = 34,
    py = 34,
    atlas_table = 'ANIMATION_ATLAS',
    frames = 21,
}

function Blind:bloons_cap_score(score)
    if not self.disabled then
        local obj = self.config and self.config.blind or self
        if obj.bloons_cap_score and type(obj.bloons_cap_score) == "function" then
            return obj:bloons_cap_score(score)
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
            'Debuffs common jokers',
            'Debuffed rarity is increased',
            'after a hand is scored',
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
    pos = { y = 24 },
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

    bloons_cap_score = function(self, score)
		return math.floor(math.min(0.3 * G.GAME.blind.chips, score) + 0.5)
	end,
}

SMODS.Blind {
    loc_txt = {
        name = 'Vortex',
        text = {
            'Appears in ante #1#',
            '-#2# hand'
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
        return { vars = { 6, 1 } }
    end,

    collection_loc_vars = function(self)
        return { vars = { 6, 1 } }
    end,

    in_pool = function()
        return G.GAME.challenge == 'c_bloons_vortex'
    end,

    set_blind = function(self)
        self.hands_removed = 1
        ease_hands_played(-self.hands_removed)
    end
}