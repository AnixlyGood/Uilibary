repeat task.wait() until game:IsLoaded()

local AnixlyUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/AnixlyGood/Uilibary/refs/heads/main/AnixlyUi.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local IMAGE_ID = "rbxassetid://2061475061"

local function Notify(title, message, theme, duration)
    AnixlyUI:ShowNotification({
        Title = title,
        Message = message,
        Theme = theme or "info",
        Duration = duration or 2
    })
end

local function GetExecutor()
    local success, result = pcall(function()
        return getexecutorname()
    end)

    if success and result then
        if tostring(result):find("Delta") or tostring(result):find("DELTA") then
            return "Delta"
        end
        return tostring(result)
    end

    local okDelta = pcall(function()
        return game:GetService("CoreGui"):FindFirstChild("Delta")
    end)

    if okDelta then
        local core = game:GetService("CoreGui")
        if core:FindFirstChild("Delta") or core:FindFirstChild("Delta Hub") then
            return "Delta"
        end
        if core:FindFirstChild("Fluxus") then
            return "Fluxus"
        end
        if core:FindFirstChild("Electron") then
            return "Electron"
        end
    end

    if syn then
        return "Synapse X"
    end

    if getsenv and setreadonly then
        return "ScriptWare"
    end

    if isfile and isfolder and not syn then
        return "Krnl"
    end

    return "Unknown Executor"
end

local executorName = GetExecutor()

local Window = AnixlyUI:CreateWindow({
    Title = "Anixly Hub",
    Subtitle = "Version 1.0.0 | " .. executorName,
    Theme = "ANIXLY",

    MiniIcon = IMAGE_ID,
    Logo = IMAGE_ID,

    Size = {
        Width = 540,
        Height = 405
    }
})

local DashboardTab = Window:CreateTab("Dashboard")
local MainTab = Window:CreateTab("Main")
local ESPTab = Window:CreateTab("ESP")
local UtilityTab = Window:CreateTab("Utility")

--// DASHBOARD

local DashboardSection = DashboardTab:AddSection("Information")

DashboardSection:AddLabel("═══════════════════════════════")
DashboardSection:AddLabel("       WELCOME TO ANIXLY HUB")
DashboardSection:AddLabel("═══════════════════════════════")

DashboardSection:AddLabel("📊 INFORMATION:")
DashboardSection:AddLabel("👤 Username: " .. LocalPlayer.Name)
DashboardSection:AddLabel("🆔 User ID: " .. LocalPlayer.UserId)
DashboardSection:AddLabel("⭐ Display Name: " .. LocalPlayer.DisplayName)
DashboardSection:AddLabel("🆔 Game ID: " .. game.PlaceId)
DashboardSection:AddLabel("🌍 Server ID: " .. string.sub(game.JobId, 1, 8) .. "...")
DashboardSection:AddLabel("👥 Players Online: " .. #Players:GetPlayers())
DashboardSection:AddLabel("⚡ Executor: " .. executorName)

DashboardSection:AddButton({
    Text = "🔄 Rejoin Server",
    Callback = function()
        Notify("REJOIN SERVER", "Rejoining server...", "warning", 2)
        task.wait(1)
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

DashboardSection:AddButton({
    Text = "🎲 Server Hop",
    Callback = function()
        Notify("SERVER HOP", "Searching for new server...", "warning", 2)

        local servers = {}

        local success, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"))
        end)

        if success and result and result.data then
            for _, server in pairs(result.data) do
                if server.id and server.id ~= game.JobId and server.playing and server.playing < server.maxPlayers then
                    table.insert(servers, server.id)
                end
            end

            if #servers > 0 then
                local randomServer = servers[math.random(1, #servers)]
                TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer, LocalPlayer)
            else
                Notify("SERVER HOP", "No other servers found.", "error", 3)
            end
        else
            Notify("SERVER HOP", "Failed to fetch servers.", "error", 3)
        end
    end
})

--// MAIN

local MainSection = MainTab:AddSection("⛩️ Main")

-- Noclip
local noclipEnabled = false
local noclipConnection = nil

local function EnableNoclip()
    if noclipConnection then return end
    noclipConnection = RunService.Stepped:Connect(function()
        if noclipEnabled and LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function DisableNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    if LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

MainSection:AddToggle({
    Text = "🚪 Noclip",
    Default = false,
    Callback = function(value)
        noclipEnabled = value
        if value then
            EnableNoclip()
            Notify("NOCLIP", "Noclip: Enabled", "success", 2)
        else
            DisableNoclip()
            Notify("NOCLIP", "Noclip: Disabled", "info", 2)
        end
    end
})

-- Infinity Jump
local infinityJumpEnabled = false
local jumpConnection = nil

local function EnableInfinityJump()
    if jumpConnection then return end
    jumpConnection = UIS.JumpRequest:Connect(function()
        if infinityJumpEnabled and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

local function DisableInfinityJump()
    if jumpConnection then
        jumpConnection:Disconnect()
        jumpConnection = nil
    end
end

MainSection:AddToggle({
    Text = "🦘 Infinity Jump",
    Default = false,
    Callback = function(value)
        infinityJumpEnabled = value
        if value then
            EnableInfinityJump()
            Notify("INFINITY JUMP", "Infinity Jump: Enabled", "success", 2)
        else
            DisableInfinityJump()
            Notify("INFINITY JUMP", "Infinity Jump: Disabled", "info", 2)
        end
    end
})

-- Speed Settings
local speedEnabled = false
local originalWalkspeed = 16
local walkspeedValue = 50

MainSection:AddToggle({
    Text = "⚡ Speed",
    Default = false,
    Callback = function(value)
        speedEnabled = value
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if value then
                originalWalkspeed = humanoid.WalkSpeed
                humanoid.WalkSpeed = walkspeedValue
                Notify("SPEED", "Speed: Enabled (" .. tostring(walkspeedValue) .. ")", "success", 2)
            else
                humanoid.WalkSpeed = originalWalkspeed
                Notify("SPEED", "Speed: Disabled", "info", 2)
            end
        end
    end
})

MainSection:AddSlider({
    Text = "🏃 WalkSpeed",
    Min = 16,
    Max = 250,
    Default = 50,
    Callback = function(value)
        walkspeedValue = value
        if speedEnabled then
            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = value
            end
        end
    end
})

--// FLY MODE (Support HP/Mobile)
local flyEnabled = false
local flying = false
local flyConnection = nil
local flyKeyConnection = nil
local flySpeed = 0
local maxFlySpeed = 50
local flyCtrl = {f = 0, b = 0, l = 0, r = 0, up = 0, down = 0}
local lastFlyCtrl = {f = 0, b = 0, l = 0, r = 0}
local bg = nil
local bv = nil
local flyButtons = {}
local flyGui = nil

-- Deteksi apakah device HP
local isMobile = game:GetService("UserInputService").TouchEnabled

local function CreateFlyButtons()
    if not isMobile then return end
    
    flyGui = Instance.new("ScreenGui")
    flyGui.Name = "FlyControls"
    flyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    flyGui.ResetOnSpawn = false
    
    local buttonSize = UDim2.new(0, 60, 0, 60)
    local buttonColor = Color3.fromRGB(77, 100, 150)
    
    -- Tombol W (Maju)
    local btnW = Instance.new("TextButton")
    btnW.Size = buttonSize
    btnW.Position = UDim2.new(0.5, -30, 0.85, -70)
    btnW.BackgroundColor3 = buttonColor
    btnW.Text = "⬆️"
    btnW.TextSize = 30
    btnW.Font = Enum.Font.GothamBold
    btnW.Parent = flyGui
    
    -- Tombol S (Mundur)
    local btnS = Instance.new("TextButton")
    btnS.Size = buttonSize
    btnS.Position = UDim2.new(0.5, -30, 0.85, 0)
    btnS.BackgroundColor3 = buttonColor
    btnS.Text = "⬇️"
    btnS.TextSize = 30
    btnS.Font = Enum.Font.GothamBold
    btnS.Parent = flyGui
    
    -- Tombol A (Kiri)
    local btnA = Instance.new("TextButton")
    btnA.Size = buttonSize
    btnA.Position = UDim2.new(0.5, -90, 0.85, -35)
    btnA.BackgroundColor3 = buttonColor
    btnA.Text = "⬅️"
    btnA.TextSize = 30
    btnA.Font = Enum.Font.GothamBold
    btnA.Parent = flyGui
    
    -- Tombol D (Kanan)
    local btnD = Instance.new("TextButton")
    btnD.Size = buttonSize
    btnD.Position = UDim2.new(0.5, 30, 0.85, -35)
    btnD.BackgroundColor3 = buttonColor
    btnD.Text = "➡️"
    btnD.TextSize = 30
    btnD.Font = Enum.Font.GothamBold
    btnD.Parent = flyGui
    
    -- Tombol Naik (Up)
    local btnUp = Instance.new("TextButton")
    btnUp.Size = UDim2.new(0, 50, 0, 50)
    btnUp.Position = UDim2.new(0.85, 0, 0.75, 0)
    btnUp.BackgroundColor3 = buttonColor
    btnUp.Text = "🔼"
    btnUp.TextSize = 25
    btnUp.Font = Enum.Font.GothamBold
    btnUp.Parent = flyGui
    
    -- Tombol Turun (Down)
    local btnDown = Instance.new("TextButton")
    btnDown.Size = UDim2.new(0, 50, 0, 50)
    btnDown.Position = UDim2.new(0.85, 0, 0.85, 0)
    btnDown.BackgroundColor3 = buttonColor
    btnDown.Text = "🔽"
    btnDown.TextSize = 25
    btnDown.Font = Enum.Font.GothamBold
    btnDown.Parent = flyGui
    
    -- Tombol E (Toggle Fly)
    local btnToggle = Instance.new("TextButton")
    btnToggle.Size = UDim2.new(0, 80, 0, 50)
    btnToggle.Position = UDim2.new(0.02, 0, 0.75, 0)
    btnToggle.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    btnToggle.Text = "FLY OFF"
    btnToggle.TextSize = 18
    btnToggle.Font = Enum.Font.GothamBold
    btnToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnToggle.Parent = flyGui
    
    -- Tombol Close
    local btnClose = Instance.new("TextButton")
    btnClose.Size = UDim2.new(0, 40, 0, 40)
    btnClose.Position = UDim2.new(0.02, 0, 0.7, 0)
    btnClose.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    btnClose.Text = "❌"
    btnClose.TextSize = 20
    btnClose.Font = Enum.Font.GothamBold
    btnClose.Parent = flyGui
    
    -- Event handlers untuk touch
    btnW.TouchBegan:Connect(function() flyCtrl.f = 1 end)
    btnW.TouchEnded:Connect(function() flyCtrl.f = 0 end)
    
    btnS.TouchBegan:Connect(function() flyCtrl.b = -1 end)
    btnS.TouchEnded:Connect(function() flyCtrl.b = 0 end)
    
    btnA.TouchBegan:Connect(function() flyCtrl.l = -1 end)
    btnA.TouchEnded:Connect(function() flyCtrl.l = 0 end)
    
    btnD.TouchBegan:Connect(function() flyCtrl.r = 1 end)
    btnD.TouchEnded:Connect(function() flyCtrl.r = 0 end)
    
    btnUp.TouchBegan:Connect(function() flyCtrl.up = 1 end)
    btnUp.TouchEnded:Connect(function() flyCtrl.up = 0 end)
    
    btnDown.TouchBegan:Connect(function() flyCtrl.down = -1 end)
    btnDown.TouchEnded:Connect(function() flyCtrl.down = 0 end)
    
    btnToggle.TouchBegan:Connect(function()
        flying = not flying
        if flying then
            btnToggle.Text = "FLY ON"
            btnToggle.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
            Notify("FLY", "Fly: Enabled", "success", 2)
            Fly()
        else
            btnToggle.Text = "FLY OFF"
            btnToggle.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
            Notify("FLY", "Fly: Disabled", "info", 2)
        end
    end)
    
    btnClose.TouchBegan:Connect(function()
        flyEnabled = false
        StopFly()
        if flyGui then flyGui:Destroy() end
        Notify("FLY", "Fly mode removed", "info", 2)
    end)
    
    flyButtons = {btnW, btnS, btnA, btnD, btnUp, btnDown, btnToggle, btnClose}
end

local function RemoveFlyButtons()
    if flyGui then
        flyGui:Destroy()
        flyGui = nil
    end
    flyButtons = {}
end

local function Fly()
    repeat task.wait() until LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid")
    
    local plr = LocalPlayer
    local rootPart = plr.Character.HumanoidRootPart
    local humanoid = plr.Character.Humanoid
    
    bg = Instance.new("BodyGyro")
    bg.P = 9e4
    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.CFrame = rootPart.CFrame
    bg.Parent = rootPart
    
    bv = Instance.new("BodyVelocity")
    bv.velocity = Vector3.new(0, 0.1, 0)
    bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Parent = rootPart
    
    while flying and flyEnabled do
        humanoid.PlatformStand = true
        
        local moveX = flyCtrl.l + flyCtrl.r
        local moveZ = flyCtrl.f + flyCtrl.b
        local moveY = flyCtrl.up + flyCtrl.down
        
        if moveX ~= 0 or moveZ ~= 0 or moveY ~= 0 then
            flySpeed = flySpeed + 0.5 + (flySpeed / maxFlySpeed)
            if flySpeed > maxFlySpeed then
                flySpeed = maxFlySpeed
            end
        elseif speed ~= 0 then
            flySpeed = flySpeed - 1
            if flySpeed < 0 then
                flySpeed = 0
            end
        end
        
        if moveX ~= 0 or moveZ ~= 0 or moveY ~= 0 then
            local cam = workspace.CurrentCamera
            local forward = cam.CFrame.LookVector
            local right = cam.CFrame.RightVector
            local up = cam.CFrame.UpVector
            
            local velocity = (forward * moveZ + right * moveX + up * moveY) * flySpeed
            bv.velocity = velocity
            lastFlyCtrl = {f = flyCtrl.f, b = flyCtrl.b, l = flyCtrl.l, r = flyCtrl.r}
        elseif flySpeed ~= 0 then
            local cam = workspace.CurrentCamera
            local forward = cam.CFrame.LookVector
            local right = cam.CFrame.RightVector
            local velocity = (forward * (lastFlyCtrl.f + lastFlyCtrl.b) + right * (lastFlyCtrl.l + lastFlyCtrl.r)) * flySpeed
            bv.velocity = velocity
        else
            bv.velocity = Vector3.new(0, 0.1, 0)
        end
        
        if moveZ ~= 0 then
            bg.CFrame = workspace.CurrentCamera.CFrame * CFrame.Angles(-math.rad(moveZ * 50 * flySpeed / maxFlySpeed), 0, 0)
        end
        task.wait()
    end
    
    if bg then bg:Destroy() end
    if bv then bv:Destroy() end
    if humanoid then humanoid.PlatformStand = false end
end

local function StartFly()
    if flyConnection then return end
    if not LocalPlayer.Character then return end
    
    flying = true
    
    if isMobile then
        CreateFlyButtons()
    else
        -- Untuk PC, pakai keyboard
        local function onKeyDown(key)
            key = key:lower()
            if key == "e" then
                flying = not flying
                if flying then
                    Notify("FLY", "Fly: Enabled", "success", 2)
                    Fly()
                else
                    Notify("FLY", "Fly: Disabled", "info", 2)
                end
            elseif key == "w" then
                flyCtrl.f = 1
            elseif key == "s" then
                flyCtrl.b = -1
            elseif key == "a" then
                flyCtrl.l = -1
            elseif key == "d" then
                flyCtrl.r = 1
            end
        end
        
        local function onKeyUp(key)
            key = key:lower()
            if key == "w" then
                flyCtrl.f = 0
            elseif key == "s" then
                flyCtrl.b = 0
            elseif key == "a" then
                flyCtrl.l = 0
            elseif key == "d" then
                flyCtrl.r = 0
            end
        end
        
        local mouse = LocalPlayer:GetMouse()
        flyKeyConnection = {
            KeyDown = mouse.KeyDown:Connect(onKeyDown),
            KeyUp = mouse.KeyUp:Connect(onKeyUp)
        }
    end
    
    Fly()
end

local function StopFly()
    flying = false
    if not isMobile then
        if flyKeyConnection then
            if flyKeyConnection.KeyDown then flyKeyConnection.KeyDown:Disconnect() end
            if flyKeyConnection.KeyUp then flyKeyConnection.KeyUp:Disconnect() end
            flyKeyConnection = nil
        end
    else
        RemoveFlyButtons()
    end
    if bg then bg:Destroy() end
    if bv then bv:Destroy() end
    flyCtrl = {f = 0, b = 0, l = 0, r = 0, up = 0, down = 0}
    flySpeed = 0
    if LocalPlayer.Character and LocalPlayer.Character.Humanoid then
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end
end

MainSection:AddToggle({
    Text = "🕊️ Fly Mode " .. (isMobile and "(Touch Controls)" or "(Press E to toggle)"),
    Default = false,
    Callback = function(value)
        flyEnabled = value
        if value then
            StartFly()
            if isMobile then
                Notify("FLY", "Fly mode enabled! Use on-screen buttons", "success", 3)
            else
                Notify("FLY", "Fly mode enabled! Press E to start flying", "success", 3)
            end
        else
            StopFly()
            Notify("FLY", "Fly mode disabled", "info", 2)
        end
    end
})

--// TELEPORT PLAYER

local TeleportSection = MainTab:AddSection("🎯 Teleport to Player")

local selectedTeleportPlayer = nil
local playerDropdown = nil

local function UpdatePlayerList()
    local list = {"Select Player"}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(list, plr.Name)
        end
    end
    return list
end

playerDropdown = TeleportSection:AddDropdown({
    Text = "👥 Select Player",
    Options = UpdatePlayerList(),
    Default = "Select Player",
    Callback = function(option)
        selectedTeleportPlayer = option
    end
})

TeleportSection:AddButton({
    Text = "✨ Teleport to Player",
    Callback = function()
        local selectedPlayer = selectedTeleportPlayer
        if not selectedPlayer or selectedPlayer == "Select Player" then
            Notify("TELEPORT", "Please select a player first.", "warning", 2)
            return
        end
        local target = Players:FindFirstChild(selectedPlayer)
        local targetRoot = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot and myRoot then
            myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
            Notify("TELEPORT", "Teleported to " .. selectedPlayer, "success", 2)
        else
            Notify("TELEPORT", "Target or character not found.", "error", 2)
        end
    end
})

TeleportSection:AddButton({
    Text = "🔄 Refresh Player List",
    Callback = function()
        if playerDropdown then
            playerDropdown:SetOptions(UpdatePlayerList())
            Notify("TELEPORT", "Player list refreshed.", "success", 2)
        end
    end
})

--// AUTO SUMMIT (CP1 - CP21)
local AutoSummitSection = MainTab:AddSection("🏔️ Auto Summit")

local autoSummitEnabled = false
local autoSummitConnection = nil
local currentCp = 1
local cpDelay = 0.5

local function TeleportToCP(cpNumber)
    local character = LocalPlayer.Character
    if not character then return false end
    
    local target = workspace:FindFirstChild("Checkpoints")
    if not target then
        Notify("AUTO SUMMIT", "Checkpoints not found!", "error", 2)
        return false
    end
    
    local cpName = "CP" .. cpNumber
    local cp = target:FindFirstChild(cpName)
    
    if not cp then
        Notify("AUTO SUMMIT", cpName .. " not found!", "error", 2)
        return false
    end
    
    if cp:IsA("Model") then
        character:PivotTo(cp:GetPivot() + Vector3.new(0, 3, 0))
        return true
    elseif cp:IsA("BasePart") then
        character:PivotTo(cp.CFrame + Vector3.new(0, 3, 0))
        return true
    else
        Notify("AUTO SUMMIT", "Target is not a Model or BasePart", "error", 2)
        return false
    end
end

local function StartAutoSummit()
    if autoSummitConnection then return end
    currentCp = 1
    
    autoSummitConnection = RunService.Heartbeat:Connect(function()
        if autoSummitEnabled then
            if currentCp <= 21 then
                TeleportToCP(currentCp)
                Notify("AUTO SUMMIT", "Teleporting to CP" .. currentCp, "info", 1)
                currentCp = currentCp + 1
                task.wait(cpDelay)
            else
                autoSummitEnabled = false
                if autoSummitConnection then
                    autoSummitConnection:Disconnect()
                    autoSummitConnection = nil
                end
                Notify("AUTO SUMMIT", "Summit Complete! Reached CP21", "success", 3)
            end
        end
    end)
end

local function StopAutoSummit()
    if autoSummitConnection then
        autoSummitConnection:Disconnect()
        autoSummitConnection = nil
    end
    currentCp = 1
end

AutoSummitSection:AddToggle({
    Text = "🏔️ Auto Summit",
    Default = false,
    Callback = function(value)
        autoSummitEnabled = value
        if value then
            StartAutoSummit()
            Notify("AUTO SUMMIT", "Auto Summit: Enabled - Teleporting from CP1 to CP21", "success", 3)
        else
            StopAutoSummit()
            Notify("AUTO SUMMIT", "Auto Summit: Disabled", "info", 2)
        end
    end
})

AutoSummitSection:AddSlider({
    Text = "⏱️ Delay between CP (seconds)",
    Min = 0.1,
    Max = 5,
    Default = 0.5,
    Callback = function(value)
        cpDelay = value
        Notify("AUTO SUMMIT", "Delay set to: " .. string.format("%.1f", value) .. " seconds", "info", 1)
    end
})

AutoSummitSection:AddButton({
    Text = "🔄 Reset Summit",
    Callback = function()
        currentCp = 1
        Notify("AUTO SUMMIT", "Summit reset to CP1", "info", 2)
    end
})

--// ESP

local ESPSection = ESPTab:AddSection("👁️ ESP")

local espEnabled = false
local espObjects = {}
local espColor = Color3.fromRGB(255, 0, 0)
local espConnection = nil

local espColors = {
    Red = Color3.fromRGB(255, 0, 0),
    Green = Color3.fromRGB(0, 255, 120),
    Blue = Color3.fromRGB(0, 170, 255),
    Yellow = Color3.fromRGB(255, 220, 0),
    White = Color3.fromRGB(255, 255, 255),
    Purple = Color3.fromRGB(170, 80, 255)
}

local function CreateESP(plr)
    if not plr or plr == LocalPlayer then return end
    local character = plr.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not character or not root then return end
    if espObjects[plr] then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "Anixly_ESP_Highlight"
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.FillColor = espColor
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Adornee = character
    highlight.Parent = character

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "Anixly_ESP_Billboard"
    billboard.Size = UDim2.new(0, 200, 0, 45)
    billboard.StudsOffset = Vector3.new(0, 2.8, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = root

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "NameLabel"
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextScaled = true
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextStrokeTransparency = 0.45
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Text = plr.Name
    textLabel.Parent = billboard

    espObjects[plr] = {highlight = highlight, billboard = billboard, textLabel = textLabel}
end

local function RemoveESP(plr)
    local espObj = espObjects[plr]
    if espObj then
        if espObj.highlight then espObj.highlight:Destroy() end
        if espObj.billboard then espObj.billboard:Destroy() end
        espObjects[plr] = nil
    end
end

local function ClearAllESP()
    for plr in pairs(espObjects) do RemoveESP(plr) end
    espObjects = {}
end

local function UpdateAllESP()
    if not espEnabled then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then CreateESP(plr) end
    end
end

local function UpdateDistance()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    for plr, espObj in pairs(espObjects) do
        local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if root and espObj.textLabel then
            local distance = (myRoot.Position - root.Position).Magnitude
            espObj.textLabel.Text = plr.Name .. " [" .. string.format("%.1f", distance) .. "m]"
            if distance < 20 then
                espObj.textLabel.TextColor3 = Color3.fromRGB(255, 70, 70)
            elseif distance < 50 then
                espObj.textLabel.TextColor3 = Color3.fromRGB(255, 180, 0)
            else
                espObj.textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        else
            RemoveESP(plr)
        end
    end
end

ESPSection:AddToggle({
    Text = "Enable ESP",
    Default = false,
    Callback = function(value)
        espEnabled = value
        if value then
            UpdateAllESP()
            if espConnection then espConnection:Disconnect() end
            espConnection = RunService.Heartbeat:Connect(function()
                if espEnabled then
                    UpdateAllESP()
                    UpdateDistance()
                end
            end)
            Notify("ESP", "ESP Enabled", "success", 2)
        else
            if espConnection then espConnection:Disconnect() end
            ClearAllESP()
            Notify("ESP", "ESP Disabled", "info", 2)
        end
    end
})

ESPSection:AddDropdown({
    Text = "🎨 ESP Color",
    Options = {"Red", "Green", "Blue", "Yellow", "White", "Purple"},
    Default = "Red",
    Callback = function(option)
        espColor = espColors[option] or Color3.fromRGB(255, 0, 0)
        for _, espObj in pairs(espObjects) do
            if espObj.highlight then espObj.highlight.FillColor = espColor end
        end
    end
})

ESPSection:AddButton({
    Text = "🔄 Refresh ESP",
    Callback = function()
        if espEnabled then
            ClearAllESP()
            task.wait(0.3)
            UpdateAllESP()
            Notify("ESP", "ESP Refreshed", "success", 2)
        else
            Notify("ESP", "Enable ESP first.", "warning", 2)
        end
    end
})

-- Auto update ESP when players join/leave
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.7)
        if espEnabled then
            RemoveESP(plr)
            CreateESP(plr)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(plr)
    RemoveESP(plr)
end)

--// UTILITY - ANTI STAFF & ANTI AFK

local UtilitySection = UtilityTab:AddSection("🛡️ Anti Staff & Anti AFK")

-- Anti Staff
local staffKeywords = {
    "admin", "mod", "moderator", "owner", "creator", "dev", "developer",
    "staff", "manager", "super", "helper", "trial", "head",
    "lead", "senior", "junior", "coordinator", "supervisor", "gm", "game master"
}

local antiStaffEnabled = false
local antiStaffConnection = nil

local function CheckForStaff()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local nameLower = plr.Name:lower()
            local displayLower = plr.DisplayName:lower()
            for _, keyword in ipairs(staffKeywords) do
                if nameLower:find(keyword) or displayLower:find(keyword) then
                    return true, plr.Name, keyword
                end
            end
        end
    end
    return false, nil, nil
end

local function StartAntiStaff()
    if antiStaffConnection then return end
    antiStaffConnection = RunService.Heartbeat:Connect(function()
        if antiStaffEnabled then
            local found, name, keyword = CheckForStaff()
            if found then
                Notify("⚠️ STAFF DETECTED", name .. " [" .. keyword .. "] - Hopping server...", "error", 5)
                task.wait(1)
                local servers = {}
                local success, result = pcall(function()
                    return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"))
                end)
                if success and result and result.data then
                    for _, v in pairs(result.data) do
                        if v.playing and v.id ~= game.JobId then
                            table.insert(servers, v.id)
                        end
                    end
                    if #servers > 0 then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
                    else
                        TeleportService:Teleport(game.PlaceId, LocalPlayer)
                    end
                else
                    TeleportService:Teleport(game.PlaceId, LocalPlayer)
                end
            end
        end
    end)
end

local function StopAntiStaff()
    if antiStaffConnection then
        antiStaffConnection:Disconnect()
        antiStaffConnection = nil
    end
end

UtilitySection:AddToggle({
    Text = "🛡️ Anti Staff",
    Default = false,
    Callback = function(value)
        antiStaffEnabled = value
        if value then
            StartAntiStaff()
            Notify("ANTI STAFF", "Anti Staff: Enabled - Will auto hop if staff detected", "success", 3)
        else
            StopAntiStaff()
            Notify("ANTI STAFF", "Anti Staff: Disabled", "info", 2)
        end
    end
})

-- Anti AFK
local antiAFKEnabled = false
local afkConnection = nil
local lastInput = tick()

UIS.InputBegan:Connect(function() lastInput = tick() end)
UIS.InputChanged:Connect(function() lastInput = tick() end)

local function SimulateInput()
    UIS.InputBegan:Fire(Enum.KeyCode.W, Enum.UserInputState.Begin)
    task.wait(0.1)
    UIS.InputEnded:Fire(Enum.KeyCode.W, Enum.UserInputState.End)
end

local function StartAntiAFK()
    if afkConnection then return end
    afkConnection = RunService.Heartbeat:Connect(function()
        if antiAFKEnabled then
            if tick() - lastInput > 50 then
                SimulateInput()
                lastInput = tick()
            end
        end
    end)
end

local function StopAntiAFK()
    if afkConnection then
        afkConnection:Disconnect()
        afkConnection = nil
    end
end

UtilitySection:AddToggle({
    Text = "💤 Anti AFK",
    Default = false,
    Callback = function(value)
        antiAFKEnabled = value
        if value then
            StartAntiAFK()
            Notify("ANTI AFK", "Anti AFK: Enabled - You won't be kicked for inactivity", "success", 3)
        else
            StopAntiAFK()
            Notify("ANTI AFK", "Anti AFK: Disabled", "info", 2)
        end
    end
})

-- Auto update all features when character respawns
LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(0.6)
    if speedEnabled then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.WalkSpeed = walkspeedValue end
    end
    if noclipEnabled then EnableNoclip() end
    if infinityJumpEnabled then EnableInfinityJump() end
    if flyEnabled then
        task.wait(0.5)
        StopFly()
        StartFly()
    end
end)

print("✅ Anixly Hub Loaded Successfully!")
print("🚀 Executor: " .. executorName)