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
    KeySystem = true, -- Enable key system
    KeySettings = {
        Title = "Key | ReyLightHub",
        Subtitle = "Key System",
        Note = "Key In Discord Server (https://discord.gg/b9NuzjaRtv)",
        FileName = "ReyHubKey1", -- Unique file name to prevent overwrites
        SaveKey = false, -- If false, the player must re-enter the key if it changes
        Key = {"ReyLucky2025"} -- List of accepted keys
    }
})

-- === UPDATE NOTIFICATION ===
Rayfield:Notify({
    Title = "⚠️ Script Under Maintenance ⚠️",
    Content = "This script is currently being updated and will not be usable for now.",
    Duration = 10, -- Notification duration in seconds
    Image = nil,
    Actions = {
        Close = {
            Name = "OK",
            Callback = function()
                Window:Destroy() -- Hides all script UI
                print("Script has been disabled due to maintenance.")
            end
        }
    }
})

-- === MAIN FEATURES ===
local MainTab = Window:CreateTab("Main", nil)
local MainSection = MainTab:CreateSection("Main Features")

-- === AUTO FARM ===
local AutoFarmTab = Window:CreateTab("Auto Farm", nil)
local AutoFarmSection = AutoFarmTab:CreateSection("Auto Farm Features")
