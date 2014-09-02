local nibRealUI = LibStub("AceAddon-3.0"):GetAddon("nibRealUI")

local MODNAME = "UnitFrames"
local UnitFrames = nibRealUI:GetModule(MODNAME)
local AngleStatusBar = nibRealUI:GetModule("AngleStatusBar")
local db, ndb, ndbc

local oUF = oUFembed

local coords = {
    [1] = {
        health = {0.1328125, 1, 0.1875, 1},
        power = {0.23046875, 1, 0, 0.5},
    },
    [2] = {
        health = {0.494140625, 1, 0.0625, 1},
        power = {0.1015625, 1, 0, 0.625},
    },
}

local function CreateHealthBar(parent)
    local texture = UnitFrames.textures[UnitFrames.layoutSize].F1.health
    local coords = coords[UnitFrames.layoutSize].health
    local health = CreateFrame("Frame", nil, parent)
    health:SetPoint("TOPRIGHT", parent, 0, 0)
    health:SetSize(texture.width, texture.height)

    health.bar = AngleStatusBar:NewBar(health, -2, -1, texture.width - 17, texture.height - 2, "LEFT", "LEFT", "LEFT", true)

    health.bg = health:CreateTexture(nil, "BACKGROUND")
    health.bg:SetTexture(texture.bar)
    health.bg:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
    health.bg:SetVertexColor(0, 0, 0, 0.4)
    health.bg:SetAllPoints(health)

    health.border = health:CreateTexture(nil, "BORDER")
    health.border:SetTexture(texture.border)
    health.border:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
    health.border:SetAllPoints(health)

    health.text = health:CreateFontString(nil, "OVERLAY")
    health.text:SetPoint("BOTTOMRIGHT", health, "TOPRIGHT", 2, 2)
    health.text:SetFont(unpack(nibRealUI:Font()))
    parent:Tag(health.text, "[realui:health]")

    health.Override = UnitFrames.HealthOverride
    return health
end

local function CreatePowerBar(parent)
    local texture = UnitFrames.textures[UnitFrames.layoutSize].F1.power
    local coords = coords[UnitFrames.layoutSize].power
    local power = CreateFrame("Frame", nil, parent)
    power:SetPoint("BOTTOMRIGHT", parent, -5, 0)
    power:SetSize(texture.width, texture.height)

    power.bar = AngleStatusBar:NewBar(power, -9, -1, texture.width - 17, texture.height - 2, "RIGHT", "RIGHT", "LEFT", true)

    ---[[
    power.bg = power:CreateTexture(nil, "BACKGROUND")
    power.bg:SetTexture(texture.bar)
    power.bg:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
    power.bg:SetVertexColor(0, 0, 0, 0.4)
    power.bg:SetAllPoints(power)
    ---]]

    power.border = power:CreateTexture(nil, "BORDER")
    power.border:SetTexture(texture.border)
    power.border:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
    power.border:SetAllPoints(power)

    power.text = power:CreateFontString(nil, "OVERLAY")
    power.text:SetPoint("TOPRIGHT", power, "BOTTOMRIGHT", 2, -3)
    power.text:SetFont(unpack(nibRealUI:Font()))
    parent:Tag(power.text, "[realui:power]")

    power.frequentUpdates = true
    power.Override = UnitFrames.PowerOverride
    return power
end

local function CreatePvPStatus(parent)
    local texture = UnitFrames.textures[UnitFrames.layoutSize].F1.healthBox
    local pvp = parent:CreateTexture(nil, "OVERLAY", nil, 1)
    pvp:SetTexture(texture.bar)
    pvp:SetSize(texture.width, texture.height)
    pvp:SetPoint("TOPRIGHT", parent, -8, -1)

    local border = parent:CreateTexture(nil, "OVERLAY", nil, 3)
    border:SetTexture(texture.border)
    border:SetAllPoints(pvp)

    pvp.Override = function(self, event, unit)
        --print("PvP Override", self, event, unit, IsPVPTimerRunning())
        pvp:SetVertexColor(0, 0, 0, 0.6)
        if UnitIsPVP(unit) then
            if UnitIsFriend(unit, "player") then
                self.PvP:SetVertexColor(unpack(db.overlay.colors.status.pvpFriendly))
            else
                self.PvP:SetVertexColor(unpack(db.overlay.colors.status.pvpEnemy))
            end
        end
    end
    return pvp
end

local function CreateCombatResting(parent)
    local texture = UnitFrames.textures[UnitFrames.layoutSize].F1.statusBox
    -- Combat status has priority so we'll use the BG as its base
    local combat = parent:CreateTexture(nil, "BORDER")
    combat:SetTexture(texture.bar)
    combat:SetSize(texture.width, texture.height)
    combat:SetPoint("TOPRIGHT", parent, "TOPLEFT", 8, 0)

    -- Resting is second priority, so we use the border then change the BG in Override.
    local resting = parent:CreateTexture(nil, "OVERLAY", nil, 3)
    resting:SetTexture(texture.border)
    resting:SetAllPoints(combat)

    local combatColor = db.overlay.colors.status.combat
    combat.Override = function(self, event, unit)
        if event == "PLAYER_REGEN_DISABLED" then
            print("Combat Override", self, event, unit)
            self.Combat:SetVertexColor(combatColor[1], combatColor[2], combatColor[3], combatColor[4])
            self.Combat.isCombat = true
        elseif event == "PLAYER_REGEN_ENABLED" then
            print("Combat Override", self, event, unit)
            self.Combat:SetVertexColor(0, 0, 0, 0.6)
            self.Combat.isCombat = false
            self.Resting.Override(self, event, unit)
        end
    end
    
    local restColor = db.overlay.colors.status.resting
    resting.Override = function(self, event, unit)
        if self.Combat.isCombat then return end
        print("Resting Override", self, event, unit)
        self.Combat:SetVertexColor(restColor[1], restColor[2], restColor[3], restColor[4])
    end
    
    return combat, resting
end

local function CreatePlayer(self)
    self.Health = CreateHealthBar(self)
    self.Power = CreatePowerBar(self)
    self.PvP = CreatePvPStatus(self.Health)
    self.Combat, self.Resting = CreateCombatResting(self.Power)

    self.PvP.text = self:CreateFontString(nil, "OVERLAY")
    self.PvP.text:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 15, 2)
    self.PvP.text:SetFont(unpack(nibRealUI:Font()))
    self.PvP.text:SetJustifyH("LEFT")
    self.PvP.text.frequentUpdates = 1
    self:Tag(self.PvP.text, "[realui:pvptimer]")


    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    self:SetSize(self.Health:GetWidth(), self.Health:GetHeight() + self.Power:GetHeight() + 3)
end

-- Init
tinsert(UnitFrames.units, function(...)
    db = UnitFrames.db.profile
    ndb = nibRealUI.db.profile
    ndbc = nibRealUI.db.char

    oUF:RegisterStyle("RealUI:player", CreatePlayer)
    oUF:SetActiveStyle("RealUI:player")
    local player = oUF:Spawn("player", "RealUIPlayerFrame")
    player:SetPoint("RIGHT", "RealUIPositionersUnitFrames", "LEFT", db.positions[UnitFrames.layoutSize].player.x, db.positions[UnitFrames.layoutSize].player.y)
end)
