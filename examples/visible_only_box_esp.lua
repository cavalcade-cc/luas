-- made by para

function player_visible(player)
    if (g_Local:GetRef() == nil or player:GetRef() == nil) then return false end

    local trace = g_EngineTrace:TraceRay(Ray.new(g_Local:GetRef():GetEyePosition(), player:GetRef():GetOrigin()), 0x4600400b, TraceFilter.new(g_Local:GetRef()))
    return (trace.m_Entity ~= nil and trace.m_Entity:GetIndex() == player:GetRef():GetIndex()) or trace.m_Fraction > 0.97
end

g_Ctx.PushCallback('Paint', function ()
    g_PlayerCache:ForEach(function(player)
        if (player:GetRef():IsAlive() and player:GetRef():IsDormant() ~= true and player:GetRef() ~= g_Local:GetRef() and player_visible(player)) then
            local bounding_box = player:GetRef():GetBoundingBox()
            if (bounding_box[1].m_X ~= 0 and bounding_box[1].m_Y ~= 0 and bounding_box[2].m_X ~= 0 and bounding_box[2].m_Y ~= 0) then
                g_Render.Rect(bounding_box[1].m_X, bounding_box[1].m_Y, bounding_box[2].m_X, bounding_box[2].m_Y, 1, 0, Color.new(0xffffffff))
            end
        end
    end)
end)