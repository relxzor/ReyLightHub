.AutoGK = Value
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
