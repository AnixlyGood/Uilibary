repeat task.wait() until game:IsLoaded()

local AnixlyUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/AnixlyGood/Uilibary/refs/heads/main/AnixlyUi.lua"))()

local IMAGE_ID = "https://imgur.com/a/UAQbFpI.png"

local Window = AnixlyUI:CreateWindow({
    Title = "Anixly Hub",
    Subtitle = "Version 1.0.0",
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

local DashboardSection = DashboardTab:AddSection("Information")

-- Header Info
DashboardSection:AddLabel("═══════════════════════════════")
DashboardSection:AddLabel("       WELCOME TO ANIXLY HUB")
DashboardSection:AddLabel("═══════════════════════════════")

-- User Info
local player = game.Players.LocalPlayer
local userId = player.UserId

DashboardSection:AddLabel("📊 INFORMATION:")
DashboardSection:AddLabel("👤 Username: " .. player.Name)
DashboardSection:AddLabel("🆔 User ID: " .. userId)
DashboardSection:AddLabel("⭐ Display Name: " .. player.DisplayName)

local success, gameInfo = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
end)

if success and gameInfo then
    DashboardSection:AddLabel("🎯 Game Name: " .. gameInfo.Name)
end
DashboardSection:AddLabel("🆔 Game ID: " .. game.PlaceId)
DashboardSection:AddLabel("🌍 Server ID: " .. string.sub(game.JobId, 1, 8) .. "...")
DashboardSection:AddLabel("👥 Players Online: " .. #game.Players:GetPlayers())

-- Rejoin Server Button
DashboardSection:AddButton({
    Text = "🔄 Rejoin Server",
    Callback = function()
        AnixlyUI:ShowNotification({
            Title = "REJOIN SERVER",
            Message = "Rejoining server...",
            Theme = "warning",
            Icon = IMAGE_ID,
            Duration = 2
        })
        task.wait(1)
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

-- Server Hop Button
DashboardSection:AddButton({
    Text = "🎲 Server Hop",
    Callback = function()
        AnixlyUI:ShowNotification({
            Title = "SERVER HOP",
            Message = "Searching for new server...",
            Theme = "warning",
            Icon = IMAGE_ID,
            Duration = 2
        })
        
        local servers = {}
        local success, result = pcall(function()
            return game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"))
        end)
        
        if success and result and result.data then
            for _, v in pairs(result.data) do
                if v.playing and v.id ~= game.JobId then
                    table.insert(servers, v.id)
                end
            end
            
            if #servers > 0 then
                local randomServer = servers[math.random(1, #servers)]
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, randomServer, game.Players.LocalPlayer)
            else
                AnixlyUI:ShowNotification({
                    Title = "SERVER HOP",
                    Message = "No other servers found!",
                    Theme = "error",
                    Icon = IMAGE_ID,
                    Duration = 3
                })
            end
        else
            AnixlyUI:ShowNotification({
                Title = "SERVER HOP",
                Message = "Failed to fetch servers!",
                Theme = "error",
                Icon = IMAGE_ID,
                Duration = 3
            })
        end
    end
})

local MainSection = MainTab:AddSection("Main")

-- Noclip
local noclipEnabled = false
local noclipConnection = nil

function EnableNoclip()
    if noclipConnection then return end
    noclipConnection = game:GetService("RunService").Stepped:Connect(function()
        if noclipEnabled and game.Players.LocalPlayer.Character then
            local character = game.Players.LocalPlayer.Character
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

function DisableNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    if game.Players.LocalPlayer.Character then
        local character = game.Players.LocalPlayer.Character
        for _, part in ipairs(character:GetDescendants()) do
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
            AnixlyUI:ShowNotification({
                Title = "NOCLIP",
                Message = "Noclip: Enabled",
                Theme = "success",
                Icon = IMAGE_ID,
                Duration = 2
            })
        else
            DisableNoclip()
            AnixlyUI:ShowNotification({
                Title = "NOCLIP",
                Message = "Noclip: Disabled",
                Theme = "info",
                Icon = IMAGE_ID,
                Duration = 2
            })
        end
    end
})

-- Infinity Jump
local infinityJumpEnabled = false
local jumpConnection = nil

function EnableInfinityJump()
    if jumpConnection then return end
    jumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
        if infinityJumpEnabled and game.Players.LocalPlayer.Character then
            local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

function DisableInfinityJump()
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
            AnixlyUI:ShowNotification({
                Title = "INFINITY JUMP",
                Message = "Infinity Jump: Enabled",
                Theme = "success",
                Icon = IMAGE_ID,
                Duration = 2
            })
        else
            DisableInfinityJump()
            AnixlyUI:ShowNotification({
                Title = "INFINITY JUMP",
                Message = "Infinity Jump: Disabled",
                Theme = "info",
                Icon = IMAGE_ID,
                Duration = 2
            })
        end
    end
})

-- Speed Settings
local speedEnabled = false
local originalWalkspeed = 16
local walkspeedValue = 50

MainSection:AddToggle({
    Text = "⚡ Speed Hack",
    Default = false,
    Callback = function(value)
        speedEnabled = value
        local character = game.Players.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                if value then
                    originalWalkspeed = humanoid.WalkSpeed
                    humanoid.WalkSpeed = walkspeedValue
                    AnixlyUI:ShowNotification({
                        Title = "SPEED HACK",
                        Message = "Speed Hack: Enabled (" .. walkspeedValue .. " WS)",
                        Theme = "success",
                        Icon = IMAGE_ID,
                        Duration = 2
                    })
                else
                    humanoid.WalkSpeed = originalWalkspeed
                    AnixlyUI:ShowNotification({
                        Title = "SPEED HACK",
                        Message = "Speed Hack: Disabled",
                        Theme = "info",
                        Icon = IMAGE_ID,
                        Duration = 2
                    })
                end
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
            local character = game.Players.LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = value
                end
            end
        end
        AnixlyUI:ShowNotification({
            Title = "WALKSPEED",
            Message = "WalkSpeed set to: " .. value,
            Theme = "info",
            Icon = IMAGE_ID,
            Duration = 1
        })
    end
})

-- Auto update speed when character respawns
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    if speedEnabled then
        local humanoid = character:FindFirstChild("Humanoid")
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

-- Teleport
local TeleportSection = MainTab:AddSection("🎯 Teleport to Player")

local playerDropdown = nil

-- Function to update player list
local function UpdatePlayerList()
    local players = {}
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(players, player.Name)
        end
    end
    return players
end

-- Function to refresh dropdown
local function RefreshTeleportDropdown()
    local players = UpdatePlayerList()
    if playerDropdown then
        playerDropdown:SetOptions(players)
    end
end

-- Create dropdown for player selection
playerDropdown = TeleportSection:AddDropdown({
    Text = "👥 Select Player",
    Options = UpdatePlayerList(),
    Default = "Select Player",
    Callback = function(option)
        print("Selected player:", option)
    end
})

-- Teleport button
TeleportSection:AddButton({
    Text = "✨ Teleport to Player",
    Callback = function()
        local selectedPlayer = playerDropdown.Value
        if selectedPlayer and selectedPlayer ~= "Select Player" then
            local target = game.Players:FindFirstChild(selectedPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local localPlayer = game.Players.LocalPlayer
                if localPlayer and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    localPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                    AnixlyUI:ShowNotification({
                        Title = "TELEPORT",
                        Message = "Teleported to " .. selectedPlayer,
                        Theme = "success",
                        Icon = IMAGE_ID,
                        Duration = 2
                    })
                else
                    AnixlyUI:ShowNotification({
                        Title = "TELEPORT",
                        Message = "Your character not found!",
                        Theme = "error",
                        Icon = IMAGE_ID,
                        Duration = 2
                    })
                end
            else
                AnixlyUI:ShowNotification({
                    Title = "TELEPORT",
                    Message = "Target player not found or no character!",
                    Theme = "error",
                    Icon = IMAGE_ID,
                    Duration = 2
                })
            end
        else
            AnixlyUI:ShowNotification({
                Title = "TELEPORT",
                Message = "Please select a player first!",
                Theme = "warning",
                Icon = IMAGE_ID,
                Duration = 2
            })
        end
    end
})

-- Refresh button
TeleportSection:AddButton({
    Text = "🔄 Refresh Player List",
    Callback = function()
        RefreshTeleportDropdown()
        AnixlyUI:ShowNotification({
            Title = "TELEPORT",
            Message = "Player list refreshed!",
            Theme = "info",
            Icon = IMAGE_ID,
            Duration = 2
        })
    end
})

-- Auto refresh player list when players join/leave
game.Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    RefreshTeleportDropdown()
end)

game.Players.PlayerRemoving:Connect(function()
    task.wait(0.5)
    RefreshTeleportDropdown()
end)

-- ESP Section
local ESPSection = ESPTab:AddSection("👁️ ESP")

local espEnabled = false
local espObjects = {}
local playerList = {}

local function CreateESP(player)
    if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Adornee = player.Character
    highlight.Parent = player.Character
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = player.Character:FindFirstChild("HumanoidRootPart") or player.Character
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "NameLabel"
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextScaled = true
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextStrokeTransparency = 0.5
    textLabel.Text = player.Name
    textLabel.Parent = billboard
    
    return {highlight = highlight, billboard = billboard, textLabel = textLabel}
end

local function UpdateDistance()
    local localPlayer = game.Players.LocalPlayer
    if not localPlayer or not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local localPos = localPlayer.Character.HumanoidRootPart.Position
    
    for _, player in ipairs(playerList) do
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local espObj = espObjects[player]
            if espObj and espObj.textLabel then
                local distance = (localPos - player.Character.HumanoidRootPart.Position).Magnitude
                local formattedDistance = string.format("%.1f", distance)
                espObj.textLabel.Text = player.Name .. " [" .. formattedDistance .. "m]"
                
                if distance < 20 then
                    espObj.textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                elseif distance < 50 then
                    espObj.textLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
                else
                    espObj.textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end
end

local function RemoveESP(player)
    local espObj = espObjects[player]
    if espObj then
        if espObj.highlight then espObj.highlight:Destroy() end
        if espObj.billboard then espObj.billboard:Destroy() end
        espObjects[player] = nil
    end
end

local function ClearAllESP()
    for player, espObj in pairs(espObjects) do
        if espObj.highlight then espObj.highlight:Destroy() end
        if espObj.billboard then espObj.billboard:Destroy() end
    end
    espObjects = {}
end

local function UpdateAllESP()
    if not espEnabled then return end
    
    local localPlayer = game.Players.LocalPlayer
    
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= localPlayer then
            if not espObjects[player] and player.Character then
                local espObj = CreateESP(player)
                if espObj then
                    espObjects[player] = espObj
                end
            elseif espObjects[player] and (not player.Character or not player.Character.Parent) then
                RemoveESP(player)
            end
        end
    end
end

ESPSection:AddToggle({
    Text = "🔍 Enable ESP",
    Default = false,
    Callback = function(value)
        espEnabled = value
        
        if value then
            playerList = {}
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    table.insert(playerList, player)
                end
            end
            
            UpdateAllESP()
            
            spawn(function()
                while espEnabled do
                    UpdateDistance()
                    task.wait(0.5)
                end
            end)
            
            game.Players.PlayerAdded:Connect(function(player)
                if espEnabled and player ~= game.Players.LocalPlayer then
                    table.insert(playerList, player)
                    player.CharacterAdded:Connect(function()
                        task.wait(0.5)
                        if espEnabled and player.Character then
                            if espObjects[player] then RemoveESP(player) end
                            local espObj = CreateESP(player)
                            if espObj then espObjects[player] = espObj end
                        end
                    end)
                end
            end)
            
            game.Players.PlayerRemoving:Connect(function(player)
                if espEnabled then
                    for i, p in ipairs(playerList) do
                        if p == player then
                            table.remove(playerList, i)
                            break
                        end
                    end
                    RemoveESP(player)
                end
            end)
            
            AnixlyUI:ShowNotification({
                Title = "ESP",
                Message = "ESP Enabled",
                Theme = "success",
                Icon = IMAGE_ID,
                Duration = 2
            })
        else
            ClearAllESP()
            playerList = {}
            AnixlyUI:ShowNotification({
                Title = "ESP",
                Message = "ESP Disabled",
                Theme = "info",
                Icon = IMAGE_ID,
                Duration = 2
            })
        end
    end
})

ESPSection:AddColorPicker({
    Text = "🎨 ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        for _, espObj in pairs(espObjects) do
            if espObj.highlight then
                espObj.highlight.FillColor = color
            end
        end
    end
})

ESPSection:AddButton({
    Text = "🔄 Refresh ESP",
    Callback = function()
        if espEnabled then
            ClearAllESP()
            task.wait(0.5)
            UpdateAllESP()
            AnixlyUI:ShowNotification({
                Title = "ESP",
                Message = "ESP Refreshed",
                Theme = "success",
                Icon = IMAGE_ID,
                Duration = 2
            })
        end
    end
})

-- Auto update for character
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if espEnabled then
        ClearAllESP()
        task.wait(0.5)
        UpdateAllESP()
    end
end)

-- ==================== UTILITY SECTION ====================
local UtilitySection = UtilityTab:AddSection("🛡️ Anti Admin")

local adminKeywords = {
    "admin", "mod", "moderator", "owner", "creator", "dev", "developer",
    "staff", "manager", "super", "helper", "trial", "head",
    "lead", "senior", "junior", "coordinator", "supervisor", "administrator"
}

local antiAdminEnabled = false
local checkConnection = nil

local function isAdminName(name)
    local clean = name:lower():gsub("[^%a%d]", "")
    for _, keyword in ipairs(adminKeywords) do
        if clean:find(keyword, 1, true) then
            return true, keyword
        end
    end
    return false, nil
end

local function antiAdminCheck()
    local localPlayer = game.Players.LocalPlayer
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= localPlayer then
            local isAdmin, keyword = isAdminName(player.Name)
            if not isAdmin then
                isAdmin, keyword = isAdminName(player.DisplayName)
            end
            if isAdmin then
                print("🛡️ ADMIN DETECTED: " .. player.Name .. " [" .. keyword .. "] — Pindah server!")
                
                AnixlyUI:ShowNotification({
                    Title = "⚠️ ADMIN DETECTED",
                    Message = player.Name .. " [" .. keyword .. "] - Server hopping...",
                    Theme = "error",
                    Icon = IMAGE_ID,
                    Duration = 5
                })
                
                task.wait(1)
                
                local servers = {}
                local success, result = pcall(function()
                    return game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"))
                end)
                
                if success and result and result.data then
                    for _, v in pairs(result.data) do
                        if v.playing and v.id ~= game.JobId then
                            table.insert(servers, v.id)
                        end
                    end
                    
                    if #servers > 0 then
                        local randomServer = servers[math.random(1, #servers)]
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, randomServer, game.Players.LocalPlayer)
                    else
                        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
                    end
                else
                    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
                end
                return
            end
        end
    end
end

local function StartAntiAdmin()
    if checkConnection then return end
    
    antiAdminCheck()
    
    checkConnection = game:GetService("RunService").Stepped:Connect(function()
        if antiAdminEnabled then
            if tick() % 5 < 0.1 then
                antiAdminCheck()
            end
        end
    end)
end

local function StopAntiAdmin()
    if checkConnection then
        checkConnection:Disconnect()
        checkConnection = nil
    end
end

UtilitySection:AddToggle({
    Text = "🛡️ Anti Admin",
    Default = false,
    Callback = function(value)
        antiAdminEnabled = value
        if value then
            StartAntiAdmin()
            AnixlyUI:ShowNotification({
                Title = "ANTI ADMIN",
                Message = "Anti Admin: Enabled",
                Theme = "success",
                Icon = IMAGE_ID,
                Duration = 3
            })
        else
            StopAntiAdmin()
            AnixlyUI:ShowNotification({
                Title = "ANTI ADMIN",
                Message = "Anti Admin: Disabled",
                Theme = "info",
                Icon = IMAGE_ID,
                Duration = 2
            })
        end
    end
})

game.Players.PlayerAdded:Connect(function(player)
    if antiAdminEnabled then
        task.wait(1)
        antiAdminCheck()
    end
end)

-- ==================== ANTI AFK ====================
local AntiAFKSection = UtilityTab:AddSection("💤 Anti AFK")

local antiAFKEnabled = false
local afkConnection = nil
local virtualUser = nil

-- Method 1: Using VirtualUser
local function SetupVirtualUser()
    local success, vu = pcall(function()
        return game:GetService("VirtualUser")
    end)
    if success and vu then
        virtualUser = vu
        return true
    end
    return false
end

-- Method 2: Manual AFK bypass
local function ManualAFKBypass()
    local player = game.Players.LocalPlayer
    if player and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            -- Simulate movement
            humanoid:MoveTo(humanoid.RootPart.Position + Vector3.new(0, 0, 1))
            task.wait(0.1)
            humanoid:MoveTo(humanoid.RootPart.Position)
            
            -- Simulate camera movement
            game:GetService("UserInputService").InputBegan:Fire(mouse)
            
            -- Click on screen
            local mouse = player:GetMouse()
            if mouse then
                mouse.Button1Down:Fire()
                task.wait(0.1)
                mouse.Button1Up:Fire()
            end
        end
    end
end

-- Method 3: Using WalkDummy patch (kode dari user)
local function PatchWalkDummy()
    local success, module = pcall(function()
        return require(game:GetService("Players").LocalPlayer.PlayerScripts.ClientMain.Replications.Workers.WalkDummy)
    end)
    
    if success and module then
        local success2, oldFunction = pcall(function()
            return getconstant(module, 34)
        end)
        
        if success2 then
            setconstant(module, 34, function()
                game:GetService("RunService").Heartbeat:Wait()
            end)
            return true
        end
    end
    return false
end

-- Main Anti AFK function
local function StartAntiAFK()
    if afkConnection then return end
    
    local virtualUserSuccess = SetupVirtualUser()
    local walkDummyPatched = PatchWalkDummy()
    
    afkConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if antiAFKEnabled then
            -- Method 1: VirtualUser
            if virtualUserSuccess and virtualUser then
                pcall(function()
                    virtualUser:CaptureController()
                    virtualUser:ClickButton2(Vector2.new())
                    virtualUser:Button2Down(Vector2.new())
                    virtualUser:Button2Up(Vector2.new())
                end)
            end
            
            -- Method 2: Manual bypass every 30 seconds
            if tick() % 30 < 0.1 then
                ManualAFKBypass()
            end
            
            -- Method 3: Simulate user input
            game:GetService("UserInputService").InputBegan:Connect(function()
                -- Just to keep player active
            end)
        end
    end)
    
    -- Additional: Clicker every 60 seconds
    spawn(function()
        while antiAFKEnabled do
            task.wait(60)
            if antiAFKEnabled then
                -- Simulate key press (W key)
                game:GetService("UserInputService").InputBegan:Fire(
                    Enum.KeyCode.W,
                    Enum.UserInputState.Begin,
                    false
                )
                task.wait(0.1)
                game:GetService("UserInputService").InputEnded:Fire(
                    Enum.KeyCode.W,
                    Enum.UserInputState.End,
                    false
                )
            end
        end
    end)
end

local function StopAntiAFK()
    if afkConnection then
        afkConnection:Disconnect()
        afkConnection = nil
    end
    
    -- Restore WalkDummy if needed
    pcall(function()
        local module = require(game:GetService("Players").LocalPlayer.PlayerScripts.ClientMain.Replications.Workers.WalkDummy)
        local oldFunc = getconstant(module, 34)
        if oldFunc then
            setconstant(module, 34, oldFunc)
        end
    end)
end

-- Anti AFK Toggle
AntiAFKSection:AddToggle({
    Text = "💤 Anti AFK",
    Default = false,
    Callback = function(value)
        antiAFKEnabled = value
        if value then
            StartAntiAFK()
            AnixlyUI:ShowNotification({
                Title = "ANTI AFK",
                Message = "Anti AFK: Enabled - You won't be kicked for inactivity",
                Theme = "success",
                Icon = IMAGE_ID,
                Duration = 3
            })
        else
            StopAntiAFK()
            AnixlyUI:ShowNotification({
                Title = "ANTI AFK",
                Message = "Anti AFK: Disabled",
                Theme = "info",
                Icon = IMAGE_ID,
                Duration = 2
            })
        end
    end
})

print("✅ Anixly Hub Loaded Successfully!")