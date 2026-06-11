repeat task.wait() until game:IsLoaded()

local AnixlyUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/AnixlyGood/Uilibary/refs/heads/main/AnixlyUi.lua"))()

local IMAGE_ID = "rbxassetid://101517365964699"

AnixlyUI:ShowKeySystem({
    Title = "ANIXLY KEY",
    Subtitle = "Masukkan key untuk membuka Anixly Hub",
    Key = "anixly123",

    Callback = function(success)
        if not success then
            return
        end

        local Window = AnixlyUI:CreateWindow({
            Title = "Anixly Hub",
            Theme = "ANIXLY",

            MiniIcon = IMAGE_ID,
            Logo = IMAGE_ID,
            LogoText = "",

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

        MainSection:AddDropdown({
            Text = "Pilih Mode",
            Options = {"Normal", "Fast", "Ultra"},
            Default = "Normal",
            Callback = function(option)
                print("Mode:", option)
            end
        })

        local PlayerSection = PlayerTab:AddSection("Player Settings")

        PlayerSection:AddSlider({
            Text = "Speed Value",
            Min = 1,
            Max = 100,
            Default = 16,
            Callback = function(value)
                print("Speed:", value)
            end
        })

        PlayerSection:AddKeybind({
            Text = "Open Key",
            Default = "RightShift",
            Callback = function(key)
                print("Keybind diganti:", key)
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

        local MiscSection = MiscTab:AddSection("Info")

        MiscSection:AddImage({
            Image = IMAGE_ID,
            Text = "ANIXLY HUB",
            Height = 150
        })

        MiscSection:AddLabel("Anixly UI berhasil muncul.")
        MiscSection:AddLabel("Key berhasil diverifikasi.")
        MiscSection:AddLabel("Mini icon pakai gambar custom.")

        MiscSection:AddButton({
            Text = "Notif Gambar",
            Callback = function()
                AnixlyUI:ShowNotification({
                    Title = "INFO",
                    Message = "Notif ini pakai gambar custom juga.",
                    Theme = "info",
                    Icon = IMAGE_ID,
                    Duration = 3
                })
            end
        })
    end
})