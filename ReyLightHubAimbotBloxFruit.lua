local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local TweenService = game:GetService("TweenService")

local Window = Rayfield:CreateWindow({
   Name = "ReyLightHub | Blox Fruit",
   LoadingTitle = "Blox Fruit",
   LoadingSubtitle = "by ReyLight",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = "ReyLightHub",
      FileName = "Config"
   },
   Discord = {
      Enabled = false,
      Invite = "b9NuzjaRtv",
      RememberJoins = true
   },
   KeySystem = false
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- === AIMBOT TAB ===
local MainTab = Window:CreateTab("Main", nil)
local MainSection = MainTab:CreateSection("Main Features")

-- === AIMBOT VARIABLES ===
_G.AimbotEnabled = false
_G.AimbotMode = "None" -- "Blatant" or "Non-Blatant"
_G.TargetPlayer = nil
_G.AIMBOT_SMOOTHNESS = 5
_G.AIMBOT_FOV = 150
_G.ESPEnabled = false

-- === DROPDOWN TO SELECT TARGET ===
local TargetDropdown = MainTab:CreateDropdown({
    Name = "Choose Target",
    Options = {},
    CurrentOption = nil,
    Flag = "AimbotTarget",
    Callback = function(value)
        _G.TargetPlayer = value
    end
})

-- Function to update player list in dropdown
local function updatePlayerList()
    local playerNames = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    TargetDropdown:Refresh(playerNames, nil)
end

-- Update player list every 3 seconds for responsiveness
spawn(function()
    while wait(3) do
        updatePlayerList()
    end
end)

-- === FUNCTION TO FIND SELECTED TARGET ===
local function getSelectedPlayer()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name == _G.TargetPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            return player.Character.HumanoidRootPart
        end
    end
    return nil
end

-- === AIMBOT TOGGLE ===
MainTab:CreateToggle({
   Name = "Aimbot Non-Blatant",
   CurrentValue = false,
   Flag = "AimbotNonBlatant",
   Callback = function(Value)
       _G.AimbotEnabled = Value
       if Value then
           _G.AimbotMode = "Non-Blatant"
       else
           _G.AimbotMode = "None"
       end
   end
})

MainTab:CreateToggle({
   Name = "Aimbot Blatant",
   CurrentValue = false,
   Flag = "AimbotBlatant",
   Callback = function(Value)
       _G.AimbotEnabled = Value
       if Value then
           _G.AimbotMode = "Blatant"
       else
           _G.AimbotMode = "None"
       end
   end
})

-- === TELEPORT FUNCTION ===
local function teleportToPlayer()
    local target = getSelectedPlayer()
    if target then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.CFrame
    end
end

-- === TELEPORT BUTTON ===
MainTab:CreateButton({
    Name = "Teleport to Target",
    Callback = function()
        teleportToPlayer()
    end
})

-- === ESP WALLHACK FUNCTION ===
local function createESP(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") and not part:FindFirstChild("ESPBox") then
                local esp = Instance.new("BoxHandleAdornment")
                esp.Name = "ESPBox"
                esp.Adornee = part
                esp.AlwaysOnTop = true
                esp.ZIndex = 5
                esp.Size = part.Size
                esp.Color3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
                esp.Transparency = 0.3
                esp.Parent = part
            end
        end
    end
end

local function enableESP()
    while _G.ESPEnabled do
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                createESP(player)
            end
        end
        wait(1)
    end
end

MainTab:CreateToggle({
   Name = "Enable ESP Wallhack",
   CurrentValue = false,
   Flag = "ESPWallhack",
   Callback = function(Value)
       _G.ESPEnabled = Value
       if Value then
           spawn(enableESP)
       else
           for _, player in pairs(Players:GetPlayers()) do
               if player.Character then
                   for _, part in pairs(player.Character:GetChildren()) do
                       if part:IsA("BasePart") then
                           local esp = part:FindFirstChild("ESPBox")
                           if esp then
                               esp:Destroy()
                           end
                       end
                   end
               end
           end
       end
   end
})

-- === AIMBOT FOR MOBILE ===
RunService.RenderStepped:Connect(function()
    if _G.AimbotEnabled then
        local target = getSelectedPlayer()
        if target then
            if _G.AimbotMode == "Blatant" then
                -- **BLATANT AIMBOT: FULL LOCK ON TARGET**
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            elseif _G.AimbotMode == "Non-Blatant" then
                -- **NON-BLATANT AIMBOT: SMOOTH AIM**
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), _G.AIMBOT_SMOOTHNESS / 100)
            end
        end
    end
end)

-- === SHOW WINDOW ===
Window:Show()
