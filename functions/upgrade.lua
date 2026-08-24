get_tower_upgrade = function(card)
    
end

tower_upgrade = function(card, to_key, immediate, evolve_message, transformation, energize_amount)
    if G.GAME.modifiers.apply_randomizer and not transformation then
        to_key = get_random_poke_key('randomizer')
    end
    if immediate then
        tower_backend_upgrade(card, to_key, energize_amount)
    else
        G.E_MANAGER:add_event(Event({
        func = function()
            if card.evolution_timer or G.P_CENTERS[to_key] == card.config.center then return true end
            card.evolution_timer = 0
            G.E_MANAGER:add_event(Event({
                trigger = 'ease',
                ref_table = card,
                ref_value = 'evolution_timer',
                ease_to = 1.5,
                delay = 2.0,
                func = (function(t) return t end)
            }))
            G.E_MANAGER:add_event(Event({
            func = function()
                tower_backend_upgrade(card, to_key, energize_amount)
                return true
            end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'ease',
                ref_table = card,
                ref_value = 'evolution_timer',
                ease_to = 2.25,
                delay = 1.0,
                func = (function(t) return t end)
            }))
            G.E_MANAGER:add_event(Event({
            func = function()
                card.evolution_timer = nil
                play_sound('tarot1')
                card_eval_status_text(card, 'extra', nil, nil, nil, { message = evolve_message or localize("poke_evolve_success"), colour = G.C.FILTER, instant = true})
                return true
            end
            }))
            return true
        end
        }))
    end
end 

tower_backend_upgrade = function(card, to_key, energize_amount)
    local custom_values_to_keep = {}
    local has_custom_values_to_keep = nil
    local trigger_add = nil
    local new_card = G.P_CENTERS[to_key]
    if card.config.center == new_card then return end
    
    local old_key = card.config.center.key
    
    --turn off multisprite on evolution
    if card.config.center.poke_multi_sprite and card.ability and card.ability.extra then
        card.ability.extra.loaded_pos = nil
        card.ability.extra.loaded_sprite = nil
    end
    
    -- if it's not a mega and not a devolution and still has rounds left, reset perish tally
    if card.ability.perishable and card.config.center.rarity ~= "poke_mega" then
        if card.ability.perish_tally == 0 then trigger_add = true end
        card.ability.perish_tally = G.GAME.perishable_rounds
        card.debuff = false
    end

    local names_to_keep = {"targets", "rank", "id", "cards_scored", "cards_drawn", "energy_count", "c_energy_count", "e_limit_up", "form"}
    if type_sticker_applied(card) then
        table.insert(names_to_keep, "ptype")
    end
    local values_to_keep = copy_scaled_values(card)
    if type(card.ability.extra) == "table" then
        for _, k in pairs(names_to_keep) do
        values_to_keep[k] = card.ability.extra[k]
        end
    end
    
    -- value filtering
    if values_to_keep.hazards_drawn then
        values_to_keep.hazards_drawn = values_to_keep.hazards_drawn % 2
    end
    
    if card.config.center.poke_custom_values_to_keep then
        for k, v in pairs(card.config.center.poke_custom_values_to_keep) do
        custom_values_to_keep[v] = card.ability.extra[v]
        end
        has_custom_values_to_keep = true
    end
    
    card.children.center = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, SMODS.get_atlas(new_card.atlas or "Joker"), new_card.pos)
    card.children.center.states.hover = card.states.hover
    card.children.center.states.click = card.states.click
    card.children.center.states.drag = card.states.drag
    card.children.center.states.collide.can = false
    card.children.center:set_role({major = card, role_type = 'Glued', draw_major = card})
    card:set_ability(new_card, true)
    card:set_cost()

    if type(card.ability.extra) == "table" then
        for k,v in pairs(values_to_keep) do
        if card.ability.extra[k] or k == "energy_count" or k == "c_energy_count" or k == "e_limit_up" then
            if type(card.ability.extra[k]) ~= "number" or (type(v) == "number" and v > card.ability.extra[k]) or k == "form" then
            card.ability.extra[k] = v
            end
        end
        end
        if values_to_keep["form"] and type(new_card.set_ability) == 'function' then
        new_card:set_ability(card)
        end
        if card.ability.extra.energy_count or card.ability.extra.c_energy_count then
        energize(card, nil, true, true)
        end
    end
    
    if has_custom_values_to_keep then
        for k, v in pairs(custom_values_to_keep) do
        card.ability.extra[k] = v
        end
    end

    if new_card.soul_pos then
        card.children.floating_sprite = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, SMODS.get_atlas(new_card.atlas or "Joker"), new_card.soul_pos)
        card.children.floating_sprite.role.draw_major = card
        card.children.floating_sprite.states.hover.can = false
        card.children.floating_sprite.states.click.can = false
    elseif card.children.floating_sprite then
        card.children.floating_sprite:remove()
        card.children.floating_sprite = nil
    end

    if not card.edition then
        card:juice_up()
        play_sound('generic1')
    else
        card:juice_up(1, 0.5)
        if card.edition.foil then play_sound('foil1', 1.2, 0.4) end
        if card.edition.holo then play_sound('holo1', 1.2*1.58, 0.4) end
        if card.edition.polychrome then play_sound('polychrome1', 1.2, 0.7) end
        if card.edition.negative then play_sound('negative', 1.5, 0.4) end
        if card.edition.poke_shiny then
        play_sound('poke_e_shiny', 1, 0.2)
        G.P_CENTERS.e_poke_shiny.on_load(card)
        end
    end
    
    if trigger_add then
        card:add_to_deck()
    end
    
    if energize_amount then
        energy_increase(card, 'Trans', energize_amount)
    end
end
