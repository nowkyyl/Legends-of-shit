shared.settings = shared.settings or {
    maxRebirths = math.huge,
    selectedOrbs = { "Yellow Orb", "Gem" },
}

local events = loadstring(game:HttpGet("https://raw.githubusercontent.com/nowkyyl/Legends-of-shit/refs/heads/main/Modules/events.lua"))()
local library = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local window = library:CreateWindow({
    Name = "Legends of shit",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Please Wait"
})

local tab = window:CreateTab("Auto Farms", 4483362458)
local section = tab:CreateSection("Main")

tab:CreateToggle({
    Name = "Auto Orbs",
    CurrentValue = false,
    Flag = "Orbs",
    Callback = events.CollectOrbs
})

tab:CreateToggle({
    Name = "Auto Hoops",
    CurrentValue = false,
    Flag = "Hoops",
    Callback = events.CollectHoops
})

tab:CreateToggle({
    Name = "Auto Race",
    CurrentValue = false,
    Flag = "Race",
    Callback = events.RaceAction
})

tab:CreateToggle({
    Name = "Auto Rebirth",
    CurrentValue = false,
    Flag = "Rebirth",
    Callback = events.DoRebirth
})

local configTab = window:CreateTab("Settings")
local section = configTab:CreateSection("Main")

configTab:CreateInput({
    Name = "Max Rebirths",
    PlaceholderText = "input",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        shared.settings.maxRebirths = tonumber(text)
    end
})

configTab:CreateDropdown({
    Name = "Selected Orb",
    MultipleOptions = true,
    Options = { "Blue Orb", "Gem", "Orange Orb", "Red Orb", "Yellow Orb" },
    CurrentOption = shared.settings.selectedOrbs,
    Flag = "OrbConfig",
    Callback = function(items)
        shared.settings.selectedOrbs = items
    end
})
