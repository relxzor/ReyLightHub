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

-- Pastikan _G.PlayerESP wujud supaya tidak ada ralat
_G.PlayerESP = _G.PlayerESP or false  

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
