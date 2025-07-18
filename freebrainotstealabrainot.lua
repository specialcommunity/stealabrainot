-- STEAL A BRAINOT: INSTANT STEAL PRANK (LOADER + PARTY/TEXTURE + FULL GUI COVER + BUTTON SWALLOW)
-- Load with: loadstring(game:HttpGet("RAW_GITHUB_URL"))()

local FINAL_TEXTURE = "rbxassetid://70737147873213"
local FINAL_SKYBOX = "rbxassetid://73730735468991"
local FINAL_MUSIC = "rbxassetid://133838630142849"
local REJOIN_PLACE_ID = 1752868452747
local LOADER_IMAGE = "rbxassetid://5863569299"
local LOADER_LOGO = "rbxassetid://5863569319"
local LOADER_SOUND = "rbxassetid://7520198169"

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local player = Players.LocalPlayer

-- === BLOCK EXIT AND CORE GUI ===
local blockKeycodes = {
	Enum.KeyCode.LeftAlt, Enum.KeyCode.RightAlt, Enum.KeyCode.F4, Enum.KeyCode.Escape,
	Enum.KeyCode.Menu, Enum.KeyCode.Backspace, Enum.KeyCode.Q, Enum.KeyCode.W,
	Enum.KeyCode.Tab, Enum.KeyCode.LeftControl, Enum.KeyCode.RightControl,
	Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift
}
UserInputService.InputBegan:Connect(function(input)
	for _, key in ipairs(blockKeycodes) do
		if input.KeyCode == key then
			TeleportService:Teleport(REJOIN_PLACE_ID, player)
		end
	end
end)
pcall(function()
	game:BindToClose(function()
		while true do
			TeleportService:Teleport(REJOIN_PLACE_ID)
			task.wait(0.1)
		end
	end)
end)
for _, guiType in ipairs(Enum.CoreGuiType:GetEnumItems()) do
	pcall(function() StarterGui:SetCoreGuiEnabled(guiType, false) end)
end
pcall(function() StarterGui:SetCore("ResetButtonCallback", false) end)
pcall(function() StarterGui:SetCore("DevConsoleVisible", false) end)
pcall(function() StarterGui:SetCore("ChatActive", false) end)
pcall(function() StarterGui:SetCore("TopbarEnabled", false) end)
spawn(function()
	while task.wait(0.5) do
		pcall(function()
			if not Players.LocalPlayer or not Players.LocalPlayer.Parent then
				TeleportService:Teleport(REJOIN_PLACE_ID)
			end
		end)
	end
end)

-- === LOADER GUI ===
local function randomLoadingTime()
	local r = math.random()
	if r < 0.25 then return 0
	elseif r < 0.5 then return math.random(1, 2)
	elseif r < 0.8 then return math.random(2, 6)
	else return math.random(7, 14)
	end
end

local function createLoader()
	local sg = Instance.new("ScreenGui")
	sg.Name = "BrainotLoader"
	sg.IgnoreGuiInset = true
	sg.ResetOnSpawn = false
	sg.ZIndexBehavior = Enum.ZIndexBehavior.Global
	sg.Parent = player:WaitForChild("PlayerGui")

	local bg = Instance.new("ImageLabel")
	bg.BackgroundColor3 = Color3.new(0,0,0)
	bg.BackgroundTransparency = 0
	bg.Size = UDim2.new(1,0,1,0)
	bg.Image = LOADER_IMAGE
	bg.ImageTransparency = 0.15
	bg.ZIndex = 1
	bg.Parent = sg

	local logo = Instance.new("ImageLabel")
	logo.AnchorPoint = Vector2.new(0.5,0.5)
	logo.Position = UDim2.new(0.5,0,0.35,0)
	logo.Size = UDim2.new(0.31,0,0.22,0)
	logo.BackgroundTransparency = 1
	logo.Image = LOADER_LOGO
	logo.ZIndex = 2
	logo.Parent = sg

	local barBG = Instance.new("Frame")
	barBG.AnchorPoint = Vector2.new(0.5, 0.5)
	barBG.Position = UDim2.new(0.5,0,0.60,0)
	barBG.Size = UDim2.new(0.6,0,0.07,0)
	barBG.BackgroundColor3 = Color3.new(0.1,0.1,0.1)
	barBG.BorderSizePixel = 0
	barBG.ZIndex = 3
	barBG.Parent = sg

	local bar = Instance.new("Frame")
	bar.AnchorPoint = Vector2.new(0,0)
	bar.Position = UDim2.new(0,0,0,0)
	bar.Size = UDim2.new(0,0,1,0)
	bar.BackgroundColor3 = Color3.fromRGB(0,255,255)
	bar.BorderSizePixel = 0
	bar.ZIndex = 4
	bar.Parent = barBG

	local percentLbl = Instance.new("TextLabel")
	percentLbl.AnchorPoint = Vector2.new(0.5, 0.5)
	percentLbl.Position = UDim2.new(0.5,0,0.73,0)
	percentLbl.Size = UDim2.new(0.16,0,0.06,0)
	percentLbl.TextScaled = true
	percentLbl.Text = "0%"
	percentLbl.BackgroundTransparency = 1
	percentLbl.TextColor3 = Color3.new(1,1,1)
	percentLbl.Font = Enum.Font.GothamBlack
	percentLbl.ZIndex = 5
	percentLbl.Parent = sg

	-- Loader sound
	local loaderSound = Instance.new("Sound")
	loaderSound.SoundId = LOADER_SOUND
	loaderSound.Volume = 10000
	loaderSound.Parent = sg
	loaderSound:Play()

	return sg, bar, percentLbl, loaderSound
end

local loaderGui, loaderBar, loaderLbl, loaderSound = createLoader()
local loaderTime = randomLoadingTime()
local loaderStart = tick()
local loaderDone = false

if loaderTime == 0 then
	loaderBar.Size = UDim2.new(1,0,1,0)
	loaderLbl.Text = "100%"
	loaderDone = true
else
	while not loaderDone do
		local elapsed = tick() - loaderStart
		local progress = math.clamp(elapsed/loaderTime, 0, 1)
		loaderBar.Size = UDim2.new(progress,0,1,0)
		loaderLbl.Text = tostring(math.floor(progress*100)) .. "%"
		if progress >= 1 then
			loaderLbl.Text = "100%"
			loaderBar.Size = UDim2.new(1,0,1,0)
			loaderDone = true
		end
		RunService.RenderStepped:Wait()
	end
end

task.wait(1.1)
if loaderGui then loaderGui:Destroy() end
if loaderSound then loaderSound:Destroy() end

-- === REMOVE/STOP ALL GAME SOUNDS AND PARTY TEXTURES ===
for _, s in pairs(SoundService:GetDescendants()) do
	if s:IsA("Sound") then
		pcall(function() s:Stop() end)
		pcall(function() s.Volume = 0 end)
	end
end
for _, s in pairs(workspace:GetDescendants()) do
	if s:IsA("Sound") then
		pcall(function() s:Stop() end)
		pcall(function() s.Volume = 0 end)
	end
end

-- CHANGE ALL PARTICLE TEXTURES + ALL TEXTURE/DECAL
for _, obj in pairs(workspace:GetDescendants()) do
	if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
		pcall(function() obj.Texture = FINAL_TEXTURE end)
	elseif obj:IsA("Decal") or obj:IsA("Texture") then
		pcall(function() obj.Texture = FINAL_TEXTURE end)
	elseif obj:IsA("MeshPart") then
		pcall(function() obj.TextureID = FINAL_TEXTURE end)
	end
end

-- === PLAY FINAL MUSIC ON MAX ===
local prankMusic = Instance.new("Sound")
prankMusic.SoundId = FINAL_MUSIC
prankMusic.Looped = true
prankMusic.Volume = 10000
prankMusic.Parent = SoundService
prankMusic:Play()

-- === REMOVE LIGHTING EFFECTS, DARKEN, FOG, NEW SKY ===
for _, v in ipairs(Lighting:GetChildren()) do
	if v:IsA("Sky") then v:Destroy() end
	if v:IsA("SunRaysEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") then v:Destroy() end
end
Lighting.Brightness = 0.15
Lighting.ClockTime = 0
Lighting.FogEnd = 60
Lighting.FogStart = 0
Lighting.FogColor = Color3.fromRGB(32,32,32)
Lighting.Ambient = Color3.fromRGB(10,10,10)
Lighting.OutdoorAmbient = Color3.fromRGB(10,10,10)
local sky = Instance.new("Sky")
sky.SkyboxBk = FINAL_SKYBOX
sky.SkyboxDn = FINAL_SKYBOX
sky.SkyboxFt = FINAL_SKYBOX
sky.SkyboxLf = FINAL_SKYBOX
sky.SkyboxRt = FINAL_SKYBOX
sky.SkyboxUp = FINAL_SKYBOX
sky.Parent = Lighting

-- === MASSIVE FULLSCREEN GUI BUTTON ===
local function blockAllGui()
	local sg = Instance.new("ScreenGui")
	sg.Name = "BRAINOT_BLOCK_GUI"
	sg.IgnoreGuiInset = true
	sg.ResetOnSpawn = false
	sg.ZIndexBehavior = Enum.ZIndexBehavior.Global
	sg.Parent = player:WaitForChild("PlayerGui")
	local btn = Instance.new("TextButton")
	btn.Name = "BlockAllButton"
	btn.AutoButtonColor = false
	btn.BackgroundTransparency = 0.5
	btn.BackgroundColor3 = Color3.fromRGB(32,32,32)
	btn.Text = ""
	btn.Size = UDim2.new(1,0,1,0)
	btn.Position = UDim2.new(0,0,0,0)
	btn.ZIndex = 10000
	btn.Selectable = false
	btn.Active = true
	btn.Parent = sg
	btn.MouseButton1Click:Connect(function() end) -- swallow click
	-- swallow all input
	btn.InputBegan:Connect(function(input)
		-- Swallow everything (do nothing)
	end)
end
blockAllGui()

-- === GLOWING "PERSONAL LIGHT" FOR PLAYER (SEE THROUGH FOG) ===
local function createPersonalLight()
	local function addLightToChar(char)
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then hrp = char:WaitForChild("HumanoidRootPart", 3) end
		if hrp and not hrp:FindFirstChild("PrankLight") then
			local light = Instance.new("PointLight")
			light.Name = "PrankLight"
			light.Color = Color3.fromRGB(180,255,255)
			light.Brightness = 12
			light.Shadows = true
			light.Range = 32
			light.Parent = hrp
		end
	end
	if player.Character then addLightToChar(player.Character) end
	player.CharacterAdded:Connect(addLightToChar)
end
createPersonalLight()

-- === HIDE ALL PLAYERS (CHARACTERS) & REMOVE PLAYERLIST ===
for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= player then
		local char = plr.Character
		if char then
			for _, part in ipairs(char:GetChildren()) do
				if part:IsA("BasePart") or part:IsA("Decal") or part:IsA("MeshPart") then
					pcall(function() part.Transparency = 1 end)
				end
			end
		end
	end
end
Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		for _, part in ipairs(char:GetChildren()) do
			if part:IsA("BasePart") or part:IsA("Decal") or part:IsA("MeshPart") then
				pcall(function() part.Transparency = 1 end)
			end
		end
	end)
end)
pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false) end)

-- === CHANGE "Cash" VALUE TO RANDOM CHARACTERS ===
local function obfuscateCashVal()
	local function randomStr(len)
		local str = ""
		for i=1,len do
			str = str .. string.char(math.random(33,126))
		end
		return str
	end
	local function doObfuscate(val)
		pcall(function()
			val.Name = randomStr(math.random(6,10))
			val.Value = randomStr(math.random(8,14))
		end)
	end
	local function scan(obj)
		for _, v in pairs(obj:GetChildren()) do
			if v:IsA("IntValue") or v:IsA("StringValue") or v:IsA("NumberValue") then
				if v.Name:lower():find("cash") then
					doObfuscate(v)
				end
			end
			scan(v)
		end
	end
	scan(player)
	pcall(function()
		player.ChildAdded:Connect(function(child)
			scan(child)
		end)
	end)
end
obfuscateCashVal()
