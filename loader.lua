repeat task.wait() until game:IsLoaded()

local AnixlyUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/AnixlyGood/Uilibary/refs/heads/main/AnixlyUi.lua"))()

local IMAGE_ID = "rbxassetid://101517365964699"

local Window = AnixlyUI:CreateWindow({
    Title = "Anixly Hub",
    Theme = "ANIXLY",
    MiniIcon = IMAGE_ID,
    Logo = IMAGE_ID,
    LogoText = "ANIXLY HUB",
    Size = {
        Width = 520,
        Height = 390
    }
})

local MainTab = Window:CreateTab("Main", "rbxassetid://101517365964699")
local MainSection = MainTab:AddSection("Main Menu")

MainSection:AddButton({
    Text = "Test Notification",
    Callback = function()
        AnixlyUI:ShowNotification({
            Title = "Anixly Notification",
            Message = "Ini notif pakai gambar custom",
            Theme = "success",
            Icon = IMAGE_ID,
            Duration = 3
        })
    end
})

MainSection:AddToggle({
    Text = "Auto Farm",
    Default = false,
    Callback = function(value)
        AnixlyUI:ShowNotification({
            Title = "Anixly Notification",
            Message = "Auto Farm: " .. tostring(value),
            Theme = "info",
            Icon = IMAGE_ID,
            Duration = 2
        })
    end
})

MainSection:AddSlider({
    Text = "Speed Value",
    Min = 1,
    Max = 100,
    Default = 16,
    Callback = function(value)
        print("Speed:", value)
    end
})