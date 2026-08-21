import jsonc
import os.path



def openSm(smPath):
    
    if "scriptableObjectSet" in smPath: #Random SM bullshit code (for S-objects):
        smPath = smPath["scriptableObjectSet"]
    elif "name" in smPath:
        smPath = smPath["name"]
    i = 0
    while smPath[i] != '/':
        i += 1
    smDirectory = smPath[:i]


    if smDirectory == '$CONTENT_DATA':        
        directory = 'C:/Program Files (x86)/Steam/steamapps/common/Challenges/MasterMechanicTrials'
    elif smDirectory == '$GAME_DATA':        
        directory = 'C:/Program Files (x86)/Steam/steamapps/common/Scrap Mechanic/Data'
    elif smDirectory == '$SURVIVAL_DATA':
        directory = 'C:/Program Files (x86)/Steam/steamapps/common/Scrap Mechanic/Survival'
    elif smDirectory == '$CHALLENGE_DATA':
        directory = 'C:/Program Files (x86)/Steam/steamapps/common/Scrap Mechanic/ChallengeData'
    elif smDirectory == '$CACHE_DATA':
        directory = 'C:/Program Files (x86)/Steam/steamapps/common/Scrap Mechanic/Cache'
    else : 
        print(smPath,'is not an SM path') 
        return

    path = directory+smPath[i:]
    if os.path.isfile(path): 
        return open(path, 'r')
    else:
        return open('Databases/empty.json', 'r')



# Tags
VanillaData = {}
with open('Databases/vanillaTags.json', 'r') as file:
    VanillaData['tags'] = jsonc.load(file)


'''
reversedTags = {}

for tag in VanillaData['tags']:
    for uuid in VanillaData['tags'][tag]:
        if not uuid in reversedTags: reversedTags[uuid] = {}
        reversedTags[uuid][tag] = VanillaData['tags'][tag][uuid]
'''

#sets
def extractSet(dbPath, typeName):
    modes = [
        ["00000000-0000-0000-0000-000000000000", '$GAME_DATA'],
        ["00000000-0000-0000-0000-000000000001", '$SURVIVAL_DATA'],
        ["00000000-0000-0000-0000-000000000002", '$CHALLENGE_DATA'],
    ]

    content = {}
    for mode in modes:
        ModId = mode[0]
        smDbPath = mode[1]+dbPath

        with openSm(smDbPath) as Dbfile:
            dbDirty = jsonc.load(Dbfile)
        if len(dbDirty) !=0 :
            sets = next(iter(dbDirty.values()))

            for setPath in sets:
                with openSm(setPath) as setFile:
                    setDirty = jsonc.load(setFile)

                if len(setDirty) !=0:
                    setData = next(iter(setDirty.values()))

                    for data in setData:
                        if not data['uuid'] in content:
                            content[data['uuid']] = {'ModId' : ModId, 'setPath' : setPath, 'type' : typeName }
    return content

shape = {**extractSet('/Objects/Database/shapesets.shapedb', 'shape'), **extractSet('/Objects/Database/shapesets.json', 'shape')}
tool = extractSet('/Tools/toolsets.json', 'tool')
harvestable = extractSet('/Harvestables/Database/harvestablesets.json', 'harvestable')
kinematic = extractSet('/Kinematics/Database/kinematicsets.json', 'kinematic')
character = extractSet('/Character/charactersets.json', 'character')
scriptableobject = extractSet('/ScriptableObjects/scriptableobjectsets.sobdb', 'scriptableobject')


VanillaData['set'] = {**shape, **tool, **harvestable, **kinematic, **character, **scriptableobject}


for tag in VanillaData['tags']:
    for uuid in VanillaData['tags'][tag]:
        if not 'tags' in VanillaData['set'][uuid] : VanillaData['set'][uuid]['tags'] = {}
        VanillaData['set'][uuid]['tags'][tag] = VanillaData['tags'][tag][uuid]


# Recipes
VanillaData['recipes'] = {}

def JsonToDict(smPath):
    with openSm(smPath) as file:
        return jsonc.load(file)

def addCrafter(crafterName):
    VanillaData['recipes'][crafterName] = JsonToDict('$SURVIVAL_DATA/CraftingRecipes/'+crafterName+'.json')

addCrafter('cookbot')
addCrafter('dispenser')
addCrafter('dressbot')
addCrafter('hideout')
addCrafter('mininghubDispenser')
addCrafter('multitool')
addCrafter('portablecrafter')
addCrafter('refinery')
addCrafter('sawtable')
addCrafter('workbench')



VanillaData['recipes']['craftbot'] = []
with openSm('$SURVIVAL_DATA/CraftingRecipes/craftbot/craftbot.json') as file:
    craftbotRecipes = jsonc.load(file)

for recipePathList in craftbotRecipes:
    recipeList = JsonToDict(craftbotRecipes[recipePathList])
    VanillaData['recipes']['craftbot'] = recipeList + VanillaData['recipes']['craftbot']




json_str = '//This file is generated\n'+jsonc.dumps(VanillaData, indent = 4)
with open('Databases/vanillaObjects.json', 'w') as savedjsonc:
    savedjsonc.write(json_str)
        


