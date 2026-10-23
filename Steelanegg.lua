-- Steal An Egg Script - Delta Executer
-- Custom Auto Steal & Auto Teleport to Spawn + High Speed

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- تنظيف أي واجهة قديمة لمنع التكرار
if CoreGui:FindFirstChild("EggStealHub") then
    CoreGui.EggStealHub:Destroy()
end

-- إنشاء واجهة المستخدم الرئيسية (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EggStealHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- الإطار الرئيسي (قائمة قابلة للسحب)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 240)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -120)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- سحب وإفلات القائمة في أي مكان بالشاشة
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- شريط العنوان العلوي
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Steal Egg Hub 🥚"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 16

-- زر التصغير للإخفاء (-) داخل الشريط
local MiniBtn = Instance.new("TextButton", TitleBar)
MiniBtn.Size = UDim2.new(0, 25, 0, 25)
MiniBtn.Position = UDim2.new(1, -30, 0, 5)
MiniBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
MiniBtn.Text = "-"
MiniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniBtn.Font = Enum.Font.SourceSansBold
MiniBtn.TextSize = 20
Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(0, 6)

-- زر عائم لإظهار القائمة في الزاوية (على شكل ناقص [-])
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Name = "OpenBtn"
OpenBtn.Size = UDim2.new(0, 40, 0, 40)
OpenBtn.Position = UDim2.new(0, 15, 0, 15)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
OpenBtn.Text = "-"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.TextSize = 22
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)

-- ربط أحداث الإخفاء والإظهار
MiniBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- محتوى القائمة
local ContentFrame = Instance.new("ScrollingFrame", MainFrame)
ContentFrame.Size = UDim2.new(1, -20, 1, -45)
ContentFrame.Position = UDim2.new(0, 10, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 150)
ContentFrame.ScrollBarThickness = 4

local UIListLayout = Instance.new("UIListLayout", ContentFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

-- المتغيرات العامة
_G.AutoSteal = false

-- دالة إنشاء زر التفعيل (Toggle)
local function CreateToggle(text, callback)
    local enabled = false
    local btn = Instance.new("TextButton", ContentFrame)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.Text = text .. " : [OFF]"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 15
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            btn.Text = text .. " : [ON]"
            btn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.Text = text .. " : [OFF]"
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        callback(enabled)
    end)
    return btn
end

-- زر سرقة البيض التلقائي (الرجوع للسبون + سرعة عالية)
CreateToggle("سرقة البيض تلقائياً", function(state)
    _G.AutoSteal = state
    task.spawn(function()
        while _G.AutoSteal do
            task.wait(0.1)
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                    -- تفعيل سرعة عالية جداً للشخصية
                    char.Humanoid.WalkSpeed = 100
                    
                    -- التحقق عما إذا كانت الشخصية تحمل بيضة أو أن هناك بيضة تم التقاطها
                    for _, child in pairs(char:GetChildren()) do
                        if string.lower(child.Name):find("egg") or string.lower(child.Name):find("بيض") or child:IsA("Tool") then
                            -- البحث عن مكان السبون (SpawnLocation) للرجوع إليه فوراً
                            local spawnLocation = nil
                            for _, obj in pairs(Workspace:GetDescendants()) do
                                if objnails or obj:IsA("SpawnLocation") then
                                    spawnLocation = obj
                                    break
                                end
                            end
                            
                            -- إذا وجد السبون، ينتقل إليه فوراً مع البيضة
                            if spawnLocation then
                                char.HumanoidRootPart.CFrame = spawnLocation.CFrame + Vector3.new(0, 3, 0)
                            end
                        end
                    end
                end
            end)
        end
        -- إعادة السرعة للطبيعي عند إيقاف الزر
        if not _G.AutoSteal and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end)
end)
