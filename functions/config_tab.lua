SMODS.current_mod.config_tab = function()
    return {
        n = G.UIT.ROOT,
        config = { r = 0.1, minw = 5, align = "tm", padding = 0.2, colour = G.C.BLACK },
        nodes = {
            {
                n = G.UIT.R,
                config = { padding = 0.2, align = "cm" },
                nodes = {
                    create_toggle({
                        label = "Only Bloonlatro Jokers",
                        ref_table = Bloonlatro.config,
                        ref_value = 'only_bloonlatro_jokers',
                    })
                }
            },
            {
                n = G.UIT.R,
                config = { padding = 0.2, align = "cm" },
                nodes = {
                    create_toggle({
                        label = "Upgrading Towers",
                        ref_table = Bloonlatro.config,
                        ref_value = 'upgrading_towers',
                    })
                }
            },
            { n = G.UIT.R, config = { minh = 0.1 } }
            
        }
    }
end

local start_run_ref = Game.start_run
function Game:start_run(args)
    local result = start_run_ref(self, args)

    if Bloonlatro.config.only_bloonlatro_jokers then
        local non_bloonlatro_jokers = {}
        for key, _ in pairs(G.P_CENTERS) do
            if key:sub(1,2) == "j_" and not key:find("^j_bloons") then
                table.insert(non_bloonlatro_jokers, { id = key })
            end
        end

        G.GAME.banned_keys = G.GAME.banned_keys or {}
        for _, v in ipairs(non_bloonlatro_jokers) do
            G.GAME.banned_keys[v.id] = true
            if v.ids then
                for _, vv in ipairs(v.ids) do
                    G.GAME.banned_keys[vv] = true
                end
            end
        end
    end

    if not Bloonlatro.config.upgrading_towers then
        local upgrade_cards = {}
        for k, v in pairs(G.P_CENTERS) do
            if k:sub(1,2) == "c_" and v.set == "Upgrade" then
                table.insert(upgrade_cards, { id = k })
            elseif k:sub(1,2) == "p_" and v.group_key == "k_upgrade_pack" then
                table.insert(upgrade_cards, { id = k })
            elseif k == "v_bloons_upgrade_merchant" or k == "v_bloons_upgrade_tycoon" then
                table.insert(upgrade_cards, { id = k })
            end
        end

        G.GAME.banned_keys = G.GAME.banned_keys or {}
        for _, v in ipairs(upgrade_cards) do
            G.GAME.banned_keys[v.id] = true
            if v.ids then
                for _, vv in ipairs(v.ids) do
                    G.GAME.banned_keys[vv] = true
                end
            end
        end
    end

    return result
end