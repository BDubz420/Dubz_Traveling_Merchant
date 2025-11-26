-- cl_init.lua
include("shared.lua")
include("autorun/dubz_traveling_merchant_config.lua")

local bgCol      = Color(0, 0, 0, 200)
local outlineCol = Color(0, 190, 255, 255)
local shadowCol  = Color(0, 0, 0, 120)
local accentCol  = Color(0, 190, 255)

net.Receive("dtm_openmerchant", function()
    local dealer     = net.ReadEntity()
    local dealerName = net.ReadString()
    local itemCount  = net.ReadUInt(8)

    local items = {}
    for i = 1, itemCount do
        items[i] = {
            id    = net.ReadString(),
            name  = net.ReadString(),
            price = net.ReadInt(32),
            type  = net.ReadString(),
        }
    end

    -- Main frame
    local frame = vgui.Create("DFrame")
    frame:SetSize(ScrW() * 0.30, ScrH() * 0.36)
    frame:Center()
    frame:SetTitle("")
    frame:MakePopup()
    frame:ShowCloseButton(false)

    frame.Paint = function(self, w, h)
        draw.RoundedBox(8, 4, 4, w - 8, h - 8, shadowCol)
        draw.RoundedBox(8, 0, 0, w, h, bgCol)
        surface.SetDrawColor(accentCol)
        surface.DrawRect(0, 0, 5, h)

        draw.SimpleText("Traveling Merchant", "Trebuchet24", 20, 12, color_white, TEXT_ALIGN_LEFT)
        draw.SimpleText("Dealer: " .. dealerName, "Trebuchet18", 20, 40, Color(200, 200, 200))
    end

    local close = vgui.Create("DButton", frame)
    close:SetText("✕")
    close:SetFont("Trebuchet24")
    close:SetColor(Color(255, 255, 255))
    close:SetSize(32, 32)
    close:SetPos(frame:GetWide() - 36, 4)
    close.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, Color(0, 0, 0, 160))
        if self.hover then
            draw.RoundedBox(6, 0, 0, w, h, Color(255, 50, 50, 80))
        end
    end
    close.OnCursorEntered = function(s) s.hover = true end
    close.OnCursorExited  = function(s) s.hover = false end
    close.DoClick = function() frame:Remove() end

    local list = vgui.Create("DScrollPanel", frame)
    list:SetPos(10, 70)
    list:SetSize(frame:GetWide() - 20, frame:GetTall() - 80)

    for _, item in ipairs(items) do
        local panel = list:Add("DPanel")
        panel:SetTall(54)
        panel:Dock(TOP)
        panel:DockMargin(0, 0, 0, 8)

        panel.Paint = function(self, w, h)
            draw.RoundedBox(6, 0, 0, w, h, Color(20, 20, 20, 180))
            draw.SimpleText(item.name, "Trebuchet18", 12, 8, color_white)
            draw.SimpleText("Price: " .. DarkRP.formatMoney(item.price), "Trebuchet18", 12, 28, outlineCol)
            draw.SimpleText(string.upper(item.type), "Trebuchet18", w - 80, 8, Color(200, 200, 200), TEXT_ALIGN_RIGHT)
        end

        local buy = vgui.Create("DButton", panel)
        buy:Dock(RIGHT)
        buy:SetWide(120)
        buy:SetText("Buy")
        buy:SetFont("Trebuchet18")
        buy:SetColor(color_white)

        buy.Paint = function(self, w, h)
            draw.RoundedBox(6, 0, 0, w, h, Color(0, 0, 0, 160))
            if self.hover then
                draw.RoundedBox(6, 0, 0, w, h, Color(50, 255, 50, 80))
            end
        end

        buy.OnCursorEntered = function(s)
            s.hover = true
            surface.PlaySound("buttons/lightswitch2.wav")
        end

        buy.OnCursorExited = function(s)
            s.hover = false
        end

        buy.DoClick = function()
            net.Start("dtm_buyitem")
                net.WriteEntity(dealer)
                net.WriteString(item.id)
            net.SendToServer()
        end
    end
end)
