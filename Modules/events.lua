local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer

local orbEvent = ReplicatedStorage.rEvents.orbEvent
local rebirthEvent = ReplicatedStorage.rEvents.rebirthEvent
local raceEvent = ReplicatedStorage.rEvents.raceEvent
local raceActive = ReplicatedStorage.raceInProgress
local raceStart = ReplicatedStorage.raceStarted
local maps = workspace.raceMaps
local orbs = workspace.orbFolder
local hoops = workspace.Hoops

local level = player.level
local rebirthCount = player.leaderstats.Rebirths
local map = player.currentMap
local requiredRebirthLabel = player.PlayerGui.gameGui.rebirthMenu.neededLabel.amountLabel

local Events = {}

function Events.RaceAction()
    if raceActive.Value then
        raceEvent:FireServer("join")
        task.wait(1.5)

        local currentMap = map.Value:split(" ")[1]
        if currentMap == "Grass" then
            currentMap = "Grassland"
        end

        local selectedMap = maps[currentMap]
        if selectedMap then
            raceStart:GetPropertyChangedSignal("Value"):Wait()
            player.Character.HumanoidRootPart.CFrame = selectedMap.finishPart.CFrame
        end
    end
end

function Events.DoRebirth()
    local requiredLevel = tonumber(requiredRebirthLabel.Text:gsub("%D", ""))
    if level.Value >= requiredLevel and (shared.maxRebirths and rebirthCount.Value < shared.maxRebirths) then
        rebirthEvent:FireServer("rebirth")
    end
end

return Events
