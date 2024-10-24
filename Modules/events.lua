local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer

local orbEvent = ReplicatedStorage.rEvents.orbEvent
local rebirthEvent = ReplicatedStorage.rEvents.rebirthEvent
local raceEvent = ReplicatedStorage.rEvents.raceEvent
local raceActive = ReplicatedStorage.raceInProgress
local raceStart = ReplicatedStorage.raceStarted
local sellTrail = ReplicatedStorage.rEvents.sellTrailEvent
local sellPet = ReplicatedStorage.rEvents.sellPetEvent
local envolvePet = ReplicatedStorage.rEvents.petEvolveEvent
local envolveTrail = ReplicatedStorage.rEvents.evolveTrailEvent
local openCrystal = ReplicatedStorage.rEvents.openCrystalRemote

local maps = workspace.raceMaps
local orbs = workspace.orbFolder
local hoops = workspace.Hoops

local level = player.level
local rebirthCount = player.leaderstats.Rebirths
local map = player.currentMap
local requiredRebirthLabel = player.PlayerGui.gameGui.rebirthMenu.neededLabel.amountLabel

local petsFolder = player.petsFolder
local trailsFolder = player.trailsFolder

local Events = {}

function Events.CollectOrbs(active)
    _G.collectOrbs = active
    while _G.collectOrbs do
        for i, v in orbs[map.Value]:GetChildren() do
            if table.find(shared.settings.selectedOrbs, v.Name) then
                for i = 1, 5 do
                    task.spawn(orbEvent.FireServer, orbEvent, "collectOrb", v.Name, map.Value)
                end
                task.wait()
            end
        end
        task.wait()
    end
end

function Events.CollectHoops(active)
    _G.collectHoops = active
    while _G.collectHoops do
        for i, v in hoops:GetChildren() do
            local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                firetouchinterest(v, player.Character.HumanoidRootPart, 0)
                firetouchinterest(v, player.Character.HumanoidRootPart, 1)
            end
            task.wait()
        end
        task.wait()
    end
end

function Events.OpenCrystals(active)
    _G.autoOpenCrystal = active
    while _G.autoOpenCrystal do
        for i, v in shared.settings.selectedCrystals do
            task.spawn(openCrystal.InvokeServer, openCrystal, "openCrystal", v)
            task.wait(.1)
        end
        task.wait()
    end
end

function Events.EnvolveItems(active)
    if not active then
        for i, v in _G.envolveSignal do
            v:Disconnect()
        end

        _G.envolveSignal = nil
        return
    end

    _G.envolveSignal = {
        petsFolder.DescendantAdded:Connect(function(item)
            if table.find(shared.settings.selectedItems, item.Name) then
                envolvePet:FireServer("evolvePet", item.Name)
            end
        end),
        trailsFolder.DescendantAdded:Connect(function(item)
            if not table.find(shared.settings.selectedItems, item.Name) then
                envolveTrail:FireServer("evolveTrail", item)
            end
        end)
    }
end

function Events.SellItems(active)
    if not active then
        for i, v in _G.sellItemsSignal do
            v:Disconnect()
        end

        _G.sellItemsSignal = nil
        return
    end

    _G.sellItemsSignal = {
        petsFolder.DescendantAdded:Connect(function(item)
            if not table.find(shared.settings.selectedItems, item.Name) then
                sellPet:FireServer("sellPet", item)
            end
        end),
        trailsFolder.DescendantAdded:Connect(function(item)
            if not table.find(shared.settings.selectedItems, item.Name) then
                sellTrail:FireServer("sellTrail", item)
            end
        end)
    }
end

function Events.RaceAction(active)
    if not active then
        _G.raceSignal:Disconnect()
        _G.raceSignal = nil
        return
    end

    _G.raceSignal = raceActive:GetPropertyChangedSignal("Value"):Connect(function()
        if raceActive.Value then
            raceEvent:FireServer("joinRace")
            task.wait(1.5)
    
            local currentMap = map.Value:split(" ")[1]
            if currentMap == "Grass" then
                currentMap = "Grassland"
            end
    
            local selectedMap = maps[currentMap]
            if selectedMap then
                raceStart:GetPropertyChangedSignal("Value"):Wait()
                player.Character:FindFirstChild("HumanoidRootPart").CFrame = selectedMap.finishPart.CFrame
            end
        end
    end)
end

function Events.DoRebirth(active)
    if not active then
        _G.autoRebirth:Disconnect()
        _G.autoRebirth = nil
        return
    end

    _G.autoRebirth = level:GetPropertyChangedSignal("Value"):Connect(function()
        local requiredLevel = requiredRebirthLabel.Text:gsub("%D", "")
        if level.Value >= tonumber(requiredLevel) and (rebirthCount.Value < shared.settings.maxRebirths) then
            rebirthEvent:FireServer("rebirthRequest")
        end
    end)
end

return Events
