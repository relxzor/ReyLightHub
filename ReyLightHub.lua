-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

-- Create UI Window
local Window = Rayfield:CreateWindow({
    Name = "ReyLightHub - Blue Lock Rivals",
    LoadingTitle = "Loading ReyLightHub...",
    LoadingSubtitle = "Developed by Developer",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ReyLightHubConfig"
    },
    KeySystem = false
})

-- Background Particle Effect
local function CreateParticles()
    local ParticleEffect = Instance.new("ParticleEmitter")
    ParticleEffect.Parent = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    ParticleEffect.Texture = "rbxassetid://1095708"  -- Ganti jika diperlukan
    ParticleEffect.Rate = 10
    ParticleEffect.Lifetime = NumberRange.new(2, 5)
    ParticleEffect.Speed = NumberRange.new(2, 5)
    ParticleEffect.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0)})
    ParticleEffect.Color = ColorSequence.new(Color3.fromRGB(0, 162, 255))
end

CreateParticles()

-- UI Toggle Button
local UIVisible = true
local UIContainer = Window:GetContainer()
local ToggleButton = Instance.new("TextButton")

ToggleButton.Parent = game.CoreGui
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0.9, 0, 0.05, 0)
ToggleButton.Text = "❌"
ToggleButton.TextScaled = true
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)

ToggleButton.MouseButton1Click:Connect(function()
    UIVisible = not UIVisible
    UIContainer.Visible = UIVisible
    ToggleButton.Text = UIVisible and "❌" or "◻️"
    ToggleButton.BackgroundColor3 = UIVisible and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(50, 255, 50)
end)

-- Main Tab
local MainTab = Window:CreateTab("Main Features")

-- Auto Dribble Settings
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
local function G(s)
    if not A.Dribbles[s] then return nil end
    local I = Instance.new("Animation")
    I.AnimationId = A.Dribbles[s]
    return M and M:LoadAnimation(I)
end

local function T(p)
    if p == L then return false end
    local c = p.Character
    if not c then return false end
    local V = c.Values and c.Values.Sliding
    if V and V.Value == true then return true end
    local h = c:FindFirstChildOfClass("Humanoid")
    if h and h.MoveDirection.Magnitude > 0 and h.WalkSpeed == 0 then return true end
    return false
end

local function O(p)
    if not L.Team or not p.Team then return false end
    return L.Team ~= p.Team
end

local function D(d)
    if not S.Enabled or not C.Values.HasBall.Value then return end
    B:FireServer()
    local s = L.PlayerStats.Style.Value
    local t = G(s)
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

U.Heartbeat:Connect(function()
    if not S.Enabled or not C or not H then return end
    for _, p in pairs(P:GetPlayers()) do
        if O(p) and T(p) then
            local r = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if r then
                local d = (r.Position - H.Position).Magnitude
                if d < S.range then
                    D(d)
                    break
                end
            end
        end
    end
end)

-- Toggle Auto Dribble
MainTab:CreateToggle({
    Name = "Auto Dribble",
    CurrentValue = getgenv().AutoDribbleSettings.Enabled,
    Callback = function(state)
        getgenv().AutoDribbleSettings.Enabled = state
    end
})

-- Dribble Range Slider
MainTab:CreateSlider({
    Name = "Dribble Range",
    Range = {10, 30},
    Increment = 1,
    CurrentValue = getgenv().AutoDribbleSettings.range,
    Callback = function(value)
        getgenv().AutoDribbleSettings.range = value
    end
})

-- Notification
Rayfield:Notify({
    Title = "ReyLightHub",
    Content = "Auto Dribble successfully loaded!",
    Duration = 5,
    Actions = {
        Ignore = {
            Name = "OK",
            Callback = function() end
        }
    }
})
