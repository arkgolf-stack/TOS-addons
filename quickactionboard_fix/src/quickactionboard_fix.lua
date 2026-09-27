-- dofile("../data/test_addons/quickactionboard_fix/addon_d.ipf/quickactionboard_fix/quickactionboard_fix.lua")
local addonName = "QUICKACTION_FIX"
local author = "arkgolf"

_G["ADDONS"] = _G["ADDONS"] or {}
_G["ADDONS"][author] = _G["ADDONS"][author] or {}
_G["ADDONS"][author][addonName] = _G["ADDONS"][author][addonName] or {}
local g = _G["ADDONS"][author][addonName]

function QUICKACTION_FIX_ON_INIT(addon, frame)
    if frame ~= nil then 
        frame:ShowWindow(0) 
    end

    if _G["QUICKACTIONBOARD_REBUILD_BOARDS"] and g.patched_board_rebuild == nil then
        g.orig_QUICKACTIONBOARD_REBUILD_BOARDS = _G["QUICKACTIONBOARD_REBUILD_BOARDS"]
        
        _G["QUICKACTIONBOARD_REBUILD_BOARDS"] = function(...)
            local qab_module = _G["QUICKACTIONBOARD"]
            local is_enabled = true
            local is_global_visible = true
            
            if _G["QUICKACTIONBOARD_IS_ENABLED"] then
                is_enabled = _G["QUICKACTIONBOARD_IS_ENABLED"]()
            elseif qab_module and qab_module.data then
                is_enabled = (qab_module.data.enabled == true)
            end
            
            if qab_module and qab_module.data then
                is_global_visible = (qab_module.data.globalVisible ~= false)
            end

            if not is_enabled or not is_global_visible then
                if qab_module and type(qab_module.frameNames) == "table" then
                    for _, frameName in ipairs(qab_module.frameNames) do
                        local targetFrame = ui.GetFrame(frameName)
                        if targetFrame then
                            targetFrame:ShowWindow(0)
                        end
                    end
                end

                local managerFrame = ui.GetFrame("quickactionboard")
                if managerFrame then managerFrame:ShowWindow(0) end
                
                if _G["QUICKACTIONBOARD_SYNC_GLOBAL_BUTTON"] then
                    pcall(_G["QUICKACTIONBOARD_SYNC_GLOBAL_BUTTON"])
                end

                pcall(function()
                    collectgarbage("collect")
                end)
                
                if not is_enabled then
                    return 
                end
            end

            return g.orig_QUICKACTIONBOARD_REBUILD_BOARDS(...)
        end
        g.patched_board_rebuild = true
        CHAT_SYSTEM("[System][QuickAction Fixer] Master Override Hook Active. Action board persistence patched.")
    end
end

_G["QUICKACTION_FIX_ON_INIT"] = QUICKACTION_FIX_ON_INIT
