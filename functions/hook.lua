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
    if card.ability.set == 'Joker' and (card.ability.name == 'Ninja Monkey' or card.ability.name == 'Shinobi Tactics') then
        return true
    else
        local ret = check_for_buy_space_old(card)
        return ret
    end
end

--Ninja full slots add
local can_select_card_old = G.FUNCS.can_select_card
G.FUNCS.can_select_card = function(e)
    if e.config.ref_table.ability.name == 'Ninja Monkey' or e.config.ref_table.ability.name == 'Shinobi Tactics' then 
        e.config.colour = G.C.GREEN
        e.config.button = 'use_card'
    else
        local ret = can_select_card_old(e)
        return ret
    end
end

--Skip tag effects
G.FUNCS.skip_blind = function(e)
    stop_use()
    G.CONTROLLER.locks.skip_blind = true
    G.E_MANAGER:add_event(Event({
        no_delete = true,
        trigger = 'after',
        blocking = false,blockable = false,
        delay = 2.5,
        timer = 'TOTAL',
        func = function()
            G.CONTROLLER.locks.skip_blind = nil
            return true
        end
    }))
    local _tag = e.UIBox:get_UIE_by_ID('tag_container')
    G.GAME.skips = (G.GAME.skips or 0) + 1
    if _tag then 
        if G.GAME.used_vouchers.v_bloons_quick_hands then
            if G.GAME.used_vouchers.v_bloons_grand_prix_spree then
                add_tag(Tag('tag_skip'))
            end
            add_tag(Tag('tag_double'))
        end
        for i = 1, #G.jokers.cards do
            G.jokers.cards[i]:calculate_joker({skip_blind = true})
        end
        add_tag(_tag.config.ref_table)
        local skipped, skip_to = G.GAME.blind_on_deck or 'Small', 
        G.GAME.blind_on_deck == 'Small' and 'Big' or G.GAME.blind_on_deck == 'Big' and 'Boss' or 'Boss'
        G.GAME.round_resets.blind_states[skipped] = 'Skipped'
        G.GAME.round_resets.blind_states[skip_to] = 'Select'
        G.GAME.blind_on_deck = skip_to
        play_sound('generic1')
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                delay(0.3)
                save_run()
                for i = 1, #G.GAME.tags do
                    G.GAME.tags[i]:apply_to_run({type = 'immediate'})
                end
                for i = 1, #G.GAME.tags do
                    if G.GAME.tags[i]:apply_to_run({type = 'new_blind_choice'}) then break end
                end
                return true
            end
        }))
    end
end

--Cost and sell price change
local set_cost_old = Card.set_cost
Card.set_cost = function(self, ...)
    local ret = set_cost_old(self, ...)
    --Salvage sell cost
    self.sell_cost = self.sell_cost + 2 * #find_joker('Banana Salvage')
    --Monkey Wall Street booster discount
    if self.ability.set == 'Booster' and #find_joker('Monkey Wall Street') > 0 then
        self.cost = math.floor(self.cost / 2.0)
    end
    --Monkey Commerce discount
    if #find_joker('Monkey Commerce') > 0 then
        if #find_joker('Monkey Commerce') > self.cost then
            self.cost = 0
        else
            self.cost = self.cost - #find_joker('Monkey Commerce')
        end
    end
    --Primary expertise primary free discount
    if self.ability.set == 'Joker' and self.config.center.rarity == 1 and #find_joker('Primary Expertise') > 0 then
        self.cost = 0
    end
    --VTSG discount
    local vtsgs = find_joker('Vengeful True Sun God')
    if #vtsgs > 0 then
        local discount = 0
        for k, v in pairs(vtsgs) do
            discount = discount + v.ability.extra.discount * (v.ability.extra.sacrifices['econ'])
        end
        if discount > self.cost then
            self.cost = 0
        else
            self.cost = self.cost - discount
        end
    end
    return ret
end

-- Sell card change
local sell_card_old = Card.sell_card
Card.sell_card = function(self, ...)
    if G.GAME.selected_back and G.GAME.selected_back.name == 'Adora Deck' then
        self.sell_cost = 0
        G.CONTROLLER.locks.selling_card = true
        stop_use()
        local area = self.area
        G.CONTROLLER:save_cardarea_focus(area == G.jokers and 'jokers' or 'consumeables')

        if self.children.use_button then self.children.use_button:remove(); self.children.use_button = nil end
        if self.children.sell_button then self.children.sell_button:remove(); self.children.sell_button = nil end

        local eval, post = eval_card(self, {selling_self = true})
        local effects = {eval}
        for _,v in ipairs(post) do effects[#effects+1] = v end
        if eval.retriggers then
            for rt = 1, #eval.retriggers do
                local rt_eval, rt_post = eval_card(self, { selling_self = true, retrigger_joker = true})
                if next(rt_eval) then
                    table.insert(effects, {eval.retriggers[rt]})
                    table.insert(effects, rt_eval)
                    for _, v in ipairs(rt_post) do effects[#effects+1] = v end
                end
            end
        end
        SMODS.trigger_effects(effects, self)

        G.E_MANAGER:add_event(Event({trigger = 'immediate',func = function()
            self:start_dissolve()
            delay(0.3)

            inc_career_stat('c_cards_sold', 1)
            if self.ability.set == 'Joker' then 
                inc_career_stat('c_jokers_sold', 1)
            end
            if self.ability.set == 'Joker' and G.GAME.blind and G.GAME.blind.name == 'Verdant Leaf' then
                G.E_MANAGER:add_event(Event({trigger = 'immediate',func = function()
                    G.GAME.blind:disable()
                    return true
                end}))
            end
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3, blocking = false,
            func = function()
                G.E_MANAGER:add_event(Event({trigger = 'immediate',
                func = function()
                    G.E_MANAGER:add_event(Event({trigger = 'immediate',
                    func = function()
                        G.CONTROLLER.locks.selling_card = nil
                        G.CONTROLLER:recall_cardarea_focus(area == G.jokers and 'jokers' or 'consumeables')
                    return true
                    end}))
                return true
                end}))
            return true
            end}))
            return true
        end}))
    else
        local ret = sell_card_old(self, ...)
        return ret
    end
end

--Energizer reroll cost
local calculate_reroll_cost_old = calculate_reroll_cost
calculate_reroll_cost = function(skip_increment)
    local ret = calculate_reroll_cost_old(skip_increment)
    if G.GAME.modifiers.survivor then
        G.GAME.current_round.reroll_cost = 540078
    elseif #find_joker('Energizer') > 0 then
        G.GAME.current_round.reroll_cost = math.floor(G.GAME.current_round.reroll_cost / 2.0)
    end
    return ret
end

--Wall Street booster changing
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

--Sacrifice Context for Adora and VTSG
local function get_sac_context(card)
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
            and vtsg_sacrifices['+chips'] == 0
            and vtsg_sacrifices['+mult'] == 0
            and vtsg_sacrifices['Xmult'] == 0
            and vtsg_sacrifices['econ']  == 0
            and vtsg_sacrifices['value'] == 0
            and vtsg_sacrifices['support'] == 0

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
end

--Sacrifice function for VTSG
G.FUNCS.vtsg_sac = function(e)
    local card = e.config.ref_table
    local sac_context = get_sac_context(card)
    if not sac_context.vtsg_enabled then return end
    card.config.center.sac_to_vtsg(card)
    card.highlighted = false
end

--Sacrifice button for Adora and VTSG
function G.UIDEF.use_and_sell_buttons(card)
    local sell, use, adora_sac, vtsg_sac = nil, nil, nil, nil
    local sac_context = get_sac_context(card)

    if sac_context.adora_show then
        adora_sac = {n=G.UIT.C, config={align = "cr"}, nodes={
            {n=G.UIT.C, config={
                ref_table = card,
                align = "cr",
                maxw = 1.25,
                padding = 0.15,
                r = 0.08,
                minw = 1.25,
                minh = 0,
                hover = true,
                shadow = true,
                colour = sac_context.adora_enabled and HEX("FFCE00") or G.C.UI.BACKGROUND_INACTIVE,
                one_press = true,
                button = sac_context.adora_enabled and 'adora_sac' or nil
            }, nodes={
            {n=G.UIT.B, config = {w=0.1,h=0.6}},
            {n=G.UIT.C, config={align = "cm"}, nodes={
            {n=G.UIT.R, config={align = "cm", maxw = 1.25}, nodes={
                {n=G.UIT.T, config={text = 'SAC',colour = sac_context.adora_enabled and G.C.UI.TEXT_LIGHT or G.C.UI.TEXT_INACTIVE, scale = 0.55, shadow = sac_context.adora_enabled}}
            }}
            }}
        }}
        }}
    end

    if sac_context.vtsg_show then
        vtsg_sac = {n=G.UIT.C, config={align = "cr"}, nodes={
            {n=G.UIT.C, config={
                ref_table = card,
                align = "cr",
                maxw = 1.25,
                padding = 0.15,
                r = 0.08,
                minw = 1.25,
                minh = 0,
                hover = true,
                shadow = true,
                colour = sac_context.vtsg_enabled and HEX("383C76") or G.C.UI.BACKGROUND_INACTIVE,
                one_press = true,
                button = sac_context.vtsg_enabled and 'vtsg_sac' or nil
            }, nodes={
            {n=G.UIT.B, config = {w=0.1,h=0.6}},
            {n=G.UIT.C, config={align = "cm"}, nodes={
            {n=G.UIT.R, config={align = "cm", maxw = 1.25}, nodes={
                {n=G.UIT.T, config={text = 'SAC',colour = sac_context.vtsg_enabled and G.C.UI.TEXT_LIGHT or G.C.UI.TEXT_INACTIVE, scale = 0.55, shadow = sac_context.vtsg_enabled}}
            }}
            }}
        }}
        }}
    end

    if card.area and card.area.config.type == 'joker' and not (G.GAME.selected_back and G.GAME.selected_back.name == 'Adora Deck') then
        sell = {n=G.UIT.C, config={align = "cr"}, nodes={
      {n=G.UIT.C, config={ref_table = card, align = "cr",padding = 0.1, r=0.08, minw = 1.25, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'sell_card', func = 'can_sell_card'}, nodes={
        {n=G.UIT.B, config = {w=0.1,h=0.6}},
        {n=G.UIT.C, config={align = "tm"}, nodes={
          {n=G.UIT.R, config={align = "cm", maxw = 1.25}, nodes={
            {n=G.UIT.T, config={text = localize('b_sell'),colour = G.C.UI.TEXT_LIGHT, scale = 0.4, shadow = true}}
          }},
          {n=G.UIT.R, config={align = "cm"}, nodes={
            {n=G.UIT.T, config={text = localize('$'),colour = G.C.WHITE, scale = 0.4, shadow = true}},
            {n=G.UIT.T, config={ref_table = card, ref_value = 'sell_cost_label',colour = G.C.WHITE, scale = 0.55, shadow = true}}
          }}
        }}
      }},
    }}
    end
    if card.ability.consumeable and card.area == G.pack_cards and booster_obj and booster_obj.select_card and card:selectable_from_pack(booster_obj) then
        if (card.area == G.pack_cards and G.pack_cards) then
            return {n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
                {n=G.UIT.R, config={ref_table = card, r = 0.08, padding = 0.1, align = "bm", minw = 0.5*card.T.w - 0.15, maxw = 0.9*card.T.w - 0.15, minh = 0.3*card.T.h, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'use_card', func = 'can_select_from_booster'}, nodes={
                {n=G.UIT.T, config={text = localize('b_select'),colour = G.C.UI.TEXT_LIGHT, scale = 0.45, shadow = true}}
                }},
            }}
        end
    end
  if card.ability.consumeable then
    if (card.area == G.pack_cards and G.pack_cards) then
      return {
        n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
          {n=G.UIT.R, config={mid = true}, nodes={
          }},
          {n=G.UIT.R, config={ref_table = card, r = 0.08, padding = 0.1, align = "bm", minw = 0.5*card.T.w - 0.15, minh = 0.8*card.T.h, maxw = 0.7*card.T.w - 0.15, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'use_card', func = 'can_use_consumeable'}, nodes={
            {n=G.UIT.T, config={text = localize('b_use'),colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}}
          }},
      }}
    end
    use =
    {n=G.UIT.C, config={align = "cr"}, nodes={
      {n=G.UIT.C, config={ref_table = card, align = "cr",maxw = 1.25, padding = 0.1, r=0.08, minw = 1.25, minh = (card.area and card.area.config.type == 'joker') and 0 or 1, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'use_card', func = 'can_use_consumeable'}, nodes={
        {n=G.UIT.B, config = {w=0.1,h=0.6}},
        {n=G.UIT.T, config={text = localize('b_use'),colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}}
      }}
    }}
  elseif card.area and card.area == G.pack_cards then
    return {
      n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
        {n=G.UIT.R, config={ref_table = card, r = 0.08, padding = 0.1, align = "bm", minw = 0.5*card.T.w - 0.15, maxw = 0.9*card.T.w - 0.15, minh = 0.3*card.T.h, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'use_card', func = 'can_select_card'}, nodes={
          {n=G.UIT.T, config={text = localize('b_select'),colour = G.C.UI.TEXT_LIGHT, scale = 0.45, shadow = true}}
        }},
    }}
  end
    local t = {
      n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
        {n=G.UIT.C, config={padding = 0.15, align = 'cl'}, nodes={
          {n=G.UIT.R, config={align = 'cl'}, nodes={
            sell
          }},
          {n=G.UIT.R, config={align = 'cl'}, nodes={
            adora_sac
          }},
          {n=G.UIT.R, config={align = 'cl'}, nodes={
            vtsg_sac
          }},
          {n=G.UIT.R, config={align = 'cl'}, nodes={
            use
          }},
        }},
    }}
  return t
end

--Challenge higher stakes
local start_challenge_run_old = G.FUNCS.start_challenge_run
G.FUNCS.start_challenge_run = function(e)
    if G.OVERLAY_MENU then
        G.FUNCS.exit_overlay_menu()
    end
    local stake = get_challenge_stake(e)
    local ret = G.FUNCS.start_run(e, {stake = stake, challenge = G.CHALLENGES[e.config.id]})
    return ret
end

--Survivor disable rerolling
local can_reroll_old = G.FUNCS.can_reroll
G.FUNCS.can_reroll = function(e)
    if G.GAME.modifiers.no_shop_rerolls then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        local ret = can_reroll_old(e)
        return ret
    end
end

--Challenge faster scaling
local get_blind_amount_old = get_blind_amount
function get_blind_amount(ante)
    local k = 0.75
    if G.GAME.modifiers.scaling == 4 then 
        local amounts = {
            300,  1200,  5000,  18000,  60000,  180000,  450000,  1000000
        }
        if ante < 1 then return 100 end
        if ante <= 8 then return amounts[ante] end
        local a, b, c, d = amounts[8],1.6,ante-8, 1 + 0.2*(ante-8)
        local amount = math.floor(a*(b+(k*c)^d)^c)
        amount = amount - amount%(10^math.floor(math.log10(amount)-1))
        return amount
    else
        local ret = get_blind_amount_old(ante)
        return ret
    end
end