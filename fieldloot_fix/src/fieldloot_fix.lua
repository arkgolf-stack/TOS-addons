-- dofile("../data/test_addons/fieldloot_fix/addon_d.ipf/fieldloot_fix/fieldloot_fix.lua")
local addonName = "FIELDLOOT_FIX"
local author = "arkgolf"

_G["ADDONS"] = _G["ADDONS"] or {}
_G["ADDONS"][author] = _G["ADDONS"][author] or {}
_G["ADDONS"][author][addonName] = _G["ADDONS"][author][addonName] or {}
local g = _G["ADDONS"][author][addonName]

function FIELDLOOT_FIX_ON_INIT(addon, frame)
    if frame ~= nil then 
        frame:ShowWindow(0)
    end

    if _G["FIELDLOOT_ON_INIT"] and g.patched_official_init == nil then
        g.orig_FIELDLOOT_ON_INIT = _G["FIELDLOOT_ON_INIT"]
        
        _G["FIELDLOOT_ON_INIT"] = function(officialAddon, officialFrame, ...)
            g.orig_FIELDLOOT_ON_INIT(officialAddon, officialFrame, ...)

            local fl_module = _G["FIELDLOOT"]
            if fl_module and fl_module.settings then

                local is_enabled = true
                if _G["FIELDLOOT_IS_ENABLED"] then
                    is_enabled = _G["FIELDLOOT_IS_ENABLED"]()
                else
                    is_enabled = (fl_module.settings.enabled ~= false)
                end

                if not is_enabled then
                    local targetFrame = ui.GetFrame('fieldloot') or officialFrame
                    if targetFrame then
                        targetFrame:ShowWindow(0)
                    end
                    ui.CloseFrame('fieldloot_detail')

                    pcall(function()
                        collectgarbage("collect")
                    end)
                end
            end
        end
        g.patched_official_init = true
        CHAT_SYSTEM("[System][FieldLoot Fixer] Master Override Hook Active. Visibility bug patched.")
    end
end

_G["FIELDLOOT_FIX_ON_INIT"] = FIELDLOOT_FIX_ON_INIT
