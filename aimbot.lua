-- CONFIG
getgenv().TargetLock = {
    Enabled = false,
    LockedPlayer = nil,
    AimPart = "HumanoidRootPart", -- ou "Head"
    Prediction = 0.1,
}

-- SERVIÇOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "TargetLockGUI"
gui.ResetOnSpawn = false

local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 160, 0, 50)
button.Position = UDim2.new(0.5, -80, 0.9, 0)
button.Text = "🔒 Lock Target"
button.TextSize = 22
button.Font = Enum.Font.SourceSansBold
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.TextColor3 = Color3.new(1, 1, 1)
button.BorderSizePixel = 0
button.Draggable = true

button.MouseButton1Click:Connect(function()
    if getgenv().TargetLock.Enabled then
        getgenv().TargetLock.Enabled = false
        getgenv().TargetLock.LockedPlayer = nil
        button.Text = "🔒 Lock Target"
        button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    else
        local closest, distance = nil, math.huge
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local part = player.Character.HumanoidRootPart
                local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(LocalPlayer:GetMouse().X, LocalPlayer:GetMouse().Y)).Magnitude
                    if dist < distance then
                        distance = dist
                        closest = player
                    end
                end
            end
        end

        if closest then
            getgenv().TargetLock.LockedPlayer = closest
            getgenv().TargetLock.Enabled = true
            button.Text = "✅ Target Locked"
            button.BackgroundColor3 = Color3.fromRGB(60, 220, 80)
        end
    end
end)
-- Mira a câmera para o jogador travado
RunService.RenderStepped:Connect(function()
    local locked = getgenv().TargetLock
    if locked.Enabled and locked.LockedPlayer and locked.LockedPlayer.Character and locked.LockedPlayer.Character:FindFirstChild(locked.AimPart) then
        local part = locked.LockedPlayer.Character[locked.AimPart]
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, part.Position + part.Velocity * locked.Prediction)
    end
end)
-- Auto Shoot (somente se a LockedPlayer estiver travada)
local UserInputService = game:GetService("UserInputService")

RunService.RenderStepped:Connect(function()
    local locked = getgenv().TargetLock
    if locked.Enabled and locked.LockedPlayer and locked.LockedPlayer.Character then
        -- Simula clique do mouse (funciona em alguns jogos com arco padrão)
        mouse1click()
    end
end)
