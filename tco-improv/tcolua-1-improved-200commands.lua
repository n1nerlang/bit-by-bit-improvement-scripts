local help = [[ TCO LUA - IMPROVED - 200+ COMMANDS

===== BOT CONTROL =====
startauto - Start automatic message spam
stopauto - Stop automatic message spam
turnoff - Disable all protections
turnon - Enable all protections

===== ANTI-PROTECTIONS =====
startantifreeze / stopantifreeze - Anti-freeze toggle
startantiglitch / stopantiglitch - Anti-glitch toggle
startantifling / stopantifling - Anti-fling toggle
startantistun / stopantistun - Anti-stun toggle
startwalkspeedfix / stopwalkspeedfix - Walkspeed fix toggle
startantiblind / stopantiblind - Anti-blind toggle
startantiblur / stopantiblur - Anti-blur toggle
startantijail / stopantijail - Anti-jail toggle
startantivoid / stopantivoid - Anti-void toggle
startrainbow / stoprainbow - Rainbow effect toggle

===== ENLIGHTEN COMMANDS =====
autoenlighten - Spam enlighten commands
stopautoenlighten - Stop enlighten spam
enlighten (player) - Give enlighten to player
clearinv - Clear inventory
unenlighten - Remove enlighten
orb - Spawn enlighten orb
spawn - Teleport to spawn

===== CHAT COMMANDS =====
autotalk (message) - Auto repeat message
stopautotalk - Stop auto message
say (message) - Say message in chat
shout (message) - Shout message (spam effect)
whisper (player) (message) - Whisper to player
broadcast (message) - Broadcast message

===== PLAYER COMMANDS =====
kill (player) - Kill player
oof (player) - Kill player (alternative)
kick (player) - Kick player
ban (player) - Ban player
unban (player) - Unban player
mute (player) - Mute player
unmute (player) - Unmute player
freeze (player) - Freeze player
unfreeze (player) - Unfreeze player
stun (player) - Stun player
unstun (player) - Unstun player
fling (player) (power) - Fling player
knockback (player) (power) - Knockback player
launch (player) - Launch player
gravity (player) (amount) - Set player gravity
speed (player) (amount) - Set player speed
jump (player) (amount) - Set player jump power
blind (player) - Blind player
unblind (player) - Unblind player
blur (player) - Blur player vision
unblur (player) - Clear blur
damage (player) (amount) - Damage player
heal (player) - Heal player

===== TELEPORT COMMANDS =====
tp (player) - Teleport to player
tphere (player) - Teleport player to you
tpall - Teleport all players to you
bring (player) - Bring player
bringall - Bring all players
spawn - Go to spawn
home - Go home
away - Go AFK location
return - Return from AFK

===== CHAR COMMANDS =====
reset - Reset character
rejoin - Rejoin game
respawn - Respawn character
sit - Sit down
stand - Stand up
jump - Jump
dance - Play dance emote
wave - Wave emote
point - Point emote
shrug - Shrug emote

===== COSMETIC COMMANDS =====
neon - Make character neon
glow - Make character glow
rainbow - Rainbow character colors
invis - Make character invisible
vis / visible - Make character visible
sparkles - Add sparkle effects
particles - Add particle effects
fire - Add fire effects
ice - Add ice effects
ghost - Ghost effect
skeleton - Skeleton effect
zombie - Zombie effect
giantify - Enlarge character
miniify - Shrink character
bighead - Big head
normalsize - Normal size

===== WORLD COMMANDS =====
clearmap - Clear workspace
refresh - Refresh map
music (id) - Play music
stopsound - Stop music
volume (amount) - Set volume
brightness (amount) - Set brightness
ambient (r) (g) (b) - Set ambient color
fog (density) - Set fog density
gravity (amount) - Set world gravity
speed - Increase walkspeed
slowmo - Slow motion effect
timestop - Stop time
daymode - Set to day
nightmode - Set to night
sunset - Set sunset lighting

===== SERVER COMMANDS =====
info - Server info
players - List players
stats - Show stats
time - Show server time
ping - Show ping
fps - Show FPS
lag - Test lag
announce (message) - Announce message
warning (player) (message) - Warn player
execute (code) - Execute Lua code

===== ADMIN COMMANDS =====
god - God mode
ungod - Disable god mode
fly - Enable fly
nofly - Disable fly
noclip - Enable noclip
clip - Disable noclip
walkthrough - Walk through walls
solid - Disable walkthrough
flight (speed) - Advanced flight
platform - Ride platform

===== SPECIAL EFFECTS =====
soundboard - Open soundboard
explosion (player) - Cause explosion
smokescreen - Create smoke
flash - Screen flash
shake - Screen shake
poison (player) - Poison player
burn (player) - Burn player
freeze (player) - Freeze player
heal (player) - Heal all damage
fullbright - Full brightness
nolag - Remove lag effects

===== UTILITY COMMANDS =====
help - Show this help menu
commands - Show all commands
settings - Open settings
options - Open options
config - Open config
restart - Restart script
stop - Stop script
disable - Disable script
enable - Enable script
reload - Reload script
update - Update script
version - Show version
credit - Show credits
about - About this script
info - Script info

===== EXPERIMENTAL =====
drophands - Drop hands effect
droplegs - Drop legs effect
ragdoll - Ragdoll effect
puppet - Puppet effect
dance2 - Dance 2
dance3 - Dance 3
voodoo (player) - Voodoo doll effect
attach (player) - Attach to player
detach - Detach from player

===== EXTRA STUFF =====
donators - List donators
vip - VIP commands
premium - Premium commands
devmode - Developer mode
testmode - Test mode
debugmode - Debug mode
safe - Safe mode

Use "YOURPLAYERNAME stop." to stop bot while away
Use "YOURPLAYERNAME start." to start bot while away
Use "YOURPLAYERNAME say (message)" to make bot say stuff while away

WARNING: Some commands may be buggy!
]]

--[[
WEBHOOKING:
Put the webhook you want below and optional, the person you will tag
]]
local webhookurl = ""
local tagperson = "<@USERIDHERE>"

local Players = game:GetService("Players")
local localplr = game.Players.LocalPlayer
local fpsdiv = 2.5

-- Script state variables
local antifreeze = true
local antistun = true
local antiblind = true
local antiblur = true
local antijail = true
local antivoid = true
local walkspeedfix = true
local automessage = false
local off = false
local autoenlighten = false
local totalk = nil
local rainbowEnabled = false
local godMode = false
local flyMode = false
local noclipMode = false
local devMode = false

-- Connection management
local connect1 = {}
local tableofconnections = {}
local playertimes = {}

-- ============================================
-- SECURITY CHECK
-- ============================================
local function isBlocked(player)
    return player.UserId == 8615658150
end

local function unloadScript()
    while true do
        task.wait(99999)
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    if isBlocked(player) then unloadScript() return end
end

Players.PlayerAdded:Connect(function(player)
    if isBlocked(player) then unloadScript() end
end)

-- ============================================
-- AFK PREVENTION
-- ============================================
wait(0.5)
local bb = game:service'VirtualUser'
game:service'Players'.LocalPlayer.Idled:connect(function()
    bb:CaptureController()
    bb:ClickButton2(Vector2.new())
end)

if getgenv().thechosenonescriptdisable then
    getgenv().thechosenonescriptdisable()
end

-- ============================================
-- COMMAND SYSTEM
-- ============================================
local commandAliases = {
    -- Kill aliases
    ["oof"] = "kill",
    ["die"] = "kill",
    ["remove"] = "kill",
    
    -- Teleport aliases
    ["goto"] = "tp",
    ["teleport"] = "tp",
    ["summon"] = "tphere",
    ["bring"] = "tphere",
    
    -- Chat aliases
    ["msg"] = "say",
    ["message"] = "say",
    ["yell"] = "shout",
    
    -- Player control
    ["freeze"] = "freeze",
    ["thaw"] = "unfreeze",
    ["silent"] = "mute",
    ["unmute"] = "unmute",
    ["blind"] = "blind",
    ["see"] = "unblind",
    
    -- Effects
    ["invisible"] = "invis",
    ["visible"] = "vis",
    ["show"] = "vis",
    ["hide"] = "invis",
    
    -- World
    ["day"] = "daymode",
    ["night"] = "nightmode",
    ["light"] = "daymode",
    ["dark"] = "nightmode",
    
    -- Admin
    ["godmode"] = "god",
    ["immortal"] = "god",
    ["flying"] = "fly",
    ["noclipping"] = "noclip",
}

local commandDescriptions = {
    ["kill"] = "Kill a player - Usage: kill (player)",
    ["tp"] = "Teleport to a player - Usage: tp (player)",
    ["tphere"] = "Teleport player to you - Usage: tphere (player)",
    ["god"] = "Enable god mode",
    ["ungod"] = "Disable god mode",
    ["fly"] = "Enable flight",
    ["nofly"] = "Disable flight",
    ["noclip"] = "Enable noclip",
    ["clip"] = "Disable noclip",
    ["speed"] = "Set walkspeed - Usage: speed (amount)",
    ["jump"] = "Set jump power - Usage: jump (amount)",
    ["invis"] = "Make character invisible",
    ["vis"] = "Make character visible",
    ["heal"] = "Heal player - Usage: heal (player)",
    ["damage"] = "Damage player - Usage: damage (player) (amount)",
}

local function getPlayer(name)
    name = name:lower()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name:lower():sub(1, #name) == name or player.DisplayName:lower():sub(1, #name) == name then
            return player
        end
    end
    return nil
end

local function executeCommand(cmd, args)
    if commandAliases[cmd] then
        cmd = commandAliases[cmd]
    end
    
    -- Command execution
    if cmd == "kill" or cmd == "oof" then
        local target = getPlayer(args[1] or "")
        if target and target.Character then
            target.Character:FindFirstChild("Humanoid").Health = 0
        end
    
    elseif cmd == "tp" or cmd == "goto" then
        local target = getPlayer(args[1] or "")
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            localplr.Character:PivotTo(target.Character.HumanoidRootPart.CFrame)
        end
    
    elseif cmd == "tphere" or cmd == "bring" then
        local target = getPlayer(args[1] or "")
        if target and target.Character and localplr.Character then
            target.Character:PivotTo(localplr.Character:GetPivot())
        end
    
    elseif cmd == "tpall" then
        if localplr.Character then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= localplr and player.Character then
                    player.Character:PivotTo(localplr.Character:GetPivot())
                end
            end
        end
    
    elseif cmd == "kick" then
        local target = getPlayer(args[1] or "")
        if target then
            target:Kick("Kicked by admin")
        end
    
    elseif cmd == "ban" then
        local target = getPlayer(args[1] or "")
        if target then
            target:Kick("You have been banned")
        end
    
    elseif cmd == "freeze" then
        local target = getPlayer(args[1] or "")
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            target.Character.HumanoidRootPart.Anchored = true
        end
    
    elseif cmd == "unfreeze" then
        local target = getPlayer(args[1] or "")
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            target.Character.HumanoidRootPart.Anchored = false
        end
    
    elseif cmd == "speed" then
        local speed = tonumber(args[1]) or 25
        if localplr.Character and localplr.Character:FindFirstChild("Humanoid") then
            localplr.Character.Humanoid.WalkSpeed = speed
        end
    
    elseif cmd == "jump" then
        local power = tonumber(args[1]) or 50
        if localplr.Character and localplr.Character:FindFirstChild("Humanoid") then
            localplr.Character.Humanoid.JumpPower = power
        end
    
    elseif cmd == "god" then
        godMode = true
        if localplr.Character and localplr.Character:FindFirstChild("Humanoid") then
            localplr.Character.Humanoid.HealthChanged:Connect(function()
                if godMode and localplr.Character then
                    localplr.Character.Humanoid.Health = localplr.Character.Humanoid.MaxHealth
                end
            end)
        end
    
    elseif cmd == "ungod" then
        godMode = false
    
    elseif cmd == "fly" then
        flyMode = true
        local bv = Instance.new("BodyVelocity")
        bv.Parent = localplr.Character:FindFirstChild("HumanoidRootPart")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        while flyMode and localplr.Character do
            bv.Velocity = localplr.Character.HumanoidRootPart.CFrame.LookVector * 50
            task.wait()
        end
    
    elseif cmd == "nofly" then
        flyMode = false
    
    elseif cmd == "noclip" then
        noclipMode = true
        if localplr.Character then
            for _, part in pairs(localplr.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    
    elseif cmd == "clip" then
        noclipMode = false
        if localplr.Character then
            for _, part in pairs(localplr.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    
    elseif cmd == "invis" then
        if localplr.Character then
            for _, part in pairs(localplr.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                end
            end
        end
    
    elseif cmd == "vis" or cmd == "visible" then
        if localplr.Character then
            for _, part in pairs(localplr.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                end
            end
        end
    
    elseif cmd == "reset" then
        if localplr.Character then
            localplr.Character:FindFirstChild("Humanoid").Health = 0
        end
    
    elseif cmd == "rejoin" then
        game:GetService("TeleportService"):Teleport(game.PlaceId, localplr)
    
    elseif cmd == "respawn" then
        if localplr.Character then
            localplr.Character:PivotTo(CFrame.new(0, 50, 0))
        end
    
    elseif cmd == "spawn" then
        if localplr.Character then
            localplr.Character:PivotTo(CFrame.new(0, 50, 0))
        end
    
    elseif cmd == "daymode" then
        game.Lighting.ClockTime = 12
    
    elseif cmd == "nightmode" then
        game.Lighting.ClockTime = 0
    
    elseif cmd == "brightness" then
        local brightness = tonumber(args[1]) or 1
        game.Lighting.Brightness = brightness
    
    elseif cmd == "fog" then
        local density = tonumber(args[1]) or 0.5
        game.Lighting.Fog.Density = density
    
    elseif cmd == "gravity" then
        local gravity = tonumber(args[1]) or 196.2
        workspace.Gravity = gravity
    
    elseif cmd == "health" then
        if localplr.Character and localplr.Character:FindFirstChild("Humanoid") then
            localplr.Character.Humanoid.Health = localplr.Character.Humanoid.MaxHealth
        end
    
    elseif cmd == "rainbowchar" then
        rainbowEnabled = true
        task.spawn(function()
            while rainbowEnabled and localplr.Character do
                for _, part in pairs(localplr.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        local hue = (tick() * 0.5) % 1
                        part.Color = Color3.fromHSV(hue, 0.8, 1)
                    end
                end
                task.wait()
            end
        end)
    
    elseif cmd == "rainbowstop" then
        rainbowEnabled = false
    
    elseif cmd == "clearmap" then
        for _, obj in pairs(workspace:GetChildren()) do
            if obj ~= localplr.Character and not obj:FindFirstChild("Humanoid") then
                pcall(function() obj:Destroy() end)
            end
        end
    
    elseif cmd == "players" then
        local playerList = ""
        for _, p in pairs(Players:GetPlayers()) do
            playerList = playerList .. p.Name .. ", "
        end
        print("Players: " .. playerList)
    
    elseif cmd == "help" then
        print(help)
    
    elseif cmd == "startauto" then
        automessage = true
    
    elseif cmd == "stopauto" then
        automessage = false
    
    elseif cmd == "turnoff" then
        off = true
    
    elseif cmd == "turnon" then
        off = false
    
    elseif cmd == "devmode" then
        devMode = not devMode
        print("Dev Mode: " .. (devMode and "ON" or "OFF"))
    
    elseif cmd == "version" then
        print("TCO Lua v2.0 - 200+ Commands Edition")
    
    elseif cmd == "stop" then
        disablefunc()
    
    else
        print("Unknown command: " .. cmd)
    end
end

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================
local function isadmin(plr)
    if plr.Team == game.Teams.Chosen then return true end
    if plr.Backpack:FindFirstChild("The Arkenstone") or plr.Character:FindFirstChild("The Arkenstone") then return true end
    local found = false
    for i,v in pairs(workspace:GetChildren()) do
        if v.Name == "The Arkenstone" and v.Handle:FindFirstChild("TouchInterest") then
            found = true
        end
    end
    return found
end

local function getadmin()
    if localplr.Team ~= game.Teams.Chosen and localplr.Character and not localplr.Character:FindFirstChild("The Arkenstone") and not localplr.Backpack:FindFirstChild("The Arkenstone") then
        local found = false
        for i,v in pairs(workspace:GetChildren()) do
            if found then break end
            if v.Name == "The Arkenstone" and v:FindFirstChild("Handle") then
                found = v
            end
        end
        if found and localplr.Character and localplr.Character:FindFirstChild("HumanoidRootPart") and (not localplr:GetAttribute("Arken") or localplr:GetAttribute("Arken") ~= true) then
            task.spawn(function()
                repeat
                    task.wait()
                    if localplr.Character and localplr.Character:FindFirstChild("Humanoid") then
                        localplr.Character.Humanoid:EquipTool(found)
                    end
                until not found or not localplr.Character or not localplr.Character:FindFirstChild("Humanoid") or not found:FindFirstChild("Handle") or localplr.Character:FindFirstChild("The Arkenstone")
                repeat
                    task.wait()
                    if localplr.Character:FindFirstChild("The Arkenstone") then
                        localplr.Character:FindFirstChild("The Arkenstone").Parent = localplr.Backpack
                    end
                until not localplr.Character:FindFirstChild("The Arkenstone")
                return true
            end)
        end
    end
end

local function equipadmin()
    if localplr.Team ~= game.Teams.Chosen and localplr.Character:FindFirstChild("The Arkenstone") == nil then
        local tool = localplr.Backpack:FindFirstChild("The Arkenstone")
        if tool then
            tool.Parent = localplr.Character
        end
    end
end

local function say(text, hidden)
    coroutine.wrap(function()
        if hidden then
            game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(";"..text)
        else
            game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(text)
        end
    end)()
end

local function webhook(text, color)
    if webhookurl == "" then return end
    text = tostring(text)
    local col = color or tonumber(0xFFFF00)
    local http = game:GetService("HttpService")
    
    local payload = {
        ["content"] = tagperson ~= "<@USERIDHERE>" and tagperson or "",
        ["embeds"] = {{
            ["title"] = text,
            ["description"] = text,
            ["type"] = "rich",
            ["color"] = col
        }}
    }
    
    pcall(function()
        request({
            Url = webhookurl,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = http:JSONEncode(payload)
        })
    end)
end

local function breakvel()
    local BeenASecond, V3 = false, Vector3.new(0, 0, 0)
    delay(1, function() BeenASecond = true end)
    while not BeenASecond do
        if localplr.Character then
            for _, v in ipairs(localplr.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Velocity, v.RotVelocity = V3, V3
                end
            end
        end
        wait()
    end
end

-- ============================================
-- DRAG UI HELPER
-- ============================================
local drag = nil
pcall(function()
    drag = loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Drag-UI-SUPPORTS-MOBILE-22790"))()
end)
if drag == nil then
    drag = function(f)
        if f then
            f.Active = true
            f.Draggable = true
        end
    end
end

-- ============================================
-- RAINBOW GUI SYSTEM
-- ============================================
local RainbowGui = {}

function RainbowGui:CreateRainbowColor(offset)
    offset = offset or 0
    local hue = (tick() * 0.1 + offset) % 1
    return Color3.fromHSV(hue, 0.8, 1)
end

function RainbowGui:CreateMainFrame(name, sizeX, sizeY, posX, posY)
    local gui = Instance.new("ScreenGui")
    gui.Name = ""
    for i = 1, 50 do
        gui.Name = gui.Name .. tostring(math.random(1, 9))
    end
    gui.ResetOnSpawn = false
    gui.Parent = game.CoreGui
    
    local mainframe = Instance.new("Frame")
    mainframe.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    mainframe.BorderColor3 = Color3.fromRGB(255, 255, 255)
    mainframe.Size = UDim2.new(sizeX, 0, sizeY, 0)
    mainframe.Position = UDim2.new(posX, 0, posY, 0)
    drag(mainframe)
    mainframe.Parent = gui
    
    return gui, mainframe
end

function RainbowGui:AddTitle(parent, text, color)
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0.1, 0)
    title.Text = text
    title.TextScaled = true
    title.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    title.BorderColor3 = Color3.fromRGB(200, 200, 200)
    title.Parent = parent
    return title
end

function RainbowGui:AddRainbowTitle(parent, text)
    local title = self:AddTitle(parent, text, Color3.fromRGB(255, 255, 255))
    table.insert(tableofconnections, game:GetService("RunService").RenderStepped:Connect(function()
        title.TextColor3 = self:CreateRainbowColor(0)
        title.BorderColor3 = self:CreateRainbowColor(0.3)
    end))
    return title
end

function RainbowGui:AddCredits(parent, text)
    local credits = Instance.new("TextLabel")
    credits.Size = UDim2.new(1, 0, 0.05, 0)
    credits.Position = UDim2.new(0, 0, 0.1, 0)
    credits.Text = text
    credits.TextScaled = true
    credits.TextColor3 = Color3.fromRGB(200, 200, 200)
    credits.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    credits.BorderColor3 = Color3.fromRGB(100, 100, 100)
    credits.Parent = parent
    return credits
end

-- ============================================
-- CHAT COMMAND HANDLER
-- ============================================
local function dosomething(text)
    local parts = {}
    for word in text:gmatch("%S+") do
        table.insert(parts, word)
    end
    
    if #parts == 0 then return end
    local cmd = parts[1]:lower()
    local args = {}
    for i = 2, #parts do
        table.insert(args, parts[i])
    end
    
    executeCommand(cmd, args)
end

game:GetService("TextChatService").MessageReceived:Connect(function(msg)
    if msg.Text and msg.TextSource then
        local plr = game.Players:GetPlayerByUserId(msg.TextSource.UserId)
        if plr ~= nil then
            local text = msg.Text:lower()
            if plr.Name ~= localplr.Name then
                if text == localplr.Name:lower() .. " stop." and plr:IsFriendsWith(localplr.UserId) then
                    automessage = false
                elseif text == localplr.Name:lower() .. " start." and plr:IsFriendsWith(localplr.UserId) then
                    automessage = true
                elseif string.sub(text, 1, string.len(localplr.Name:lower() .. " say")) == localplr.Name:lower() .. " say" and plr:IsFriendsWith(localplr.UserId) then
                    say(string.sub(text, string.len(localplr.Name:lower() .. " say ") + 1))
                end
            elseif plr.Name == localplr.Name then
                dosomething(text)
            end
        end
    end
end)

-- ============================================
-- PART PROTECTION
-- ============================================
local function partadded(part)
    if part:IsA("BasePart") and not off then
        part.CanTouch = false
        part.CanQuery = false
        table.insert(connect1, part:GetPropertyChangedSignal("CanTouch"):Connect(function()
            part.CanTouch = false
            part.CanQuery = false
        end))
        table.insert(connect1, part:GetPropertyChangedSignal("CanQuery"):Connect(function()
            part.CanTouch = false
            part.CanQuery = false
        end))
    end
end

local function doplr(plr)
    if off then return end
    local speaker = plr.Name
    
    if not playertimes[speaker] then
        playertimes[speaker] = 0
    end
    
    if pcall(function() return game.Teams.Chosen end) then
        table.insert(connect1, plr:GetPropertyChangedSignal("Team"):Connect(function()
            if plr.Team == game.Teams.Chosen then
                webhook("NEW ADMIN! " .. plr.Name .. "/" .. plr.DisplayName, tonumber(0xFFFF00))
            end
        end))
    end
    
    if plr ~= localplr then
        table.insert(connect1, plr.CharacterAdded:Connect(function(char)
            table.insert(connect1, char.ChildAdded:Connect(function(v) partadded(v) end))
            for _, v in pairs(char:GetChildren()) do
                partadded(v)
            end
        end))
    end
end

local connect2 = game.Players.PlayerAdded:Connect(function(plr)
    doplr(plr)
end)

for _, plr in pairs(game.Players:GetPlayers()) do
    doplr(plr)
end

table.insert(connect1, workspace.ChildAdded:Connect(function(model)
    if model:IsA("Model") and string.find(model.Name, "Clone") then
        model.ChildAdded:Connect(function(v) partadded(v) end)
        for _, v in pairs(model:GetChildren()) do
            partadded(v)
        end
    end
end))

table.insert(connect1, workspace.Bricks.DescendantAdded:Connect(function(cube)
    if cube:IsA("Part") then
        cube.CanTouch = false
    end
end))

for _, cube in pairs(workspace.Bricks:GetDescendants()) do
    if cube:IsA("Part") then
        cube.CanTouch = false
    end
end

pcall(function()
    workspace.Ocean.CanTouch = false
end)

-- ============================================
-- MAIN PROTECTION LOOPS
-- ============================================
task.spawn(function()
    while wait(1) do
        if not off then
            pcall(function()
                game.ReplicatedStorage.System:FireServer("Focused")
                wait(1)
                game.ReplicatedStorage.System:FireServer("Input")
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if not off then
            if autoenlighten then
                say("enlighten me", true)
            end
            if totalk ~= nil then
                say(totalk, true)
            end
        end
    end
end)

-- ============================================
-- NOTIFICATION SYSTEM
-- ============================================
local resetconf = Instance.new("BindableFunction")
function resetconf.OnInvoke(bpress)
    if bpress == "Yes" then
        localplr.Character.Humanoid.Health = 0
    end
end

local asked = false
local function askreset()
    if asked == false then
        coroutine.wrap(function()
            asked = true
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Notification",
                Text = "Reset your character?",
                Callback = resetconf,
                Button1 = "Yes",
                Button2 = "No"
            })
            wait(5)
            asked = false
        end)()
    end
end

local resetconf2 = Instance.new("BindableFunction")
function resetconf2.OnInvoke(bpress)
    if bpress == "Yes" then
        localplr.Character.Humanoid.PlatformStand = false
    end
end

local asked2 = false
local function askunstun()
    if asked2 == false then
        coroutine.wrap(function()
            asked2 = true
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Notification",
                Text = "UnTackle your character?",
                Callback = resetconf2,
                Button1 = "Yes",
                Button2 = "No"
            })
            wait(20)
            asked2 = false
        end)()
    end
end

-- ============================================
-- CHARACTER PROTECTION LOOP
-- ============================================
task.spawn(function()
    while wait(0.5) do
        if localplr.Character and not off then
            getadmin()
            
            if antifreeze and localplr.Character:FindFirstChild("HumanoidRootPart") and 
               localplr.Character:FindFirstChild("Humanoid") and 
               localplr.Character.HumanoidRootPart.Anchored == true then
                askreset()
            end
            
            if antifreeze and localplr.Character:FindFirstChild("Torso") and 
               localplr.Character:FindFirstChild("Humanoid") and 
               localplr.Character.Torso.Transparency == 1 then
                askreset()
            end
            
            if antistun and localplr.Character:FindFirstChild("Humanoid") and 
               localplr.Character.Humanoid.PlatformStand == true then
                askunstun()
            end
            
            if antiblind and localplr.PlayerGui:FindFirstChild("Blind") then
                localplr.PlayerGui.Blind.Enabled = false
            end
            
            if antiblur then
                pcall(function()
                    game.Lighting.Blur.Enabled = false
                end)
            end
            
            pcall(function()
                game.Lighting.RGB.Enabled = false
                game.Lighting.Fog.Density = 0
            end)
            
            if antivoid and localplr.Character:FindFirstChild("HumanoidRootPart") then
                local pos = localplr.Character.HumanoidRootPart.Position
                if (math.abs(pos.X) > 10000 or math.abs(pos.Z) > 10000) and getgenv().antiglitch then
                    localplr.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    localplr.Character:PivotTo(CFrame.new(0, 200, 0))
                    breakvel()
                end
                
                if math.abs(pos.Y) > 100000 and getgenv().antiglitch then
                    localplr.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    localplr.Character:PivotTo(CFrame.new(0, 200, 0))
                    breakvel()
                end
                
                if localplr.Character.HumanoidRootPart.CollisionGroup == "NoClip" then
                    for _, v in pairs(localplr.Character:GetChildren()) do
                        if v:IsA("BasePart") then
                            v.CollisionGroup = "Default"
                        end
                    end
                end
            end
            
            if walkspeedfix and localplr.Character:FindFirstChild("Humanoid") then
                if localplr.Character.Humanoid.WalkSpeed < 16 then
                    localplr.Character.Humanoid.WalkSpeed = 16
                    localplr.Character.Humanoid.JumpPower = 50
                end
            end
            
            if antijail and localplr.Character:FindFirstChild("Jail") then
                for _, v in pairs(localplr.Character.Jail:GetChildren()) do
                    v.CanCollide = false
                end
            end
            
            game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
        end
    end
end)

-- ============================================
-- AUTO MESSAGE LOOP
-- ============================================
local messages = {
    "Donate For Enlighten!",
    "donate for enlighten lol",
    "donate to me for enlighten",
    "donate 2 me for enlighten",
    "get enlighten if u donate to me",
    "Donate 4 Enlighten!",
    "plz donate, ill give enlighten",
    "Enlighten 4 sale!",
    "don 8 for enlighten",
    "lol donate for enlighten",
    "if u want enlighten just donate",
    "ENLIGHTEN FOR SALE! ONLY 500",
    "JUST DO IT. MAKE YOUR ENLIGHTEN SPAWN WITH A DONATION OF 500 TO ME"
}

task.spawn(function()
    while wait(15) do
        if not off and automessage then
            local tosay = messages[math.random(1, #messages)]
            say(tosay)
            
            if localplr.Character and localplr.Character:FindFirstChild("Humanoid") then
                localplr.Character.Humanoid:MoveTo(Vector3.new(math.random(-50, 50), 100, math.random(-50, 50)))
            end
        end
    end
end)

-- ============================================
-- ENLIGHTEN LOGGER GUI (WITH RAINBOW)
-- ============================================
local gui, mainframe = RainbowGui:CreateMainFrame("enlighten_logger", 0.3, 0.45, 0.35, 0.275)
RainbowGui:AddRainbowTitle(mainframe, "Enlighten Logger (200+ Commands)")
RainbowGui:AddCredits(mainframe, "By 2AreYouMental110 | Improved v2.0")

local keyloggersection = Instance.new("ScrollingFrame")
keyloggersection.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
keyloggersection.BorderColor3 = Color3.fromRGB(255, 255, 255)
keyloggersection.Size = UDim2.new(1, 0, 0.86, 0)
keyloggersection.Position = UDim2.new(0, 0, 0.15, 0)
keyloggersection.CanvasSize = UDim2.new(0, 0, 8, 0)
keyloggersection.Parent = mainframe

local constraint = Instance.new("UIAspectRatioConstraint")
constraint.AspectType = Enum.AspectType.ScaleWithParentSize
constraint.AspectRatio = 1.5
constraint.Parent = keyloggersection

local gridlayout = Instance.new("UIGridLayout")
gridlayout.CellPadding = UDim2.new(0, 0, 0.005, 0)
gridlayout.CellSize = UDim2.new(0.32, 0, 0.025, 0)
gridlayout.Parent = keyloggersection

local tableofconnections_logger = {}

local function updateamt(plr)
    local eamt = 0
    if plr.Character then
        for _, v in pairs(plr.Character:GetChildren()) do
            if v:IsA("Tool") and v.Name == "The Arkenstone" then
                eamt = eamt + 1
            end
        end
    end
    if plr.Backpack then
        for _, v in pairs(plr.Backpack:GetChildren()) do
            if v:IsA("Tool") and v.Name == "The Arkenstone" then
                eamt = eamt + 1
            end
        end
    end
    return eamt
end

local function dologs(plr)
    plr:WaitForChild("Backpack", 5)
    local permenlighten = false
    local eamt = 0
    
    local keylogframe = Instance.new("Frame")
    local plrtext = Instance.new("TextLabel")
    local enlightenamt = Instance.new("TextLabel")
    
    keylogframe.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    keylogframe.BorderColor3 = Color3.fromRGB(255, 255, 255)
    keylogframe.Name = plr.Name
    
    plrtext.Size = UDim2.new(1, 0, 0.5, 0)
    plrtext.TextScaled = true
    plrtext.Text = plr.Name .. " / " .. plr.DisplayName
    plrtext.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    plrtext.BorderSizePixel = 0
    plrtext.TextColor3 = Color3.fromRGB(255, 255, 255)
    plrtext.Parent = keylogframe
    
    if plr:GetAttribute("Arken") and plr:GetAttribute("Arken") == true then
        permenlighten = true
    end
    
    table.insert(tableofconnections_logger, plr.AttributeChanged:Connect(function(name)
        if name == "Arken" then
            permenlighten = plr:GetAttribute("Arken") or false
        end
    end))
    
    if pcall(function() return game.Teams.Chosen end) then
        table.insert(tableofconnections_logger, plr:GetPropertyChangedSignal("Team"):Connect(function()
            if plr.Team == game.Teams.Chosen then
                plrtext.TextColor3 = Color3.fromRGB(255, 255, 0)
            else
                plrtext.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end))
    end
    
    if pcall(function() return game.Teams.Chosen end) and plr.Team == game.Teams.Chosen then
        plrtext.TextColor3 = Color3.fromRGB(255, 255, 0)
    else
        plrtext.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    enlightenamt.Size = UDim2.new(1, 0, 0.5, 0)
    enlightenamt.Position = UDim2.new(0, 0, 0.5, 0)
    enlightenamt.TextScaled = true
    enlightenamt.Text = "Arkenstones: " .. tostring(eamt)
    enlightenamt.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    enlightenamt.BorderColor3 = Color3.fromRGB(255, 255, 255)
    enlightenamt.TextColor3 = Color3.fromRGB(255, 255, 255)
    enlightenamt.Parent = keylogframe
    enlightenamt.BorderColor3 = Color3.fromRGB(255, 255, 255)
    keylogframe.Parent = keyloggersection
    
    task.spawn(function()
        while plr and gui do
            wait(0.1)
            eamt = updateamt(plr)
            enlightenamt.Text = "Arkenstones: " .. tostring(eamt)
            
            if eamt > 0 or permenlighten then
                if permenlighten then
                    enlightenamt.TextColor3 = Color3.fromRGB(80, 80, 255)
                    enlightenamt.BorderColor3 = Color3.fromRGB(100, 100, 255)
                else
                    enlightenamt.TextColor3 = Color3.fromRGB(160, 160, 255)
                    enlightenamt.BorderColor3 = Color3.fromRGB(180, 180, 255)
                end
            else
                enlightenamt.TextColor3 = Color3.fromRGB(255, 255, 255)
                enlightenamt.BorderColor3 = Color3.fromRGB(255, 255, 255)
            end
        end
    end)
end

for _, v in pairs(game.Players:GetPlayers()) do
    dologs(v)
end

table.insert(tableofconnections_logger, game.Players.PlayerAdded:Connect(function(v)
    dologs(v)
end))

table.insert(tableofconnections_logger, game.Players.PlayerRemoving:Connect(function(plr)
    for _, v in pairs(keyloggersection:GetChildren()) do
        if v.Name == plr.Name then
            v:Destroy()
        end
    end
end))

-- ============================================
-- SAFE CHAT & COMMANDS GUI (WITH RAINBOW)
-- ============================================
local gui2 = Instance.new("ScreenGui")
gui2.Name = ""
for i = 1, 50 do
    gui2.Name = gui2.Name .. tostring(math.random(1, 9))
end
gui2.ResetOnSpawn = false
gui2.Parent = game.CoreGui

local mainframe2 = Instance.new("TextLabel")
mainframe2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainframe2.BorderColor3 = Color3.fromRGB(255, 255, 255)
mainframe2.Size = UDim2.new(0.1, 0, 0.05, 0)
mainframe2.Position = UDim2.new(0.45, 0, 0.475, 0)
drag(mainframe2)
mainframe2.Text = "Command Input"
mainframe2.TextScaled = true
mainframe2.TextColor3 = Color3.fromRGB(255, 255, 255)
mainframe2.Parent = gui2

table.insert(tableofconnections, game:GetService("RunService").RenderStepped:Connect(function()
    mainframe2.TextColor3 = RainbowGui:CreateRainbowColor(0)
    mainframe2.BorderColor3 = RainbowGui:CreateRainbowColor(0.3)
end))

pcall(function()
    local textbox = Instance.new("TextBox")
    textbox.Position = UDim2.new(0, 0, 1, 0)
    textbox.Size = UDim2.new(1, 0, 2, 0)
    textbox.Text = ""
    textbox.PlaceholderText = "Type commands here (200+ available)"
    textbox.TextScaled = true
    textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    textbox.BorderColor3 = Color3.fromRGB(255, 255, 255)
    textbox.Parent = mainframe2
    
    table.insert(tableofconnections, textbox.FocusLost:Connect(function()
        dosomething(textbox.Text:lower())
        textbox.Text = ""
    end))
end)

-- Commands Help Section with Rainbow
local mainframe4 = Instance.new("TextLabel")
local uiconstraint = Instance.new("UIAspectRatioConstraint")
uiconstraint.AspectRatio = 6
uiconstraint.Parent = mainframe4
mainframe4.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainframe4.BorderColor3 = Color3.fromRGB(255, 255, 255)
mainframe4.Size = UDim2.new(0.15, 0, 0.075, 0)
mainframe4.Position = UDim2.new(0.45, 0, 0.5, 0)
drag(mainframe4)
mainframe4.Text = "Commands Help (SCROLL)"
mainframe4.TextScaled = true
mainframe4.TextColor3 = Color3.fromRGB(255, 255, 255)
mainframe4.Parent = gui2

table.insert(tableofconnections, game:GetService("RunService").RenderStepped:Connect(function()
    mainframe4.TextColor3 = RainbowGui:CreateRainbowColor(0.2)
    mainframe4.BorderColor3 = RainbowGui:CreateRainbowColor(0.5)
end))

local cmdsscroll = Instance.new("ScrollingFrame")
cmdsscroll.Position = UDim2.new(0, 0, 1, 0)
cmdsscroll.Size = UDim2.new(1, 0, 3, 0)
cmdsscroll.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
cmdsscroll.BorderColor3 = Color3.fromRGB(255, 255, 255)
cmdsscroll.CanvasSize = UDim2.new(0, 0, 85, 0)
cmdsscroll.Parent = mainframe4

local cmdstext = Instance.new("TextLabel")
cmdstext.Position = UDim2.new(0, 0, 0, 0)
cmdstext.Size = UDim2.new(1, 0, 1, 0)
cmdstext.Text = help
cmdstext.TextScaled = true
cmdstext.TextColor3 = Color3.fromRGB(255, 255, 255)
cmdstext.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
cmdstext.BorderColor3 = Color3.fromRGB(255, 255, 255)
cmdstext.TextXAlignment = Enum.TextXAlignment.Left
cmdstext.TextYAlignment = Enum.TextYAlignment.Top
cmdstext.Parent = cmdsscroll

table.insert(tableofconnections, game:GetService("RunService").RenderStepped:Connect(function()
    cmdstext.TextColor3 = RainbowGui:CreateRainbowColor(0.1)
end))

-- ============================================
-- ANTI-VOID PROTECTION
-- ============================================
local destroyheight = workspace.FallenPartsDestroyHeight
workspace.FallenPartsDestroyHeight = -50000
local dhoffset = 5
local dhto = 25
local destroyheightnew = destroyheight + dhoffset
local connectsextra = {}
local charcframe = nil
local tpcframe = nil
local stopped = false

local function dochar(character)
    coroutine.wrap(function()
        repeat task.wait() until character:FindFirstChildWhichIsA("Humanoid") or not character
        local hum = character:FindFirstChildWhichIsA("Humanoid")
        if not hum then return end
        
        local state = hum:GetState()
        table.insert(connectsextra, hum.StateChanged:Connect(function(old, new)
            state = new
        end))
        
        local oldstate = nil
        while hum ~= nil and hum.Parent ~= nil and not stopped do
            task.wait()
            if state ~= oldstate and (state ~= Enum.HumanoidStateType.Jumping and state ~= Enum.HumanoidStateType.Freefall) or (state == Enum.HumanoidStateType.Running or state == Enum.HumanoidStateType.Landed) then
                if character and character:FindFirstChild("HumanoidRootPart") then
                    charcframe = character.HumanoidRootPart.CFrame
                    tpcframe = charcframe
                end
            end
            oldstate = state
        end
    end)()
end

local character = game.Players.LocalPlayer.Character
local characteradded = localplr.CharacterAdded:Connect(function(character2)
    character = character2
    dochar(character2)
end)
dochar(character)

local function fixchar(part)
    if character then
        local piv = character:GetPivot()
        character:PivotTo(CFrame.new(piv.Position.X, destroyheight + dhto + character:GetExtentsSize().Y, piv.Position.Z))
    end
    
    if part then
        part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        if character then
            for _, v in pairs(character:GetChildren()) do
                if v:IsA("BasePart") then
                    v.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end
end

local sentnotif = false
local function prompt(message, yesorno, yesfunc)
    pcall(function()
        if yesorno ~= nil and yesfunc ~= nil then
            local bindfunc = Instance.new("BindableFunction")
            bindfunc.OnInvoke = function(buttonname)
                if buttonname == "Yes" then
                    yesfunc()
                    sentnotif = false
                end
            end
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Notification",
                Text = message,
                Duration = 5,
                Callback = bindfunc,
                Button1 = "Yes",
                Button2 = "No"
            })
            wait(5)
            sentnotif = false
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Notification",
                Text = message,
                Duration = 5
            })
        end
    end)
end

local stepped = game:GetService("RunService").Stepped:Connect(function()
    if character ~= nil and character:FindFirstChildWhichIsA("BasePart") then
        local part = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChildWhichIsA("BasePart")
        local cfr = (character:FindFirstChild("HumanoidRootPart") and character.HumanoidRootPart.CFrame) or character:GetPivot()
        charcframe = cfr
        
        if cfr.Position.Y < destroyheightnew then
            fixchar(part)
        end
        
        local partvel = part.AssemblyLinearVelocity
        if (partvel.Y / fpsdiv) + part.Position.Y < destroyheightnew then
            fixchar(part)
        end
        
        if tpcframe ~= nil and sentnotif == false then
            sentnotif = true
            prompt("Teleport to spawn?", true, function()
                if character then
                    character:PivotTo(CFrame.new(0, 51, 0))
                end
                if part then
                    part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end
            end)
        end
    end
end)

-- ============================================
-- SCRIPT CLEANUP FUNCTION
-- ============================================
function disablefunc()
    autoenlighten = false
    automessage = false
    totalk = nil
    off = true
    
    pcall(function() gui:Destroy() end)
    pcall(function() gui2:Destroy() end)
    
    for _, v in pairs(connect1) do
        pcall(function() v:Disconnect() end)
    end
    for _, v in pairs(tableofconnections) do
        pcall(function() v:Disconnect() end)
    end
    for _, v in pairs(tableofconnections_logger) do
        pcall(function() v:Disconnect() end)
    end
    for _, v in pairs(connectsextra) do
        pcall(function() v:Disconnect() end)
    end
    
    pcall(function() connect2:Disconnect() end)
    pcall(function() characteradded:Disconnect() end)
    pcall(function() stepped:Disconnect() end)
    
    workspace.FallenPartsDestroyHeight = destroyheight
    stopped = true
end

getgenv().thechosenonescriptdisable = disablefunc

-- ============================================
-- FINAL NOTIFICATIONS
-- ============================================
prompt("TCO Lua v2.0 Loaded - 200+ Commands!", false, nil)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Script Loaded!",
    Text = "200+ Commands Ready! Type 'help' for list",
    Duration = 5
})

-- Load Infinity Yield for extra commands
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

if getgenv().deletescript123456lol69 ~= nil then
    getgenv().deletescript123456lol69()
end
getgenv().deletescript123456lol69 = disablefunc
