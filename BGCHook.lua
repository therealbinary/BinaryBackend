local Player = game.Players.LocalPlayer

GetPetModule = function(pet)
    for _, v in pairs(game:GetService("ReplicatedStorage")["Game Objects"].Pets:GetChildren()) do 
        if v:FindFirstChildWhichIsA("Model").Name == pet then 
            return v:FindFirstChildWhichIsA("ModuleScript")
        end
    end
end

IsShiny = function(pet)
    if pet:FindFirstChild("Inner") then 
        for i = 1, 45 do 
            wait()
            if pet.Inner:FindFirstChild("Shine") then 
                return "SHINY "
            end
        end
    end
    return "NORMAL "
end

getPetThumbnail = function(pet)
    local id = string.split(pet:FindFirstChild("Pet").Icon.Image, "rbxassetid://")[2]

    local req = game:HttpGet('https://thumbnails.roblox.com/v1/assets?assetIds='..id..'&size=420x420&format=png')
    req = game:GetService("HttpService"):JSONDecode(req)
    if req.data then
        return (req.data[1].imageUrl) 
    else
        return nil 
    end
end
formatNumber = (function (n)
	n = tostring(n)
	return n:reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end)
suffixnumber = function(n) 
    if tonumber(n) >= 0 then
        return (Utility.Functions.NumberShorten(tonumber(n)))
    else
        return '-'..(Utility.Functions.NumberShorten(tonumber(n) * -1))
    end
end

task.spawn(function()
    game:GetService("Players").LocalPlayer.PlayerGui.Inventory.Frame.Container.Pets.ChildAdded:Connect(function(v)
        if getgenv()["bgcwareconfiguration"].Configuration.Toggles.WebhookNotifier == true and v:IsA("TextButton") then 
            if v ~= nil then    
                repeat wait() until v:FindFirstChild("TradeTick")
                local PetName = v:FindFirstChild("PetName")
                if not vmahook.IgnorePets[PetName.Text] then 
                    local PetModule = require(GetPetModule(PetName.Text))
                    if not table.find(getgenv().bgcwarecfg.Webhook.IgnoreRarity, PetModule.rarity) then 
                        local OSTime = os.time() 
                        local Time = os.date('!*t', OSTime);
                        local Shiny = IsShiny(v)
                        local Rarity = (v.Secret.Visible and "SECRET" or tostring(PetModule.rarity))
                        local data = {
                            ["content"] = getgenv().bgcwarecfg.Webhook.Content,
                            ["embeds"] = {{
                                ["title"] = "__**acc: "..Player.Name.." | eggs: "..formatNumber(Player.leaderstats.Eggs.Value).."**__",
                                ["description"] = "```Pet Hatched: "..Shiny..Rarity.." "..PetName.Text.."```",
                                ["fields"] = {
                                    {
                                        ["name"] = "🍬 | Gum Stats: ",
                                        ["value"] = "**"..(Shiny == "SHINY " and suffixnumber(PetModule.buffs.Bubbles * 2) or suffixnumber(PetModule.buffs.Bubbles * 1)).."**" ,
                                    },
                                    {
                                        ["name"] = "💰 | Coin Stats: ",
                                        ["value"] = "**"..(Shiny == "SHINY " and suffixnumber(PetModule.buffs.Coins * 2) or suffixnumber(PetModule.buffs.Coins * 1)).."**",
                                    },
                                    {
                                        ["name"] = "💎 | Diamond Stats: ",
                                        ["value"] = "**"..(Shiny == "SHINY " and suffixnumber(PetModule.buffs.Diamonds * 2) or suffixnumber(PetModule.buffs.Diamonds * 1)).."**",
                                    };
                                },
                                ["type"] = "rich",
                                ["color"] = (Shiny == "SHINY " and tonumber(0xFFF700) or Rarity == "SECRET" and tonumber(0x000000) or Rarity == "Godly" and tonumber(0x7400FF) or tonumber(0x00FFF2)),
                                ["thumbnail"] = {url = getPetThumbnail(v)},
                                ["footer"] = {text = "brought to you by bgcware!"},
                                ["timestamp"] = string.format('%d-%d-%dT%02d:%02d:%02dZ', Time.year, Time.month, Time.day, Time.hour, Time.min, Time.sec)
                            }}
                        }
                        local Encoded = game:GetService("HttpService"):JSONEncode(data)
                        local header = {
                            ["content-type"] = "application/json"
                        }
                        ((syn and syn.request) or (http and http.request) or http_request or request) ({
                            Url = bgcwarecfg.WebhookURL,
                            Body = Encoded,
                            Method = "POST",
                            Headers = header
                        })
                    end
                end
            end
        end
    end)
end)
