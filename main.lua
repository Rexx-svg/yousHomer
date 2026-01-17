-- YOU VS HOMER HUB
-- By Jorge ad 🔥

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

------------------------------------------------
-- GUI
------------------------------------------------
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "YouVsHomerHub"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 260, 0, 0)
main.Position = UDim2.fromScale(0.35, 0.25)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel = 0
main.AutomaticSize = Enum.AutomaticSize.Y
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

-- HEADER
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,0,0,36)
header.BackgroundColor3 = Color3.fromRGB(230,230,230)
header.BorderSizePixel = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,-40,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "YOU VS HOMER HUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(0,0,0)
title.TextXAlignment = Left

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
local container = Instance.new("Frame", main)
container.Position = UDim2.new(0,8,0,42)
container.Size = UDim2.new(1,-16,0,0)
container.AutomaticSize = Enum.AutomaticSize.Y
container.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0,6)

------------------------------------------------
-- BOTONES
------------------------------------------------
local function createButton(txt)
	local b = Instance.new("TextButton", container)
	b.Size = UDim2.new(1,0,0,40)
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	b.Text = txt
	b.Font = Enum.Font.GothamBold
	b.TextSize = 18
	b.TextColor3 = Color3.new(1,1,1)
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	return b
end

local tpBtn   = createButton("TP LOBBY")
local speedBtn= createButton("SPEED")
local infBtn  = createButton("INF JUMP")
local espBtn  = createButton("ESP")
local lagBtn  = createButton("FIX LAG")

------------------------------------------------
-- MINIMIZAR + / -
------------------------------------------------
local minimized = false
toggleBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	container.Visible = not minimized
	toggleBtn.Text = minimized and "+" or "-"
end)

------------------------------------------------
-- TP LOBBY
------------------------------------------------
local lobbyCFrame
local firstSpawn = true

player.CharacterAdded:Connect(function(char)
	local hrp = char:WaitForChild("HumanoidRootPart")
	if firstSpawn then
		lobbyCFrame = hrp.CFrame
		firstSpawn = false
	end
end)

tpBtn.MouseButton1Click:Connect(function()
	local char = player.Character
	if char and lobbyCFrame then
		char:WaitForChild("HumanoidRootPart").CFrame = lobbyCFrame
	end
end)

------------------------------------------------
-- SPEED (+35%)
------------------------------------------------
local speedOn = false
local defaultSpeed = 16
local speedMultiplier = 1.35

speedBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	speedBtn.Text = speedOn and "SPEED (ON)" or "SPEED"

	local char = player.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.WalkSpeed = speedOn and (defaultSpeed * speedMultiplier) or defaultSpeed
		end
	end
end)

------------------------------------------------
-- INF JUMP (rznnq source con ON/OFF)
------------------------------------------------
local infinityJumpEnabled = false
local jumpForce = 50
local clampFallSpeed = 80

infBtn.MouseButton1Click:Connect(function()
	infinityJumpEnabled = not infinityJumpEnabled
	infBtn.Text = infinityJumpEnabled and "INF JUMP (ON)" or "INF JUMP"
end)

RunService.Heartbeat:Connect(function()
	if not infinityJumpEnabled then return end
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp and hrp.Velocity.Y < -clampFallSpeed then
		hrp.Velocity = Vector3.new(hrp.Velocity.X, -clampFallSpeed, hrp.Velocity.Z)
	end
end)

UserInputService.JumpRequest:Connect(function()
	if not infinityJumpEnabled then return end
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.Velocity = Vector3.new(hrp.Velocity.X, jumpForce, hrp.Velocity.Z)
	end
end)

------------------------------------------------
-- ESP (Highlight + Hitbox rojo)
------------------------------------------------
local espEnabled = false
local espFolder = Instance.new("Folder", gui)
espFolder.Name = "ESPFolder"

local function addESP(plr)
	if plr == player then return end
	local char = plr.Character
	if not char then return end

	local h = Instance.new("Highlight")
	h.Adornee = char
	h.FillColor = Color3.fromRGB(255,0,0)
	h.OutlineColor = Color3.fromRGB(255,0,0)
	h.Parent = espFolder

	local root = char:FindFirstChild("HumanoidRootPart")
	if root then
		local box = Instance.new("BoxHandleAdornment")
		box.Adornee = root
		box.Size = root.Size + Vector3.new(1,2,1)
		box.Color3 = Color3.fromRGB(255,0,0)
		box.Transparency = 0.5
		box.AlwaysOnTop = true
		box.ZIndex = 10
		box.Parent = espFolder
	end
end

espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espBtn.Text = espEnabled and "ESP (ON)" or "ESP"

	if espEnabled then
		for _,plr in pairs(Players:GetPlayers()) do
			addESP(plr)
		end
	else
		espFolder:ClearAllChildren()
	end
end)

------------------------------------------------
-- FIX LAG (textura “sin cargar” + restaurar)
------------------------------------------------
local lagFixEnabled = false
local saved = {}

lagBtn.MouseButton1Click:Connect(function()
	lagFixEnabled = not lagFixEnabled
	lagBtn.Text = lagFixEnabled and "FIX LAG (ON)" or "FIX LAG"

	if lagFixEnabled then
		for _,v in pairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") then
				saved[v] = {Material = v.Material, Color = v.Color}
				v.Material = Enum.Material.Plastic
				v.Color = Color3.fromRGB(200,200,200)
			end
		end
	else
		for obj,data in pairs(saved) do
			if obj and obj.Parent then
				obj.Material = data.Material
				obj.Color = data.Color
			end
		end
		saved = {}
	end
end)

print("🔥 YOU VS HOMER HUB CARGADO COMPLETO 🔥")
