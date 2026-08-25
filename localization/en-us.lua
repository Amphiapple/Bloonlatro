return {
    descriptions = {
        Back = {
            b_bloons_quincy = {
                name = 'Quincy Deck',
                text = {
                    '{C:green}#1# in #2#{} chance to',
                    'halve Chips',
                    '{C:mult}X#3#{} base Blind size'
                }
            },
            b_bloons_gwendolin = {
                name = 'Gwendolin Deck',
                text = {
                    'Start run with',
                    'an {C:spectral,T:c_immolate}Immolate{} card',
                    '{C:blue}-1{} hand every round'
                }
            },
            b_bloons_jones = {
                name = 'Jones Deck',
                text = {
                    'Create an',
                    '{C:power,T:c_bloons_artillery_command}Artillery Command{}',
                    'card after defeating',
                    'each {C:attention}Boss Blind{}'
                }
            },
            b_bloons_obyn = {
                name = 'Obyn Deck',
                text = {
                    'Start run with',
                    '{C:money,T:v_seed_money}Seed Money{} and',
                    '{C:money,T:v_money_tree}Money Tree{}'
                }
            },
            b_bloons_churchill = {
                name = 'Churchill Deck',
                text = {
                    '{X:mult,C:white}X#1#{} Mult against',
                    '{C:attention}Boss Blinds{}'
                }
            },
            b_bloons_benjamin = {
                name = 'Benjamin Deck',
                text = {
                    'Start with {C:attention,T:j_bloons_monkey_bank}Monkey Bank{}',
                    'and extra {C:money}$#1#'
                }
            },
            b_bloons_ezili = {
                name = 'Ezili Deck',
                text = {
                    'Start run with',
                    '{C:attention,T:v_magic_trick}Magic Trick{}, {C:enhanced,T:v_illusion}Illusion{},',
                    '{C:dark_edition,T:v_hone}Hone{}, and {C:dark_edition,T:v_glow_up}Glow Up{}'
                }
            },
            b_bloons_pat_fusty = {
                name = 'Pat Fusty Deck',
                text = {
                    '{C:attention}+#1#{} hand size'
                }
            },
            b_bloons_adora = {
                name = 'Adora Deck',
                text = {
                    'Sacrifice cards instead of',
                    'selling them to upgrade',
                    '{C:attention}#1# poker hands{} by {C:attention}1{} level'
                }
            },
            b_bloons_brickell = {
                name = 'Brickell Deck',
                text = {
                    'Start on Ante {C:attention}#1#{}',
                    'with a {C:power,T:c_bloons_mega_mine}Mega Mine{}',
                    'and {C:red}#3#{} discards'
                }
            },
            b_bloons_etienne = {
                name = 'Etienne Deck',
                text = {
                    '{C:attention}+#1#{} booster pack slot'
                }
            },
            b_bloons_sauda = {
                name = 'Sauda Deck',
                text = {
                    'Start run with all',
                    '{C:attention}poker hands{} upgraded',
                    'by {C:attention}1{} level'
                }
            },
            b_bloons_psi = {
                name = 'Psi Deck',
                text = {
                    'Reveal the next {C:attention}#1#{}',
                    'cards in your deck',
                }
            },
            b_bloons_geraldo = {
                name = 'Geraldo Deck',
                text = {
                    'Start run with the',
                    '{C:power,T:v_bloons_power_merchant}Power Merchant{} voucher',
                    "Other heroes' {C:power}powers{} may",
                    'appear in the shop',
                }
            },
            b_bloons_corvus = {
                name = 'Corvus Deck',
                text = {
                    'Played cards give',
                    '{C:attention}#1#{} mana when scored',
                    'Consume {C:attention}#2#{} mana to',
                    'create a {C:spectral}Spectral{} card',
                }
            },
            b_bloons_rosalia = {
                name = 'Rosalia Deck',
                text = {
                    'Toggle Rosalia\'s weapons',
                    '{C:attention}Laser{}: {X:mult,C:white}X#1#{} Mult after scoring',
                    '{C:blue}Grenade{}: {C:attention}Retrigger{} first scoring card'
                }
            },
            b_bloons_silas = {
                name = 'Silas Deck',
                text = {
                    '{C:attention,T:m_bloons_frozen}Freeze #1#{} cards',
                    'held in hand at',
                    'end of round'
                }
            },
            b_bloons_dan = {
                name = 'Dan Deck',
                text = {
                    'Prevents Death and',
                    'replays {C:attention}Blind{} once'
                }
            },
            b_bloons_boss_challenge = {
                name = 'Boss Challenge Deck'
            }
        },
        Blind = {
            bl_bloons_final_moab = {
                name = 'Massive MOAB',
                text = {
                    'Halve Hands and Discards',
                }
            },
            bl_bloons_final_bfb = {
                name = 'Brutal Behemoth',
                text = {
                    'Disable rightmost Jokers',
                    'equal to hands played'
                }
            },
            bl_bloons_final_ddt = {
                name = 'Dark Titan',
                text = {
                    '#1# in #2# cards',
                    'are debuffed',
                }
            },
            bl_bloons_final_zomg = {
                name = 'Green Gargantuan',
                text = {
                    'All Jokers debuffed',
                    'until 1 Joker sold',
                }
            },
            bl_bloons_final_bad = {
                name = 'B.A.D',
                text = {
                    'X1.5 blind requirement',
                    'after each hand',
                }
            },
            bl_bloons_bloonarius = {
                name = 'Bloonarius',
                text = {
                    'Fills deck with random',
                    'cards until deck size',
                    'reaches #1# cards',
                },
            },
            bl_bloons_lych = {
                name = 'Lych',
                text = {
                    'Revives and resets hands once',
                    'Removes enhancements from all',
                    'played and held in hand cards',
                    'Heals back #2#',
                    '#3# enhancement removed',
                },
            },
            bl_bloons_vortex = {
                name = 'Vortex',
                text = {
                    '-#1# hands',
                    '+#2# Hands and one random Joker disabled',
                    'every #3# chips scored',
                    'Cards are stunned when drawn to hand',
                },
                bloons_boss_challenge_rules = {
                    '{C:attention}Vortex{} appears in {C:attention}Ante 6{}'
                }
            },
            bl_bloons_dreadbloon = {
                name = 'Dreadbloon',
                text = {
                    'Score is capped at #1#',
                    'Halves base chips and mult',
                    'Debuffs Jokers by rarity',
                    'Debuffed rarity increases',
                    'after each hand played',
                },
            },
            bl_bloons_phayze = {
                name = 'Phayze',
                text = {
                    'Moves a random Joker to the leftmost',
                    'position when a hand is played',
                    'Debuffs all Jokers and cards',
                    'without an edition.',
                },
                bloons_boss_challenge_rules = {
                    'Start with {C:attention,T:v_hone}Hone{} and {C:attention,T:v_glow_up}Glow Up{}',
                }
            },
            bl_bloons_blastapopoulos = {
                name = 'Blastapopoulos',
                text = {
                    'Card draw adds a Meteor card to deck',
                    'Score is reduced by #1#% per heat point',
                    'Played scoring cards increase heat by #2#',
                    'Scoring Meteor cards increase heat by #3#',
                    'Held Frozen cards decrease heat by #4#',
                },
            },
            bl_bloons_diamondback_head = {
                name = 'Diamondback Head',
                text = {
                    'All face cards are debuffed',
                    'X1 score for each undefeated',
                    'Diamondback blind',
                },
                bloons_boss_challenge_rules = {
                    "{C:attention}Tail{} appears in {C:attention}Ante 8 Small Blind{}",
                    "{C:attention}Body{} appears in {C:attention}Ante 8 Big Blind{}",
                    "{C:attention}Head{} appears in {C:attention}Ante 8 Boss Blind{}"
                }
            },
            bl_bloons_diamondback_body = {
                name = 'Diamondback Body',
                text = {
                    'Adds #1# face cards to your',
                    'deck each hand played',
                    'X1 score for each undefeated',
                    'Diamondback blind',
                },
            },
            bl_bloons_diamondback_tail = {
                name = 'Diamondback Tail',
                text = {
                    'Score #1# less chips',
                    'X1 score for each undefeated',
                    'Diamondback blind',
                }
            },
        },
        Enhanced = {
            m_bloons_frozen = {
                name = 'Frozen Card',
                text = {
                    '{C:chips}+#1#{} Chips and',
                    'thaws when held in hand',
                    'no rank or suit',
                    "doesn't score"
                }
            },
            m_bloons_glued = {
                name = 'Glued Card',
                text = {
                    '{C:mult}+#1#{} Mult and',
                    'wears off if scored',
                    'Lose {C:money}$#2#{} when discarded'
                }
            },
            m_bloons_stunned = {
                name = 'Stunned Card',
                text = {
                    'Wears off and',
                    'is discarded if',
                    'held in hand'
                }
            },
            m_bloons_meteor = {
                name = 'Meteor Card',
                text = {
                    '{X:mult,C:white}X#1#{} Mult',
                    'destroys card',
                    'no rank or suit'
                }
            },
        },
        Stake = {
            stake_bloons_chimps = {
                name = "CHIMPS Stake",
                text = {
                    '{C:attention}Boss Blinds{} can have {C:attention}Modifiers{}',
                    '{s:0.8}Applies all previous Stakes{}'
                }
            }
        },
        Tag = {
            tag_bloons_cleansing = {
                name = 'Cleansing Tag',
                text = {
                    'Remove all {C:attention}Stickers{}',
                    'from leftmost {C:attention}Joker{}',
                }
            },
            tag_bloons_invisible = {
                name = 'Invisible Tag',
                text = {
                    '{C:attention}Duplicates{} a random',
                    '{C:attention}Joker{} after defeating',
                    'the {C:attention}Boss Blind{}',
                    '{C:inactive}(Must have room)',
                }
            },
            tag_bloons_power = {
                name = 'Power Tag',
                text = {
                    'Gives a free',
                    '{C:power}Mega Power Pack{}',
                }
            },
            tag_bloons_sabotage = {
                name = 'Sabotage Tag',
                text = {
                    'Reduces {C:attention}Blind{}',
                    'requirement by {C:attention}#1#%{}',
                    'next round',
                }
            },
            tag_bloons_redeemed = {
                name = 'Redeemed Tag',
                text = {
                    'Adds one {C:attention}Upgraded{}',
                    '{C:voucher}Voucher{} to the next shop',
                    '{C:inactive}(Must be available)',
                }
            },
            tag_bloons_concoction = {
                name = 'Concoction Tag',
                text = {
                    'Adds {C:dark_edition}Foil{}, {C:dark_edition}Holographic{},',
                    '{C:dark_edition}Polychrome{}, or {C:dark_edition}Negative{} edition',
                    'to a random {C:attention}Joker{}',
                }
            },
        },
        Voucher = {
            v_bloons_power_merchant = {
                name = 'Power Merchant',
                text = {
                    '{C:power}Power{} cards may',
                    'appear in the shop'
                }
            },
            v_bloons_power_tycoon = {
                name = 'Power Tycoon',
                text = {
                    '{C:power}Power{} cards appear',
                    '{C:attention}#1#X{} more frequently',
                    'in the shop'
                }
            },
            v_bloons_insider_trades = {
                name = 'Insider Trades',
                text = {
                    '{C:attention}+#1#{} Booster Pack slot'
                }
            },
            v_bloons_backroom_deals = {
                name = 'Backroom Deals',
                text = {
                    '{C:attention}+#1#{} Voucher slot'
                }
            },
            v_bloons_flanking_maneuvers = {
                name = 'Flanking Maneuvers',
                text = {
                    'Create a {C:attention}Double Tag{}',
                    'when skipping a {C:attention}Blind{}'
                }
            },
            v_bloons_grand_prix_spree = {
                name = 'Grand Prix Spree',
                text = {
                    'Create a {C:attention}Speed Tag{}',
                    'when skipping a {C:attention}Blind{}'
                }
            },
            v_bloons_big_bloon_sabotage = {
                name = 'Big Bloon Sabotage',
                text = {
                    'Reduce {C:attention}Blind{}',
                    'requirement by {C:attention}#1#%{}'
                }
            },
            v_bloons_big_bloon_blueprints = {
                name = 'Big Bloon Blueprints',
                text = {
                    'Reduce {C:attention}Boss Blind{}',
                    'requirement by {C:attention}#1#%{} instead'
                }
            },
        },
        Other = {
            bloons_chimps_sticker = {
                name = "CHIMPS Sticker",
                text = {
                    'Used this Joker',
                    'to win on {C:attention}CHIMPS',
                    '{C:attention}Stake{} difficulty',
                }
            },
            p_bloons_power_normal_1 = {
                name = 'Power Pack',
                text = {
                    'Choose {C:attention}#1#{} of {C:attention}#2#{}',
                    '{C:power}Power{} cards to add',
                    'to your consumables'
                }
            },
            p_bloons_power_normal_2 = {
                name = 'Power Pack',
                text = {
                    'Choose {C:attention}#1#{} of {C:attention}#2#{}',
                    '{C:power}Power{} cards to add',
                    'to your consumables'
                }
            },
            p_bloons_power_jumbo_1 = {
                name = 'Jumbo Power Pack',
                text = {
                    'Choose {C:attention}#1#{} of {C:attention}#2#{}',
                    '{C:power}Power{} cards to add',
                    'to your consumables'
                }
            },
            p_bloons_power_mega_1 = {
                name = 'Mega Power Pack',
                text = {
                    'Choose {C:attention}#1#{} of {C:attention}#2#{}',
                    '{C:power}Power{} cards to add',
                    'to your consumables'
                }
            },
            p_bloons_upgrade_normal_1 = {
                name = 'Power Pack',
                text = {
                    'Choose {C:attention}#1#{} of {C:attention}#2#{}',
                    '{C:upgrade}Upgrade{} cards to be',
                    'used immediately'
                }
            },
            p_bloons_upgrade_normal_2 = {
                name = 'Power Pack',
                text = {
                    'Choose {C:attention}#1#{} of {C:attention}#2#{}',
                    '{C:upgrade}Upgrade{} cards to be',
                    'used immediately'
                }
            },
            p_bloons_upgrade_jumbo_1 = {
                name = 'Jumbo Power Pack',
                text = {
                    'Choose {C:attention}#1#{} of {C:attention}#2#{}',
                    '{C:upgrade}Upgrade{} cards to be',
                    'used immediately'
                }
            },
            p_bloons_upgrade_mega_1 = {
                name = 'Mega Power Pack',
                text = {
                    'Choose {C:attention}#1#{} of {C:attention}#2#{}',
                    '{C:upgrade}Upgrade{} cards to be',
                    'used immediately'
                }
            },
            bloons_regrow = {
                name = 'Regrow',
                text = {
                    'Heal back {C:attention}#1#%{} of {C:attention}Blind{} size',
                    'when a hand is played'
                },
            },
            bloons_camo = {
                name = 'Camo',
                text = {
                    'Every {C:attention}#1#th Playing{}',
                    'card is drawn face',
                    'down and {C:attention}debuffed'
                },
            },
            bloons_fortified = {
                name = 'Fortified',
                text = {
                    '{C:attention}X#1# Blind{} size'
                },
            }
        }
    },
    misc = {
        dictionary = {
            k_power_pack = 'Power Pack',
            k_upgrade_pack = 'Upgrade Pack',
        },
        labels = {
            bloons_regrow = 'Regrow',
            bloons_camo = 'Camo',
            bloons_fortified = 'Fortified',
        },
        v_text = {
            ch_c_gold_stake = {
                "Challenge is played on {C:gold}Gold Stake{}"
            },
            ch_c_difficulty_warning = {
                "Warning: This challenge is {C:attention}RIDICULOUSLY {C:red}DIFFICULT{}"
            },
            ch_c_stubborn_strategy = {
                "Lose run when {C:attention}Rocket Storm{} resets"
            },
            ch_c_crash_of_the_titans = {
                "Must play {C:attention}5{} scoring cards"
            },
            ch_c_no_skipping_blinds = {
                "Skipping {C:attention}Blinds{} is disabled"
            },
            ch_c_no_shop_slots = {
                "Start with {C:attention}-2{} card slots available in the shop"
            },
            ch_c_half_blind_size = {
                "Half base {C:attention}Blind{} size"
            },
            ch_c_half_cash = {
                "Halve money when entering shop"
            },
            ch_c_student_loans = {
                "Must be {C:red}-$4000{} in debt at the end of ante {C:attention}8{}"
            },
            ch_c_sapper = {
                "All {C:attention}Boss Blinds{} are {C:attention,T:bloons_fortified}Fortified{}"
            },
            ch_c_nah_id_win = {
                "Must lose every {C:attention}Small Blind{} and {C:attention}Big Blind{}"
            },
            ch_c_inflated = {
                "After round begins, draw no cards"
            },
            ch_c_no_shop_rerolls = {
                "Rerolls are disabled"
            },
            ch_c_no_negative_jokers = {
                "Negative Jokers no longer appear in the shop"
            },
            ch_c__2mp = {
                "Required score scales extremely fast for each {C:attention}Ante{}"
            },
        },
    },
}
