---@class DragonflightUI
---@diagnostic disable-next-line: assign-type-mismatch
local DF = LibStub('AceAddon-3.0'):GetAddon('DragonflightUI')
DF.Compatibility = {}

if C_AddOns and C_AddOns.IsAddOnLoaded then
    function DF:IsAddOnLoaded(...)
        return C_AddOns.IsAddOnLoaded(...)
    end
else
    function DF:IsAddOnLoaded(...)
        return IsAddOnLoaded(...)
    end
end

if C_AddOns and C_AddOns.LoadAddOn then
    function DF:LoadAddOn(...)
        return C_AddOns.LoadAddOn(...)
    end
else
    function DF:LoadAddOn(...)
        return LoadAddOn(...)
    end
end

-- C_CVar compatibility for 3.3.5a
if not C_CVar then
    C_CVar = {}
    
    function C_CVar.GetCVar(cvar)
        return GetCVar(cvar)
    end
    
    function C_CVar.GetCVarBool(cvar)
        return GetCVarBool(cvar)
    end
    
    function C_CVar.SetCVar(cvar, value)
        return SetCVar(cvar, value)
    end
end

-- C_Container compatibility for 3.3.5a
if not C_Container then
    C_Container = {}
    
    function C_Container.GetContainerNumSlots(bagID)
        return GetContainerNumSlots(bagID)
    end
    
    function C_Container.GetContainerItemInfo(bagID, slot)
        local icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue, itemID = GetContainerItemInfo(bagID, slot)
        return {
            iconFileID = icon,
            stackCount = itemCount,
            isLocked = locked,
            quality = quality,
            isReadable = readable,
            hasLoot = lootable,
            hyperlink = itemLink,
            isFiltered = isFiltered,
            hasNoValue = noValue,
            itemID = itemID
        }
    end
    
    function C_Container.GetItemCooldown(bagID, slot)
        return GetContainerItemCooldown(bagID, slot)
    end
end

function DF.Compatibility:FuncOrWaitframe(addon, func)
    if DF:IsAddOnLoaded(addon) then
        -- print('Module:FuncOrWaitframe(addon,func)', addon, 'ISLOADED')
        func()
    else
        local waitFrame = CreateFrame("FRAME")
        waitFrame:RegisterEvent("ADDON_LOADED")
        waitFrame:SetScript("OnEvent", function(self, event, arg1)
            if arg1 == addon then
                -- print('Module:FuncOrWaitframe(addon,func)', addon, 'WAITFRAME')
                func()
                waitFrame:UnregisterAllEvents()
            end
        end)
    end
end

-- @TODO
local novaLoaded = DF:IsAddOnLoaded('NovaWorldBuffs')
-- print('Nova loaded: ', novaLoaded)
if novaLoaded then if _G['MinimapLayerFrame'] then _G['MinimapLayerFrame']:SetPoint('BOTTOM', 0, 4) end end
