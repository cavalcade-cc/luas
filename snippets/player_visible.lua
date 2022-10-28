-- This is for the Player structure, not CSPlayer, to make it CSPlayer get rid of GetRef calls.
function player_visible(player)
    if (g_Local:GetRef() == nil or player:GetRef() == nil) then return false end

    local trace = g_EngineTrace:TraceRay(Ray.new(g_Local:GetRef():GetEyePosition(), player:GetRef():GetOrigin()), 0x4600400b, TraceFilter.new(g_Local:GetRef()))
    return (trace.m_Entity ~= nil and trace.m_Entity:GetIndex() == player:GetRef():GetIndex()) or trace.m_Fraction > 0.97
end