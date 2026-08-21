print("Loading CompatLib basic functions")

function CompatLib.getUuidData( searchedUuid )
    searchedUuid = tostring(searchedUuid)
    if sm.localData.set[searchedUuid] == nil then
        sm.log.error( "[ERROR] in \"$CONTENT_8ec0b0e1-b0ab-4f34-ae1c-59ad47c6e5ec/Scripts/pipeFunctions.lua\" : \n".."Uuid \""..tostring(searchedUuid).."\" isn't registered/detected in the Compatibility Library/ModDatabase")
        return nil
    elseif sm.json.fileExists(sm.localData.set[searchedUuid].setPath) == nil then
        sm.log.error( "[ERROR] in \"$CONTENT_8ec0b0e1-b0ab-4f34-ae1c-59ad47c6e5ec/Scripts/pipeFunctions.lua\" : \n".."File \""..sm.localData.set[searchedUuid].setPath.."\" for Uuid \""..tostring(searchedUuid).."\" isn't registered/detected in the server's local storage")
        return nil
    end
    local set = sm.json.open(sm.localData.set[searchedUuid].setPath)
    for _, data in pairs(set) do
        for _, Objectdata in pairs(data) do
            if tostring(Objectdata.uuid) == searchedUuid then
                local uuidData = Objectdata
                for dataName, data in pairs(sm.localData.set[searchedUuid]) do
                    uuidData[dataName] = data
                end
                return uuidData
            end
        end
    end
end

function CompatLib.getTagContent( tagName )
    return sm.localData.tags[tagName]
end

function CompatLib.getUuidTagList( uuid )
    uuid = tostring(uuid)
    local tagList = sm.localData.set[uuid].tags
    if tagList == nil then
        tagList = {}
    end
    return tagList
end

function CompatLib.isUuidInTag( uuid, tag )
    uuid = tostring(uuid)
    local tagContent = CompatLib.getTagContent(tag)
    for tagUuid, uuidData in pairs(tagContent) do
        if tagUuid == uuid then
            return {state = true, data = uuidData}
        end
    end
    return {state = false, data = nil}
end

function CompatLib.addTemporaryPart(uuid, ModID, setPath, type, tags)
    uuid = tostring(uuid)
    ModID = tostring(ModID)
    setPath = tostring("$CONTENT_"..ModID..setPath)
    if tags == nil then
        tags = {}
    else
        for tag, data in pairs(tags) do
            sm.localData.tags[tag][uuid] = data
        end
    end
    sm.localData.set[uuid] = {ModID = ModID, setPath = setPath, type = string.lower(type), tags = tags}
end