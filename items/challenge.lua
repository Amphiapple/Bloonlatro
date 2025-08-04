local vanilla_jokers = {}

for key, center in pairs(G.P_CENTERS or {}) do
    if key:sub(1,2) == "j_" and not key:find("^j_bloons") then
        table.insert(vanilla_jokers, { id = key })
    end
end

SMODS.Challenge {
    key = 'bloonlatro',
    loc_txt = {
        name = 'Bloonlatro',
    },
    rules = {
        custom = {
            { id = 'no_vanilla_jokers' }
        }
    },
    jokers = {},
    vouchers = {},
    restrictions = {
        banned_cards = vanilla_jokers,
    },
    deck = {
        type = 'Challenge Deck'
    }
}

SMODS.Challenge {
    key = 'monkey_capital',
    loc_txt = {
        name = 'Monkey Capital',
    },
    rules = {
        custom = {
            { id = 'no_shop_jokers' },
            { id = 'no_reward' },
            { id = 'no_extra_hand_money' },
            { id = 'no_interest' },
        },
        modifiers = {
            { id = 'joker_slots', value = 100 },
            { id = 'hands', value = 1 },
            { id = 'discards', value = 5 },
        }
    },
    restrictions = {
        banned_cards = {
            {id = 'c_judgement'},
            {id = 'c_wraith'},
            {id = 'c_soul'},
            {id = 'v_antimatter'},
            {id = 'p_buffoon_normal_1', ids = {
                'p_buffoon_normal_1','p_buffoon_normal_2','p_buffoon_jumbo_1','p_buffoon_mega_1',
            }},
        },
        banned_tags = {
            {id = 'tag_rare'},
            {id = 'tag_uncommon'},
            {id = 'tag_holo'},
            {id = 'tag_polychrome'},
            {id = 'tag_negative'},
            {id = 'tag_foil'},
            {id = 'tag_buffoon'},
            {id = 'tag_top_up'},
        },
    },
    jokers = {
        { id = 'j_bloons_city', eternal = true }
    }
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
    restrictions = {
        banned_cards = {
            { id = 'j_luchador' },
            { id = 'j_chicot' },
            { id = 'j_mr_bones' },
            { id = 'j_bloons_blitz' },
        },
        banned_other = {
            { id = 'bl_final_bell', type = 'blind' },
            { id = 'bl_final_vessel', type = 'blind' },
            { id = 'bl_final_leaf', type = 'blind' },
            { id = 'bl_final_heart', type = 'blind' },
            { id = 'bl_final_acorn', type = 'blind' },
        },
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
    restrictions = {
        banned_cards = {
            { id = 'j_luchador' },
            { id = 'j_chicot' },
            { id = 'j_mr_bones' },
            { id = 'j_bloons_blitz' },
        },
        banned_other = {
            { id = 'bl_final_bell', type = 'blind' },
            { id = 'bl_final_vessel', type = 'blind' },
            { id = 'bl_final_leaf', type = 'blind' },
            { id = 'bl_final_heart', type = 'blind' },
            { id = 'bl_final_acorn', type = 'blind' },
        },
    },
    deck = {
        type = 'Challenge Deck'
    },
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
        banned_cards = {
            { id = 'j_luchador' },
            { id = 'j_chicot' },
            { id = 'j_bloons_draft' },
            { id = 'j_burglar' },
            { id = 'j_mr_bones' },
            { id = 'j_bloons_blitz' },
            { id = 'v_grabber' },
            { id = 'v_nacho_tong' },
            { id = 'v_hieroglyph' }
        },
        banned_other = {
            { id = 'bl_final_bell', type = 'blind' },
            { id = 'bl_final_vessel', type = 'blind' },
            { id = 'bl_final_leaf', type = 'blind' },
            { id = 'bl_final_heart', type = 'blind' },
            { id = 'bl_final_acorn', type = 'blind' },
        },
    },
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
    restrictions = {
        banned_cards = {
            { id = 'j_luchador' },
            { id = 'j_chicot' },
            { id = 'j_mr_bones' },
            { id = 'j_bloons_blitz' },
        },
        banned_other = {
            { id = 'bl_final_bell', type = 'blind' },
            { id = 'bl_final_vessel', type = 'blind' },
            { id = 'bl_final_leaf', type = 'blind' },
            { id = 'bl_final_heart', type = 'blind' },
            { id = 'bl_final_acorn', type = 'blind' },
        },
    },
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
    restrictions = {
        banned_cards = {
            { id = 'j_luchador' },
            { id = 'j_chicot' },
            { id = 'j_mr_bones' },
            { id = 'j_bloons_blitz' },
        },
        banned_other = {
            { id = 'bl_final_bell', type = 'blind' },
            { id = 'bl_final_vessel', type = 'blind' },
            { id = 'bl_final_leaf', type = 'blind' },
            { id = 'bl_final_heart', type = 'blind' },
            { id = 'bl_final_acorn', type = 'blind' },
        },
    },
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
    restrictions = {
        banned_cards = {
            { id = 'j_luchador' },
            { id = 'j_chicot' },
            { id = 'j_mr_bones' },
            { id = 'j_bloons_blitz' },
        },
        banned_other = {
            { id = 'bl_final_bell', type = 'blind' },
            { id = 'bl_final_vessel', type = 'blind' },
            { id = 'bl_final_leaf', type = 'blind' },
            { id = 'bl_final_heart', type = 'blind' },
            { id = 'bl_final_acorn', type = 'blind' },
        },
    },
    deck = {
        type = 'Challenge Deck'
    },
}
