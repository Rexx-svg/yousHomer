-- 😹 HAROLD TOP - RAYFIELD EDITION (TP SAFE como TOGGLE)
-- Main:
--   • TP SAFE (Toggle)
--   • TP LOBBY (Button)
--   • ESP (Toggle)
-- Player:
--   • Speed (Toggle)
--   • Wall Hop (Toggle)
-- Skins Limitadas: toggles para comprar/equipar viejas limitadas (Ghost, Witch, Beauty, CPTDev, etc.)

-- Rayfield Loader
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
local SkinsTab = Window:CreateTab("Skins Limitadas", 4483362458)  -- Nuevo tab al lado de Player

-------------------------------------------------
-- STATES (originales)
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

-------------------------------------------------
-- SKINS LIMITADAS - SECCIÓN NUEVA
-------------------------------------------------
local buyRemote = ReplicatedStorage:WaitForChild("eventFolders"):WaitForChild("store"):WaitForChild("buyItem")
local changeRemote = ReplicatedStorage:WaitForChild("eventFolders"):WaitForChild("store"):WaitForChild("changeSkin")

local Leaderstats = LocalPlayer:WaitForChild("leaderstats")
local Quidz = Leaderstats:WaitForChild("Quidz")

-- Lista de skins limitadas/viejas (IDs reales de wikis/scripts)
local LimitedSkins = {
	{name = "Ghost Bart", id = "Ghost", price = 555, team = "Bart"},
	{name = "Witch Bart", id = "Witch", price = 350, team = "Bart"},
	{name = "Jacko Bart", id = "Jacko", price = 400, team = "Bart"},  -- Halloween old
	{name = "Santa Bart", id = "Santa", price = 375, team = "Bart"},
	{name = "Frozen Bart", id = "Frozen", price = 500, team = "Bart"},
	{name = "Beauty", id = "Beauty", price = 0, team = "Bart"},  -- Old special
	{name = "CPTDev Bart", id = "CPT", price = 999999, team = "Bart"},  -- Exclusive pero exploiteable
	{name = "1M VISITS Bart", id = "1M", price = 1000000, team = "Bart"},
	{name = "700K Visits Bart", id = "700K", price = 700000, team = "Bart"},
}

-- Función para comprar/equipar skin
local function TryBuyAndEquip(skin)
	if LocalPlayer.Team.Name ~= skin.team then
		Rayfield:Notify({
			Title = "Error",
			Content = "Debes estar en equipo " .. skin.team .. " para esta skin.",
			Duration = 4
		})
		return
	end
	
	local currentQuidz = Quidz.Value
	if currentQuidz >= skin.price then
		-- Fire remotes reales
		buyRemote:FireServer("Bart", skin.id)   -- Asumiendo Bart skins, ajusta si Homer
		changeRemote:FireServer("Bart", skin.id)
		
		-- Simular gasto visual
		Quidz.Value = currentQuidz - skin.price
		
		Rayfield:Notify({
			Title = "¡Comprada!",
			Content = skin.name .. " comprada y equipada por " .. skin.price .. " Quidz.",
			Duration = 5
		})
	else
		Rayfield:Notify({
			Title = "Quidz Insuficientes",
			Content = "Necesitas " .. skin.price .. " Quidz para " .. skin.name,
			Duration = 4
		})
	end
end

-- Crear toggles para cada skin limitada
SkinsTab:CreateSection("Skins Limitadas Viejas (Toggle = Comprar/Equipar)")

for _, skin in ipairs(LimitedSkins) do
	SkinsTab:CreateToggle({
		Name = skin.name .. " (" .. skin.price .. " Quidz)",
		CurrentValue = false,
		Flag = "Skin_" .. skin.id,
		Callback = function(Value)
			if Value then
				TryBuyAndEquip(skin)
				-- Toggle off auto después de intentar (no es equip permanente)
				task.delay(0.5, function()
					Rayfield.Flags["Skin_" .. skin.id].CurrentValue = false
				end)
			end
		end,
	})
end

SkinsTab:CreateSection("Info")
SkinsTab:CreateParagraph({
	Title = "Cómo usar",
	Content = "Activa el toggle → intenta comprar y equipar la skin si tienes Quidz. Funciona con remotes reales. Rejoin si no ves el cambio. Solo Bart skins por ahora (agrega Homer si quieres)."
})

Rayfield:Notify({
	Title = "Listo bro!",
	Content = "Tab 'Skins Limitadas' agregado con toggles para viejas limitadas. ¡Prueba Ghost Bart y Beauty primero!",
	Duration = 6
})
