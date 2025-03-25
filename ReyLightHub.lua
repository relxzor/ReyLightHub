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
      FileName = "ReyHubKey",
      SaveKey = false,
      Key = {"ReyLucky2025"}
   }
})

-- Tabs
local MainTab = Window:CreateTab("Main", nil)
local AutoFarmTab = Window:CreateTab("Auto Farm", nil)
local SpeedTab = Window:CreateTab("Speed", nil)
local ESPTab = Window:CreateTab("ESP", nil)
local StylesTab = Window:CreateTab("Styles", nil)

-- Sections
local MainSection = MainTab:CreateSection("Main Features")
local AutoFarmSection = AutoFarmTab:CreateSection("Auto Farm Features")
local SpeedSection = SpeedTab:CreateSection("Speed Hack Features")
local ESPSection = ESPTab:CreateSection("ESP Feature")
local StylesSection = StylesTab:CreateSection("Styles & Flows Rolling")

-- AUTO SHOOT
MainTab:CreateToggle({
    Name = "Auto Shoot",
    Default = false,
    Callback = function(state)
        if state then
            AutoShootScript = loadstring(game:HttpGet("https://raw.githubusercontent.com/relxzor/ReyLightHub/main/AutoShoot.lua"))()
        else
            AutoShootScript = nil
        end
    end
})

-- BALL ESP
ESPTab:CreateToggle({
    Name = "ESP Ball",
    Default = false,
    Callback = function(state)
        if state then
            ESPBallScript = loadstring(game:HttpGet("https://raw.githubusercontent.com/relxzor/ReyLightHub/main/EspBall.lua"))()
        else
            ESPBallScript = nil
        end
    end
})

-- PLAYER ESP
ESPTab:CreateToggle({
    Name = "ESP Player",
    Default = false,
    Callback = function(state)
        if state then
            ESPPlayerScript = loadstring(game:HttpGet("https://raw.githubusercontent.com/relxzor/ReyLightHub/main/PlayerEsp.lua"))()
        else
            ESPPlayerScript = nil
        end
    end
})

-- STYLE ROLLING SYSTEM
local function rollStyle(styleName)
    local player = game.Players.LocalPlayer
    local styleService = game:GetService("ReplicatedStorage").RollStyle
    local legendaryStyles = {["King"] = true, ["Sae"] = true, ["Rin"] = true} -- Tambah style lain jika perlu
    local stopRolling = false

    while not stopRolling do
        task.wait(0.5)
        local currentStyle = player.PlayerStats.Style.Value
        if currentStyle == styleName or legendaryStyles[currentStyle] then
            stopRolling = true
            return
        else
            styleService:FireServer()
        end
    end
end

local styles = {"King", "Chigiri", "Bachira", "Shidou", "Nagi", "Isagi", "Gagamaru", "Sae", "Rin", "Aiku", "Reo", "Yukimiya", "Hiori", "Kunigami", "Karasu", "Don Lorenzo"}
for _, style in ipairs(styles) do
    StylesTab:CreateButton({
        Name = "Roll for " .. style .. " Style",
        Callback = function()
            rollStyle(style)
        end
    })
end

-- STOP ROLLING BUTTON
StylesTab:CreateButton({
   Name = "Stop Rolls",
   Callback = function()
       stopRolling = true
   end
})

-- LEGENDARY+ PROTECTION TOGGLE
StylesTab:CreateToggle({
   Name = "Legendary+ Protection",
   Default = false,
   Callback = function(state)
       legendaryProtection = state
   end
})

-- AUTO GK
AutoFarmTab:CreateToggle({
    Name = "Auto GK",
    Default = false,
    Callback = function(state)
        if state then
            AutoGkScript = loadstring(game:HttpGet("https://raw.githubusercontent.com/relxzor/ReyLightHub/main/AutoGk.lua"))()
        else
            AutoGkScript = nil
        end
    end
})

-- AUTO STEAL
AutoFarmTab:CreateToggle({
    Name = "Auto Steal",
    Default = false,
    Callback = function(state)
        if state then
            AutoStealScript = loadstring(game:HttpGet("https://raw.githubusercontent.com/relxzor/ReyLightHub/main/AutoSteal.lua"))()
        else
            AutoStealScript = nil
        end
    end
})

-- Speed Multiplier Slider
SpeedTab:CreateSlider({
    Name = "Speed Multiplier",
    Min = 1,
    Max = 50,
    Increment = 1,
    Default = 10,
    Callback = function(value)
        _G.SpeedMultiplier = value
    end
})

-- Tunjukkan Window
Window:Show()
