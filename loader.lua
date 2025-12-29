-- Warp Key System - UPDATED WITH GAME CHECK AND LOGGING
-- Enhanced with case-insensitive and space-insensitive key validation
-- Using custom notification library

local plr = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local tw = game:GetService("TweenService")
local sg = game:GetService("StarterGui")
local http = game:GetService("HttpService")
local market = game.Players.LocalPlayer

--------------------------------------------------
-- NOTIFICATION LIBRARY (Credits to blud_wtf and me)
--------------------------------------------------

local NotificationLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/your-username/your-repo/main/NotificationLib.lua"))() -- Replace with your hosted URL
-- OR use the local version below by uncommenting:

--[[
local NotificationLib = {}
local TweenService = game:GetService("TweenService")
local Players = game.Players

local CONFIG = {
	NotificationWidth = 350,
	NotificationHeight = 80,
	Padding = 10,
	InternalPadding = 10,
	IconSize = 40,
	DisplayTime = 5,
	BackgroundColor = Color3.fromRGB(45, 45, 45),
	BackgroundTransparency = 0.1,
	StrokeColor = Color3.fromRGB(80, 80, 80),
	StrokeThickness = 1,
	TextColor = Color3.fromRGB(240, 240, 240),
	TitleFont = Enum.Font.SourceSansSemibold,
	TitleSize = 18,
	ContentFont = Enum.Font.SourceSans,
	ContentSize = 15,
	EntryEasingStyle = Enum.EasingStyle.Back,
	EntryEasingDirection = Enum.EasingDirection.Out,
	EntryTime = 0.5,
	ExitEasingStyle = Enum.EasingStyle.Quad,
	ExitEasingDirection = Enum.EasingDirection.In,
	ExitTime = 0.4,
	Icons = {
		Info = "rbxassetid://112082878863231",
		Warn = "rbxassetid://117107314745025",
		Error = "rbxassetid://77067602950967",
		Success = "rbxassetid://112082878863231" -- You can replace this with a success icon
	}
}

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = nil
local notificationList = {}
local isInitialized = false

local function initializeUI()
	if isInitialized then return end
	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "EnhancedNotifUI"
	screenGui.Parent = playerGui
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.DisplayOrder = 999
	screenGui.ResetOnSpawn = false
	isInitialized = true
end

local function updateNotificationPositions()
	if not screenGui then return end
	local currentY = -CONFIG.Padding
	local itemsToRemove = {}
	for i = 1, #notificationList do
		local notifFrame = notificationList[i]
		if not notifFrame or not notifFrame.Parent then
			table.insert(itemsToRemove, i)
			continue
		end
		local targetPos = UDim2.new(1, -CONFIG.Padding, 1, currentY)
		notifFrame:TweenPosition(targetPos, Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.3, true)
		currentY = currentY - (notifFrame.AbsoluteSize.Y + CONFIG.Padding)
	end
	for i = #itemsToRemove, 1, -1 do
		table.remove(notificationList, itemsToRemove[i])
	end
end

local function createNotification(contentText, titleText, notifType)
	initializeUI()
	local frame = Instance.new("Frame")
	frame.Name = "NotificationFrame"
	frame.Position = UDim2.new(1, CONFIG.NotificationWidth + 50, 1, 0)
	frame.Size = UDim2.new(0, CONFIG.NotificationWidth, 0, CONFIG.NotificationHeight)
	frame.AnchorPoint = Vector2.new(1, 1)
	frame.BackgroundColor3 = CONFIG.BackgroundColor
	frame.BackgroundTransparency = CONFIG.BackgroundTransparency
	frame.BorderSizePixel = 0
	frame.ClipsDescendants = true
	frame.LayoutOrder = -#notificationList
	frame.Parent = screenGui
	frame.AutomaticSize = Enum.AutomaticSize.Y
	
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 6)
	uiCorner.Parent = frame
	
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = CONFIG.StrokeColor
	uiStroke.Thickness = CONFIG.StrokeThickness
	uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	uiStroke.Parent = frame
	
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingTop = UDim.new(0, CONFIG.InternalPadding)
	uiPadding.PaddingBottom = UDim.new(0, CONFIG.InternalPadding)
	uiPadding.PaddingLeft = UDim.new(0, CONFIG.InternalPadding)
	uiPadding.PaddingRight = UDim.new(0, CONFIG.InternalPadding)
	uiPadding.Parent = frame
	
	local iconImage = Instance.new("ImageLabel")
	iconImage.Name = "Icon"
	iconImage.Size = UDim2.new(0, CONFIG.IconSize, 0, CONFIG.IconSize)
	iconImage.BackgroundTransparency = 1
	iconImage.Image = CONFIG.Icons[notifType] or CONFIG.Icons.Info
	iconImage.ScaleType = Enum.ScaleType.Fit
	iconImage.AnchorPoint = Vector2.new(0, 0.5)
	iconImage.Position = UDim2.new(0, 0, 0.5, 0)
	iconImage.Parent = frame
	
	local iconAspectRatio = Instance.new("UIAspectRatioConstraint")
	iconAspectRatio.AspectRatio = 1.0
	iconAspectRatio.DominantAxis = Enum.DominantAxis.Height
	iconAspectRatio.Parent = iconImage
	
	local textFrame = Instance.new("Frame")
	textFrame.Name = "TextContainer"
	textFrame.BackgroundTransparency = 1
	textFrame.Size = UDim2.new(1, -(CONFIG.IconSize + CONFIG.InternalPadding + 5), 1, 0)
	textFrame.Position = UDim2.new(0, CONFIG.IconSize + 5, 0, 0)
	textFrame.Parent = frame
	textFrame.AutomaticSize = Enum.AutomaticSize.Y
	
	local textListLayout = Instance.new("UIListLayout")
	textListLayout.FillDirection = Enum.FillDirection.Vertical
	textListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	textListLayout.Padding = UDim.new(0, 2)
	textListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	textListLayout.Parent = textFrame
	
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Text = titleText or "Notification"
	title.Font = CONFIG.TitleFont
	title.TextSize = CONFIG.TitleSize
	title.TextColor3 = CONFIG.TextColor
	title.TextWrapped = true
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.BackgroundTransparency = 1
	title.AutomaticSize = Enum.AutomaticSize.Y
	title.Size = UDim2.new(1, 0, 0, CONFIG.TitleSize)
	title.LayoutOrder = 1
	title.Parent = textFrame
	
	local content = Instance.new("TextLabel")
	content.Name = "Content"
	content.Text = contentText or "Notification Content"
	content.Font = CONFIG.ContentFont
	content.TextSize = CONFIG.ContentSize
	content.TextColor3 = CONFIG.TextColor
	content.TextWrapped = true
	content.TextXAlignment = Enum.TextXAlignment.Left
	content.TextYAlignment = Enum.TextYAlignment.Top
	content.BackgroundTransparency = 1
	content.AutomaticSize = Enum.AutomaticSize.Y
	content.Size = UDim2.new(1, 0, 0, CONFIG.ContentSize)
	content.LayoutOrder = 2
	content.Parent = textFrame
	
	table.insert(notificationList, 1, frame)
	updateNotificationPositions()
	
	local initialTargetY = -CONFIG.Padding
	local initialTargetPos = UDim2.new(1, -CONFIG.Padding, 1, initialTargetY)
	frame:TweenPosition(initialTargetPos, CONFIG.EntryEasingDirection, CONFIG.EntryEasingStyle, CONFIG.EntryTime, true)
	
	task.delay(CONFIG.DisplayTime, function()
		if frame and frame.Parent then
			local exitPos = UDim2.new(1, CONFIG.NotificationWidth + 50, frame.Position.Y.Scale, frame.Position.Y.Offset)
			local tweenInfo = TweenInfo.new(CONFIG.ExitTime, CONFIG.ExitEasingStyle, CONFIG.ExitEasingDirection)
			local goal = { Position = exitPos, BackgroundTransparency = 1 }
			local tween = TweenService:Create(frame, tweenInfo, goal)
			
			local childrenTweens = {}
			for _, child in ipairs(frame:GetChildren()) do
				if child:IsA("GuiObject") then
					if child:IsA("UIStroke") then
						table.insert(childrenTweens, TweenService:Create(child, tweenInfo, { Transparency = 1 }))
					elseif child.Name == "Icon" and child:IsA("ImageLabel") then
						table.insert(childrenTweens, TweenService:Create(child, tweenInfo, { ImageTransparency = 1 }))
					elseif child.Name == "TextContainer" then
						for _, textChild in ipairs(child:GetChildren()) do
							if textChild:IsA("TextLabel") then
								table.insert(childrenTweens, TweenService:Create(textChild, tweenInfo, { TextTransparency = 1 }))
							end
						end
					end
				end
			end
			
			tween:Play()
			for _, childTween in ipairs(childrenTweens) do
				childTween:Play()
			end
			
			tween.Completed:Wait()
			local foundIndex = table.find(notificationList, frame)
			if foundIndex then
				table.remove(notificationList, foundIndex)
			end
			frame:Destroy()
			updateNotificationPositions()
		end
	end)
	
	return frame
end

function NotificationLib.Info(content, title)
	return createNotification(content or "Information", title or "Info", "Info")
end

function NotificationLib.Warn(content, title)
	return createNotification(content or "Warning occurred", title or "Warning", "Warn")
end

function NotificationLib.Error(content, title)
	return createNotification(content or "An error occurred", title or "Error", "Error")
end

function NotificationLib.Success(content, title)
	return createNotification(content or "Success", title or "Success", "Success")
end
]]

--------------------------------------------------
-- CONFIG
--------------------------------------------------

local CORRECT_KEY = "pineapple"
local DISCORD_LINK = "https://discord.gg/warphub"

-- SUPPORTED GAMES
local GAME_SCRIPTS = {
    [88929752766075] = "https://raw.githubusercontent.com/adubwon/geekUI/main/Games/BladeBattle.lua",
    [109397169461300] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/warp.lua",
    [286090429] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/warp.lua",
    [2788229376] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/warp.lua",
    [85509428618863] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/WormIO.lua",
    [116610479068550] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/ClassClash.lua",
    [133614490579000] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/Laser%20A%20Planet.lua",
    [8737602449] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/PlsDonate.lua",
    [292439477] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/warp.lua",
    [17625359962] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/warp.lua",
    [3623096087] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/musclelegends.lua",
    [115499966198681] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Games/My%20Brainrot%20Army.lua",
    [3678761576] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/warp.lua",
    [77888146126370] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/warp.lua",
    [1458767429] = "https://github.com/adubwon/geekUI/raw/refs/heads/main/Universal/warp.lua",
}

local CURRENT_PLACE_ID = game.PlaceId
local SCRIPT_TO_LOAD = GAME_SCRIPTS[CURRENT_PLACE_ID]

--------------------------------------------------
-- KEY VALIDATION FUNCTIONS
--------------------------------------------------

local function normalizeKey(key)
    if not key or type(key) ~= "string" then
        return ""
    end
    
    -- Remove all spaces and convert to lowercase
    local normalized = key:gsub("%s+", ""):lower()
    
    -- Also remove other whitespace characters
    normalized = normalized:gsub("\t", ""):gsub("\n", ""):gsub("\r", "")
    
    return normalized
end

local function validateKey(enteredKey)
    -- Normalize the entered key
    local normalizedEntered = normalizeKey(enteredKey)
    
    -- Normalize the correct key (for consistency)
    local normalizedCorrect = normalizeKey(CORRECT_KEY)
    
    -- Compare the normalized keys
    return normalizedEntered == normalizedCorrect, normalizedEntered
end

--------------------------------------------------
-- STORAGE
--------------------------------------------------

local KEY_STORAGE_FILE = "Warp_KeyData.json"

--------------------------------------------------
-- COLORS
--------------------------------------------------

local COLORS = {
    Primary = Color3.fromRGB(0, 150, 255),
    Secondary = Color3.fromRGB(0, 100, 200),
    Accent = Color3.fromRGB(100, 200, 255),
    Background = Color3.fromRGB(15, 15, 15),
    SecondaryBG = Color3.fromRGB(25, 25, 25),
    Frame = Color3.fromRGB(35, 35, 35),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(180, 180, 180),
    Success = Color3.fromRGB(50, 255, 50),
    Error = Color3.fromRGB(255, 50, 50),
}

--------------------------------------------------
-- NOTIFICATION FUNCTIONS
--------------------------------------------------

local function notify(title, text, type)
    type = type or "Info"
    
    if type == "Success" then
        NotificationLib.Success(text, title)
    elseif type == "Error" then
        NotificationLib.Error(text, title)
    elseif type == "Warn" then
        NotificationLib.Warn(text, title)
    else
        NotificationLib.Info(text, title)
    end
end

--------------------------------------------------
-- HELPERS
--------------------------------------------------

local function tween(obj, props, time, style)
    tw:Create(obj, TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quad), props):Play()
end

local function createCorner(obj, r)
    local c = Instance.new("UICorner", obj)
    c.CornerRadius = UDim.new(0, r or 10)
    return c
end

local function createStroke(obj, color, thickness)
    local s = Instance.new("UIStroke", obj)
    s.Color = color
    s.Thickness = thickness or 2
    return s
end

local function createGlow(parent, color)
    local g = Instance.new("ImageLabel", parent)
    g.Size = UDim2.new(1, 30, 1, 30)
    g.Position = UDim2.new(0, -15, 0, -15)
    g.BackgroundTransparency = 1
    g.Image = "rbxassetid://94551274981295"
    g.ImageColor3 = color
    g.ImageTransparency = 0.6
    g.ZIndex = 0
    return g
end

local function hover(btn, base, hover)
    btn.MouseEnter:Connect(function()
        tw:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = hover}):Play()
    end)
    btn.MouseLeave:Connect(function()
        tw:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = base}):Play()
    end)
end

--------------------------------------------------
-- FILE HANDLING
--------------------------------------------------

local function saveKeyData()
    pcall(function()
        writefile(KEY_STORAGE_FILE, http:JSONEncode({
            key_verified = true,
            user_id = plr.UserId,
            saved_key = CORRECT_KEY,
            timestamp = os.time(),
            username = plr.Name
        }))
    end)
end

local function loadKeyData()
    local success, result = pcall(function()
        if isfile(KEY_STORAGE_FILE) then
            local data = http:JSONDecode(readfile(KEY_STORAGE_FILE))
            return data.key_verified and data.user_id == plr.UserId and data.saved_key == CORRECT_KEY
        end
        return false
    end)
    return success and result
end

--------------------------------------------------
-- LOAD SCRIPT
--------------------------------------------------

local function loadMainScript()
    if not SCRIPT_TO_LOAD then
        notify("Error", "No script available for this game.", "Error")
        return
    end

    local ok, err = pcall(function()
        loadstring(game:HttpGet(SCRIPT_TO_LOAD))()
    end)

    if ok then
        notify("Success", "Script loaded successfully!", "Success")
    else
        notify("Error", tostring(err), "Error")
    end
end

--------------------------------------------------
-- BROWSER FUNCTIONS
--------------------------------------------------

local function openBrowser(url)
    -- Ensure URL has proper protocol
    if not url:match("^https?://") then
        url = "https://" .. url
    end
    
    -- Method 1: Using syn.write_clipboard with launchuri (Synapse)
    if syn and syn.write_clipboard then
        pcall(function()
            syn.write_clipboard(url)
            if launchuri then
                launchuri(url)
            end
        end)
    end
    
    -- Method 2: Using shell command (Windows)
    if os and os.execute then
        pcall(function()
            -- Common browser paths
            local browserPaths = {
                -- Opera GX
                [[C:\Users\%USERNAME%\AppData\Local\Programs\Opera GX\launcher.exe]],
                [[C:\Program Files\Opera GX\launcher.exe]],
                [[C:\Program Files (x86)\Opera GX\launcher.exe]],
                
                -- Chrome
                [[C:\Program Files\Google\Chrome\Application\chrome.exe]],
                [[C:\Program Files (x86)\Google\Chrome\Application\chrome.exe]],
                [[C:\Users\%USERNAME%\AppData\Local\Google\Chrome\Application\chrome.exe]],
                
                -- Edge
                [[C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe]],
                [[C:\Program Files\Microsoft\Edge\Application\msedge.exe]],
                
                -- Firefox
                [[C:\Program Files\Mozilla Firefox\firefox.exe]],
                [[C:\Program Files (x86)\Mozilla Firefox\firefox.exe]],
                
                -- Opera
                [[C:\Program Files\Opera\launcher.exe]],
                [[C:\Program Files (x86)\Opera\launcher.exe]],
            }
            
            -- Try each browser
            for _, path in ipairs(browserPaths) do
                local expandedPath = path:gsub("%%USERNAME%%", os.getenv("USERNAME") or "")
                local command = string.format('start "" "%s" "%s"', expandedPath, url)
                if os.execute(command) then
                    return true
                end
            end
            
            -- Fallback: Use default browser
            os.execute(string.format('start "" "%s"', url))
        end)
    end
    
    -- Method 3: Using system API (if available)
    if os and os.open then
        pcall(os.open, url)
    end
    
    -- Method 4: Using executor-specific methods
    if setclipboard then
        setclipboard(url)
    end
    
    -- Method 5: Using HTTP request as last resort
    pcall(function()
        if syn and syn.request then
            syn.request({Url = url, Method = "GET"})
        elseif request then
            request({Url = url, Method = "GET"})
        elseif http then
            http:GetAsync(url)
        end
    end)
end

--------------------------------------------------
-- CREATE UI
--------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "WarpKeySystem"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local iconBtn = Instance.new("ImageButton", gui)
iconBtn.Size = UDim2.new(0, 70, 0, 70)
iconBtn.Position = UDim2.new(0, 20, 0, 20)
iconBtn.Image = "rbxassetid://90013112630319"
iconBtn.BackgroundColor3 = COLORS.Background
iconBtn.AutoButtonColor = false
iconBtn.BorderSizePixel = 0
iconBtn.Active = true
iconBtn.Draggable = true

createCorner(iconBtn, 16)
createStroke(iconBtn, COLORS.Primary)
createGlow(iconBtn, COLORS.Primary)

--------------------------------------------------
-- MAIN FRAME
--------------------------------------------------

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 420, 0, 320)
frame.Position = UDim2.new(0.5, -210, 0.5, -160)
frame.BackgroundColor3 = COLORS.Background
frame.Visible = true
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

createCorner(frame, 20)
createStroke(frame, COLORS.Primary)
createGlow(frame, COLORS.Primary)

--------------------------------------------------
-- HEADER
--------------------------------------------------

local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 80)
header.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
header.BorderSizePixel = 0
createCorner(header, 20)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 20, 0, 20)
title.Text = "Warp Key System"
title.Font = Enum.Font.GothamBold
title.TextSize = 26
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1

--------------------------------------------------
-- INPUT
--------------------------------------------------

local inputFrame = Instance.new("Frame", frame)
inputFrame.Size = UDim2.new(1, -40, 0, 50)
inputFrame.Position = UDim2.new(0, 20, 0, 120)
inputFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
inputFrame.BorderSizePixel = 0
createCorner(inputFrame, 12)

local inputStroke = createStroke(inputFrame, Color3.fromRGB(40, 40, 40))

local keyBox = Instance.new("TextBox", inputFrame)
keyBox.Size = UDim2.new(1, -20, 1, 0)
keyBox.Position = UDim2.new(0, 10, 0, 0)
keyBox.PlaceholderText = "Enter key... (case and space insensitive)"
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.BackgroundTransparency = 1
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 15

--------------------------------------------------
-- BUTTONS
--------------------------------------------------

local submit = Instance.new("TextButton", frame)
submit.Size = UDim2.new(1, -40, 0, 50)
submit.Position = UDim2.new(0, 20, 0, 190)
submit.Text = "Verify Key"
submit.Font = Enum.Font.GothamBold
submit.TextSize = 16
submit.TextColor3 = Color3.fromRGB(255, 255, 255)
submit.BackgroundColor3 = COLORS.Primary
submit.BorderSizePixel = 0

createCorner(submit, 12)
createGlow(submit, COLORS.Primary)

local getKey = Instance.new("TextButton", frame)
getKey.Size = UDim2.new(1, -40, 0, 45)
getKey.Position = UDim2.new(0, 20, 0, 250)
getKey.Text = "Get Key"
getKey.Font = Enum.Font.GothamBold
getKey.TextSize = 15
getKey.TextColor3 = Color3.fromRGB(255, 255, 255)
getKey.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
getKey.BorderSizePixel = 0

createCorner(getKey, 12)

hover(submit, COLORS.Primary, Color3.fromRGB(0, 180, 255))
hover(getKey, Color3.fromRGB(40, 40, 40), Color3.fromRGB(60, 60, 60))

--------------------------------------------------
-- AUTO LOAD
--------------------------------------------------

local function handleAutoLoad()
    if loadKeyData() and SCRIPT_TO_LOAD then
        -- Auto-load from saved key
        frame.Visible = false
        iconBtn.Visible = false
        notify("Verified", "Loading script...", "Success")
        task.wait(0.5)
        loadMainScript()
    end
end

handleAutoLoad()

--------------------------------------------------
-- KEY VALIDATION LOGIC
--------------------------------------------------

submit.MouseButton1Click:Connect(function()
    local enteredKey = keyBox.Text
    local success, normalizedKey = validateKey(enteredKey)
    
    if success then
        saveKeyData()
        notify("Success", "Key verified!", "Success")
        frame.Visible = false
        iconBtn.Visible = false
        loadMainScript()
    else
        notify("Invalid Key", "Wrong key entered.", "Error")
        -- Clear the input field
        keyBox.Text = ""
    end
end)

getKey.MouseButton1Click:Connect(function()
    -- Copy to clipboard
    if setclipboard then
        setclipboard(DISCORD_LINK)
    end
    
    -- Open in browser
    pcall(function()
        openBrowser(DISCORD_LINK)
    end)

    notify("Copied!", "Key link copied and opening browser...", "Info")
end)

iconBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

--------------------------------------------------
-- END
--------------------------------------------------
