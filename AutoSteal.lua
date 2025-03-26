

-- Hitbox & Football Expander for Blue Lock Rivals (Mobile)
local hitboxEnabled = false
local hitboxSize = Vector3.new(12, 12, 12) -- Enlarged enemy hitbox
local ballSize = Vector3.new(15, 15, 15) -- Enlarged football size

-- Function to toggle hitbox & football size
local function toggleFeatures()
    hitboxEnabled = not hitboxEnabled
    
    -- Toggle hitbox for enemies
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local hitbox = character:FindFirstChild("HumanoidRootPart")
                if hitboxEnabled then
                    hitbox.Size = hitboxSize
                    hitbox.Transparency = 0.5
                    hitbox.Material = Enum.Material.ForceField
                else
                    hitbox.Size = Vector3.new(2, 2, 1) -- Default size
                    hitbox.Transparency = 1
                    hitbox.Material = Enum.Material.Plastic
                end
            end
        end
    end

    -- Toggle football size
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Part") and obj.Name:lower():find("football") then
            if hitboxEnabled then
                obj.Size = ballSize
                obj.Material = Enum.Material.Neon
                obj.Transparency = 0.2
            else
                obj.Size = Vector3.new(5, 5, 5) -- Default football size
                obj.Material = Enum.Material.SmoothPlastic
                obj.Transparency = 0
            end
        end
    end
end

-- Create a toggle button for mobile
local toggleButton = Instance.new("TextButton")
toggleButton.Parent = game.CoreGui
toggleButton.Size = UDim2.new(0, 100, 0, 50)
toggleButton.Position = UDim2.new(0.85, 0, 0.8, 0) -- Adjust position on screen
toggleButton.Text = "Toggle"
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
toggleButton.TextScaled = true
toggleButton.TextColor3 = Color3.new(1, 1, 1)

-- Connect button to toggle function
toggleButton.MouseButton1Click:Connect(toggleFeatures)

-- Auto-expand hitbox when new players join
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1)
        if hitboxEnabled then
            toggleFeatures()
        end
    end)
end)

-- Auto-expand football when new footballs spawn
workspace.ChildAdded:Connect(function(obj)
    if obj:IsA("Part") and obj.Name:lower():find("football") then
        wait(1)
        if hitboxEnabled then
            toggleFeatures()
        end
    end
end)
