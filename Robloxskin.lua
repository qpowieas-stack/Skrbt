-- Roblox Ultimate Skin & Size Copier (Works even if Offline / Left Game)
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
TitleLabel.Text = "ناسخ السكنات (شغال أوفلاين/خارج اللعبة) 🔥"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 12
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
CopyButton.Text = "نسخ السكن بالحجم الكامل"
CopyButton.TextSize = 14
CopyButton.Font = Enum.Font.SourceSansBold
CopyButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = CopyButton

-- دالة التطبيق القسري للمقاسات والأحجام (Forced Scale)
local function applyScales(humanoid, description)
    local scales = {
        HeightScale = description.HeightScale,
        WidthScale = description.WidthScale,
        DepthScale = description.DepthScale,
        HeadScale = description.HeadScale,
        BodyTypeScale = description.BodyTypeScale,
        ProportionScale = description.ProportionScale
    }

    for scaleName, scaleValue in pairs(scales) do
        local valObj = humanoid:FindFirstChild(scaleName)
        if valObj and valObj:IsA("NumberValue") then
            valObj.Value = scaleValue
        else
            local newScale = Instance.new("NumberValue")
            newScale.Name = scaleName
            newScale.Value = scaleValue
            newScale.Parent = humanoid
        end
    end
end

-- دالة النسخ الرئيسية
local function copySkin()
    local targetUsername = string.gsub(UsernameInput.Text, "%s+", "")
    if targetUsername == "" then 
        CopyButton.Text = "اكتب اسم اليوزر أولاً!"
        task.wait(1.5)
        CopyButton.Text = "نسخ السكن بالحجم الكامل"
        return 
    end

    CopyButton.Text = "جاري التحميل..."

    task.spawn(function()
        local myCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local myHumanoid = myCharacter:FindFirstChildOfClass("Humanoid")

        if not (myCharacter and myHumanoid) then return end

        local success, targetUserId = pcall(function()
            return Players:GetUserIdFromNameAsync(targetUsername)
        end)

        if success and targetUserId then
            local descSuccess, humanoidDesc = pcall(function()
                return Players:GetHumanoidDescriptionFromUserId(targetUserId)
            end)

            if descSuccess and humanoidDesc then
                -- 1. مسح الملابس والإكسسوارات الحالية
                for _, item in pairs(myCharacter:GetChildren()) do
                    if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") or item:IsA("BodyColors") or item:IsA("CharacterMesh") then
                        item:Destroy()
                    end
                end

                -- 2. تطبيق السكن والمظهر
                pcall(function()
                    myHumanoid:ApplyDescription(humanoidDesc)
                end)

                -- 3. إجبار تطبيق الحجم والمقاسات العميقة (تضخيم/تكبير السكن)
                applyScales(myHumanoid, humanoidDesc)

                -- 4. جلب الموديل المؤقت لنقل أجزاء الجسم العملاقة وإصلاح الوجه
                local modelSuccess, targetModel = pcall(function()
                    return Players:CreateHumanoidModelFromUserId(targetUserId)
                end)

                if modelSuccess and targetModel then
                    for _, item in pairs(targetModel:GetChildren()) do
                        if item:IsA("CharacterMesh") then
                            item:Clone().Parent = myCharacter
                        elseif item:IsA("Accessory") and not myCharacter:FindFirstChild(item.Name) then
                            pcall(function()
                                myHumanoid:AddAccessory(item:Clone())
                            end)
                        end
                    end

                    -- إصلاح الوجه دون اختفاء
                    local myHead = myCharacter:FindFirstChild("Head")
                    local targetHead = targetModel:FindFirstChild("Head")
                    if myHead and targetHead then
                        local targetFace = targetHead:FindFirstChildOfClass("Decal")
                        if targetFace then
                            local myFace = myHead:FindFirstChildOfClass("Decal")
                            if myFace then myFace:Destroy() end
                            targetFace:Clone().Parent = myHead
                        end
                    end

                    targetModel:Destroy()
                end

                CopyButton.Text = "تم نسخ السكن والحجم! 🔥"
            else
                CopyButton.Text = "فشل جلب بيانات الحجم!"
            end
        else
            CopyButton.Text = "اليوزر غير صحيح!"
        end

        task.wait(2)
        CopyButton.Text = "نسخ السكن بالحجم الكامل"
    end)
end

CopyButton.MouseButton1Click:Connect(copySkin)
