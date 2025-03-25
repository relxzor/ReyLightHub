local stopRolling = false
local legendaryProtection = false

local legendaryStyles = {["Don Lorenzo"] = true, ["Shidou"] = true, ["Yukimiya"] = true, ["Sae"] = true,
                         ["Kunigami"] = true, ["Aiku"] = true, ["Rin"] = true, ["King"] = true, ["Nagi"] = true, ["Reo"] = true}

local function lockStyle()
    local args = { [1] = "Slot1", [2] = true }
    local lockService = game:GetService("ReplicatedStorage").Packages.Knit.Services.StyleService.RE.LockSlot
    lockService:FireServer(unpack(args))
end

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

local styles = {"King", "Chigiri", "Bachira", "Shidou", "Nagi", "Isagi", "Gagamaru", "Sae", "Rin", "Aiku", "Reo", "Yukimiya", "Hiori", "Kunigami", "Karasu", "Don Lorenzo"}
for _, style in ipairs(styles) do
    StylesTab:CreateButton({
        Name = "Roll for " .. style .. " Style",
        Callback = function()
            rollStyle(style)
        end
    })
end
