CleanMinimap = LibStub("AceAddon-3.0"):NewAddon("CleanMinimap", "AceEvent-3.0")
CleanMinimap.title = "CleanMinimap"
local self = CleanMinimap
local shape = "SQUARE";

CleanMinimap.defaults = {
	profile = {
		UseSquare = true,
		ShowCoord = true,
		ShowZone = true,
		ShowDura = true,
		ShowTrack = true,
		ShowMail = true,
		Scale = 1,
		IconScale = 18,
	}
}

CleanMinimap.options = {
	name = "CleanMinimap",
	desc = self.notes,
	handler = CleanMinimap,
	type = 'group',
	args = {
		General = {
			name = "General Options",
			desc = '',
			order = 1,
			type = 'group',
			guiInline = true,
			args = {
				UseSquare = {
					type = 'toggle',
					name = "Use square minimap",
					desc = "Use the default square minimap.",
					get = "GetUseSquare",
					set = "SetUseSquare",
					width = 'full',
					order = 1,
				},
				ShowCoord = {
					type = 'toggle',
					name = "Show coordinates",
					desc = "Toggle the coordinates on the minimap.",
					get = "GetShowCoord",
					set = "SetShowCoord",
					width = 'full',
					order = 2,
				},
				ShowZone = {
					type = 'toggle',
					name = "Show zone header",
					desc = "Toggle the zone header on the minimap.",
					get = "GetShowZone",
					set = "SetShowZone",
					width = 'full',
					order = 3,
				},
				ShowDura = {
					type = 'toggle',
					name = "Show durability figure",
					desc = "Toggle the durability figure below the minimap.",
					get = "GetShowDura",
					set = "SetShowDura",
					width = 'full',
					order = 4,
				},
				ShowTrack = {
					type = 'toggle',
					name = "Show tracking icon",
					desc = "Toggle the tracking icon for herbs, minerals, and others.",
					get = "GetShowTrack",
					set = "SetShowTrack",
					width = 'full',
					order = 5,
				},
				ShowMail = {
					type = 'toggle',
					name = "Show mail icon",
					desc = "Toggle the mail icon visibility.",
					get = "GetShowMail",
					set = "SetShowMail",
					width = 'full',
					order = 6,
				},
				Scale = {
					type = 'range',
					name = "Minimap scale",
					desc = "Increases or decreases the size of the minimap.",
					max = 3,
					min = 0.1,
					step = 0.1,
					get = "GetScale",
					set = "SetScale",
					width = 'full',
					order = 7,
				},
				IconScale = {
					type = 'range',
					name = "Icon size",
					desc = "Increases or decreases the size of the default icons around the minimap.",
					max = 48,
					min = 6,
					step = 1,
					get = "GetIconScale",
					set = "SetIconScale",
					width = 'full',
					order = 8,
				},
			},
		},
	}
}

function GetMinimapShape()
	return shape;
end

local backdrop = {
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground", tile =true, tileSize =4,
	edgeFile = "Interface\\Addons\\CleanMinimap\\Texture\\Plain.tga", edgeSize = 4,
	insets = {left = 4, right = 4, top = 4, bottom = 4},
}

local backdropmail = {
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground", tile =true, tileSize =4,
	edgeFile = "Interface\\Addons\\CleanMinimap\\Texture\\Plain.tga", edgeSize = 4,
	insets = {left = 0, right = 0, top = 0,bottom = 0},
}

local CleanMinimapFrame = CreateFrame("Frame", nil, Minimap);
local loc, text, track;

function MessageCoords()
	if (UnitInRaid("player")) then
		SendChatMessage("My coordinate location is " .. text:GetText() .. ".", "RAID");
	elseif (GetNumPartyMembers() > 0) then
		SendChatMessage("My coordinate location is " .. text:GetText() .. ".", "PARTY");
	else
		SendChatMessage("My coordinate location is " .. text:GetText() .. ".", "SAY");
	end
end


function CleanMinimap:GetUseSquare()
	return self.db.profile.UseSquare
end
function CleanMinimap:SetUseSquare()
	self.db.profile.UseSquare = not self.db.profile.UseSquare
	if (self.db.profile.UseSquare) then
		MinimapBorder:Hide();
		shape = "SQUARE";
		Minimap:SetMaskTexture("Interface\\AddOns\\CleanMinimap\\texture\\Mask");
		CleanMinimapFrame:Show();
		loc:SetWidth(60);
		text:SetWidth(60);
		loc:SetPoint("BOTTOMLEFT", CleanMinimapFrame, "BOTTOMLEFT", 3, 3)
		if (self.db.profile.ShowZone) then
			MinimapBorderTop:Hide();
			MinimapZoneTextButton:Show()
		else
			MinimapBorderTop:Hide();
			MinimapZoneTextButton:Hide()
		end
		MinimapZoneTextButton:ClearAllPoints()
		MinimapZoneTextButton:SetHeight(21)
		MinimapZoneTextButton:SetPoint("BOTTOMLEFT", CleanMinimapFrame, "TOPLEFT", 0, 2)
		MinimapZoneTextButton:SetPoint("BOTTOMRIGHT", CleanMinimapFrame, "TOPRIGHT", 0, 2)
		MinimapZoneTextButton:SetBackdrop(backdrop)
		MinimapZoneTextButton:SetBackdropColor(0,0,0,0.2)
		MinimapZoneTextButton:SetBackdropBorderColor(0,0,0,0.6)
		if (TimeManagerClockButton) then
			TimeManagerClockButton:ClearAllPoints();
			TimeManagerClockButton:SetPoint("CENTER", Minimap, "CENTER", 0, -76);
		end
	else
		MinimapBorder:Show();
		shape = "CIRCULAR";
		Minimap:SetMaskTexture("Textures\\MinimapMask");
		CleanMinimapFrame:Hide();
		loc:SetWidth(CleanMinimapFrame:GetWidth());
		text:SetWidth(CleanMinimapFrame:GetWidth());
		loc:SetPoint("BOTTOMLEFT", CleanMinimapFrame, "BOTTOMLEFT", 0, 11)
		if (self.db.profile.ShowZone) then
			MinimapBorderTop:Show();
			MinimapZoneTextButton:Show()
		else
			MinimapBorderTop:Hide();
			MinimapZoneTextButton:Hide()
		end
		MinimapZoneTextButton:ClearAllPoints()
		MinimapZoneTextButton:SetHeight(12)
		MinimapZoneTextButton:SetPoint("CENTER", MinimapCluster, "CENTER", -3, 83)
		MinimapZoneTextButton:SetBackdrop(nil)
		MinimapZoneTextButton:SetBackdropColor(0,0,0,0)
		MinimapZoneTextButton:SetBackdropBorderColor(0,0,0,0)
		if (TimeManagerClockButton) then
			TimeManagerClockButton:ClearAllPoints();
			TimeManagerClockButton:SetPoint("CENTER", Minimap, "CENTER", 0, -68);
		end
	end
end
function CleanMinimap:GetShowCoord()
	return self.db.profile.ShowCoord
end
function CleanMinimap:SetShowCoord()
	self.db.profile.ShowCoord = not self.db.profile.ShowCoord
	if (self.db.profile.ShowCoord) then
		text:Show()
	else
		text:Hide()
	end
end
function CleanMinimap:GetShowZone()
	return self.db.profile.ShowZone
end
function CleanMinimap:SetShowZone()
	self.db.profile.ShowZone = not self.db.profile.ShowZone
	if (self.db.profile.UseSquare) then
		if (self.db.profile.ShowZone) then
			MinimapBorderTop:Hide();
			MinimapZoneTextButton:Show()
		else
			MinimapBorderTop:Hide();
			MinimapZoneTextButton:Hide()
		end
	else
		if (self.db.profile.ShowZone) then
			MinimapBorderTop:Show();
			MinimapZoneTextButton:Show()
		else
			MinimapBorderTop:Hide();
			MinimapZoneTextButton:Hide()
		end
	end
end

function CleanMinimap:GetShowDura()
	return self.db.profile.ShowDura
end
function CleanMinimap:SetShowDura()
	self.db.profile.ShowDura = not self.db.profile.ShowDura
	if (self.db.profile.ShowDura) then
		DurabilityFrame:Show()
		DurabilityFrame:RegisterEvent("UPDATE_INVENTORY_ALERTS")
	else
		DurabilityFrame:Hide()
		DurabilityFrame:UnregisterEvent("UPDATE_INVENTORY_ALERTS")
	end
end

function CleanMinimap:GetShowTrack()
	return self.db.profile.ShowTrack
end
function CleanMinimap:SetShowTrack()
	self.db.profile.ShowTrack = not self.db.profile.ShowTrack
	if (self.db.profile.ShowTrack) then
		MiniMapTracking:Show();
	else
		MiniMapTracking:Hide();
	end
end

function CleanMinimap:GetShowMail()
	return self.db.profile.ShowMail
end
function CleanMinimap:SetShowMail()
	self.db.profile.ShowMail = not self.db.profile.ShowMail
	if (self.db.profile.ShowMail) then
		MiniMapMailFrame:Show();
	else
		MiniMapMailFrame:Hide();
	end
end

function CleanMinimap:GetScale()
	if not self.db.profile then
		return 1
	end
	return self.db.profile.Scale or 1
end
function CleanMinimap:SetScale(table, size)
	self.db.profile.Scale = size
	MinimapCluster:SetScale(self.db.profile.Scale);
end
function CleanMinimap:GetIconScale()
	if not self.db.profile then
		return 18
	end
	return self.db.profile.IconScale or 18
end
function CleanMinimap:SetIconScale(table, size)
	self.db.profile.IconScale = size
	MiniMapTracking:SetHeight(self.db.profile.IconScale);
	MiniMapTracking:SetWidth(self.db.profile.IconScale);
	MiniMapTrackingIcon:SetHeight(self.db.profile.IconScale);
	MiniMapTrackingIcon:SetWidth(self.db.profile.IconScale);
	MiniMapTrackingButton:SetHeight(self.db.profile.IconScale + 8);
	MiniMapTrackingButton:SetWidth(self.db.profile.IconScale + 8);
	MiniMapMailFrame:SetHeight(self.db.profile.IconScale);
	MiniMapMailFrame:SetWidth(self.db.profile.IconScale);
	MiniMapMailIcon:SetHeight(self.db.profile.IconScale);
	MiniMapMailIcon:SetWidth(self.db.profile.IconScale);
	MiniMapBattlefieldFrame:SetHeight(self.db.profile.IconScale + 15);
	MiniMapBattlefieldFrame:SetWidth(self.db.profile.IconScale + 15);
	MiniMapBattlefieldIcon:SetHeight(self.db.profile.IconScale + 14);
	MiniMapBattlefieldIcon:SetWidth(self.db.profile.IconScale + 14);
end

function CleanMinimap:OnInitialize()
	CleanMinimap.db = LibStub("AceDB-3.0"):New("CleanMinimapDB", CleanMinimap.defaults)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("CleanMinimap", CleanMinimap.options, "cmm")
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("CleanMinimap", nil, nil)
	
--Restores the saved position of Minimap itself
	local x, y = self.db.profile.posx, self.db.profile.posy 
	if x and y then 
   		local scale = MinimapCluster:GetEffectiveScale() 
		MinimapCluster:ClearAllPoints() 
		MinimapCluster:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / scale, y / scale) 
    end
	
	--self:SetScript("OnEvent",self.OnEvent)
	CleanMinimapFrame:EnableMouseWheel(true)
	CleanMinimapFrame:SetScript("OnMouseWheel", function() self:Zoom() end)
	
	--Setting Up
	CleanMinimapFrame:ClearAllPoints()
	CleanMinimapFrame:EnableMouse(false)
	CleanMinimapFrame:SetPoint("TOPLEFT", Minimap, "TOPLEFT",-3,3)
	CleanMinimapFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT",3,-3)
	CleanMinimapFrame:SetBackdrop(backdrop)
	CleanMinimapFrame:SetBackdropColor(0,0,0,0)
	CleanMinimapFrame:SetBackdropBorderColor(0,0,0,0.6)

	--Coords button
	loc = CreateFrame("Button", nil, Minimap)
	loc:SetWidth(60)
	loc:SetHeight(16)
	loc:SetPoint("BOTTOMLEFT", CleanMinimapFrame, "BOTTOMLEFT", 3, 3)
	loc:SetScript("OnUpdate", function() CleanMinimap:UpdateCoords() end)
	loc:SetScript("OnClick", MessageCoords)

	text = loc:CreateFontString(nil, "OVERLAY","GameFontNormal")
	text:SetWidth(60)
	text:SetHeight(16)
	text:SetPoint("TOP", loc)
	text:SetJustifyH("CENTER")

	--Move zone button
	MinimapZoneTextButton:ClearAllPoints()
	MinimapZoneText:ClearAllPoints()
	MinimapZoneText:SetPoint("CENTER", MinimapZoneTextButton,"CENTER",0,1)
	if (self.db.profile.UseSquare) then
		MinimapZoneTextButton:ClearAllPoints()
		MinimapZoneTextButton:SetHeight(21)
		MinimapZoneTextButton:SetPoint("BOTTOMLEFT", CleanMinimapFrame, "TOPLEFT", 0, 2)
		MinimapZoneTextButton:SetPoint("BOTTOMRIGHT", CleanMinimapFrame, "TOPRIGHT", 0, 2)
		MinimapZoneTextButton:SetBackdrop(backdrop)
		MinimapZoneTextButton:SetBackdropColor(0,0,0,0.2)
		MinimapZoneTextButton:SetBackdropBorderColor(0,0,0,0.6)
		MinimapZoneTextButton:SetScript("OnClick", ToggleMinimap)
		MinimapBorder:Hide();
		shape = "SQUARE";
		Minimap:SetMaskTexture("Interface\\AddOns\\CleanMinimap\\texture\\Mask");
		CleanMinimapFrame:Show();
		loc:SetWidth(60);
		text:SetWidth(60);
		loc:SetPoint("BOTTOMLEFT", CleanMinimapFrame, "BOTTOMLEFT", 3, 3)
		if (self.db.profile.ShowZone) then
			MinimapBorderTop:Hide();
			MinimapZoneTextButton:Show();
		else
			MinimapBorderTop:Hide();
			MinimapZoneTextButton:Hide();
		end
	else
		MinimapZoneTextButton:ClearAllPoints()
		MinimapZoneTextButton:SetHeight(12)
		MinimapZoneTextButton:SetPoint("CENTER", MinimapCluster, "CENTER", -3, 83)
		MinimapZoneTextButton:SetBackdrop(nil)
		MinimapZoneTextButton:SetBackdropColor(0,0,0,0)
		MinimapZoneTextButton:SetBackdropBorderColor(0,0,0,0)
		MinimapBorder:Show();
		shape = "CIRCULAR";
		Minimap:SetMaskTexture("Textures\\MinimapMask");
		CleanMinimapFrame:Hide();
		loc:SetWidth(CleanMinimapFrame:GetWidth());
		text:SetWidth(CleanMinimapFrame:GetWidth());
		loc:SetPoint("BOTTOMLEFT", CleanMinimapFrame, "BOTTOMLEFT", 0, 11)
		if (self.db.profile.ShowZone) then
			MinimapBorderTop:Show();
			MinimapZoneTextButton:Show();
		else
			MinimapBorderTop:Hide();
			MinimapZoneTextButton:Hide();
		end
	end
	
-- Make map movable on alt 
    MinimapCluster:SetMovable(true) 
    Minimap:SetScript("OnMouseDown", function() 
        if(IsAltKeyDown()) then 
            MinimapCluster:ClearAllPoints() 
			MinimapCluster:StartMoving() 
        else 
            Minimap_OnClick(getglobal("Minimap")) 
        end 
    end)
    Minimap:SetScript("OnMouseUp", function() 
					MinimapCluster:StopMovingOrSizing()  
					local scale = MinimapCluster:GetEffectiveScale() 
					self.db.profile.posx = MinimapCluster:GetLeft() * scale 
					self.db.profile.posy = MinimapCluster:GetTop() * scale 
					end) 
	 	 
--Minimap extras clean up.
	MinimapZoomIn:Hide();
	MinimapZoomOut:Hide();
	--MinimapToggleButton:Hide();
	MiniMapWorldMapButton:Hide();
	GameTimeFrame:Hide();
	
	--Tracking Frame
	MiniMapTracking:SetHeight(self.db.profile.IconScale);
	MiniMapTracking:SetWidth(self.db.profile.IconScale);
	MiniMapTrackingIcon:SetHeight(self.db.profile.IconScale);
	MiniMapTrackingIcon:SetWidth(self.db.profile.IconScale);
	MiniMapTracking:ClearAllPoints();
	MiniMapTracking:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -10, 6);
	MiniMapTrackingBackground:Hide();
	MiniMapTrackingButtonBorder:Hide();
	MiniMapTrackingButton:SetHighlightTexture(nil);
	MiniMapTrackingButton:SetHeight(self.db.profile.IconScale + 8);
	MiniMapTrackingButton:SetWidth(self.db.profile.IconScale + 8);
	MiniMapTrackingButtonShine:SetHeight(self.db.profile.IconScale + 8);
	MiniMapTrackingButtonShine:SetWidth(self.db.profile.IconScale + 8);
	MiniMapTrackingButton:SetScript("OnMouseDown", function()
					MiniMapTrackingIcon:SetPoint("TOPLEFT", MiniMapTracking, "TOPLEFT", 8, -8);
					end)
	MiniMapTrackingButton:SetScript("OnMouseUp", function() 
					MiniMapTrackingIcon:SetPoint("TOPLEFT", MiniMapTracking, "TOPLEFT", 6, -6);
					end)
	
	--Mail Frame
	MiniMapMailFrame:SetHeight(self.db.profile.IconScale);
	MiniMapMailFrame:SetWidth(self.db.profile.IconScale);
	MiniMapMailIcon:SetHeight(self.db.profile.IconScale);
	MiniMapMailIcon:SetWidth(self.db.profile.IconScale);
	MiniMapMailFrame:ClearAllPoints();
	MiniMapMailFrame:SetPoint("TOPLEFT", MiniMapTracking, "BOTTOMLEFT", -1, -3);
	MiniMapMailBorder:Hide();
	
	--Battlefield Frame
	MiniMapBattlefieldFrame:SetHeight(self.db.profile.IconScale + 15);
	MiniMapBattlefieldFrame:SetWidth(self.db.profile.IconScale + 15);
	MiniMapBattlefieldIcon:SetHeight(self.db.profile.IconScale + 14);
	MiniMapBattlefieldIcon:SetWidth(self.db.profile.IconScale + 14);
	MiniMapBattlefieldFrame:ClearAllPoints();
	MiniMapBattlefieldFrame:SetPoint("TOPLEFT", MiniMapMailFrame, "BOTTOMLEFT", 1, -3);
	MiniMapBattlefieldBorder:Hide();

	if (self.db.profile.ShowCoord) then
		text:Show()
	else
		text:Hide()
	end
	if (self.db.profile.ShowDura) then
		DurabilityFrame:Show()
		DurabilityFrame:RegisterEvent("UPDATE_INVENTORY_ALERTS")
	else
		DurabilityFrame:Hide()
		DurabilityFrame:UnregisterEvent("UPDATE_INVENTORY_ALERTS")
	end
	if (self.db.profile.ShowTrack) then
		MiniMapTracking:Show();
	else
		MiniMapTracking:Hide();
	end
	MinimapCluster:SetScale(self.db.profile.Scale);

--Square Time
	
end

function CleanMinimap:OnEnable()
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
end

function CleanMinimap:OnDisable()
	self:UnregisterAllEvents()
end

--Event Handler
function CleanMinimap:PLAYER_LOGIN()
	SetMapToCurrentZone()
end

function CleanMinimap:ZONE_CHANGED_NEW_AREA()
	SetMapToCurrentZone()
end

--Mousewheel zoom
function CleanMinimap:Zoom()
    if not arg1 then return end
    if arg1 > 0 and Minimap:GetZoom() < 5 then
        Minimap:SetZoom(Minimap:GetZoom() + 1)
    elseif arg1 < 0 and Minimap:GetZoom() > 0 then
        Minimap:SetZoom(Minimap:GetZoom() - 1)
    end
end

--Coord update
function CleanMinimap:UpdateCoords()
    local x, y = GetPlayerMapPosition("player")
    text:SetText(string.format("%.1f,%.1f", 100*x, 100*y))
	if (self.db.profile.UseSquare) then
		Minimap:SetMaskTexture("Interface\\AddOns\\CleanMinimap\\texture\\Mask");
	else
		Minimap:SetMaskTexture("Textures\\MinimapMask");
	end
	if (self.db.profile.UseSquare and TimeManagerClockButton) then
		TimeManagerClockButton:ClearAllPoints();
		TimeManagerClockButton:SetPoint("CENTER", Minimap, "CENTER", 0, -76);
	elseif (TimeManagerClockButton) then
		TimeManagerClockButton:ClearAllPoints();
		TimeManagerClockButton:SetPoint("CENTER", Minimap, "CENTER", 0, -68);
	end
end
	