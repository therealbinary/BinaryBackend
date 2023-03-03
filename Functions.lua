--[[
    Hello there, this function script is made for binary script hub but if 
    you are an developer and want to use this, i won't get in your way, this is 
    not obfuscated so people can use the functions for their projects for free.
    if you don't mind, leave me an credit if you want to use it
]]

local notify = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua", true))() -- notification module

getgenv()._G._binaryfns = {}
local funcenv = getgenv()._G._binaryfns

funcenv.GetLocalPlayer = function()
    return game.Players.LocalPlayer
end

funcenv.GrabCharacter = function(p)
    if (p and p.Character) then 
        return p.Character
    end
end

funcenv.GetDistance = function(p1, p2)
    return (p1.Position - p2.Position).Magnitude
end

funcenv.GetRandomColor = function()
    return Color3.new(math.random(1, 255), math.random(1, 255), math.random(1, 255))
end

funcenv.GetRandomPlayer = function()
    repeat 
        local selectedrdm = game.Players:GetPlayers()[math.random(1, #game.Players:GetPlayers())]
        wait()
    until selectedrdm ~= game.Players.LocalPlayer
    return selectedrdm
end

funcenv.GetHumanoid = function()
    if game.Players.LocalPlayer.Character then 
        return game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    end
end

funcenv.GetClientPing = function()
    return (math.round(tonumber(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString())))
end

funcenv.Teleport = function(pOrPos)
    local Position = (typeof(pOrPos) == "Vector3" and pOrPos or typeof(pOrPos) == "Instance" and pOrPos.Position or typeof(pOrPos) == "CFrame" and pOrPos.Position)
    if game.Players.LocalPlayer.Character then 
        game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(Position)
    end
end

funcenv.GetHWID = function()
    local HardwareID = game:GetService("RbxAnalyticsService"):getClientId()
    if HardwareID ~= nil then 
        return HardwareID
    end
end

funcenv.CheckLabelText = function(label, expected)
    if typeof(label) ~= "Instance" then return nil end 
    if tostring(label.Text) == tostring(expected) then  
        return true 
    end 
    return false
end

funcenv.LinearTween = function(pos, time)
    if game.Players.LocalPlayer.Character and pos and typeof(pos) == "Vector3" then 
        tweenService, tweenInfo = game:GetService("TweenService"), TweenInfo.new(time, Enum.EasingStyle.Linear)
        tween = tweenService:Create(game:GetService("Players")["LocalPlayer"].Character.HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(pos)})
        tween:Play()
        tween.Completed:Wait()
    end
end

funcenv.Notify = function(title, description, time)
    notify.Notify({
        Title = title
        Description = description
        Duration = tonumber(time)
    })
end

return getgenv()._G._binaryfns
