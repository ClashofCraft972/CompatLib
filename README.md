The Compatibility Library mod is a library that aims to allow interconnectivity between mods by creating a common environnement where mods can share informations. It adds a brand new tag system like Minecraft, you can suggest and check the existing tags name in this [google folder](https://drive.google.com/drive/folders/1ZujH5DYTK7tPxhyR9ZLuF5tNTtis5KX2?usp=sharing).

In this page, you'll find all the info to use the Comptability Library mod.

> [!IMPORTANT]
> **For now, this mod is NOT updated for 1.0 due to problems created by Axolot and issues with the ModDatabase (a dependancy)**
> In case of any problem, suggestion, message me (@\_1g\_\_) on Discord or open an [issue](https://github.com/ClashofCraft972/CompatLibs/issues).

# How to configure your mod to enable the Compatibility Library 

## Add the Compatibilty library to your mod dependancy

This will install automaticly the library to the player game when they use your mod.

Write this in your dependencies in `description.json` : 
```json
{
"fileId" : 3055543525,
"localId" : "8ec0b0e1-b0ab-4f34-ae1c-59ad47c6e5ec",
"name" : "Compatibility Library"
}
```

## Enable the library in your lua file

To enable the library's functions and variables in your lua file, just write this at the start of your lua file (it could make a little lag spike) :
```lua
dofile( "$CONTENT_8ec0b0e1-b0ab-4f34-ae1c-59ad47c6e5ec/Scripts/Compatibility.lua" )
```


## Create your tag file

This will be the file in which you register the objects' tags

In your mods, Create the `Compatlib` repository, create a `tags.json`, for the syntax, it must look like this :
```json
{
    "Crafter" :{
        "2af00456-b22e-4743-b338-a91934aba7c5": {"recipe" : "cookbot"},
        "b63c6440-dfc2-4da7-acdb-3c385080b2e4": {"recipe" : "craftbot"},
        "b7571f6f-9d53-44ba-99d2-3b4f05e6fd0f": {"recipe" : "craftbot"},
        "5cb15c93-4fa9-48da-9974-2e95ca6c9e1c": {"recipe" : "refinery"},
        "767a3121-2c31-473c-a5ab-27e188fdd55a": {"recipe" : "dressbot"}
    },
    "AggroUnit" : {
        "04761b4a-a83e-4736-b565-120bc776edb2": {},
        "c3d31c47-0c9b-4b07-9bd4-8f022dc4333e": {},
        "9dbbd2fb-7726-4e8f-8eb4-0dab228a561d": {},
        "fcb2e8ce-ca94-45e4-a54b-b5acc156170b": {},
        "9f4fde94-312f-4417-b13b-84029c5d6b52": {}
    }
}
```

## Create Custom recipes 

This use the same system as QM's Modded Craftbot Recipes gamemode ([Steam](https://steamcommunity.com/sharedfiles/filedetails/?id=2816900681), [Github](https://github.com/QuestionableM/Modded-Craftbot-Recipes/blob/main/README.md))

## For custom connection type and others _(the list my be longer soon)_

In your mods, Create the `Compatlib` repository, create a `misc.json`, for the syntax, it must look like this :
```json
{
    "connectionTypes":{
        "gasoline" : { "consume" : "d4d68946-aa03-4b8f-b1af-96b81ad4e305"},
        "electricity" : { "consume" : "910a7f2c-52b0-46eb-8873-ad13255539af"},
        "ammo" : { "consume" : "bfcfac34-db0f-42d6-bd0c-74a7a5c95e82"},
        "water" : { "consume" : "869d4736-289a-4952-96cd-8a40117a2d28"}
        }
}
```


## To use this library, check the [Wiki](https://github.com/ClashofCraft972/CompatLib/wiki/Compatibility-Library-Wiki)
