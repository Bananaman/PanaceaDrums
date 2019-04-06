local VERSION = tonumber(("$Rev: 32 $"):match("%d+"))

ccDrums = Rock:NewAddon("ccDrums", "LibRockDB-1.0", "LibRockEvent-1.0", "LibRockConsole-1.0", "LibRockConfig-1.0")
local ccDrums, self = ccDrums, ccDrums
ccDrums.version = "2.0-r" .. VERSION
ccDrums.revision = VERSION
ccDrums.date = ("$Date: 2008-07-29 09:00:27 +0200 (Di, 29 Jul 2008) $"):match("%d%d%d%d%-%d%d%-%d%d")

function ccDrums:ProvideVersion(revision, date)
	revision = tonumber(tostring(revision):match("%d+"))
	if revision > ccDrums.revision then
		ccDrums.version = "2.0-r" .. revision
		ccDrums.revision = revision
		ccDrums.date = date:match("%d%d%d%d%-%d%d%-%d%d")
	end
end



do
	local localeTables = {}
	function ccDrums:L(name, defaultTable)
		if not localeTables[name] then
			localeTables[name] = setmetatable(defaultTable or {}, {__index = function(self, key)
				self[key] = key
				return key
			end})
		end
		return localeTables[name]
	end
end

local localization = (GetLocale == "deDE") and {
	["foo"] = "bar",
} or {}

local L = ccDrums:L("ccDrums", localization)

local table_insert = table.insert
local table_remove = table.remove
local table_sort = table.sort
local table_concat = table.concat
local select = select
local geterrorhandler = geterrorhandler
local pairs = pairs
local type = type
local tostring = tostring
local ipairs = ipairs
local _G = _G
local UnitName = UnitName
local UnitExists = UnitExists
local GetRaidRosterInfo = GetRaidRosterInfo

ccDrums.Layouts = {}
ccDrums.Layout = nil

ccDrums:SetDatabase("ccDrumsDB")

do
	ccDrums:SetDatabaseDefaults('profile', {
		layout = "Simple Drum",
		layoutSettings = {},
		drumwatched = 29529,
	})
end

function ccDrums:OnInitialize()
	assert(self.Layouts, "Error, no Layouts not provided.")

	if not self.Layouts[self.db.profile.layout] then
		return
	end

	if not self:IsActive() then
		self:ToggleActive(true)
	end

	for k,v in pairs(self.Layouts) do
		if v.OnInitialize then
			v:OnInitialize()
		end
	end

	if not ccDrums.db.profile.scale then
		ccDrums.db.profile.scale = 1
	end

	if not self.db.profile.flashsize then
		self.db.profile.flashsize = 400
	end

	if not self.db.profile.flashspeed then
		self.db.profile.flashspeed = 0.1
	end

	if not ccDrums.db.profile.maxflashalpha then
		ccDrums.db.profile.maxflashalpha = 0.8
	end

	if not ccDrums.db.profile.screenflash then
		ccDrums.db.profile.screenflash = true
	end

	ccDrums.db.profile.locked = true
end

function ccDrums:OnEnable()
	ccDrums:SwitchLayout(ccDrums.db.profile.layout)

	self:AddEventListener("Blizzard", "COMBAT_LOG_EVENT_UNFILTERED")

	self:SetConfigTable(self.options)
	self:SetConfigSlashCommand("/ccDrums", "/ccd")
	self.options.extraArgs.active = nil
end

function ccDrums:COMBAT_LOG_EVENT_UNFILTERED(namespace, event, ...)
	local timestamp, event = ...
	if event ~= "SPELL_CAST_SUCCESS" then return end

	local _,_,_,drummer,_,_,_,_,spellid = ...
	local drum = self:GetDrumBySpellID(spellid)

	if not drum then return end

	local drummer = self:GetUnitID(drummer)

	self:Drum(drum, drummer)
end

function ccDrums:Drum(drum, drummer)
	if not drum or not drummer then return end

	if self.Layout.Drummed then
		self.Layout:Drummed(drum, drummer)
	end

	if drummer == "player" and self.db.profile.announceparty and GetNumPartyMembers() > 0 then
		local itemlink = select(2, GetItemInfo(drum.item))
		SendChatMessage(L["++ %s drummed, active for %d seconds!"]:format(itemlink, drum.duration), "PARTY")
	end
end

function ccDrums:DrumsFaded(drum, drummer)
	if drummer == "player" then
		if self.db.profile.announceparty and GetNumPartyMembers() > 0 then
			local itemlink = select(2, GetItemInfo(drum.item))
			SendChatMessage(L["-- %s faded, next now!"]:format(itemlink), "PARTY")
		end
	end
end

function ccDrums:DrumCDFinished(drum)
	if ccDrums.db.profile.screenflash then
		self:FlashDrum(drum)
	end
end

function ccDrums:GetUnitID(name)
	local num = GetNumPartyMembers()
	local prefix = "party"

	if name == UnitName("player") then
		return "player"
	end

	if GetNumRaidMembers() > 0 then
		num = GetNumRaidMembers()
		prefix = "raid"
	end

	for i=1, num, 1 do
		local uname = UnitName(prefix..i)
		if name:match(uname) then
			return prefix..i
		end
	end
end

function ccDrums:UnitInParty(unit)
	if UnitName(unit) == UnitName("player") then
		return true
	end

	if not UnitExists(unit) then
		return false
	end

	for i=1,GetNumPartyMembers(), 1 do
		local uname = UnitName("party"..i)
		if UnitName(unit):match(uname) then
			return true
		end
	end

	return false
end

function ccDrums:UnitInRaid(unit)
	if GetNumRaidMembers() == 0 then
		return false
	end

	if not UnitExists(unit) then
		return false
	end

	return true
end

function ccDrums:GetDrumWatched()
	return self.db.profile.drumwatched
end

function ccDrums:RegisterLayout(data)
	if not data.name then return end

	if self.Layouts[data.name] then
		return
	end

	self.Layouts[data.name] = data
end

function ccDrums:GetLayoutNamespace(layout)
	local name = layout

	if type(name) == "table" then
		name = name.name
	end

	if not self.db.profile.layoutSettings then
		self.db.profile.layoutSettings = {}
	end

	if not self.db.profile.layoutSettings[name] then
		self.db.profile.layoutSettings[name] = {}
	end

	return self.db.profile.layoutSettings[name]
end

function ccDrums:SwitchLayout(name)
	if not self.Layouts[name] then return end

	if self.Layout then
		self.Layout:Unload()
	end

	ccDrums.db.profile.layout = name
	ccDrums.Layout = self.Layouts[name]
	ccDrums.Layout:Load()
end