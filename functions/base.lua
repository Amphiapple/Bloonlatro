Primary_towers = {
    'dart',
    'boomer',
    'bomb',
    'tack',
    'ice',
    'glue',
    'desperado',
}

Military_towers = {
    'sniper',
    'sub',
    'boat',
    'ace',
    'heli',
    'mortar',
    'dartling',
}

Magic_towers = {
    'wizard',
    'super',
    'ninja',
    'alch',
    'druid',
    'merm',
}

Support_towers = {
    'farm',
    'spac',
    'village',
    'engi',
    'beast',
}

--Tower effects function
function Card.get_category_vtsg(self)
    local category = self.ability.base
    for k, v in ipairs(Primary_towers) do
        if category == v then
            return 'primary'
        end
    end
    for k, v in ipairs(Military_towers) do
        if category == v then
            return 'military'
        end
    end
    for k, v in ipairs(Magic_towers) do
        if category == v then
            return 'magic'
        end
    end
    for k, v in ipairs(Support_towers) do
        if category == v then
            return 'support'
        end
    end
    return nil
end

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
        local spike_factory_card = pseudorandom_element(valid_spike_factory_cards, pseudoseed('spac'..G.GAME.round_resets.ante))
        G.GAME.current_round.spike_factory_card.suit = spike_factory_card.base.suit
        G.GAME.current_round.spike_factory_card.rank = spike_factory_card.base.value
        G.GAME.current_round.spike_factory_card.id = spike_factory_card.base.id
    end
end

--Sacrifice Context for Adora and VTSG
function get_sac_context(card)
    local deck = G.GAME and G.GAME.selected_back
    local is_adora_deck = deck and deck.name == 'Adora Deck'
    local is_vtsg = card.ability and card.ability.name == 'Vengeful True Sun God'
    local vtsg_sacrifices = is_vtsg and card.ability.extra and card.ability.extra.sacrifices

    local sac_context = {
        vtsg_show = false,
        vtsg_enabled = false,
        adora_show = false,
        adora_enabled = false,
    }

    -- VTSG sacrifice
    if is_vtsg then
        sac_context.vtsg_show = true
        local no_sacs = vtsg_sacrifices
            and vtsg_sacrifices['primary'] == 0
            and vtsg_sacrifices['military'] == 0
            and vtsg_sacrifices['magic'] == 0
            and vtsg_sacrifices['support']  == 0

        local other_jokers = {}
        for _, joker in pairs(G.jokers.cards) do
            if joker ~= card then
                table.insert(other_jokers, joker)
            end
        end

        if #other_jokers >= 1 and no_sacs then
            sac_context.vtsg_enabled = true
        end
    end

    -- Adora sacrifice
    if is_adora_deck then
        sac_context.adora_show = true
        if not card.ability.eternal then
            sac_context.adora_enabled = true
        end
    end

    return sac_context
end

--Sacrifice function for Adora
G.FUNCS.adora_sac = function(e)
    local card = e.config.ref_table
    local sac_context = get_sac_context(card)
    if not (G.GAME.selected_back.effect.center) or not sac_context.adora_enabled then return end
    G.GAME.selected_back.effect.center.sac_to_adora(card)
    SMODS.calculate_context({selling_card = true, card = card})
end

--Sacrifice function for VTSG
G.FUNCS.vtsg_sac = function(e)
    local card = e.config.ref_table
    local sac_context = get_sac_context(card)
    if not sac_context.vtsg_enabled then return end
    card.config.center.sac_to_vtsg(card)
    card.highlighted = false
end

--Enable optional features
SMODS.current_mod.optional_features = function()
    return {
        post_trigger = true,
        retrigger_joker = true,
    }
end