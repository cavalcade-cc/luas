g_Ctx.PushCallback('FireEventIntern', function (event, is_server, is_client)
    local name = event:GetName()
    if (name == 'player_death' and is_client) then
        local us = g_EngineClient:GetLocalPlayerIndex()
        local attacker = g_EngineClient:GetPlayerForUID(event:GetInt('attacker'))
        local dead = g_EngineClient:GetPlayerForUID(event:GetInt('userid'))
        local dead_info = g_EngineClient:GetPlayerInfo(dead)
        if (attacker == us) then
            g_ClientModeShared.m_ChatElement:Print('<font color="#ff00ff">rip ' .. dead_info.m_Name .. '</font>')
            g_EngineClient:ExecuteClientCmd('say "rip ' .. dead_info.m_Name .. '"')
        end
    end
end)