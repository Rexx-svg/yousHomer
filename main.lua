--// YOU VS HOMER HUB (para TU juego)
-- TP LOBBY | SPEED | INF JUMP | ESP | FIX LAG
-- Panel autoajustable, animaciones, sonidos y botón + / -

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

player.CharacterAdded:Connect(function(c)
	char = c
	hrp = char:WaitForChild("HumanoidRootPart")
	humanoid = char:WaitForChild("Humanoid")
end)

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "YOUVSHOMERHUB"
gui.ResetOnSpawn = false

-- PANEL
local frame = Instance.new("Frame", gui)
frame.Position = UDim2.fromScale(0.35,0.2)
frame.Size = UDim2.fromScale(0.3,0)
frame.AutomaticSize = Enum.AutomaticSize.Y
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

-- HEADER
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1,0,0,36)
header.BackgroundColor3 = Color3.fromRGB(230,230,230)
header.BorderSizePixel = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,-40,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "YOU VS HOMER HUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(0,0,0)
title.TextXAlignment = Enum.TextXAlignment.Left

local toggleBtn = Instance.new("TextButton", header)
toggleBtn.Size = UDim2.new(0,26,0,26)
toggleBtn.Position = UDim2.new(1,-30,0.5,-13)
toggleBtn.Text = "-"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 22
toggleBtn.BackgroundColor3 = Color3.fromRGB(200,200,200)
toggleBtn.TextColor3 = Color3.fromRGB(0,0,0)
toggleBtn.BorderSizePixel = 0
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1,0)

-- CONTENEDOR
local container = Instance.new("Frame", frame)
container.Size = UDim2.new(1,-16,0,0)
container.Position = UDim2.new(0,8,0,42)
container.AutomaticSize = Enum.AutomaticSize.Y
container.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0,6)

-- SONIDO BOTONES
local clickSound = Instance.new("Sound", gui)
clickSound.SoundId = "rbxassetid://12222225"
clickSound.Volume = 1

local function playSound()
	clickSound:Play()
end

-- BOTONES
local function createButton(text)
	local btn = Instance.new("TextButton", container)
	btn.Size = UDim2.new(1,0,0,42)
	btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
	btn.MouseButton1Click:Connect(playSound)
	return btn
end

local tpBtn   = createButton("TP LOBBY")
local speedBtn= createButton("SPEED")
local infBtn  = createButton("INF JUMP")
local espBtn  = createButton("ESP")
local fixBtn  = createButton("FIX LAG")

-- MINIMIZAR / ABRIR CON ANIMACIÓN
local minimized = false
toggleBtn.MouseButton1Click:Connect(function()
	playSound()
	minimized = not minimized
	local goal = minimized and 0 or container.AbsoluteContentSize.Y
	TweenService:Create(container,TweenInfo.new(0.25,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),
		{Size = UDim2.new(1,-16,0,goal)}):Play()
	container.Visible = not minimized
	toggleBtn.Text = minimized and "+" or "-"
end)

-- =========================
-- TP LOBBY (SOURCE QUE PEDISTE)
-- =========================
local lobbyCFrame
local firstSpawn = true

player.CharacterAdded:Connect(function(c)
	char = c
	hrp = char:WaitForChild("HumanoidRootPart")
	humanoid = char:WaitForChild("Humanoid")
	if firstSpawn then
		lobbyCFrame = hrp.CFrame
		firstSpawn = false
	end
end)

tpBtn.MouseButton1Click:Connect(function()
	if hrp and lobbyCFrame then
		hrp.CFrame = lobbyCFrame
	end
end)

-- =========================
-- SPEED (+29%)
-- =========================
local speedOn = false
local normalSpeed = humanoid.WalkSpeed

speedBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	if speedOn then
		humanoid.WalkSpeed = normalSpeed * 1.29
		speedBtn.Text = "SPEED (ON)"
	else
		humanoid.WalkSpeed = normalSpeed
		speedBtn.Text = "SPEED"
	end
end)

-- =========================
-- INF JUMP (SOURCE QUE PEDISTE)
-- =========================
local infinityJumpEnabled = false
local jumpForce = 50
local clampFallSpeed = 80

infBtn.MouseButton1Click:Connect(function()
	infinityJumpEnabled = not infinityJumpEnabled
	infBtn.Text = infinityJumpEnabled and "INF JUMP (ON)" or "INF JUMP"
end)

RunService.Heartbeat:Connect(function()
	if not infinityJumpEnabled then return end
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if hrp and hrp.Velocity.Y < -clampFallSpeed then
		hrp.Velocity = Vector3.new(hrp.Velocity.X,-clampFallSpeed,hrp.Velocity.Z)
	end
end)

UIS.JumpRequest:Connect(function()
	if not infinityJumpEnabled then return end
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.Velocity = Vector3.new(hrp.Velocity.X,jumpForce,hrp.Velocity.Z)
	end
end)

-- =========================
-- ESP (Players en rojo con Highlight)
-- =========================
local espEnabled = false
local highlights = {}

local function addESP(plr)
	if plr.Character then
		local h = Instance.new("Highlight")
		h.FillColor = Color3.fromRGB(255,0,0)
		h.OutlineColor = Color3.fromRGB(255,0,0)
		h.Parent = plr.Character
		highlights[plr] = h
	end
end

local function removeESP()
	for _,h in pairs(highlights) do
		h:Destroy()
	end
	highlights = {}
end

espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	if espEnabled then
		for _,plr in pairs(Players:GetPlayers()) do
			if plr ~= player then
				addESP(plr)
			end
		end
		espBtn.Text = "ESP (ON)"
	else
		removeESP()
		espBtn.Text = "ESP"
	end
end)

Players.PlayerAdded:Connect(function(plr)
	if espEnabled then
		plr.CharacterAdded:Connect(function()
			addESP(plr)
		end)
	end
end)

-- =========================
-- FIX LAG (modo carton + más fluido)
-- =========================
local fixOn = false

fixBtn.MouseButton1Click:Connect(function()
	fixOn = not fixOn
	if fixOn then
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 1e5
		for _,v in pairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Material = Enum.Material.Cardboard
				v.Reflectance = 0
			end
		end
		fixBtn.Text = "FIX LAG (ON)"
	else
		Lighting.GlobalShadows = true
		fixBtn.Text = "FIX LAG"
	end
end)

print("🔥 YOU VS HOMER HUB cargado completo")
