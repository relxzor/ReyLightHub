-- Import Rayfield GUI Library
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Create GUI Window
local Window = Rayfield:CreateWindow({
   Name = "ReyLightHub | Fisch",
   LoadingTitle = "Fisch",
   LoadingSubtitle = "by ReyLight",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = "ReyLightHub",
      FileName = "Config"
   },
   KeySystem = true,
   KeySettings = {
      Title = "Key | ReyLightHub",
      Subtitle = "Key System",
      Note = "Key In Discord Server (https://discord.gg/b9NuzjaRtv)",
      FileName = "ReyHubKey1",
      SaveKey = false,
      Key = {"eX512011"}
   }
})

-- Get Player Data
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Create Main Tab
local MainTab = Window:CreateTab("Main", "rbxassetid://7734052815")

-- Toggle Status
local autoFishEnabled = false
local espFishEnabled = false
local espPlayerEnabled = false

-- Auto Fish Function
local function autoFish()
    while autoFishEnabled and task.wait(2) do
        local fishingRod = player.Backpack:FindFirstChild("FishingRod") or character:FindFirstChild("FishingRod")
        if fishingRod then
            local remoteEvent = fishingRod:FindFirstChild("RemoteEvent")
            if remoteEvent then
                remoteEvent:FireServer()
            else
                local clickDetector = fishingRod:FindFirstChildWhichIsA("ClickDetector")
                if clickDetector then
                    fireclickdetector(clickDetector)
                end
            end
        end
    end
end

-- Rare Fish ESP Function
local function highlightRareFish()
    while espFishEnabled and task.wait(3) do
        for _, fish in pairs(workspace:GetChildren()) do
            if fish:IsA("Model") and fish:FindFirstChild("FishType") then
                local fishType = fish.FishType.Value
                local rareFish = { "Golden Fish", "Shark", "Legendary Fish" }

                if table.find(rareFish, fishType) then
                    if not fish:FindFirstChild("Highlight") then
                        local highlight = Instance.new("Highlight")
                        highlight.Parent = fish
                        highlight.FillColor = Color3.fromRGB(255, 215, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                    end
                end
            end
        end
    end
end

-- Player ESP Function
local function highlightPlayers()
    while espPlayerEnabled and task.wait(3) do
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                if not v.Character:FindFirstChild("Highlight") then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = v.Character
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                end
            end
        end
    end
end

-- Auto Fish Toggle
MainTab:CreateToggle({
    Name = "Auto Fish",
    CurrentValue = false,
    Flag = "AutoFish",
    Callback = function(value)
        autoFishEnabled = value
        if autoFishEnabled then
            task.spawn(autoFish)
        end
    end
})

-- Rare Fish ESP Toggle
MainTab:CreateToggle({
    Name = "ESP Rare Fish",
    CurrentValue = false,
    Flag = "ESPFish",
    Callback = function(value)
        espFishEnabled = value
        if espFishEnabled then
            task.spawn(highlightRareFish)
        end
    end
})

-- Player ESP Toggle
MainTab:CreateToggle({
    Name = "ESP Player",
    CurrentValue = false,
    Flag = "ESPPlayer",
    Callback = function(value)
        espPlayerEnabled = value
        if espPlayerEnabled then
            task.spawn(highlightPlayers)
        end
    end
})
