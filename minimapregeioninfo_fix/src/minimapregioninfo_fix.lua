-- dofile("../data/test_addons/minimapregioninfo_fix/addon_d.ipf/minimapregioninfo_fix/minimapregioninfo_fix.lua")
local addonName = "MINIMAP_REGION_FIX"
local author = "arkgolf"

_G["ADDONS"] = _G["ADDONS"] or {}
_G["ADDONS"][author] = _G["ADDONS"][author] or {}
_G["ADDONS"][author][addonName] = _G["ADDONS"][author][addonName] or {}
local g = _G["ADDONS"][author][addonName]

function MINIMAP_REGION_FIX_ON_INIT(addon, frame)
    if frame ~= nil then 
        frame:ShowWindow(0) 
    end

    if _G["MINIMAP_REGION_INFO_SYNC_LAYOUT"] and g.patched_official_layout == nil then
        g.orig_MINIMAP_REGION_INFO_SYNC_LAYOUT = _G["MINIMAP_REGION_INFO_SYNC_LAYOUT"]
        
        _G["MINIMAP_REGION_INFO_SYNC_LAYOUT"] = function(displayMode, ...)
            local info_module = _G["MINIMAP_REGION_INFO"]
            local is_enabled = true
            
            if _G["MINIMAP_REGION_INFO_IS_ENABLED"] then
                is_enabled = _G["MINIMAP_REGION_INFO_IS_ENABLED"]()
            elseif info_module and info_module.settings then
                is_enabled = (info_module.settings.enabled ~= false)
            end

            if not is_enabled then
                local railFrame = ui.GetFrame('minimap_region_info')
                local panelFrame = ui.GetFrame('minimap_region_info_detail')
                
                if railFrame then railFrame:ShowWindow(0) end
                if panelFrame then panelFrame:ShowWindow(0) end

                pcall(function()
                    collectgarbage("collect")
                end)
                return 
            end

            return g.orig_MINIMAP_REGION_INFO_SYNC_LAYOUT(displayMode, ...)
        end
        g.patched_official_layout = true
        CHAT_SYSTEM("[System][Minimap Region Fixer] Master Override Hook Active. Visibility bug patched.")
    end
end

_G["MINIMAP_REGION_FIX_ON_INIT"] = MINIMAP_REGION_FIX_ON_INIT
