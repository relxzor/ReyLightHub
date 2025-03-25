if not _G.AutoSteal then return end -- Pastikan tidak menjalankan jika toggle OFF

task.spawn(function()
    while _G.AutoSteal do
        task.wait(0.1)
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
end)
