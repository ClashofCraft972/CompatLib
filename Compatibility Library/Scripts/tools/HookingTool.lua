dofile('../Compatibility.lua')
dofile('$SURVIVAL_DATA/Scripts/util.lua')

print("Loading Compatlib's Hooking tool")

---@class HookingTool
HookingTool = class()



function HookingTool:server_onCreate()

    local function createSMCompatibility(  )
        print('Compiling CompatLib data')
        sm.localData = sm.json.open('$CONTENT_8ec0b0e1-b0ab-4f34-ae1c-59ad47c6e5ec/Scripts/Databases/vanillaObjects.json')
        ModDatabase.loadShapesets()
        sm.localData.ModsIds = ModDatabase.getAllLoadedMods()

        local function contains(list, value)
            for _, v in ipairs(list) do
                if v == value then
                    return true
                end
            end
            return false
        end

        local function grabUuidInSets(sets)
            for set, setData in pairs(sets) do
                if #setData > 0 then
                    return setData[1]
                end
            end
        end

        local function loadLocalSets()
                OperationList = {
                    {Load = "loadShapesets", type = "shape"},
                    {Load = "loadToolsets", type = "tool"},
                    {Load = "loadHarvestablesets", type = "harvestable"},
                    {Load = "loadKinematicsets", type = "kinematic"},
                    {Load = "loadCharactersets", type = "character"},
                    {Load = "loadScriptableobjectsets", type = "scriptableobject"}
                }
                for _, subList in pairs(OperationList) do
                    ModDatabase[subList.Load]()
                    local sets = ModDatabase.databases[subList.type.."sets"]
                    for localID, modSets in pairs(sets) do
                        if contains(sm.localData.ModsIds, localID) then
                            for setPath, setData in pairs(modSets) do
                                for _, ObjectUuid in ipairs(setData) do
                                    sm.localData.set[ObjectUuid] = { ModId=localID, setPath = setPath, type = subList.type }
                                end
                            end
                        end
                    end
                    ModDatabase["un"..subList.Load]()
                end
        end
        loadLocalSets()

        local function loadLocalTags()
        for _, modId in ipairs(sm.localData.ModsIds) do
                local tagPath = tostring("$CONTENT_"..modId.."/CompatLib/tags.json")
                if sm.json.fileExists(tagPath) then
                    local modTag = sm.json.open(tagPath)
                    for tagName, objectList in pairs(modTag) do
                        if sm.localData.tags[tagName] == nil then
                            sm.localData.tags[tagName] = {}
                        end
                        for object, data in pairs(objectList) do
                            sm.localData.tags[tagName][object] = data
                            if sm.localData.set[object].tags == nil then
                                sm.localData.set[object].tags = {}
                            end
                            sm.localData.set[object].tags[tagName] = data
                        end
                    end
                end
            end
        end
        loadLocalTags()
        
        local function loadLocalRecipes()
            local doneCraftTypes = {}
            for _, type in pairs(sm.localData.tags.Crafter) do
                    local craftType = type.recipe

                    -- Prevent crafts from appearing multiple times
                    -- (Happenes if multiple crafters of the same type exists)
                    if not doneCraftTypes[craftType] then
                        for _, modId in ipairs(sm.localData.ModsIds) do
                            if sm.json.fileExists("$CONTENT_"..modId.."/CraftingRecipes/"..craftType..".json") then
                                for _, craft in ipairs(sm.json.open("$CONTENT_"..modId.."/CraftingRecipes/"..craftType..".json")) do
                                    table.insert(sm.localData.recipes[craftType], craft)
                                end
                            end
                        end
                        doneCraftTypes[craftType] = true
                    end
                end
        end
        loadLocalRecipes()

        local function loadMisc()
            sm.interactable.connectionData = sm.json.open('$CONTENT_8ec0b0e1-b0ab-4f34-ae1c-59ad47c6e5ec/Scripts/Databases/vanillaCTypes.json')
            local cTypeBit = 2^tableCount(sm.interactable.connectionType)

            for _, ModID in ipairs(sm.localData.ModsIds) do
                local miscPath = tostring("$CONTENT_"..ModID.."/CompatLib/misc.json")
                if sm.json.fileExists(miscPath) then
                    local misc = sm.json.open(miscPath)
                    --ConnectType
                    for cTypeName, cTypeData in pairs(misc.connectionTypes) do
                        if sm.interactable.connectionType[cTypeName] == nil then
                            sm.interactable.connectionType[cTypeName] = cTypeBit
                            sm.interactable.connectionData[cTypeName] = cTypeData
                            cTypeBit = 2*cTypeBit
                        end


                    end
                end
            end
        end
        loadMisc()
    end

    createSMCompatibility()
end

function HookingTool:server_onRefresh()
    print(sm.interactable.connectionData)
end

function HookingTool:server_onFixedUpdate()
end
