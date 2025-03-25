task.spawn(function()
    _G.AutoGK = true
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
