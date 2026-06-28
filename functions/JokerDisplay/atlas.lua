local old_calculate_card_triggers = JokerDisplay.calculate_card_triggers
function JokerDisplay.calculate_card_triggers(card, scoring_hand, held_in_hand)
    local count = old_calculate_card_triggers(card, scoring_hand, held_in_hand)
    if G.consumeables and G.consumeables.cards and not card.debuff then
        for _, consumable in pairs(G.consumeables.cards) do
            if not consumable.config or not consumable.config.center then return count end
            if consumable.config.center.key == "c_bloons_thrive" and consumable.ability.active and not card.highlighted then
                count = count + consumable.ability.retrigger
            end
            if scoring_hand and consumable.config.center.key == "c_bloons_road_spikes" then
                for i = 1, #scoring_hand do
                    if scoring_hand[i] == card and i <= consumable.ability.spikes then
                        count = count + consumable.ability.retrigger
                    end
                end
            end
            if consumable.config.center.key == "c_bloons_tech_bot" and consumable.ability.active and G.jokers.cards and #G.jokers.cards >= 1 then
                local joker = G.jokers.cards[#G.jokers.cards]
                local joker_display_definition = JokerDisplay.Definitions[joker.config.center.key]
                local retrigger_function =
                    not joker.debuff and joker.joker_display_values and (
                        (joker_display_definition and joker_display_definition.retrigger_function)
                        or
                        (joker.joker_display_values.blueprint_ability_key
                            and not joker.joker_display_values.blueprint_debuff
                            and not joker.joker_display_values.blueprint_stop_func
                            and JokerDisplay.Definitions[joker.joker_display_values.blueprint_ability_key]
                            and JokerDisplay.Definitions[joker.joker_display_values.blueprint_ability_key].retrigger_function)
                    )

                if retrigger_function then
                    local retriggers = retrigger_function(
                        card,
                        scoring_hand,
                        held_in_hand or false,
                        joker.joker_display_values
                            and not joker.joker_display_values.blueprint_stop_func
                            and joker.joker_display_values.blueprint_ability_joker
                            or joker
                    ) or 0

                    count = count + math.floor(retriggers)
                end
            end
        end
    end
    return count
end
