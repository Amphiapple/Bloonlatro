--Challenge id function
function get_challenge_stake(e)
    local key = G.CHALLENGES[e.config.id].id
    if key and Challenge_stakes[key] then
        return Challenge_stakes[key].stake
    end
    return 1
end

--Recalculate cost function
function recalc_all_costs()
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.0,
        func = (function()
            for k, v in pairs(G.I.CARD) do
                if v.set_cost then
                    v:set_cost()
                end
            end
            return true
        end)
    }))
end

--Reset desperado card
function reset_desperado_card()
    G.GAME.current_round.desperado_card.rank = 'Ace'
    local valid_desperado_cards = {}
    for k, v in ipairs(G.playing_cards) do
        if not SMODS.has_no_rank(v) then
            valid_desperado_cards[#valid_desperado_cards+1] = v
        end
    end
    if valid_desperado_cards[1] then
        local desperado_card = pseudorandom_element(valid_desperado_cards, pseudoseed('desperado'..G.GAME.round_resets.ante))
        G.GAME.current_round.desperado_card.rank = desperado_card.base.value
        G.GAME.current_round.desperado_card.id = desperado_card.base.id
    end
end

--Reset spike factory card
function reset_spike_factory_card()
    G.GAME.current_round.spike_factory_card.rank = 'Ace'
    local valid_spike_factory_cards = {}
    for k, v in ipairs(G.playing_cards) do
        if not SMODS.has_no_rank(v) then
            valid_spike_factory_cards[#valid_spike_factory_cards+1] = v
        end
    end
    if valid_spike_factory_cards[1] then
        local spike_factory_card = pseudorandom_element(valid_spike_factory_cards, pseudoseed('spike_factory'..G.GAME.round_resets.ante))
        G.GAME.current_round.spike_factory_card.suit = spike_factory_card.base.suit
        G.GAME.current_round.spike_factory_card.rank = spike_factory_card.base.value
        G.GAME.current_round.spike_factory_card.id = spike_factory_card.base.id
    end
end

--Enable optional features
SMODS.current_mod.optional_features = function()
    return {
        post_trigger = true,
        retrigger_joker = true,
    }
end