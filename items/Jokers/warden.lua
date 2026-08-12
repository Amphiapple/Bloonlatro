SMODS.Joker { --Skywarden
    key = 'skywarden',
    name = 'Skywarden',
    atlas = 'Joker',
	pos = { x = 0, y = 20 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Skywarden", category = "magic" },
        extra = { starting_mult = 4, mult_gain = 2, current = 4 } --Variables: starting_mult = +mult at the start of round, mult_gain = +mult after each hand, current = current mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current, card.ability.extra.mult_gain } }
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.current
            }
        elseif context.after and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "current",
                scalar_value = "mult_gain",
            })
            return nil, true
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = card.ability.extra.starting_mult
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker { --Storm's Pulse
    key = 'storms_pulse',
    name = "Storm's Pulse",
    atlas = 'Joker',
	pos = { x = 6, y = 20 },
    rarity = 1,
	cost = 3,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Skywarden", category = "magic" },
        extra = { starting_mult = 4, mult_gain = 4, current = 4 } --Variables: starting_mult = +mult at the start of round, mult_gain = +mult after each hand, current = current mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current, card.ability.extra.mult_gain } }
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.current
            }
        elseif context.after and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "current",
                scalar_value = "mult_gain",
            })
            return nil, true
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = card.ability.extra.starting_mult
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker { --Thundering Arc
    key = 'thundering_arc',
    name = "Thundering Arc",
    atlas = 'Joker',
	pos = { x = 7, y = 20 },
    rarity = 1,
	cost = 4,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Skywarden", category = "magic" },
        extra = { starting_mult = 4, mult_gain = 2, current = 4 } --Variables: starting_mult = +mult at the start of round, mult_gain = +mult after each card, current = current mult
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current, card.ability.extra.mult_gain } }
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.current
            }
        elseif context.after and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "current",
                scalar_value = "mult_gain",
                operation = function(ref_table, ref_value, initial, scaling)
                    ref_table[ref_value] = initial + scaling*#context.scoring_hand
                end
            })
            return nil, true
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = card.ability.extra.starting_mult
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Joker { --Galvanic Conduit
    key = 'galvanic_conduit',
    name = "Galvanic Conduit",
    atlas = 'Joker',
	pos = { x = 7, y = 20 },
    rarity = 2,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Skywarden", category = "magic" },
        extra = { mult = 1, current = 0 } --Variables: mult_gain = +mult after each card, current = current mult
    },

    calculate = function (self, card, context)
        if context.individual then
            if context.cardarea == G.play then
                if not context.blueprint then
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "current",
                        scalar_value = "mult",
                        no_message = true
                    })
                end
                return {
                    mult = card.ability.extra.current
                }
            end
        elseif context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card.ability.extra.current = 0
        end
    end
}
