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

-- === STYLES TAB ===
local stylesTab = DrRayLibrary.newTab("Styles", "")

local stopRolling = false -- Flag to control when to stop rolling
local legendaryProtection = false -- Toggle for stopping at Legendary+ styles

-- Legendary+ styles list
local legendaryStyles = {["Don Lorenzo"] = true, ["Shidou"] = true, ["Yukimiya"] = true, ["Sae"] = true,
["Kunigami"] = true, ["Aiku"] = true, ["Rin"] = true, ["King"] = true, ["Nagi"] = true, ["Reo"] = true}

-- Function to lock the acquired style
local function lockStyle()
local args = {
[1] = "Slot1",
[2] = true
}
local lockService = game:GetService("ReplicatedStorage").Packages.Knit.Services.StyleService.RE.LockSlot
lockService:FireServer(unpack(args))
print("Style locked successfully!")
end

-- Function to roll for the desired style
local function rollStyle(styleName)
local player = game.Players.LocalPlayer
local styleService = game:GetService("ReplicatedStorage").Packages.Knit.Services.StyleService.RE.Spin

stopRolling = false -- Reset the flag  

while not stopRolling do  
    task.wait(0.6) -- Rolling speed for styles  
    if player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("Style") then  
        local currentStyle = player.PlayerStats.Style.Value  

        -- Stop if we get the exact style or a Legendary+ style (if enabled)  
        if currentStyle == styleName or (legendaryProtection and legendaryStyles[currentStyle]) then  
            print(currentStyle .. " Style activated!")  
            lockStyle() -- Lock the style immediately  
            stopRolling = true -- Stop rolling  
            stopButton.MouseButton1Click:Fire() -- Simulate clicking Stop Rolls  
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
stylesTab.newButton(style, "Roll for " .. style .. " Style", function()
rollStyle(style)
end)
end

-- === FLOWS TAB ===
local flowsTab = DrRayLibrary.newTab("Flows", "")

-- Function to roll for the desired flow
local function rollFlow(flowName)
local player = game.Players.LocalPlayer
local flowService = game:GetService("ReplicatedStorage").Packages.Knit.Services.FlowService.RE.Spin

stopRolling = false -- Reset the flag  

while not stopRolling do  
    task.wait(1) -- Rolling speed for flows  
    if player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("Flow") then  
        local currentFlow = player.PlayerStats.Flow.Value  
        if currentFlow == flowName then  
            print(flowName .. " Flow activated!")  
            stopRolling = true -- Stop rolling  
            stopButton.MouseButton1Click:Fire() -- Simulate clicking Stop Rolls  
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
flowsTab.newButton(flow, "Roll for " .. flow .. " Flow", function()
rollFlow(flow)
end)
end

-- === STOP ROLLING GUI ===
local stopRollsGui = Instance.new("ScreenGui")
stopRollsGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
stopRollsGui.Name = "StopRollsGUI"

local stopButton = Instance.new("TextButton")
stopButton.Text = "Stop Rolls"
stopButton.Size = UDim2.new(0, 150, 0, 50)
stopButton.Position = UDim2.new(0, 0, 0, 0) -- Top-left corner
stopButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
stopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stopButton.Parent = stopRollsGui

-- Stop Rolling button action
stopButton.MouseButton1Click:Connect(function()
stopRolling = true
print("Rolling stopped.")
end)

-- === LEGENDARY+ TOGGLE BUTTON ===
local legendaryToggle = Instance.new("TextButton")
legendaryToggle.Text = "Legendary+ Protection: OFF"
legendaryToggle.Size = UDim2.new(0, 200, 0, 50)
legendaryToggle.Position = UDim2.new(0, 160, 0, 0) -- Next to Stop Rolls button
legendaryToggle.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
legendaryToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
legendaryToggle.Parent = stopRollsGui

-- Toggle action
legendaryToggle.MouseButton1Click:Connect(function()
legendaryProtection = not legendaryProtection -- Toggle the flag
if legendaryProtection then
legendaryToggle.Text = "Legendary+ Protection: ON"
legendaryToggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
print("Legendary+ Protection enabled!")
else
legendaryToggle.Text = "Legendary+ Protection: OFF"
legendaryToggle.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
print("Legendary+ Protection disabled!")
end
end)

-- === SHOW THE WINDOW ===
window:Show()

