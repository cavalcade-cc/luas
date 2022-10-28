-- made by para
local table = require('table')

-- change to match if need be
-- maybe use FFI to rely on shell to give us windows path instead
-- anyway if this fails it's not gonna draw text so it's gonna be pretty evident
local tahoma = Font.new('C:\\Windows\\Fonts\\tahoma.ttf', 32, FontStyle.BITMAP_ALIASED, false)
local tahoma_bold = Font.new('C:\\Windows\\Fonts\\tahomabd.ttf', 32, FontStyle.BITMAP_ALIASED, false)

local accent_color = Color.new(0x485a7dff)
local main_color = Color.new(0x252525ff)
local contrast_color = Color.new(0x212121ff)
local outline_color = Color.new(0x454447ff)

local header_height = 25
local entry_height = 25

-- x padding between ends for spectators
local padding = 5

local x = 30
local y = g_Render.GetScreenSize().m_Y / 2
local old_mouse = g_Ctx.GetMousePos()
local dragging = false

-- automatically gets extended if there's any longer entry
local default_max_w = 300

function outline_text(x, y, text, font, size, color)
    g_Render.Text(x-1, y, text, font, size, Color.new(0xff))
    g_Render.Text(x, y-1, text, font, size, Color.new(0xff))
    g_Render.Text(x+1, y, text, font, size, Color.new(0xff))
    g_Render.Text(x, y+1, text, font, size, Color.new(0xff))
    g_Render.Text(x, y, text, font, size, color)
end

function mouse_within_bounds(x, y, w, h)
    return (g_Ctx.GetMousePos().m_X >= x and g_Ctx.GetMousePos().m_Y >= y and g_Ctx.GetMousePos().m_X <= (x + w) and g_Ctx.GetMousePos().m_Y <= (y + h))
end

function speclist(w)    
    -- get spectators
    local strings = {}

    g_PlayerCache:ForEach(function (player)
        if (player:GetRef() ~= nil and player:GetRef():IsDormant() ~= true and player:GetRef():GetObserver():GetPlayerRef() ~= nil) then
            local target = player:GetRef():GetObserver():GetPlayerRef()
            local observed_info = g_EngineClient:GetPlayerInfo(target:GetIndex())
            local observer_info = g_EngineClient:GetPlayerInfo(player:GetRef():GetIndex())
            
            table.insert(strings, {observer_info.m_Name .. ' -> ' .. observed_info.m_Name, g_Local:GetRef() and target:GetIndex() == g_Local:GetRef():GetIndex()})
            local size = tahoma_bold:GetTextSize(strings[#strings][1], 5.5)
            if (size.m_X > w) then
                w = size.m_X + padding*2
            end
        end
    end)

    -- dragging
    if (dragging ~= true and g_Ctx.GetKeyState(1, KeyState.DOWN) and mouse_within_bounds(x, y, w, header_height)) then
        dragging = true
    elseif (dragging and g_Ctx.GetKeyState(1, KeyState.DOWN) ~= true) then
        dragging = false
    end

    if (dragging) then
        local delta_x = g_Ctx.GetMousePos().m_X - old_mouse.m_X
        local delta_y = g_Ctx.GetMousePos().m_Y - old_mouse.m_Y

        x = x + delta_x
        y = y + delta_y
    end

    -- header
    local quad = {Pair.new(x, y + header_height), Pair.new(x + w*0.05, y), Pair.new(x + w + w*0.05, y), Pair.new(x + w, y + header_height)}
    g_Render.PolyFill(quad, main_color)
    table.insert(quad, Pair.new(x, y + header_height))
    g_Render.PolyLine(quad, 1, outline_color)

    local size = tahoma:GetTextSize('SPECTATOR LIST', 6.5)
    outline_text(x + w / 2 - size.m_X / 2, y + header_height / 2 - size.m_Y / 2, 'SPECTATOR LIST', tahoma, 6.5, accent_color)

    -- draw spectators
    for i = 1, #strings, 1
    do
        local contrast = (i % 2) == 0
        local color = main_color
        if (contrast) then
            color = contrast_color
        end

        g_Render.RectFill(x, y + i * header_height, w, entry_height, 0, color)

        color = Color.new(0xffffffff)
        if (strings[i][2]) then
            color = accent_color
        end

        local size = tahoma_bold:GetTextSize(strings[i][1], 5.5)
        outline_text(x + padding, y + i * header_height + header_height / 2 - size.m_Y / 2, strings[i][1], tahoma_bold, 5.5, color)
    end

    -- outline spectators part
    if (#strings > 0) then
        local final_outline = {Pair.new(x, y + header_height), Pair.new(x, y + header_height + (entry_height * #strings)), Pair.new(x + w, y + header_height + (entry_height * #strings)), Pair.new(x + w, y + header_height)}
        g_Render.PolyLine(final_outline, 1, outline_color)
    end

    -- for dragging
    old_mouse = g_Ctx.GetMousePos()
end

g_Ctx.PushCallback('Paint', function ()
    speclist(default_max_w)
end)