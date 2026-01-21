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
local tpSafeOn,tpOn,speedOn,wallHopOn = false,false,false,false
local normalSpeed = 16
local lobbyPos = nil
local lastPos = nil

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
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	if tpSafeOn then
		if LocalPlayer.Team and LocalPlayer.Team.Name == "Bart" then
			lastPos = hrp.CFrame
			if lobbyPos then hrp.CFrame = lobbyPos end
		end
	else
		if lastPos then
			hrp.CFrame = lastPos
			lastPos = nil
		end
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
	if not wallHopOn then return end
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
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
-- ESP FINAL CORRECTO
-------------------------------------------------
local espEnabled = false
local espCache = {}

local function clearESP()
	for _,v in pairs(espCache) do
		if v.box then v.box:Destroy() end
		if v.name then v.name:Destroy() end
	end
	espCache = {}
end

local function validTarget(plr)
	if plr == LocalPlayer then return false end
	if not plr.Team or plr.Team.Name == "Muerto" then return false end
	if not plr.Character then return false end

	local hum = plr.Character:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 then return false end

	return plr.Team.Name == "Bart" or plr.Team.Name == "Homer"
end

local function canSee()
	return LocalPlayer.Team and LocalPlayer.Team.Name ~= "Muerto"
end

local function createESP(plr)
	if espCache[plr] then return end
	if not validTarget(plr) or not canSee() then return end

	local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local color = plr.Team.Name == "Bart"
		and Color3.fromRGB(0,120,255)
		or Color3.fromRGB(255,0,0)

	local box = Instance.new("BoxHandleAdornment")
	box.Adornee = hrp
	box.Size = Vector3.new(4,6,4)
	box.AlwaysOnTop = true
	box.Transparency = 0.35
	box.ZIndex = 10
	box.Color3 = color
	box.Parent = Workspace

	local gui = Instance.new("BillboardGui")
	gui.Adornee = hrp
	gui.Size = UDim2.new(0,100,0,20)
	gui.StudsOffset = Vector3.new(0,4,0)
	gui.AlwaysOnTop = true
	gui.Parent = Workspace

	local txt = Instance.new("TextLabel", gui)
	txt.Size = UDim2.new(1,0,1,0)
	txt.BackgroundTransparency = 1
	txt.Text = plr.Name
	txt.TextColor3 = color
	txt.TextStrokeTransparency = 0
	txt.TextScaled = true
	txt.Font = Enum.Font.GothamBold

	espCache[plr] = {box=box,name=gui}
end

local function updateESP()
	if not espEnabled or not canSee() then
		clearESP()
		return
	end

	for plr,data in pairs(espCache) do
		if not validTarget(plr) then
			if data.box then data.box:Destroy() end
			if data.name then data.name:Destroy() end
			espCache[plr] = nil
		end
	end

	for _,plr in pairs(Players:GetPlayers()) do
		if validTarget(plr) then
			createESP(plr)
		end
	end
end

ESPBtn.MouseButton1Click:Connect(function()
	sound()
	espEnabled = not espEnabled
	ESPBtn.Text = "ESP ["..(espEnabled and "ON" or "OFF").."]"
	if not espEnabled then clearESP() end
end)

RunService.Heartbeat:Connect(updateESP)

-------------------------------------------------
-- MINIMIZAR / MAXIMIZAR
-------------------------------------------------
local open = true
minimize.MouseButton1Click:Connect(function()
	sound()
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
end)
