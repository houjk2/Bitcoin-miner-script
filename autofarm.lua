

local VirtualUser = game:GetService("Players")
local player = game:GetService("Players").LocalPlayer

player.Idled:connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/houjk2/Bitcoin-miner-script/main/farmstatus.lua"))()



function changeinfo(infotype, txt, inmediate)
    inmediate = inmediate or false
    
    if inmediate == true then 
        if infotype == "gputarget" then 
            player.PlayerGui.notif.gputarget.TextLabel.Text = txt
        end
        if infotype == "notification" then 
            player.PlayerGui.notif.notification.TextLabel.Text = txt
        end
        
        return
    end
    
    if infotype == "gputarget" then 
        local splitted = txt:split("")
        player.PlayerGui.notif.gputarget.TextLabel.Text = ""
        
        for i, v in pairs(splitted) do
            player.PlayerGui.notif.gputarget.TextLabel.Text = player.PlayerGui.notif.gputarget.TextLabel.Text..v
            task.wait(0.01)
        end
    end
    
    if infotype == "notification" then 
        local splitted = txt:split("")
        player.PlayerGui.notif.notification.TextLabel.Text = ""
        for i, v in pairs(splitted) do 
            player.PlayerGui.notif.notification.TextLabel.Text = player.PlayerGui.notif.notification.TextLabel.Text..v
            task.wait(0.01)
        end
    end
end

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

changeinfo("notification", "Please stay at your plot")
changeinfo("gputarget", "Please stay at your plot")

wait(2)

changeinfo("notification", "Getting card information..")

wait(1)

function proccesnum(before, isradon)
    if type(before) == "number" and tostring(number):find(".") then
        if tostring(before):find("e") then
            local numb = tostring(before)
            
            if numb:split(".")[2]:split("")[1] == "e" then 
                return tonumber(numb:split(".")[1])
            end
            
            return tonumber(numb:split(".")[1].."."..numb:split(".")[2]:split("")[1]..numb:split(".")[2]:split("")[1])
        else
            return math.round(before * 100) / 100
        end
    end
end


mytable = {bitcoin = {}, solaris = {}}

for i, v in pairs(game:GetService("ReplicatedStorage").Objects:GetChildren()) do 
    if v.Class and v.Class.Value == "Card" and v:FindFirstChild("Limited") == nil then 
        if v:FindFirstChild("bps") then
            mytable.bitcoin[v.Name] = {
                price = tonumber(v.Price.Value),
                bps = tonumber(v.bps.Value),
                wattperbtc = proccesnum(v.Engr.Value / v.bps.Value),
                btcperprice = proccesnum(tonumber(v.bps.Value) / tonumber(v.Price.Value))
            }
        end
    end
end

changeinfo("notification", 'Got card information...')
wait(1)
changeinfo("notification", 'Starting..')
wait(0.5)

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

function getbps()
    return player.Bps.Value + player.Bps2.Value + player.Bps3.Value + player.Bps4.Value
end

function bitcointomoney(btc)
    return btc * tonumber(player.PlayerGui.NewUi.ExchangeUI.Values.Rate.Text:split(" ")[4])
end

function buycards(name, amount)
    local buyevent = game:GetService("ReplicatedStorage").Events.BuyCard
    
    buyevent:FireServer(name, getshopversion(name), amount)
end

function sellcrypto(name)
    if name == "bitcoin" then 
        changeinfo("notification", "selling bitcoin")
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
        changeinfo("notification", "Sold")
    elseif name == "solaris" then
        changeinfo("notification", "selling solaris")
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
        changeinfo("notification", "Sold")
    end
end

function calculatenextcard()
    local pricetarget = bitcointomoney(getbps()) * 300
    local minimumprice = bitcointomoney(getbps()) * 30
    local options = {}
    
    local bestcardname = ""
    local bestcardbtcperprice = 0
    
    for i, v in pairs(mytable.bitcoin) do
        if v.price > minimumprice and v.price < pricetarget then
            options[i] = v
        end
    end
    
    for i, v in pairs(options) do 
        if v.btcperprice > bestcardbtcperprice then 
            bestcardname = i
        end
    end
    
    if bestcardname == "" then 
        pricetarget = bitcointomoney(getbps()) * 2000
        minimumprice = bitcointomoney(getbps()) * 3
        
        for i, v in pairs(mytable.bitcoin) do
            if v.price > minimumprice and v.price < pricetarget then
                options[i] = v
            end
        end
    
        for i, v in pairs(options) do 
            if v.btcperprice > bestcardbtcperprice then 
                bestcardname = i
            end
        end
    end
    
    
    return bestcardname
end


function check()
    local nextcard = calculatenextcard()
    
    if calculatenextcard() == "" then
        return 
    end
    changeinfo("gputarget", "Next GPU Target: "..calculatenextcard(), true)
    buycards(calculatenextcard(), 1)
    
    wait(1)
    for i, v in pairs(game:GetService("Workspace").Buildings[player.Name]:GetChildren()) do 
        if v:FindFirstChild("Cards") then 
            for i2, v2 in pairs(v.Cards:GetChildren()) do
                local canexecute = true
                for i3, v3 in pairs(v2:GetChildren()) do 
                    if v3.ClassName == "Model" then 
                        canexecute = false
                    end
                end
                if canexecute then
                    game:GetService("ReplicatedStorage").Events.PlaceCard:FireServer(nextcard, v2)
                end
            end
        end
    end
end

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

spawn(function()
    while wait(1) do
        sellcrypto("bitcoin")
        pcall(choosebest)
        check()
    end
end)
