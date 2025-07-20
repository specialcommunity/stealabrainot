-- AI PANEL - ADVANCED GUI SYSTEM + TELEPORT + SPEED + NOCLIP + GODMODE + ESP
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local players = game:GetService("Players")

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- VARIABLES
local currentSpeed = humanoid.WalkSpeed
local noclip = false
local fullNoclip = false
local savedLocation = nil
local cancelReturn = false
local cancelCheckActive = false
local godModeActive = false
local espEnabled = false
local espObjects = {}

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AI_PANEL"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 420)
frame.Position = UDim2.new(0.05, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = frame

local function createLabel(text, pos)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0, 80, 0, 25)
	label.Position = pos
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.Gotham
	label.TextSize = 16
	label.Parent = frame
	return label
end

local function createButton(text, pos, color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 210, 0, 32)
	btn.Position = pos
	btn.Text = text
	btn.BackgroundColor3 = color or Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	btn.Parent = frame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn

	return btn
end

-- SPEED
createLabel("Speed:", UDim2.new(0, 10, 0, 10))
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0, 130, 0, 25)
speedBox.Position = UDim2.new(0, 90, 0, 10)
speedBox.Text = tostring(currentSpeed)
speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 16
speedBox.Parent = frame

local function applySpeed(val)
	currentSpeed = val
	if humanoid then humanoid.WalkSpeed = currentSpeed end
end

speedBox.FocusLost:Connect(function(enter)
	if enter then
		local val = tonumber(speedBox.Text)
		if val and val > 0 and val < 1000 then
			applySpeed(val)
		else
			speedBox.Text = tostring(currentSpeed)
		end
	end
end)

player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	applySpeed(currentSpeed)
	noclip = false
	fullNoclip = false
	noclipBtn.Text = "NoClip: OFF"
end)

-- NOCLIP
local noclipBtn = createButton("NoClip: OFF", UDim2.new(0, 10, 0, 45))
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	fullNoclip = false
	noclipBtn.Text = "NoClip: " .. (noclip and "ON" or "OFF")
end)

local fullNoclipBtn = createButton("Full NoClip: OFF", UDim2.new(0, 10, 0, 85))
fullNoclipBtn.MouseButton1Click:Connect(function()
	fullNoclip = not fullNoclip
	noclip = false
	fullNoclipBtn.Text = "Full NoClip: " .. (fullNoclip and "ON" or "OFF")
end)

runService.Stepped:Connect(function()
	if (noclip or fullNoclip) and character then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
				if fullNoclip then part.Transparency = 0.5 end
			end
		end
	end
end)

-- SAVE LOCATION
local saveBtn = createButton("Save Location", UDim2.new(0, 10, 0, 125), Color3.fromRGB(0,130,0))
saveBtn.MouseButton1Click:Connect(function()
	local root = character:FindFirstChild("HumanoidRootPart")
	if root then
		savedLocation = root.Position
		saveBtn.Text = "Saved!"
		task.wait(1)
		saveBtn.Text = "Save Location"
	end
end)

-- CANCEL RETURN CHECK
UIS.InputBegan:Connect(function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.E and cancelCheckActive then
		cancelReturn = true
	end
end)

-- GODMODE FUNCTION
local function enableTemporaryGodmode()
	if not humanoid or godModeActive then return end
	godModeActive = true
	humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)

	task.delay(5, function()
		if humanoid then
			humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
		end
		godModeActive = false
	end)
end

-- TELEPORT TO SAVED LOCATION (INVISIBLE + GODMODE)
local tpBtn = createButton("Teleport to Saved", UDim2.new(0, 10, 0, 165), Color3.fromRGB(130, 100, 0))
tpBtn.MouseButton1Click:Connect(function()
	local root = character:FindFirstChild("HumanoidRootPart")
	if savedLocation and root then
		local prev = root.Position
		enableTemporaryGodmode()
		root.CFrame = CFrame.new(savedLocation - Vector3.new(0, 3, 0))
		cancelReturn = false
		cancelCheckActive = true
		tpBtn.Text = "Returning in 1s... (Press E to cancel)"
		task.delay(1, function()
			if not cancelReturn and cancelCheckActive then
				root.CFrame = CFrame.new(prev)
				tpBtn.Text = "Teleport to Saved"
			elseif cancelReturn then
				tpBtn.Text = "Stayed at Location"
			end
			cancelCheckActive = false
		end)
	end
end)

-- ESP FUNCTION
local function toggleESP()
	espEnabled = not espEnabled

	for _, obj in pairs(espObjects) do
		if obj and obj.Adornee then
			obj:Destroy()
		end
	end

table.clear(espObjects)

	if espEnabled then
		for _, plr in pairs(players:GetPlayers()) do
			if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				local box = Instance.new("BillboardGui")
				box.Size = UDim2.new(0, 100, 0, 40)
				box.AlwaysOnTop = true
				box.Adornee = plr.Character.HumanoidRootPart
				box.Parent = gui

				local text = Instance.new("TextLabel")
				text.Size = UDim2.new(1, 0, 1, 0)
				text.BackgroundTransparency = 1
				text.Text = plr.Name
				text.TextColor3 = Color3.new(1, 0, 0)
				text.Font = Enum.Font.GothamBold
				text.TextScaled = true
				text.Parent = box

				table.insert(espObjects, box)
			end
		end
	end
end

local espBtn = createButton("ESP: OFF", UDim2.new(0, 10, 0, 205), Color3.fromRGB(0, 80, 140))
espBtn.MouseButton1Click:Connect(function()
	toggleESP()
	espBtn.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
end)

-- PANEL TITLE
local info = Instance.new("TextLabel")
info.Size = UDim2.new(0, 210, 0, 30)
info.Position = UDim2.new(0, 10, 0, 370)
info.BackgroundTransparency = 1
info.Text = "AI Panel - Advanced TP, Speed, NoClip, ESP"
info.TextColor3 = Color3.new(1, 1, 1)
info.Font = Enum.Font.GothamItalic
info.TextSize = 14
info.Parent = frame
