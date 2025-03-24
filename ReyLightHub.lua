local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "ReyLightHub | Blue Lock Rivals",
   LoadingTitle = "Blue Lock Rivals",
   LoadingSubtitle = "by ReyLight",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "ReyLightHub"
   }
})

-- Main Features Section
local MainTab = Window:CreateTab("Main", nil)
local MainSection = MainTab:CreateSection("Main Features")

-- Auto Shoot
local AutoShoot = false
local ToggleAutoShoot = MainTab:CreateToggle({
   Name = "Auto Shoot",
   CurrentValue = false,
   Flag = "AutoShoot",
   Callback = function(state)
      AutoShoot = state
      spawn(function()
         while AutoShoot do
            wait(1)
            local player = game.Players.LocalPlayer
            if player and player.Character then
               local Ball = game.Workspace:FindFirstChild("Ball")
               if Ball then
                  Ball.Velocity = Vector3.new(0, 50, _G.ShootPower or 50)
               end
            end
         end
      end)
   end
})

-- Auto Dribble
local AutoDribble = false
local ToggleAutoDribble = MainTab:CreateToggle({
   Name = "Auto Dribble",
   CurrentValue = false,
   Flag = "AutoDribble",
   Callback = function(state)
      AutoDribble = state
      spawn(function()
         while AutoDribble do
            wait(0.1)
            local player = game.Players.LocalPlayer
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
               character.HumanoidRootPart.Velocity = Vector3.new(20, 0, 20)
            end
         end
      end)
   end
})

-- Auto Steal Ball
local AutoSteal = false
local ToggleAutoSteal = MainTab:CreateToggle({
   Name = "Auto Steal Ball",
   CurrentValue = false,
   Flag = "AutoStealBall",
   Callback = function(state)
      AutoSteal = state
      spawn(function()
         while AutoSteal do
            wait(0.1)
            local player = game.Players.LocalPlayer
            local character = player.Character
            if character and game.Workspace:FindFirstChild("Ball") then
               local Ball = game.Workspace.Ball
               local distance = (character.HumanoidRootPart.Position - Ball.Position).magnitude
               if distance < 5 then -- Jarak tackle
                  Ball.Position = character.HumanoidRootPart.Position
               end
            end
         end
      end)
   end
})

-- Shooting Section
local ShootingTab = Window:CreateTab("Shooting", nil)
local ShootingSection = ShootingTab:CreateSection("Power Control")

-- Power Shoot (Maksimum 150)
local SliderPowerShoot = ShootingTab:CreateSlider({
   Name = "Power Shoot",
   Range = {10, 150},
   Increment = 5,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "PowerShoot",
   Callback = function(Value)
      _G.ShootPower = Value
   end
})

-- ESP Section
local ESPTab = Window:CreateTab("ESP", nil)
local ESPSection = ESPTab:CreateSection("ESP Features")

-- Ball ESP
local _G.BallESP = false
local ToggleBallESP = ESPTab:CreateToggle({
   Name = "Ball ESP",
   CurrentValue = false,
   Flag = "BallESP",
   Callback = function(state)
      _G.BallESP = state
      spawn(function()
         while _G.BallESP do
            wait(0.1)
            local ball = workspace:FindFirstChild("SoccerBall")

            if ball then
               local highlight = ball:FindFirstChild("ESP") or Instance.new("Highlight")
               highlight.Name = "ESP"
               highlight.FillColor = Color3.fromRGB(255, 255, 0) -- Kuning
               highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
               highlight.Adornee = ball
               highlight.Parent = ball
            end
         end
      end)
   end
})

-- Player ESP untuk semua pemain kecuali diri sendiri
local _G.PlayerESP = false
local TogglePlayerESP = ESPTab:CreateToggle({
   Name = "Player ESP",
   CurrentValue = false,
   Flag = "PlayerESP",
   Callback = function(state)
      _G.PlayerESP = state
      spawn(function()
         while _G.PlayerESP do
            wait(0.1)
            for _, player in pairs(game.Players:GetPlayers()) do
               if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                  local char = player.Character
                  local highlight = char:FindFirstChild("ESP") or Instance.new("Highlight")
                  highlight.Name = "ESP"
                  highlight.FillColor = Color3.fromRGB(0, 255, 0) -- Hijau
                  highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                  highlight.Adornee = char
                  highlight.Parent = char
               end
            end
         end
      end)
   end
})

-- Hitbox untuk semua pemain kecuali diri sendiri
local _G.Hitbox = false
local ToggleHitbox = ESPTab:CreateToggle({
   Name = "Player Hitbox",
   CurrentValue = false,
   Flag = "Hitbox",
   Callback = function(state)
      _G.Hitbox = state
      spawn(function()
         while _G.Hitbox do
            wait(0.1)
            for _, player in pairs(game.Players:GetPlayers()) do
               if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                  local hrp = player.Character.HumanoidRootPart
                  hrp.Size = Vector3.new(10, 10, 10) -- Besarkan hitbox
                  hrp.Transparency = 0.5 -- Biar nampak tapi separuh lutsinar
                  hrp.Material = Enum.Material.Neon -- Beri efek neon
               end
            end
         end
      end)
   end
})
