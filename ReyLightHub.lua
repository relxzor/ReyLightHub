-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

-- Create UI Window
local Window = Rayfield:CreateWindow({
    Name = "Blue Lock Rivals | Script",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Please wait...",
    ConfigurationSaving = {Enabled = false},
    Discord = {Enabled = false},
    KeySystem = false
})

-- Tab utama untuk fitur
local MainTab = Window:CreateTab("Main Features", 4483362458)

-- Section Auto Dribble
local DribbleSection = MainTab:CreateSection("Auto Dribble")

-- Toggle untuk mengaktifkan / menonaktifkan Auto Dribble
local AutoDribbleToggle = MainTab:CreateToggle({
    Name = "Enable Auto Dribble",
    CurrentValue = true,
    Callback = function(state)
        getgenv().AutoDribbleSettings.Enabled = state
    end
})

-- Slider untuk mengatur jarak dribble
MainTab:CreateSlider({
    Name = "Dribble Range",
    Range = {10, 30},
    Increment = 1,
    CurrentValue = 22,
    Callback = function(value)
        getgenv().AutoDribbleSettings.range = value
    end
})

-- UI untuk Auto AFK
local AFKSection = MainTab:CreateSection("Anti-AFK")

-- Toggle untuk mengaktifkan Anti-AFK
local AFKToggle = MainTab:CreateToggle({
    Name = "Enable Anti-AFK",
    CurrentValue = false,
    Callback = function(state)
        getgenv().afk_toggle = state
    end
})

-- Tombol untuk menutup UI
MainTab:CreateButton({
    Name = "Close UI",
    Callback = function()
        Window:Destroy()
    end
})

----------------------------
-- SCRIPT AUTO DRIBBLE
----------------------------
if not getgenv().AutoDribbleSettings then
    getgenv().AutoDribbleSettings = {Enabled = true, range = 22}
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
    if t then t:Play(); t:AdjustSpeed(math.clamp(1 + (10 - d) / 10, 1, 2)) end
    local F = workspace:FindFirstChild("Football")
    if F then F.AssemblyLinearVelocity = Vector3.new(); F.CFrame = C.HumanoidRootPart.CFrame * CFrame.new(0, -2.5, 0) end
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

----------------------------
-- SCRIPT ANTI-AFK
----------------------------
local VirtualUser = game:GetService("VirtualUser")
local plr = game:GetService("Players").LocalPlayer

plr.Idled:Connect(function()
    if not getgenv().afk_toggle then return end
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)
