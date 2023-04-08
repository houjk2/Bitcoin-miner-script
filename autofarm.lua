
local player = game:GetService("Players").LocalPlayer

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

function calculatenextcard()
    local pricetarget = bitcointomoney(getbps()) * 120
    local minimumprice = bitcointomoney(getbps()) * 60
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
    
    return bestcardname
end


function check()
    local nextcard = calculatenextcard()
    
    if calculatenextcard() == nil then
        return 
    end
    print("Buying", nextcard)
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

spawn(function()
    while wait(1) do
        sellcrypto("bitcoin")
        check()
    end
end)
