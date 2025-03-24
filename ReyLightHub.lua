-- Load Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("ReyLightHub | Blue Lock Rivals", "DarkTheme")

-- UI Animation Effect
local TweenService = game:GetService("TweenService")
local UI = Window.MainFrame
UI.Position = UDim2.new(0.5, 0, -1, 0)
local Tween = TweenService:Create(UI, TweenInfo.new(1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.5, 0)})
Tween:Play()

-- Main Tab
local MainTab = Window:NewTab("Main Features")
local MainSection = MainTab:NewSection("Premium Features")

-- Auto Dribble
MainSection:NewToggle("Auto Dribble", "Automatically dribble when the ball is at your feet", function(state)
    getgenv().AutoDribble = state
    while getgenv().AutoDribble do
        pcall(function()
            game:GetService("ReplicatedStorage").Packages.Knit.Services.BallService.RE.Dribble:FireServer()
        end)
        wait(0.5)
    end
end)

-- Speed Hack
MainSection:NewSlider("Speed Hack", "Increase movement speed", 100, 16, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

-- Infinite Jump
MainSection:NewToggle("Infinite Jump", "Jump infinitely without restrictions", function(state)
    getgenv().InfiniteJump = state
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if getgenv().InfiniteJump then
            game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end)

-- Close Button (Minimize UI)
local ToggleUI = Window:NewTab("Settings"):NewSection("UI Settings")
ToggleUI:NewButton("Minimize UI", "Hide the interface and show a toggle button", function()
    UI.Visible = false
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = game.CoreGui
    ToggleButton.Size = UDim2.new(0, 150, 0, 50)
    ToggleButton.Position = UDim2.new(0.5, -75, 0.9, 0)
    ToggleButton.Text = "Show UI"
    ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.MouseButton1Click:Connect(function()
        UI.Visible = true
        ToggleButton:Destroy()
    end)
end)
