JokerDisplay.Definitions["j_bloons_beast"] = { --Beast Handler
    
}

JokerDisplay.Definitions["j_bloons_owl"] = { --Horned Owl
    
}

JokerDisplay.Definitions["j_bloons_velo"] = { --Velociraptor

}

JokerDisplay.Definitions["j_bloons_condor"] = { --Giant Condor
    reminder_text = {
        { text = "(" },
        { text = "Mult", colour = G.C.ORANGE }, 
        { text = ")" }
    },
    extra = {
        {
            { text = "(", colour = G.C.GREEN, scale = 0.3 },
            { ref_table = "card.joker_display_values", ref_value = "odds", colour = G.C.GREEN, scale = 0.3 },
            { text = ")", colour = G.C.GREEN, scale = 0.3 },
        }
    },
    calc_function = function(card)
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'condor')
        card.joker_display_values.odds = numerator .. " in " .. denominator
    end
}

JokerDisplay.Definitions["j_bloons_meg"] = { --Megalodon
    
}