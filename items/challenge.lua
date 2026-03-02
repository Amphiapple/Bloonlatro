Challenge_stakes = {
    c_bloons_gorgon_storm = {stake = 8},
    c_bloons_joshs_constant = {stake = 8},
    c_bloons_inflated_expert = {stake = 8},
    c_bloons_survivor_expert = {stake = 8},
    c_bloons__2tc_expert = {stake = 8},
    c_bloons__2mp_expert = {stake = 8},
}

local banned_hand_cards = {
    {id = 'j_bloons_downdraft'},
    {id = 'j_bloons_counter_espionage'},
    {id = 'j_bloons_druid_of_the_storm'},
    {id = 'j_bloons_long_reach'},
    {id = 'j_bloons_perma_spike'},
    {id = 'j_burglar'},
    {id = 'v_grabber'},
    {id = 'v_nacho_tong'},
    {id = 'c_bloons_time_stop'}
}

local monkeyopolis_tags = {
    {id = 'tag_rare'},
    {id = 'tag_uncommon'},
    {id = 'tag_holo'},
    {id = 'tag_polychrome'},
    {id = 'tag_negative'},
    {id = 'tag_foil'},
    {id = 'tag_buffoon'},
    {id = 'tag_top_up'},
    {id = 'tag_bloons_cleansing'},
    {id = 'tag_investment'},
    {id = 'tag_handy'},
    {id = 'tag_garbage'},
    {id = 'tag_skip'},
    {id = 'tag_economy'}
}

local crash_of_the_titans_cards = {
    {id = 'c_hanged_man'},
    {id = 'c_incantation'},
    {id = 'c_grim'},
    {id = 'c_familiar'},
    {id = 'c_immolate'},
    {id = 'c_bloons_volcano'},
    {id = 'c_bloons_cave_monkey'},
    {id = 'p_standard_normal_1',
        ids = {'p_standard_normal_1','p_standard_normal_2','p_standard_normal_3','p_standard_normal_4','p_standard_jumbo_1','p_standard_jumbo_2','p_standard_mega_1','p_standard_mega_2'},
    },
    {id = 'j_marble'},
    {id = 'j_certificate'},
    {id = 'j_trading'},
    {id = 'j_erosion'},
    {id = 'j_dna'},
    {id = 'j_bloons_bomb_blitz'},
    {id = 'j_bloons_ring_of_fire'},
    {id = 'j_bloons_inferno_ring'},
    {id = 'j_bloons_super_brittle'},
    {id = 'j_bloons_exploding_pineapple'},
    {id = 'j_bloons_bomber_ace'},
    {id = 'j_bloons_burny_stuff'},
    {id = 'j_bloons_necromancer'},
    {id = 'j_bloons_wizard_lord_phoenix'},
    {id = 'j_bloons_total_transformation'},
    {id = 'j_bloons_spiked_mines'},
    {id = 'j_bloons_cleansing_foam'},
    {id = 'j_bloons_bloon_trap'},
    {id = 'j_bloons_xxxl_trap'},
    {id = 'j_bloons_megalodon'},
    {id = 'j_bloons_glaive_dominus'},
    {id = 'v_magic_trick'},
    {id = 'v_illusion'},
    {id = 'v_hieroglyph'},
    {id = 'v_petroglyph'}
}

for _, joker in ipairs(banned_hand_cards) do
    table.insert(crash_of_the_titans_cards, joker)
end

local joshs_constant_cards = {
    { id = 'j_bloons_total_transformation'},
    { id = 'j_bloons_cleansing_foam'},
}

for _, joker in ipairs(banned_hand_cards) do
    table.insert(joshs_constant_cards, joker)
end

local inflated_cards = {
    {id = 'j_juggler'},
    {id = 'j_troubadour'},
    {id = 'j_turtle_bean'},
    {id = 'j_bloons_arctic_wind'},
    {id = 'j_bloons_snowstorm'},
    {id = 'j_bloons_giant_condor'},
    {id = 'v_paint_brush'},
    {id = 'v_palette'},
}

for _, joker in ipairs(banned_hand_cards) do
    table.insert(inflated_cards, joker)
end

local survivor_cards = {
    {id = 'j_chaos'},
    {id = 'j_bloons_longer_range'},
    {id = 'j_bloons_advanced_intel'},
    {id = 'j_bloons_submerge_and_support'},
    {id = 'j_bloons_energizer'},
    {id = 'j_bloons_super_range'},
    {id = 'j_bloons_epic_range'},
    {id = 'v_overstock_norm'},
    {id = 'v_overstock_plus'},
    {id = 'v_reroll_surplus'},
    {id = 'v_reroll_glut'},
}

local banned_2tc_cards = {
    {id = 'c_ectoplasm'},
    {id = 'c_bloons_pontoon'},
    {id = 'j_bloons_carrier_flagship'},
    {id = 'j_bloons_ninja_monkey'},
    {id = 'j_bloons_ninja_discipline'},
    {id = 'j_bloons_sharp_shurikens'},
    {id = 'j_bloons_distraction'},
    {id = 'j_bloons_counter_espionage'},
    {id = 'j_bloons_seeking_shuriken'},
    {id = 'j_bloons_caltrops'},
    {id = 'v_antimatter'},
}

local boss_jokers = {
    {id = 'j_luchador'},
    {id = 'j_chicot'},
    {id = 'j_mr_bones'},
    {id = 'j_bloons_bomb_blitz'},
    {id = 'j_bloons_cripple_moab'},
}

local boss_bans = {
    banned_cards = boss_jokers,
}

local dreadbloon_cards = {
    { id = 'v_hieroglyph' },
    { id = 'j_troubadour' },
}
for _, joker in ipairs(boss_jokers) do
    table.insert(dreadbloon_cards, joker)
end
for _, card in ipairs(banned_hand_cards) do
    table.insert(dreadbloon_cards, card)
end

SMODS.Challenge {
    key = 'glorious_gold',
    loc_txt = {
        name = 'Glorious Gold',
    },
    rules = {
        custom = {
            { id = 'discard_cost', value = 3 },
        },
        modifiers = {
            { id = 'discards', value = 1 },
        }
    },
    restrictions = {
        banned_cards = {
            { id = 'j_bloons_total_transformation'},
            { id = 'j_bloons_cleansing_foam'},
        },
        banned_tags = {
            { id = 'tag_bloons_cleansing' },
        },
    },
    jokers = {
        { id = 'j_bloons_rubber_to_gold', eternal = true }
    },
    vouchers = {},
    deck = {
        type = 'Challenge Deck',
    },
}

SMODS.Challenge {
    key = 'monkeyopolis',
    loc_txt = {
        name = 'Monkeyopolis',
    },
    rules = {
        custom = {
            { id = 'no_shop_jokers' },
            { id = 'no_reward' },
            { id = 'no_extra_hand_money' },
            { id = 'no_interest' },
        },
        modifiers = {
            { id = 'joker_slots', value = 10 },
        }
    },
    restrictions = {
        banned_cards = {
            {id = 'c_judgement'},
            {id = 'c_hermit'},
            {id = 'c_temperance'},
            {id = 'c_wraith'},
            {id = 'c_soul'},
            {id = 'c_bloons_cash_drop'},
            {id = 'c_bloons_banana_farmer'},
            {id = 'v_antimatter'},
            {id = 'v_bloons_grand_prix_spree'},
            {id = 'p_buffoon_normal_1',
                ids = {'p_buffoon_normal_1','p_buffoon_normal_2', 'p_buffoon_jumbo_1','p_buffoon_mega_1'},
            },
        },
        banned_tags = monkeyopolis_tags,
    },
    jokers = {
        { id = 'j_bloons_monkey_city', eternal = true }
    }
}

SMODS.Challenge {
    key = 'gorgon_storm',
    loc_txt = {
        name = 'Gorgon Storm'
    },
    rules = {
        custom = {
            { id = 'gold_stake' },
            { id = 'gorgon_storm' },
        }
    },
    jokers = {
        { id = 'j_bloons_rocket_storm', eternal = true }
    },
    vouchers = {},
    restrictions = {
        banned_cards = {
            { id = 'j_bloons_total_transformation'},
            { id = 'j_bloons_cleansing_foam'},
        },
        banned_tags = {
            { id = 'tag_bloons_cleansing' },
        },
    },
    deck = {
        type = 'Challenge Deck'
    },

    calculate = function(self, context)
        if context.initial_scoring_step and context.poker_hands and not next(context.poker_hands['Pair']) then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                func = function()
                    G.STATE = G.STATES.GAME_OVER
                    G.STATE_COMPLETE = false
                    return true
                end
            }))
        end
    end,
}

SMODS.Challenge {
    key = 'no_harvest',
    loc_txt = {
        name = 'No Harvest'
    },
    rules = {
        custom = {
            { id = 'no_shop_slots' }
        }
    },
    jokers = {
        { id = 'j_bloons_advanced_intel' },
    },
    vouchers = {},
    restrictions = {
        banned_cards = {
            { id = 'v_overstock_norm' },
            { id = 'v_overstock_plus' }
        }
    },
    deck = {
        type = 'Challenge Deck',
    },

    apply = function(self)
        change_shop_size(-2)
    end
}

SMODS.Challenge {
    key = 'crash_of_the_titans',
    loc_txt = {
        name = 'Crash of the Titans',
    },
    rules = {
        custom = {
            { id = 'crash_of_the_titans' },
            { id = 'double_blind_size' },
            { id = 'no_skipping_blinds' }
        },
        modifiers = {
            { id = 'hands', value = 1 },
            { id = 'discards', value = 6 },
        }
    },
    jokers = {
        { id = 'j_bloons_blooncineration', eternal = true }
    },
    vouchers = {},
    restrictions = {
            banned_cards = crash_of_the_titans_cards,
            banned_tags = {
                { id = 'tag_standard' },
                { id = 'tag_bloons_cleansing' },
            },
            banned_other = {
                { id = 'bl_water', type = 'blind' },
                { id = 'bl_needle', type = 'blind' },
            }
        },
    deck = {
        type = 'Challenge Deck',
        cards = {
            {s='D',r='2',g='Red',},{s='D',r='3',g='Red',},{s='D',r='4',g='Red',},{s='D',r='5',g='Red',},{s='D',r='6',g='Red',},{s='D',r='7',g='Red',},{s='D',r='8',g='Red',},{s='D',r='9',g='Red',},{s='D',r='T',g='Red',},{s='D',r='J',g='Red',},{s='D',r='Q',g='Red',},{s='D',r='K',g='Red',},{s='D',r='A',g='Red',},{s='C',r='2',g='Red',},{s='C',r='3',g='Red',},{s='C',r='4',g='Red',},{s='C',r='5',g='Red',},{s='C',r='6',g='Red',},{s='C',r='7',g='Red',},{s='C',r='8',g='Red',},{s='C',r='9',g='Red',},{s='C',r='T',g='Red',},{s='C',r='J',g='Red',},{s='C',r='Q',g='Red',},{s='C',r='K',g='Red',},{s='C',r='A',g='Red',},{s='H',r='2',g='Red',},{s='H',r='3',g='Red',},{s='H',r='4',g='Red',},{s='H',r='5',g='Red',},{s='H',r='6',g='Red',},{s='H',r='7',g='Red',},{s='H',r='8',g='Red',},{s='H',r='9',g='Red',},{s='H',r='T',g='Red',},{s='H',r='J',g='Red',},{s='H',r='Q',g='Red',},{s='H',r='K',g='Red',},{s='H',r='A',g='Red',},{s='S',r='2',g='Red',},{s='S',r='3',g='Red',},{s='S',r='4',g='Red',},{s='S',r='5',g='Red',},{s='S',r='6',g='Red',},{s='S',r='7',g='Red',},{s='S',r='8',g='Red',},{s='S',r='9',g='Red',},{s='S',r='T',g='Red',},{s='S',r='J',g='Red',},{s='S',r='Q',g='Red',},{s='S',r='K',g='Red',},{s='S',r='A',g='Red',},
            {s='D',r='2',g='Red',},{s='D',r='3',g='Red',},{s='D',r='4',g='Red',},{s='D',r='5',g='Red',},{s='D',r='6',g='Red',},{s='D',r='7',g='Red',},{s='D',r='8',g='Red',},{s='D',r='9',g='Red',},{s='D',r='T',g='Red',},{s='D',r='J',g='Red',},{s='D',r='Q',g='Red',},{s='D',r='K',g='Red',},{s='D',r='A',g='Red',},{s='C',r='2',g='Red',},{s='C',r='3',g='Red',},{s='C',r='4',g='Red',},{s='C',r='5',g='Red',},{s='C',r='6',g='Red',},{s='C',r='7',g='Red',},{s='C',r='8',g='Red',},{s='C',r='9',g='Red',},{s='C',r='T',g='Red',},{s='C',r='J',g='Red',},{s='C',r='Q',g='Red',},{s='C',r='K',g='Red',},{s='C',r='A',g='Red',},{s='H',r='2',g='Red',},{s='H',r='3',g='Red',},{s='H',r='4',g='Red',},{s='H',r='5',g='Red',},{s='H',r='6',g='Red',},{s='H',r='7',g='Red',},{s='H',r='8',g='Red',},{s='H',r='9',g='Red',},{s='H',r='T',g='Red',},{s='H',r='J',g='Red',},{s='H',r='Q',g='Red',},{s='H',r='K',g='Red',},{s='H',r='A',g='Red',},{s='S',r='2',g='Red',},{s='S',r='3',g='Red',},{s='S',r='4',g='Red',},{s='S',r='5',g='Red',},{s='S',r='6',g='Red',},{s='S',r='7',g='Red',},{s='S',r='8',g='Red',},{s='S',r='9',g='Red',},{s='S',r='T',g='Red',},{s='S',r='J',g='Red',},{s='S',r='Q',g='Red',},{s='S',r='K',g='Red',},{s='S',r='A',g='Red',},
            {s='S',r='A',g='Red',e='m_stone'},{s='S',r='A',g='Red',e='m_stone'},{s='S',r='A',g='Red',e='m_stone'},{s='S',r='A',g='Red',e='m_stone'},{s='H',r='A',g='Red',e='m_stone'},{s='H',r='A',g='Red',e='m_stone'},{s='H',r='A',g='Red',e='m_stone'},{s='H',r='A',g='Red',e='m_stone'},{s='C',r='A',g='Red',e='m_stone'},{s='C',r='A',g='Red',e='m_stone'},{s='C',r='A',g='Red',e='m_stone'},{s='C',r='A',g='Red',e='m_stone'},{s='D',r='A',g='Red',e='m_stone'},{s='D',r='A',g='Red',e='m_stone'},{s='D',r='A',g='Red',e='m_stone'},{s='D',r='A',g='Red',e='m_stone'}
        }
    },
}

SMODS.Challenge {
    key = 'joshs_constant',
    loc_txt = {
        name = "Josh's Constant"
    },
    rules = {
        modifiers = {
            { id = 'hands', value = 2 }
        },
        custom = {
            { id = 'gold_stake' }
        }
    },
    jokers = {
        { id = 'j_bloons_perma_spike', eternal = true }
    },
    vouchers = {},
    restrictions = {
        banned_cards = joshs_constant_cards,
        banned_tags = {
            { id = 'tag_bloons_cleansing' },
        },
    },
    deck = {
        type = 'Challenge Deck',
    },
}

SMODS.Challenge {
    key = 'inflated',
    loc_txt = {
        name = 'Inflated'
    },
    rules = {
        custom = {
            { id = 'inflated' },
        },
        modifiers = {
            { id = 'hand_size', value = 13 },
            { id = 'hands', value = 3 },
            { id = 'discards', value = 0 },
            { id = 'dollars', value = 13 },
        }
    },
    jokers = {},
    vouchers = {},
    restrictions = {
        banned_cards = inflated_cards,
        banned_tags = {
            { id = 'tag_juggle' },
        },
        banned_other = {
            { id = 'bl_water', type = 'blind' },
            { id = 'bl_needle', type = 'blind' },
            { id = 'bl_serpent', type = 'blind' },
            { id = 'bl_bloons_final_moab', type = 'blind' },
        }
    },
    deck = {
        type = 'Challenge Deck',
    },
}

SMODS.Challenge {
    key = 'survivor',
    loc_txt = {
        name = 'Survivor'
    },
    rules = {
        custom = {
            { id = 'no_shop_rerolls' },
            { id = 'no_shop_slots' },
        },
    },
    jokers = {},
    vouchers = {},
    restrictions = {
        banned_cards = survivor_cards,
        banned_tags = {
            { id = 'tag_d_six' },
            { id = 'tag_uncommon' },
            { id = 'tag_rare' },
            { id = 'tag_negative' },
            { id = 'tag_foil' },
            { id = 'tag_holo' },
            { id = 'tag_polychrome' },
        },
    },
    deck = {
        type = 'Challenge Deck',
    },

    apply = function(self)
        change_shop_size(-2)
    end
}

SMODS.Challenge {
    key = '_2tc',
    loc_txt = {
        name = '2 Tower Chimps'
    },
    rules = {
        custom = {
            { id = 'no_negative_jokers' },
        },
        modifiers = {
            { id = 'joker_slots', value = 2 },
        }
    },
    jokers = {},
    vouchers = {},
    restrictions = {
        banned_cards = banned_2tc_cards,
        banned_tags = {
            { id = 'tag_negative' },
            { id = 'tag_bloons_concoction' }
        },
        banned_other = {
            { id = 'bl_final_leaf', type = 'blind' },
            { id = 'bl_bloons_final_zomg', type = 'blind' },
        }
    },
    deck = {
        type = 'Challenge Deck',
    },

    apply = function(self)
        SMODS.Edition:take_ownership("negative", {
			get_weight = function()
				return 0
			end,
		}, true)
    end
}

SMODS.Challenge {
    key = '_2mp',
    loc_txt = {
        name = '2 Megapops'
    },
    rules = {
        custom = {
            { id = '_2mp' },
        },
    },
    jokers = {},
    vouchers = {},
    restrictions = {
        banned_cards = {
            {id = 'v_bloons_big_bloon_sabotage'},
            {id = 'v_bloons_big_bloon_blueprints'},
        },
        banned_tags = {
            { id = 'tag_bloons_sabotage' }
        },
        banned_other = {
            { id = 'bl_final_vessel', type = 'blind' },
            { id = 'bl_bloons_final_bad', type = 'blind' }
        }
    },
    deck = {
        type = 'Challenge Deck',
    },

    apply = function(self)
        G.GAME.modifiers.scaling = 3
    end
}

SMODS.Challenge {
    key = 'bloonarius',
    loc_txt = {
        name = 'Bloonarius',
    },
    rules = {
        custom = {
            { id = 'bloonarius1' },
            { id = 'bloonarius2' },
            { id = 'bloonarius3' },
            { id = 'bloonarius4' },
        }
    },
    jokers = {},
    vouchers = {},
    restrictions = boss_bans,
    deck = {
        type = 'Challenge Deck'
    },
}

SMODS.Challenge {
    key = 'lych',
    loc_txt = {
        name = 'Lych',
    },
    rules = {
        custom = {
            { id = 'lych1' },
            { id = 'lych2' },
            { id = 'lych3' },
            { id = 'lych4' },
        },
    },
    jokers = {},
    vouchers = {},
    restrictions = boss_bans,
    deck = {
        type = 'Challenge Deck'
    },
}

SMODS.Challenge {
    key = 'vortex',
    loc_txt = {
        name = 'Vortex',
    },
    rules = {
        custom = {
            { id = 'vortex1' },
            { id = 'vortex2' },
            { id = 'vortex3' },
            { id = 'vortex4' },
        },
    },
    jokers = {},
    vouchers = {},
    restrictions = boss_bans,
    deck = {
        type = 'Challenge Deck'
    },

    apply = function(self)
        G.GAME.win_ante = 6
    end
}

SMODS.Challenge {
    key = 'dreadbloon',
    loc_txt = {
        name = 'Dreadbloon',
    },
    rules = {
        custom = {
            { id = 'dreadbloon1' },
            { id = 'dreadbloon2' },
            { id = 'dreadbloon3' },
            { id = 'dreadbloon4' },
        }
    },
    jokers = {},
    vouchers = {},
    restrictions = {
        banned_cards = dreadbloon_cards
    },
    deck = {
        type = 'Challenge Deck'
    },
}

SMODS.Challenge {
    key = 'phayze',
    loc_txt = {
        name = 'Phayze',
    },
    rules = {
        custom = {
            { id = 'phayze1' },
            { id = 'phayze2' },
            { id = 'phayze3' },
            { id = 'phayze4' },
        }
    },
    jokers = {},
    vouchers = {
        { id = 'v_hone' },
        { id = 'v_glow_up' }
    },
    restrictions = boss_bans,
    deck = {
        type = 'Challenge Deck'
    },
}

SMODS.Challenge {
    key = 'blastapopoulos',
    loc_txt = {
        name = 'Blastapopoulos',
    },
    rules = {
        custom = {
            { id = 'blastapopoulos1' },
            { id = 'blastapopoulos2' },
            { id = 'blastapopoulos3' },
            { id = 'blastapopoulos4' },
        },
     },
    jokers = {},
    vouchers = {},
    restrictions = boss_bans,
    deck = {
        type = 'Challenge Deck'
    },
}

SMODS.Challenge {
    key = 'inflated_expert',
    loc_txt = {
        name = 'Inflated Expert'
    },
    rules = {
        custom = {
            { id = 'gold_stake' },
            { id = 'inflated' },
            { id = 'difficulty_warning'}
        },
        modifiers = {
            { id = 'hand_size', value = 13 },
            { id = 'hands', value = 3 },
            { id = 'discards', value = 0 },
            { id = 'dollars', value = 13 },
        }
    },
    jokers = {},
    vouchers = {},
    restrictions = {
        banned_cards = inflated_cards,
        banned_tags = {
            { id = 'tag_juggle' },
        },
        banned_other = {
            { id = 'bl_water', type = 'blind' },
            { id = 'bl_needle', type = 'blind' },
            { id = 'bl_serpent', type = 'blind' },
            { id = 'bl_bloons_final_moab', type = 'blind' },
        }
    },
    deck = {
        type = 'Challenge Deck',
    },
}

SMODS.Challenge {
    key = 'survivor_expert',
    loc_txt = {
        name = 'Survivor Expert'
    },
    rules = {
        custom = {
            { id = 'gold_stake' },
            { id = 'no_shop_rerolls' },
            { id = 'no_shop_slots' },
            { id = 'difficulty_warning'}
        },
    },
    jokers = {},
    vouchers = {},
    restrictions = {
        banned_cards = survivor_cards,
        banned_tags = {
            { id = 'tag_d_six' },
            { id = 'tag_uncommon' },
            { id = 'tag_rare' },
            { id = 'tag_negative' },
            { id = 'tag_foil' },
            { id = 'tag_holo' },
            { id = 'tag_polychrome' },
        },
    },
    deck = {
        type = 'Challenge Deck',
    },

    apply = function(self)
        change_shop_size(-2)
    end
}

SMODS.Challenge {
    key = '_2tc_expert',
    loc_txt = {
        name = '2 Tower Chimps Expert'
    },
    rules = {
        custom = {
            { id = 'gold_stake' },
            { id = 'no_negative_jokers' },
            { id = 'difficulty_warning'}
        },
        modifiers = {
            { id = 'joker_slots', value = 2 },
        }
    },
    jokers = {},
    vouchers = {},
    restrictions = {
        banned_cards = banned_2tc_cards,
        banned_tags = {
            { id = 'tag_negative' },
            { id = 'tag_bloons_concoction' }
        },
        banned_other = {
            { id = 'bl_final_leaf', type = 'blind' },
            { id = 'bl_bloons_final_zomg', type = 'blind' },
        }
    },
    deck = {
        type = 'Challenge Deck',
    },

    apply = function(self)
        SMODS.Edition:take_ownership("negative", {
			get_weight = function()
				return 0
			end,
		}, true)
    end
}

SMODS.Challenge {
    key = '_2mp_expert',
    loc_txt = {
        name = '2 Megapops Expert'
    },
    rules = {
        custom = {
            { id = 'gold_stake' },
            { id = '_2mp' },
            { id = 'difficulty_warning'}
        },
    },
    jokers = {},
    vouchers = {},
    restrictions = {
        banned_cards = {
            {id = 'v_bloons_big_bloon_sabotage'},
            {id = 'v_bloons_big_bloon_blueprints'},
        },
        banned_tags = {
            { id = 'tag_bloons_sabotage' }
        },
        banned_other = {
            { id = 'bl_final_vessel', type = 'blind' },
            { id = 'bl_bloons_final_bad', type = 'blind' }
        }
    },
    deck = {
        type = 'Challenge Deck',
    },

    apply = function(self)
        G.GAME.modifiers.scaling = 3
    end
}