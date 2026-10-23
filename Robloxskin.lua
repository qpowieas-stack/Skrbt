-- Roblox Delta Multi-Tool GUI (Infinite Jump + Fly + Speed + Noclip)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- تنظيف الواجهة القديمة
if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("MultiToolGui") then
    LocalPlayer.PlayerGui.MultiToolGui:Destroy()
end

-- Variables
local InfiniteJumpEnabled = false
local NoclipEnabled = false
local Flying = false
local FlySpeed = 50

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MultiToolGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 260, 0, 310)
MainFrame.Position = UDim2.new(0.5, -130, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 35)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "قائمة الأدوات المتقدمة ⚡"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 15
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = MainFrame

-- Helper Function to Create Buttons
local function createButton(text, pos, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 35)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.TextSize = 13
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    return btn
end

-- Buttons Creation
local InfJumpBtn = createButton("القفز اللانهائي: معطل ❌", UDim2.new(0.075, 0, 0.15, 0), Color3.fromRGB(180, 50, 50))
local SpeedBtn = createButton("زيادة السرعة (x2) 🏃", UDim2.new(0.075, 0, 0.30, 0), Color3.fromRGB(0, 140, 255))
local FlyBtn = createButton("الطيران (Fly): معطل ❌", UDim2.new(0.075, 0, 0.45, 0), Color3.fromRGB(180, 50, 50))
local NoclipBtn = createButton("اختراق الجدران: معطل ❌", UDim2.new(0.075, 0, 0.60, 0), Color3.fromRGB(180, 50, 50))
local ResetSpeedBtn = createButton("إعادة السرعة العادية 🔄", UDim2.new(0.075, 0, 0.75, 0), Color3.fromRGB(70, 70, 80))

-- Toggle GUI Button (زر تصغير/إخفاء القائمة)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0, 10, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "⚡"
ToggleBtn.TextSize = 20
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- 1. Infinite Jump Logic
InfJumpBtn.MouseButton1Click:Connect(function()
    InfiniteJumpEnabled = not InfiniteJumpEnabled
    if InfiniteJumpEnabled then
        InfJumpBtn.Text = "القفز اللانهائي: مفعل ✅"
        InfJumpBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
    else
        InfJumpBtn.Text = "القفز اللانهائي: معطل ❌"
        InfJumpBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

-- 2. Speed Logic
SpeedBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char.Humanoid.WalkSpeed = 50
    end
end)

ResetSpeedBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char.Humanoid.WalkSpeed = 16
    end
end)

-- 3. Noclip Logic
NoclipBtn.MouseButton1Click:Connect(function()
    NoclipEnabled = not NoclipEnabled
    if NoclipEnabled then
        NoclipBtn.Text = "اختراق الجدران: مفعل ✅"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
    else
        NoclipBtn.Text = "اختراق الجدران: معطل ❌"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    end
end)

RunService.Stepped:Connect(function()
    if NoclipEnabled then
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- 4. Fly Logic
FlyBtn.MouseButton1Click:Connect(function()
    Flying = not Flying
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    if Flying then
        FlyBtn.Text = "الطيران (Fly): مفعل ✅"
        FlyBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 80)
        
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyVelocity"
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Parent = hrp

        task.spawn(function()
            while Flying and char and hrp:FindFirstChild("FlyVelocity") do
                local cam = workspace.CurrentCamera
                bv.Velocity = cam.CFrame.LookVector * FlySpeed
                task.wait()
            end
            if bv then bv:Destroy() end
        end)
    else
        FlyBtn.Text = "الطيران (Fly): معطل ❌"
        FlyBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        if hrp:FindFirstChild("FlyVelocity") then
            hrp.FlyVelocity:Destroy()
        end
    end
end)
