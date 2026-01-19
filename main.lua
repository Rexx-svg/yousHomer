--// HAROLD TOP 😹
--// Full GUI + Sources (TP Lobby, Speed, Wallhop, Wallhack)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
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
main.Size = UDim2.new(0, 210, 0, 220)
main.Position = UDim2.new(0.5, -105, 0.5, -110)
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
-- BUTTONS
-------------------------------------------------
local TPLobbyBtn = button("TP LOBBY", 45)
local SpeedBtn  = button("SPEED", 85)
local WallhopBtn = button("WALLHOP", 125)
local WallhackBtn = button("WALLHACK", 165)

-------------------------------------------------
-- STATES
-------------------------------------------------
local tpOn, speedOn, wallhopOn, wallhackOn = false,false,false,false
local normalSpeed = 16
local respawnCF = nil

-------------------------------------------------
-- TP LOBBY
-------------------------------------------------
LocalPlayer.CharacterAdded:Connect(function(char)
	if respawnCF then
		task.wait(0.5)
		local hrp = char:WaitForChild("HumanoidRootPart")
		hrp.CFrame = respawnCF
	end
end)

TPLobbyBtn.MouseButton1Click:Connect(function()
	sound()
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	respawnCF = hrp.CFrame
	tpOn = true
	TPLobbyBtn.Text = "TP LOBBY [ON]"
	TPLobbyBtn.BackgroundColor3 = Color3.fromRGB(0,120,255)
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
	SpeedBtn.BackgroundColor3 = speedOn and Color3.fromRGB(0,120,255) or Color3.fromRGB(40,0,0)
end)

-------------------------------------------------
-- WALLHOP (Inf Jump)
-------------------------------------------------
local jumpForce = 50
local clampFallSpeed = 80
WallhopBtn.MouseButton1Click:Connect(function()
	sound()
	wallhopOn = not wallhopOn
	WallhopBtn.Text = "WALLHOP ["..(wallhopOn and "ON" or "OFF").."]"
	WallhopBtn.BackgroundColor3 = wallhopOn and Color3.fromRGB(0,120,255) or Color3.fromRGB(40,0,0)
end)

RunService.Heartbeat:Connect(function()
	if not wallhopOn then return end
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp and hrp.Velocity.Y < -clampFallSpeed then
		hrp.Velocity = Vector3.new(hrp.Velocity.X, -clampFallSpeed, hrp.Velocity.Z)
	end
end)

UserInputService.JumpRequest:Connect(function()
	if not wallhopOn then return end
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.Velocity = Vector3.new(hrp.Velocity.X, jumpForce, hrp.Velocity.Z)
	end
end)

-------------------------------------------------
-- WALLHACK (Noclip)
-------------------------------------------------
WallhackBtn.MouseButton1Click:Connect(function()
	sound()
	wallhackOn = not wallhackOn
	WallhackBtn.Text = "WALLHACK ["..(wallhackOn and "ON" or "OFF").."]"
	WallhackBtn.BackgroundColor3 = wallhackOn and Color3.fromRGB(0,120,255) or Color3.fromRGB(40,0,0)
end)

RunService.Heartbeat:Connect(function()
	if wallhackOn then
		local char = LocalPlayer.Character
		if not char then return end
		for _,part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)
