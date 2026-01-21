--// HAROLD TOP 😹
--// UI + 5 BOTONES (TP SAFE, TP LOBBY, SPEED, WALL HOP, ESP)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-------------------------------------------------
-- GUI BASE
-------------------------------------------------
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "HAROLD_TOP"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 210, 0, 245) -- ajustado a 5 botones
main.Position = UDim2.new(0.5, -105, 0.5, -122)
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
-- ESP (You vs Homer)
-------------------------------------------------
local function addESP(plr)
	if plr == LocalPlayer then return end
	local char = plr.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local color
	if plr.Team and plr.Team.Name == "Homer" then
		color = Color3.fromRGB(255,0,0) -- rojo para Homer
	elseif plr.Team and plr.Team.Name == "Bart" then
		color = Color3.fromRGB(0,0,255) -- azul para Barts
	else
		color = Color3.fromRGB(255,255,255) -- fallback blanco
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
	-- limpiar ESP de jugadores que se fueron
	for plr, box in pairs(espObjects) do
		if not plr.Parent or not plr.Character then
			removeESP(plr)
		end
	end
	-- agregar ESP a los nuevos jugadores
	for _, plr in pairs(Players:GetPlayers()) do
		if not espObjects[plr] then
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

-- Actualizar ESP cada frame si está activo
RunService.Heartbeat:Connect(function()
	if espOn then
		updateESP()
	end
end)
