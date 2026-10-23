-- Time Bomb Script - Delta Executer
-- Features: Draggable UI + Minimize (-) Button + Hitbox Control + Speed & Jump

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Clean previous instances
if CoreGui:FindFirstChild("TimeBombDeltaHub") then
    CoreGui.TimeBombDeltaHub:Destroy()
end

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TimeBombDeltaHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Frame (Draggable Container)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 340)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- إمكانية تحريك القائمة بالتسحيب
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

-- Title Bar
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Time Bomb Hub 💣"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 18

-- Minimize Button (-) inside Top Bar
local MiniBtn = Instance.new("TextButton", TitleBar)
MiniBtn.Size = UDim2.new(0, 25, 0, 25)
MiniBtn.Position = UDim2.new(1, -30, 0, 5)
MiniBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
MiniBtn.Text = "-"
MiniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniBtn.Font = Enum.Font.SourceSansBold
MiniBtn.TextSize = 20
Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(0, 6)

-- Open Button (Small Floating Button in Screen Corner with '-')
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Name = "OpenBtn"
OpenBtn.Size = UDim2.new(0, 40, 0, 40)
OpenBtn.Position = UDim2.new(0, 15, 0, 15) -- زاوية الشاشة
OpenBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
OpenBtn.Text = "-"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.TextSize = 22
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true -- إمكانية تحريك زر الإظهار أيضاً
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)

-- Minimize & Restore Functions
MiniBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- Content Frame
local ContentFrame = Instance.new("ScrollingFrame", MainFrame)
ContentFrame.Size = UDim2.new(1, -20, 1, -45)
ContentFrame.Position = UDim2.new(0, 10, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 320)
ContentFrame.ScrollBarThickness = 4

local UIListLayout = Instance.new("UIListLayout", ContentFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

-- Global Variables
_G.HitboxEnabled = false
_G.HitboxSize = 15
_G.InfJump = false

-- Function: Create Button
local function CreateButton(text, callback)
    local btn = Instance.new("TextButton", ContentFrame)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Function: Create Toggle
local function CreateToggle(text, callback)
    local enabled = false
    local btn = Instance.new("TextButton", ContentFrame)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    btn.Text = text .. " : [OFF]"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            btn.Text = text .. " : [ON]"
            btn.BackgroundColor3 = Color3.fromRGB(60, 140, 60)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.Text = text .. " : [OFF]"
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        callback(enabled)
    end)
    return btn
end

-- 1. Hitbox Toggle
CreateToggle("تفعيل الهيت بوكس (Hitbox)", function(state)
    _G.HitboxEnabled = state
    task.spawn(function()
        while _G.HitboxEnabled do
            task.wait(0.2)
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = plr.Character.HumanoidRootPart
                    hrp.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                    hrp.Transparency = 0.6
                    hrp.BrickColor = BrickColor.new("Bright red")
                    hrp.Material = Enum.Material.ForceField
                    hrp.CanCollide = false
                end
            end
        end
    end)
end)

-- 2. Hitbox Size Control (+ / - Buttons)
local SizeFrame = Instance.new("Frame", ContentFrame)
SizeFrame.Size = UDim2.new(1, 0, 0, 35)
SizeFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
Instance.new("UICorner", SizeFrame).CornerRadius = UDim.new(0, 6)

local SizeLabel = Instance.new("TextLabel", SizeFrame)
SizeLabel.Size = UDim2.new(0.5, 0, 1, 0)
SizeLabel.BackgroundTransparency = 1
SizeLabel.Text = "حجم الهيت بوكس: " .. tostring(_G.HitboxSize)
SizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SizeLabel.Font = Enum.Font.SourceSans
SizeLabel.TextSize = 15

local MinusBtn = Instance.new("TextButton", SizeFrame)
MinusBtn.Size = UDim2.new(0.2, -5, 0.8, 0)
MinusBtn.Position = UDim2.new(0.5, 0, 0.1, 0)
MinusBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
MinusBtn.Text = "-"
MinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinusBtn.TextSize = 18
Instance.new("UICorner", MinusBtn).CornerRadius = UDim.new(0, 4)

local PlusBtn = Instance.new("TextButton", SizeFrame)
PlusBtn.Size = UDim2.new(0.2, -5, 0.8, 0)
PlusBtn.Position = UDim2.new(0.75, 0, 0.1, 0)
PlusBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
PlusBtn.Text = "+"
PlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PlusBtn.TextSize = 18
Instance.new("UICorner", PlusBtn).CornerRadius = UDim.new(0, 4)

PlusBtn.MouseButton1Click:Connect(function()
    _G.HitboxSize = math.min(_G.HitboxSize + 5, 60)
    SizeLabel.Text = "حجم الهيت بوكس: " .. tostring(_G.HitboxSize)
end)

MinusBtn.MouseButton1Click:Connect(function()
    _G.HitboxSize = math.max(_G.HitboxSize - 5, 2)
    SizeLabel.Text = "حجم الهيت بوكس: " .. tostring(_G.HitboxSize)
end)

-- 3. Teleport Button
CreateButton("انتقال لأقرب لاعب", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local p1 = LocalPlayer.Character.HumanoidRootPart
        local nearest, closestDist = nil, math.huge
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (p1.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    nearest = plr.Character.HumanoidRootPart
                end
            end
        end
        if nearest then
            p1.CFrame = nearest.CFrame * CFrame.new(0, 0, 2)
        end
    end
end)

-- 4. Speed Boost Toggle
CreateToggle("سرعة عالية (Speed 60)", function(state)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = state and 60 or 16
    end
end)

-- 5. Infinite Jump Toggle
CreateToggle("قفز لا نهائي (Inf Jump)", function(state)
    _G.InfJump = state
end)

UserInputService.JumpRequest:Connect(function()
    if _G.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)
