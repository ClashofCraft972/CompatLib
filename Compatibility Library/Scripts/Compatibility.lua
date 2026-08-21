print("==================================")
print("--- Loading Compatibility Libs ---")
print("==================================")

dofile("$CONTENT_40639a2c-bb9f-4d4f-b88c-41bfe264ffa8/Scripts/ModDatabase.lua")
dofile("$SURVIVAL_DATA/Scripts/util.lua")


---@class CompatLib

ModDatabase.loadShapesets()

if CompatLib then return end

CompatLib = class()

if sm.localData == nil then
    sm.localData = {}
end

dofile("basicFunctions.lua")
