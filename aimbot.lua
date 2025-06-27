getgenv().Settings = {
    Prediction = 0.0440,
    AutoClick = false,
}

getgenv().TargetLock = {
    AimPart = "Head",
    Enabled = true,
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local function getClosestPlayer()
    local closest = nil
    local shortestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(getgenv().TargetLock.AimPart) then
            local part = player.Character[getgenv().TargetLock.AimPart]
            local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
            if onScreen then
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closest = part
                end
            end
        end
    end

    return closest
end

RunService.RenderStepped:Connect(function()
    if getgenv().TargetLock.Enabled then
        local target = getClosestPlayer()
        if target then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Position + target.Velocity * getgenv().Settings.Prediction)
        end
    end
end)
