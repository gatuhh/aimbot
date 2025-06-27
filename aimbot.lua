-- CONFIGURAÇÕES
getgenv().Settings = {
    Prediction = 0.0440,
    AutoClick = false,
}

getgenv().TargetLock = {
    AimPart = "Head",
    Enabled = false, -- Começa desligado
}

-- SERVIÇOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- GUI DO BOTÃO
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "AimbotToggleGui"

local Button = Instance.new("TextButton", ScreenGui)
Button.Size = UDim2.new(0, 140, 0, 50)
Button.Position = UDim2.new(0.5, -70, 0.9, 0)
Button.Text = "Ativar Aimbot"
Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Button.TextColor3 = Color3.new(1, 1, 1)
Button.Font = Enum.Font.SourceSansBold
Button.TextSize = 22
Button.BorderSizePixel = 0
Button.Active = true
Button.Draggable = true

Button.MouseButton1Click:Connect(function()
    getgenv().TargetLock.Enabled = not getgenv().TargetLock.Enabled
    Button.Text = getgenv().TargetLock.Enabled and "Desativar Aimbot" or "Ativar Aimbot"
    Button.BackgroundColor3 = getgenv().TargetLock.Enabled and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(0, 170, 255)
end)

-- FUNÇÃO PARA ENCONTRAR O INIMIGO MAIS PRÓXIMO DO MOUSE
local function getClosestTarget()
    local closestPart = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(getgenv().TargetLock.AimPart) then
            local part = player.Character[getgenv().TargetLock.AimPart]
            local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
            if onScreen then
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPart = part
                end
            end
        end
    end

    return closestPart
end

-- LOOP PARA MOVER A MIRA
RunService.RenderStepped:Connect(function()
    if getgenv().TargetLock.Enabled then
        local target = getClosestTarget()
        if target then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Position + target.Velocity * getgenv().Settings.Prediction)
        end
    end
end)
