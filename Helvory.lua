repeat task.wait() until game:IsLoaded()

local AnixlyUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/AnixlyGood/Uilibary/refs/heads/main/AnixlyUi.lua"))()

local IMAGE_ID = "rbxassetid://2061475061"

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

local DashboardTab = Window:CreateTab("Dashboard", "rbxassetid://6023426945")
local MainTab = Window:CreateTab("Main", "rbxassetid://6023426926")
local ESPTab = Window:CreateTab("ESP", "rbxassetid://6023426926")

local DashboardSection = DashboardTab:AddSection("Information")

DashboardSection:AddLabel("Welcome to Anixly Hub.")
DashboardSection:AddLabel("Version: 1.0.0")
DashboardSection:AddLabel("Status: Online")

-- Rejoin Server Button
DashboardSection:AddButton({
    Text = "Rejoin Server",
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
    Text = "Server Hop",
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

local MainSection = MainTab:AddSection("Movement")

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
    Text = "Noclip",
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
    Text = "Infinity Jump",
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
local originalJumppower = 50
local walkspeedValue = 50
local jumppowerValue = 80

MainSection:AddToggle({
    Text = "Speed Hack",
    Default = false,
    Callback = function(value)
        speedEnabled = value
        local character = game.Players.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                if value then
                    originalWalkspeed = humanoid.WalkSpeed
                    originalJumppower = humanoid.JumpPower
                    humanoid.WalkSpeed = walkspeedValue
                    humanoid.JumpPower = jumppowerValue
                    AnixlyUI:ShowNotification({
                        Title = "SPEED HACK",
                        Message = "Speed Hack: Enabled (" .. walkspeedValue .. " WS, " .. jumppowerValue .. " JP)",
                        Theme = "success",
                        Icon = IMAGE_ID,
                        Duration = 2
                    })
                else
                    humanoid.WalkSpeed = originalWalkspeed
                    humanoid.JumpPower = originalJumppower
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
    Text = "WalkSpeed",
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

MainSection:AddSlider({
    Text = "JumpPower",
    Min = 50,
    Max = 500,
    Default = 80,
    Callback = function(value)
        jumppowerValue = value
        if speedEnabled then
            local character = game.Players.LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.JumpPower = value
                end
            end
        end
        AnixlyUI:ShowNotification({
            Title = "JUMPPOWER",
            Message = "JumpPower set to: " .. value,
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
            humanoid.JumpPower = jumppowerValue
        end
    end
    if noclipEnabled then
        EnableNoclip()
    end
    if infinityJumpEnabled then
        EnableInfinityJump()
    end
end)

-- ESP Section
local ESPSection = ESPTab:AddSection("ESP Settings")

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
    Text = "Enable ESP",
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
    Text = "ESP Color",
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
    Text = "Refresh ESP",
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