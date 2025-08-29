--Ninja full slots functions
local check_for_buy_space_old = G.FUNCS.check_for_buy_space
G.FUNCS.check_for_buy_space = function(card)
    if card.ability.set == 'Joker' and card.ability.name == 'Ninja Monkey' then
        return true
    else
        local ret = check_for_buy_space_old(card)
        return ret
    end
end

local can_select_card_old = G.FUNCS.can_select_card
G.FUNCS.can_select_card = function(e)
    if e.config.ref_table.ability.name == 'Ninja Monkey' then 
        e.config.colour = G.C.GREEN
        e.config.button = 'use_card'
    else
        local ret = can_select_card_old(e)
        return ret
    end
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

--Cost changing function
local set_cost_old = Card.set_cost
Card.set_cost = function(self, ...)
    local ret = set_cost_old(self, ...)
    self.sell_cost = self.sell_cost + 2 * #find_joker('Banana Salvage')
    if self.ability.set == 'Booster' and #find_joker('Monkey Wall Street') > 0 then
        self.cost = math.floor(self.cost / 2.0)
    end
    if #find_joker('Monkey Commerce') > 0 then
        if #find_joker('Monkey Commerce') > self.cost then
            self.cost = 0
        else
            self.cost = self.cost - #find_joker('Monkey Commerce')
        end
    end
    local lotas = find_joker('Lord of the Abyss')
    if self.ability.set == 'Booster' and #lotas > 0 then
        for k, v in pairs(lotas) do
            if self.cost - v.ability.extra.number < 0 then
                self.cost = 0
            else
                self.cost = self.cost - v.ability.extra.number
            end
        end
    end
    if self.ability.set == 'Joker' and self.config.center.rarity == 1 and #find_joker('Primary Expertise') > 0 then
        self.cost = 0
    end
    return ret
end

--Energizer reroll function
local calculate_reroll_cost_old = calculate_reroll_cost
calculate_reroll_cost = function(skip_increment)
    local ret = calculate_reroll_cost_old(skip_increment)
    if #find_joker('Energizer') > 0 then
        G.GAME.current_round.reroll_cost = math.floor(G.GAME.current_round.reroll_cost / 2.0)
    end
    return ret
end

--Monkey Wall Street pack changing function
local get_pack_old = get_pack
get_pack = function(_key, _type)
    local center = nil
    if #find_joker('Monkey Wall Street') > 0 then
        local mega_packs = {}
        for k, v in ipairs(G.P_CENTER_POOLS['Booster']) do
            if v.key:sub(1,2) == 'p_' and v.key:find('mega') then
                mega_packs[#mega_packs+1] = v
            end
        end
        local cume, it = 0, 0
        for k, v in ipairs(mega_packs) do
            if (not _type or _type == v.kind) and not G.GAME.banned_keys[v.key] then cume = cume + (v.weight or 1 ) end
        end
        local poll = pseudorandom(pseudoseed((_key or 'pack_generic')..G.GAME.round_resets.ante))*cume
        for k, v in ipairs(mega_packs) do
            if not G.GAME.banned_keys[v.key] then
                if not _type or _type == v.kind then it = it + (v.weight or 1) end
                if it >= poll and it - (v.weight or 1) <= poll then center = v; break end
            end
        end
    else
        center = get_pack_old(_key, _type)
    end
    return center
end

--New end_round if Mdom is active
function end_round_new(mdoms)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.2,
        func = function()
            local game_over = true
            local game_won = false
            G.RESET_BLIND_STATES = true
            G.RESET_JIGGLES = true
            if G.GAME.chips - G.GAME.blind.chips >= to_big(0) then
                game_over = false
            end
            for i = 1, #G.jokers.cards do
                local eval = nil
                eval = G.jokers.cards[i]:calculate_joker({end_of_round = true, game_over = game_over})
                if eval then
                    if eval.saved then
                        game_over = false
                    end
                    card_eval_status_text(G.jokers.cards[i], 'jokers', nil, nil, nil, eval)
                end
                G.jokers.cards[i]:calculate_rental()
                G.jokers.cards[i]:calculate_perishable()
            end
            if game_over then
                G.STATE = G.STATES.GAME_OVER
                if not G.GAME.won and not G.GAME.seeded and not G.GAME.challenge then 
                    G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
                end
                G:save_settings()
                G.FILE_HANDLER.force = true
                G.STATE_COMPLETE = false
            else
                G.GAME.unused_discards = (G.GAME.unused_discards or 0) + G.GAME.current_round.discards_left
                if G.GAME.blind and G.GAME.blind.config.blind then 
                    discover_card(G.GAME.blind.config.blind)
                end

                if G.GAME.blind:get_type() == 'Boss' and not G.GAME.seeded and not G.GAME.challenge  then
                    G.GAME.current_boss_streak = G.GAME.current_boss_streak + 1
                    check_and_set_high_score('boss_streak', G.GAME.current_boss_streak)
                end
                
                if G.GAME.current_round.hands_played == 1 then 
                    inc_career_stat('c_single_hand_round_streak', 1)
                else
                    if not G.GAME.seeded and not G.GAME.challenge  then
                        G.PROFILES[G.SETTINGS.profile].career_stats.c_single_hand_round_streak = 0
                        G:save_settings()
                    end
                end

                check_for_unlock({type = 'round_win'})
                set_joker_usage()
                for i=1, #G.hand.cards do
                    --Check for hand doubling
                    local reps = {1}
                    local j = 1
                    while j <= #reps do
                        local percent = (i-0.999)/(#G.hand.cards-0.998) + (j-1)*0.1
                        if reps[j] ~= 1 then card_eval_status_text((reps[j].jokers or reps[j].seals).card, 'jokers', nil, nil, nil, (reps[j].jokers or reps[j].seals)) end
    
                        --calculate the hand effects
                        local effects = {G.hand.cards[i]:get_end_of_round_effect()}
                        for k=1, #G.jokers.cards do
                            --calculate the joker individual card effects
                            local eval = G.jokers.cards[k]:calculate_joker({cardarea = G.hand, other_card = G.hand.cards[i], individual = true, end_of_round = true})
                            if eval then 
                                table.insert(effects, eval)
                            end
                        end

                        if reps[j] == 1 then 
                            --Check for hand doubling
                            --From Red seal
                            local eval = eval_card(G.hand.cards[i], {end_of_round = true,cardarea = G.hand, repetition = true, repetition_only = true})
                            if next(eval) and (next(effects[1]) or #effects > 1)  then 
                                for h = 1, eval.seals.repetitions do
                                    reps[#reps+1] = eval
                                end
                            end

                            --from Jokers
                            for j=1, #G.jokers.cards do
                                --calculate the joker effects
                                local eval = eval_card(G.jokers.cards[j], {cardarea = G.hand, other_card = G.hand.cards[i], repetition = true, end_of_round = true, card_effects = effects})
                                if next(eval) then 
                                    for h  = 1, eval.jokers.repetitions do
                                        reps[#reps+1] = eval
                                    end
                                end
                            end
                        end
        
                        for ii = 1, #effects do
                            --if this effect came from a joker
                            if effects[ii].card then
                                G.E_MANAGER:add_event(Event({
                                    trigger = 'immediate',
                                    func = (function() effects[ii].card:juice_up(0.7);return true end)
                                }))
                            end
                            
                            --If dollars
                            if effects[ii].h_dollars then 
                                ease_dollars(effects[ii].h_dollars)
                                card_eval_status_text(G.hand.cards[i], 'dollars', effects[ii].h_dollars, percent)
                            end

                            --Any extras
                            if effects[ii].extra then
                                card_eval_status_text(G.hand.cards[i], 'extra', nil, percent, nil, effects[ii].extra)
                            end
                        end
                        j = j + 1
                    end
                end
                delay(0.3)

                G.FUNCS.draw_from_hand_to_discard()
                G.FUNCS.draw_from_discard_to_deck()
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = function()
                        G.STATE = G.STATES.ROUND_EVAL
                        G.STATE_COMPLETE = false

                        if G.GAME.round_resets.blind == G.P_BLINDS.bl_small then
                            G.GAME.round_resets.blind_states.Small = 'Defeated'
                        elseif G.GAME.round_resets.blind == G.P_BLINDS.bl_big then
                            G.GAME.round_resets.blind_states.Big = 'Defeated'
                        else
                            for k, v in pairs(mdoms) do
                                v.ability.extra.active = false
                            end
                        end

                        if G.GAME.round_resets.temp_handsize then G.hand:change_size(-G.GAME.round_resets.temp_handsize); G.GAME.round_resets.temp_handsize = nil end
                        if G.GAME.round_resets.temp_reroll_cost then G.GAME.round_resets.temp_reroll_cost = nil; calculate_reroll_cost(true) end

                        reset_idol_card()
                        reset_mail_rank()
                        reset_ancient_card()
                        reset_castle_card()
                        for k, v in ipairs(G.playing_cards) do
                            v.ability.discarded = nil
                            v.ability.forced_selection = nil
                        end
                    return true
                    end
                }))
            end
        return true
        end
    }))
end

--Mdom replay boss function
local end_round_old = end_round
end_round = function()
    local mdoms = find_joker('MOAB Domination')
    if #mdoms > 0 then
        local active = true
        for k, v in pairs(mdoms) do
            if v.ability.extra.active == false then
                active = false
            end
        end
        if active then
            local ret = end_round_new(mdoms)
            return ret
        end
    end
    local ret = end_round_old()
    return ret
end
