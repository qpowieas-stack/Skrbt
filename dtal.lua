-- Roblox Custom Environment Script for Delta + Montagem Music Button
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. جعل السماء سوداء وتغيير إضاءة اللعبة
pcall(function()
    Lighting.Sky:Destroy()
end)
local Sky = Instance.new("Sky")
Sky.SkyboxBk = "rbxassetid://0"
Sky.SkyboxDn = "rbxassetid://0"
Sky.SkyboxFt = "rbxassetid://0"
Sky.SkyboxLf = "rbxassetid://0"
Sky.SkyboxRt = "rbxassetid://0"
Sky.SkyboxUp = "rbxassetid://0"
Sky.Parent = Lighting

Lighting.ClockTime = 0
Lighting.Ambient = Color3.fromRGB(0, 0, 0)
Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)

-- 2. تحويل ألوان الأرض والمباني والأشياء إلى أحمر وأصفر
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") and not obj:IsDescendantOf(LocalPlayer.Character) then
        if math.random(1, 2) == 1 then
            obj.Color = Color3.fromRGB(255, 0, 0) -- أحمر
        else
            obj.Color = Color3.fromRGB(255, 200, 0) -- أصفر
        end
        obj.Material = Enum.Material.SmoothPlastic
    end
end

-- 3. إضافة نار خلف شخصية اللاعب
local function applyFireTrail(character)
    if not character then return end
    local hrp = character:WaitForChild("HumanoidRootPart", 5)
    if hrp then
        if hrp:FindFirstChild("BackFire") then
            hrp.BackFire:Destroy()
        end
        
        local fire = Instance.new("Fire")
        fire.Name = "BackFire"
        fire.Size = 10
        fire.Heat = 15
        fire.Color = Color3.fromRGB(255, 60, 0)
        fire.SecondaryColor = Color3.fromRGB(255, 255, 0)
        fire.Parent = hrp
    end
end

if LocalPlayer.Character then
    applyFireTrail(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    applyFireTrail(char)
end)

-- 4. إعداد الأغنية
local Sound = Instance.new("Sound")
Sound.Name = "MontagemMusic"
Sound.SoundId = "rbxassetid://1848354536"
Sound.Volume = 3
Sound.Looped = true
Sound.Parent = workspace

-- 5. إنشاء زر تشغيل/إيقاف الأغنية (Screen GUI)
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- إزالة أي زر قديم إن وجد
if PlayerGui:FindFirstChild("MusicGUI") then
    PlayerGui.MusicGUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MusicGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 160, 0, 50)
toggleButton.Position = UDim2.new(0.05, 0, 0.4, 0) -- موقع الزر على اليسار
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 18
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Text = "🎵 تشغيل MONTAGEM"
toggleButton.Parent = screenGui

-- إضافة حواف دائرية للزر
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = toggleButton

-- برمجة ضغطة الزر
local isPlaying = false
toggleButton.MouseButton1Click:Connect(function()
    if not isPlaying then
        Sound:Play()
        isPlaying = true
        toggleButton.Text = "⏸️ إيقاف الأغنية"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0) -- يتغير للون الأخضر عند التشغيل
    else
        Sound:Stop()
        isPlaying = false
        toggleButton.Text = "🎵 تشغيل MONTAGEM"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- يعود للون الأحمر عند الإيقاف
    end
end)
