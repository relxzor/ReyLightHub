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
        Key = {"ReyHitBox512011"}
    }
})

-- === MAIN FEATURES ===
local MainTab = Window:CreateTab("Main", nil)
local MainSection = MainTab:CreateSection("Main Features")

local hitboxEnabled = false
local hitboxSize = Vector3.new(12, 12, 12) -- Besarkan hitbox musuh
local ballSize = Vector3.new(15, 15, 15) -- Besarkan bola

-- Fungsi untuk mengubah saiz hitbox pemain lawan
local function updateHitboxes()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            local hitbox = player.Character:FindFirstChild("HumanoidRootPart")
            if hitbox then
                hitbox.Size = hitboxEnabled and hitboxSize or Vector3.new(2, 2, 1)
                hitbox.Transparency = hitboxEnabled and 0.5 or 1
                hitbox.Material = hitboxEnabled and Enum.Material.ForceField or Enum.Material.Plastic
            end
        end
    end
end

-- Fungsi untuk mengubah saiz bola di padang
local function updateFootballSize()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Part") and obj.Name:lower():find("football") then
            obj.Size = hitboxEnabled and ballSize or Vector3.new(5, 5, 5)
            obj.Material = hitboxEnabled and Enum.Material.Neon or Enum.Material.SmoothPlastic
            obj.Transparency = hitboxEnabled and 0.2 or 0
        end
    end
end

-- Fungsi utama untuk toggle
local function toggleFeatures()
    hitboxEnabled = not hitboxEnabled
    updateHitboxes()
    updateFootballSize()
end

-- UI Button (Mudah Alih)
local toggleButton = Instance.new("TextButton")
toggleButton.Parent = game.CoreGui
toggleButton.Size = UDim2.new(0, 120, 0, 50)
toggleButton.Position = UDim2.new(0.85, 0, 0.8, 0)
toggleButton.Text = "Toggle"
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 180)
toggleButton.TextScaled = true
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.MouseButton1Click:Connect(toggleFeatures)

-- Auto-expand hitbox apabila pemain baru masuk
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if hitboxEnabled then updateHitboxes() end
    end)
end)

-- Auto-expand bola apabila objek bola baru dimasukkan
workspace.ChildAdded:Connect(function(obj)
    if obj:IsA("Part") and obj.Name:lower():find("football") then
        task.wait(1)
        if hitboxEnabled then updateFootballSize() end
    end
end)
