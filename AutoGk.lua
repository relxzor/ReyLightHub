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
Key = {"ReyLucky2025"}
}
})

-- === MAIN FEATURES ===
local MainTab = Window:CreateTab("Main", nil)
local MainSection = MainTab:CreateSection("Main Features")

-- Auto GK Toggle
local ToggleAutoGK = MainTab:CreateToggle({
Name = "Auto GK",
CurrentValue = false,
Flag = "AutoGK",
Callback = function(Value)
_G.AutoGK = Value
if _G.AutoGK then
task.spawn(function()
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local ball = game.Workspace:WaitForChild("Football")
local myGoal = game.Workspace.AI.Home.DiveBox.Position
local animController = game:GetService("ReplicatedStorage").Controllers.AnimatonController
local function stopBall()
ball.AssemblyLinearVelocity = Vector3.zero
ball.AssemblyAngularVelocity = Vector3.zero
ball.Velocity = Vector3.zero
ball.RotVelocity = Vector3.zero
ball.Anchored = true
task.wait(0.1)
ball.Anchored = false
end

while _G.AutoGK do  
                task.wait(0.01)  
                if not _G.AutoGK then break end  
                if ball and rootPart and humanoid then  
                    rootPart.CFrame = CFrame.lookAt(rootPart.Position, ball.Position)  
                    if (ball.Position - myGoal).Magnitude < 40 then  
                        rootPart.CFrame = CFrame.new(ball.Position + Vector3.new(0, 3, 0))  
                        humanoid.JumpPower = 0  
                        humanoid:Move(Vector3.new(0, -10, 0))  
                        stopBall()  

                        local ballVelocity = ball.AssemblyLinearVelocity  
                        local ballSpeed = ballVelocity.Magnitude  
                        local ballDirection = ballVelocity.Unit  

                        if ballSpeed > 0 then  
                            if ballDirection.X > 0.5 then  
                                animController.DiveR:Play()  
                            elseif ballDirection.X < -0.5 then  
                                animController.DiveL:Play()  
                            elseif ballDirection.Y > 0.5 then  
                                animController.DiveF:Play()  
                            else  
                                animController.DiveF:Play()  
                            end  
                        end  

                        task.wait(0.5)  
                        humanoid.JumpPower = 50  
                    end  
                end  
            end  
        end)  
    end  
end

})

-- Toggle Auto Steal
local ToggleAutoSteal = MainTab:CreateToggle({
Name = "Auto Steal",
CurrentValue = false,
Flag = "AutoSteal",
Callback = function(Value)
_G.AutoSteal = Value

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local ball = game.Workspace:FindFirstChild("Football")

local function isEnemy(p)    
    return p.Team ~= player.Team    
end    

local function hasBall(p)    
    return p.Character and p.Character:FindFirstChild("HasBall") and p.Character.HasBall.Value    
end    

local function autoSteal()    
    while _G.AutoSteal do    
        task.wait(0.1)    

        if ball then    
            for _, p in pairs(game.Players:GetPlayers()) do    
                if p ~= player and isEnemy(p) and hasBall(p) then    
                    local enemyHRP = p.Character and p.Character:FindFirstChild("HumanoidRootPart")    
                    if enemyHRP and (ball.Position - enemyHRP.Position).Magnitude < 10 then    
                        -- Auto teleport ke bola & ambil    
                        humanoidRootPart.CFrame = CFrame.new(ball.Position + Vector3.new(0, 2, 0))    
                        task.wait(0.05)    
                        firetouchinterest(humanoidRootPart, ball, 0)    
                        firetouchinterest(humanoidRootPart, ball, 1)    
                    end    
                end    
            end    
        end    
    end    
end    

if _G.AutoSteal then    
    task.spawn(autoSteal)    
end

end

})

-- Ambil pemain dan karakter
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local ball = game.Workspace:FindFirstChild("Football")

-- Kedudukan Dive Box GK (Sesuaikan jika perlu)
local diveBoxGK = game.Workspace.AI.Home.DiveBox.Position
