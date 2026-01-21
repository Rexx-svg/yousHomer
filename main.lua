--// HAROLD TOP 😹
--// UI + 5 BOTONES (TP SAFE, TP LOBBY, SPEED, WALL HOP, ESP)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-------------------------------------------------
-- GUI BASE
-------------------------------------------------
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "HAROLD_TOP"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 210, 0, 260)
main.Position = UDim2.new(0.5, -105, 0.5, -130)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

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
local function button(txt, y, w)
	local b = Instance.new("TextButton", main)
	b.Size = w or UDim2.new(1,-20,0,32)
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
local TPSafeBtn = button("TP SAFE", 45)
local TPLobbyBtn = button("TP LOBBY", 85)
local SpeedBtn   = button("SPEED", 125)
local WallHopBtn = button("WALL HOP", 165)
local ESPBtn     = button("ESP", 205)

-------------------------------------------------
-- STATES
-------------------------------------------------
local tpSafeOn, tpOn, speedOn, wallHopOn, espOn = false,false,false,false,false
local normalSpeed = 16
local lobbyPos = nil
local espObjects = {}

-- Guardar posición al spawn
lobbyPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.CFrame

-------------------------------------------------
-- TP SAFE
-------------------------------------------------
TPSafeBtn.MouseButton1Click:Connect(function()
	sound()
	tpSafeOn = not tpSafeOn
	TPSafeBtn.Text = "TP SAFE ["..(tpSafeOn and "ON" or "OFF").."]"
	-- Source para teletransportar al verde se añadirá aquí
end)

-------------------------------------------------
-- TP LOBBY
-------------------------------------------------
TPLobbyBtn.MouseButton1Click:Connect(function()
	sound()
	tpOn = not tpOn
	TPLobbyBtn.Text = "TP LOBBY ["..(tpOn and "ON" or "OFF").."]"
	if tpOn and lobbyPos and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
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
-- WALL HOP (INFINITE JUMP)
-------------------------------------------------
local jumpForce = 50
local clampFallSpeed = 80

WallHopBtn.MouseButton1Click:Connect(function()
	sound()
	wallHopOn = not wallHopOn
	WallHopBtn.Text = "WALL HOP ["..(wallHopOn and "ON" or "OFF").."]"
end)

RunService.Heartbeat:Connect(function()
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then return end

	if wallHopOn and hrp.Velocity.Y < -clampFallSpeed then
		hrp.Velocity = Vector3.new(hrp.Velocity.X, -clampFallSpeed, hrp.Velocity.Z)
	end
end)

UIS.JumpRequest:Connect(function()
	if wallHopOn then
		local char = LocalPlayer.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.Velocity = Vector3.new(hrp.Velocity.X, jumpForce, hrp.Velocity.Z)
		end
	end
end)

-------------------------------------------------
-- ESP (You vs Homer) actualizado
-------------------------------------------------
local function addESP(plr)
	if plr == LocalPlayer then return end
	local char = plr.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	if not plr.Team then return end -- ESP solo si está en un equipo

	local color
	if plr.Team.Name == "Homer" then
		color = Color3.fromRGB(255,0,0) -- rojo para Homer
	elseif plr.Team.Name == "Bart" then
		color = Color3.fromRGB(0,0,255) -- azul para Barts
	else
		color = Color3.fromRGB(255,255,255)
	end

	local box = Instance.new("BoxHandleAdornment")
	box.Adornee = hrp
	box.Size = Vector3.new(1.5, 3.5, 1) -- hitbox mediana
	box.AlwaysOnTop = true
	box.Transparency = 0.5
	box.Color3 = color
	box.ZIndex = 10
	box.Parent = Workspace

	espObjects[plr] = box
end

local function removeESP(plr)
	if espObjects[plr] then
		espObjects[plr]:Destroy()
		espObjects[plr] = nil
	end
end

local function updateESP()
	for plr, box in pairs(espObjects) do
		if not plr.Parent or not plr.Character then
			removeESP(plr)
		end
	end
	for _, plr in pairs(Players:GetPlayers()) do
		if not espObjects[plr] and plr.Team then
			addESP(plr)
		end
	end
end

ESPBtn.MouseButton1Click:Connect(function()
	sound()
	espOn = not espOn
	ESPBtn.Text = "ESP ["..(espOn and "ON" or "OFF").."]"
	if not espOn then
		for _, plr in pairs(espObjects) do
			plr:Destroy()
		end
		espObjects = {}
	end
end)

RunService.Heartbeat:Connect(function()
	if espOn then
		updateESP()
	end
end)

-------------------------------------------------
-- MINIMIZADOR / BOTÓN CIRCULAR
-------------------------------------------------
local minimized = false

local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.new(0, 25, 0, 25)
minBtn.Position = UDim2.new(1, -30, 0, 5)
minBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,12)

local openBtn = Instance.new("TextButton", PlayerGui)
openBtn.Size = UDim2.new(0, 40, 0, 40)
openBtn.Position = UDim2.new(0, 10, 0.5, -20)
openBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
openBtn.Text = ""
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0,20)
openBtn.Visible = false
openBtn.ZIndex = 50

local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

minBtn.MouseButton1Click:Connect(function()
	minimized = true
	local goal = {Size = UDim2.new(0,210,0,35)}
	local tween = TweenService:Create(main, tweenInfo, goal)
	tween:Play()
	openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
	minimized = false
	local goal = {Size = UDim2.new(0,210,0,260)}
	local tween = TweenService:Create(main, tweenInfo, goal)
	tween:Play()
	openBtn.Visible = false
end)
