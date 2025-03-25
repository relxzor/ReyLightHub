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

-- === FUNGSI RGB ANIMATION ===
local function startRGBEffect(uiElement)
    spawn(function()
        while true do
            for i = 0, 1, 0.01 do
                local color = Color3.fromHSV(i, 1, 1)
                local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
                local tween = TweenService:Create(uiElement, tweenInfo, {BackgroundColor3 = color})
                tween:Play()
                wait(0.1)
            end
        end
    end)
end

-- === GUNAKAN RGB PADA WINDOW ===
startRGBEffect(Window)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = game.Workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- === TAB AIMBOT ===
local MainTab = Window:CreateTab("Aimbot", nil)
local MainSection = MainTab:CreateSection("Aimbot Features")

-- === VARIABEL AIMBOT ===
_G.AimbotEnabled = false
_G.AimbotMode = "None" -- "Blatant" atau "Non-Blatant"
_G.TargetPlayer = nil
_G.AIMBOT_SMOOTHNESS = 5
_G.AIMBOT_FOV = 150

-- === DROPDOWN UNTUK PILIH TARGET ===
local TargetDropdown = MainTab:CreateDropdown({
    Name = "Choose Target",
    Options = {},
    CurrentOption = nil,
    Flag = "AimbotTarget",
    Callback = function(value)
        _G.TargetPlayer = value
    end
})

-- Fungsi untuk kemaskini senarai pemain dalam dropdown
local function updatePlayerList()
    local playerNames = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    TargetDropdown:Refresh(playerNames, nil)
end

-- Kemaskini senarai pemain setiap 3 saat supaya lebih responsif
spawn(function()
    while wait(3) do
        updatePlayerList()
    end
end)

-- === TOGGLE AIMBOT BLATANT ===
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

-- === TOGGLE AIMBOT NON BLATANT ===
MainTab:CreateToggle({
   Name = "Aimbot Non Blatant",
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

-- Fungsi untuk cari pemain terdekat dalam FOV (untuk Non-Blatant)
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = _G.AIMBOT_FOV  

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).magnitude
                
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = rootPart
                end
            end
        end
    end

    return closestPlayer
end

-- Fungsi smooth aim (untuk Non-Blatant)
local function smoothAim(targetPos)
    local currentMousePos = Vector2.new(Mouse.X, Mouse.Y)
    local targetMousePos = Vector2.new(targetPos.X, targetPos.Y)
    
    local moveVector = (targetMousePos - currentMousePos) / _G.AIMBOT_SMOOTHNESS
    mousemoverel(moveVector.X, moveVector.Y) -- Pastikan exploit menyokong ini
end

-- === FUNGSI AIMBOT ===
RunService.RenderStepped:Connect(function()
    if _G.AimbotEnabled then
        if _G.AimbotMode == "Blatant" and _G.TargetPlayer then
            -- Aimbot Blatant: Lock terus ke target
            local targetPlayer = Players:FindFirstChild(_G.TargetPlayer)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = targetPlayer.Character.HumanoidRootPart
                local targetPosition = Camera:WorldToViewportPoint(rootPart.Position)
                local moveX = (targetPosition.X - Mouse.X) / _G.AIMBOT_SMOOTHNESS
                local moveY = (targetPosition.Y - Mouse.Y) / _G.AIMBOT_SMOOTHNESS
                mousemoverel(moveX, moveY)
            end
        elseif _G.AimbotMode == "Non-Blatant" then
            -- Aimbot Non-Blatant: Cari target dalam FOV dan aim perlahan
            local target = getClosestPlayer()
            if target then
                local targetPosition = Camera:WorldToViewportPoint(target.Position)
                smoothAim(targetPosition)
            end
        end
    end
end)

-- === SHOW WINDOW ===
Window:Show()
