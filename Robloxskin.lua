-- Roblox Delta Skin Copier (Local / Client-Side)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- إزالة الواجهة القديمة إن وجدت لمنع التكرار والأخطاء
if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("SkinCopierGui") then
    LocalPlayer.PlayerGui.SkinCopierGui:Destroy()
end

-- إنشاء الواجهة (ScreenGui)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SkinCopierGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- إطار القائمة الصغيرة (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 260, 0, 160)
MainFrame.Position = UDim2.new(0.5, -130, 0.4, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- العنوان
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 35)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "ناسخ السكنات (لك فقط)"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = MainFrame

-- حقل إدخال اسم اليوزر
local UsernameInput = Instance.new("TextBox")
UsernameInput.Size = UDim2.new(0.85, 0, 0, 35)
UsernameInput.Position = UDim2.new(0.075, 0, 0.28, 0)
UsernameInput.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
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

-- زر النسخ
local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(0.85, 0, 0, 35)
CopyButton.Position = UDim2.new(0.075, 0, 0.60, 0)
CopyButton.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Text = "نسخ السكن"
CopyButton.TextSize = 15
CopyButton.Font = Enum.Font.SourceSansBold
CopyButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = CopyButton

-- دالة نسخ السكن بدون أخطاء
local function copySkin()
    local targetUsername = UsernameInput.Text
    if targetUsername == "" or targetUsername == " " then 
        CopyButton.Text = "الرجاء كتابة اسم اليوزر!"
        task.wait(1.5)
        CopyButton.Text = "نسخ السكن"
        return 
    end

    CopyButton.Text = "جاري التحميل..."

    local success, targetUserId = pcall(function()
        return Players:GetUserIdFromNameAsync(targetUsername)
    end)

    if success and targetUserId then
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        
        if humanoid then
            local descSuccess, humanoidDescription = pcall(function()
                return Players:GetHumanoidDescriptionFromUserId(targetUserId)
            end)

            if descSuccess and humanoidDescription then
                pcall(function()
                    humanoid:ApplyDescription(humanoidDescription)
                end)
                CopyButton.Text = "تم النسخ بنجاح!"
            else
                CopyButton.Text = "فشل جلب سكن اليوزر!"
            end
        end
    else
        CopyButton.Text = "اليوزر غير موجود!"
    end

    task.wait(1.5)
    CopyButton.Text = "نسخ السكن"
end

CopyButton.MouseButton1Click:Connect(copySkin)
