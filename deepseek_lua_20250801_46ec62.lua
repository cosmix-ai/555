-- ประกาศตัวแปร player ให้ถูกต้อง (จำเป็นใน LocalScript ของ Roblox)
local player = game:GetService("Players").LocalPlayer

-- ประกาศฟังก์ชัน createStyledButton ถ้ายังไม่มี
local function createStyledButton(parent, text, size, position)
    local button = Instance.new("TextButton")
    button.Text = text
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.Gotham
    button.TextScaled = true
    button.Parent = parent
    return button
end

-- ประกาศ teleportPoints และตัวแปรอื่นๆ
local teleportPoints = {
    Vector3.new(-22.2, 54.0, 39.5), -- จุดที่ 1
    Vector3.new(-17.8, 54.0, 27.6), -- จุดที่ 2
    Vector3.new(-18.4, 54.0, 18.3)  -- จุดที่ 3
}

local isTeleporting = false
local currentTeleportIndex = 1

-- ฟังก์ชัน Teleport
local function teleportToNextPoint()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local targetPos = teleportPoints[currentTeleportIndex]
    player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos)
    
    currentTeleportIndex = currentTeleportIndex + 1
    if currentTeleportIndex > #teleportPoints then
        currentTeleportIndex = 1
    end
end

-- ฟังก์ชันเพิ่มปุ่ม Teleport
local function addTeleportFeature(buttons, content)
    -- สร้างปุ่มในเมนูหลัก
    buttons.coordTeleport = createStyledButton(featureScroll, "Teleport (ปิด)", UDim2.new(1, 0, 0, 50), UDim2.new(0, 0, 0, 0))
    buttons.coordTeleport.Name = "coordTeleport"
    buttons.coordTeleport.LayoutOrder = 7
    
    buttons.coordTeleport.MouseButton1Click:Connect(function()
        isTeleporting = not isTeleporting
        buttons.coordTeleport.Text = isTeleporting and "Teleport (เปิด)" or "Teleport (ปิด)"
        buttons.coordTeleport.BackgroundColor3 = isTeleporting and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(80, 80, 80)
        
        if isTeleporting then
            task.spawn(function()
                while isTeleporting do
                    teleportToNextPoint()
                    task.wait(0.1) -- ความเร็ว 0.1 วินาที
                end
            end)
        end
    end)
    
    -- สร้างหน้าแสดงข้อมูลใน Content
    buttons.coordTeleport.MouseButton1Click:Connect(function()
        clearContent()
        
        local lblInfo = Instance.new("TextLabel", content)
        lblInfo.Text = "ระบบ Teleport อัตโนมัติ\nจะเคลื่อนที่ระหว่างจุดที่กำหนด\nทุก 0.1 วินาที"
        lblInfo.Size = UDim2.new(1, -20, 0, 100)
        lblInfo.Position = UDim2.new(0, 10, 0, 10)
        lblInfo.TextColor3 = Color3.new(1, 1, 1)
        lblInfo.BackgroundTransparency = 1
        lblInfo.TextWrapped = true
        lblInfo.Font = Enum.Font.Gotham
        lblInfo.TextScaled = true
        
        local lblPoints = Instance.new("TextLabel", content)
        lblPoints.Text = "จุด Teleport:\n1. (-22.2, 54.0, 39.5)\n2. (-17.8, 54.0, 27.6)\n3. (-18.4, 54.0, 18.3)"
        lblPoints.Size = UDim2.new(1, -20, 0, 150)
        lblPoints.Position = UDim2.new(0, 10, 0, 120)
        lblPoints.TextColor3 = Color3.new(1, 1, 1)
        lblPoints.BackgroundTransparency = 1
        lblPoints.TextWrapped = true
        lblPoints.Font = Enum.Font.Gotham
        lblPoints.TextScaled = true
        
        local toggleBtn = createStyledButton(content, isTeleporting and "ปิด Teleport" or "เปิด Teleport", 
            UDim2.new(1, -20, 0, 50), UDim2.new(0, 10, 0, 280))
        
        toggleBtn.MouseButton1Click:Connect(function()
            isTeleporting = not isTeleporting
            buttons.coordTeleport.Text = isTeleporting and "Teleport (เปิด)" or "Teleport (ปิด)"
            buttons.coordTeleport.BackgroundColor3 = isTeleporting and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(80, 80, 80)
            toggleBtn.Text = isTeleporting and "ปิด Teleport" or "เปิด Teleport"
            
            if isTeleporting then
                task.spawn(function()
                    while isTeleporting do
                        teleportToNextPoint()
                        task.wait(0.1)
                    end
                end)
            end
        end)
    end)
end

-- เรียกใช้ฟังก์ชันหลังจากประกาศทั้งหมดแล้ว
addTeleportFeature(buttons, content)