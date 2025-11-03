SMODS.Joker { --Druid
    key = 'druid',
    name = 'Druid',
    loc_txt = {
        name = 'Druid',
        text = {
            '{C:mult}+#1#{} Mult if played',
            'hand contains',
            'a {C:attention}Full House{}'
        }
    },
    atlas = 'Joker',
	pos = { x = 0, y = 18 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        base = 'druid',
        extra = { mult = 20 } --Variables: mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands['Full House']) then
            return {
                mult = card.ability.extra.mult,
            }
        end
    end
}

SMODS.Joker { --Heart of Thunder
    key = 'thunder',
    name = 'Heart of Thunder',
    loc_txt = {
        name = 'Heart of Thunder',
        text = {
            '{C:green}#1# in #2#{} chance to',
            'create a {C:attention}Double Tag{}',
            'when skipping a {C:attention}Blind{}'
        }
    },
    atlas = 'Joker',
	pos = { x = 2, y = 18 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'druid',
        extra = { num = 1, denom = 2 } --Variables: num/denom = probability fraction
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'thunder')
        return { vars = { n, d } }
    end,
    calculate = function(self, card, context)
        if context.skip_blind and SMODS.pseudorandom_probability(card, 'thunder', card.ability.extra.num, card.ability.extra.denom, 'thunder') then
            add_tag(Tag('tag_double'))
        end
    end
}

SMODS.Joker { --Druid of the Storm
    key = 'dots',
    name = 'Druid of the Storm',
	loc_txt = {
        name = 'Druid of the Storm',
        text = {
            'Gain {C:blue}+#1#{} hand every',
            '{C:attention}#2#{} hands played',
            '{C:inactive}(#3#)'
        }
    },
	atlas = 'Joker',
	pos = { x = 3, y = 18 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'druid',
        extra = { hands = 1, limit = 4, counter = 4 } --Variables: hands = extra hands, limit = number of hands for hand, counter = hand index
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
				card.ability.extra.hands,
				card.ability.extra.limit,
                process_var(card.ability.extra.counter, card.ability.extra.limit),
			},
		}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.counter = (G.GAME.hands_played - card.ability.hands_played_at_create)%(card.ability.extra.limit) + 1
            if not context.blueprint then
                local eval = function()
                    return card.ability.extra.counter == card.ability.extra.limit - 1
                end
                juice_card_until(card, eval, true)
            end
            if card.ability.extra.counter == card.ability.extra.limit then
                ease_hands_played(card.ability.extra.hands)
            end
        end
    end
}

SMODS.Joker { --Jungle's Bounty
    key = 'jbounty',
    name = "Jungle's Bounty",
	loc_txt = {
        name = "Jungle's Bounty",
        text = {
            'Earn money equal to',
            'the difference of',
            'ranks if played hand',
            'contains a {C:attention}Full House{}'
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 18 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        base = 'druid',
    },

    calculate = function(self, card, context)
        if context.before and next(context.poker_hands['Full House']) then
            local low, high = context.scoring_hand[1].base.nominal, context.scoring_hand[1].base.nominal
            for k, v in ipairs(context.scoring_hand) do
                if v.base.nominal < low then
                    low = v.base.nominal
                    break
                elseif v.base.nominal > high then
                    high = v.base.nominal
                    break
                end
            end
            if high - low > 0 then
                ease_dollars(high - low)
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('$')..(high-low),colour = G.C.MONEY, delay = 0.45})
            end
        end
    end
}

SMODS.Joker { --Avatar of Wrath
    key = 'aow',
    name = 'Avatar of Wrath',
	loc_txt = {
        name = 'Avatar of Wrath',
        text = {
            '{X:mult,C:white}X#1#{} Mult,',
            'loses {X:mult,C:white}X0.02{} Mult for every',
            '{C:attention}1%{} of chips scored this round',
        }
    },
	atlas = 'Joker',
	pos = { x = 15, y = 18 },
    rarity = 3,
	cost = 8,
    blueprint_compat = true,
    config = {
        base = 'druid',
        extra = { Xmult = 3, current = 3 } --Variables: Xmult = starting Xmult, current = current Xmult,
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current, card.ability.extra.loss } }
    end,
    update = function(self, card, dt)
        if G.GAME.blind and to_big(G.GAME.blind.chips) > to_big(0) then
            if G.GAME.chips/G.GAME.blind.chips > to_big(1) then
                card.ability.extra.current = 1
            else
                card.ability.extra.current = card.ability.extra.Xmult - 2 * G.GAME.chips/G.GAME.blind.chips
            end
        else
            card.ability.extra.current = card.ability.extra.Xmult
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.current,
            }
        end
    end
}
