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
local ToggleAutoShoot = MainTab:CreateToggle({
   Name = "Auto Shoot",
   CurrentValue = false,
   Flag = "AutoShoot",
   Callback = function(Value)
       _G.AutoShoot = Value
       while _G.AutoShoot do
           wait(0.1)
           local plr = game.Players.LocalPlayer
           local ball = workspace:FindFirstChild("SoccerBall")
           local goal = workspace:FindFirstChild("Goal")

           if ball and goal then
               local distance = (plr.Character.HumanoidRootPart.Position - goal.Position).Magnitude
               if distance < 15 then
                   ball.Velocity = Vector3.new(0, 50, _G.ShootPower or 50) -- Gunakan nilai Shoot Power
               end
           end
       end
   end
})

-- Auto Dribble
local ToggleAutoDribble = MainTab:CreateToggle({
   Name = "Auto Dribble",
   CurrentValue = false,
   Flag = "AutoDribble",
   Callback = function(Value)
       _G.AutoDribble = Value
       while _G.AutoDribble do
           wait(0.1)
           local plr = game.Players.LocalPlayer
           local ball = workspace:FindFirstChild("SoccerBall")

           if ball then
               ball.Position = plr.Character.HumanoidRootPart.Position + Vector3.new(0, 0, 2)
           end
       end
   end
})

-- Auto Steal Ball
local ToggleAutoSteal = MainTab:CreateToggle({
   Name = "Auto Steal Ball",
   CurrentValue = false,
   Flag = "AutoStealBall",
   Callback = function(Value)
       _G.AutoStealBall = Value
       while _G.AutoStealBall do
           wait(0.1)
           local plr = game.Players.LocalPlayer
           local ball = workspace:FindFirstChild("SoccerBall")

           if ball and (ball.Position - plr.Character.HumanoidRootPart.Position).Magnitude < 5 then
               ball.Position = plr.Character.HumanoidRootPart.Position -- Ambil bola secara automatik
           end
       end
   end
})

-- Movement Section
local MovementTab = Window:CreateTab("Movement", nil)
local MovementSection = MovementTab:CreateSection("Speed Control")

-- Speed Hack
local SliderSpeed = MovementTab:CreateSlider({
   Name = "Speed Hack",
   Range = {16, 100},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "SpeedHack",
   Callback = function(Value)
       game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
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
   end,
})

-- ESP Section
local ESPTab = Window:CreateTab("ESP", nil)
local ESPSection = ESPTab:CreateSection("ESP Features")

-- Ball ESP
local ToggleBallESP = ESPTab:CreateToggle({
   Name = "Ball ESP",
   CurrentValue = false,
   Flag = "BallESP",
   Callback = function(Value)
       _G.BallESP = Value
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
   end
})

-- Player ESP untuk semua pemain di server
local TogglePlayerESP = ESPTab:CreateToggle({
   Name = "Player ESP (Semua Pemain)",
   CurrentValue = false,
   Flag = "PlayerESP",
   Callback = function(Value)
       _G.PlayerESP = Value
       while _G.PlayerESP do
           wait(0.1)
           for _, player in pairs(game.Players:GetPlayers()) do
               if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
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
   end
})
