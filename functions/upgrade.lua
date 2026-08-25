get_tower_upgrade = function(card)
    
end

tower_upgrade = function(card, to_key, immediate)
    if immediate then
        tower_backend_upgrade(card, to_key)
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
                tower_backend_upgrade(card, to_key)
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

tower_backend_upgrade = function(card, to_key)
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

end

JokerTable = {
    ace = {
        ['monkey_ace'] = { path = 0, tier = 0 },
        ['rapid_fire'] = { path = 1, tier = 1 },
        ['lots_more_darts'] = { path = 1, tier = 2 },
        ['fighter_plane'] = { path = 1, tier = 3 },
        ['operation_dart_storm'] = { path = 1, tier = 4 },
        ['sky_shredder'] = { path = 1, tier = 5 },
        ['exploding_pineapple'] = { path = 2, tier = 1 },
        ['spy_plane'] = { path = 2, tier = 2 },
        ['bomber_ace'] = { path = 2, tier = 3 },
        ['ground_zero'] = { path = 2, tier = 4 },
        ['tsar_bomba'] = { path = 2, tier = 5 },
        ['sharper_darts'] = { path = 3, tier = 1 },
        ['centered_path'] = { path = 3, tier = 2 },
        ['neva_miss_targeting'] = { path = 3, tier = 3 },
        ['spectre'] = { path = 3, tier = 4 },
        ['flying_fortress'] = { path = 3, tier = 5 },
        ['goliath_doomship'] = { path = 0, tier = 6 },
    },
    alch = {
        ['alchemist'] = { path = 0, tier = 0 },
        ['larger_potions'] = { path = 1, tier = 1 },
        ['acidic_mixture_dip'] = { path = 1, tier = 2 },
        ['berserker_brew'] = { path = 1, tier = 3 },
        ['stronger_stimulant'] = { path = 1, tier = 4 },
        ['permanent_brew'] = { path = 1, tier = 5 },
        ['stronger_acid'] = { path = 2, tier = 1 },
        ['perishing_potions'] = { path = 2, tier = 2 },
        ['unstable_concoction'] = { path = 2, tier = 3 },
        ['transforming_tonic'] = { path = 2, tier = 4 },
        ['total_transformation'] = { path = 2, tier = 5 },
        ['faster_throwing_alchemist'] = { path = 3, tier = 1 },
        ['acid_pools'] = { path = 3, tier = 2 },
        ['lead_to_gold'] = { path = 3, tier = 3 },
        ['rubber_to_gold'] = { path = 3, tier = 4 },
        ['bloon_master_alchemist'] = { path = 3, tier = 5 },
    },
    beast = {
        ['beast_handler'] = { path = 0, tier = 0 },
        ['piranha'] = { path = 1, tier = 1 },
        ['barracuda'] = { path = 1, tier = 2 },
        ['great_white'] = { path = 1, tier = 3 },
        ['orca'] = { path = 1, tier = 4 },
        ['megalodon'] = { path = 1, tier = 5 },
        ['microraptor'] = { path = 2, tier = 1 },
        ['adasaurus'] = { path = 2, tier = 2 },
        ['velociraptor'] = { path = 2, tier = 3 },
        ['tyrannosaurus_rex'] = { path = 2, tier = 4 },
        ['giganotosaurus'] = { path = 2, tier = 5 },
        ['gyrfalcon'] = { path = 3, tier = 1 },
        ['horned_owl'] = { path = 3, tier = 2 },
        ['golden_eagle'] = { path = 3, tier = 3 },
        ['giant_condor'] = { path = 3, tier = 4 },
        ['pouakai'] = { path = 3, tier = 5 },
    },
    boat = {
        ['monkey_buccaneer'] = { path = 0, tier = 0 },
        ['faster_shooting_buccaneer'] = { path = 1, tier = 1 },
        ['double_shot_buccaneer'] = { path = 1, tier = 2 },
        ['destroyer'] = { path = 1, tier = 3 },
        ['aircraft_carrier'] = { path = 1, tier = 4 },
        ['carrier_flagship'] = { path = 1, tier = 5 },
        ['grape_shot'] = { path = 2, tier = 1 },
        ['hot_shot'] = { path = 2, tier = 2 },
        ['cannon_ship'] = { path = 2, tier = 3 },
        ['monkey_pirates'] = { path = 2, tier = 4 },
        ['pirate_lord'] = { path = 2, tier = 5 },
        ['long_range'] = { path = 3, tier = 1 },
        ['crows_nest'] = { path = 3, tier = 2 },
        ['merchantman'] = { path = 3, tier = 3 },
        ['favored_trades'] = { path = 3, tier = 4 },
        ['trade_empire'] = { path = 3, tier = 5 },
        ['navarch_of_the_seas'] = { path = 0, tier = 6 },
    },
    bomb = {
        ['bomb_shooter'] = { path = 0, tier = 0 },
        ['bigger_bombs'] = { path = 1, tier = 1 },
        ['heavy_bombs'] = { path = 1, tier = 2 },
        ['really_big_bombs'] = { path = 1, tier = 3 },
        ['bloon_impact'] = { path = 1, tier = 4 },
        ['bloon_crush'] = { path = 1, tier = 5 },
        ['faster_reload_bomb'] = { path = 2, tier = 1 },
        ['missile_launcher'] = { path = 2, tier = 2 },
        ['moab_mauler'] = { path = 2, tier = 3 },
        ['moab_assassin'] = { path = 2, tier = 4 },
        ['moab_eliminator'] = { path = 2, tier = 5 },
        ['extra_range'] = { path = 3, tier = 1 },
        ['frag_bombs'] = { path = 3, tier = 2 },
        ['cluster_bombs'] = { path = 3, tier = 3 },
        ['recursive_cluster'] = { path = 3, tier = 4 },
        ['bomb_blitz'] = { path = 3, tier = 5 },
        ['ballistic_obliteration_missile_bunker'] = { path = 0, tier = 6 },
    },
    boomer = {
        ['boomerang_monkey'] = { path = 0, tier = 0 },
        ['improved_rangs'] = { path = 1, tier = 1 },
        ['glaives'] = { path = 1, tier = 2 },
        ['glaive_ricochet'] = { path = 1, tier = 3 },
        ['moar_glaives'] = { path = 1, tier = 4 },
        ['glaive_lord'] = { path = 1, tier = 5 },
        ['faster_throwing_boomerang'] = { path = 2, tier = 1 },
        ['faster_rangs'] = { path = 2, tier = 2 },
        ['bionic_boomerang'] = { path = 2, tier = 3 },
        ['turbo_charge'] = { path = 2, tier = 4 },
        ['perma_charge'] = { path = 2, tier = 5 },
        ['long_range_rangs'] = { path = 3, tier = 1 },
        ['red_hot_rangs'] = { path = 3, tier = 2 },
        ['kylie_boomerang'] = { path = 3, tier = 3 },
        ['moab_press'] = { path = 3, tier = 4 },
        ['moab_domination'] = { path = 3, tier = 5 },
        ['glaive_dominus'] = { path = 0, tier = 6 },
    },
    dart = {
        ['dart_monkey'] = { path = 0, tier = 0 },
        ['sharp_shots'] = { path = 1, tier = 1 },
        ['razor_sharp_shots'] = { path = 1, tier = 2 },
        ['spike_o_pult'] = { path = 1, tier = 3 },
        ['juggernaut'] = { path = 1, tier = 4 },
        ['ultra_juggernaut'] = { path = 1, tier = 5 },
        ['quick_shots'] = { path = 2, tier = 1 },
        ['very_quick_shots'] = { path = 2, tier = 2 },
        ['triple_shot'] = { path = 2, tier = 3 },
        ['super_monkey_fan_club'] = { path = 2, tier = 4 },
        ['plasma_monkey_fan_club'] = { path = 2, tier = 5 },
        ['long_range_darts'] = { path = 3, tier = 1 },
        ['enhanced_eyesight'] = { path = 3, tier = 2 },
        ['crossbow'] = { path = 3, tier = 3 },
        ['sharp_shooter'] = { path = 3, tier = 4 },
        ['crossbow_master'] = { path = 3, tier = 5 },
        ['apex_plasma_master'] = { path = 0, tier = 6 },
    },
    dartling = {
        ['dartling_gunner'] = { path = 0, tier = 0 },
        ['focused_firing'] = { path = 1, tier = 1 },
        ['laser_shock'] = { path = 1, tier = 2 },
        ['laser_cannon'] = { path = 1, tier = 3 },
        ['plasma_accelerator'] = { path = 1, tier = 4 },
        ['ray_of_doom'] = { path = 1, tier = 5 },
        ['advanced_targeting'] = { path = 2, tier = 1 },
        ['faster_barrel_spin'] = { path = 2, tier = 2 },
        ['hydra_rocket_pods'] = { path = 2, tier = 3 },
        ['rocket_storm'] = { path = 2, tier = 4 },
        ['mad'] = { path = 2, tier = 5 },
        ['faster_swivel'] = { path = 3, tier = 1 },
        ['powerful_darts'] = { path = 3, tier = 2 },
        ['buckshot'] = { path = 3, tier = 3 },
        ['bloon_area_denial_system'] = { path = 3, tier = 4 },
        ['bloon_exclusion_zone'] = { path = 3, tier = 5 },
    },
    desp = {
        ['desperado'] = { path = 0, tier = 0 },
        ['quickdraw'] = { path = 1, tier = 1 },
        ['standoff'] = { path = 1, tier = 2 },
        ['big_iron'] = { path = 1, tier = 3 },
        ['twin_sixes'] = { path = 1, tier = 4 },
        ['the_blazing_sun'] = { path = 1, tier = 5 },
        ['eagle_eye'] = { path = 2, tier = 1 },
        ['bullseye'] = { path = 2, tier = 2 },
        ['deadeye'] = { path = 2, tier = 3 },
        ['bounty_hunter'] = { path = 2, tier = 4 },
        ['golden_justice'] = { path = 2, tier = 5 },
        ['wanderer'] = { path = 3, tier = 1 },
        ['nomad'] = { path = 3, tier = 2 },
        ['enforcer'] = { path = 3, tier = 3 },
        ['avenger'] = { path = 3, tier = 4 },
        ['the_desert_phantom'] = { path = 3, tier = 5 },
    },
    druid = {
        ['druid'] = { path = 0, tier = 0 },
        ['hard_thorns'] = { path = 1, tier = 1 },
        ['heart_of_thunder'] = { path = 1, tier = 2 },
        ['druid_of_the_storm'] = { path = 1, tier = 3 },
        ['ball_lightning'] = { path = 1, tier = 4 },
        ['monarch_of_storms'] = { path = 1, tier = 5 },
        ['thorn_swarm'] = { path = 2, tier = 1 },
        ['heart_of_oak'] = { path = 2, tier = 2 },
        ['druid_of_the_jungle'] = { path = 2, tier = 3 },
        ['jungles_bounty'] = { path = 2, tier = 4 },
        ['spirit_of_the_forest'] = { path = 2, tier = 5 },
        ['druidic_reach'] = { path = 3, tier = 1 },
        ['heart_of_vengeance'] = { path = 3, tier = 2 },
        ['druid_of_wrath'] = { path = 3, tier = 3 },
        ['poplust'] = { path = 3, tier = 4 },
        ['avatar_of_wrath'] = { path = 3, tier = 5 },
        ['root_of_all_nature'] = { path = 0, tier = 6 },
    },
    engi = {
        ['engineer_monkey'] = { path = 0, tier = 0 },
        ['sentry_gun'] = { path = 1, tier = 1 },
        ['faster_engineering'] = { path = 1, tier = 2 },
        ['sprockets'] = { path = 1, tier = 3 },
        ['sentry_expert'] = { path = 1, tier = 4 },
        ['sentry_champion'] = { path = 1, tier = 5 },
        ['larger_service_area'] = { path = 2, tier = 1 },
        ['deconstruction'] = { path = 2, tier = 2 },
        ['cleansing_foam'] = { path = 2, tier = 3 },
        ['overclock'] = { path = 2, tier = 4 },
        ['ultraboost'] = { path = 2, tier = 5 },
        ['oversize_nails'] = { path = 3, tier = 1 },
        ['pin'] = { path = 3, tier = 2 },
        ['double_gun'] = { path = 3, tier = 3 },
        ['bloon_trap'] = { path = 3, tier = 4 },
        ['xxxl_trap'] = { path = 3, tier = 5 },
        ['master_builder'] = { path = 0, tier = 6 },
    },
    farm = {
        ['banana_farm'] = { path = 0, tier = 0 },
        ['increased_production'] = { path = 1, tier = 1 },
        ['greater_production'] = { path = 1, tier = 2 },
        ['banana_plantation'] = { path = 1, tier = 3 },
        ['banana_research_facility'] = { path = 1, tier = 4 },
        ['banana_central'] = { path = 1, tier = 5 },
        ['long_life_bananas'] = { path = 2, tier = 1 },
        ['valuable_bananas'] = { path = 2, tier = 2 },
        ['monkey_bank'] = { path = 2, tier = 3 },
        ['imf_loan'] = { path = 2, tier = 4 },
        ['monkey_nomics'] = { path = 2, tier = 5 },
        ['ez_collect'] = { path = 3, tier = 1 },
        ['banana_salvage'] = { path = 3, tier = 2 },
        ['marketplace'] = { path = 3, tier = 3 },
        ['central_market'] = { path = 3, tier = 4 },
        ['monkey_wall_street'] = { path = 3, tier = 5 },
    },
    glue = {
        ['glue_gunner'] = { path = 0, tier = 0 },
        ['glue_soak'] = { path = 1, tier = 1 },
        ['corrosive_glue'] = { path = 1, tier = 2 },
        ['bloon_dissolver'] = { path = 1, tier = 3 },
        ['bloon_liquefier'] = { path = 1, tier = 4 },
        ['the_bloon_solver'] = { path = 1, tier = 5 },
        ['bigger_globs'] = { path = 2, tier = 1 },
        ['glue_splatter'] = { path = 2, tier = 2 },
        ['glue_hose'] = { path = 2, tier = 3 },
        ['glue_strike'] = { path = 2, tier = 4 },
        ['glue_storm'] = { path = 2, tier = 5 },
        ['stickier_glue'] = { path = 3, tier = 1 },
        ['stronger_glue'] = { path = 3, tier = 2 },
        ['moab_glue'] = { path = 3, tier = 3 },
        ['relentless_glue'] = { path = 3, tier = 4 },
        ['super_glue'] = { path = 3, tier = 5 },
    },
    heli = {
        ['heli_pilot'] = { path = 0, tier = 0 },
        ['quad_darts'] = { path = 1, tier = 1 },
        ['pursuit'] = { path = 1, tier = 2 },
        ['razor_rotors'] = { path = 1, tier = 3 },
        ['apache_dartship'] = { path = 1, tier = 4 },
        ['apache_prime'] = { path = 1, tier = 5 },
        ['bigger_jets'] = { path = 2, tier = 1 },
        ['ifr'] = { path = 2, tier = 2 },
        ['downdraft'] = { path = 2, tier = 3 },
        ['support_chinook'] = { path = 2, tier = 4 },
        ['special_poperations'] = { path = 2, tier = 5 },
        ['faster_darts'] = { path = 3, tier = 1 },
        ['faster_firing'] = { path = 3, tier = 2 },
        ['moab_shove'] = { path = 3, tier = 3 },
        ['comanche_defense'] = { path = 3, tier = 4 },
        ['comanche_commander'] = { path = 3, tier = 5 },
    },
    ice = {
        ['ice_monkey'] = { path = 0, tier = 0 },
        ['permafrost'] = { path = 1, tier = 1 },
        ['cold_snap'] = { path = 1, tier = 2 },
        ['ice_shards'] = { path = 1, tier = 3 },
        ['embrittlement'] = { path = 1, tier = 4 },
        ['super_brittle'] = { path = 1, tier = 5 },
        ['enhanced_freeze'] = { path = 2, tier = 1 },
        ['deep_freeze'] = { path = 2, tier = 2 },
        ['arctic_wind'] = { path = 2, tier = 3 },
        ['snowstorm'] = { path = 2, tier = 4 },
        ['absolute_zero'] = { path = 2, tier = 5 },
        ['larger_radius'] = { path = 3, tier = 1 },
        ['re_freeze'] = { path = 3, tier = 2 },
        ['cryo_cannon'] = { path = 3, tier = 3 },
        ['icicles'] = { path = 3, tier = 4 },
        ['icicle_impale'] = { path = 3, tier = 5 },
        ['herald_of_everfrost'] = { path = 0, tier = 6 },
    },
    merm = {
        ['mermonkey'] = { path = 0, tier = 0 },
        ['trident_efficiency'] = { path = 1, tier = 1 },
        ['trident_swiftness'] = { path = 1, tier = 2 },
        ['abyss_dweller'] = { path = 1, tier = 3 },
        ['abyssal_warrior'] = { path = 1, tier = 4 },
        ['lord_of_the_abyss'] = { path = 1, tier = 5 },
        ['sharper_prongs'] = { path = 2, tier = 1 },
        ['tidal_chill'] = { path = 2, tier = 2 },
        ['riptide_champion'] = { path = 2, tier = 3 },
        ['arctic_knight'] = { path = 2, tier = 4 },
        ['popseidon'] = { path = 2, tier = 5 },
        ['echosense_precision'] = { path = 3, tier = 1 },
        ['echosense_network'] = { path = 3, tier = 2 },
        ['alluring_melody'] = { path = 3, tier = 3 },
        ['symphonic_resonance'] = { path = 3, tier = 4 },
        ['the_final_harmonic'] = { path = 3, tier = 5 },
    },
    mortar = {
        ['mortar_monkey'] = { path = 0, tier = 0 },
        ['bigger_blast'] = { path = 1, tier = 1 },
        ['bloon_buster'] = { path = 1, tier = 2 },
        ['shell_shock'] = { path = 1, tier = 3 },
        ['the_big_one'] = { path = 1, tier = 4 },
        ['the_biggest_one'] = { path = 1, tier = 5 },
        ['faster_reload'] = { path = 2, tier = 1 },
        ['rapid_reload'] = { path = 2, tier = 2 },
        ['heavy_shells'] = { path = 2, tier = 3 },
        ['artillery_battery'] = { path = 2, tier = 4 },
        ['pop_and_awe'] = { path = 2, tier = 5 },
        ['increased_accuracy'] = { path = 3, tier = 1 },
        ['burny_stuff'] = { path = 3, tier = 2 },
        ['signal_flare'] = { path = 3, tier = 3 },
        ['shattering_shells'] = { path = 3, tier = 4 },
        ['blooncineration'] = { path = 3, tier = 5 },
    },
    ninja = {
        ['ninja_monkey'] = { path = 0, tier = 0 },
        ['ninja_discipline'] = { path = 1, tier = 1 },
        ['sharp_shurikens'] = { path = 1, tier = 2 },
        ['double_shot_ninja'] = { path = 1, tier = 3 },
        ['bloonjitsu'] = { path = 1, tier = 4 },
        ['grandmaster_ninja'] = { path = 1, tier = 5 },
        ['distraction'] = { path = 2, tier = 1 },
        ['counter_espionage'] = { path = 2, tier = 2 },
        ['shinobi_tactics'] = { path = 2, tier = 3 },
        ['bloon_sabotage'] = { path = 2, tier = 4 },
        ['grand_saboteur'] = { path = 2, tier = 5 },
        ['seeking_shuriken'] = { path = 3, tier = 1 },
        ['caltrops'] = { path = 3, tier = 2 },
        ['flash_bomb'] = { path = 3, tier = 3 },
        ['sticky_bomb'] = { path = 3, tier = 4 },
        ['master_bomber'] = { path = 3, tier = 5 },
        ['ascended_shadow'] = { path = 0, tier = 6 },
    },
    sniper = {
        ['sniper_monkey'] = { path = 0, tier = 0 },
        ['full_metal_jacket'] = { path = 1, tier = 1 },
        ['large_calibre'] = { path = 1, tier = 2 },
        ['deadly_precision'] = { path = 1, tier = 3 },
        ['maim_moab'] = { path = 1, tier = 4 },
        ['cripple_moab'] = { path = 1, tier = 5 },
        ['night_vision_goggles'] = { path = 2, tier = 1 },
        ['shrapnel_shot'] = { path = 2, tier = 2 },
        ['bouncing_bullet'] = { path = 2, tier = 3 },
        ['supply_drop'] = { path = 2, tier = 4 },
        ['elite_sniper'] = { path = 2, tier = 5 },
        ['fast_firing_sniper'] = { path = 3, tier = 1 },
        ['even_faster_firing'] = { path = 3, tier = 2 },
        ['semi_automatic'] = { path = 3, tier = 3 },
        ['full_auto_rifle'] = { path = 3, tier = 4 },
        ['elite_defender'] = { path = 3, tier = 5 },
    },
    spac = {
        ['spike_factory'] = { path = 0, tier = 0 },
        ['bigger_stacks'] = { path = 1, tier = 1 },
        ['white_hot_spikes'] = { path = 1, tier = 2 },
        ['spiked_balls'] = { path = 1, tier = 3 },
        ['spiked_mines'] = { path = 1, tier = 4 },
        ['super_mines'] = { path = 1, tier = 5 },
        ['faster_production'] = { path = 2, tier = 1 },
        ['even_faster_production'] = { path = 2, tier = 2 },
        ['moab_shredr'] = { path = 2, tier = 3 },
        ['spike_storm'] = { path = 2, tier = 4 },
        ['carpet_of_spikes'] = { path = 2, tier = 5 },
        ['long_reach'] = { path = 3, tier = 1 },
        ['smart_spikes'] = { path = 3, tier = 2 },
        ['long_life_spikes'] = { path = 3, tier = 3 },
        ['deadly_spikes'] = { path = 3, tier = 4 },
        ['perma_spike'] = { path = 3, tier = 5 },
        ['mega_massive_munitions_factory'] = { path = 0, tier = 6 },
    },
    sub = {
        ['monkey_sub'] = { path = 0, tier = 0 },
        ['longer_range'] = { path = 1, tier = 1 },
        ['advanced_intel'] = { path = 1, tier = 2 },
        ['submerge_and_support'] = { path = 1, tier = 3 },
        ['bloontonium_reactor'] = { path = 1, tier = 4 },
        ['energizer'] = { path = 1, tier = 5 },
        ['barbed_darts'] = { path = 2, tier = 1 },
        ['heat_tipped_darts'] = { path = 2, tier = 2 },
        ['ballistic_missile'] = { path = 2, tier = 3 },
        ['first_strike_capability'] = { path = 2, tier = 4 },
        ['pre_emptive_strike'] = { path = 2, tier = 5 },
        ['twin_guns'] = { path = 3, tier = 1 },
        ['airburst_darts'] = { path = 3, tier = 2 },
        ['triple_guns'] = { path = 3, tier = 3 },
        ['armor_piercing_darts'] = { path = 3, tier = 4 },
        ['sub_commander'] = { path = 3, tier = 5 },
        ['nautic_siege_core'] = { path = 0, tier = 6 },
    },
    super = {
        ['super_monkey'] = { path = 0, tier = 0 },
        ['laser_blasts'] = { path = 1, tier = 1 },
        ['plasma_blasts'] = { path = 1, tier = 2 },
        ['sun_avatar'] = { path = 1, tier = 3 },
        ['sun_temple'] = { path = 1, tier = 4 },
        ['true_sun_god'] = { path = 1, tier = 5 },
        ['super_range'] = { path = 2, tier = 1 },
        ['epic_range'] = { path = 2, tier = 2 },
        ['robo_monkey'] = { path = 2, tier = 3 },
        ['tech_terror'] = { path = 2, tier = 4 },
        ['the_anti_bloon'] = { path = 2, tier = 5 },
        ['knockback'] = { path = 3, tier = 1 },
        ['ultravision'] = { path = 3, tier = 2 },
        ['dark_knight'] = { path = 3, tier = 3 },
        ['dark_champion'] = { path = 3, tier = 4 },
        ['legend_of_the_night'] = { path = 3, tier = 5 },
        ['vengeful_true_sun_god'] = { path = 0, tier = 5 },
    },
    tack = {
        ['tack_shooter'] = { path = 0, tier = 0 },
        ['faster_shooting_tack'] = { path = 1, tier = 1 },
        ['even_faster_shooting'] = { path = 1, tier = 2 },
        ['hot_shots'] = { path = 1, tier = 3 },
        ['ring_of_fire'] = { path = 1, tier = 4 },
        ['inferno_ring'] = { path = 1, tier = 5 },
        ['long_range_tacks'] = { path = 2, tier = 1 },
        ['super_range_tacks'] = { path = 2, tier = 2 },
        ['blade_shooter'] = { path = 2, tier = 3 },
        ['blade_maelstrom'] = { path = 2, tier = 4 },
        ['super_maelstrom'] = { path = 2, tier = 5 },
        ['more_tacks'] = { path = 3, tier = 1 },
        ['even_more_tacks'] = { path = 3, tier = 2 },
        ['tack_sprayer'] = { path = 3, tier = 3 },
        ['overdrive'] = { path = 3, tier = 4 },
        ['the_tack_zone'] = { path = 3, tier = 5 },
        ['crucible_of_steel_and_flame'] = { path = 0, tier = 6 },
    },
    village = {
        ['monkey_village'] = { path = 0, tier = 0 },
        ['bigger_radius'] = { path = 1, tier = 1 },
        ['jungle_drums'] = { path = 1, tier = 2 },
        ['primary_training'] = { path = 1, tier = 3 },
        ['primary_mentoring'] = { path = 1, tier = 4 },
        ['primary_expertise'] = { path = 1, tier = 5 },
        ['grow_blocker'] = { path = 2, tier = 1 },
        ['radar_scanner'] = { path = 2, tier = 2 },
        ['monkey_intelligence_bureau'] = { path = 2, tier = 3 },
        ['call_to_arms'] = { path = 2, tier = 4 },
        ['homeland_defense'] = { path = 2, tier = 5 },
        ['monkey_business'] = { path = 3, tier = 1 },
        ['monkey_commerce'] = { path = 3, tier = 2 },
        ['monkey_town'] = { path = 3, tier = 3 },
        ['monkey_city'] = { path = 3, tier = 4 },
        ['monkeyopolis'] = { path = 3, tier = 5 },
    },
    warden = {
        ['skywarden'] = { path = 0, tier = 0 },
        ['aerial_attunement'] = { path = 1, tier = 1 },
        ['zephyr_sense'] = { path = 1, tier = 2 },
        ['wind_weaver'] = { path = 1, tier = 3 },
        ['galesage'] = { path = 1, tier = 4 },
        ['farwind_seer'] = { path = 1, tier = 5 },
        ['storms_pulse'] = { path = 2, tier = 1 },
        ['thundering_arc'] = { path = 2, tier = 2 },
        ['galvanic_conduit'] = { path = 2, tier = 3 },
        ['thunders_decree'] = { path = 2, tier = 4 },
        ['stormwrath_archon'] = { path = 2, tier = 5 },
        ['shatterpoint'] = { path = 3, tier = 1 },
        ['icebore'] = { path = 3, tier = 2 },
        ['coldchain'] = { path = 3, tier = 3 },
        ['frozen_verdict'] = { path = 3, tier = 4 },
        ['winters_mercy'] = { path = 3, tier = 5 },
    },
    wizard = {
        ['wizard_monkey'] = { path = 0, tier = 0 },
        ['guided_magic'] = { path = 1, tier = 1 },
        ['arcane_blast'] = { path = 1, tier = 2 },
        ['arcane_mastery'] = { path = 1, tier = 3 },
        ['arcane_spike'] = { path = 1, tier = 4 },
        ['archmage'] = { path = 1, tier = 5 },
        ['fireball'] = { path = 2, tier = 1 },
        ['wall_of_fire'] = { path = 2, tier = 2 },
        ['dragons_breath'] = { path = 2, tier = 3 },
        ['summon_phoenix'] = { path = 2, tier = 4 },
        ['wizard_lord_phoenix'] = { path = 2, tier = 5 },
        ['intense_magic'] = { path = 3, tier = 1 },
        ['monkey_sense'] = { path = 3, tier = 2 },
        ['shimmer'] = { path = 3, tier = 3 },
        ['necromancer'] = { path = 3, tier = 4 },
        ['prince_of_darkness'] = { path = 3, tier = 5 },
        ['magus_perfectus'] = { path = 0, tier = 6 },
    },
}

JokerTableInverted = {
    ace = {
        [0] = {
            [0] = 'monkey_ace',
            [6] = 'goliath_doomship',
        },
        [1] = {
            [1] = 'rapid_fire',
            [2] = 'lots_more_darts',
            [3] = 'fighter_plane',
            [4] = 'operation_dart_storm',
            [5] = 'sky_shredder',
        },
        [2] = {
            [1] = 'exploding_pineapple',
            [2] = 'spy_plane',
            [3] = 'bomber_ace',
            [4] = 'ground_zero',
            [5] = 'tsar_bomba',
        },
        [3] = {
            [1] = 'sharper_darts',
            [2] = 'centered_path',
            [3] = 'neva_miss_targeting',
            [4] = 'spectre',
            [5] = 'flying_fortress',
        },
    },
    alch = {
        [0] = {
            [0] = 'alchemist',
        },
        [1] = {
            [1] = 'larger_potions',
            [2] = 'acidic_mixture_dip',
            [3] = 'berserker_brew',
            [4] = 'stronger_stimulant',
            [5] = 'permanent_brew',
        },
        [2] = {
            [1] = 'stronger_acid',
            [2] = 'perishing_potions',
            [3] = 'unstable_concoction',
            [4] = 'transforming_tonic',
            [5] = 'total_transformation',
        },
        [3] = {
            [1] = 'faster_throwing_alchemist',
            [2] = 'acid_pools',
            [3] = 'lead_to_gold',
            [4] = 'rubber_to_gold',
            [5] = 'bloon_master_alchemist',
        },
    },
    beast = {
        [0] = {
            [0] = 'beast_handler',
        },
        [1] = {
            [1] = 'piranha',
            [2] = 'barracuda',
            [3] = 'great_white',
            [4] = 'orca',
            [5] = 'megalodon',
        },
        [2] = {
            [1] = 'microraptor',
            [2] = 'adasaurus',
            [3] = 'velociraptor',
            [4] = 'tyrannosaurus_rex',
            [5] = 'giganotosaurus',
        },
        [3] = {
            [1] = 'gyrfalcon',
            [2] = 'horned_owl',
            [3] = 'golden_eagle',
            [4] = 'giant_condor',
            [5] = 'pouakai',
        },
    },
    boat = {
        [0] = {
            [0] = 'monkey_buccaneer',
            [6] = 'navarch_of_the_seas',
        },
        [1] = {
            [1] = 'faster_shooting_buccaneer',
            [2] = 'double_shot_buccaneer',
            [3] = 'destroyer',
            [4] = 'aircraft_carrier',
            [5] = 'carrier_flagship',
        },
        [2] = {
            [1] = 'grape_shot',
            [2] = 'hot_shot',
            [3] = 'cannon_ship',
            [4] = 'monkey_pirates',
            [5] = 'pirate_lord',
        },
        [3] = {
            [1] = 'long_range',
            [2] = 'crows_nest',
            [3] = 'merchantman',
            [4] = 'favored_trades',
            [5] = 'trade_empire',
        },
    },
    bomb = {
        [0] = {
            [0] = 'bomb_shooter',
            [6] = 'ballistic_obliteration_missile_bunker',
        },
        [1] = {
            [1] = 'bigger_bombs',
            [2] = 'heavy_bombs',
            [3] = 'really_big_bombs',
            [4] = 'bloon_impact',
            [5] = 'bloon_crush',
        },
        [2] = {
            [1] = 'faster_reload_bomb',
            [2] = 'missile_launcher',
            [3] = 'moab_mauler',
            [4] = 'moab_assassin',
            [5] = 'moab_eliminator',
        },
        [3] = {
            [1] = 'extra_range',
            [2] = 'frag_bombs',
            [3] = 'cluster_bombs',
            [4] = 'recursive_cluster',
            [5] = 'bomb_blitz',
        },
    },
    boomer = {
        [0] = {
            [0] = 'boomerang_monkey',
            [6] = 'glaive_dominus',
        },
        [1] = {
            [1] = 'improved_rangs',
            [2] = 'glaives',
            [3] = 'glaive_ricochet',
            [4] = 'moar_glaives',
            [5] = 'glaive_lord',
        },
        [2] = {
            [1] = 'faster_throwing_boomerang',
            [2] = 'faster_rangs',
            [3] = 'bionic_boomerang',
            [4] = 'turbo_charge',
            [5] = 'perma_charge',
        },
        [3] = {
            [1] = 'long_range_rangs',
            [2] = 'red_hot_rangs',
            [3] = 'kylie_boomerang',
            [4] = 'moab_press',
            [5] = 'moab_domination',
        },
    },
    dart = {
        [0] = {
            [0] = 'dart_monkey',
            [6] = 'apex_plasma_master',
        },
        [1] = {
            [1] = 'sharp_shots',
            [2] = 'razor_sharp_shots',
            [3] = 'spike_o_pult',
            [4] = 'juggernaut',
            [5] = 'ultra_juggernaut',
        },
        [2] = {
            [1] = 'quick_shots',
            [2] = 'very_quick_shots',
            [3] = 'triple_shot',
            [4] = 'super_monkey_fan_club',
            [5] = 'plasma_monkey_fan_club',
        },
        [3] = {
            [1] = 'long_range_darts',
            [2] = 'enhanced_eyesight',
            [3] = 'crossbow',
            [4] = 'sharp_shooter',
            [5] = 'crossbow_master',
        },
    },
    dartling = {
        [0] = {
            [0] = 'dartling_gunner',
        },
        [1] = {
            [1] = 'focused_firing',
            [2] = 'laser_shock',
            [3] = 'laser_cannon',
            [4] = 'plasma_accelerator',
            [5] = 'ray_of_doom',
        },
        [2] = {
            [1] = 'advanced_targeting',
            [2] = 'faster_barrel_spin',
            [3] = 'hydra_rocket_pods',
            [4] = 'rocket_storm',
            [5] = 'mad',
        },
        [3] = {
            [1] = 'faster_swivel',
            [2] = 'powerful_darts',
            [3] = 'buckshot',
            [4] = 'bloon_area_denial_system',
            [5] = 'bloon_exclusion_zone',
        },
    },
    desp = {
        [0] = {
            [0] = 'desperado',
        },
        [1] = {
            [1] = 'quickdraw',
            [2] = 'standoff',
            [3] = 'big_iron',
            [4] = 'twin_sixes',
            [5] = 'the_blazing_sun',
        },
        [2] = {
            [1] = 'eagle_eye',
            [2] = 'bullseye',
            [3] = 'deadeye',
            [4] = 'bounty_hunter',
            [5] = 'golden_justice',
        },
        [3] = {
            [1] = 'wanderer',
            [2] = 'nomad',
            [3] = 'enforcer',
            [4] = 'avenger',
            [5] = 'the_desert_phantom',
        },
    },
    druid = {
        [0] = {
            [0] = 'druid',
            [6] = 'root_of_all_nature',
        },
        [1] = {
            [1] = 'hard_thorns',
            [2] = 'heart_of_thunder',
            [3] = 'druid_of_the_storm',
            [4] = 'ball_lightning',
            [5] = 'monarch_of_storms',
        },
        [2] = {
            [1] = 'thorn_swarm',
            [2] = 'heart_of_oak',
            [3] = 'druid_of_the_jungle',
            [4] = 'jungles_bounty',
            [5] = 'spirit_of_the_forest',
        },
        [3] = {
            [1] = 'druidic_reach',
            [2] = 'heart_of_vengeance',
            [3] = 'druid_of_wrath',
            [4] = 'poplust',
            [5] = 'avatar_of_wrath',
        },
    },
    engi = {
        [0] = {
            [0] = 'engineer_monkey',
            [6] = 'master_builder',
        },
        [1] = {
            [1] = 'sentry_gun',
            [2] = 'faster_engineering',
            [3] = 'sprockets',
            [4] = 'sentry_expert',
            [5] = 'sentry_champion',
        },
        [2] = {
            [1] = 'larger_service_area',
            [2] = 'deconstruction',
            [3] = 'cleansing_foam',
            [4] = 'overclock',
            [5] = 'ultraboost',
        },
        [3] = {
            [1] = 'oversize_nails',
            [2] = 'pin',
            [3] = 'double_gun',
            [4] = 'bloon_trap',
            [5] = 'xxxl_trap',
        },
    },
    farm = {
        [0] = {
            [0] = 'banana_farm',
        },
        [1] = {
            [1] = 'increased_production',
            [2] = 'greater_production',
            [3] = 'banana_plantation',
            [4] = 'banana_research_facility',
            [5] = 'banana_central',
        },
        [2] = {
            [1] = 'long_life_bananas',
            [2] = 'valuable_bananas',
            [3] = 'monkey_bank',
            [4] = 'imf_loan',
            [5] = 'monkey_nomics',
        },
        [3] = {
            [1] = 'ez_collect',
            [2] = 'banana_salvage',
            [3] = 'marketplace',
            [4] = 'central_market',
            [5] = 'monkey_wall_street',
        },
    },
    glue = {
        [0] = {
            [0] = 'glue_gunner',
        },
        [1] = {
            [1] = 'glue_soak',
            [2] = 'corrosive_glue',
            [3] = 'bloon_dissolver',
            [4] = 'bloon_liquefier',
            [5] = 'the_bloon_solver',
        },
        [2] = {
            [1] = 'bigger_globs',
            [2] = 'glue_splatter',
            [3] = 'glue_hose',
            [4] = 'glue_strike',
            [5] = 'glue_storm',
        },
        [3] = {
            [1] = 'stickier_glue',
            [2] = 'stronger_glue',
            [3] = 'moab_glue',
            [4] = 'relentless_glue',
            [5] = 'super_glue',
        },
    },
    heli = {
        [0] = {
            [0] = 'heli_pilot',
        },
        [1] = {
            [1] = 'quad_darts',
            [2] = 'pursuit',
            [3] = 'razor_rotors',
            [4] = 'apache_dartship',
            [5] = 'apache_prime',
        },
        [2] = {
            [1] = 'bigger_jets',
            [2] = 'ifr',
            [3] = 'downdraft',
            [4] = 'support_chinook',
            [5] = 'special_poperations',
        },
        [3] = {
            [1] = 'faster_darts',
            [2] = 'faster_firing',
            [3] = 'moab_shove',
            [4] = 'comanche_defense',
            [5] = 'comanche_commander',
        },
    },
    ice = {
        [0] = {
            [0] = 'ice_monkey',
            [6] = 'herald_of_everfrost',
        },
        [1] = {
            [1] = 'permafrost',
            [2] = 'cold_snap',
            [3] = 'ice_shards',
            [4] = 'embrittlement',
            [5] = 'super_brittle',
        },
        [2] = {
            [1] = 'enhanced_freeze',
            [2] = 'deep_freeze',
            [3] = 'arctic_wind',
            [4] = 'snowstorm',
            [5] = 'absolute_zero',
        },
        [3] = {
            [1] = 'larger_radius',
            [2] = 're_freeze',
            [3] = 'cryo_cannon',
            [4] = 'icicles',
            [5] = 'icicle_impale',
        },
    },
    merm = {
        [0] = {
            [0] = 'mermonkey',
        },
        [1] = {
            [1] = 'trident_efficiency',
            [2] = 'trident_swiftness',
            [3] = 'abyss_dweller',
            [4] = 'abyssal_warrior',
            [5] = 'lord_of_the_abyss',
        },
        [2] = {
            [1] = 'sharper_prongs',
            [2] = 'tidal_chill',
            [3] = 'riptide_champion',
            [4] = 'arctic_knight',
            [5] = 'popseidon',
        },
        [3] = {
            [1] = 'echosense_precision',
            [2] = 'echosense_network',
            [3] = 'alluring_melody',
            [4] = 'symphonic_resonance',
            [5] = 'the_final_harmonic',
        },
    },
    mortar = {
        [0] = {
            [0] = 'mortar_monkey',
        },
        [1] = {
            [1] = 'bigger_blast',
            [2] = 'bloon_buster',
            [3] = 'shell_shock',
            [4] = 'the_big_one',
            [5] = 'the_biggest_one',
        },
        [2] = {
            [1] = 'faster_reload',
            [2] = 'rapid_reload',
            [3] = 'heavy_shells',
            [4] = 'artillery_battery',
            [5] = 'pop_and_awe',
        },
        [3] = {
            [1] = 'increased_accuracy',
            [2] = 'burny_stuff',
            [3] = 'signal_flare',
            [4] = 'shattering_shells',
            [5] = 'blooncineration',
        },
    },
    ninja = {
        [0] = {
            [0] = 'ninja_monkey',
            [6] = 'ascended_shadow',
        },
        [1] = {
            [1] = 'ninja_discipline',
            [2] = 'sharp_shurikens',
            [3] = 'double_shot_ninja',
            [4] = 'bloonjitsu',
            [5] = 'grandmaster_ninja',
        },
        [2] = {
            [1] = 'distraction',
            [2] = 'counter_espionage',
            [3] = 'shinobi_tactics',
            [4] = 'bloon_sabotage',
            [5] = 'grand_saboteur',
        },
        [3] = {
            [1] = 'seeking_shuriken',
            [2] = 'caltrops',
            [3] = 'flash_bomb',
            [4] = 'sticky_bomb',
            [5] = 'master_bomber',
        },
    },
    sniper = {
        [0] = {
            [0] = 'sniper_monkey',
        },
        [1] = {
            [1] = 'full_metal_jacket',
            [2] = 'large_calibre',
            [3] = 'deadly_precision',
            [4] = 'maim_moab',
            [5] = 'cripple_moab',
        },
        [2] = {
            [1] = 'night_vision_goggles',
            [2] = 'shrapnel_shot',
            [3] = 'bouncing_bullet',
            [4] = 'supply_drop',
            [5] = 'elite_sniper',
        },
        [3] = {
            [1] = 'fast_firing_sniper',
            [2] = 'even_faster_firing',
            [3] = 'semi_automatic',
            [4] = 'full_auto_rifle',
            [5] = 'elite_defender',
        },
    },
    spac = {
        [0] = {
            [0] = 'spike_factory',
            [6] = 'mega_massive_munitions_factory',
        },
        [1] = {
            [1] = 'bigger_stacks',
            [2] = 'white_hot_spikes',
            [3] = 'spiked_balls',
            [4] = 'spiked_mines',
            [5] = 'super_mines',
        },
        [2] = {
            [1] = 'faster_production',
            [2] = 'even_faster_production',
            [3] = 'moab_shredr',
            [4] = 'spike_storm',
            [5] = 'carpet_of_spikes',
        },
        [3] = {
            [1] = 'long_reach',
            [2] = 'smart_spikes',
            [3] = 'long_life_spikes',
            [4] = 'deadly_spikes',
            [5] = 'perma_spike',
        },
    },
    sub = {
        [0] = {
            [0] = 'monkey_sub',
            [6] = 'nautic_siege_core',
        },
        [1] = {
            [1] = 'longer_range',
            [2] = 'advanced_intel',
            [3] = 'submerge_and_support',
            [4] = 'bloontonium_reactor',
            [5] = 'energizer',
        },
        [2] = {
            [1] = 'barbed_darts',
            [2] = 'heat_tipped_darts',
            [3] = 'ballistic_missile',
            [4] = 'first_strike_capability',
            [5] = 'pre_emptive_strike',
        },
        [3] = {
            [1] = 'twin_guns',
            [2] = 'airburst_darts',
            [3] = 'triple_guns',
            [4] = 'armor_piercing_darts',
            [5] = 'sub_commander',
        },
    },
    super = {
        [0] = {
            [0] = 'super_monkey',
            [5] = 'vengeful_true_sun_god',
        },
        [1] = {
            [1] = 'laser_blasts',
            [2] = 'plasma_blasts',
            [3] = 'sun_avatar',
            [4] = 'sun_temple',
            [5] = 'true_sun_god',
        },
        [2] = {
            [1] = 'super_range',
            [2] = 'epic_range',
            [3] = 'robo_monkey',
            [4] = 'tech_terror',
            [5] = 'the_anti_bloon',
        },
        [3] = {
            [1] = 'knockback',
            [2] = 'ultravision',
            [3] = 'dark_knight',
            [4] = 'dark_champion',
            [5] = 'legend_of_the_night',
        },
    },
    tack = {
        [0] = {
            [0] = 'tack_shooter',
            [6] = 'crucible_of_steel_and_flame',
        },
        [1] = {
            [1] = 'faster_shooting_tack',
            [2] = 'even_faster_shooting',
            [3] = 'hot_shots',
            [4] = 'ring_of_fire',
            [5] = 'inferno_ring',
        },
        [2] = {
            [1] = 'long_range_tacks',
            [2] = 'super_range_tacks',
            [3] = 'blade_shooter',
            [4] = 'blade_maelstrom',
            [5] = 'super_maelstrom',
        },
        [3] = {
            [1] = 'more_tacks',
            [2] = 'even_more_tacks',
            [3] = 'tack_sprayer',
            [4] = 'overdrive',
            [5] = 'the_tack_zone',
        },
    },
    village = {
        [0] = {
            [0] = 'monkey_village',
        },
        [1] = {
            [1] = 'bigger_radius',
            [2] = 'jungle_drums',
            [3] = 'primary_training',
            [4] = 'primary_mentoring',
            [5] = 'primary_expertise',
        },
        [2] = {
            [1] = 'grow_blocker',
            [2] = 'radar_scanner',
            [3] = 'monkey_intelligence_bureau',
            [4] = 'call_to_arms',
            [5] = 'homeland_defense',
        },
        [3] = {
            [1] = 'monkey_business',
            [2] = 'monkey_commerce',
            [3] = 'monkey_town',
            [4] = 'monkey_city',
            [5] = 'monkeyopolis',
        },
    },
    warden = {
        [0] = {
            [0] = 'skywarden',
        },
        [1] = {
            [1] = 'aerial_attunement',
            [2] = 'zephyr_sense',
            [3] = 'wind_weaver',
            [4] = 'galesage',
            [5] = 'farwind_seer',
        },
        [2] = {
            [1] = 'storms_pulse',
            [2] = 'thundering_arc',
            [3] = 'galvanic_conduit',
            [4] = 'thunders_decree',
            [5] = 'stormwrath_archon',
        },
        [3] = {
            [1] = 'shatterpoint',
            [2] = 'icebore',
            [3] = 'coldchain',
            [4] = 'frozen_verdict',
            [5] = 'winters_mercy',
        },
    },
    wizard = {
        [0] = {
            [0] = 'wizard_monkey',
            [6] = 'magus_perfectus',
        },
        [1] = {
            [1] = 'guided_magic',
            [2] = 'arcane_blast',
            [3] = 'arcane_mastery',
            [4] = 'arcane_spike',
            [5] = 'archmage',
        },
        [2] = {
            [1] = 'fireball',
            [2] = 'wall_of_fire',
            [3] = 'dragons_breath',
            [4] = 'summon_phoenix',
            [5] = 'wizard_lord_phoenix',
        },
        [3] = {
            [1] = 'intense_magic',
            [2] = 'monkey_sense',
            [3] = 'shimmer',
            [4] = 'necromancer',
            [5] = 'prince_of_darkness',
        },
    },
}