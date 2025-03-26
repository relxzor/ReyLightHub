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

-- === TOGGLE REJOIN SERVER ===
MainTab:CreateToggle({
    Name = "Rejoin Server",
    Default = false,
    Callback = function(value)
        autoRejoin = value
    end
})

-- Auto Rejoin Server Function
local function rejoinServer()
    if autoRejoin then
        local TeleportService = game:GetService("TeleportService")
        TeleportService:Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
end

-- Rejoin Button
MainTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        rejoinServer()
    end
})

Window:Show()
