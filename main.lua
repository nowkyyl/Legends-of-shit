shared.settings = shared.settings or {
    maxRebirths = math.huge,
    selectedOrbs = { "Yellow Orb", "Gem" },
    selectedCrystals = {},
    selectedItems = {}
}

local function require(path)
    return loadstring(game:HttpGet(("https://raw.githubusercontent.com/nowkyyl/Legends-of-shit/refs/heads/main/%s.lua"):format(path)))()
end

local eventHandlers = require("Modules/events")
local rebirthGlitchData = require("Modules/glich")

local library = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local mainWindow = library:CreateWindow({
    Name = "Legends of Shit",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Please Wait"
})

do
    local autoFarmsTab = mainWindow:CreateTab("Auto Farms", 4483362458)
    local farmsSection = autoFarmsTab:CreateSection("Main")

    autoFarmsTab:CreateToggle({
        Name = "Auto Orbs",
        CurrentValue = if _G.collectOrbs then true else false,
        Flag = "OrbsToggle",
        Callback = eventHandlers.CollectOrbs
    })

    autoFarmsTab:CreateToggle({
        Name = "Auto Hoops",
        CurrentValue = if _G.collectHoops then true else false,
        Flag = "HoopsToggle",
        Callback = eventHandlers.CollectHoops
    })

    autoFarmsTab:CreateToggle({
        Name = "Auto Race",
        CurrentValue = if _G.raceSignal then true else false,
        Flag = "RaceToggle",
        Callback = eventHandlers.RaceAction
    })

    autoFarmsTab:CreateToggle({
        Name = "Auto Rebirth",
        CurrentValue = if _G.autoRebirth then true else false,
        Flag = "RebirthToggle",
        Callback = eventHandlers.DoRebirth
    })
end

do
    local eggsTab = mainWindow:CreateTab("Eggs")
    local eggsSection = eggsTab:CreateSection("Main")

    local crystalOptions = {}
    for i, v in workspace.mapCrystalsFolder:GetChildren() do
        table.insert(crystalOptions, v.Name)
    end
    
    eggsTab:CreateDropdown({
        Name = "Select Crystal",
        MultipleOptions = true,
        Options = crystalOptions,
        CurrentOption = shared.settings.selectedCrystals,
        Flag = "CrystalDropdown",
        Callback = function(selectedCrystals)
            shared.settings.selectedCrystals = selectedCrystals
        end
    })

    eggsTab:CreateToggle({
        Name = "Auto Open Crystal",
        CurrentValue = if _G.autoOpenCrystal then true else false,
        Flag = "OpenCrystalToggle",
        Callback = eventHandlers.OpenCrystals
    })

    local petOptions = {}
    for i, v in game.ReplicatedStorage.cPetShopFolder:GetChildren() do
        table.insert(petOptions, v.Name)
    end
    
    eggsTab:CreateDropdown({
        Name = "Ignore Items to Sell",
        MultipleOptions = true,
        Options = petOptions,
        CurrentOption = shared.settings.selectedItems,
        Flag = "SellItemsDropdown",
        Callback = function(selectedItems)
            shared.settings.selectedItems = selectedItems
        end
    })

    eggsTab:CreateToggle({
        Name = "Auto Sell Items",
        CurrentValue = if _G.sellItemsSignal then true else false,
        Flag = "SellItemsToggle",
        Callback = eventHandlers.SellItems
    })

    eggsTab:CreateToggle({
        Name = "Auto Evolve Items",
        CurrentValue = if _G.envolveSignal then true else false,
        Flag = "EvolveItemsToggle",
        Callback = eventHandlers.EnvolveItems
    })
end

do
    local glitchTab = mainWindow:CreateTab("Glitch Rebirth")
    local glitchSection = glitchTab:CreateSection("Rebirth List")

    for i, v in rebirthGlitchData do
        glitchTab:CreateLabel(v)
    end
end

do
    local settingsTab = mainWindow:CreateTab("Settings")
    local settingsSection = settingsTab:CreateSection("Main")

    settingsTab:CreateInput({
        Name = "Max Rebirths",
        PlaceholderText = "Enter max rebirths",
        RemoveTextAfterFocusLost = false,
        Callback = function(input)
            shared.settings.maxRebirths = tonumber(input)
        end
    })

    settingsTab:CreateDropdown({
        Name = "Selected Orb",
        MultipleOptions = true,
        Options = { "Blue Orb", "Gem", "Orange Orb", "Red Orb", "Yellow Orb" },
        CurrentOption = shared.settings.selectedOrbs,
        Flag = "OrbSelection",
        Callback = function(selectedOrbs)
            shared.settings.selectedOrbs = selectedOrbs
        end
    })
end
