-- dofile("../data/test_addons/global_ram_cleaner/addon_d.ipf/global_ram_cleaner/global_ram_cleaner.lua")
local addonName = "GLOBAL_RAM_CLEANER"
local author = "arkgolf"

_G["ADDONS"] = _G["ADDONS"] or {}
_G["ADDONS"][author] = _G["ADDONS"][author] or {}
_G["ADDONS"][author][addonName] = _G["ADDONS"][author][addonName] or {}
local g = _G["ADDONS"][author][addonName]

g.last_flush_time = 0

function GLOBAL_RAM_CLEANER_ON_TIMER(frame, timer, argStr, argNum, passedTime)
    local now = imcTime.GetAppTime()
    if now > (g.last_flush_time + 20) then
        g.last_flush_time = now
        pcall(function()
            collectgarbage("collect")
        end)
    end
    return 1
end

function GLOBAL_RAM_CLEANER_ON_INIT(addon, frame)
    if frame == nil then return end
    frame:ShowWindow(0)
    
    local timer = GET_CHILD_RECURSIVELY(frame, "addontimer", "ui::CAddOnTimer") or frame:CreateOrGetControl("addontimer", "addontimer", 0, 0, 10, 10)
    tolua.cast(timer, "ui::CAddOnTimer")
    timer:SetUpdateScript("GLOBAL_RAM_CLEANER_ON_TIMER")
    timer:Start(1.0) 
end

_G["GLOBAL_RAM_CLEANER_ON_INIT"] = GLOBAL_RAM_CLEANER_ON_INIT
