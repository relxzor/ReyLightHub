  _G.AutoDribbleRunning = true    -- Pastikan tiada duplikasi sambungan ke Heartbeat
            if _G.DribbleConnection then _G.DribbleConnection:Disconnect() end

            _G.DribbleConnection = game:GetService("RunService").Heartbeat:Connect(function()
                task.spawn(function() -- Elakkan UI freeze
                    if not _G.AutoDribbleRunning then return end
                    
                    local plr = game.Players.LocalPlayer
                    local char = plr.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if not char or not hrp then return end

                    for _, p in pairs(game.Players:GetPlayers()) do
                        if isEnemy(p) and isSlidingOrFrozen(p) then
                            local enemyHRP = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                            if enemyHRP then
                                local distance = (enemyHRP.Position - hrp.Position).Magnitude
                                if distance < S.range then
                                    autoDribble(distance)
                                    break
                                end
                            end
                        end
                    end
                end)
            end)

        else
            -- Hentikan Auto Dribble jika toggle dimatikan
            if _G.DribbleConnection then
                _G.DribbleConnection:Disconnect()
                _G.DribbleConnection = nil
            end
            _G.AutoDribbleRunning = false
        end
    end
})

function autoDribble(d)
    B:FireServer()
    local s = L:FindFirstChild("PlayerStats") and L.PlayerStats:FindFirstChild("Style") and L.PlayerStats.Style.Value
    local t = getDribbleAnim(s)
    if t then
        t:Play()
        t:AdjustSpeed(math.clamp(1 + (10 - d) / 10, 1, 2))
    end
    local F = workspace:FindFirstChild("Football")
    if F then
        F.AssemblyLinearVelocity = Vector3.new()
        F.CFrame = C.HumanoidRootPart.CFrame * CFrame.new(0, -2.5, 0)
    end
end
