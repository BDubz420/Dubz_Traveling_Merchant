-- cl_init.lua
include("shared.lua")
include("autorun/franks_snow_ui.lua") -- ensures SnowDubz fonts exist

local bgCol      = Color(0, 0, 0, 170)
local outlineCol = Color(0, 190, 255, 255)
local shadowCol  = Color(0, 0, 0, 120)
local accentCol  = Color(0, 190, 255)

net.Receive("drugdealeropenmenu", function()
    local dealer      = net.ReadEntity()
    local cokePrice   = net.ReadInt(24)
    local dealerName  = net.ReadString()
    local cokeHolding = net.ReadInt(24)

    -- Main frame
    local frame = vgui.Create("DFrame")
    frame:SetSize(ScrW()*0.26, ScrH()*0.26)
    frame:Center()
    frame:SetTitle("")
    frame:MakePopup()
    frame:ShowCloseButton(false)

    -- Dubz-shadow + border style
    frame.Paint = function(self, w, h)
        -- Shadow behind panel
        --draw.RoundedBox(8, 4, 4, w-8, h-8, shadowCol)

        -- Main background
        draw.RoundedBox(8, 0, 0, w, h, bgCol)

        -- Outline
        --surface.SetDrawColor(outlineCol)
        --surface.DrawOutlinedRect(0, 0, w, h, 2)

        -- Left accent bar
        surface.SetDrawColor(accentCol)
        surface.DrawRect(0, 0, 5, h)

        -- Text layout
        draw.SimpleText("SNOW BUYER", "SnowDubz_Big",
            20, 12, color_white, TEXT_ALIGN_LEFT)

        draw.SimpleText("Dealer: " .. dealerName,
            "SnowDubz_Medium", 20, 50, Color(200,200,200))

        draw.SimpleText("Current Snow Price",
            "SnowDubz_Small", w/2, 90, Color(200,200,200), TEXT_ALIGN_CENTER)

        draw.SimpleText(DarkRP.formatMoney(cokePrice),
            "SnowDubz_Big", w/2, 115, outlineCol, TEXT_ALIGN_CENTER)

        draw.SimpleText("Holding: " .. cokeHolding .. " brick(s)",
            "SnowDubz_Medium", w/2, 150, color_white, TEXT_ALIGN_CENTER)
    end

    -- Close button (top right, Dubz style)
    local close = vgui.Create("DButton", frame)
    close:SetText("✕")
    close:SetFont("SnowDubz_Medium")
    close:SetColor(Color(255,255,255))
    close:SetSize(32, 32)
    close:SetPos(frame:GetWide()-36, 4)

    close.Paint = function(self,w,h)
        draw.RoundedBox(6,0,0,w,h,Color(0,0,0,160))
        if self.hover then
            draw.RoundedBox(6,0,0,w,h,Color(255,50,50,80))
        end
    end
    close.OnCursorEntered = function(s) s.hover = true end
    close.OnCursorExited  = function(s) s.hover = false end
    close.DoClick = function() frame:Remove() end

    -- Sell button (Dubz style)
	local sell = vgui.Create("DButton", frame)
	sell:SetText("")
	sell:SetSize(frame:GetWide()*0.70, 58)
	sell:SetPos(frame:GetWide()*0.15, frame:GetTall()-80)

	sell.Paint = function(self, w, h)
	    draw.RoundedBox(6, 0, 0, w, h, Color(0,0,0,150))

	    local col = self.hover and Color(50,255,50) or color_white

	    local totalPay = cokeHolding * cokePrice

	    -- Main sell label
	    draw.SimpleText(
	        "SELL COKE",
	        "SnowDubz_Medium",
	        w/2, h/2 - 8,
	        col,
	        TEXT_ALIGN_CENTER,
	        TEXT_ALIGN_CENTER
	    )

	    -- Price preview
	    draw.SimpleText(
	        "⇢ " .. DarkRP.formatMoney(totalPay),
	        "SnowDubz_Small",
	        w/2, h/2 + 14,
	        outlineCol,
	        TEXT_ALIGN_CENTER,
	        TEXT_ALIGN_CENTER
	    )
	end

	sell.OnCursorEntered = function(s)
	    s.hover = true
	    surface.PlaySound("buttons/lightswitch2.wav")
	end

	sell.OnCursorExited = function(s)
	    s.hover = false
	end

	sell.DoClick = function()
	    net.Start("sellcoke")
	        net.WriteEntity(dealer)
	    net.SendToServer()
	    frame:Remove()
	end
end)
