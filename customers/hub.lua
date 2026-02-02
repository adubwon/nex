local Kavo = {}
local tween = game:GetService("TweenService")
local tweeninfo = TweenInfo.new
local input = game:GetService("UserInputService")
local run = game:GetService("RunService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

--================================================================================--
--[[ CONFIGURATION ]]--
--================================================================================--
local Config = {
    -- Key System Settings
    CORRECT_KEY = "ezunban",
    DISCORD_LINK = "https://discord.gg/ezunban",
    DISCORD_INVITE_CODE = "ezunban",
    
    -- Key Storage
    KEY_STORAGE_FILE = "abysskey.json",

    -- Main Settings
    HubName = "Abyss Hub",
    ScriptToLoad = "https://github.com/adubwon/nex/raw/refs/heads/main/hub.lua",

    -- UI Configuration
    GlassTransparency = 0.15,
    DarkGlassTransparency = 0.1,
    CornerRadius = 20,
    AccentColor = Color3.fromRGB(168, 128, 255),
    SecondaryColor = Color3.fromRGB(128, 96, 255),
    GlassColor = Color3.fromRGB(25, 25, 35),
    DarkGlassColor = Color3.fromRGB(15, 15, 22),
    TextColor = Color3.fromRGB(255, 255, 255),
    SubTextColor = Color3.fromRGB(200, 200, 220),
    ButtonColor = Color3.fromRGB(35, 35, 45),
    ButtonHoverColor = Color3.fromRGB(168, 128, 255),
    InputBackground = Color3.fromRGB(40, 40, 50),
    SliderTrack = Color3.fromRGB(45, 45, 55),
    SliderFill = Color3.fromRGB(168, 128, 255),
    DropdownBackground = Color3.fromRGB(40, 40, 50),
    DropdownHover = Color3.fromRGB(50, 50, 60),
    ErrorColor = Color3.fromRGB(255, 85, 85),
    SuccessColor = Color3.fromRGB(85, 255, 127)
}

local Utility = {}
local Objects = {}

-- Key System Functions
local function notify(title, text, dur)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = dur or 3
        })
    end)
end

local function saveKeyData()
    pcall(function()
        local player = Players.LocalPlayer
        writefile(Config.KEY_STORAGE_FILE, HttpService:JSONEncode({
            key_verified = true,
            user_id = player.UserId,
            saved_key = Config.CORRECT_KEY,
            timestamp = os.time()
        }))
    end)
end

local function loadKeyData()
    local success, result = pcall(function()
        if isfile(Config.KEY_STORAGE_FILE) then
            local player = Players.LocalPlayer
            local data = HttpService:JSONDecode(readfile(Config.KEY_STORAGE_FILE))
            return data.key_verified and data.user_id == player.UserId and data.saved_key == Config.CORRECT_KEY
        end
        return false
    end)
    return success and result
end

local function handleDiscordInvite()
    xpcall(function()
        if setclipboard then
            setclipboard(Config.DISCORD_LINK)
        elseif toclipboard then
            toclipboard(Config.DISCORD_LINK)
        end
    end, function() end)
    
    notify("Discord Link Copied", "Paste in browser to join", 15)
end

local alreadyVerified = loadKeyData()

-- UI Creation Functions (Glass Style)
local function createNotification(title, message, duration)
    local duration = duration or 2.5
    local notificationGUI = Instance.new("ScreenGui")
    notificationGUI.Name = "AbyssHubNotification_" .. HttpService:GenerateGUID(false)
    notificationGUI.ZIndexBehavior = Enum.ZIndexBehavior.Global
    notificationGUI.ResetOnSpawn = false
    
    local padding = 12
    local notificationWidth = 320
    local titleHeight = 24
    local messageHeight = 36
    local totalHeight = titleHeight + messageHeight + padding

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, notificationWidth, 0, totalHeight)
    mainFrame.Position = UDim2.new(1, -notificationWidth - 20, 1, totalHeight)
    mainFrame.BackgroundColor3 = Config.DarkGlassColor
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Config.DarkGlassColor
    stroke.Thickness = 1.5
    stroke.Transparency = 0.6
    stroke.Parent = mainFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -padding * 2, 0, titleHeight)
    titleLabel.Position = UDim2.new(0, padding, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Notification"
    titleLabel.TextColor3 = Config.AccentColor
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -padding * 2, 0, messageHeight)
    messageLabel.Position = UDim2.new(0, padding, 0, titleHeight)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message or ""
    messageLabel.TextColor3 = Config.TextColor
    messageLabel.TextSize = 14
    messageLabel.Font = Enum.Font.GothamMedium
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.TextWrapped = true
    
    titleLabel.Parent = mainFrame
    messageLabel.Parent = mainFrame
    mainFrame.Parent = notificationGUI
    notificationGUI.Parent = CoreGui
    
    local targetY = 80
    
    tween:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -notificationWidth - 20, 0, targetY)
    }):Play()
    
    task.delay(duration, function()
        tween:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, -notificationWidth - 20, 1, totalHeight)
        }):Play()
        
        task.wait(0.3)
        if notificationGUI and notificationGUI.Parent then
            notificationGUI:Destroy()
        end
    end)
    
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            tween:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Position = UDim2.new(1, -notificationWidth - 20, 1, totalHeight)
            }):Play()
            
            task.wait(0.2)
            if notificationGUI and notificationGUI.Parent then
                notificationGUI:Destroy()
            end
        end
    end)
end

-- Dragging Function
function Kavo:DraggingEnabled(frame, parent)
    parent = parent or frame
    
    local dragging = false
    local dragInput, mousePos, framePos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = parent.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    input.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            parent.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

-- Tween Utility
function Utility:TweenObject(obj, properties, duration, ...)
    tween:Create(obj, tweeninfo(duration, ...), properties):Play()
end

-- Themes with Glass Effect
local themes = {
    SchemeColor = Config.AccentColor,
    Background = Config.GlassColor,
    Header = Config.DarkGlassColor,
    TextColor = Config.TextColor,
    ElementColor = Config.ButtonColor,
    GlassTransparency = Config.GlassTransparency,
    CornerRadius = Config.CornerRadius
}

local themeStyles = {
    DarkTheme = {
        SchemeColor = Config.AccentColor,
        Background = Color3.fromRGB(20, 20, 25),
        Header = Color3.fromRGB(15, 15, 20),
        TextColor = Config.TextColor,
        ElementColor = Color3.fromRGB(30, 30, 40)
    },
    Midnight = {
        SchemeColor = Config.AccentColor,
        Background = Color3.fromRGB(25, 25, 35),
        Header = Color3.fromRGB(15, 15, 25),
        TextColor = Config.TextColor,
        ElementColor = Color3.fromRGB(35, 35, 45)
    }
}

-- Key System UI Function
function Kavo:CreateKeySystem()
    local windowWidth = 480
    local windowHeight = 480

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AbyssHubKeySystem"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ScreenGui.ResetOnSpawn = false

    -- Create Main Frame with Glass Effect
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, windowWidth, 0, windowHeight)
    MainFrame.Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
    MainFrame.BackgroundColor3 = Config.DarkGlassColor
    MainFrame.BackgroundTransparency = Config.DarkGlassTransparency
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 22)
    corner.Parent = MainFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Config.DarkGlassColor
    stroke.Thickness = 1.5
    stroke.Transparency = 0.6
    stroke.Parent = MainFrame

    -- Top Bar
    local topBarHeight = 55
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, -24, 0, topBarHeight)
    TopBar.Position = UDim2.new(0, 12, 0, 12)
    TopBar.BackgroundColor3 = Config.GlassColor
    TopBar.BackgroundTransparency = 0.1
    TopBar.BorderSizePixel = 0

    local topBarCorner = Instance.new("UICorner")
    topBarCorner.CornerRadius = UDim.new(0, 14)
    topBarCorner.Parent = TopBar

    local topBarStroke = Instance.new("UIStroke")
    topBarStroke.Color = Config.GlassColor
    topBarStroke.Thickness = 1.5
    topBarStroke.Transparency = 0.6
    topBarStroke.Parent = TopBar

    -- Window Title with Glow Effect
    local windowTitle = Instance.new("TextLabel")
    windowTitle.Size = UDim2.new(1, -16, 1, 0)
    windowTitle.Position = UDim2.new(0, 16, 0, 0)
    windowTitle.BackgroundTransparency = 1
    windowTitle.Text = Config.HubName
    windowTitle.TextColor3 = Config.TextColor
    windowTitle.TextSize = 26
    windowTitle.Font = Enum.Font.GothamBlack
    windowTitle.TextXAlignment = Enum.TextXAlignment.Left

    local titleGlow = Instance.new("UIGradient")
    titleGlow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Config.AccentColor),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Config.SecondaryColor)
    })
    titleGlow.Parent = windowTitle

    -- Logo/Icon
    local logoContainer = Instance.new("Frame")
    logoContainer.Size = UDim2.new(0, 120, 0, 120)
    logoContainer.Position = UDim2.new(0.5, -60, 0, topBarHeight + 40)
    logoContainer.BackgroundColor3 = Config.GlassColor
    logoContainer.BackgroundTransparency = 0.1
    logoContainer.BorderSizePixel = 0

    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0, 20)
    logoCorner.Parent = logoContainer

    local logoStroke = Instance.new("UIStroke")
    logoStroke.Color = Config.GlassColor
    logoStroke.Thickness = 1.5
    logoStroke.Transparency = 0.6
    logoStroke.Parent = logoContainer

    local logoLetter = Instance.new("TextLabel")
    logoLetter.Size = UDim2.new(1, 0, 1, 0)
    logoLetter.BackgroundTransparency = 1
    logoLetter.Text = "A"
    logoLetter.TextColor3 = Config.AccentColor
    logoLetter.TextSize = 64
    logoLetter.Font = Enum.Font.GothamBlack
    logoLetter.TextTransparency = 0

    local logoGlow = Instance.new("UIGradient")
    logoGlow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Config.AccentColor),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Config.SecondaryColor)
    })
    logoGlow.Parent = logoLetter

    -- Status Text
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, -40, 0, 30)
    statusText.Position = UDim2.new(0, 20, 0, topBarHeight + 180)
    statusText.BackgroundTransparency = 1
    statusText.Text = alreadyVerified and "Key already verified! Click VERIFY to continue." or "Enter your key to access the script"
    statusText.TextColor3 = alreadyVerified and Config.SuccessColor or Config.SubTextColor
    statusText.TextSize = 16
    statusText.Font = Enum.Font.GothamMedium
    statusText.TextXAlignment = Enum.TextXAlignment.Center

    -- Key Input Box
    local keyInputContainer = Instance.new("Frame")
    keyInputContainer.Size = UDim2.new(1, -60, 0, 52)
    keyInputContainer.Position = UDim2.new(0, 30, 0, topBarHeight + 220)
    keyInputContainer.BackgroundColor3 = Config.InputBackground
    keyInputContainer.BackgroundTransparency = 0.1
    keyInputContainer.BorderSizePixel = 0

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 14)
    inputCorner.Parent = keyInputContainer

    local inputStroke = Instance.new("UIStroke")
    inputStroke.Color = Config.InputBackground
    inputStroke.Thickness = 1.5
    inputStroke.Transparency = 0.6
    inputStroke.Parent = keyInputContainer

    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(1, -20, 1, 0)
    keyInput.Position = UDim2.new(0, 10, 0, 0)
    keyInput.BackgroundTransparency = 1
    keyInput.PlaceholderText = alreadyVerified and "Key already saved (click VERIFY)" or "Enter your key..."
    keyInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
    keyInput.TextColor3 = Config.TextColor
    keyInput.TextSize = 16
    keyInput.Font = Enum.Font.GothamMedium
    keyInput.ClearTextOnFocus = false
    keyInput.Text = alreadyVerified and Config.CORRECT_KEY or ""

    -- Buttons Container
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(1, -60, 0, 52)
    buttonContainer.Position = UDim2.new(0, 30, 0, topBarHeight + 290)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = MainFrame

    local buttonList = Instance.new("UIListLayout")
    buttonList.Padding = UDim.new(0, 12)
    buttonList.FillDirection = Enum.FillDirection.Horizontal
    buttonList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    buttonList.SortOrder = Enum.SortOrder.LayoutOrder
    buttonList.Parent = buttonContainer

    -- Verify Button
    local verifyButton = Instance.new("TextButton")
    verifyButton.Size = UDim2.new(0.5, -6, 1, 0)
    verifyButton.BackgroundColor3 = alreadyVerified and Config.SuccessColor or Config.AccentColor
    verifyButton.BackgroundTransparency = 0.2
    verifyButton.AutoButtonColor = false
    verifyButton.Text = alreadyVerified and "CONTINUE" or "VERIFY KEY"
    verifyButton.TextColor3 = Config.TextColor
    verifyButton.TextSize = 16
    verifyButton.Font = Enum.Font.GothamBold
    verifyButton.BorderSizePixel = 0
    verifyButton.LayoutOrder = 1

    local verifyCorner = Instance.new("UICorner")
    verifyCorner.CornerRadius = UDim.new(0, 12)
    verifyCorner.Parent = verifyButton

    local verifyStroke = Instance.new("UIStroke")
    verifyStroke.Color = alreadyVerified and Config.SuccessColor or Config.AccentColor
    verifyStroke.Thickness = 1.5
    verifyStroke.Transparency = 0.6
    verifyStroke.Parent = verifyButton

    -- Get Key Button
    local getKeyButton = Instance.new("TextButton")
    getKeyButton.Size = UDim2.new(0.5, -6, 1, 0)
    getKeyButton.BackgroundColor3 = Config.ButtonColor
    getKeyButton.BackgroundTransparency = 0.2
    getKeyButton.AutoButtonColor = false
    getKeyButton.Text = "GET KEY"
    getKeyButton.TextColor3 = Config.TextColor
    getKeyButton.TextSize = 16
    getKeyButton.Font = Enum.Font.GothamMedium
    getKeyButton.BorderSizePixel = 0
    getKeyButton.LayoutOrder = 2

    local getKeyCorner = Instance.new("UICorner")
    getKeyCorner.CornerRadius = UDim.new(0, 12)
    getKeyCorner.Parent = getKeyButton

    local getKeyStroke = Instance.new("UIStroke")
    getKeyStroke.Color = Config.ButtonColor
    getKeyStroke.Thickness = 1.5
    getKeyStroke.Transparency = 0.6
    getKeyStroke.Parent = getKeyButton

    -- Footer Text
    local footerText = Instance.new("TextLabel")
    footerText.Size = UDim2.new(1, -40, 0, 40)
    footerText.Position = UDim2.new(0, 20, 1, -50)
    footerText.BackgroundTransparency = 1
    footerText.Text = "Join our Discord for keys and updates"
    footerText.TextColor3 = Config.SubTextColor
    footerText.TextSize = 14
    footerText.Font = Enum.Font.Gotham
    footerText.TextXAlignment = Enum.TextXAlignment.Center

    -- Close Button
    local CloseButton = Instance.new("ImageButton")
    CloseButton.Size = UDim2.new(0, 28, 0, 28)
    CloseButton.Position = UDim2.new(1, -46, 0, 14)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Image = "rbxassetid://3926305904"
    CloseButton.ImageRectOffset = Vector2.new(284, 4)
    CloseButton.ImageRectSize = Vector2.new(24, 24)
    CloseButton.ImageColor3 = Config.TextColor

    -- Parent all elements
    TopBar.Parent = MainFrame
    windowTitle.Parent = TopBar
    logoContainer.Parent = MainFrame
    logoLetter.Parent = logoContainer
    statusText.Parent = MainFrame
    keyInputContainer.Parent = MainFrame
    keyInput.Parent = keyInputContainer
    verifyButton.Parent = buttonContainer
    getKeyButton.Parent = buttonContainer
    buttonContainer.Parent = MainFrame
    footerText.Parent = MainFrame
    CloseButton.Parent = TopBar
    MainFrame.Parent = ScreenGui
    ScreenGui.Parent = CoreGui

    -- Enable dragging on top bar
    Kavo:DraggingEnabled(TopBar, MainFrame)

    -- UI Interaction Functions
    local isClosing = false

    local function closeUI()
        if isClosing then return end
        isClosing = true
        
        tween:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        }):Play()
        
        task.wait(0.3)
        if ScreenGui then
            ScreenGui:Destroy()
        end
    end

    local function updateStatus(text, isError)
        statusText.Text = text
        if isError then
            tween:Create(statusText, TweenInfo.new(0.15), {
                TextColor3 = Config.ErrorColor
            }):Play()
        else
            tween:Create(statusText, TweenInfo.new(0.15), {
                TextColor3 = Config.SuccessColor
            }):Play()
        end
    end

    local function showError(message)
        updateStatus(message, true)
        createNotification("Key Error", message, 3)
        
        local originalPos = keyInputContainer.Position
        for i = 1, 3 do
            tween:Create(keyInputContainer, TweenInfo.new(0.05), {
                Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset + 5, originalPos.Y.Scale, originalPos.Y.Offset)
            }):Play()
            task.wait(0.05)
            tween:Create(keyInputContainer, TweenInfo.new(0.05), {
                Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset - 5, originalPos.Y.Scale, originalPos.Y.Offset)
            }):Play()
            task.wait(0.05)
        end
        tween:Create(keyInputContainer, TweenInfo.new(0.1), {Position = originalPos}):Play()
    end

    local function showSuccess(message)
        updateStatus(message, false)
        createNotification("Success", message, 3)
    end

    local function startLoadingAnimation()
        tween:Create(keyInputContainer, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        tween:Create(keyInput, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        tween:Create(verifyButton, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        tween:Create(getKeyButton, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        
        local loadingContainer = Instance.new("Frame")
        loadingContainer.Size = UDim2.new(1, -60, 0, 8)
        loadingContainer.Position = UDim2.new(0, 30, 0, topBarHeight + 280)
        loadingContainer.BackgroundColor3 = Config.SliderTrack
        loadingContainer.BackgroundTransparency = 0.8
        loadingContainer.BorderSizePixel = 0
        
        local loadingCorner = Instance.new("UICorner")
        loadingCorner.CornerRadius = UDim.new(0, 4)
        loadingCorner.Parent = loadingContainer
        
        local loadingFill = Instance.new("Frame")
        loadingFill.Size = UDim2.new(0, 0, 1, 0)
        loadingFill.Position = UDim2.new(0, 0, 0, 0)
        loadingFill.BackgroundColor3 = Config.SuccessColor
        loadingFill.BackgroundTransparency = 0
        loadingFill.BorderSizePixel = 0
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 4)
        fillCorner.Parent = loadingFill
        
        local loadingText = Instance.new("TextLabel")
        loadingText.Size = UDim2.new(1, 0, 0, 30)
        loadingText.Position = UDim2.new(0, 0, 0, 15)
        loadingText.BackgroundTransparency = 1
        loadingText.Text = "Loading hub... 0%"
        loadingText.TextColor3 = Config.SuccessColor
        loadingText.TextSize = 16
        loadingText.Font = Enum.Font.GothamMedium
        loadingText.TextXAlignment = Enum.TextXAlignment.Center
        
        loadingFill.Parent = loadingContainer
        loadingText.Parent = loadingContainer
        loadingContainer.Parent = MainFrame
        
        for i = 0, 100, 2 do
            loadingFill.Size = UDim2.new(i/100, 0, 1, 0)
            loadingText.Text = string.format("Loading hub... %d%%", i)
            task.wait(0.03)
        end
        
        return loadingContainer
    end

    local function loadMainHub()
        local loadingContainer = startLoadingAnimation()
        
        task.wait(1)
        
        local success, result = pcall(function()
            loadstring(game:HttpGet(Config.ScriptToLoad))()
        end)
        
        if success then
            loadingContainer:FindFirstChildOfClass("TextLabel").Text = "Hub loaded successfully!"
            task.wait(1)
            closeUI()
        else
            showError("Failed to load hub: " .. tostring(result))
            tween:Create(keyInputContainer, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
            tween:Create(keyInput, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
            tween:Create(verifyButton, TweenInfo.new(0.3), {BackgroundTransparency = 0.2, TextTransparency = 0}):Play()
            tween:Create(getKeyButton, TweenInfo.new(0.3), {BackgroundTransparency = 0.2, TextTransparency = 0}):Play()
            
            if loadingContainer then
                loadingContainer:Destroy()
            end
        end
    end

    -- Button Click Events
    verifyButton.MouseButton1Click:Connect(function()
        local key = keyInput.Text:gsub("%s+", "")
        
        if key == "" then
            showError("Please enter a key")
            return
        end
        
        if alreadyVerified or key == Config.CORRECT_KEY then
            if not alreadyVerified then
                saveKeyData()
            end
            showSuccess("Key verified! Loading hub...")
            loadMainHub()
        else
            showError("Invalid key! Please try again.")
        end
    end)

    getKeyButton.MouseButton1Click:Connect(function()
        showSuccess("Copied Discord Invite !")
        handleDiscordInvite()
    end)

    CloseButton.MouseButton1Click:Connect(closeUI)

    keyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            verifyButton.MouseButton1Click:Fire()
        end
    end)

    -- Hover Effects
    verifyButton.MouseEnter:Connect(function()
        if isClosing then return end
        tween:Create(verifyButton, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.1,
            BackgroundColor3 = Config.ButtonHoverColor,
            Size = UDim2.new(0.5, -2, 1.05, 0)
        }):Play()
    end)

    verifyButton.MouseLeave:Connect(function()
        if isClosing then return end
        tween:Create(verifyButton, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.2,
            BackgroundColor3 = alreadyVerified and Config.SuccessColor or Config.AccentColor,
            Size = UDim2.new(0.5, -6, 1, 0)
        }):Play()
    end)

    getKeyButton.MouseEnter:Connect(function()
        if isClosing then return end
        tween:Create(getKeyButton, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.1,
            BackgroundColor3 = Config.ButtonHoverColor,
            Size = UDim2.new(0.5, -2, 1.05, 0)
        }):Play()
    end)

    getKeyButton.MouseLeave:Connect(function()
        if isClosing then return end
        tween:Create(getKeyButton, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.2,
            BackgroundColor3 = Config.ButtonColor,
            Size = UDim2.new(0.5, -6, 1, 0)
        }):Play()
    end)

    CloseButton.MouseEnter:Connect(function()
        if isClosing then return end
        tween:Create(CloseButton, TweenInfo.new(0.15), {
            ImageColor3 = Config.ErrorColor,
            Size = UDim2.new(0, 32, 0, 32)
        }):Play()
    end)

    CloseButton.MouseLeave:Connect(function()
        if isClosing then return end
        tween:Create(CloseButton, TweenInfo.new(0.15), {
            ImageColor3 = Config.TextColor,
            Size = UDim2.new(0, 28, 0, 28)
        }):Play()
    end)

    logoContainer.MouseEnter:Connect(function()
        if isClosing then return end
        tween:Create(logoContainer, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 130, 0, 130),
            Position = UDim2.new(0.5, -65, 0, topBarHeight + 35)
        }):Play()
        tween:Create(logoLetter, TweenInfo.new(0.2), {
            TextSize = 70
        }):Play()
    end)

    logoContainer.MouseLeave:Connect(function()
        if isClosing then return end
        tween:Create(logoContainer, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 120, 0, 120),
            Position = UDim2.new(0.5, -60, 0, topBarHeight + 40)
        }):Play()
        tween:Create(logoLetter, TweenInfo.new(0.2), {
            TextSize = 64
        }):Play()
    end)

    -- Intro Animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.BackgroundTransparency = 1
    TopBar.BackgroundTransparency = 1
    logoContainer.BackgroundTransparency = 1
    logoLetter.TextTransparency = 1
    statusText.TextTransparency = 1
    keyInputContainer.BackgroundTransparency = 1
    keyInput.TextTransparency = 1
    keyInput.PlaceholderColor3 = Color3.fromRGB(0, 0, 0)
    verifyButton.BackgroundTransparency = 1
    verifyButton.TextTransparency = 1
    getKeyButton.BackgroundTransparency = 1
    getKeyButton.TextTransparency = 1
    footerText.TextTransparency = 1
    windowTitle.TextTransparency = 1
    CloseButton.ImageTransparency = 1

    task.wait(0.5)
    tween:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, windowWidth, 0, windowHeight),
        BackgroundTransparency = Config.DarkGlassTransparency
    }):Play()

    task.wait(0.3)

    local elements = {
        {TopBar, "BackgroundTransparency", 0.1},
        {windowTitle, "TextTransparency", 0},
        {CloseButton, "ImageTransparency", 0},
        {logoContainer, "BackgroundTransparency", 0.1},
        {logoLetter, "TextTransparency", 0},
        {statusText, "TextTransparency", 0},
        {keyInputContainer, "BackgroundTransparency", 0.1},
        {keyInput, "TextTransparency", 0},
        {keyInput, "PlaceholderColor3", Color3.fromRGB(120, 120, 140)},
        {verifyButton, "BackgroundTransparency", 0.2},
        {verifyButton, "TextTransparency", 0},
        {getKeyButton, "BackgroundTransparency", 0.2},
        {getKeyButton, "TextTransparency", 0},
        {footerText, "TextTransparency", 0}
    }

    for _, elementData in ipairs(elements) do
        local element = elementData[1]
        local property = elementData[2]
        local value = elementData[3]
        
        if element and element[property] then
            tween:Create(element, TweenInfo.new(0.3), {
                [property] = value
            }):Play()
        end
        task.wait(0.05)
    end

    if not alreadyVerified then
        task.wait(0.5)
        keyInput:CaptureFocus()
    end

    return true
end

-- Main Kavo Library Function (Modified for Glass Theme)
function Kavo.CreateLib(kavName, themeList)
    if not themeList then
        themeList = themes
    end
    
    -- Apply theme if it's a preset
    if themeStyles[themeList] then
        themeList = themeStyles[themeList]
    end
    
    themeList = themeList or {}
    local selectedTab 
    kavName = kavName or Config.HubName
    
    -- Clean up existing UI
    for i,v in pairs(game.CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name == kavName then
            v:Destroy()
        end
    end
    
    -- Create ScreenGui with random name
    local randomName = tostring(math.random(1, 100))..tostring(math.random(1,50))..tostring(math.random(1, 100))
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = randomName
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    -- Main Container with Glass Effect
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = themeList.Background
    Main.BackgroundTransparency = themeList.GlassTransparency or Config.GlassTransparency
    Main.ClipsDescendants = true
    Main.Position = UDim2.new(0.336503863, 0, 0.275485456, 0)
    Main.Size = UDim2.new(0, 525, 0, 318)
    Main.BorderSizePixel = 0

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, themeList.CornerRadius or Config.CornerRadius)
    MainCorner.Name = "MainCorner"
    MainCorner.Parent = Main

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = themeList.Background
    MainStroke.Thickness = 1.5
    MainStroke.Transparency = 0.6
    MainStroke.Parent = Main

    -- Main Header with Glass Effect
    local MainHeader = Instance.new("Frame")
    MainHeader.Name = "MainHeader"
    MainHeader.Parent = Main
    MainHeader.BackgroundColor3 = themeList.Header
    MainHeader.BackgroundTransparency = themeList.GlassTransparency or Config.GlassTransparency
    MainHeader.Size = UDim2.new(0, 525, 0, 29)
    MainHeader.BorderSizePixel = 0

    local headerCover = Instance.new("UICorner")
    headerCover.CornerRadius = UDim.new(0, themeList.CornerRadius or Config.CornerRadius)
    headerCover.Name = "headerCover"
    headerCover.Parent = MainHeader

    local headerStroke = Instance.new("UIStroke")
    headerStroke.Color = themeList.Header
    headerStroke.Thickness = 1.5
    headerStroke.Transparency = 0.6
    headerStroke.Parent = MainHeader

    local coverup = Instance.new("Frame")
    coverup.Name = "coverup"
    coverup.Parent = MainHeader
    coverup.BackgroundColor3 = themeList.Header
    coverup.BorderSizePixel = 0
    coverup.Position = UDim2.new(0, 0, 0.758620679, 0)
    coverup.Size = UDim2.new(0, 525, 0, 7)

    local title = Instance.new("TextLabel")
    title.Name = "title"
    title.Parent = MainHeader
    title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1.000
    title.BorderSizePixel = 0
    title.Position = UDim2.new(0.0171428565, 0, 0.344827592, 0)
    title.Size = UDim2.new(0, 204, 0, 8)
    title.Font = Enum.Font.Gotham
    title.RichText = true
    title.Text = kavName
    title.TextColor3 = themeList.TextColor
    title.TextSize = 16.000
    title.TextXAlignment = Enum.TextXAlignment.Left

    local close = Instance.new("ImageButton")
    close.Name = "close"
    close.Parent = MainHeader
    close.BackgroundTransparency = 1.000
    close.Position = UDim2.new(0.949999988, 0, 0.137999997, 0)
    close.Size = UDim2.new(0, 21, 0, 21)
    close.ZIndex = 2
    close.Image = "rbxassetid://3926305904"
    close.ImageRectOffset = Vector2.new(284, 4)
    close.ImageRectSize = Vector2.new(24, 24)
    close.ImageColor3 = themeList.TextColor
    close.MouseButton1Click:Connect(function()
        tween:Create(close, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            ImageTransparency = 1
        }):Play()
        task.wait()
        tween:Create(Main, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0,0,0,0),
            Position = UDim2.new(0, Main.AbsolutePosition.X + (Main.AbsoluteSize.X / 2), 0, Main.AbsolutePosition.Y + (Main.AbsoluteSize.Y / 2))
        }):Play()
        task.wait(1)
        ScreenGui:Destroy()
    end)

    -- Main Side Panel with Glass Effect
    local MainSide = Instance.new("Frame")
    MainSide.Name = "MainSide"
    MainSide.Parent = Main
    MainSide.BackgroundColor3 = themeList.Header
    MainSide.BackgroundTransparency = themeList.GlassTransparency or Config.GlassTransparency
    MainSide.Position = UDim2.new(-7.4505806e-09, 0, 0.0911949649, 0)
    MainSide.Size = UDim2.new(0, 149, 0, 289)
    MainSide.BorderSizePixel = 0

    local sideCorner = Instance.new("UICorner")
    sideCorner.CornerRadius = UDim.new(0, themeList.CornerRadius or Config.CornerRadius)
    sideCorner.Name = "sideCorner"
    sideCorner.Parent = MainSide

    local sideStroke = Instance.new("UIStroke")
    sideStroke.Color = themeList.Header
    sideStroke.Thickness = 1.5
    sideStroke.Transparency = 0.6
    sideStroke.Parent = MainSide

    local coverup_2 = Instance.new("Frame")
    coverup_2.Name = "coverup"
    coverup_2.Parent = MainSide
    coverup_2.BackgroundColor3 = themeList.Header
    coverup_2.BorderSizePixel = 0
    coverup_2.Position = UDim2.new(0.949939311, 0, 0, 0)
    coverup_2.Size = UDim2.new(0, 7, 0, 289)

    -- Tab Frames
    local tabFrames = Instance.new("Frame")
    tabFrames.Name = "tabFrames"
    tabFrames.Parent = MainSide
    tabFrames.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    tabFrames.BackgroundTransparency = 1.000
    tabFrames.Position = UDim2.new(0.0438990258, 0, -0.00066378375, 0)
    tabFrames.Size = UDim2.new(0, 135, 0, 283)

    local tabListing = Instance.new("UIListLayout")
    tabListing.Name = "tabListing"
    tabListing.Parent = tabFrames
    tabListing.SortOrder = Enum.SortOrder.LayoutOrder

    -- Pages Container
    local pages = Instance.new("Frame")
    pages.Name = "pages"
    pages.Parent = Main
    pages.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    pages.BackgroundTransparency = 1.000
    pages.BorderSizePixel = 0
    pages.Position = UDim2.new(0.299047589, 0, 0.122641519, 0)
    pages.Size = UDim2.new(0, 360, 0, 269)

    local Pages = Instance.new("Folder")
    Pages.Name = "Pages"
    Pages.Parent = pages

    local infoContainer = Instance.new("Frame")
    infoContainer.Name = "infoContainer"
    infoContainer.Parent = Main
    infoContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    infoContainer.BackgroundTransparency = 1.000
    infoContainer.BorderColor3 = Color3.fromRGB(27, 42, 53)
    infoContainer.ClipsDescendants = true
    infoContainer.Position = UDim2.new(0.299047619, 0, 0.874213815, 0)
    infoContainer.Size = UDim2.new(0, 368, 0, 33)

    local blurFrame = Instance.new("Frame")
    blurFrame.Name = "blurFrame"
    blurFrame.Parent = pages
    blurFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blurFrame.BackgroundTransparency = 1
    blurFrame.BorderSizePixel = 0
    blurFrame.Position = UDim2.new(-0.0222222228, 0, -0.0371747203, 0)
    blurFrame.Size = UDim2.new(0, 376, 0, 289)
    blurFrame.ZIndex = 999

    -- Enable dragging
    Kavo:DraggingEnabled(MainHeader, Main)

    -- Theme update coroutine with Glass effect
    coroutine.wrap(function()
        while wait() do
            Main.BackgroundColor3 = themeList.Background
            Main.BackgroundTransparency = themeList.GlassTransparency or Config.GlassTransparency
            MainStroke.Color = themeList.Background
            
            MainHeader.BackgroundColor3 = themeList.Header
            MainHeader.BackgroundTransparency = themeList.GlassTransparency or Config.GlassTransparency
            headerStroke.Color = themeList.Header
            
            MainSide.BackgroundColor3 = themeList.Header
            MainSide.BackgroundTransparency = themeList.GlassTransparency or Config.GlassTransparency
            sideStroke.Color = themeList.Header
            
            coverup_2.BackgroundColor3 = themeList.Header
            coverup.BackgroundColor3 = themeList.Header
        end
    end)()

    function Kavo:ChangeColor(prope,color)
        if prope == "Background" then
            themeList.Background = color
        elseif prope == "SchemeColor" then
            themeList.SchemeColor = color
        elseif prope == "Header" then
            themeList.Header = color
        elseif prope == "TextColor" then
            themeList.TextColor = color
        elseif prope == "ElementColor" then
            themeList.ElementColor = color
        elseif prope == "GlassTransparency" then
            themeList.GlassTransparency = color
        end
    end

    -- Close button hover effects
    close.MouseEnter:Connect(function()
        tween:Create(close, TweenInfo.new(0.15), {
            ImageColor3 = Config.ErrorColor,
            Size = UDim2.new(0, 24, 0, 24)
        }):Play()
    end)

    close.MouseLeave:Connect(function()
        tween:Create(close, TweenInfo.new(0.15), {
            ImageColor3 = themeList.TextColor,
            Size = UDim2.new(0, 21, 0, 21)
        }):Play()
    end)

    -- Tabs system (modified from original Kavo)
    local Tabs = {}
    local first = true

    function Tabs:NewTab(tabName)
        tabName = tabName or "Tab"
        local tabButton = Instance.new("TextButton")
        local UICorner = Instance.new("UICorner")
        local page = Instance.new("ScrollingFrame")
        local pageListing = Instance.new("UIListLayout")
        local buttonStroke = Instance.new("UIStroke")

        local function UpdateSize()
            local cS = pageListing.AbsoluteContentSize
            tween:Create(page, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                CanvasSize = UDim2.new(0,cS.X,0,cS.Y)
            }):Play()
        end

        page.Name = "Page"
        page.Parent = Pages
        page.Active = true
        page.BackgroundColor3 = themeList.Background
        page.BackgroundTransparency = themeList.GlassTransparency or Config.GlassTransparency
        page.BorderSizePixel = 0
        page.Position = UDim2.new(0, 0, -0.00371747208, 0)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.ScrollBarThickness = 5
        page.Visible = false
        page.ScrollBarImageColor3 = themeList.SchemeColor

        local pageCorner = Instance.new("UICorner")
        pageCorner.CornerRadius = UDim.new(0, themeList.CornerRadius or Config.CornerRadius)
        pageCorner.Parent = page

        local pageStroke = Instance.new("UIStroke")
        pageStroke.Color = themeList.Background
        pageStroke.Thickness = 1.5
        pageStroke.Transparency = 0.6
        pageStroke.Parent = page

        pageListing.Name = "pageListing"
        pageListing.Parent = page
        pageListing.SortOrder = Enum.SortOrder.LayoutOrder
        pageListing.Padding = UDim.new(0, 5)

        tabButton.Name = tabName.."TabButton"
        tabButton.Parent = tabFrames
        tabButton.BackgroundColor3 = themeList.SchemeColor
        tabButton.BackgroundTransparency = 0.2
        tabButton.Size = UDim2.new(0, 135, 0, 28)
        tabButton.AutoButtonColor = false
        tabButton.Font = Enum.Font.Gotham
        tabButton.Text = tabName
        tabButton.TextColor3 = themeList.TextColor
        tabButton.TextSize = 14.000
        tabButton.BackgroundTransparency = 0.2

        buttonStroke.Color = themeList.SchemeColor
        buttonStroke.Thickness = 1.5
        buttonStroke.Transparency = 0.6
        buttonStroke.Parent = tabButton

        if first then
            first = false
            page.Visible = true
            tabButton.BackgroundTransparency = 0.1
            tabButton.TextColor3 = Color3.new(1, 1, 1)
            UpdateSize()
        else
            page.Visible = false
            tabButton.BackgroundTransparency = 0.2
        end

        UICorner.CornerRadius = UDim.new(0, 5)
        UICorner.Parent = tabButton
        table.insert(Tabs, tabName)

        UpdateSize()
        page.ChildAdded:Connect(UpdateSize)
        page.ChildRemoved:Connect(UpdateSize)

        -- Button hover effects
        tabButton.MouseEnter:Connect(function()
            tween:Create(tabButton, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.1,
                BackgroundColor3 = Config.ButtonHoverColor,
                Size = UDim2.new(0, 138, 0, 30)
            }):Play()
        end)

        tabButton.MouseLeave:Connect(function()
            if page.Visible then
                tween:Create(tabButton, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.1,
                    BackgroundColor3 = themeList.SchemeColor,
                    Size = UDim2.new(0, 135, 0, 28)
                }):Play()
            else
                tween:Create(tabButton, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.2,
                    BackgroundColor3 = themeList.SchemeColor,
                    Size = UDim2.new(0, 135, 0, 28)
                }):Play()
            end
        end)

        tabButton.MouseButton1Click:Connect(function()
            UpdateSize()
            for i,v in next, Pages:GetChildren() do
                v.Visible = false
            end
            page.Visible = true
            for i,v in next, tabFrames:GetChildren() do
                if v:IsA("TextButton") then
                    tween:Create(v, TweenInfo.new(0.2), {
                        BackgroundTransparency = 0.2,
                        TextColor3 = themeList.TextColor
                    }):Play()
                end
            end
            tween:Create(tabButton, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.1,
                TextColor3 = Color3.new(1, 1, 1),
                BackgroundColor3 = themeList.SchemeColor
            }):Play()
        end)

        -- Theme updates
        coroutine.wrap(function()
            while wait() do
                page.BackgroundColor3 = themeList.Background
                page.BackgroundTransparency = themeList.GlassTransparency or Config.GlassTransparency
                pageStroke.Color = themeList.Background
                page.ScrollBarImageColor3 = themeList.SchemeColor
                tabButton.TextColor3 = themeList.TextColor
                tabButton.BackgroundColor3 = themeList.SchemeColor
                buttonStroke.Color = themeList.SchemeColor
            end
        end)()

        -- Sections system (will be modified for glass effect in actual use)
        local Sections = {}
        
        function Sections:NewSection(secName, hidden)
            -- This would contain the section creation code with glass effects
            -- Similar to original Kavo but with glass styling
            return {
                NewButton = function() end,
                NewToggle = function() end,
                NewSlider = function() end,
                NewDropdown = function() end,
                NewTextBox = function() end,
                NewKeybind = function() end,
                NewColorPicker = function() end,
                NewLabel = function() end
            }
        end
        
        return Sections
    end

    -- Toggle UI function
    function Kavo:ToggleUI()
        if ScreenGui and ScreenGui.Enabled then
            ScreenGui.Enabled = false
        else
            ScreenGui.Enabled = true
        end
    end

    return Tabs
end

-- Key System Integration
if not alreadyVerified then
    Kavo:CreateKeySystem()
else
    -- If already verified, you can directly load the hub or show main UI
    loadstring(game:HttpGet(Config.ScriptToLoad))()
end

return Kavo
