

local VirtualUser = game:GetService("VirtualUser")
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
    openshops = tabs.main:NewSection("Open Shop"),
    sell = tabs.main:NewSection("Sell Crypto"),
    others = tabs.main:NewSection("Others"),
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
    autosell = false,
    antiafk = false
}

local values = {
    gputobuy = "",
    gpuamt = 1
}

-- funcs

function getshopsnames()
    local shops = {}
    for i, v in pairs(game:GetService("Workspace").Shops:GetChildren()) do 
        if v.ClassName == "Model" then 
            table.insert(shops, v.Name)
        end
    end
    
    return shops
end

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

sections.player:NewButton("Redeem codes", "Redeems most codes found", function()
    local codeslist = {}
    for i, v in pairs(game:GetService("Workspace").Codes:GetChildren()) do 
        table.insert(codeslist, v.SurfaceGui.SIGN.Text:split(" ")[2])
    end
    
    fireproximityprompt(game:GetService("Workspace").Codes["Meshes/INviter Friends_Plane.008"].ProximityPrompt)
    
    for i, v in pairs(codeslist) do 
        localplayer.PlayerGui.NewUi.Codes.CodesContainer.Input.Value.Text = v
        task.wait(1)
        firesignal(player.PlayerGui.NewUi.Codes.CodesContainer.Enter.MouseButton1Down)
    end
end)

sections.openshops:NewDropdown("Select Shop", "Select the shop to open", getshopsnames(), function(option)
    game:GetService("ReplicatedStorage").LEvents.OpenShop:Fire(game:GetService("Workspace").Shops[option].Shows, true)
    spawn(function()
        for i = 1, 100, 1 do 
            task.wait(0.01)
            keypress(0x45)
            task.wait(0.1)
            keyrelease(0x45)
        end
    end)
end)

sections.sell:NewButton("Sell Bitcoin", "Sells your Bitcoin", function() 
    sellcrypto("bitcoin")
end)

sections.sell:NewButton("Sell Solaris", "Sells your Solaris", function() 
    sellcrypto("solaris")
end)

-- AutoFarm 

sections.autofarm:NewButton("Enable Full Farm and AutoBuy/Place", "Combines all functions ands automatically buys new cards etc.", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/houjk2/Bitcoin-miner-script/main/autofarm.lua"))()
	game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "AutoFarm initiated",
	Text = "AutoFarm succesfully executed please refrain from using autofarm toggles from now on",
	Duration = 4
    })
end)

sections.autofarm:NewToggle("AntiAfk", "You won't be kicked for idling", function(toggle) 
    toggles.antiafk = toggle
end)


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

-- anti afk 

player.Idled:connect(function()
    if toggles.antiafk == true then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)


