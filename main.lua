--// SERVICIOS
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

--// GUARDAR LOBBY
local lobbyCFrame
local firstSpawn = true

player.CharacterAdded:Connect(function(char)
	task.wait(1)
	local hrp = char:WaitForChild("HumanoidRootPart")
	if firstSpawn then
		lobbyCFrame = hrp.CFrame
		firstSpawn = false
	end
end)

--// GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "MenuUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,240)
frame.Position = UDim2.new(0.4,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0

--// HEADER
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1,0,0,40)
header.BackgroundColor3 = Color3.fromRGB(20,20,20)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,-40,1,0)
title.Position = UDim2.new(0,10,0,0)
title.Text = "you vs homer V1.0"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left

local minimize = Instance.new("TextButton", header)
minimize.Size = UDim2.new(0,30,1,0)
minimize.Position = UDim2.new(1,-30,0,0)
minimize.Text = "-"
minimize.TextColor3 = Color3.fromRGB(255,255,255)
minimize.BackgroundTransparency = 1
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 20

--// BOTONES
local buttons = {}

local function createButton(text)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0,200,0,40)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.BorderSizePixel = 0
	b.Text = text
	table.insert(buttons,b)
	return b
end

local tpBtn    = createButton("TP SALVO")
local wallBtn  = createButton("WALL HACK")
local jumpBtn  = createButton("INF JUMP")
local shiftBtn = createButton("SHIFT LOCK")

--// POSICIÓN BOTONES
local padding = 10
local startY = 50

for i,btn in ipairs(buttons) do
	btn.Position = UDim2.new(0,30,0,startY + ((i-1)*(40+padding)))
end

local totalHeight = startY + (#buttons*(40+padding))
frame.Size = UDim2.new(0,260,0,totalHeight)

--// MINIMIZAR
local minimized = false
local fullSize = frame.Size

minimize.MouseButton1Click:Connect(function()
	minimized = not minimized

	if minimized then
		for _,b in pairs(buttons) do
			b.Visible = false
		end
		frame.Size = UDim2.new(0,260,0,40)
		minimize.Text = "+"
	else
		for _,b in pairs(buttons) do
			b.Visible = true
		end
		frame.Size = fullSize
		minimize.Text = "-"
	end
end)

------------------------------------------------
-- TP LOBBY
------------------------------------------------
tpBtn.MouseButton1Click:Connect(function()
	local char = player.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if hrp and lobbyCFrame then
		hrp.CFrame = lobbyCFrame
	end
end)

------------------------------------------------
-- WALL HACK
------------------------------------------------
local noclip = false
local noclipConn

wallBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	wallBtn.Text = noclip and "WALL HACK: ON" or "WALL HACK"

	if noclip then
		noclipConn = RunService.Stepped:Connect(function()
			for _,v in pairs(workspace:GetDescendants()) do
				if v:IsA("BasePart") then
					if not CollectionService:HasTag(v,"Ground") then
						v.CanCollide = false
					end
				end
			end
		end)
	else
		if noclipConn then noclipConn:Disconnect() end
		for _,v in pairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = true
			end
		end
	end
end)

------------------------------------------------
-- MULTI JUMP SEGURO (NO MATA)
------------------------------------------------
local infJump = false
local jumpCooldown = false

jumpBtn.MouseButton1Click:Connect(function()
	infJump = not infJump
	jumpBtn.Text = infJump and "MULTI JUMP: ON" or "INF JUMP"
end)

UIS.JumpRequest:Connect(function()
	if not infJump or jumpCooldown then return end

	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	local state = hum:GetState()
	if state == Enum.HumanoidStateType.Freefall
	or state == Enum.HumanoidStateType.Jumping then

		jumpCooldown = true
		hum:ChangeState(Enum.HumanoidStateType.Jumping)

		task.delay(0.15, function()
			jumpCooldown = false
		end)
	end
end)

------------------------------------------------
-- SHIFT LOCK
------------------------------------------------
local shiftIcon = Instance.new("ImageButton", gui)
shiftIcon.Size = UDim2.new(0,36,0,36)
shiftIcon.Position = UDim2.new(0.92,0,0.78,0)
shiftIcon.BackgroundColor3 = Color3.fromRGB(30,30,30)
shiftIcon.BorderSizePixel = 0
shiftIcon.Image = "rbxassetid://3926305904"
shiftIcon.ImageRectOffset = Vector2.new(4,684)
shiftIcon.ImageRectSize = Vector2.new(36,36)
shiftIcon.Visible = false
shiftIcon.Active = false

local corner = Instance.new("UICorner", shiftIcon)
corner.CornerRadius = UDim.new(1,0)

local shiftLock = false

shiftBtn.MouseButton1Click:Connect(function()
	shiftLock = not shiftLock
	shiftBtn.Text = shiftLock and "SHIFT LOCK: ON" or "SHIFT LOCK"
	shiftIcon.Visible = shiftLock

	if shiftLock then
		UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
		shiftIcon.BackgroundColor3 = Color3.fromRGB(255,255,255)
	else
		UIS.MouseBehavior = Enum.MouseBehavior.Default
		shiftIcon.BackgroundColor3 = Color3.fromRGB(30,30,30)
	end
end)

shiftIcon.MouseButton1Click:Connect(function()
	shiftLock = not shiftLock

	if shiftLock then
		UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
		shiftIcon.BackgroundColor3 = Color3.fromRGB(255,255,255)
	else
		UIS.MouseBehavior = Enum.MouseBehavior.Default
		shiftIcon.BackgroundColor3 = Color3.fromRGB(30,30,30)
	end
end)
