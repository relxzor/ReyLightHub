local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "ReyLightHub | Blue Lock Rivals",
   LoadingTitle = "Blue Lock Rivals",
   LoadingSubtitle = "by ReyLight",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "ReyLightHub"
   },
   Discord = {
      Enabled = false,
      Invite = "https://b9NuzjaRtv", -- Kod jemputan Discord tanpa 'discord.gg/'
      RememberJoins = true -- Jika false, pemain perlu menyertai semula setiap kali skrip dimuatkan
   },
   KeySystem = true, -- Aktifkan sistem kunci
   KeySettings = {
      Title = "Key | ReyLightHub",
      Subtitle = "Key System",
      Note = "Key In Discord Server (https://discord.gg/b9NuzjaRtv",
      FileName = "ReyHubKey1", -- Pastikan nama fail unik supaya tidak ditimpa oleh skrip lain
      SaveKey = false, -- Jika false, pemain perlu memasukkan semula kunci jika ia berubah
      Key = {"ReyLucky2025"} -- Senarai kunci yang diterima
   }
})
-- === MAIN FEATURES ===
local MainTab = Window:CreateTab("Main", nil)
local MainSection = MainTab:CreateSection("Main Features")

-- === AUTO FARM ===
local AutoFarmTab = Window:CreateTab("Auto Farm", nil)
local AutoFarmSection = AutoFarmTab:CreateSection("Auto Farm Features")

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
           local ball = workspace:FindFirstChild("Football")
           local goal = workspace:FindFirstChild("Goal")

           if ball and goal then
               local distance = (plr.Character.HumanoidRootPart.Position - goal.Position).Magnitude
               if distance < 15 then
                   firetouchinterest(plr.Character.HumanoidRootPart, ball, 0)
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
        if _G.AutoDribble then
            if not getgenv().AutoDribbleSettings then
                getgenv().AutoDribbleSettings = {
                    Enabled = true,
                    range = 22
                }
            end

            local S, R, P, U = getgenv().AutoDribbleSettings, game:GetService("ReplicatedStorage"), game:GetService("Players"), game:GetService("RunService")
            local L = P.LocalPlayer or P.PlayerAdded:Wait()
            
            local function initCharacter()
                local C = L.Character or L.CharacterAdded:Wait()
                local H = C:WaitForChild("HumanoidRootPart")
                local M = C:WaitForChild("Humanoid")
                return C, H, M
            end

            local C, H, M = initCharacter()
            L.CharacterAdded:Connect(function(newChar)
                C, H, M = initCharacter()
            end)

            local B = R.Packages.Knit.Services.BallService.RE.Dribble
            local A = require(R.Assets.Animations)

            local function getDribbleAnim(s)
                if not A.Dribbles[s] then return nil end
                local I = Instance.new("Animation")
                I.AnimationId = A.Dribbles[s]
                return M and M:LoadAnimation(I)
            end

            local function isSlidingOrFrozen(p)
                if p == L then return false end
                local c = p.Character
                if not c then return false end
                local V = c.Values and c.Values.Sliding
                if V and V.Value == true then return true end
                local h = c:FindFirstChildOfClass("Humanoid")
                return h and h.MoveDirection.Magnitude > 0 and h.WalkSpeed == 0
            end

            local function isEnemy(p)
                if not L.Team or not p.Team then return false end
                return L.Team ~= p.Team
            end

            local function autoDribble(d)
                if not S.Enabled or not C.Values.HasBall.Value then return end
                B:FireServer()
                local s = L.PlayerStats.Style.Value
                local t = getDribbleAnim(s)
                if t then
                    t:Play()
                    t:AdjustSpeed(math.clamp(1 + (10 - d) / 10, 1, 2))
                end
                local F = workspace:FindFirstChild("Football")
                if F then
                    F.AssemblyLinearVelocity = Vector3.new()
                    F.CFrame = C.HumanoidRootPart.CFrame * CFrame.new(0, -2.5, 0)
                end
            end

            -- Pastikan tiada duplikasi sambungan ke Heartbeat
            if _G.DribbleConnection then _G.DribbleConnection:Disconnect() end

            _G.DribbleConnection = U.Heartbeat:Connect(function()
                if not S.Enabled or not C or not H then return end
                for _, p in pairs(P:GetPlayers()) do
                    if isEnemy(p) and isSlidingOrFrozen(p) then
                        local r = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                        if r then
                            local d = (r.Position - H.Position).Magnitude
                            if d < S.range then
                                autoDribble(d)
                                break
                            end
                        end
                    end
                end
            end)
        else
            if _G.DribbleConnection then
                _G.DribbleConnection:Disconnect()
                _G.DribbleConnection = nil
            end
        end
    end
})

-- === ESP ===
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
           local ball = workspace:FindFirstChild("Football")

           if ball then
               local highlight = ball:FindFirstChild("ESP") or Instance.new("Highlight")
               highlight.Name = "ESP"
               highlight.FillColor = Color3.fromRGB(255, 255, 0)
               highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
               highlight.Adornee = ball
               highlight.Parent = ball
           end
       end
   end
})

-- PLAYER ESP
local function ApplyESP(player)
    if player.Character then
        local char = player.Character
        -- Padam ESP lama jika ada
        local oldHighlight = char:FindFirstChild("ESP")
        if oldHighlight then
            oldHighlight:Destroy()
        end

        -- Buat ESP baru
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP"
        highlight.FillColor = Color3.fromRGB(0, 255, 0)
        highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
        highlight.Adornee = char
        highlight.Parent = char
    end
end

local function RemoveESP(player)
    if player.Character then
        local highlight = player.Character:FindFirstChild("ESP")
        if highlight then
            highlight:Destroy()
        end
    end
end

local TogglePlayerESP = ESPTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "PlayerESP",
    Callback = function(Value)
        _G.PlayerESP = Value

        if _G.PlayerESP then
            -- Pasang ESP untuk semua pemain sedia ada
            for _, player in pairs(game.Players:GetPlayers()) do
                ApplyESP(player)
                -- Pastikan ESP dipasang semula jika pemain respawn
                player.CharacterAdded:Connect(function()
                    ApplyESP(player)
                end)
            end
        else
            -- Padamkan semua ESP jika dinyahaktifkan
            for _, player in pairs(game.Players:GetPlayers()) do
                RemoveESP(player)
            end
        end
    end
})

-- === STYLES & FLOWS ROLLING ===
local StylesTab = Window:CreateTab("Styles", nil)
local stopRolling = false
local legendaryProtection = false

local legendaryStyles = {["Don Lorenzo"] = true, ["Shidou"] = true, ["Yukimiya"] = true, ["Sae"] = true,
                         ["Kunigami"] = true, ["Aiku"] = true, ["Rin"] = true, ["King"] = true, ["Nagi"] = true, ["Reo"] = true}

local function lockStyle()
    local args = { [1] = "Slot1", [2] = true }
    local lockService = game:GetService("ReplicatedStorage").Packages.Knit.Services.StyleService.RE.LockSlot
    lockService:FireServer(unpack(args))
end

local function rollStyle(styleName)
    local player = game.Players.LocalPlayer
    local styleService = game:GetService("ReplicatedStorage").Packages.Knit.Services.StyleService.RE.Spin
    stopRolling = false

    while not stopRolling do
        task.wait(0.6)
        if player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("Style") then
            local currentStyle = player.PlayerStats.Style.Value
            if currentStyle == styleName or (legendaryProtection and legendaryStyles[currentStyle]) then
                lockStyle()
                stopRolling = true
                return
            else
                styleService:FireServer()
            end
        end
    end
end

local styles = {"King", "Chigiri", "Bachira", "Shidou", "Nagi", "Isagi", "Gagamaru", "Sae", "Rin", "Aiku", "Reo", "Yukimiya", "Hiori", "Kunigami", "Karasu", "Don Lorenzo"}
for _, style in ipairs(styles) do
    StylesTab:CreateButton({
        Name = "Roll for " .. style .. " Style",
        Callback = function()
            rollStyle(style)
        end
    })
end

-- === STOP ROLLING BUTTON ===
local stopButton = StylesTab:CreateButton({
   Name = "Stop Rolls",
   Callback = function()
       stopRolling = true
   end
})

-- === LEGENDARY+ PROTECTION TOGGLE ===
local ToggleLegendaryProtection = StylesTab:CreateToggle({
   Name = "Legendary+ Protection",
   CurrentValue = false,
   Flag = "LegendaryProtection",
   Callback = function(Value)
       legendaryProtection = Value
   end
})

local ToggleAutoGK = AutoFarmTab:CreateToggle({
    Name = "Auto GK",
CurrentValue = false,
Flag = "AutoGK",
Callback = function(Value)
    _G.AutoGK = Value
    if _G.AutoGK then
        task.spawn(function()
            while _G.AutoGK do
                task.wait(0.03) -- **Kurangkan delay untuk reaksi lebih pantas**
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoid = character:FindFirstChild("Humanoid")
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                local ball = game.Workspace:FindFirstChild("Football")

                if not _G.AutoGK then break end

                if ball and rootPart and humanoid then
                    rootPart.CFrame = CFrame.lookAt(rootPart.Position, ball.Position)

                    local myGoal = game.Workspace.AI.Home.DiveBox.Position
                    local ballDistance = (ball.Position - myGoal).Magnitude
                    local ballSpeed = ball.AssemblyLinearVelocity.Magnitude

                    -- **Tentukan jika bola dalam zon bahaya**
                    local dangerZone = ballDistance < 60 and ballSpeed > 5
                    local criticalZone = ballDistance < 40 or ballSpeed > 10

                    if criticalZone then
                        -- **Boost teleport jika bola terlalu laju ke arah gol**
                        if ballSpeed > 15 then
                            rootPart.CFrame = CFrame.new(ball.Position + Vector3.new(0, 5, 0))
                        else
                            rootPart.CFrame = CFrame.new(ball.Position + Vector3.new(0, 3, 0))
                        end

                        humanoid.JumpPower = 0
                        humanoid:Move(Vector3.new(0, -10, 0))

                        -- **Bekukan bola sepenuhnya**
                        if _G.AutoGK then
                            ball.AssemblyLinearVelocity = Vector3.zero
                            ball.AssemblyAngularVelocity = Vector3.zero
                            ball.Velocity = Vector3.zero
                            ball.RotVelocity = Vector3.zero
                            ball.Anchored = true
                            task.wait(0.1)
                            ball.Anchored = false
                        end

                        -- **Tolak bola jauh dari gol**
                        local direction = (ball.Position - myGoal).Unit * 120
                        ball.AssemblyLinearVelocity = direction

                        task.wait(0.5)
                        humanoid.JumpPower = 50
                    end

                    -- **Blok lawan yang dekat dengan bola**
                    for _, opponent in pairs(game.Players:GetPlayers()) do
                        if opponent ~= player and opponent.Team ~= player.Team then
                            local enemyCharacter = opponent.Character
                            if enemyCharacter then
                                local enemyRoot = enemyCharacter:FindFirstChild("HumanoidRootPart")
                                if enemyRoot and (enemyRoot.Position - ball.Position).Magnitude < 10 then
                                    -- **Tolak lawan jauh dari bola**
                                    local pushDirection = (enemyRoot.Position - ball.Position).Unit * 80
                                    enemyRoot.AssemblyLinearVelocity = pushDirection
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
      end

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local ball = game.Workspace:FindFirstChild("Football")

local function isEnemy(player)
    return player.Team ~= game.Players.LocalPlayer.Team
end

local function autoSteal()
    while _G.AutoSteal do
        task.wait(0.1)

        if ball then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= player and isEnemy(p) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local enemyHRP = p.Character.HumanoidRootPart
                    if (ball.Position - enemyHRP.Position).Magnitude < 10 then
                        -- Auto teleport ke bola & ambil
                        humanoidRootPart.CFrame = CFrame.new(ball.Position + Vector3.new(0, 2, 0))
                        task.wait(0.05)
                        firetouchinterest(humanoidRootPart, ball, 0)
                        firetouchinterest(humanoidRootPart, ball, 1)
                    end
                end
            end
        end
    end
end

-- Toggle Auto Steal
local ToggleAutoSteal = AutoFarmTab:CreateToggle({
    Name = "Auto Steal",
    CurrentValue = false,
    Flag = "AutoSteal",
    Callback = function(Value)
        _G.AutoSteal = Value
        
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local ball = game.Workspace:FindFirstChild("Football")

        local function isEnemy(p)
            return p.Team ~= player.Team
        end

        local function hasBall(p)
            return p.Character and p.Character:FindFirstChild("HasBall") and p.Character.HasBall.Value
        end

        local function autoSteal()
            while _G.AutoSteal do
                task.wait(0.1)

                if ball then
                    for _, p in pairs(game.Players:GetPlayers()) do
                        if p ~= player and isEnemy(p) and hasBall(p) then
                            local enemyHRP = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                            if enemyHRP and (ball.Position - enemyHRP.Position).Magnitude < 10 then
                                -- Auto teleport ke bola & ambil
                                humanoidRootPart.CFrame = CFrame.new(ball.Position + Vector3.new(0, 2, 0))
                                task.wait(0.05)
                                firetouchinterest(humanoidRootPart, ball, 0)
                                firetouchinterest(humanoidRootPart, ball, 1)
                            end
                        end
                    end
                end
            end
        end

        if _G.AutoSteal then
            task.spawn(autoSteal)
        end
    end
})

-- Ambil pemain dan karakter
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local ball = game.Workspace:FindFirstChild("Football")

-- Kedudukan Dive Box GK (Sesuaikan jika perlu)
local diveBoxGK = game.Workspace.AI.Home.DiveBox.Position

-- Toggle Auto Teleport To Goal
local ToggleAutoGoal = AutoFarmTab:CreateToggle({
    Name = "Auto Teleport To Goal",
    CurrentValue = false,
    Flag = "AutoTeleportToGoal",
    Callback = function(Value)
        _G.AutoGoal = Value

        if _G.AutoGoal then
            task.spawn(function() -- Pastikan loop berjalan secara selamat
                while _G.AutoGoal do
                    task.wait(0.1)

                    -- **Pastikan karakter dan bola wujud sebelum teleport**
                    local character = player.Character
                    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                    local ball = game.Workspace:FindFirstChild("Football")

                    if ball and rootPart and ball.Parent == character then
                        rootPart.CFrame = CFrame.new(diveBoxGK + Vector3.new(0, 3, 0)) -- Teleport ke atas Dive Box
                    end
                end
            end)
        end
    end
})
-- === SPEED HACK SECTION ===
local SpeedTab = Window:CreateTab("Speed", nil)
local SpeedSection = SpeedTab:CreateSection("Speed Hack Features")

-- Speed Hack Toggle
local ToggleSpeedHack = SpeedTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Flag = "SpeedHack",
    Callback = function(Value)
        _G.SpeedHack = Value
        if _G.SpeedHack then
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

            while _G.SpeedHack do
                task.wait(0.02) -- Delay kecil untuk kelancaran
                if humanoidRootPart then
                    humanoidRootPart.CFrame = humanoidRootPart.CFrame + humanoidRootPart.CFrame.LookVector * _G.SpeedMultiplier
                end
            end
        end
    end
})

-- Speed Multiplier Slider
local SliderSpeedMultiplier = SpeedTab:CreateSlider({
    Name = "Speed Multiplier",
    Min = 1,
    Max = 50,
    Increment = 1,
    CurrentValue = 10,
    Flag = "SpeedMultiplier",
    Callback = function(Value)
        _G.SpeedMultiplier = Value
    end
})
-- === SHOW WINDOW ===
Window:Show()
