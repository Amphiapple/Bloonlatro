--Psi change boss
local get_boss_old = get_new_boss
get_new_boss = function()
    local ret = get_boss_old()
    if G.GAME.selected_back.name ~= 'Psi Deck' or G.GAME.round_resets.ante%G.GAME.win_ante == 0 and G.GAME.round_resets.ante >= 2 then
        return ret
    else
        return "bl_psychic"
    end
end

--Ninja full slots buy
local check_for_buy_space_old = G.FUNCS.check_for_buy_space
G.FUNCS.check_for_buy_space = function(card)
    if card.ability.set == 'Joker' and card.ability.name == 'Ninja Monkey' then
        return true
    else
        local ret = check_for_buy_space_old(card)
        return ret
    end
end

--Ninja full slots add
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

--Cost and sell price change
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
    if self.ability.set == 'Joker' and self.config.center.rarity == 1 and #find_joker('Primary Expertise') > 0 then
        self.cost = 0
    end
    return ret
end

--Energizer reroll cost
local calculate_reroll_cost_old = calculate_reroll_cost
calculate_reroll_cost = function(skip_increment)
    local ret = calculate_reroll_cost_old(skip_increment)
    if #find_joker('Energizer') > 0 then
        G.GAME.current_round.reroll_cost = math.floor(G.GAME.current_round.reroll_cost / 2.0)
    end
    return ret
end

--Monkey Wall Street pack changing
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

--Mdom replay boss
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

--Challenge higher stakes
local start_challenge_run_old = G.FUNCS.start_challenge_run
G.FUNCS.start_challenge_run = function(e)
    if G.OVERLAY_MENU then
        G.FUNCS.exit_overlay_menu()
    end
    local stake = 1
    if e.config.id == 21 or e.config.id == 23 or e.config.id == 25 or e.config.id == 30 then
        stake = 8
    elseif e.config.id == 28 then
        stake = 6
    end
    local ret = G.FUNCS.start_run(e, {stake = stake, challenge = G.CHALLENGES[e.config.id]})
    return ret
end