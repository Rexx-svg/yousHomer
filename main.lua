--------------------------------------------------
-- DESYNC MENU (APARTADO ESTILO CAT HUB)
--------------------------------------------------
local desyncFrame = Instance.new("Frame", gui)
desyncFrame.Size = UDim2.fromScale(0.3,0.2)
desyncFrame.Position = UDim2.fromScale(0.35,0.1)
desyncFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
desyncFrame.BorderSizePixel = 0
desyncFrame.Visible = true
Instance.new("UICorner", desyncFrame).CornerRadius = UDim.new(0,18)

-- TITULO
local desyncTitle = Instance.new("TextLabel", desyncFrame)
desyncTitle.Size = UDim2.fromScale(1,0.3)
desyncTitle.BackgroundTransparency = 1
desyncTitle.Text = "DESYNC MENU"
desyncTitle.Font = Enum.Font.GothamBlack
desyncTitle.TextScaled = true
desyncTitle.TextColor3 = Color3.fromRGB(255,90,90)

-- BOTON DESYNC
local desyncBtn = Instance.new("TextButton", desyncFrame)
desyncBtn.Size = UDim2.fromScale(0.9,0.5)
desyncBtn.Position = UDim2.fromScale(0.05,0.4)
desyncBtn.Text = "DESYNC"
desyncBtn.Font = Enum.Font.GothamBold
desyncBtn.TextScaled = true
desyncBtn.TextSize = 28
desyncBtn.TextColor3 = Color3.new(1,1,1)
desyncBtn.BackgroundColor3 = Color3.fromRGB(255,50,50)
desyncBtn.BorderSizePixel = 0
Instance.new("UICorner", desyncBtn).CornerRadius = UDim.new(0,14)

-- DRAG DESYNC FRAME
local dragging, dragStart, startPos
desyncFrame.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = i.Position
		startPos = desyncFrame.Position
	end
end)

UIS.InputChanged:Connect(function(i)
	if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
		local d = i.Position - dragStart
		desyncFrame.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
	end
end)

UIS.InputEnded:Connect(function() dragging = false end)

-- ACCION DEL BOTON DESYNC
desyncBtn.MouseButton1Click:Connect(function()
	click()
	if not char then return end
	local hrp = char:WaitForChild("HumanoidRootPart")
	local humanoid = char:WaitForChild("Humanoid")

	-- Clonar cuerpo para apariencia visual
	local clone = char:Clone()
	for _, part in pairs(clone:GetChildren()) do
		if part:IsA("BasePart") then
			part.Anchored = true
		elseif part:IsA("Humanoid") then
			part.Health = 0
		end
	end
	clone.Parent = workspace

	-- Hacer cuerpo real invisible
	for _, part in pairs(char:GetChildren()) do
		if part:IsA("BasePart") then
			part.Transparency = 1
			part.CanCollide = false
		elseif part:IsA("Humanoid") then
			part.PlatformStand = true
		end
	end

	-- Mantener HRP real controlable
	RunService.Heartbeat:Connect(function()
		if humanoid.Health > 0 then
			hrp.CFrame = hrp.CFrame -- tu HRP sigue moviéndose con otros scripts
		end
	end)
end)
