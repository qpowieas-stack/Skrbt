-- MM2 Ultimate GUI (Unified Target Kill System)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- تنظيف الواجهة القديمة
if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("MM2GodGui") then
    LocalPlayer.PlayerGui.MM2GodGui:Destroy()
end

local ESPEnabled = false
local HitboxEnabled = false
local FlyEnabled = false
local SpeedEnabled = false
local JumpEnabled = false
local NoclipEnabled = false
local GodmodeEnabled = false
local HitboxSize = 15

local flySpeed = 45
local bv, bg

-- إنشاء الواجهة الرئيسية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2GodGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 250, 0, 460)
MainFrame.Position = UDim2.new(0.5, -125, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

-- عنوان القائمة
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -45, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "MM2 السكربت النهائي المطور 🔪⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 12
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- زر الإخفاء والإظهار في الزاوية
local CornerToggleBtn = Instance.new("TextButton")
CornerToggleBtn.Size = UDim2.new(0, 35, 0, 35)
CornerToggleBtn.Position = UDim2.new(1, -40, 0, 3)
CornerToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
CornerToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CornerToggleBtn.Text = "👁️"
CornerToggleBtn.TextSize = 16
CornerToggleBtn.Parent = MainFrame

local CornerToggleCorner = Instance.new("UICorner")
CornerToggleCorner.CornerRadius = UDim.new(0, 6)
CornerToggleCorner.Parent = CornerToggleBtn

CornerToggleBtn.MouseButton1Click:Connect(function()
    for _, child in pairs(MainFrame:GetChildren()) do
        if child ~= Title and child ~= CornerToggleBtn and child ~= Corner then
            child.Visible = not child.Visible
        end
    end
    if MainFrame.Size.Y.Offset == 460 then
        MainFrame.Size = UDim2.new(0, 250, 0, 45)
    else
        MainFrame.Size = UDim2.new(0, 250, 0, 460)
    end
end)

local function createBtn(text, pos, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 32)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.TextSize = 12
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = MainFrame
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    return btn
end

-- الأزرار
local ESPBtn       = createBtn("كشف الأدوار (ESP): معطل ❌", UDim2.new(0.075, 0, 0.10, 0), Color3.fromRGB(180, 50, 50))
local HitboxBtn    = createBtn("تكبير الهيت بوكس: معطل ❌", UDim2.new(0.075, 0, 0.19, 0), Color3.fromRGB(180, 50, 50))
local GodmodeBtn   = createBtn("عدم الموت (Godmode): معطل ❌", UDim2.new(0.075, 0, 0.28, 0), Color3.fromRGB(180, 50, 50))
local FlyBtn       = createBtn("طيران الجوال (Fly): معطل ❌", UDim2.new(0.075, 0, 0.37, 0), Color3.fromRGB(180, 50, 50))
local KillMurderer = createBtn("قتل القاتل 🎯 (Kill Murderer)", UDim2.new(0.075, 0, 0.46, 0), Color3.fromRGB(200, 30, 30))
local KillSheriff  = createBtn("قتل الشريف 🎯 (Kill Sheriff)", UDim2.new(0.075, 0, 0.55, 0), Color3.fromRGB(30, 100, 200))
local SpeedBtn     = createBtn("سرعة خارقة (Speed): معطل ❌", UDim2.new(0.075, 0, 0.64, 0), Color3.fromRGB(70, 70, 80))
local JumpBtn      = createBtn("قفز عالي (Jump): معطل ❌", UDim2.new(0.075, 0, 0.73, 0), Color3.fromRGB(70, 70, 80))
local NoclipBtn    = createBtn("اختراق الجدران (Noclip): معطل ❌", UDim2.new(0.075, 0, 0.82, 0), Color3.fromRGB(70, 70, 80))

local function getPlayerByRole(targetRole)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local backpack = p:FindFirstChild("Backpack")
            local hasKnife = char:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife"))
            local hasGun = char:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun"))
            
            if targetRole == "Murderer" and hasKnife then return p
            elseif targetRole == "Sheriff" and hasGun then return p end
        end
    end
    return nil
end

-- ESP
ESPBtn.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    ESPBtn.Text = ESPEnabled and "كشف الأدوار (ESP): مفعل ✅" or "كشف الأدوار (ESP): معطل ❌"
    ESPBtn.BackgroundColor3 = ESPEnabled and Color3.fromRGB(40, 180, 80) or Color3.fromRGB(180, 50, 50)
end)

-- Hitbox
HitboxBtn.MouseButton1Click:Connect(function()
    HitboxEnabled = not HitboxEnabled
    HitboxBtn.Text = HitboxEnabled and "تكبير الهيت بوكس: مفعل ✅" or "تكبير الهيت بوكس: معطل ❌"
    HitboxBtn.BackgroundColor3 = HitboxEnabled and Color3.fromRGB(40, 180, 80) or Color3.fromRGB(180, 50, 50)
    if not HitboxEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                p.Character.HumanoidRootPart.Transparency = 1
            end
        end
    end
end)

-- Godmode
GodmodeBtn.MouseButton1Click:Connect(function()
    GodmodeEnabled = not GodmodeEnabled
    GodmodeBtn.Text = GodmodeEnabled and "عدم الموت (Godmode): مفعل ✅" or "عدم الموت (Godmode): معطل ❌"
    GodmodeBtn.BackgroundColor3 = GodmodeEnabled and Color3.fromRGB(40, 180, 80) or Color3.fromRGB(180, 50, 50)
end)

RunService.Stepped:Connect(function()
    if GodmodeEnabled then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.Health = hum.MaxHealth
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                end
            end
        end)
    end
end)

-- Fly
FlyBtn.MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    FlyBtn.Text = FlyEnabled and "طيران الجوال (Fly): مفعل ✅" or "طيران الجوال (Fly): معطل ❌"
    FlyBtn.BackgroundColor3 = FlyEnabled and Color3.fromRGB(40, 180, 80) or Color3.fromRGB(180, 50, 50)
    
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        if FlyEnabled then
            bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.Parent = hrp

            bg = Instance.new("BodyGyro")
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bg.CFrame = hrp.CFrame
            bg.Parent = hrp
        else
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end
    end
end)

-- دالة القتل بالضرب السريع وطرد الهدف لضمان الموت
local function eliminateTarget(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local char = LocalPlayer.Character
    local targetChar = targetPlayer.Character
    if char and targetChar and char:FindFirstChild("HumanoidRootPart") and targetChar:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local tHrp = targetChar.HumanoidRootPart
        local oldCFrame = hrp.CFrame
        
        -- التجهيز بالسلاح إن وجد
        local tool = char:FindFirstChildOfClass("Tool") or LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
        if tool then tool.Parent = char end

        -- الهجوم المباشر وسحب الهدف لمنطقة الموت (Void)
        pcall(function()
            hrp.CFrame = tHrp.CFrame * CFrame.new(0, 0, 1)
            if tool then tool:Activate() end
            task.wait(0.05)
            
            -- طرده لخارج الماب ليتم التأكد من موته
            local voidPos = CFrame.new(0, -900, 0)
            tHrp.CFrame = voidPos
            hrp.CFrame = voidPos
            task.wait(0.1)
            
            -- العودة الفورية لموقعك الأصلي
            hrp.CFrame = oldCFrame
        end)
    end
end

KillMurderer.MouseButton1Click:Connect(function()
    pcall(function() eliminateTarget(getPlayerByRole("Murderer")) end)
end)

KillSheriff.MouseButton1Click:Connect(function()
    pcall(function() eliminateTarget(getPlayerByRole("Sheriff")) end)
end)

-- Speed, Jump & Noclip
SpeedBtn.MouseButton1Click:Connect(function()
    SpeedEnabled = not SpeedEnabled
    SpeedBtn.Text = SpeedEnabled and "سرعة خارقة (Speed): مفعل ✅" or "سرعة خارقة (Speed): معطل ❌"
    SpeedBtn.BackgroundColor3 = SpeedEnabled and Color3.fromRGB(40, 180, 80) or Color3.fromRGB(70, 70, 80)
end)

JumpBtn.MouseButton1Click:Connect(function()
    JumpEnabled = not JumpEnabled
    JumpBtn.Text = JumpEnabled and "قفز عالي (Jump): مفعل ✅" or "قفز عالي (Jump): معطل ❌"
    JumpBtn.BackgroundColor3 = JumpEnabled and Color3.fromRGB(40, 180, 80) or Color3.fromRGB(70, 70, 80)
end)

NoclipBtn.MouseButton1Click:Connect(function()
    NoclipEnabled = not NoclipEnabled
    NoclipBtn.Text = NoclipEnabled and "اختراق الجدران (Noclip): معطل ❌" or "اختراق الجدران (Noclip): مفعل ✅"
    NoclipBtn.BackgroundColor3 = NoclipEnabled and Color3.fromRGB(40, 180, 80) or Color3.fromRGB(70, 70, 80)
end)

-- التحديث المستمر
RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local backpack = p:FindFirstChild("Backpack")
                local char = p.Character
                local roleColor = Color3.fromRGB(0, 255, 0)
                local hasKnife = char:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife"))
                local hasGun = char:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun"))
                
                if hasKnife then roleColor = Color3.fromRGB(255, 0, 0)
                elseif hasGun then roleColor = Color3.fromRGB(0, 150, 255) end

                local hl = char:FindFirstChild("MM2_HL")
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "MM2_HL"
                    hl.Adornee = char
                    hl.Parent = char
                end
                hl.FillColor = roleColor
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("MM2_HL") then p.Character.MM2_HL:Destroy() end
        end
    end

    if HitboxEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                hrp.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                hrp.Transparency = 0.7
                hrp.BrickColor = BrickColor.new("Really red")
                hrp.CanCollide = false
            end
        end
    end

    if FlyEnabled and bv and bg then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if char and char:FindFirstChild("HumanoidRootPart") and hum then
            local camera = workspace.CurrentCamera
            local moveDir = hum.MoveDirection
            
            if moveDir.Magnitude > 0 then
                bv.Velocity = moveDir * flySpeed + Vector3.new(0, camera.CoordinateFrame.LookVector.Y * flySpeed * 0.5, 0)
            else
                bv.Velocity = Vector3.new(0, 0, 0)
            end
            bg.CFrame = camera.CoordinateFrame
        end
    end

    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        if SpeedEnabled then char.Humanoid.WalkSpeed = 35 end
        if JumpEnabled then char.Humanoid.JumpPower = 120 end
    end

    if NoclipEnabled and char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)
