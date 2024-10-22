--This code is shit in my opinion
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local player = game.Players.LocalPlayer
local collectOrbEvent = ReplicatedStorage.rEvents.orbEvent
local rebirthRequestEvent = ReplicatedStorage.rEvents.rebirthEvent

local requiredRebirthLabel = player.PlayerGui.gameGui.rebirthMenu.neededLabel.amountLabel
local playerLevel = player.level
local activeMap = player.currentMap

local function HandleAutoRebirth()
    local requiredLevel = requiredRebirthLabel.Text:gsub("%D", "")
    if playerLevel.Value >= tonumber(requiredLevel) then
        rebirthRequestEvent:FireServer("rebirthRequest")
    end
end

local function CollectOrbs()
    for i, v in workspace.orbFolder[activeMap.Value]:GetChildren() do
        for i = 1, 5 do
            task.spawn(collectOrbEvent.FireServer, collectOrbEvent, "collectOrb", v.Name, activeMap.Value)
        end
        task.wait()
    end
end

local function TriggerHoops()
    for i, v in workspace.Hoops:GetChildren() do
        firetouchinterest(v, player.Character.HumanoidRootPart, 0)
        firetouchinterest(v, player.Character.HumanoidRootPart, 1)
        task.wait()
    end
end

if shared.autoRebirthConnection then
    shared.autoRebirthConnection:Disconnect()
end

shared.autoRebirthConnection = playerLevel:GetPropertyChangedSignal("Value"):Connect(HandleAutoRebirth)
shared.autoFarmEnabled = not shared.autoFarmEnabled

StarterGui:SetCore("SendNotification", {
    Title = "CP",
    Text = "Auto farm status: " .. shared.autoFarmEnabled,
    Duration = 5
})

while shared.autoFarmEnabled do
    pcall(function()
        CollectOrbs()
        TriggerHoops()
    end)

    task.wait()
end
