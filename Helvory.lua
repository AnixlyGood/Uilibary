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

local MainSection = MainTab:AddSection("Main")

local noclipEnabled = false
local noclipConnection = nil

local function EnableNoclip()
    if noclipConnection then
        return
    end

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

local infinityJumpEnabled = false
local jumpConnection = nil

local function EnableInfinityJump()
    if jumpConnection then
        return
    end

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

LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(0.6)

    if speedEnabled then
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.WalkSpeed = walkspeedValue
        end
    end

    if noclipEnabled then
        EnableNoclip()
    end

    if infinityJumpEnabled then
        EnableInfinityJump()
    end
end)

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
        print("Selected player:", option)
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
        if playerDropdown and type(playerDropdown.SetOptions) == "function" then
            playerDropdown:SetOptions(UpdatePlayerList())
            Notify("TELEPORT", "Player list refreshed.", "success", 2)
        else
            Notify("TELEPORT", "Reload script untuk refresh player list.", "info", 3)
        end
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
    if not plr or plr == LocalPlayer then
        return
    end

    local character = plr.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not character or not root then
        return
    end

    if espObjects[plr] then
        return
    end

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

    espObjects[plr] = {
        highlight = highlight,
        billboard = billboard,
        textLabel = textLabel
    }
end

local function RemoveESP(plr)
    local espObj = espObjects[plr]

    if espObj then
        if espObj.highlight then
            espObj.highlight:Destroy()
        end

        if espObj.billboard then
            espObj.billboard:Destroy()
        end

        espObjects[plr] = nil
    end
end

local function ClearAllESP()
    for plr in pairs(espObjects) do
        RemoveESP(plr)
    end

    espObjects = {}
end

local function UpdateAllESP()
    if not espEnabled then
        return
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            CreateESP(plr)
        end
    end
end

local function UpdateDistance()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if not myRoot then
        return
    end

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

            if espConnection then
                espConnection:Disconnect()
            end

            espConnection = RunService.Heartbeat:Connect(function()
                if espEnabled then
                    UpdateAllESP()
                    UpdateDistance()
                end
            end)

            Notify("ESP", "ESP Enabled", "success", 2)
        else
            if espConnection then
                espConnection:Disconnect()
                espConnection = nil
            end

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
            if espObj.highlight then
                espObj.highlight.FillColor = espColor
            end
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

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        plr.CharacterAdded:Connect(function()
            task.wait(0.7)

            if espEnabled then
                RemoveESP(plr)
                CreateESP(plr)
            end
        end)
    end
end

--// UTILITY

local UtilitySection = UtilityTab:AddSection("🛠️ Utility")

UtilitySection:AddLabel("Utility loaded.")
UtilitySection:AddLabel("Version: 1.0.0")
UtilitySection:AddLabel("Executor: " .. executorName)

UtilitySection:AddButton({
    Text = "🔄 Rejoin Server",
    Callback = function()
        Notify("REJOIN", "Rejoining server...", "warning", 2)
        task.wait(1)
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

local StaffAlertSection = UtilityTab:AddSection("🛡️ Staff Alert")

local staffKeywords = {
    "admin",
    "mod",
    "moderator",
    "owner",
    "creator",
    "dev",
    "developer",
    "staff",
    "manager",
    "helper"
}

local staffAlertEnabled = false
local staffAlertConnection = nil
local lastStaffNotify = 0

local function CheckForStaffName()
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

StaffAlertSection:AddToggle({
    Text = "🛡️ Staff Alert",
    Default = false,
    Callback = function(value)
        staffAlertEnabled = value

        if value then
            if staffAlertConnection then
                staffAlertConnection:Disconnect()
            end

            staffAlertConnection = RunService.Heartbeat:Connect(function()
                if staffAlertEnabled and tick() - lastStaffNotify >= 8 then
                    local found, name, keyword = CheckForStaffName()

                    if found then
                        lastStaffNotify = tick()

                        Notify(
                            "STAFF ALERT",
                            name .. " detected keyword: " .. keyword,
                            "warning",
                            3
                        )
                    end
                end
            end)

            Notify("STAFF ALERT", "Staff Alert: Enabled", "success", 2)
        else
            if staffAlertConnection then
                staffAlertConnection:Disconnect()
                staffAlertConnection = nil
            end

            Notify("STAFF ALERT", "Staff Alert: Disabled", "info", 2)
        end
    end
})

local IdleSection = UtilityTab:AddSection("💤 Idle Reminder")

local idleReminderEnabled = false
local idleReminderConnection = nil
local lastInput = tick()

UIS.InputBegan:Connect(function()
    lastInput = tick()
end)

UIS.InputChanged:Connect(function()
    lastInput = tick()
end)

IdleSection:AddToggle({
    Text = "💤 Idle Reminder",
    Default = false,
    Callback = function(value)
        idleReminderEnabled = value

        if value then
            if idleReminderConnection then
                idleReminderConnection:Disconnect()
            end

            idleReminderConnection = RunService.Heartbeat:Connect(function()
                if idleReminderEnabled and tick() - lastInput > 60 then
                    lastInput = tick()
                    Notify("IDLE REMINDER", "Lu udah idle sekitar 60 detik.", "warning", 3)
                end
            end)

            Notify("IDLE REMINDER", "Idle Reminder: Enabled", "success", 2)
        else
            if idleReminderConnection then
                idleReminderConnection:Disconnect()
                idleReminderConnection = nil
            end

            Notify("IDLE REMINDER", "Idle Reminder: Disabled", "info", 2)
        end
    end
})

print("✅ Anixly Hub Loaded Successfully!")
print("🚀 Executor: " .. executorName)