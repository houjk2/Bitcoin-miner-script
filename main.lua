


local players = game:GetService("Players")
local player = players.LocalPlayer

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Bitcoin Miner Gui by RoSploits", "DarkTheme")

local tabs = {
    main = Window:NewTab("Main"),
    autofarm = Window:NewTab("AutoFarm"),
    autobuy = Window:NewTab("AutoBuy"),
    teleport = Window:NewTab("Teleport"),
    credits = Window:NewTab("Credits")
}

local sections = {
    player = tabs.main:NewSection("Player"),
    sell = tabs.main:NewSection("Sell Crypto"),
    autofarm = tabs.autofarm:NewSection("AutoFarm"),
    autobuy = tabs.autobuy:NewSection("Buy Items"),
    teleport = tabs.teleport:NewSection("Teleports"),
    credits = tabs.credits:NewSection("Credits")
}

local teleportpos = {
    spawn = CFrame.new(153, 7, 93),
    future = CFrame.new(-144, 27, 13864),
    hsvshop = CFrame.new(40, 7, -1085)
}

local toggles = {
    autobestalgorithm = false,
    autosell = false
}

local values = {
    gputobuy = "",
    gpuamt = 1
}

-- funcs

function scientifictonum(scientificNum)
    local fullNum = tonumber(scientificNum)

    while fullNum == nil do
        local exponentPos = scientificNum:find("e")
        local baseNum = tonumber(scientificNum:sub(1, exponentPos-1))
        local exponent = tonumber(scientificNum:sub(exponentPos+1))
        fullNum = baseNum * 10^exponent
    end

    return fullNum
end

function abbreviatenumber(firstv)
    local numb = firstv
    if type(firstv) == "string" then
        numb = scientifictonum(firstv)
    end
    local abbrev = {"", "K", "M", "B", "T", "QD", "QT", "SX", "SP", "O", "N", "D"}
    local i = 1
    while numb >= 1000 and i < #abbrev do
        numb = numb / 1000
        i = i + 1
    end
    return string.format("%.1f%s", numb, abbrev[i])
end

function getshopversion(name)
    for i, v in pairs(game:GetService("Workspace").Shops:GetChildren()) do 
        for i2, v2 in pairs(v.Shows:GetChildren()) do 
            if tonumber(v2.Name) then
                if v2:GetChildren()[1].Name == name then 
                    return v2
                end
            end
        end
    end
end

function buycards(name, amount)
    local buyevent = game:GetService("ReplicatedStorage").Events.BuyCard
    
    buyevent:FireServer(name, getshopversion(name), amount)
end

function getlistofgpus()
    local nametable = {}
    for i, v in pairs(game:GetService("Workspace").Shops:GetChildren()) do 
        if v:FindFirstChild("Shows") then
            for i2, v2 in pairs(v.Shows:GetChildren()) do 
                if v2.ClassName == "Model" then 
                    for i3, v3 in pairs(v2:GetChildren()) do 
                        if v3.ClassName == "Model" then
                            if v3:FindFirstChild("Price") then 
                                table.insert(nametable, v3.Name.."  |  "..abbreviatenumber(v3.Price.Value))
                            elseif v3:FindFirstChild("SPrice") then
                                table.insert(nametable, v3.Name.."  |  S"..abbreviatenumber(v3.SPrice.Value))
                            end
                        end
                    end
                end
            end
        end
    end
    
    return nametable
end

function sellcrypto(name)
    if name == "bitcoin" then 
        if player.Character then
            for i = 1, 10, 1 do 
                local oldc = player.Character.HumanoidRootPart.CFrame
                player.Character.HumanoidRootPart.CFrame = CFrame.new(156, 7, 96)
                wait()
                game:GetService("ReplicatedStorage").Events.ExchangeMoney:FireServer(true)
                wait()
                player.Character.HumanoidRootPart.CFrame = oldc
            end
        end
    elseif name == "solaris" then
        if player.Character then
            for i = 1, 10, 1 do 
                local oldc = player.Character.HumanoidRootPart.CFrame
                player.Character.HumanoidRootPart.CFrame = CFrame.new(156, 7, 96)
                wait()
                game:GetService("ReplicatedStorage").Events.ExchangeMoney:FireServer(false)
                wait()
                player.Character.HumanoidRootPart.CFrame = oldc
            end
        end
    end
end

-- Main 

sections.player:NewSlider("Walkspeed", "Sets your walkspeed", 200, 16, function(amt)
    if player.Character then 
        player.Character.Humanoid.WalkSpeed = amt
    end
end)

sections.sell:NewButton("Sell Bitcoin", "Sells your Bitcoin", function() 
    sellcrypto("bitcoin")
end)

sections.sell:NewButton("Sell Solaris", "Sells your Solaris", function() 
    sellcrypto("solaris")
end)

-- AutoFarm 

sections.autofarm:NewToggle("Auto Choose Best Algorithm", "Automatically uses the best algorithm for maxium profit", function(toggle) 
    toggles.autobestalgorithm = toggle
end)

sections.autofarm:NewToggle("Auto Sell Crypto", "Automatically sells your crypto for money", function(toggle) 
    toggles.autosell = toggle
end)

-- AutoBuy

sections.autobuy:NewSlider("Amount", "Amount of GPU's to purchase", 100, 1, function(amt)
    values.gpuamt = amt
end)


sections.autobuy:NewDropdown("Select GPU", "Select the GPU to buy", getlistofgpus(), function(selection) 
    print(selection:split("|")[1]:split("  ")[1])
    values.gputobuy = selection:split("|")[1]:split("  ")[1]
end)

sections.autobuy:NewButton("Purchase", "Attempts to buy the selected GPU's", function()
    if values.gputobuy ~= "" then
        buycards(values.gputobuy, values.gpuamt)
    end
end)


-- Teleport 

local tpoptions = {}

for i, v in pairs(teleportpos) do 
    tpoptions[#tpoptions + 1] = i
end

sections.teleport:NewDropdown("Choose Teleport", "Teleport to your desired position", tpoptions, function(tp) 
    if player.Character then 
        player.Character.HumanoidRootPart.CFrame = teleportpos[tp]
    end
end)

sections.teleport:NewButton("To Plot", "Teleport to your activated plot", function()
    for i, v in pairs(game:GetService("Workspace"):GetChildren()) do 
        if v:FindFirstChild("Owned") then 
            if v.Owned.Value == true then 
                if v.Sign.wr.SurfaceGui.Text.Text == player.Name.."'s plot" then 
                    if player.Character then 
                        player.Character.HumanoidRootPart.CFrame = v.Frame.CFrame * CFrame.new(0, 20, 0)
                    end
                end
            end
        end
    end
end)

-- Credits

sections.credits:NewKeybind("Toggle Ui", "Open and Close the UI", Enum.KeyCode.RightShift, function()
	Library:ToggleUI()
end)

-- funcs

function choosebest()
    local highest = 0
    
    for i, v in pairs(player.PlayerGui.NewUi.UiButtons.SubButtonsContainer.SubButtonsMenu.Algorithms.AlgStore:GetChildren()) do 
        if v.ClassName == "TextButton" then 
            if tonumber(v.Rate.Text:split("x")[1]) > highest then
                highest = tonumber(v.Rate.Text:split("x")[1])
            end
        end
    end
    
    for i, v in pairs(player.PlayerGui.NewUi.UiButtons.SubButtonsContainer.SubButtonsMenu.Algorithms.AlgStore:GetChildren()) do 
        if v.ClassName == "TextButton" then 
            if tonumber(v.Rate.Text:split("x")[1]) == highest then
                highest = tonumber(v.Rate.Text:split("x")[1])
                firesignal(v.MouseButton1Down)
            end
        end
    end
end

-- autosell
spawn(function() 
    while task.wait(1) do
        if toggles.autosell == true then 
            sellcrypto("bitcoin")
            task.wait(10)
            sellcrypto("solaris")
            task.wait(9)
        end
    end
end)

-- auto algorithm
spawn(function()
    while task.wait(1) do 
        if toggles.autobestalgorithm == true then 
            choosebest()
        end
    end
end)


