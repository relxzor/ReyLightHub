local plr = game.Players.LocalPlayer
local ball = workspace:FindFirstChild("Football")
local goal = workspace:FindFirstChild("Goal")

if ball and goal then
    local distance = (plr.Character.HumanoidRootPart.Position - goal.Position).Magnitude
    if distance < 15 then
        firetouchinterest(plr.Character.HumanoidRootPart, ball, 0)
        task.wait(0.1) -- Tunggu sekejap sebelum memutuskan sentuhan
        firetouchinterest(plr.Character.HumanoidRootPart, ball, 1)
    end
end
