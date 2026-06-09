local multiplayer_bans = {}
local multiplayer_versus_bans = {}

if next(SMODS.find_mod('Multiplayer')) or next(SMODS.find_mod('MultiplayerExperimental')) then
    sendDebugMessage("Multiplayer detected", "BLOONLATRO")
    multiplayer_bans = {
        {id = 'j_bloons_bomb_blitz'},
        {id = 'j_bloons_monkey_pirates'},
        {id = 'j_bloons_pirate_lord'},
        {id = 'j_bloons_legend_of_the_night'},
        {id = 'j_bloons_grand_saboteur'},
        {id = 'tag_bloons_sabotage'},
        {id = 'v_bloons_big_bloon_sabotage'},
        {id = 'v_bloons_big_bloon_blueprints'},
        --Bugged towers
        {id = 'j_bloons_faster_throwing'},
        {id = 'j_bloons_faster_rangs'},
        {id = 'j_bloons_turbo_charge'},
        {id = 'j_bloons_perma_charge'},
    }
    multiplayer_versus_bans = {
        {id = 'j_bloons_cripple_moab'},
        {id = 'j_bloons_herald_of_everfrost'},
    }
end

local start_run_ref = Game.start_run
function Game:start_run(args)
    local result = start_run_ref(self, args)
    G.GAME.banned_keys = G.GAME.banned_keys or {}
    if MP then
        for _, v in ipairs(multiplayer_bans) do
            G.GAME.banned_keys[v.id] = true
            if v.ids then
                for _, vv in ipairs(v.ids) do
                    G.GAME.banned_keys[vv] = true
                end
            end
        end
        if MP.LOBBY.setup.creation_gamemode == 'gamemode_mp_attrition' or MP.LOBBY.setup.creation_gamemode == 'gamemode_mp_showdown' then
            for _, v in ipairs(multiplayer_versus_bans) do
                G.GAME.banned_keys[v.id] = true
                if v.ids then
                    for _, vv in ipairs(v.ids) do
                        G.GAME.banned_keys[vv] = true
                    end
                end
            end
        end
    end
    return result
end
