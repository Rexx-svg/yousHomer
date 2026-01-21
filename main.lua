--// HAROLD TOP 😹
--// UI + 5 BOTONES (TP SAFE, TP LOBBY, SPEED, WALL HOP, ESP)
--// DAY SHADERS FIX 🔆

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-------------------------------------------------
-- 🌞 DAY SHADERS (AUTO)
-------------------------------------------------
Lighting.Brightness = 3
Lighting.ClockTime = 13.5
Lighting.GlobalShadows = true
Lighting.EnvironmentDiffuseScale = 1
Lighting.EnvironmentSpecularScale = 1
Lighting.OutdoorAmbient = Color3.fromRGB(140,140,140)
Lighting.Ambient = Color3.fromRGB(120,120,120)

-- Color Correction
local cc = Instance.new("ColorCorrectionEffect", Lighting)
cc.Brightness = 0.05
cc.Contrast = 0.2
cc.Saturation = 0.15
cc.TintColor = Color3.fromRGB(255,255,245)

-- Bloom
local bloom = Instance.new("BloomEffect", Lighting)
bloom.Intensity = 0.25
bloom.Size = 24
bloom.Threshold = 1

-- Sun Rays
local sun = Instance.new("SunRaysEffect", Lighting)
sun.Intensity = 0.15
sun.Spread = 0.9

-- Atmosphere (HD look)
local atmo = Instance.new("Atmosphere", Lighting)
atmo.Density = 0.25
atmo.Offset = 0.2
atmo.Color = Color3.fromRGB(199,199,199)
atmo.Decay = Color3.fromRGB(106,112,125)
atmo.Glare = 0.15
atmo.Haze = 1

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

-- Minimizador
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
-- BOTONES
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
local lobbyPos = nil
local lastPos = nil
local espObjects = {}

-------------------------------------------------
-- GUARDAR LOBBY
-------------------------------------------------
LocalPlayer.CharacterAdded:Connect(function(char)
	task.wait(1)
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp then lobbyPos = hrp.CFrame end
end)

-------------------------------------------------
-- TP SAFE (SOLO BART)
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
		if hrp then hrp.Velocity = Vector3.new(hrp.Velocity.X,jumpForce,hrp.Velocity.Z) end
	end
end)

-------------------------------------------------
-- ESP FIX
-------------------------------------------------
local function validTeam(team)
	return team and (team.Name=="Bart" or team.Name=="Homer")
end

local function clearESP()
	for _,b in pairs(espObjects) do b:Destroy() end
	espObjects = {}
end

local function addESP(plr)
	if plr==LocalPlayer then return end
	if not validTeam(plr.Team) then return end
	local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local box = Instance.new("BoxHandleAdornment")
	box.Adornee = hrp
	box.Size = Vector3.new(2.6,4.8,2.6)
	box.AlwaysOnTop = true
	box.Transparency = 0.4
	box.Color3 = plr.Team.Name=="Bart" and Color3.fromRGB(0,0,255) or Color3.fromRGB(255,0,0)
	box.Parent = Workspace
	espObjects[plr]=box
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
-- MINIMIZAR
-------------------------------------------------
local open=true
minimize.MouseButton1Click:Connect(function()
	sound()
	open=not open
	minimize.Text=open and "-" or "+"
	for _,b in pairs({TPSafeBtn,TPLobbyBtn,SpeedBtn,WallHopBtn,ESPBtn}) do
		b.Visible=open
	end
	main:TweenSize(open and UDim2.new(0,210,0,260) or UDim2.new(0,210,0,40),
		"Out","Quad",0.3,true)
end)
