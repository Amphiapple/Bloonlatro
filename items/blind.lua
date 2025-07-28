SMODS.Blind {
    loc_txt = {
        name = 'Bloonarius',
        text = {
            'Fills deck with random',
            'cards until deck size',
            'reaches 100 cards'
        }
    },
    key = 'bloonarius',
    dollars = 8,
    mult = 100, -- 100x base score (5 million)
    boss = { showdown = true },
    boss_colour = HEX("94D708"),
    discovered = true,

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
            '100x blind size',
            'Fills deck with random cards',
            'until deck size reaches 100 cards'
        }
    },
    key = 'phayze',
    dollars = 8,
    mult = 6, -- 6x base score (300k)
    boss = { showdown = true },
    boss_colour = HEX("000000"),
    discovered = true,

    in_pool = function()
        return G.GAME.challenge == 'c_bloons_phayze'
    end,
    press_play = function(self)
        if #G.jokers.cards > 1 then
            local random_index = math.random(2, #G.jokers.cards)
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