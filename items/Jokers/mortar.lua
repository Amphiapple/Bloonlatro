SMODS.Joker { --Mortar Monkey
    key = 'mortar',
    name = 'Mortar Monkey',
	loc_txt = {
        name = 'Mortar Monkey',
        text = {
            '{C:green}#1# in #2#{} chance for',
            'played cards to give',
            '{C:mult}+#3#{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 12 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'mortar',
        extra = { num = 1, denom = 2, mult = 6 } --Variables: num/denom = probability fraction, mult = +mult
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'mortar')
        return { vars = { n, d, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and SMODS.pseudorandom_probability(card, 'mortar', card.ability.extra.num, card.ability.extra.denom, 'mortar') then
            return {
                mult = card.ability.extra.mult,
            }
		end
    end
}

SMODS.Joker { --Burny Stuff
    key = 'burny',
    name = 'Burny Stuff',
    loc_txt = {
        name = 'Burny Stuff',
        text = {
            '{C:green}#1# in #2#{} chance to',
            'destroy {C:attention}first{}',
            'played card'
        }
    },
    atlas = 'Joker',
	pos = { x = 12, y = 12 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'mortar',
        extra = { num = 1, denom = 4 } --Variables: num/denom = probability fraction 
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'burny')
        return { vars = { n, d } }
    end,
    calculate = function(self, card, context)
        if context.destroy_card and context.destroy_card == context.full_hand[1] and SMODS.pseudorandom_probability(card, 'burny', card.ability.extra.num, card.ability.extra.denom, 'burny') then
            return {remove = true}
        end
    end
}

SMODS.Joker { --Shell Shock
    key = 'sshock',
    name = 'Shell Shock',
    loc_txt = {
        name = 'Shell Shock',
        text = {
            '{C:green}#1# in #2#{} chance to',
            '{C:attention}stun{} each scoring card',
            'and give {C:mult}+#3#{} Mult'
        }
    },
    atlas = 'Joker',
	pos = { x = 3, y = 12 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'mortar',
        extra = { num = 1, denom = 2, mult = 8 } --Variables: num/denom = probability fraction 
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_bloons_stunned
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'sshock')
        return { vars = { n, d, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and SMODS.pseudorandom_probability(card, 'sshock', card.ability.extra.num, card.ability.extra.denom, 'sshock') and not context.other_card.debuff then
            context.other_card:set_ability('m_bloons_stunned', nil, true)
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker { --Artillery Battery
    key = 'abatt',
    name = 'Artillery Battery',
	loc_txt = {
        name = 'Artillery Battery',
        text = {
            '{C:green}#1# in #2#{} chance for',
            'scoring cards to give',
            '{C:chips}+#3#{} Chips, {C:mult}+#4#{} Mult, and',
            '{X:mult,C:white}X#5#{} Mult independently'
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 12 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        base = 'mortar',
        extra = { num = 1, denom = 3, chips = 33, mult = 8, Xmult = 1.3 } --Variables: num/denom = probability fraction, chips = +chips, mult = +mult, Xmult = Xmult

    },
    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'abatt')
        return {
            vars = {
                n,
                d,
                card.ability.extra.chips,
                card.ability.extra.mult,
                card.ability.extra.Xmult
            }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local temp_chips, temp_mult, temp_Xmult = 0, 0, 1
            if SMODS.pseudorandom_probability(card, 'abatt1', card.ability.extra.num, card.ability.extra.denom, 'abatt') then
                temp_chips = card.ability.extra.chips
            end
            if SMODS.pseudorandom_probability(card, 'abatt2', card.ability.extra.num, card.ability.extra.denom, 'abatt') then
                temp_mult = card.ability.extra.mult
            end
            if SMODS.pseudorandom_probability(card, 'abatt3', card.ability.extra.num, card.ability.extra.denom, 'abatt') then
                temp_Xmult = card.ability.extra.Xmult
            end
                return {
                    chips = temp_chips,
                    mult = temp_mult,
                    x_mult = temp_Xmult
                }
		end
    end
}

SMODS.Joker { --Blooncineration
    key = 'cin',
    name = 'Blooncineration',
	loc_txt = {
        name = 'Blooncineration',
        text = {
            'Destroy all scoring',
            'cards with {C:enhanced}Enhancements{},',
            '{C:dark_edition}Editions{} or {C:attention}Seals{}',
            'Gives {X:mult,C:white}X#1#{} Mult for each'
        }
    },
	atlas = 'Joker',
	pos = { x = 15, y = 12 },
    rarity = 3,
	cost = 8,
    blueprint_compat = false,
    config = {
        base = 'mortar',
        extra = { Xmult = 1 } --Variables: Xmult = Xmult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local total = 1
            for k, v in ipairs(context.scoring_hand) do
                if v.config.center ~= G.P_CENTERS.c_base or v.edition or v.seal then
                    total = total + card.ability.extra.Xmult
                end
            end
            if total > 1 then
                return {
                    x_mult = total
                }
            end
        elseif context.destroying_card and
                (context.destroying_card.config.center ~= G.P_CENTERS.c_base or
                context.destroying_card.edition or
                context.destroying_card.seal) and
                not context.blueprint then
            return true
        end
    end
}
