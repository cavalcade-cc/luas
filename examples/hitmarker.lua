-- made by para
local table = require('table')

local tahoma_bold = Font.new('C:\\Windows\\Fonts\\tahomabd.ttf', 32, FontStyle.BITMAP_ALIASED, false)

local hits = {}
local hitmarker_time = 3.0
g_Ctx.PushCallback('ReportHit', function (vec)
    table.insert(hits, {vec, g_Ctx.GetTime() + hitmarker_time})
end)

g_Ctx.PushCallback('Paint', function ()
    if (#hits > 0) then
        local i = 1
        while i <= #hits do
            if hits[i][2] < g_Ctx.GetTime() then
                table.remove(hits, i)
            else
                local w2s = g_Render.WorldToScreen(hits[i][1])
                if (w2s.m_X ~= 0 and w2s.m_Y ~= 0) then
                    local multiplier = (hits[i][2] - g_Ctx.GetTime()) / hitmarker_time
                    local size = tahoma_bold:GetTextSize('BEANED', 13)
                    g_Render.Text(w2s.m_X - size.m_X/2, w2s.m_Y - (30 * (1-multiplier)), 'BEANED', tahoma_bold, 13, Color.new(0xffffffff):WithAlphaMul(multiplier))
                end

                i = i + 1
            end
        end
    end
end)