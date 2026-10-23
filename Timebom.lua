-- Time Bomb - Delta Script (With Hitbox Size Control)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Time Bomb - Delta Hub 💣", "BloodTheme")

-- متغيرات التحكم بحجم الهيت بوكس
_G.HitboxSize = 15
_G.HitboxEnabled = false

-- ============================================
-- Tab 1: القتال والهيت بوكس (Combat)
-- ============================================
local CombatTab = Window:NewTab("القتال")
local CombatSection = CombatTab:NewSection("خيارات الهيت بوكس وتمرير القنبلة")

-- تفعيل / إيقاف الهيت بوكس
CombatSection:NewToggle("تفعيل الهيت بوكس (Hitbox)", "تشغيل أو إيقاف تكبير الأعداء", function(state)
    _G.HitboxEnabled = state
    while _G.HitboxEnabled do
        task.wait(0.2)
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
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

-- التحكم بحجم الهيت بوكس (Slider)
CombatSection:NewSlider("حجم الهيت بوكس (Size)", "تحديد حجم تكبير الهيت بوكس", 50, 2, function(value)
    _G.HitboxSize = value
end)

-- الانتقال لأقرب لاعب (Teleport)
CombatSection:NewButton("انتقال لأقرب لاعب (Teleport)", "ينقلك فوراً لأقرب لاعب لتمرير القنبلة", function()
    local p1 = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if p1 then
        local nearest, closestDist = nil, math.huge
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
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

-- ============================================
-- Tab 2: الحركة والهروب (Movement)
-- ============================================
local MoveTab = Window:NewTab("الحركة")
local MoveSection = MoveTab:NewSection("السرعة والقفز للهروب")

-- تعديل السرعة (Speed Slider)
MoveSection:NewSlider("سرعة المشي (Speed)", "تغيير سرعة شخصيتك", 120, 16, function(value)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
end)

-- تعديل قوة القفز (Jump Slider)
MoveSection:NewSlider("قوة القفز (Jump)", "تغيير ارتفاع القفزة", 200, 50, function(value)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end
end)

-- القفز المستمر (Inf Jump)
MoveSection:NewToggle("قفز لا نهائي (Inf Jump)", "القفز في الهواء للابتعاد عن القنبلة", function(state)
    _G.InfJump = state
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if _G.InfJump and game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
        end
    end)
end)

-- ============================================
-- Tab 3: الإعدادات وإخفاء القائمة (Settings)
-- ============================================
local SettingsTab = Window:NewTab("الإعدادات")
local SettingsSection = SettingsTab:NewSection("التحكم بالشاشة والقائمة")

-- زر اختيار مفتاح إخفاء/إظهار القائمة
SettingsSection:NewKeybind("زر إخفاء/إظهار القائمة", "اضغط الزر المحدد لإخفاء أو إظهار القائمة", Enum.KeyCode.RightControl, function()
    Library:ToggleUI()
end)

-- زر مباشر لإخفاء القائمة
SettingsSection:NewButton("إخفاء القائمة الآن (Hide UI)", "يخفي القائمة فوراً", function()
    Library:ToggleUI()
end)
