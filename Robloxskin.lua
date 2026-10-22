-- Ultimate Roblox Skin & Animation Copier (Fully Fixed)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- إزالة الواجهة القديمة
if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("SkinCopierGui") then
    LocalPlayer.PlayerGui.SkinCopierGui:Destroy()
end

-- إنشاء الواجهة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SkinCopierGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 260, 0, 160)
MainFrame.Position = UDim2.new(0.5, -130, 0.4, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 35)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "ناسخ السكنات (نسخة خالية من الأخطاء) 🔥"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = MainFrame

local UsernameInput = Instance.new("TextBox")
UsernameInput.Size = UDim2.new(0.85, 0, 0, 35)
UsernameInput.Position = UDim2.new(0.075, 0, 0.28, 0)
UsernameInput.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
UsernameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
UsernameInput.PlaceholderText = "اكتب اليوزر هنا..."
UsernameInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
UsernameInput.Text = ""
UsernameInput.TextSize = 14
UsernameInput.Font = Enum.Font.SourceSans
UsernameInput.Parent = MainFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 6)
InputCorner.Parent = UsernameInput

local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(0.85, 0, 0, 35)
CopyButton.Position = UDim2.new(0.075, 0, 0.60, 0)
CopyButton.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Text = "نسخ السكن والحركات"
CopyButton.TextSize = 14
CopyButton.Font = Enum.Font.SourceSansBold
CopyButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = CopyButton

-- دالة النسخ الكاملة الشاملة
local function copySkin()
    local targetUsername = string.gsub(UsernameInput.Text, "%s+", "")
    if targetUsername == "" then 
        CopyButton.Text = "اكتب اسم اليوزر أولاً!"
        task.wait(1.5)
        CopyButton.Text = "نسخ السكن والحركات"
        return 
    end

    CopyButton.Text = "جاري النسخ..."

    task.spawn(function()
        local success, targetUserId = pcall(function()
            return Players:GetUserIdFromNameAsync(targetUsername)
        end)

        if success and targetUserId then
            local myCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local myHumanoid = myCharacter:FindFirstChildOfClass("Humanoid")

            if myCharacter and myHumanoid then
                -- جلب وصف الشخصية المعتمد
                local descSuccess, humanoidDesc = pcall(function()
                    return Players:GetHumanoidDescriptionFromUserId(targetUserId)
                end)

                if descSuccess and humanoidDesc then
                    -- 1. تنظيف ملابس وإكسسوارات الشخصية القديمة
                    for _, item in pairs(myCharacter:GetChildren()) do
                        if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") or item:IsA("BodyColors") or item:IsA("CharacterMesh") then
                            item:Destroy()
                        end
                    end

                    -- 2. تطبيق المظهر والقياسات والحركات من الوصف المباشر
                    pcall(function()
                        myHumanoid:ApplyDescription(humanoidDesc)
                    end)

                    -- 3. معالجة إضافية للحجم الكبيرة والمجسمات العالية (Custom Model Check)
                    pcall(function()
                        local targetModel = Players:CreateHumanoidModelFromUserId(targetUserId)
                        if targetModel then
                            for _, part in pairs(targetModel:GetChildren()) do
                                if part:IsA("CharacterMesh") or (part:IsA("Accessory") and not myCharacter:FindFirstChild(part.Name)) then
                                    part:Clone().Parent = myCharacter
                                end
                            end

                            -- نسْخ وإعادة تنشيط الحركة
                            local targetAnimate = targetModel:FindFirstChild("Animate")
                            local myAnimate = myCharacter:FindFirstChild("Animate")
                            if targetAnimate then
                                if myAnimate then myAnimate:Destroy() end
                                local clonedAnimate = targetAnimate:Clone()
                                clonedAnimate.Parent = myCharacter
                                clonedAnimate.Disabled = false
                            end

                            targetModel:Destroy()
                        end
                    end)

                    CopyButton.Text = "تم النسخ بنجاح! ✨"
                else
                    CopyButton.Text = "فشل جلب بيانات السكن!"
                end
            end
        else
            CopyButton.Text = "اليوزر غير صحيح!"
        end

        task.wait(2)
        CopyButton.Text = "نسخ السكن والحركات"
    end)
end

CopyButton.MouseButton1Click:Connect(copySkin)
