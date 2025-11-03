SMODS.Joker { --Dartling Gunner
    key = 'dartling',
    name = 'Dartling Gunner',
	loc_txt = {
        name = 'Dartling Gunner',
        text = {
            '{C:chips}+???{} Chips'
        }
    },
	atlas = 'Joker',
	pos = { x = 0, y = 13 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        base = 'dartling',
        extra = { max = 150, min = 0 } --Variables: max = max possible +chips, min = min possible +chips
    },

    calculate = function(self, card, context)
        if context.joker_main then
            local temp_chips = pseudorandom('dartling', card.ability.extra.min, card.ability.extra.max)
            return {
                chips = temp_chips
            }
		end
    end
}

SMODS.Joker { --Laser Shock
    key = 'lshock',
    name = 'Laser Shock',
    loc_txt = {
        name = 'Laser Shock',
        text = {
            '{C:mult}+??{} Mult for current and',
            'next hand if scoring hand',
            'contains a {C:attention}face{} card',
            '{C:inactive}Shock damage {C:mult}+#1#{C:inactive} Mult{}'
        }
    },
    atlas = 'Joker',
	pos = { x = 2, y = 13 },
    rarity = 1,
	cost = 6,
    blueprint_compat = true,
    config = {
        base = 'dartling',
        extra = { max = 23, min = 0, mult = 0 } --Variables: max = max possible +mult, min = min possible +mult, mult = shock +mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local has_face = false
            for k, v in ipairs(context.scoring_hand) do
                if v:is_face() then
                    has_face = true
                end
            end
            local temp_mult = card.ability.extra.mult
            if has_face then
                local rand_mult = pseudorandom('lshock', card.ability.extra.min, card.ability.extra.max)
                temp_mult = temp_mult + rand_mult
                card.ability.extra.mult = rand_mult
            else
                card.ability.extra.mult = 0
            end
            if temp_mult > 0 then
                return {
                    mult = temp_mult
                }
            end
		end
    end
}

SMODS.Joker { --Buckshot
    key = 'buckshot',
    name = 'Buckshot',
	loc_txt = {
        name = 'Buckshot',
        text = {
            '{X:mult,C:white}X?.?{} Mult'
        }
    },
	atlas = 'Joker',
	pos = { x = 13, y = 13 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    config = {
        base = 'dartling',
        extra = { max = 33, min = 10 } --Variables: max = max possible Xmult *10, min = min possible Xmult *10
    },

    calculate = function(self, card, context)
        if context.joker_main then
            local temp_Xmult = pseudorandom('buckshot', card.ability.extra.min, card.ability.extra.max) / 10.0
            return {
                x_mult = temp_Xmult
            }
		end
    end
}

SMODS.Joker { --Rocket Storm
    key = 'rorm',
    name = 'Rocket Storm',
	loc_txt = {
        name = 'Rocket Storm',
        text = {
            'This Joker gains {X:mult,C:white}X0.??{}',
            'Mult per {C:attention}consecutive{} hand',
            'played containing a {C:attention}Pair{}',
            '{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult){}'
        }
    },
	atlas = 'Joker',
	pos = { x = 9, y = 13 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        base = 'dartling',
        extra = { max = 15, min = 0, current = 1 } --Variables: max = max possible Xmult gain *100, min = min possible Xmult gain *100, current = current Xmult
    },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current } }
    end,
    calculate = function(self, card, context)
        if context.before and context.poker_hands and not context.blueprint then
            if next(context.poker_hands['Pair']) then
                local temp_Xmult = pseudorandom('rorm', card.ability.extra.min, card.ability.extra.max) / 100.0
                card.ability.extra.current = card.ability.extra.current + temp_Xmult
            else
                if card.ability.extra.current > 1 then
                    card.ability.extra.current = 1
                    return {
                        message = localize('k_reset'),
                        colour = G.C.RED,
                    }
                end
            end
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Ray of Doom
    key = 'rod',
    name = 'Ray of Doom',
	loc_txt = {
        name = 'Ray of Doom',
        text = {
            'Each repeated card rank',
            'in played hand gives',
            '{X:mult,C:white}X?.??{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 13 },
    rarity = 3,
	cost = 10,
    blueprint_compat = true,
    config = {
        base = 'dartling',
        extra = { max = 43, min = 20, ranks = {} } --Variables: max = max possible Xmult *20, min = min possible Xmult *20, ranks = card ranks played
    },
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local new_rank = true
            local id = context.other_card:get_id()
            if id < 0 then
                new_rank = false
            end
            for k, v in pairs(card.ability.extra.ranks) do
                if id == k then
                    local temp_Xmult = pseudorandom('rod', card.ability.extra.min, card.ability.extra.max) / 20.0
                    new_rank = false
                    return {
                        x_mult = temp_Xmult
                    }
                end
            end
            if new_rank and not context.blueprint then
                card.ability.extra.ranks[id] = true
            end
        elseif context.after and not context.blueprint then
            card.ability.extra.ranks = {}
        end
    end
}
