-- Roblox Advanced Skin Copier
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- إزالة الواجهة القديمة إن وجدت
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
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
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
TitleLabel.Text = "ناسخ السكنات (المطور)"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = MainFrame

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

-- دالة النسخ القوية (تشتغل على R6 و R15)
local function copySkin()
    local targetUsername = UsernameInput.Text
    if targetUsername == "" or targetUsername == " " then 
        CopyButton.Text = "اكتب اسم اليوزر أولاً!"
        task.wait(1.5)
        CopyButton.Text = "نسخ السكن"
        return 
    end

    CopyButton.Text = "جاري النسخ..."

    local success, targetUserId = pcall(function()
        return Players:GetUserIdFromNameAsync(targetUsername)
    end)

    if success and targetUserId then
        local myCharacter = LocalPlayer.Character
        if myCharacter then
            -- جلب موديل الشخصية المطلوبة
            local modelSuccess, model = pcall(function()
                return Players:CreateHumanoidModelFromUserId(targetUserId)
            end)

            if modelSuccess and model then
                -- مسح الملابس والإكسسوارات القديمة لشخصيتك
                for _, item in pairs(myCharacter:GetChildren()) do
                    if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") or item:IsA("BodyColors") then
                        item:Destroy()
                    end
                end

                -- نقل الملابس والإكسسوارات من الشخصية المطلوبة إليك
                for _, item in pairs(model:GetChildren()) do
                    if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") or item:IsA("BodyColors") then
                        item:Clone().Parent = myCharacter
                    end
                end

                -- نسخ شكل وجه الشخصية (Face)
                local myHead = myCharacter:FindFirstChild("Head")
                local targetHead = model:FindFirstChild("Head")
                if myHead and targetHead then
                    local targetFace = targetHead:FindFirstChildOfClass("Decal")
                    if targetFace then
                        local myFace = myHead:FindFirstChildOfClass("Decal")
                        if myFace then myFace:Destroy() end
                        targetFace:Clone().Parent = myHead
                    end
                end

                model:Destroy()
                CopyButton.Text = "تم نسخ السكن بنجاح!"
            else
                CopyButton.Text = "فشل جلب بيانات اليوزر!"
            end
        end
    else
        CopyButton.Text = "اليوزر غير صحيح!"
    end

    task.wait(1.5)
    CopyButton.Text = "نسخ السكن"
end

CopyButton.MouseButton1Click:Connect(copySkin)
