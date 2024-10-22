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

function Events.CollectOrbs(active)
    _G.collectOrbs = active
    while _G.collectOrbs do
        for i, v in orbs[map.Value]:GetChildren() do
            for i = 1, 5 do
                task.spawn(orbEvent.FireServer, orbEvent, "collect", v.Name, map.Value)
            end
            task.wait()
        end
        task.wait()
    end
end

function Events.CollectHoops(active)
    _G.collectHoops = active
    while _G.collectHoops do
        for i, v in hoops:GetChildren() do
            firetouchinterest(v, player.Character.HumanoidRootPart, 0)
            firetouchinterest(v, player.Character.HumanoidRootPart, 1)
            task.wait()
        end
        task.wait()
    end
end

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
    if level.Value >= requiredLevel and (rebirthCount.Value < shared.settings.maxRebirths) then
        rebirthEvent:FireServer("rebirth")
    end
end

return Events
