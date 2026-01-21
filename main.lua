--// HAROLD TOP 😹
--// UI + TP SAFE, TP LOBBY, SPEED, WALL HOP, ESP
--// DAY MODE NO LAG + ESP THROUGH WALLS FIXED ✅

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-------------------------------------------------
-- 🌞 DAY MODE (ABSOLUTE / NO NIGHT / NO LAG)
-------------------------------------------------
Lighting:ClearAllChildren()
Lighting.Brightness = 2.5
Lighting.ClockTime = 13
Lighting.GlobalShadows = true
Lighting.Ambient = Color3.fromRGB(140,140,140)
Lighting.OutdoorAmbient = Color3.fromRGB(160,160,160)
Lighting.EnvironmentDiffuseScale = 1
Lighting.EnvironmentSpecularScale = 1
Lighting.FogEnd = 1e10

-------------------------------------------------
-- GUI BASE
-------------------------------------------------
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "HAROLD_TOP"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,210,0,260)
main.Position = UDim2.new(0.5,-105,0.5,-130)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

-- Minimize
local minimize = Instance.new("TextButton", main)
minimize.Size = UDim2.new(0,30,0,30)
minimize.Position = UDim2.new(1,-35,0,2)
minimize.BackgroundColor3 = Color3.fromRGB(0,0,0)
minimize.Text = "-"
minimize.TextColor3 = Color3.new(1,1,1)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 14
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0,8)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "😹 HAROLD TOP"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(255,80,80)

-------------------------------------------------
-- CLICK SOUND
-------------------------------------------------
local click = Instance.new("Sound", gui)
click.SoundId = "rbxassetid://12221967"
click.Volume = 1
local function sound() click:Play() end

-------------------------------------------------
-- BUTTON MAKER
-------------------------------------------------
local function button(txt,y)
	local b = Instance.new("TextButton", main)
	b.Size = UDim2.new(1,-20,0,32)
	b.Position = UDim2.new(0,10,0,y)
	b.BackgroundColor3 = Color3.fromRGB(40,0,0)
	b.Text = txt.." [OFF]"
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 12
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	return b
end

-------------------------------------------------
-- BUTTONS
-------------------------------------------------
local TPSafeBtn = button("TP SAFE",45)
local TPLobbyBtn = button("TP LOBBY",85)
local SpeedBtn   = button("SPEED",125)
local WallHopBtn = button("WALL HOP",165)
local ESPBtn     = button("ESP",205)

-------------------------------------------------
-- STATES
-------------------------------------------------
local tpSafeOn,tpOn,speedOn,wallHopOn,espOn = false,false,false,false,false
local normalSpeed = 16
local lobbyPos,lastPos = nil,nil
local espObjects = {}

-------------------------------------------------
-- SAVE LOBBY POS
-------------------------------------------------
LocalPlayer.CharacterAdded:Connect(function(char)
	task.wait(1)
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp then lobbyPos = hrp.CFrame end
end)

-------------------------------------------------
-- TP SAFE (BART)
-------------------------------------------------
TPSafeBtn.MouseButton1Click:Connect(function()
	sound()
	tpSafeOn = not tpSafeOn
	TPSafeBtn.Text = "TP SAFE ["..(tpSafeOn and "ON" or "OFF").."]"

	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	if tpSafeOn then
		if LocalPlayer.Team and LocalPlayer.Team.Name=="Bart" then
			lastPos = hrp.CFrame
			if lobbyPos then hrp.CFrame = lobbyPos end
		end
	else
		if lastPos then hrp.CFrame = lastPos lastPos=nil end
	end
end)

-------------------------------------------------
-- TP LOBBY
-------------------------------------------------
TPLobbyBtn.MouseButton1Click:Connect(function()
	sound()
	tpOn = not tpOn
	TPLobbyBtn.Text = "TP LOBBY ["..(tpOn and "ON" or "OFF").."]"
	if tpOn and lobbyPos and LocalPlayer.Character then
		LocalPlayer.Character.HumanoidRootPart.CFrame = lobbyPos
	end
end)

-------------------------------------------------
-- SPEED
-------------------------------------------------
SpeedBtn.MouseButton1Click:Connect(function()
	sound()
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	speedOn = not speedOn
	hum.WalkSpeed = speedOn and 38.5 or normalSpeed
	SpeedBtn.Text = "SPEED ["..(speedOn and "ON" or "OFF").."]"
end)

-------------------------------------------------
-- WALL HOP
-------------------------------------------------
local jumpForce = 50
local clampFallSpeed = 80

WallHopBtn.MouseButton1Click:Connect(function()
	sound()
	wallHopOn = not wallHopOn
	WallHopBtn.Text = "WALL HOP ["..(wallHopOn and "ON" or "OFF").."]"
end)

RunService.Heartbeat:Connect(function()
	if wallHopOn then
		local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if hrp and hrp.Velocity.Y < -clampFallSpeed then
			hrp.Velocity = Vector3.new(hrp.Velocity.X,-clampFallSpeed,hrp.Velocity.Z)
		end
	end
end)

UIS.JumpRequest:Connect(function()
	if wallHopOn then
		local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.Velocity = Vector3.new(hrp.Velocity.X,jumpForce,hrp.Velocity.Z)
		end
	end
end)

-------------------------------------------------
-- ESP THROUGH WALLS (HIGHLIGHT)
-------------------------------------------------
local function validTeam(team)
	return team and (team.Name=="Bart" or team.Name=="Homer")
end

local function clearESP()
	for _,h in pairs(espObjects) do
		if h then h:Destroy() end
	end
	espObjects = {}
end

local function addESP(plr)
	if plr == LocalPlayer then return end
	if not validTeam(plr.Team) then return end
	if not plr.Character then return end

	local highlight = Instance.new("Highlight")
	highlight.Adornee = plr.Character
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.FillTransparency = 0.6
	highlight.OutlineTransparency = 0
	highlight.FillColor =
		plr.Team.Name=="Bart"
		and Color3.fromRGB(0,120,255)
		or Color3.fromRGB(255,60,60)
	highlight.OutlineColor = highlight.FillColor
	highlight.Parent = gui

	espObjects[plr] = highlight
end

ESPBtn.MouseButton1Click:Connect(function()
	sound()
	espOn = not espOn
	ESPBtn.Text = "ESP ["..(espOn and "ON" or "OFF").."]"
	if not espOn then clearESP() end
end)

RunService.Heartbeat:Connect(function()
	if espOn then
		for _,p in pairs(Players:GetPlayers()) do
			if validTeam(p.Team) and not espObjects[p] then
				addESP(p)
			end
		end
	end
end)

-------------------------------------------------
-- MINIMIZE
-------------------------------------------------
local open = true
minimize.MouseButton1Click:Connect(function()
	sound()
	open = not open
	minimize.Text = open and "-" or "+"
	for _,b in pairs({TPSafeBtn,TPLobbyBtn,SpeedBtn,WallHopBtn,ESPBtn}) do
		b.Visible = open
	end
	main:TweenSize(
		open and UDim2.new(0,210,0,260) or UDim2.new(0,210,0,40),
		"Out","Quad",0.3,true
	)
end)
