
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


local function Print(tbl, label, deepPrint)

	assert(type(tbl) == "table", "First argument must be a table")
	assert(label == nil or type(label) == "string", "Second argument must be a string or nil")
	
	label = (label or "TABLE")
	
	local strTbl = {}
	local indent = " - "
	
	-- Insert(string, indentLevel)
	local function Insert(s, l)
		strTbl[#strTbl + 1] = (indent:rep(l) .. s .. "\n")
	end
	
	local function AlphaKeySort(a, b)
		return (tostring(a.k) < tostring(b.k))
	end
	
	local function PrintTable(t, lvl, lbl)
		Insert(lbl .. ":", lvl - 1)
		local nonTbls = {}
		local tbls = {}
		local keySpaces = 0
		for k,v in pairs(t) do
			if (type(v) == "table") then
				table.insert(tbls, {k = k, v = v})
			else
				table.insert(nonTbls, {k = k, v = "[" .. typeof(v) .. "] " .. tostring(v)})
			end
			local spaces = #tostring(k) + 1
			if (spaces > keySpaces) then
				keySpaces = spaces
			end
		end
		table.sort(nonTbls, AlphaKeySort)
		table.sort(tbls, AlphaKeySort)
		for _,v in ipairs(nonTbls) do
			Insert(tostring(v.k) .. ":" .. (" "):rep(keySpaces - #tostring(v.k)) .. v.v, lvl)
		end
		if (deepPrint) then
			for _,v in ipairs(tbls) do
				PrintTable(v.v, lvl + 1, tostring(v.k) .. (" "):rep(keySpaces - #tostring(v.k)) .. " [Table]")
			end
		else
			for _,v in ipairs(tbls) do
				Insert(tostring(v.k) .. ":" .. (" "):rep(keySpaces - #tostring(v.k)) .. "[Table]", lvl)
			end
		end
	end
	
	PrintTable(tbl, 1, label)
	
	print(table.concat(strTbl, ""))
	
end

mytable = {bitcoin = {}, solaris = {}}

for i, v in pairs(game:GetService("ReplicatedStorage").Objects:GetChildren()) do 
    if v.Class and v.Class.Value == "Card" and v:FindFirstChild("Limited") == nil then 
        if v:FindFirstChild("bps") then
            if v.Name == "Radon 6000" then 
                proccesnum(tonumber(v.bps.Value) / v.Price.Value, true)
            end
            mytable.bitcoin[v.Name] = {
                price = tonumber(v.Price.Value),
                bps = tonumber(v.bps.Value),
                wattperbtc = proccesnum(v.Engr.Value / v.bps.Value),
                btcperprice = proccesnum(tonumber(v.bps.Value) / tonumber(v.Price.Value))
            }
        end
    end
end

writefile("gpudata.json", game:GetService("HttpService"):JSONEncode(mytable))

Print(mytable, "my table ok", true)
