repeat task.wait() until game:IsLoaded()

local AnixlyUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/AnixlyGood/Uilibary/refs/heads/main/AnixlyUi.lua"))()

local Window = AnixlyUI:CreateWindow({
    Title = "Anixly Hub",
    Theme = "ANIXLY",
    Size = {
        Width = 520,
        Height = 390
    }
})

local MainTab = Window:CreateTab("Main", "rbxassetid://6023426945")
local PlayerTab = Window:CreateTab("Player", "rbxassetid://6023426959")
local MiscTab = Window:CreateTab("Misc", "rbxassetid://6023426926")

local MainSection = MainTab:AddSection("Main Menu")

MainSection:AddButton({
    Text = "Test Button",
    Callback = function()
        print("Button Main kepencet")

        AnixlyUI:ShowNotification({
            Title = "ANIXLY",
            Message = "Button berhasil dipencet!",
            Theme = "success",
            Duration = 3
        })
    end
})

MainSection:AddToggle({
    Text = "Test Toggle",
    Default = false,
    Callback = function(value)
        print("Toggle Main:", value)

        AnixlyUI:ShowNotification({
            Title = "TOGGLE",
            Message = "Toggle sekarang: " .. tostring(value),
            Theme = "info",
            Duration = 2
        })
    end
})

MainSection:AddDropdown({
    Text = "Pilih Mode",
    Options = {"Normal", "Fast", "Ultra"},
    Default = "Normal",
    Callback = function(option)
        print("Mode dipilih:", option)
    end
})

local PlayerSection = PlayerTab:AddSection("Player Settings")

PlayerSection:AddSlider({
    Text = "Speed Value",
    Min = 1,
    Max = 100,
    Default = 16,
    Callback = function(value)
        print("Speed Value:", value)
    end
})

PlayerSection:AddKeybind({
    Text = "Open Key",
    Default = "RightShift",
    Callback = function(key)
        print("Keybind diganti ke:", key)
    end,
    Pressed = function()
        print("Keybind ditekan")
    end
})

local Progress = PlayerSection:AddProgressBar({
    Text = "Loading Bar"
})

PlayerSection:AddButton({
    Text = "Test Progress",
    Callback = function()
        for i = 0, 100, 10 do
            Progress:SetProgress(i)
            task.wait(0.1)
        end
    end
})

local MiscSection = MiscTab:AddSection("Misc")

MiscSection:AddLabel("Anixly UI sudah berhasil muncul.")
MiscSection:AddLabel("Pencet tombol kuning buat minimize.")
MiscSection:AddLabel("Icon A bakal muncul setelah minimize.")

MiscSection:AddButton({
    Text = "Close Info",
    Callback = function()
        AnixlyUI:ShowNotification({
            Title = "INFO",
            Message = "UI aman, tinggal isi function callback lu.",
            Theme = "info",
            Duration = 3
        })
    end
})