-- Roblox Custom Environment Script for Delta
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. جعل السماء سوداء وتغيير إضاءة اللعبة
Lighting.Sky:Destroy() -- إزالة السماء الافتراضية إن وجدت
local Sky = Instance.new("Sky")
Sky.SkyboxBk = "rbxassetid://0"
Sky.SkyboxDn = "rbxassetid://0"
Sky.SkyboxFt = "rbxassetid://0"
Sky.SkyboxLf = "rbxassetid://0"
Sky.SkyboxRt = "rbxassetid://0"
Sky.SkyboxUp = "rbxassetid://0"
Sky.Parent = Lighting

Lighting.ClockTime = 0 -- جعل الوقت ليلاً
Lighting.Ambient = Color3.fromRGB(0, 0, 0) -- إزالة الضوء المحيطي
Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)

-- 2. تحويل ألوان الأرض والمباني والأشياء إلى أحمر وأصفر
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") and not obj:IsDescendantOf(LocalPlayer.Character) then
        -- صبغ المجسمات بشكل عشوائي بين الأحمر والأصفر
        if math.random(1, 2) == 1 then
            obj.Color = Color3.fromRGB(255, 0, 0) -- لون أحمر
        else
            obj.Color = Color3.fromRGB(255, 200, 0) -- لون أصفر
        end
        obj.Material = Enum.Material.SmoothPlastic
    end
end

-- 3. إضافة نار خلف شخصية اللاعب
local function applyFireTrail(character)
    if not character then return end
    local hrp = character:WaitForChild("HumanoidRootPart", 5)
    if hrp then
        -- إزالة أي نار قديمة إذا كانت موجودة
        if hrp:FindFirstChild("BackFire") then
            hrp.BackFire:Destroy()
        end
        
        local fire = Instance.new("Fire")
        fire.Name = "BackFire"
        fire.Size = 10 -- حجم النار
        fire.Heat = 15 -- ارتفاع النار
        fire.Color = Color3.fromRGB(255, 60, 0) -- لون النار الخارجي
        fire.SecondaryColor = Color3.fromRGB(255, 255, 0) -- لون النار الداخلي (أصفر)
        fire.Parent = hrp
    end
end

-- تطبيق النار عند تشغيل السكربت وعند إعادة الترسيب (Respawn)
if LocalPlayer.Character then
    applyFireTrail(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    applyFireTrail(char)
end)
