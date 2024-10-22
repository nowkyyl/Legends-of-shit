local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = game.Players.LocalPlayer
local raceEvent = ReplicatedStorage.rEvents.raceEvent

local raceInProgress: BoolValue = ReplicatedStorage.raceInProgress
local raceStarted: BoolValue = ReplicatedStorage.raceStarted

local raceMaps = workspace.raceMaps

if shared.autoRace then
    shared.autoRace:Disconnect()
    shared.autoRace = nil
    game.StarterGui:SetCore("SendNotification", {
        Title = "CP",
        Text = "Auto race is stopped",
        Duration = 5
    })
    return
end

game.StarterGui:SetCore("SendNotification", {
    Title = "CP",
    Text = "Auto race is started",
    Duration = 5
})

shared.autoRace = raceInProgress:GetPropertyChangedSignal("Value"):Connect(function()
    if raceInProgress.Value then
        raceEvent:FireServer("joinRace")
        raceStarted:GetPropertyChangedSignal("Value"):Wait()

        local currentMapName = player.currentMap.Value:split(" ")[1]
        if currentMapName == "Grass" then
            currentMapName = "Grassland"
        end
    
        local raceMap = raceMaps[currentMapName]
        if raceMap then
            TweenService:Create(
                player.Character.HumanoidRootPart,
                TweenInfo.new(0.1),
                {
                    CFrame = raceMap.finishPart.CFrame
                }
            ):Play()
        end
    end
end)
