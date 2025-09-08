local vanilla_jokers = {}
for key, _ in pairs(G.P_CENTERS or {}) do
    if key:sub(1,2) == "j_" and not key:find("^j_bloons") then
        table.insert(vanilla_jokers, { id = key })
    end
end

local banned_tarot_cards = {
    { id = 'j_hallucination' },
    { id = 'j_cartomancer' },
    { id = 'j_8_ball' },
    { id = 'j_vagabond' },
    { id = 'j_bloons_owl' },
    { id = 'j_bloons_tripshot' },
    { id = 'j_bloons_supply' },
    { id = 'j_bloons_amast' },
    { id = 'j_bloons_fortress' },
    { id = 'p_arcana_normal_1', ids = {
        'p_arcana_normal_1', 'p_arcana_normal_2',
        'p_arcana_normal_3', 'p_arcana_normal_4',
        'p_arcana_jumbo_1', 'p_arcana_jumbo_2',
        'p_arcana_mega_1', 'p_arcana_mega_2' }
    },
    { id = 'c_medium' },
    { id = 'v_tarot_merchant' },
    { id = 'v_tarot_tycoon' },

}

local banned_tarot_tags = {
    { id = 'tag_charm' }
}

local banned_tarot_others = {
    { id = 'Purple' }
}

local banned_enhancement_cards = {
    { id = 'm_bloons_frozen' },
    { id = 'm_bloons_glued' },
    { id = 'm_bloons_stunned' },
    { id = 'c_bloons_volcano' },
    { id = 'c_bloons_gtrap' },
    { id = 'c_bloons_ftrap' },
    { id = 'c_bloons_psychic' },
    { id = 'j_midas_mask' },
    { id = 'j_bloons_ice' },
    { id = 'j_bloons_glue' },
    { id = 'j_bloons_wiz' },
    { id = 'j_bloons_glose' },
    { id = 'j_bloons_sshock' },
    { id = 'j_bloons_flash' },
    { id = 'j_bloons_velo' },
    { id = 'j_bloons_blimpact' },
    { id = 'j_bloons_icicles' },
    { id = 'j_bloons_az' },
    { id = 'j_bloons_solver' },
    { id = 'j_bloons_wlp' }
}

local banned_hand_cards = {
    { id = 'j_bloons_draft' },
    { id = 'j_bloons_pspike' },
    { id = 'j_burglar' },
    { id = 'v_grabber' },
    { id = 'v_nacho_tong' },
    { id = 'c_bloons_time' }
}

local unable_perishable = {
    { id = 'j_ceremonial' },
    { id = 'j_ride_the_bus' },
    { id = 'j_runner' },
    { id = 'j_constellation' },
    { id = 'j_green_joker' },
    { id = 'j_red_card' },
    { id = 'j_madness' },
    { id = 'j_square' },
    { id = 'j_vampire' },
    { id = 'j_hologram' },
    { id = 'j_rocket' },
    { id = 'j_obelisk' },
    { id = 'j_lucky_cat' },
    { id = 'j_flash' },
    { id = 'j_trousers' },
    { id = 'j_castle' },
    { id = 'j_glass' },
    { id = 'j_wee' },
    { id = 'j_bloons_corrosive' },
    { id = 'j_bloons_quad' },
    { id = 'j_bloons_smart' },
    { id = 'j_bloons_bioboomer' },
    { id = 'j_bloons_blade' },
    { id = 'j_bloons_shards' },
    { id = 'j_bloons_tripguns' },
    { id = 'j_bloons_lls' },
    { id = 'j_bloons_rorm' },
    { id = 'j_bloons_meg' }
}

local unable_eternal = {
    {id = 'j_gros_michel'},
    {id = 'j_ice_cream'},
    {id = 'j_cavendish'},
    {id = 'j_turtle_bean'},
    {id = 'j_ramen'},
    {id = 'j_diet_cola'},
    {id = 'j_selzer'},
    {id = 'j_popcorn'},
    {id = 'j_mr_bones'},
    {id = 'j_invisible'},
    {id = 'j_luchador'},
    {id = 'j_bloons_grape'},
    {id = 'j_bloons_pineapple'},
    {id = 'j_bloons_brew'},
    {id = 'j_bloons_bank'},
    {id = 'j_bloons_blitz'},
    {id = 'j_bloons_tt5'},
}

local income_jokers = {
    {id = 'j_delayed_grat'},
    {id = 'j_business'},
    {id = 'j_faceless'},
    {id = 'j_todo_list'},
    {id = 'j_cloud_9'},
    {id = 'j_rocket'},
    {id = 'j_reserved_parking'},
    {id = 'j_mail'},
    {id = 'j_golden'},
    {id = 'j_trading'},
    {id = 'j_ticket'},
    {id = 'j_rough_gem'},
    {id = 'j_matador'},
    {id = 'j_satellite'},
    {id = 'j_to_the_moon'},
    {id = 'j_bloons_farm'},
    {id = 'j_bloons_engi'},
    {id = 'j_bloons_doublegun'},
    {id = 'j_bloons_jbounty'},
    {id = 'j_bloons_bank'},
    {id = 'j_bloons_r2g'},
    {id = 'j_bloons_city'},
    {id = 'j_bloons_gustice'},
    {id = 'j_bloons_fortress'}
}

local income_tags = {
    { id = 'tag_investment' },
    { id = 'tag_handy' },
    { id = 'tag_garbage' },
    { id = 'tag_skip' },
    { id = 'tag_economy' }
}

local boss_jokers = {}
table.insert(boss_jokers, { id = 'j_luchador' })
table.insert(boss_jokers, { id = 'j_chicot' })
table.insert(boss_jokers, { id = 'j_mr_bones' })
table.insert(boss_jokers, { id = 'j_bloons_blitz' })

local finisher_blinds = {}
table.insert(finisher_blinds, { id = 'bl_final_bell', type = 'blind' })
table.insert(finisher_blinds, { id = 'bl_final_vessel', type = 'blind' })
table.insert(finisher_blinds, { id = 'bl_final_leaf', type = 'blind' })
table.insert(finisher_blinds, { id = 'bl_final_heart', type = 'blind' })
table.insert(finisher_blinds, { id = 'bl_final_acorn', type = 'blind' })

local boss_bans = {
    banned_cards = boss_jokers,
    banned_other = finisher_blinds
}

local abracadabmonkey_cards = {}
for _, card in ipairs(banned_enhancement_cards) do
    table.insert(abracadabmonkey_cards, card)
end
for _, card in ipairs(banned_tarot_cards) do
    table.insert(abracadabmonkey_cards, card)
end

local abracadabmonkey_bans = {
    banned_cards = abracadabmonkey_cards,
    banned_tags = banned_tarot_tags,
    banned_other = banned_tarot_others
}

local sticky_situation_cards = {
    { id = 'j_bloons_glose' }
}
local sticky_situation_others = {
    { id = 'bl_water', type = 'blind' },
    { id = 'bl_needle', type = 'blind' }
}
for _, card in ipairs(banned_tarot_cards) do
    table.insert(sticky_situation_cards, card)
end
for _, card in ipairs(banned_hand_cards) do
    table.insert(sticky_situation_cards, card)
end
for _, card in ipairs(banned_tarot_others) do
    table.insert(sticky_situation_others, card)
end

local sticky_situation_bans = {
    banned_cards = sticky_situation_cards,
    banned_tags = banned_tarot_tags,
    banned_other = sticky_situation_others
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

local dreadbloon_bans = {
    banned_cards = dreadbloon_cards,
    banned_other = finisher_blinds
}

local glorious_gold_cards = {
    { id = 'c_talisman' }
}
for _, joker in ipairs(income_jokers) do
    table.insert(glorious_gold_cards, joker)
end

local glorious_gold_other = {
    { id = 'Gold' }
}

local glorious_gold_bans = {
    banned_cards = glorious_gold_cards,
    banned_other = glorious_gold_other
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
}
for _, tag in ipairs(income_tags) do
    table.insert(monkeyopolis_tags, tag)
end

local crash_of_the_titans_cards = {
    { id = 'c_hanged_man' },
    { id = 'c_incantation' },
    { id = 'c_grim' },
    { id = 'c_familiar' },
    { id = 'c_immolate'},
    { id = 'c_bloons_volcano' },
    { id = 'c_bloons_cave'},
    { id = 'p_standard_normal_1',
        ids = {'p_standard_normal_1','p_standard_normal_2','p_standard_normal_3','p_standard_normal_4','p_standard_jumbo_1','p_standard_jumbo_2','p_standard_mega_1','p_standard_mega_2'},
    },
    { id = 'j_marble' },
    { id = 'j_certificate' },
    { id = 'j_trading' },
    { id = 'j_erosion'},
    { id = 'j_dna'},
    { id = 'j_bloons_necro'},
    { id = 'j_bloons_iring' },
    { id = 'j_bloons_wlp' },
    { id = 'j_bloons_tt5'},
    { id = 'j_bloons_mdom' },
    { id = 'v_magic_trick' },
    { id = 'v_illusion' },
    { id = 'v_hieroglyph' },
    { id = 'v_petroglyph' }
}

for _, joker in ipairs(banned_hand_cards) do
    table.insert(crash_of_the_titans_cards, joker)
end

SMODS.Challenge {
    key = 'bloonlatro',
    loc_txt = {
        name = 'Bloonlatro',
    },
    rules = {
        custom = {
            { id = 'gold_stake' },
            { id = 'bloonlatro' }
        }
    },
    jokers = {},
    vouchers = {},
    restrictions = {
        banned_cards = vanilla_jokers,
    },
    deck = {
        type = 'Challenge Deck'
    },

    apply = function(self)
        G.GAME.stake = 8
    end
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
            {id = 'c_bloons_cash'},
            {id = 'c_bloons_farmer'},
            {id = 'v_antimatter'},
            {id = 'p_buffoon_normal_1',
                ids = {'p_buffoon_normal_1','p_buffoon_normal_2', 'p_buffoon_jumbo_1','p_buffoon_mega_1'},
            },
        },
        banned_tags = monkeyopolis_tags,
    },
    jokers = {
        { id = 'j_bloons_city', eternal = true }
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
        { id = 'j_bloons_rorm', eternal = true }
    },
    vouchers = {},
    restrictions = {
        banned_cards = {
            { id = 'j_bloons_tt5'},
        }
    },
    deck = {
        type = 'Challenge Deck'
    },

    calculate = function(self, context)
        if context.initial_scoring_step and not context.blueprint then
            if G.play and G.play.cards then
                local text,disp_text,poker_hands,scoring_hand,non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)

                local final_scoring_hand = {}
                for i=1, #G.play.cards do
                    local splashed = SMODS.always_scores(G.play.cards[i]) or next(find_joker('Splash'))
                    local unsplashed = SMODS.never_scores(G.play.cards[i])
                    if not splashed then
                        for _, card in pairs(scoring_hand) do
                            if card == G.play.cards[i] then splashed = true end
                        end
                    end
                    local effects = {}
                    SMODS.calculate_context({modify_scoring_hand = true, other_card =  G.play.cards[i], full_hand = G.play.cards, scoring_hand = scoring_hand, in_scoring = true}, effects)
                    local flags = SMODS.trigger_effects(effects, G.play.cards[i])
                    if flags and flags.add_to_hand then splashed = true end
                    if flags and flags.remove_from_hand then unsplashed = true end
                    if splashed and not unsplashed then table.insert(final_scoring_hand, G.play.cards[i]) end
                end
                -- TARGET: adding to hand effects
                scoring_hand = final_scoring_hand

                local value_counts = {}
                local duplicate_found = false
                for _, card in ipairs(scoring_hand) do
                    local v = card.base.value
                    value_counts[v] = (value_counts[v] or 0) + 1
                end
                for _, count in pairs(value_counts) do
                    if count > 1 then
                        duplicate_found = true
                    end
                end

                if not duplicate_found then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        func = function()
                            G.STATE = G.STATES.GAME_OVER
                            G.STATE_COMPLETE = false
                            return true
                        end
                    }))
                end
            end
        end
    end,

    apply = function(self)
        G.GAME.stake = 8
    end
}

SMODS.Challenge {
    key = 'abracadabmonkey',
    loc_txt = {
        name = 'Abracadabmonkey'
    },
    rules = {
        custom = {
            { id = 'abracadabmonkey' },
            { id = 'no_shop_tarots' },
        }
    },
    jokers = {
        { id = 'j_bloons_wiz', eternal = true }
    },
    vouchers = {},
    restrictions = abracadabmonkey_bans,
    deck = {
        type = 'Challenge Deck',
    },

    apply = function(self)
        G.GAME.tarot_rate = 0
    end
}

SMODS.Challenge {
    key = 'glorious_gold',
    loc_txt = {
        name = 'Glorious Gold'
    },
    rules = {
        custom = {
            { id = 'gold_stake' },
            { id = 'condensed_no_extra_money' },
            { id = 'disable_gold_card_money' },
            { id = 'scored_cards_become_gold' },
        }
    },
    jokers = {
        { id = 'j_bloons_gustice', eternal = true }
    },
    vouchers = {},
    restrictions = glorious_gold_bans,
    deck = {
        type = 'Challenge Deck',
    },

    calculate = function(self, context)
        if context.before and not context.blueprint then
            for i, card in ipairs(context.scoring_hand) do
                if not card.debuff and not (card.config.center == G.P_CENTERS['m_gold']) then
                    card:set_ability('m_gold', nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            context.scoring_hand[i]:juice_up()
                            return true
                        end
                    }))
                end
            end
        end
    end,

    apply = function(self)
        G.GAME.modifiers.no_extra_hand_money = true
        G.GAME.modifiers.no_interest = true
        G.GAME.modifiers.no_blind_reward = G.GAME.modifiers.no_blind_reward or {}
        G.GAME.modifiers.no_blind_reward.Small = true
        G.GAME.modifiers.no_blind_reward.Big = true
        G.GAME.modifiers.no_blind_reward.Boss = true
        G.GAME.stake = 8
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
        { id = 'j_bloons_intel' }
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
        { id = 'j_bloons_cin', eternal = true }
    },
    vouchers = {},
    restrictions = {
            banned_cards = crash_of_the_titans_cards,
            banned_tags = {
                { id = 'tag_standard' },
            },
            banned_other = {
                { id = 'bl_water', type = 'blind' },
                { id = 'bl_needle', type = 'blind' }
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
    key = 'freaky_friday',
    loc_txt = {
        name = 'Freaky Friday'
    },
    rules = {
        custom = {
            { id = 'purple_stake' },
            { id = 'all_eternal' },
        },
    },
    jokers = {
        { id = 'j_bloons_tt5', pinned = true },
        { id = 'j_bloons_dart', eternal = true, pinned = true, edition = 'negative' },
    },
    vouchers = {},
    restrictions = {
        banned_cards = unable_eternal,
        banned_other = {
            { id = 'bl_final_leaf', type = 'blind' }
        }
    },
    deck = {
        type = 'Challenge Deck',
    },

    apply = function(self)
        G.GAME.stake = 6
    end
}

SMODS.Challenge {
    key = 'sticky_situation',
    loc_txt = {
        name = 'Sticky Situation'
    },
    rules = {
        custom = {
            { id = 'sticky_situation' },
            { id = 'glue_money_loss' },
            { id = 'no_shop_tarots' },
        },
        modifiers = {
            { id = 'hands', value = 1 },
        }
    },
    jokers = {
        { id = 'j_bloons_glue' }
    },
    vouchers = {},
    restrictions = sticky_situation_bans,
    deck = {
        type = 'Challenge Deck',
    },

    calculate = function(self, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            context.other_card:set_ability('m_bloons_glued', nil, true)
        end
    end,

    apply = function(self)
        G.GAME.tarot_rate = 0
    end
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
        { id = 'j_bloons_pspike', eternal = true }
    },
    vouchers = {},
    restrictions = {
        banned_cards = banned_hand_cards
    },
    deck = {
        type = 'Challenge Deck',
    },

    apply = function(self)
        G.GAME.stake = 8
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
    restrictions = dreadbloon_bans,
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