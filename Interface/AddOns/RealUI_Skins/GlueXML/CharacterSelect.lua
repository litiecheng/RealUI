local _, private = ...

if not private.GlueXML then return end

-- Lua Globals --
local _G = _G
local next = _G.next

-- RealUI --
local Mod = private.Mod
local Skin = private.Skin
local debug = private.debug

_G.tinsert(private.GlueXML, function()
    _G.CharacterSelect:SetScale(private.uiScale)
    local DEFAULT_TEXT_OFFSET, MOVING_TEXT_OFFSET = 8, 16

    do --[[ CharacterName ]]--
        Mod.SetPoint(_G.CharSelectCharacterName)
        Skin.Font(_G.CharSelectCharacterName)
    end

    do --[[ Logo ]]--
        Mod.SetSize(_G.LogoHoist)

        Mod.SetSize(_G.CharacterSelectLogo)
        Mod.SetPoint(_G.CharacterSelectLogo)
    end

    do --[[ AccountUpgradeButton ]]--
        local self = _G.CharSelectAccountUpgradeButton
        Skin.GlueButton(self)
        self:SetSize(Mod.Value(191), Mod.Value(43))
        Mod.SetPoint(self)

        for i = 1, 2 do
            local tex = _G["CharSelectAccountUpgradeButtonChains"..i]
            tex:SetTexture("")
            Mod.SetSize(tex)
            Mod.SetPoint(tex)
        end

        self = _G.CharSelectAccountUpgradeButtonBorder
        self:SetTexture("")
        Mod.SetSize(self)
        Mod.SetPoint(self)
    end

    do --[[ CharSelectEnterWorldButton ]]--
        local self = _G.CharSelectEnterWorldButton
        Skin.GlueButton(self)
        self:SetSize(Mod.Value(173), Mod.Value(34))
        self:SetPoint("BOTTOM", 0, Mod.Value(46))
        self:SetScript("OnUpdate", nil)
    end

    do --[[ RotateButtons ]]--
        local rotateButtons = {
            Left = {"TOPRIGHT", "CharSelectEnterWorldButton", "BOTTOM", Mod.Value(-3), Mod.Value(-10)},
            Right = {"TOPLEFT", "CharacterSelectRotateLeft", "TOPRIGHT", Mod.Value(7), 0}
        }
        for side, anchors in next, rotateButtons do
            local self = _G["CharacterSelectRotate"..side]
            Skin.Button(self)
            self:SetSize(Mod.Value(24), Mod.Value(24))
            self:SetHitRectInsets(0, 0, 0, 0)
            self:ClearAllPoints()
            self:SetPoint(anchors[1], anchors[2], anchors[3], anchors[4], anchors[5])

            local arrow = Skin.CreateArrow(side, self)
            arrow:SetPoint("TOPLEFT", Mod.Value(4), Mod.Value(-6))
            arrow:SetPoint("BOTTOMRIGHT", Mod.Value(-4), Mod.Value(6))
        end
    end

    do --[[ CharacterSelectBackButton ]]--
        local self = _G.CharacterSelectBackButton
        Skin.GlueButton(self)
        self:SetSize(Mod.Value(90), Mod.Value(20))
        self:ClearAllPoints()
        self:SetPoint("TOPRIGHT", _G.CharacterSelectCharacterFrame, "BOTTOMRIGHT", 0, Mod.Value(-10))
        self:SetScript("OnUpdate", nil)
    end

    do --[[ CharacterSelectMenuButton ]]--
        local self = _G.CharacterSelectMenuButton
        Skin.GlueButton(self)
        self:SetSize(Mod.Value(128), Mod.Value(20))
        self:ClearAllPoints()
        self:SetPoint("BOTTOMLEFT", Mod.Value(40), Mod.Value(7))
        self:SetScript("OnUpdate", nil)
    end

    do --[[ CharacterSelectAddonsButton ]]--
        local self = _G.CharacterSelectAddonsButton
        Skin.GlueButton(self)
        self:SetSize(Mod.Value(128), Mod.Value(20))
        self:ClearAllPoints()
        self:SetPoint("BOTTOMLEFT", _G.CharacterSelectMenuButton, "TOPLEFT", 0, Mod.Value(7))
        self:SetScript("OnUpdate", nil)
    end

    do --[[ StoreButton ]]--
        local self = _G.StoreButton
        Skin.UIPanelGoldButton(self)
        self:SetSize(Mod.Value(128), Mod.Value(26))
        self:ClearAllPoints()
        self:SetPoint("BOTTOMLEFT", _G.CharacterSelectAddonsButton, "TOPLEFT", 0, Mod.Value(13))
        self:SetScript("OnUpdate", nil)

        Mod.SetSize(self.Logo)
    end

    do --[[ CopyCharacterButton ]]--
        local self = _G.CopyCharacterButton
        Skin.GlueButton(self)
        self:SetSize(Mod.Value(164), Mod.Value(40))
        Mod.SetPoint(self)
    end

    do --[[ CharacterSelectDeleteButton ]]--
        local self = _G.CharacterSelectDeleteButton
        Skin.GlueButton(self)
        self:ClearAllPoints()
        self:SetPoint("TOPLEFT", _G.CharacterSelectCharacterFrame, "BOTTOMLEFT", 0, Mod.Value(-10))
        self:SetPoint("BOTTOMRIGHT", _G.CharacterSelectBackButton, "BOTTOMLEFT", Mod.Value(-15), 0)
        self:SetScript("OnUpdate", nil)
    end

    do --[[ CharacterSelectCharacterFrame ]]--
        local self = _G.CharacterSelectCharacterFrame
        Skin.Backdrop(self)
        self:SetPoint("TOPRIGHT", Mod.Value(-8), Mod.Value(-18))

        Skin.Font(_G.CharSelectRealmName)
        Mod.SetPoint(_G.CharSelectRealmName)
        _G.CharSelectRealmName:SetHeight(Mod.Value(7))
        Skin.Font(_G.CharSelectUndeleteLabel)
        Mod.SetPoint(_G.CharSelectUndeleteLabel)

        Skin.GlueButton(_G.CharSelectChangeRealmButton)
        _G.CharSelectChangeRealmButton:SetPoint("TOP", _G.CharSelectRealmName, "BOTTOM", 0, Mod.Value(-9))
        _G.CharSelectChangeRealmButton:SetSize(Mod.Value(120), Mod.Value(18))
        _G.CharSelectChangeRealmButton:SetScript("OnUpdate", nil)

        local prevBtn
        local function OnEnter(btn)
            btn:SetBackdropBorderColor(btn.rUIColor.r, btn.rUIColor.g, btn.rUIColor.b, 1)
        end
        local function OnLeave(btn)
            if not (btn.upButton:IsMouseOver() or btn.downButton:IsMouseOver()) then
                btn:SetBackdropBorderColor(0, 0, 0, 0)
            end
        end
        local moveButtons = {
            up = {"TOPRIGHT", Mod.Value(-3), Mod.Value(-3)},
            down = {"BOTTOMRIGHT", Mod.Value(-3), Mod.Value(3)}
        }
        for i = 1, _G.MAX_CHARACTERS_DISPLAYED do
            self = _G["CharSelectCharacterButton"..i]
            self:SetSize(Mod.Value(231), Mod.Value(52))
            self:SetHitRectInsets(0, 0, 0, 0)
            self:ClearAllPoints()
            if i == 1 then
                self:SetPoint("TOPLEFT", Mod.Value(9), Mod.Value(-64))
            else
                self:SetPoint("TOPLEFT", prevBtn, "BOTTOMLEFT", 0, Mod.Value(-5))
            end

            self.selection:SetTexture("")
            self:SetHighlightTexture("")
            Skin.Backdrop(self)
            self:SetBackdropBorderColor(0, 0, 0, 0)

            for _, name in next, {"name", "Info", "Location"} do
                local font = self.buttonText[name]
                Skin.Font(font)
                if name == "name" then
                    font:SetPoint("TOPLEFT", Mod.Value(DEFAULT_TEXT_OFFSET), Mod.Value(-3))
                else
                    Mod.SetPoint(font)
                    Mod.SetSize(font)
                end
            end

            for dir, anchors in next, moveButtons do
                local btn = self[dir.."Button"]
                Skin.Button(btn)
                btn:SetSize(Mod.Value(22), Mod.Value(22))
                btn:SetPoint(anchors[1], anchors[2], anchors[3])
                local arrow = Skin.CreateArrow(dir, btn)
                arrow:SetPoint("TOPLEFT", Mod.Value(5), Mod.Value(-8))
                arrow:SetPoint("BOTTOMRIGHT", Mod.Value(-5), Mod.Value(8))
            end

            self:HookScript("OnEnter", OnEnter)
            self:HookScript("OnLeave", OnLeave)

            local charSvc = _G["CharSelectPaidService"..i]
            Skin.Button(charSvc)
            charSvc:HookScript("OnEnter", OnEnter)
            charSvc:ClearAllPoints()
            charSvc:SetPoint("RIGHT", self, "LEFT", Mod.Value(-12), 0)
            charSvc:SetSize(Mod.Value(43), Mod.Value(43))
            charSvc.VASIcon:ClearAllPoints()
            charSvc.VASIcon:SetPoint("TOPLEFT", 1, -1)
            charSvc.VASIcon:SetPoint("BOTTOMRIGHT", -1, 1)
            charSvc.VASIcon:SetTexCoord(.08, .92, .08, .92)
            charSvc.GoldBorder:SetTexture("")
            prevBtn = self
        end
    end

    _G.hooksecurefunc("CharacterSelectButton_OnDragStart", function(self)
        self.buttonText.name:SetPoint("TOPLEFT", Mod.Value(MOVING_TEXT_OFFSET), Mod.Value(-3));
    end)
    _G.hooksecurefunc("CharacterSelectButton_OnDragStop", function(self)
        for index = 1, _G.MAX_CHARACTERS_DISPLAYED do
            local button = _G["CharSelectCharacterButton"..index];
            button.buttonText.name:SetPoint("TOPLEFT", Mod.Value(DEFAULT_TEXT_OFFSET), Mod.Value(-3));
        end
    end)

    local bdAlpha, bdMod = private.bdInfo[1], private.bdInfo[2]
    _G.hooksecurefunc("UpdateCharacterSelection", function(self)
        debug("UpdateCharacterSelection")
        for key, value in next, self do
            debug(key, value)
        end
        local charID = _G.GetCharIDFromIndex(self.selectedIndex)
        debug("charID", charID)
        debug("GetCharacterInfo", _G.GetCharacterInfo(charID))
        debug("GetIndexFromCharID", _G.GetIndexFromCharID(charID))
        local _, _, _, class = _G.GetCharacterInfo(charID)
        private.classColor = _G.RAID_CLASS_COLORS[class]

        local resetColor = self.orderChanged or self.currentBGTag ~= _G.GetSelectBackgroundModel(charID)
        for index = 1, _G.math.min(_G.GetNumCharacters(), _G.MAX_CHARACTERS_DISPLAYED) do
            local button = _G["CharSelectCharacterButton"..index]
            if not button.rUIColor or resetColor then
                local btnCharID = _G.GetCharIDFromIndex(index + _G.CHARACTER_LIST_OFFSET)
                local _, _, _, btnClass = _G.GetCharacterInfo(btnCharID)
                button.rUIColor = _G.RAID_CLASS_COLORS[btnClass]
                _G["CharSelectPaidService"..index].rUIColor = button.rUIColor
            end
            if button.selection:IsShown() and button.rUIColor then
                button:SetBackdropColor(button.rUIColor.r * bdMod, button.rUIColor.g * bdMod, button.rUIColor.b * bdMod, bdAlpha)
            else
                button:SetBackdropColor(0, 0, 0, 0)
            end
            if button:IsMouseOver() and button.rUIColor then
                button:SetBackdropBorderColor(button.rUIColor.r, button.rUIColor.g, button.rUIColor.b, 1)
            else
                button:SetBackdropBorderColor(0, 0, 0, 0)
            end
        end
    end)

    _G.hooksecurefunc("UpdateCharacterList", function(skipSelect)
        local self = _G.CharacterSelectCharacterFrame
        if self.scrollBar:IsShown() then
            self:SetPoint("BOTTOMLEFT", _G.CharacterSelectUI, "BOTTOMRIGHT", Mod.Value(-278), Mod.Value(50))
        else
            self:SetPoint("BOTTOMLEFT", _G.CharacterSelectUI, "BOTTOMRIGHT", Mod.Value(-258), Mod.Value(50))
        end
        for index = 1, _G.math.min(_G.GetNumCharacters(), _G.MAX_CHARACTERS_DISPLAYED) do
            local button = _G["CharSelectCharacterButton"..index]
            if ( _G.CharacterSelect.draggedIndex ) then
                if ( _G.CharacterSelect.draggedIndex == button.index ) then
                    button.buttonText.name:SetPoint("TOPLEFT", Mod.Value(MOVING_TEXT_OFFSET), Mod.Value(-3));
                else
                    button.buttonText.name:SetPoint("TOPLEFT", Mod.Value(DEFAULT_TEXT_OFFSET), Mod.Value(-3));
                end
            end
        end
    end)
end)

_G.tinsert(private.DebugXML, function()
    -- These are frames that wouldn't typically be shown for players
    do --[[ PlayersOnServer ]]--
        local self = _G.PlayersOnServer
        local connected = _G.IsConnectedToServer()
        debug("IsConnectedToServer", connected)
        if (not connected) then
            self:Hide()
            return
        end
        
        local numHorde, numAlliance = 5, 20
        self.HordeCount:SetText(numHorde)
        self.AllianceCount:SetText(numAlliance)
        self.HordeStar:SetShown(numHorde < numAlliance)
        self.AllianceStar:SetShown(numAlliance < numHorde)
        self:Show()
    end
end)
