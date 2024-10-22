shared.settings = shared.settings or {
    maxRebirths = math.huge,
    selectedOrbs = { "Yellow Orb", "Gem" },
}

local function require(path)
    return loadstring(game:HttpGet(("https://raw.githubusercontent.com/nowkyyl/Legends-of-shit/refs/heads/main/%s"):format(path)))()
end

local events = require("Modules/events.lua")
local glichRebirths = require("Modules/glich.lua")

warn(events, glichRebirths)
local library = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local window = library:CreateWindow({
    Name = "Legends of shit",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Please Wait"
})

do
    local tab = window:CreateTab("Auto Farms", 4483362458)
    local section = tab:CreateSection("Main")

    tab:CreateToggle({
        Name = "Auto Orbs",
        CurrentValue = _G.collectOrbs or false,
        Flag = "Orbs",
        Callback = events.CollectOrbs
    })

    tab:CreateToggle({
        Name = "Auto Hoops",
        CurrentValue = _G.collectHoops or false,
        Flag = "Hoops",
        Callback = events.CollectHoops
    })

    tab:CreateToggle({
        Name = "Auto Race",
        CurrentValue = if _G.raceSignal then true else false,
        Flag = "Race",
        Callback = events.RaceAction
    })

    tab:CreateToggle({
        Name = "Auto Rebirth",
        CurrentValue = if _G.autoRebirth then true else false,
        Flag = "Rebirth",
        Callback = events.DoRebirth
    })
end

do
    local glichTab = window:CreateTab("Glich Rebirth")
    local section = glichTab:CreateSection("Glich Rebirth Table")

    for i = 1, #glichRebirths do
        glichTab:CreateLabel(glichRebirths[i])
    end
end

do
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
end
