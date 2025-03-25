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
    KeySystem = true,
    KeySettings = {
        Title = "Key | ReyLightHub",
        Subtitle = "Key System",
        Note = "Key In Discord Server (https://discord.gg/b9NuzjaRtv)",
        FileName = "ReyHubKey1",
        SaveKey = false,
        Key = {"ReyLucky2025"}
    }
})

-- === MAIN FEATURES ===
local MainTab = Window:CreateTab("Main", nil)
local MainSection = MainTab:CreateSection("Main Features")

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local ball = game.Workspace:FindFirstChild("Football")

-- Kenal pasti pasukan dan dive box
local teamName = player.Team and player.Team.Name or "Unknown"
local isHomeTeam = (teamName == "Home")
local myGoal = isHomeTeam and game.Workspace.AI.Home.DiveBox.Position or game.Workspace.AI.Away.DiveBox.Position

-- Auto GK Toggle
local ToggleAutoGK = MainTab:CreateToggle({
    Name = "Auto GK Extreme",
    CurrentValue = false,
    Flag = "AutoGK",
    Callback = function(Value)
        _G.AutoGK = Value
        if _G.AutoGK then
            task.spawn(function()
                local animController = game:GetService("ReplicatedStorage").Controllers.AnimatonController

                local function stopBall()
                    if ball then
                        ball.AssemblyLinearVelocity = Vector3.zero
                        ball.AssemblyAngularVelocity = Vector3.zero
                        ball.Velocity = Vector3.zero
                        ball.RotVelocity = Vector3.zero
                        ball.Anchored = true
                        task.wait(0.05)
                        ball.Anchored = false
                    end
                end

                while _G.AutoGK do
                    task.wait(0.005)
                    if not _G.AutoGK then break end

                    ball = game.Workspace:FindFirstChild("Football")
                    if ball and rootPart and humanoid then
                        rootPart.CFrame = CFrame.lookAt(rootPart.Position, ball.Position)

                        local ballDist = (ball.Position - myGoal).Magnitude
                        local ballVelocity = ball.AssemblyLinearVelocity
                        local ballSpeed = ballVelocity.Magnitude
                        local ballDirection = ballVelocity.Unit

                        if ballDist < 50 then
                            rootPart.CFrame = CFrame.new(ball.Position + Vector3.new(0, 3, 0))
                            humanoid.JumpPower = 0
                            humanoid:Move(Vector3.new(0, -10, 0))

                            stopBall()

                            -- **Tangkap bola dengan sentuhan paksa**
                            firetouchinterest(rootPart, ball, 0)
                            firetouchinterest(rootPart, ball, 1)

                            -- **Animasi menyelamatkan bola**
                            if ballSpeed > 0 then
                                if ballDirection.X > 0.5 then
                                    animController.DiveR:Play()
                                elseif ballDirection.X < -0.5 then
                                    animController.DiveL:Play()
                                elseif ballDirection.Y > 0.5 then
                                    animController.DiveF:Play()
                                else
                                    animController.DiveF:Play()
                                end
                            end

                            task.wait(0.3)
                            humanoid.JumpPower = 50
                        end
                    end
                end
            end)
        end
    end
})

-- === ESP BALL (Highlight bola dengan warna neon) ===
local function createESP(target)
    if not target then return end
    local esp = Instance.new("Highlight", target)
    esp.FillColor = Color3.fromRGB(0, 255, 0)
    esp.OutlineColor = Color3.fromRGB(255, 255, 255)
    esp.FillTransparency = 0.2
    esp.OutlineTransparency = 0
    esp.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end

local function createBeam(startPart, endPart)
    if startPart and endPart then
        local beam = Instance.new("Beam", startPart)
        beam.Attachment0 = Instance.new("Attachment", startPart)
        beam.Attachment1 = Instance.new("Attachment", endPart)
        beam.Color = ColorSequence.new(Color3.fromRGB(0, 255, 0))
        beam.Width0 = 0.2
        beam.Width1 = 0.2
        beam.LightEmission = 1
    end
end

task.spawn(function()
    while true do
        task.wait(1)
        ball = game.Workspace:FindFirstChild("Football")
        if ball and not ball:FindFirstChild("Highlight") then
            createESP(ball)
        end

        local playerChar = player.Character
        if playerChar and ball and not playerChar:FindFirstChild("Beam") then
            createBeam(playerChar, ball)
        end
    end
end)

-- Kedudukan Dive Box GK
local diveBoxGK = game.Workspace.AI.Home.DiveBox.Position
