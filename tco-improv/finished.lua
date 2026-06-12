--[[
    ============================================================================
    Project: The Chosen Hub | The Chosen One | Ultimate Edition
    Author: n1nerlang
    Environment: Roblox / Luau
    Last Update: 2026-06-12
    Device: Samsung Galaxy Tab A7 Lite (SM-T225)
    
    Description: 
    Advanced administrative bridge for 'The Chosen One'. Includes 
    automated Arkenstone tracking, presence management, and 
    modular chat-command wrapping.
    ============================================================================
]]

--[[
```markdown
# senti.cc - The Chosen One
### Features
- **Arkenstone Auto-Grab**: High-precision teleportation to item spawns.
- **Arkenstone ESP**: Persistent highlight system with distance tracking.
- **AFK-Presence**: Keeps the session alive for admin-tier grinding.
- **Command Palette**: Rapid administrative command execution.

### Changelog
- v1.0.0: Initial release.
- v1.1.2: Added custom log window and error handling for SM-T225 memory stability.

### Credits
- Developed by: lupsup39

```

]]

-- 1. INITIALIZATION & SECURITY
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Library-Link/Here'))()
local Window = Rayfield:CreateWindow({
Name = "senti.cc | The Chosen One | v1.1.2",
LoadingTitle = "Initializing senti.cc...",
LoadingSubtitle = "by lupsup39",
})

-- 3. UTILITY MODULES
local Lib = {}

function Lib:Notify(title, text)
Rayfield:Notify({Title = title, Content = text, Duration = 3})
end

function Lib:Teleport(cframe)
local char = LocalPlayer.Character
if char and char:FindFirstChild("HumanoidRootPart") then
char.HumanoidRootPart.CFrame = cframe
end
end

function Lib:ExecuteChat(cmd)
local chatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
if chatEvent then
chatEvent.SayMessageRequest:FireServer(cmd, "All")
end
end

-- 4. TABS
local HomeTab = Window:CreateTab("Home")
local AutomationTab = Window:CreateTab("Automation")
local ArkenstoneTab = Window:CreateTab("Arkenstone")
local AdminTab = Window:CreateTab("Admin/Commands")

-- 5. HOME TAB (Logging)
local LogContainer = HomeTab:CreateSection("Activity Logs")
local LogList = {}
local function AddLog(msg)
table.insert(LogList, msg)
if #LogList > 10 then table.remove(LogList, 1) end
print("[senti.cc]: " .. msg)
end

-- 6. AUTOMATION TAB (AFK)
AutomationTab:CreateToggle({
Name = "Anti-AFK System",
Callback = function(state)
getgenv().AFK = state
task.spawn(function()
while getgenv().AFK do
local VirtualUser = game:GetService("VirtualUser")
VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
task.wait(1)
VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
AddLog("Anti-AFK heartbeat sent.")
task.wait(300)
end
end)
end
})

-- 7. ARKENSTONE TAB
ArkenstoneTab:CreateToggle({
Name = "Arkenstone ESP",
Callback = function(state)
getgenv().ESP = state
task.spawn(function()
while getgenv().ESP do
local target = Workspace:FindFirstChild("Arkenstone") or Workspace:FindFirstChild("The Arkenstone")
if target and not target:FindFirstChild("SentiHighlight") then
local h = Instance.new("Highlight")
h.Name = "SentiHighlight"
h.Parent = target
h.FillColor = Color3.fromRGB(0, 255, 255)
end
task.wait(2)
end
end)
end
})

ArkenstoneTab:CreateButton({
Name = "Teleport to Arkenstone",
Callback = function()
local stone = Workspace:FindFirstChild("Arkenstone") or Workspace:FindFirstChild("The Arkenstone")
if stone then
Lib:Teleport(stone.PrimaryPart and stone.PrimaryPart.CFrame or stone:IsA("BasePart") and stone.CFrame)
Lib:Notify("senti.cc", "Teleported to Arkenstone.")
else
Lib:Notify("senti.cc", "Arkenstone not found.")
end
end
})

-- 8. ADMIN TAB
AdminTab:CreateSection("Command Macros")

local Commands = {
{"Peace Mode", "/peace"},
{"Chaos Mode", "/chaos"},
{"Server Reset", "/reset"},
}

for _, cmd in ipairs(Commands) do
AdminTab:CreateButton({
Name = "Execute " .. cmd[1],
Callback = function()
Lib:ExecuteChat(cmd[2])
AddLog("Executed: " .. cmd[2])
end
})
end

-- 9. FINALIZATION
Rayfield:LoadConfiguration()
AddLog("senti.cc loaded successfully.")
