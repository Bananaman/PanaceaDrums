local ccDrums = ccDrums

ccDrums:ProvideVersion("$Rev: 24 $", "$Date: 2008-07-27 08:59:17 +0200 (So, 27 Jul 2008) $")

if IsAddOnLoaded("ButtonFacade") then

	local LBF = LibStub("LibButtonFacade",true)
	ccDrums.LBFGroup = LBF:Group("ccDrums", "ccDrumsBar")

	function ccDrums:AddLBF(frame)
		self.LBFGroup:AddButton(frame.mainframe)
	end
else
	function ccDrums:AddLBF(frame)
	end
end