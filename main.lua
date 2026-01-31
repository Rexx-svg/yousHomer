-- 😹 HAROLD TOP - RAYFIELD EDITION (TP SAFE como TOGGLE)
-- Main:
--   • TP SAFE (Toggle)
--   • TP LOBBY (Button)
--   • ESP (Toggle)
-- Player:
--   • Speed (Toggle)
--   • Wall Hop (Toggle)

-- Rayfield Loader
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

-------------------------------------------------
-- WINDOW
-------------------------------------------------
local Window = Rayfield:CreateWindow({
	Name = "😹 HAROLD TOP",
	LoadingTitle = "HAROLD TOP",
	LoadingSubtitle = "Rayfield Edition",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "HaroldTop",
		FileName = "Config"
	},
	KeySystem = false
})

-------------------------------------------------
-- TABS
-------------------------------------------------
local MainTab = Window:CreateTab("Main", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)

-------------------------------------------------
-- STATES
-------------------------------------------------
local tpSafeOn = false
local speedOn = false
local wallHopOn = false
local espOn = false

local normalSpeed = 16
local lobbyPos = nil
local lastPos = nil
local espObjects = {}

-------------------------------------------------
-- GUARDAR POSICIÓN LOBBY
-------------------------------------------------
LocalPlayer.CharacterAdded:Connect(function(char)
	task.wait(1)
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp then
		lobbyPos = hrp.CFrame
	end
end)

-------------------------------------------------
-- TP SAFE (TOGGLE)
-------------------------------------------------
MainTab:CreateToggle({
	Name = "TP SAFE",
	CurrentValue = false,
	Flag = "TPSafeToggle",
	Callback = function(Value)
		tpSafeOn = Value

		local char = LocalPlayer.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		if tpSafeOn then
			-- Activado: guardar posición y mandar al lobby
			if LocalPlayer.Team and LocalPlayer.Team.Name == "Bart" then
				lastPos = hrp.CFrame
				if lobbyPos then
					hrp.CFrame = lobbyPos
				end
			end
		else
			-- Desactivado: volver a la posición anterior
			if lastPos then
				hrp.CFrame = lastPos
				lastPos = nil
			end
		end
	end,
})

-------------------------------------------------
-- TP LOBBY (BUTTON)
-------------------------------------------------
MainTab:CreateButton({
	Name = "TP LOBBY",
	Callback = function()
		if lobbyPos and LocalPlayer.Character then
			LocalPlayer.Character.HumanoidRootPart.CFrame = lobbyPos
		end
	end,
})

-------------------------------------------------
-- SPEED (TOGGLE)
-------------------------------------------------
PlayerTab:CreateToggle({
	Name = "Speed",
	CurrentValue = false,
	Flag = "SpeedToggle",
	Callback = function(Value)
		speedOn = Value
		local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.WalkSpeed = speedOn and 38.5 or normalSpeed
		end
	end,
})

-------------------------------------------------
-- WALL HOP (TOGGLE)
-------------------------------------------------
local jumpForce = 50
local clampFallSpeed = 80

PlayerTab:CreateToggle({
	Name = "Wall Hop",
	CurrentValue = false,
	Flag = "WallHopToggle",
	Callback = function(Value)
		wallHopOn = Value
	end,
})

RunService.Heartbeat:Connect(function()
	if not wallHopOn then return end
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp and hrp.Velocity.Y < -clampFallSpeed then
		hrp.Velocity = Vector3.new(hrp.Velocity.X, -clampFallSpeed, hrp.Velocity.Z)
	end
end)

UIS.JumpRequest:Connect(function()
	if wallHopOn then
		local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.Velocity = Vector3.new(hrp.Velocity.X, jumpForce, hrp.Velocity.Z)
		end
	end
end)

-------------------------------------------------
-- ESP
-------------------------------------------------
local function validTeam(team)
	return team and (team.Name == "Bart" or team.Name == "Homer")
end

local function clearESP()
	for _, b in pairs(espObjects) do
		b:Destroy()
	end
	espObjects = {}
end

local function addESP(plr)
	if plr == LocalPlayer then return end
	if not validTeam(plr.Team) then return end
	if not plr.Character then return end

	local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local color = plr.Team.Name == "Homer"
		and Color3.fromRGB(255, 0, 0)
		or Color3.fromRGB(0, 0, 255)

	local box = Instance.new("BoxHandleAdornment")
	box.Adornee = hrp
	box.Size = Vector3.new(2.6, 4.8, 2.6)
	box.AlwaysOnTop = true
	box.Transparency = 0.4
	box.Color3 = color
	box.ZIndex = 10
	box.Parent = Workspace

	espObjects[plr] = box
end

local function updateESP()
	if not espOn then return end

	for plr, box in pairs(espObjects) do
		if not validTeam(plr.Team) or not plr.Character then
			box:Destroy()
			espObjects[plr] = nil
		end
	end

	for _, plr in pairs(Players:GetPlayers()) do
		if validTeam(plr.Team) and not espObjects[plr] then
			addESP(plr)
		end
	end
end

MainTab:CreateToggle({
	Name = "ESP",
	CurrentValue = false,
	Flag = "ESPToggle",
	Callback = function(Value)
		espOn = Value
		if not espOn then
			clearESP()
		end
	end,
})

RunService.Heartbeat:Connect(updateESP)
Players.PlayerRemoving:Connect(function(p)
	if espObjects[p] then
		espObjects[p]:Destroy()
		espObjects[p] = nil
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
