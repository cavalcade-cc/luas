-- made by para
local math = require('math')

local tahoma = Font.new('C:\\Windows\\Fonts\\tahoma.ttf', 12, FontStyle.BITMAP_ALIASED, false)

function outline_text(x, y, text, font, size, color)
    g_Render.Text(x-1.0, y, text, font, size, Color.new(0xff))
    g_Render.Text(x, y-1.0, text, font, size, Color.new(0xff))
    g_Render.Text(x+1.0, y, text, font, size, Color.new(0xff))
    g_Render.Text(x, y+1.0, text, font, size, Color.new(0xff))
    g_Render.Text(x, y, text, font, size, color)
end

local box_color = Color.new(0xffffffff)
local name_color = Color.new(0xffffffff)
local hp_color = Color.new(0xffffffff)
local weapon_ammo_color = Color.new(0xffffffff)

g_Ctx.PushCallback('Paint', function ()
    g_PlayerCache:ForEach(function(player)
        if (player:GetRef():IsAlive() and player:GetRef():IsDormant() ~= true and player:GetRef():IsEnemy(g_Local:GetRef())) then
            local bounding_box = player:GetRef():GetBoundingBox()
            if ((bounding_box[1].m_X == 0 and bounding_box[1].m_Y == 0) or (bounding_box[2].m_X == 0 and bounding_box[2].m_Y == 0)) then return end

            -- get cached info
            local info = player:GetPlayerInfo()

            -- name esp
            local size = tahoma:GetTextSize(info.m_Name, 6)
            outline_text(bounding_box[1].m_X + bounding_box[2].m_X / 2.0 - size.m_X / 2.0, bounding_box[1].m_Y - size.m_Y - 4.0, info.m_Name, tahoma, 6, name_color)
            
            -- box esp
            g_Render.Rect(bounding_box[1].m_X, bounding_box[1].m_Y, bounding_box[2].m_X, bounding_box[2].m_Y, 1, 0, Color.new(0xff))
            g_Render.Rect(bounding_box[1].m_X+1.0, bounding_box[1].m_Y+1.0, bounding_box[2].m_X-2.0, bounding_box[2].m_Y-2.0, 1, 0, box_color)

            -- automaticaly position stuff
            local bottom_padding = 4.0
            function pad(size)
                bottom_padding = bottom_padding + size.m_Y + 4.0 + 1.0 -- due to outline
            end

            -- health esp
            size = tahoma:GetTextSize(player:GetRef():GetHealth() .. ' HP', 6)
            outline_text(bounding_box[1].m_X + bounding_box[2].m_X / 2.0 - size.m_X / 2.0, bounding_box[1].m_Y + bounding_box[2].m_Y + bottom_padding, player:GetRef():GetHealth() .. ' HP', tahoma, 6, hp_color)
            pad(size)

            -- weapon + ammo esp
            local weapon_handle = player:GetRef():GetActiveWeapon()
            if (weapon_handle:IsValid() and weapon_handle:GetWeaponRef() ~= nil) then
                local weapon_info = weapon_handle:GetWeaponRef():GetCSWeaponInfo()
                if (weapon_info ~= nil) then
                    local name = g_Localize:Find(weapon_info:GetHudName()) .. '-' .. weapon_handle:GetWeaponRef():GetAmmo()
                    size = tahoma:GetTextSize(name, 6)
                    outline_text(bounding_box[1].m_X + bounding_box[2].m_X / 2.0 - size.m_X / 2.0, bounding_box[1].m_Y + bounding_box[2].m_Y + bottom_padding, name, tahoma, 6, weapon_ammo_color)
                    pad(size)
                end
            end
        end
    end)
end)