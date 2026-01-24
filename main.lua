--// HAROLD TOP 😹
--// UI + 5 BOTONES (TP SAFE, TP LOBBY, SPEED, WALL HOP, ESP)
--// KEYBIND: Presiona K para abrir/cerrar el menú

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

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
	b.Text = txt
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
local SpeedBtn   = button("SPEED [OFF]",125)
local WallHopBtn = button("WALL HOP [OFF]",165)
local ESPBtn     = button("ESP [OFF]",205)

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
	if hrp then
		lobbyPos = hrp.CFrame
	end
end)

-------------------------------------------------
-- TP SAFE (TEXTO BACK)
-------------------------------------------------
TPSafeBtn.MouseButton1Click:Connect(function()
	sound()
	tpSafeOn = not tpSafeOn

	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	if tpSafeOn then
		TPSafeBtn.Text = "BACK"
		if LocalPlayer.Team and LocalPlayer.Team.Name == "Bart" then
			lastPos = hrp.CFrame
			if lobbyPos then
				hrp.CFrame = lobbyPos
			end
		end
	else
		TPSafeBtn.Text = "TP SAFE"
		if lastPos then
			hrp.CFrame = lastPos
			lastPos = nil
		end
	end
end)

-------------------------------------------------
-- TP LOBBY (TELEPORTING...)
-------------------------------------------------
TPLobbyBtn.MouseButton1Click:Connect(function()
	sound()
	TPLobbyBtn.Text = "TELEPORTING..."

	if lobbyPos and LocalPlayer.Character then
		task.wait(0.2)
		LocalPlayer.Character.HumanoidRootPart.CFrame = lobbyPos
	end

	task.wait(0.3)
	TPLobbyBtn.Text = "TP LOBBY"
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
	if not wallHopOn then return end
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp and hrp.Velocity.Y < -clampFallSpeed then
		hrp.Velocity = Vector3.new(hrp.Velocity.X,-clampFallSpeed,hrp.Velocity.Z)
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
-- ESP
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
	if not plr.Character then return end

	local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local color = plr.Team.Name=="Homer"
		and Color3.fromRGB(255,0,0)
		or Color3.fromRGB(0,0,255)

	local box = Instance.new("BoxHandleAdornment")
	box.Adornee = hrp
	box.Size = Vector3.new(2.6,4.8,2.6)
	box.AlwaysOnTop = true
	box.Transparency = 0.4
	box.Color3 = color
	box.ZIndex = 10
	box.Parent = Workspace

	espObjects[plr]=box
end

local function updateESP()
	if not espOn then return end

	if not validTeam(LocalPlayer.Team) then
		clearESP()
		return
	end

	for plr,box in pairs(espObjects) do
		if not validTeam(plr.Team) or not plr.Character then
			box:Destroy()
			espObjects[plr]=nil
		end
	end

	for _,plr in pairs(Players:GetPlayers()) do
		if validTeam(plr.Team) and not espObjects[plr] then
			addESP(plr)
		end
	end
end

ESPBtn.MouseButton1Click:Connect(function()
	sound()
	espOn = not espOn
	ESPBtn.Text = "ESP ["..(espOn and "ON" or "OFF").."]"
	if not espOn then clearESP() end
end)

RunService.Heartbeat:Connect(updateESP)
Players.PlayerAdded:Connect(updateESP)
Players.PlayerRemoving:Connect(function(p)
	if espObjects[p] then espObjects[p]:Destroy() espObjects[p]=nil end
end)

-------------------------------------------------
-- MINIMIZAR / MAXIMIZAR (BOTÓN Y TECLA K)
-------------------------------------------------
local open = true

local function toggleMenu()
	open = not open
	if open then
		minimize.Text = "-"
		for _,b in pairs({TPSafeBtn,TPLobbyBtn,SpeedBtn,WallHopBtn,ESPBtn}) do
			b.Visible = true
		end
		main:TweenSize(UDim2.new(0,210,0,260),"Out","Quad",0.3,true)
	else
		minimize.Text = "+"
		for _,b in pairs({TPSafeBtn,TPLobbyBtn,SpeedBtn,WallHopBtn,ESPBtn}) do
			b.Visible = false
		end
		main:TweenSize(UDim2.new(0,210,0,40),"Out","Quad",0.3,true)
	end
end

minimize.MouseButton1Click:Connect(function()
	sound()
	toggleMenu()
end)

-- KEYBIND K
UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.K then
		sound()
		toggleMenu()
	end
end)

-------------------------------------------------
-- FIJAR MEDIO DÍA
-------------------------------------------------
local function setMidDay()
	Lighting.ClockTime = 13
	Lighting.Brightness = 2
	Lighting.GlobalShadows = true
	Lighting.FogEnd = 100000
end

LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function()
	task.wait(0.1)
	setMidDay()
end)

setMidDay()
