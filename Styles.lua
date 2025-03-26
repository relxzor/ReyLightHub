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
        Key = {"ReySpiner"}
    }
})

-- === MAIN FEATURES ===
local MainTab = Window:CreateTab("Main", nil)
local MainSection = MainTab:CreateSection("Main Features")

local stopRolling = false
local legendaryProtection = false
local autoRejoin = false -- Toggle untuk rejoin server

local legendaryStyles = {
    ["Don Lorenzo"] = true, ["Shidou"] = true, ["Yukimiya"] = true, 
    ["Sae"] = true, ["Kunigami"] = true, ["Aiku"] = true, 
    ["Rin"] = true, ["King"] = true, ["Nagi"] = true, ["Reo"] = true
}

-- Function to lock style
local function lockStyle()
    local args = { [1] = "Slot1", [2] = true }
    local lockService = game:GetService("ReplicatedStorage").Packages.Knit.Services.StyleService.RE.LockSlot
    lockService:FireServer(unpack(args))
end

-- Function to roll for a style
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

-- Add buttons for styles
local styles = {"King", "Chigiri", "Bachira", "Shidou", "Nagi", "Isagi", "Gagamaru", "Sae", "Rin", "Aiku", "Reo", "Yukimiya", "Hiori", "Kunigami", "Karasu", "Don Lorenzo"}
for _, style in ipairs(styles) do
    MainTab:CreateButton({
        Name = "Roll for " .. style,
        Callback = function()
            rollStyle(style)
        end
    })
end

-- === FLOWS TAB ===
local FlowsTab = Window:CreateTab("Flows", nil)
local function rollFlow(flowName)
    local player = game.Players.LocalPlayer
    local flowService = game:GetService("ReplicatedStorage").Packages.Knit.Services.FlowService.RE.Spin
    stopRolling = false  

    while not stopRolling do  
        task.wait(1)
        if player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("Flow") then  
            local currentFlow = player.PlayerStats.Flow.Value
            if currentFlow == flowName then  
                stopRolling = true  
                return  
            else  
                flowService:FireServer()  
            end  
        end  
    end
end

-- Add buttons for flows
local flows = {"Lighting", "Puzzle", "Monster", "Gale Burst", "King's Instinct", "Genius", "Awakened Genius", "Wild Card", "Demon Wings", "Snake", "Prodigy", "Chameleon", "Ice", "Trap", "Dribbler", "Crow Ability", "Soul Harvester"}
for _, flow in ipairs(flows) do
    FlowsTab:CreateButton({
        Name = "Roll for " .. flow,
        Callback = function()
            rollFlow(flow)
        end
    })
end

-- === STOP ROLLING BUTTON ===
MainTab:CreateButton({
    Name = "Stop Rolling",
    Callback = function()
        stopRolling = true
    end
})

-- === LEGENDARY PROTECTION TOGGLE ===
MainTab:CreateToggle({
    Name = "Legendary+Protection",
    Default = false,
    Callback = function(value)
        legendaryProtection = value
    end
})

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local function RejoinServer()
    local player = Players.LocalPlayer
    local servers = {}  -- Simpan senarai ID pelayan

    -- Dapatkan senarai pelayan (memerlukan HttpService jika executor menyokong)
    local HttpService = game:GetService("HttpService")
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    
    local success, result = pcall(function()
        return HttpService:GetAsync(url)
    end)

    if success then
        local data = HttpService:JSONDecode(result)
        for _, server in pairs(data.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end
    end

    -- Jika ada pelayan yang tersedia, teleport pemain ke pelayan lain
    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], player)
    else
        TeleportService:Teleport(game.PlaceId, player) -- Jika tiada, rejoin pelayan sekarang
    end
end

-- Buat toggle untuk rejoin
MainTab:CreateToggle({
    Name = "Rejoin Server",
    Default = false,
    Callback = function(value)
        if value then
            RejoinServer()
        end
    end
})

Window:Show()
