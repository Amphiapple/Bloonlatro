SMODS.Joker { --Dartling Gunner
    key = 'dartling_gunner',
    name = 'Dartling Gunner',
	atlas = 'Joker',
	pos = { x = 0, y = 13 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dartling Gunner", category = "military" },
        extra = { min = 0, max = 150 } --Variables: min = min possible +chips, max = max possible +chips
    },

    loc_txt = {
        name = 'Dartling Gunner',
    },

    loc_vars = function(self, info_queue, card)
        local r_chips = {}
        for i = card.ability.extra.min, card.ability.extra.max do
            r_chips[#r_chips + 1] = tostring(i)
        end

        local main_start = {
            {
                n = G.UIT.C,
                config = { align = 'cm', padding = 0.03 },
                nodes = {
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = '+', colour = G.C.CHIPS, scale = 0.32 } },
                        { n = G.UIT.O, config = { object = DynaText({
                            string = r_chips,
                            colours = { G.C.CHIPS },
                            pop_in_rate = 9999999,
                            silent = true,
                            random_element = true,
                            pop_delay = 0.5,
                            scale = 0.32,
                            min_cycle_time = 0
                        })}},
                        { n = G.UIT.T, config = { text = ' Chips', colour = G.C.UI.TEXT_DARK, scale = 0.32 } }
                    }}
                }
            }
        }

        return { main_start = main_start }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local temp_chips = pseudorandom('dartling_gunner', card.ability.extra.min, card.ability.extra.max)
            return {
                chips = temp_chips
            }
		end
    end
}

SMODS.Joker { --Focused Firing
    key = 'focused_firing',
    name = 'Focused Firing',
	atlas = 'Joker',
	pos = { x = 1, y = 13 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dartling Gunner", category = "military" },
        extra = { min = 0, q1 = 50, q3 = 100, max = 150 } --Variables: min = min possible +chips, q1,q3 = range for central values, max = max possible +chips
    },

    loc_txt = {
        name = 'Focused Firing',
    },

    loc_vars = function(self, info_queue, card)
        local r_chips = {}
        for i = card.ability.extra.min, card.ability.extra.max do
            r_chips[#r_chips + 1] = tostring(i)
            if i >= card.ability.extra.q1 and i <= card.ability.extra.q3 then
                r_chips[#r_chips + 1] = tostring(i)
            end
        end

        local main_start = {
            {
                n = G.UIT.C,
                config = { align = 'cm', padding = 0.03 },
                nodes = {
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = '+', colour = G.C.CHIPS, scale = 0.32 } },
                        { n = G.UIT.O, config = { object = DynaText({
                            string = r_chips,
                            colours = { G.C.CHIPS },
                            pop_in_rate = 9999999,
                            silent = true,
                            random_element = true,
                            pop_delay = 0.5,
                            scale = 0.32,
                            min_cycle_time = 0
                        })}},
                        { n = G.UIT.T, config = { text = ' Chips', colour = G.C.UI.TEXT_DARK, scale = 0.32 } }
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = 'Higher chance of', colour = G.C.UI.TEXT_DARK, scale = 0.32 } }
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = 'central values', colour = G.C.UI.TEXT_DARK, scale = 0.32 } }
                    }}
                }
            }
        }

        return { main_start = main_start }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local r = pseudorandom('focused_firing')
            local temp_chips
            if r < 0.5 then
                temp_chips = pseudorandom('focused_firing', card.ability.extra.q1, card.ability.extra.q3)
            else
                temp_chips = pseudorandom('focused_firing', card.ability.extra.min, card.ability.extra.max)
            end
            return {
                chips = temp_chips
            }
		end
    end
}

SMODS.Joker { --Laser Shock
    key = 'laser_shock',
    name = 'Laser Shock',
    atlas = 'Joker',
	pos = { x = 2, y = 13 },
    rarity = 1,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dartling Gunner", category = "military" },
        extra = { min = 0, max = 23, mult = 0 } --Variables: max = max possible +mult, min = min possible +mult, mult = shock +mult
    },

    loc_txt = {
        name = 'Laser Shock',
    },

    loc_vars = function(self, info_queue, card)
        local r_mult = {}
        for i = card.ability.extra.min, card.ability.extra.max do
            r_mult[#r_mult + 1] = tostring(i)
        end

        local main_start = {
            {
                n = G.UIT.C,
                config = { align = 'cm', padding = 0.03 },
                nodes = {
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = '+', colour = G.C.MULT, scale = 0.32 } },
                        { n = G.UIT.O, config = { object = DynaText({
                            string = r_mult,
                            colours = { G.C.MULT },
                            pop_in_rate = 9999999,
                            silent = true,
                            random_element = true,
                            pop_delay = 0.5,
                            scale = 0.32,
                            min_cycle_time = 0
                        })}},
                        { n = G.UIT.T, config = { text = ' Mult if scoring hand', colour = G.C.UI.TEXT_DARK, scale = 0.32 } }
                    }},
                     { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = 'contains a ', colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = 'face ', colour = G.C.ORANGE, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = 'card', colour = G.C.UI.TEXT_DARK, scale = 0.32 } }
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = 'Store Mult as shock', colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = 'damage for next hand', colour = G.C.UI.TEXT_DARK, scale = 0.32 } }
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = '(Shock damage ', colour = G.C.UI.TEXT_INACTIVE, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = '+', colour = G.C.MULT, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = tostring(card.ability.extra.mult), colour = G.C.MULT, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = ' Mult)', colour = G.C.UI.TEXT_INACTIVE, scale = 0.32 } }
                    }}
                }
            }
        }

        return { main_start = main_start }
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
                local rand_mult = pseudorandom('laser_shock', card.ability.extra.min, card.ability.extra.max)
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

SMODS.Joker { --Laser Cannon
    key = 'laser_cannon',
    name = 'Laser Cannon',
    atlas = 'Joker',
	pos = { x = 3, y = 13 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dartling Gunner", category = "military" },
        extra = { min = 0, max = 11, mult = 0, saved = 0 } --Variables: max = max possible +mult, min = min possible +mult, mult = shock +mult, saved = saved shock +mult
    },

    loc_txt = {
        name = 'Laser Cannon',
    },

    loc_vars = function(self, info_queue, card)
        local r_mult = {}
        for i = card.ability.extra.min, card.ability.extra.max do
            r_mult[#r_mult + 1] = tostring(i)
        end

        local main_start = {
            {
                n = G.UIT.C,
                config = { align = 'cm', padding = 0.03 },
                nodes = {
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = 'Each ', colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = 'face ', colour = G.C.ORANGE, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = 'card gives', colour = G.C.UI.TEXT_DARK, scale = 0.32 } }
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = '+', colour = G.C.MULT, scale = 0.32 } },
                        { n = G.UIT.O, config = { object = DynaText({
                            string = r_mult,
                            colours = { G.C.MULT },
                            pop_in_rate = 9999999,
                            silent = true,
                            random_element = true,
                            pop_delay = 0.5,
                            scale = 0.32,
                            min_cycle_time = 0
                        })}},
                        { n = G.UIT.T, config = { text = ' Mult when scored', colour = G.C.UI.TEXT_DARK, scale = 0.32 } }
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = 'Store Mult as shock', colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = 'damage for next hand', colour = G.C.UI.TEXT_DARK, scale = 0.32 } }
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = '(Shock damage ', colour = G.C.UI.TEXT_INACTIVE, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = '+', colour = G.C.MULT, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = tostring(card.ability.extra.mult), colour = G.C.MULT, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = ' Mult)', colour = G.C.UI.TEXT_INACTIVE, scale = 0.32 } }
                    }}
                }
            }
        }

        return { main_start = main_start }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_face() and not context.other_card.debuff then
            local rand_mult = pseudorandom('laser_cannon', card.ability.extra.min, card.ability.extra.max)
            if not context.blueprint then
                card.ability.extra.saved = card.ability.extra.saved + rand_mult
            end
            return {
                mult = rand_mult
            }
        elseif context.joker_main then
            if card.ability.extra.mult > 0 then
                return {
                    mult = card.ability.extra.mult
                }
            end
		elseif context.after and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.saved
            card.ability.extra.saved = 0
        end
    end
}

SMODS.Joker { --Plasma Accelerator
    key = 'plasma_accelerator',
    name = 'Plasma Accelerator',
	loc_txt = {
        name = 'Plasma Accelerator',
        text = {
            'Each repeated card rank',
            'in played hand gives',
            '{C:mult}+#1#{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 4, y = 13 },
    rarity = 2,
	cost = 8,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dartling Gunner", category = "military" },
        extra = { mult = 12, ranks = {} } --Variables: mult = +mult, ranks = card ranks played
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local new_rank = true
            local id = context.other_card:get_id()
            if id < 0 then
                new_rank = false
            end
            for k, v in pairs(card.ability.extra.ranks) do
                if id == k then
                    return {
                        mult = card.ability.extra.mult
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

SMODS.Joker { --Ray of Doom
    key = 'ray_of_doom',
    name = 'Ray of Doom',
	loc_txt = {
        name = 'Ray of Doom',
        text = {
            'Each repeated card rank',
            'in played hand gives',
            '{X:mult,C:white}X#1#{} Mult when scored'
        }
    },
	atlas = 'Joker',
	pos = { x = 5, y = 13 },
    rarity = 3,
	cost = 10,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dartling Gunner", category = "military" },
        extra = { Xmult = 1.5, ranks = {} } --Variables: Xmult = Xmult, ranks = card ranks played
    },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local new_rank = true
            local id = context.other_card:get_id()
            if id < 0 then
                new_rank = false
            end
            for k, v in pairs(card.ability.extra.ranks) do
                if id == k then
                    return {
                        x_mult = card.ability.extra.Xmult
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

SMODS.Joker { --Advanced Targeting
    key = 'advanced_targeting',
    name = 'Advanced Targeting',
	atlas = 'Joker',
	pos = { x = 6, y = 13 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dartling Gunner", category = "military" },
        extra = { min = 25, max = 125 } --Variables: min = min possible +chips, max = max possible +chips
    },

    loc_txt = {
        name = 'Advanced Targeting',
    },

    loc_vars = function(self, info_queue, card)
        local r_chips = {}
        for i = card.ability.extra.min, card.ability.extra.max do
            r_chips[#r_chips + 1] = tostring(i)
        end

        local main_start = {
            {
                n = G.UIT.C,
                config = { align = 'cm', padding = 0.03 },
                nodes = {
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = '+', colour = G.C.CHIPS, scale = 0.32 } },
                        { n = G.UIT.O, config = { object = DynaText({
                            string = r_chips,
                            colours = { G.C.CHIPS },
                            pop_in_rate = 9999999,
                            silent = true,
                            random_element = true,
                            pop_delay = 0.5,
                            scale = 0.32,
                            min_cycle_time = 0
                        })}},
                        { n = G.UIT.T, config = { text = ' Chips', colour = G.C.UI.TEXT_DARK, scale = 0.32 } }
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = 'Smaller range of values', colour = G.C.UI.TEXT_DARK, scale = 0.32 } }
                    }}
                }
            }
        }

        return { main_start = main_start }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local temp_chips = pseudorandom('advanced_targeting', card.ability.extra.min, card.ability.extra.max)
            return {
                chips = temp_chips
            }
		end
    end
}

SMODS.Joker { --Faster Barrel Spin
    key = 'faster_barrel_spin',
    name = 'Faster Barrel Spin',
	atlas = 'Joker',
	pos = { x = 7, y = 13 },
    rarity = 1,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dartling Gunner", category = "military" },
        extra = { min = 50, max = 150 } --Variables: min = min possible +chips, max = max possible +chips
    },

    loc_txt = {
        name = 'Faster Barrel Spin',
    },

    loc_vars = function(self, info_queue, card)
        local r_chips = {}
        for i = card.ability.extra.min, card.ability.extra.max do
            r_chips[#r_chips + 1] = tostring(i)
        end

        local main_start = {
            {
                n = G.UIT.C,
                config = { align = 'cm', padding = 0.03 },
                nodes = {
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = '+', colour = G.C.CHIPS, scale = 0.32 } },
                        { n = G.UIT.O, config = { object = DynaText({
                            string = r_chips,
                            colours = { G.C.CHIPS },
                            pop_in_rate = 9999999,
                            silent = true,
                            random_element = true,
                            pop_delay = 0.5,
                            scale = 0.32,
                            min_cycle_time = 0
                        })}},
                        { n = G.UIT.T, config = { text = ' Chips', colour = G.C.UI.TEXT_DARK, scale = 0.32 } }
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = 'Higher possible values', colour = G.C.UI.TEXT_DARK, scale = 0.32 } }
                    }}
                }
            }
        }

        return { main_start = main_start }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local temp_chips = pseudorandom('faster_barrel_spin', card.ability.extra.min, card.ability.extra.max)
            return {
                chips = temp_chips
            }
		end
    end
}

SMODS.Joker { --Hydra Rocket Pods
    key = 'hydra_rocket_pods',
    name = 'Hydra Rocket Pods',
	atlas = 'Joker',
	pos = { x = 8, y = 13 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        tower_info = { base = "Dartling Gunner", category = "military" },
        extra = { min = 0, max = 11, current = 0 } --Variables: min = min possible chip gain, max = max possible chips gain, current = current chips
    },

    loc_txt = {
        name = 'Hydra Rocket Pods'
    },

    loc_vars = function(self, info_queue, card)
        local r_chips = {}
        for i = card.ability.extra.min, card.ability.extra.max do
            r_chips[#r_chips + 1] = tostring(i)
        end

        local main_start = {
            {
                n = G.UIT.C,
                config = { align = 'cm', padding = 0.03 },
                nodes = {
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = 'This Joker gains ', colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = '+', colour = G.C.CHIPS, scale = 0.32 } },
                        { n = G.UIT.O, config = { object = DynaText({
                            string = r_chips,
                            colours = { G.C.CHIPS },
                            pop_in_rate = 9999999,
                            silent = true,
                            random_element = true,
                            pop_delay = 0.5,
                            scale = 0.32,
                            min_cycle_time = 0
                        })}},
                        { n = G.UIT.T, config = { text = ' Chips', colour = G.C.UI.TEXT_DARK, scale = 0.32 } }
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = 'per ', colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = 'consecutive ', colour = G.C.ORANGE, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = 'hand', colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = 'played containing a ', colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = 'Pair', colour = G.C.ORANGE, scale = 0.32 } },
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = '(Currently ', colour = G.C.UI.TEXT_INACTIVE, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = '+', colour = G.C.CHIPS, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = tostring(card.ability.extra.current), colour = G.C.CHIPS, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = ' Chips)', colour = G.C.UI.TEXT_INACTIVE, scale = 0.32 } }
                    }}
                }
            }
        }

        return { main_start = main_start }
    end,

    calculate = function(self, card, context)
        if context.before and context.poker_hands and not context.blueprint then
            if next(context.poker_hands['Pair']) then
                local temp_chips = pseudorandom('hydra_rocket_pods', card.ability.extra.min, card.ability.extra.max)
                card.ability.extra.current = card.ability.extra.current + temp_chips
            else
                card.ability.extra.current = 0
                return {
                    message = localize('k_reset'),
                    colour = G.C.RED,
                }
            end
        elseif context.joker_main then
            return {
                chips = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Rocket Storm
    key = 'rocket_storm',
    name = 'Rocket Storm',
	atlas = 'Joker',
	pos = { x = 9, y = 13 },
    rarity = 2,
	cost = 7,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        tower_info = { base = "Dartling Gunner", category = "military" },
        extra = { min = 0, max = 15, current = 1 } --Variables: max = max possible Xmult gain *100, min = min possible Xmult gain *100, current = current Xmult
    },

    loc_txt = {
        name = 'Rocket Storm'
    },

    loc_vars = function(self, info_queue, card)
        local r_xmult = {}
        for i = card.ability.extra.min, card.ability.extra.max do
            r_xmult[#r_xmult+1] = tostring(i/100)
        end

        local main_start = {
            {
                n = G.UIT.C,
                config = { align = 'cm', padding = 0.03 },
                nodes = {
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = 'This Joker gains ', colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
                        {
                            n = G.UIT.C,
                            config = { colour = G.C.RED, r = 0.05, padding = 0.03, res = 0.15 },
                            nodes = {
                                { n = G.UIT.T, config = { text = "X", colour = G.C.WHITE, scale = 0.32 } },
                                { n = G.UIT.O, config = { object = DynaText({
                                    string = r_xmult,
                                    colours = { G.C.WHITE },
                                    pop_in_rate = 9999999,
                                    silent = true,
                                    random_element = true,
                                    pop_delay = 0.5,
                                    scale = 0.32,
                                    min_cycle_time = 0
                                })}
                            }}
                        }
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = 'Mult per ', colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = 'consecutive ', colour = G.C.ORANGE, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = 'hand', colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = 'played containing a ', colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = 'Pair', colour = G.C.ORANGE, scale = 0.32 } },
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = '(Currently ', colour = G.C.UI.TEXT_INACTIVE, scale = 0.32 } },
                        {
                            n = G.UIT.C,
                            config = { colour = G.C.RED, r = 0.05, padding = 0.03, res = 0.15 },
                            nodes = {
                                { n = G.UIT.T, config = { text = "X", colour = G.C.WHITE, scale = 0.32 } },
                                { n = G.UIT.T, config = { text = card.ability.extra.current, colour = G.C.WHITE, scale = 0.32 } },
                            }
                        },
                        { n = G.UIT.T, config = { text = ' Mult)', colour = G.C.UI.TEXT_INACTIVE, scale = 0.32 } },
                    }}
                }
            }
        }

        return { main_start = main_start }
    end,

    calculate = function(self, card, context)
        if context.before and context.poker_hands and not context.blueprint then
            if next(context.poker_hands['Pair']) then
                local temp_Xmult = pseudorandom('rocket_storm', card.ability.extra.min, card.ability.extra.max) / 100.0
                card.ability.extra.current = card.ability.extra.current + temp_Xmult
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.RED,
                    delay = 0.45,
                }
            else
                card.ability.extra.current = 1
                return {
                    message = localize('k_reset'),
                    colour = G.C.RED,
                }
            end
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --M.A.D
    key = 'mad',
    name = 'M.A.D',
	atlas = 'Joker',
	pos = { x = 10, y = 13 },
    rarity = 3,
	cost = 9,
    blueprint_compat = true,
    perishable_compat = false,
    config = {
        tower_info = { base = "Dartling Gunner", category = "military" },
        extra = { min = 25, max = 100, current = 1 } --Variables: min = min possible Xmult gain *100, max = max possible Xmult gain *100, current = current Xmult
    },

    loc_txt = {
        name = 'M.A.D'
    },

    loc_vars = function(self, info_queue, card)
        local r_xmult = {}
        for i = card.ability.extra.min, card.ability.extra.max do
            r_xmult[#r_xmult+1] = tostring(i/100)
        end

        local main_start = {
            {
                n = G.UIT.C,
                config = { align = 'cm', padding = 0.03 },
                nodes = {
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = 'This Joker gains ', colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
                        {
                            n = G.UIT.C,
                            config = { colour = G.C.RED, r = 0.05, padding = 0.03, res = 0.15 },
                            nodes = {
                                { n = G.UIT.T, config = { text = "X", colour = G.C.WHITE, scale = 0.32 } },
                                { n = G.UIT.O, config = { object = DynaText({
                                    string = r_xmult,
                                    colours = { G.C.WHITE },
                                    pop_in_rate = 9999999,
                                    silent = true,
                                    random_element = true,
                                    pop_delay = 0.5,
                                    scale = 0.32,
                                    min_cycle_time = 0
                                })}
                            }}
                        },
                        { n = G.UIT.T, config = { text = ' Mult', colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = 'when ', colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = 'Boss Blind ', colour = G.C.ORANGE, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = 'is selected', colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = '(Currently ', colour = G.C.UI.TEXT_INACTIVE, scale = 0.32 } },
                        {
                            n = G.UIT.C,
                            config = { colour = G.C.RED, r = 0.05, padding = 0.03, res = 0.15 },
                            nodes = {
                                { n = G.UIT.T, config = { text = "X", colour = G.C.WHITE, scale = 0.32 } },
                                { n = G.UIT.T, config = { text = card.ability.extra.current, colour = G.C.WHITE, scale = 0.32 } },
                            }
                        },
                        { n = G.UIT.T, config = { text = ' Mult)', colour = G.C.UI.TEXT_INACTIVE, scale = 0.32 } },
                    }}
                }
            }
        }

        return { main_start = main_start }
    end,

    calculate = function(self, card, context)
        if context.setting_blind and G.GAME.blind.boss and not card.getting_sliced and not context.blueprint then
            local temp_Xmult = pseudorandom('mad', card.ability.extra.min, card.ability.extra.max) / 100.0
            card.ability.extra.current = card.ability.extra.current + temp_Xmult
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.RED,
                delay = 0.45,
            }
        elseif context.joker_main then
            return {
                x_mult = card.ability.extra.current
            }
        end
    end
}

SMODS.Joker { --Faster Swivel
    key = 'faster_swivel',
    name = 'Faster Swivel',
	atlas = 'Joker',
	pos = { x = 11, y = 13 },
    rarity = 1,
	cost = 5,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dartling Gunner", category = "military" },
        extra = { min = 0, q1 = 50, q3 = 100, max = 150 } --Variables: max = max possible +chips, q1-q3 = range for extreme values, min = min possible +chips
    },

    loc_txt = {
        name = 'Faster Swivel',
    },

    loc_vars = function(self, info_queue, card)
        local r_chips = {}
        for i = card.ability.extra.min, card.ability.extra.max do
            r_chips[#r_chips + 1] = tostring(i)
            if i <= card.ability.extra.q1 or i >= card.ability.extra.q3 then
                r_chips[#r_chips + 1] = tostring(i)
            end
        end

        local main_start = {
            {
                n = G.UIT.C,
                config = { align = 'cm', padding = 0.03 },
                nodes = {
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = '+', colour = G.C.CHIPS, scale = 0.32 } },
                        { n = G.UIT.O, config = { object = DynaText({
                            string = r_chips,
                            colours = { G.C.CHIPS },
                            pop_in_rate = 9999999,
                            silent = true,
                            random_element = true,
                            pop_delay = 0.5,
                            scale = 0.32,
                            min_cycle_time = 0
                        })}},
                        { n = G.UIT.T, config = { text = ' Chips', colour = G.C.UI.TEXT_DARK, scale = 0.32 } }
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = 'Higher chance of', colour = G.C.UI.TEXT_DARK, scale = 0.32 } }
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = 'edge values', colour = G.C.UI.TEXT_DARK, scale = 0.32 } }
                    }}
                }
            }
        }

        return { main_start = main_start }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local r = pseudorandom('faster_swivel')
            local temp_chips
            if r < 0.25 then
                temp_chips = pseudorandom('faster_swivel', card.ability.extra.min, card.ability.extra.q1)
            elseif r > 0.75 then
                temp_chips = pseudorandom('faster_swivel', card.ability.extra.min, card.ability.extra.q3)
            else
                temp_chips = pseudorandom('faster_swivel', card.ability.extra.min, card.ability.extra.max)
            end
            return {
                chips = temp_chips
            }
		end
    end
}

SMODS.Joker { --Powerful Darts
    key = 'powerful_darts',
    name = 'Powerful Darts',
	atlas = 'Joker',
	pos = { x = 12, y = 13 },
    rarity = 1,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dartling Gunner", category = "military" },
        extra = { num = 1, denom = 2, min = 150, max = 250 } --Variables: num/denom = probabiltiy fraction, max = max possible +chips, min = min possible +chips
    },

    loc_txt = {
        name = 'Powerful Darts',
    },

    loc_vars = function(self, info_queue, card)
        local r_chips = {}
        for i = card.ability.extra.min, card.ability.extra.max do
            r_chips[#r_chips + 1] = tostring(i)
        end

        local n, d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'powerful_darts')

        local main_start = {
            {
                n = G.UIT.C,
                config = { align = 'cm', padding = 0.03 },
                nodes = {
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = n .. " in " .. d, colour = G.C.GREEN, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = " chance for", colour = G.C.UI.TEXT_DARK, scale = 0.32 } }
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = '+', colour = G.C.CHIPS, scale = 0.32 } },
                        { n = G.UIT.O, config = { object = DynaText({
                            string = r_chips,
                            colours = { G.C.CHIPS },
                            pop_in_rate = 9999999,
                            silent = true,
                            random_element = true,
                            pop_delay = 0.5,
                            scale = 0.32,
                            min_cycle_time = 0
                        })}},
                        { n = G.UIT.T, config = { text = ' Chips', colour = G.C.UI.TEXT_DARK, scale = 0.32 } }
                    }},
                }
            }
        }

        return { main_start = main_start }
    end,

    calculate = function(self, card, context)
        if context.joker_main and SMODS.pseudorandom_probability(card, 'powerful_darts', card.ability.extra.num, card.ability.extra.denom, 'powerful_darts') then
            local temp_chips = pseudorandom('powerful_darts', card.ability.extra.min, card.ability.extra.max)
            return {
                chips = temp_chips
            }
		end
    end
}

SMODS.Joker { --Buckshot
    key = 'buckshot',
    name = 'Buckshot',
	atlas = 'Joker',
	pos = { x = 13, y = 13 },
    rarity = 2,
	cost = 6,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dartling Gunner", category = "military" },
        extra = { max = 30, min = 10 } --Variables: max = max possible Xmult *10, min = min possible Xmult *10
    },

    loc_txt = {
        name = 'Buckshot'
    },

    loc_vars = function(self, info_queue, card)
        local r_xmult = {}
        for i = card.ability.extra.min, card.ability.extra.max do
            r_xmult[#r_xmult+1] = tostring(i/10)
        end

        local main_start = {
            {
                n = G.UIT.C,
                config = { align = 'cm', padding = 0.03 },
                nodes = {
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        {
                            n = G.UIT.C,
                            config = { colour = G.C.RED, r = 0.05, padding = 0.03, res = 0.15 },
                            nodes = {
                                { n = G.UIT.T, config = { text = "X", colour = G.C.WHITE, scale = 0.32 } },
                                { n = G.UIT.O, config = { object = DynaText({
                                    string = r_xmult,
                                    colours = { G.C.WHITE },
                                    pop_in_rate = 9999999,
                                    silent = true,
                                    random_element = true,
                                    pop_delay = 0.5,
                                    scale = 0.32,
                                    min_cycle_time = 0
                                })}
                            }}
                        },
                        { n = G.UIT.T, config = { text = ' Mult', colour = G.C.UI.TEXT_DARK, scale = 0.32 } }
                    }}
                }
            }
        }

        return { main_start = main_start }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local temp_Xmult = pseudorandom('buckshot', card.ability.extra.min, card.ability.extra.max) / 10.0
            return {
                x_mult = temp_Xmult
            }
		end
    end
}

SMODS.Joker { --Bloon Area Denial System
    key = 'bloon_area_denial_system',
    name = 'Bloon Area Denial System',
	atlas = 'Joker',
	pos = { x = 14, y = 13 },
    rarity = 2,
	cost = 8,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dartling Gunner", category = "military" },
        extra = { min = 100, max = 150, cards = {} } --Variables: min = min possible Xmult *100, max = max possible Xmult *100
    },

    loc_txt = {
        name = 'Bloon Area Denial System'
    },

    loc_vars = function(self, info_queue, card)
        local r_xmult = {}
        for i = card.ability.extra.min, card.ability.extra.max do
            r_xmult[#r_xmult+1] = tostring(i/100)
        end

        local main_start = {
            {
                n = G.UIT.C,
                config = { align = 'cm', padding = 0.03 },
                nodes = {
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = 'First', colour = G.C.ORANGE, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = ', ', colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = 'last', colour = G.C.ORANGE, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = ', ', colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = 'lowest', colour = G.C.ORANGE, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = ', and', colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
                        
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = 'highest', colour = G.C.ORANGE, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = ' rank cards give', colour = G.C.UI.TEXT_DARK, scale = 0.32 } }
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        {
                            n = G.UIT.C,
                            config = { colour = G.C.RED, r = 0.05, padding = 0.03, res = 0.15 },
                            nodes = {
                                { n = G.UIT.T, config = { text = "X", colour = G.C.WHITE, scale = 0.32 } },
                                { n = G.UIT.O, config = { object = DynaText({
                                    string = r_xmult,
                                    colours = { G.C.WHITE },
                                    pop_in_rate = 9999999,
                                    silent = true,
                                    random_element = true,
                                    pop_delay = 0.5,
                                    scale = 0.32,
                                    min_cycle_time = 0
                                })}
                            }}
                        },
                        { n = G.UIT.T, config = { text = ' Mult when scored', colour = G.C.UI.TEXT_DARK, scale = 0.32 } }
                    }}
                }
            }
        }

        return { main_start = main_start }
    end,

    calculate = function(self, card, context)
        if context.before then
            local low = 0
            local high = 0
            for k, v in ipairs(context.scoring_hand) do
                if not SMODS.has_no_rank(v) then
                    local id = v:get_id()
                    if k == 1 then
                        card.ability.extra.cards['first'] = v
                        low = id
                        high = id
                    end
                    if k == #context.scoring_hand then
                        card.ability.extra.cards['last'] = v
                    end
                    if id < low then
                        low = id
                        card.ability.extra.cards['low'] = v
                    end
                    if id > high then
                        high = id
                        card.ability.extra.cards['high'] = v
                    end
                end
            end
        elseif context.individual and context.cardarea == G.play and not context.other_card.debuff then
            for k, v in pairs(card.ability.extra.cards) do
                if context.other_card == v then
                    local temp_Xmult = pseudorandom('bloon_area_denial_system', card.ability.extra.min, card.ability.extra.max) / 100
                    return {
                        x_mult = temp_Xmult
                    }
                end
            end
		end
    end
}

SMODS.Joker { --Bloon Exclusion Zone
    key = 'bloon_exclusion_zone',
    name = 'Bloon Exclusion Zone',
	atlas = 'Joker',
	pos = { x = 15, y = 13 },
    rarity = 3,
	cost = 9,
    blueprint_compat = true,
    config = {
        tower_info = { base = "Dartling Gunner", category = "military" },
        extra = { min = 100, max = 150, cards = {} } --Variables: min = min possible Xmult *100, max = max possible Xmult *100
    },

    loc_txt = {
        name = 'Bloon Exclusion Zone'
    },

    loc_vars = function(self, info_queue, card)
        local r_xmult = {}
        for i = card.ability.extra.min, card.ability.extra.max do
            r_xmult[#r_xmult+1] = tostring(i/100)
        end

        local main_start = {
            {
                n = G.UIT.C,
                config = { align = 'cm', padding = 0.03 },
                nodes = {
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = 'First', colour = G.C.ORANGE, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = ', ', colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = 'last', colour = G.C.ORANGE, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = ', and', colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = 'highest', colour = G.C.ORANGE, scale = 0.32 } },
                        { n = G.UIT.T, config = { text = ' rank cards played', colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        { n = G.UIT.T, config = { text = 'or held in hand give', colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
                    }},
                    { n = G.UIT.R, config = { align = 'cm' }, nodes = {
                        {
                            n = G.UIT.C,
                            config = { colour = G.C.RED, r = 0.05, padding = 0.03, res = 0.15 },
                            nodes = {
                                { n = G.UIT.T, config = { text = "X", colour = G.C.WHITE, scale = 0.32 } },
                                { n = G.UIT.O, config = { object = DynaText({
                                    string = r_xmult,
                                    colours = { G.C.WHITE },
                                    pop_in_rate = 9999999,
                                    silent = true,
                                    random_element = true,
                                    pop_delay = 0.5,
                                    scale = 0.32,
                                    min_cycle_time = 0
                                })}
                            }}
                        },
                        { n = G.UIT.T, config = { text = ' Mult when scored', colour = G.C.UI.TEXT_DARK, scale = 0.32 } }
                    }}
                }
            }
        }

        return { main_start = main_start }
    end,

    calculate = function(self, card, context)
        if context.before then
            local high = 0
            for k, v in ipairs(context.scoring_hand) do
                if not SMODS.has_no_rank(v) then
                    local id = v:get_id()
                    if k == 1 then
                        card.ability.extra.cards['first'] = v
                        high = id
                    end
                    if k == #context.scoring_hand then
                        card.ability.extra.cards['last'] = v
                    end
                    if id > high then
                        high = id
                        card.ability.extra.cards['high'] = v
                    end
                end
            end
            high = 0
            for k, v in ipairs(G.hand.cards) do
                if not SMODS.has_no_rank(v) then
                    local id = v:get_id()
                    if k == 1 then
                        card.ability.extra.cards['h_first'] = v
                        high = id
                    end
                    if k == #G.hand.cards then
                        card.ability.extra.cards['h_last'] = v
                    end
                    if id > high then
                        high = id
                        card.ability.extra.cards['h_high'] = v
                    end
                end
            end
        elseif context.individual and (context.cardarea == G.play or context.cardarea == G.hand) and not context.other_card.debuff and not context.end_of_round then
            for k, v in pairs(card.ability.extra.cards) do
                if context.other_card == v then
                    local temp_Xmult = pseudorandom('bloon_exclusion_zone', card.ability.extra.min, card.ability.extra.max) / 100
                    return {
                        x_mult = temp_Xmult
                    }
                end
            end
		end
    end
}
