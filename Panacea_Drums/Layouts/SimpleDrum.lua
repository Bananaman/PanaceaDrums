local Panacea_Drums = Panacea_Drums

Panacea_Drums:ProvideVersion("$Rev: 10 $", "$Date: 2008-07-26 20:25:49 +0200 (Sa, 26 Jul 2008) $")

local SharedMedia = Rock("LibSharedMedia-3.0")

local table_insert = table.insert
local table_remove = table.remove

local Layout = {
	name = "Simple Drum",
	frame = nil,
}

local drummers = {}

function Layout:Drummed(drum, drummer)
	if Panacea_Drums:GetDrumWatched() ~= drum.item then return end

	if Panacea_Drums:UnitInParty(drummer) then
		local frame = self.frame

		local drummername = UnitName(drummer)

		local idx = 0
		for k, v in pairs(drummers) do
			if v:match(drummername) then
				idx = k
			end
		end

		for i=1, idx, 1 do
			table_remove(drummers, 1)
		end

		table_insert(drummers, drummername)

		frame:SetIcon(drum.texture)
		frame:SetCooldown(drum, drummer)

		local tex = ""
		for k,v in pairs(drummers) do
			tex = tex .. v .. "\n"
		end

		tex = tex:sub(1,-1)

		frame.toptext:SetText(tex)
	end
end

function Layout:OnInitialize()
	-- Get Settings
	self.settings = Panacea_Drums:GetLayoutNamespace(self)

	if not self.settings.fonts then
		self.settings.fonts = {}
	end

	if not self.settings.fonts.toptext then
		self.settings.fonts.toptext = SharedMedia:Fetch("font", "Adventure")
	end
	if not self.settings.fonts.toptextsize then
		self.settings.fonts.toptextsize = 10
	end

	if not self.settings.fonts.centertext then
		self.settings.fonts.centertext = SharedMedia:Fetch("font", "Adventure")
	end
	if not self.settings.fonts.centertextsize then
		self.settings.fonts.centertextsize = 15
	end

	if not self.settings.fonts.bottomtext then
		self.settings.fonts.bottomtext = SharedMedia:Fetch("font", "Adventure")
	end
	if not self.settings.fonts.bottomtextsize then
		self.settings.fonts.bottomtextsize = 10
	end
end

function Layout:Load()
	-- Set up Frame
	self.frame = Panacea_Drums:GetSingleFrame("SimpleDrum")

	self.frame:LoadPos()
	self.frame.mainframe:Show()
end

function Layout:Unload()
	Panacea_Drums:ReleaseFrame(self.frame)
	self.frame = nil
end

Panacea_Drums:RegisterLayout(Layout)
