@@ -1,1026 +1,316 @@
-- WarpHub UI Library
-- Version: 2.1 - Fixed for loadstring usage
-- Load this library with: loadstring(game:HttpGet("YOUR_RAW_URL"))()
-- Version: 2.2 - Fully Fixed & Executor Safe
-- loadstring(game:HttpGet("RAW_URL_HERE"))()

local WarpHub = {}
WarpHub.__index = WarpHub

-- Default Colors (can be customized by users)
--==============================
-- SERVICES
--==============================
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local GuiParent = (gethui and gethui()) or game:GetService("CoreGui")

--==============================
-- CONFIG
--==============================
WarpHub.DefaultColors = {
    AccentColor = Color3.fromRGB(168, 128, 255),
    SecondaryColor = Color3.fromRGB(128, 96, 255),
    GlassColor = Color3.fromRGB(20, 20, 30),
    DarkGlassColor = Color3.fromRGB(10, 10, 18),
    TextColor = Color3.fromRGB(255, 255, 255),
    SubTextColor = Color3.fromRGB(220, 220, 240)
    AccentColor = Color3.fromRGB(168,128,255),
    SecondaryColor = Color3.fromRGB(128,96,255),
    GlassColor = Color3.fromRGB(20,20,30),
    DarkGlassColor = Color3.fromRGB(10,10,18),
    TextColor = Color3.fromRGB(255,255,255),
    SubTextColor = Color3.fromRGB(200,200,220)
}

-- Configuration settings
WarpHub.Config = {
    Version = "2.1",
    SplashScreenEnabled = true,
    GlassTransparency = 0.12,
    DarkGlassTransparency = 0.08,
    CornerRadius = 14,
    AnimationSpeed = 0.25
    CornerRadius = 14
}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
--==============================
-- HELPERS
--==============================
local function createGlassFrame(parent, size, pos, transparency, color)
    local f = Instance.new("Frame")
    f.Size = size
    f.Position = pos
    f.BackgroundColor3 = color or WarpHub.DefaultColors.GlassColor
    f.BackgroundTransparency = transparency or WarpHub.Config.GlassTransparency
    f.BorderSizePixel = 0
    f.ClipsDescendants = true

-- Helper function to detect mobile
local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end
    local c = Instance.new("UICorner", f)
    c.CornerRadius = UDim.new(0, WarpHub.Config.CornerRadius)

-- Initialize colors with defaults
function WarpHub:SetColors(colors)
    for colorName, value in pairs(colors) do
        if WarpHub.DefaultColors[colorName] then
            WarpHub.DefaultColors[colorName] = value
        end
    end
end
    local s = Instance.new("UIStroke", f)
    s.Color = Color3.new(1,1,1)
    s.Transparency = 0.9
    s.Thickness = 1.2

-- Create glass frame helper
local function createGlassFrame(parent, size, position, transparency, color, noStroke)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = color or WarpHub.DefaultColors.GlassColor
    frame.BackgroundTransparency = transparency or WarpHub.Config.GlassTransparency
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, WarpHub.Config.CornerRadius)
    corner.Parent = frame
    
    if not noStroke then
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Transparency = 0.9
        stroke.Thickness = 1.2
        stroke.Parent = frame
    end
    
    if parent then
        frame.Parent = parent
    end
    
    return frame
    if parent then f.Parent = parent end
    return f
end

-- Show splash screen
local function showSplashScreen()
    if not WarpHub.Config.SplashScreenEnabled then
        return
    end
    
    local splashGui = Instance.new("ScreenGui")
    splashGui.Name = "WarpHubSplash"
    splashGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    splashGui.ResetOnSpawn = false
    
    local screenDim = Instance.new("Frame")
    screenDim.Size = UDim2.new(1, 0, 1, 0)
    screenDim.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
    screenDim.BackgroundTransparency = 1
    screenDim.Parent = splashGui
    
    local logoContainer = Instance.new("Frame")
    logoContainer.Size = UDim2.new(0, 320, 0, 120)
    logoContainer.Position = UDim2.new(0.5, -160, 0.5, -60)
    logoContainer.BackgroundTransparency = 1
    logoContainer.Parent = splashGui
    
    local logoBg = createGlassFrame(logoContainer, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), 0.2, WarpHub.DefaultColors.AccentColor)
    logoBg.BackgroundTransparency = 0.8
    
    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(1, 0, 1, 0)
    logo.AnchorPoint = Vector2.new(0.5, 0.5)
    logo.Position = UDim2.new(0.5, 0, 0.5, 0)
    logo.BackgroundTransparency = 1
    logo.Text = "WARP HUB"
    logo.TextColor3 = Color3.fromRGB(255, 255, 255)
    logo.TextTransparency = 1
    logo.TextSize = 38
    logo.Font = Enum.Font.GothamBlack
    logo.TextStrokeTransparency = 0.7
    logo.TextStrokeColor3 = WarpHub.DefaultColors.AccentColor
    
    local logoGradient = Instance.new("UIGradient")
    logoGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, WarpHub.DefaultColors.AccentColor),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, WarpHub.DefaultColors.SecondaryColor)
    })
    logoGradient.Parent = logo
    
    logo.Parent = logoContainer
    splashGui.Parent = CoreGui
    
    -- Animation sequence
    TweenService:Create(screenDim, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {
        BackgroundTransparency = 0.3
    }):Play()
    
    task.wait(0.4)
    
    logoContainer.Size = UDim2.new(0, 10, 0, 10)
    logoContainer.Position = UDim2.new(0.5, -5, 0.5, -5)
    logoBg.BackgroundTransparency = 1
    
    TweenService:Create(logoContainer, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0), {
        Size = UDim2.new(0, 320, 0, 120),
        Position = UDim2.new(0.5, -160, 0.5, -60)
    }):Play()
    
    TweenService:Create(logoBg, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {
        BackgroundTransparency = 0.8
    }):Play()
    
    task.wait(0.5)
    
    TweenService:Create(logo, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {
        TextTransparency = 0
    }):Play()
    
    task.wait(1.5)
    
    TweenService:Create(logo, TweenInfo.new(0.9, Enum.EasingStyle.Quint), {
        TextTransparency = 1,
        TextSize = 10
    }):Play()
    
    TweenService:Create(logoBg, TweenInfo.new(0.9, Enum.EasingStyle.Quint), {
        BackgroundTransparency = 1
    }):Play()
    
    TweenService:Create(logoContainer, TweenInfo.new(0.9, Enum.EasingStyle.Quint), {
        Size = UDim2.new(0, 10, 0, 10),
        Position = UDim2.new(0.5, -5, 0.5, -5)
    }):Play()
    
    TweenService:Create(screenDim, TweenInfo.new(0.9, Enum.EasingStyle.Quint), {
        BackgroundTransparency = 1
    }):Play()
    
    task.wait(1)
    splashGui:Destroy()
end
--==============================
-- WINDOW
--==============================
function WarpHub:CreateWindow(title)
    local self = setmetatable({}, WarpHub)

    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "WarpHubUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    self.ScreenGui.Parent = GuiParent

    self.MainFrame = createGlassFrame(
        self.ScreenGui,
        UDim2.new(0,620,0,500),
        UDim2.new(0.5,-310,0.5,-250),
        WarpHub.Config.DarkGlassTransparency,
        WarpHub.DefaultColors.DarkGlassColor
    )

-- MAIN ENTRY POINT FOR LOADSTRING USERS
function WarpHub:CreateWindow(title, settings)
    local windowObj = setmetatable({}, WarpHub)
    
    -- Apply custom settings if provided
    if settings then
        if settings.SplashScreenEnabled ~= nil then
            WarpHub.Config.SplashScreenEnabled = settings.SplashScreenEnabled
        end
        if settings.CustomColors then
            windowObj:SetColors(settings.CustomColors)
        end
    end
    
    -- Show splash screen
    showSplashScreen()
    task.wait(2.5)
    
    -- Create main GUI
    windowObj.ScreenGui = Instance.new("ScreenGui")
    windowObj.ScreenGui.Name = "WarpHubUI_" .. tostring(math.random(10000, 99999))
    windowObj.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    windowObj.ScreenGui.ResetOnSpawn = false
    
    local screenSize = workspace.CurrentCamera.ViewportSize
    local isMobileDevice = isMobile()
    
    windowObj.windowWidth = isMobileDevice and math.min(580, screenSize.X * 0.9) or 620
    windowObj.windowHeight = isMobileDevice and math.min(480, screenSize.Y * 0.8) or 500
    
    windowObj.MainFrame = createGlassFrame(nil, UDim2.new(0, windowObj.windowWidth, 0, windowObj.windowHeight), 
        UDim2.new(0.5, -windowObj.windowWidth/2, 0.5, -windowObj.windowHeight/2), 
        WarpHub.Config.DarkGlassTransparency)
    windowObj.MainFrame.BackgroundColor3 = WarpHub.DefaultColors.DarkGlassColor
    windowObj.MainFrame.Visible = false
    
    local sidebarWidth = 140
    local topBarHeight = 46
    
    -- Top Bar
    windowObj.TopBar = createGlassFrame(windowObj.MainFrame, UDim2.new(1, -24, 0, topBarHeight), 
        UDim2.new(0, 12, 0, 12), 0.1)
    windowObj.TopBar.BackgroundColor3 = WarpHub.DefaultColors.GlassColor
    
    -- Title
    local titleContainer = Instance.new("Frame")
    titleContainer.Size = UDim2.new(0, 200, 1, 0)
    titleContainer.BackgroundTransparency = 1
    
    local windowTitle = Instance.new("TextLabel")
    windowTitle.Size = UDim2.new(1, -16, 1, 0)
    windowTitle.Position = UDim2.new(0, 12, 0, 0)
    windowTitle.BackgroundTransparency = 1
    windowTitle.Text = title or "WARP HUB"
    windowTitle.TextColor3 = WarpHub.DefaultColors.TextColor
    windowTitle.TextSize = isMobileDevice and 18 or 20
    windowTitle.Font = Enum.Font.GothamBlack
    windowTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local titleGlow = Instance.new("UIGradient")
    titleGlow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, WarpHub.DefaultColors.AccentColor),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    titleGlow.Parent = windowTitle
    
    -- Minimize button
    windowObj.MinimizeButton = Instance.new("ImageButton")
    windowObj.MinimizeButton.Size = UDim2.new(0, 22, 0, 22)
    windowObj.MinimizeButton.Position = UDim2.new(1, -52, 0.5, -11)
    windowObj.MinimizeButton.BackgroundTransparency = 1
    windowObj.MinimizeButton.Image = "rbxassetid://3926305904"
    windowObj.MinimizeButton.ImageRectOffset = Vector2.new(564, 284)
    windowObj.MinimizeButton.ImageRectSize = Vector2.new(36, 36)
    windowObj.MinimizeButton.ImageColor3 = WarpHub.DefaultColors.TextColor
    
    -- Close button
    windowObj.CloseButton = Instance.new("ImageButton")
    windowObj.CloseButton.Size = UDim2.new(0, 22, 0, 22)
    windowObj.CloseButton.Position = UDim2.new(1, -24, 0.5, -11)
    windowObj.CloseButton.BackgroundTransparency = 1
    windowObj.CloseButton.Image = "rbxassetid://3926305904"
    windowObj.CloseButton.ImageRectOffset = Vector2.new(284, 4)
    windowObj.CloseButton.ImageRectSize = Vector2.new(24, 24)
    windowObj.CloseButton.ImageColor3 = WarpHub.DefaultColors.TextColor
    
    self.TopBar = createGlassFrame(
        self.MainFrame,
        UDim2.new(1,-24,0,44),
        UDim2.new(0,12,0,12),
        0.1
    )

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1,-20,1,0)
    titleLabel.Position = UDim2.new(0,10,0,0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "WARP HUB"
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 20
    titleLabel.TextXAlignment = Left
    titleLabel.TextColor3 = WarpHub.DefaultColors.TextColor
    titleLabel.Parent = self.TopBar

    -- Sidebar
    windowObj.Sidebar = createGlassFrame(windowObj.MainFrame, UDim2.new(0, sidebarWidth, 1, -(topBarHeight + 24)), 
        UDim2.new(0, 12, 0, topBarHeight + 18), 0.1)
    
    -- Content Area
    windowObj.ContentArea = createGlassFrame(windowObj.MainFrame, UDim2.new(1, -(sidebarWidth + 24), 1, -(topBarHeight + 24)), 
        UDim2.new(0, sidebarWidth + 18, 0, topBarHeight + 18), 0.1)
    
    -- Sidebar tabs container
    windowObj.SidebarTabs = Instance.new("Frame")
    windowObj.SidebarTabs.Size = UDim2.new(1, -10, 1, -10)
    windowObj.SidebarTabs.Position = UDim2.new(0, 5, 0, 5)
    windowObj.SidebarTabs.BackgroundTransparency = 1
    
    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, 6)
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Parent = windowObj.SidebarTabs
    
    -- Parent elements
    windowTitle.Parent = titleContainer
    titleContainer.Parent = windowObj.TopBar
    windowObj.MinimizeButton.Parent = windowObj.TopBar
    windowObj.CloseButton.Parent = windowObj.TopBar
    windowObj.SidebarTabs.Parent = windowObj.Sidebar
    windowObj.MainFrame.Parent = windowObj.ScreenGui
    windowObj.ScreenGui.Parent = CoreGui
    
    -- Window state
    windowObj.isMinimized = false
    windowObj.isClosing = false
    windowObj.tabs = {}
    windowObj.currentTab = nil
    windowObj.dragging = false
    windowObj.dragStart = Vector2.new(0, 0)
    windowObj.startPos = UDim2.new(0, 0, 0, 0)
    windowObj.uiElements = {}
    
    -- Initialize window
    windowObj:setupWindow()
    
    -- Return the window object with public methods
    return windowObj
end
    self.Sidebar = createGlassFrame(
        self.MainFrame,
        UDim2.new(0,140,1,-70),
        UDim2.new(0,12,0,58),
        0.1
    )

-- Window setup and animations
function WarpHub:setupWindow()
    local function animateIn()
        self.MainFrame.Visible = true
        
        self.MainFrame.Size = UDim2.new(0, 10, 0, 10)
        self.MainFrame.Position = UDim2.new(0.5, -5, 0.5, -5)
        self.MainFrame.BackgroundTransparency = 1
        
        local tween = TweenService:Create(self.MainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0), {
            Size = UDim2.new(0, self.windowWidth, 0, self.windowHeight),
            Position = UDim2.new(0.5, -self.windowWidth/2, 0.5, -self.windowHeight/2),
            BackgroundTransparency = WarpHub.Config.DarkGlassTransparency
        })
        tween:Play()
        
        tween.Completed:Wait()
        
        -- Bounce effect
        TweenService:Create(self.MainFrame, TweenInfo.new(0.2), {
            Size = UDim2.new(0, self.windowWidth + 8, 0, self.windowHeight + 8)
        }):Play()
        
        task.wait(0.1)
        
        TweenService:Create(self.MainFrame, TweenInfo.new(0.2), {
            Size = UDim2.new(0, self.windowWidth, 0, self.windowHeight)
        }):Play()
    end
    
    local function toggleMinimize()
        if self.isClosing then return end
        
        if self.isMinimized then
            -- Restore window
            TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, self.windowWidth, 0, self.windowHeight),
                Position = UDim2.new(0.5, -self.windowWidth/2, 0.5, -self.windowHeight/2)
            }):Play()
            TweenService:Create(self.MinimizeButton, TweenInfo.new(0.15), {
                ImageColor3 = WarpHub.DefaultColors.TextColor
            }):Play()
        else
            -- Minimize window
            TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, self.windowWidth, 0, 70),
                Position = UDim2.new(0.5, -self.windowWidth/2, 0.5, -35)
            }):Play()
            TweenService:Create(self.MinimizeButton, TweenInfo.new(0.15), {
                ImageColor3 = WarpHub.DefaultColors.AccentColor
            }):Play()
        end
        self.isMinimized = not self.isMinimized
    end
    
    local function closeUI()
        if self.isClosing then return end
        self.isClosing = true
        
        local fadeTween = TweenService:Create(self.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
            Size = UDim2.new(0, 10, 0, 10),
            Position = UDim2.new(0.5, -5, 0.5, -5),
            BackgroundTransparency = 1
        })
        fadeTween:Play()
        
        fadeTween.Completed:Wait()
        
        if self.ScreenGui and self.ScreenGui.Parent then
            self.ScreenGui:Destroy()
        end
    end
    
    -- Window dragging functionality
    self.TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.dragging = true
            self.dragStart = input.Position
            self.startPos = self.MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if self.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - self.dragStart
            self.MainFrame.Position = UDim2.new(
                self.startPos.X.Scale, 
                self.startPos.X.Offset + delta.X, 
                self.startPos.Y.Scale, 
                self.startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.dragging = false
        end
    end)
    
    -- Button connections
    self.MinimizeButton.MouseButton1Click:Connect(toggleMinimize)
    self.CloseButton.MouseButton1Click:Connect(closeUI)
    
    -- Hover effects
    self.MinimizeButton.MouseEnter:Connect(function()
        if self.isClosing then return end
        TweenService:Create(self.MinimizeButton, TweenInfo.new(0.15), {
            ImageColor3 = WarpHub.DefaultColors.AccentColor,
            Size = UDim2.new(0, 24, 0, 24)
        }):Play()
    end)
    
    self.MinimizeButton.MouseLeave:Connect(function()
        if self.isClosing then return end
        TweenService:Create(self.MinimizeButton, TweenInfo.new(0.15), {
            ImageColor3 = self.isMinimized and WarpHub.DefaultColors.AccentColor or WarpHub.DefaultColors.TextColor,
            Size = UDim2.new(0, 22, 0, 22)
        }):Play()
    end)
    
    self.CloseButton.MouseEnter:Connect(function()
        if self.isClosing then return end
        TweenService:Create(self.CloseButton, TweenInfo.new(0.15), {
            ImageColor3 = Color3.fromRGB(255, 100, 100),
            Size = UDim2.new(0, 24, 0, 24)
        }):Play()
    end)
    
    self.CloseButton.MouseLeave:Connect(function()
        if self.isClosing then return end
        TweenService:Create(self.CloseButton, TweenInfo.new(0.15), {
            ImageColor3 = WarpHub.DefaultColors.TextColor,
            Size = UDim2.new(0, 22, 0, 22)
        }):Play()
    end)
    
    -- Start animation
    animateIn()
end
    self.SidebarTabs = Instance.new("Frame", self.Sidebar)
    self.SidebarTabs.Size = UDim2.new(1,-10,1,-10)
    self.SidebarTabs.Position = UDim2.new(0,5,0,5)
    self.SidebarTabs.BackgroundTransparency = 1

    local sideList = Instance.new("UIListLayout", self.SidebarTabs)
    sideList.Padding = UDim.new(0,6)

    -- Content
    self.ContentArea = createGlassFrame(
        self.MainFrame,
        UDim2.new(1,-176,1,-70),
        UDim2.new(0,164,0,58),
        0.1
    )

-- Section Divider
function WarpHub:createSectionDivider(text)
    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, 0, 0, 26)
    divider.BackgroundTransparency = 1
    
    local lineContainer = Instance.new("Frame")
    lineContainer.Size = UDim2.new(1, 0, 0, 20)
    lineContainer.BackgroundTransparency = 1
    lineContainer.Position = UDim2.new(0, 0, 0.5, -10)
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = WarpHub.DefaultColors.AccentColor
    line.BackgroundTransparency = 0.3
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(0, 90, 0, 20)
    textLabel.Position = UDim2.new(0.5, -45, 0.5, -10)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text:upper()
    textLabel.TextColor3 = WarpHub.DefaultColors.AccentColor
    textLabel.TextSize = 11
    textLabel.Font = Enum.Font.GothamBold
    
    lineContainer.Parent = divider
    line.Parent = lineContainer
    textLabel.Parent = lineContainer
    
    return divider
    self.tabs = {}
    self.currentTab = nil

    return self
end

-- Add Tab - FIXED FOR LOADSTRING USAGE
function WarpHub:AddTab(name, icon)
    local tabObj = {
        name = name,
        elements = {},
        sections = {}
    }
    
    local buttonHeight = 38
    local buttonFontSize = 13
    
    -- Create Tab Button
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, -10, 0, buttonHeight)
    TabButton.BackgroundColor3 = WarpHub.DefaultColors.GlassColor
    TabButton.BackgroundTransparency = 0.15
    TabButton.AutoButtonColor = false
    TabButton.Text = ""
    TabButton.BorderSizePixel = 0
    TabButton.LayoutOrder = #self.SidebarTabs:GetChildren() + 1
    
    -- Glass styling
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = TabButton
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.9
    stroke.Thickness = 1.2
    stroke.Parent = TabButton
    
    -- Button text
    local buttonText = Instance.new("TextLabel")
    buttonText.Size = icon and UDim2.new(1, -36, 1, 0) or UDim2.new(1, -16, 1, 0)
    buttonText.Position = UDim2.new(0, icon and 32 or 10, 0, 0)
    buttonText.BackgroundTransparency = 1
    buttonText.Text = name
    buttonText.TextColor3 = WarpHub.DefaultColors.SubTextColor
    buttonText.TextSize = buttonFontSize
    buttonText.Font = Enum.Font.GothamMedium
    buttonText.TextXAlignment = Enum.TextXAlignment.Left
    buttonText.Parent = TabButton
    
    -- Optional icon
    if icon then
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(0, 20, 0, 20)
        iconLabel.Position = UDim2.new(0, 6, 0.5, -10)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = icon
        iconLabel.TextColor3 = WarpHub.DefaultColors.SubTextColor
        iconLabel.TextSize = 14
        iconLabel.Font = Enum.Font.GothamMedium
        iconLabel.Parent = TabButton
    end
    
    -- Tab Content
    local TabContent = Instance.new("Frame")
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.Visible = false
    
    -- Scrolling content area
    local TabScrolling = Instance.new("ScrollingFrame")
    TabScrolling.Size = UDim2.new(1, -16, 1, -16)
    TabScrolling.Position = UDim2.new(0, 8, 0, 8)
    TabScrolling.BackgroundTransparency = 1
    TabScrolling.ScrollBarThickness = 4
    TabScrolling.ScrollBarImageColor3 = WarpHub.DefaultColors.AccentColor
    TabScrolling.ScrollBarImageTransparency = 0.5
    TabScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 8)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Parent = TabScrolling
    
    TabScrolling.Parent = TabContent
    
    -- Store tab data
    local tabData = {
        button = TabButton, 
        content = TabContent, 
        scrolling = TabScrolling,
        text = buttonText,
        name = name,
        icon = icon,
        obj = tabObj
    }
    table.insert(self.tabs, tabData)
    
    -- Function to select this tab
    local function selectTab()
        for _, tData in pairs(self.tabs) do
            tData.content.Visible = false
            TweenService:Create(tData.button, TweenInfo.new(0.25), {
                BackgroundTransparency = 0.15,
                BackgroundColor3 = WarpHub.DefaultColors.GlassColor
            }):Play()
            TweenService:Create(tData.text, TweenInfo.new(0.25), {
                TextColor3 = WarpHub.DefaultColors.SubTextColor
            }):Play()
        end
        
        -- Show this tab's content
        TabContent.Visible = true
        TweenService:Create(TabButton, TweenInfo.new(0.25), {
            BackgroundTransparency = 0.06,
            BackgroundColor3 = WarpHub.DefaultColors.AccentColor
        }):Play()
        TweenService:Create(buttonText, TweenInfo.new(0.25), {
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        
        self.currentTab = tabData
    end
    
    -- Button hover effects
    TabButton.MouseEnter:Connect(function()
        if self.isClosing then return end
        if not TabContent.Visible then
            TweenService:Create(TabButton, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.1
            }):Play()
            TweenService:Create(buttonText, TweenInfo.new(0.15), {
                TextColor3 = WarpHub.DefaultColors.TextColor
            }):Play()
        end
--==============================
-- TABS
--==============================
function WarpHub:AddTab(name)
    local tab = {}
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1,-10,0,36)
    button.BackgroundColor3 = WarpHub.DefaultColors.GlassColor
    button.BackgroundTransparency = 0.15
    button.Text = name
    button.Font = Enum.Font.GothamMedium
    button.TextSize = 13
    button.TextColor3 = WarpHub.DefaultColors.SubTextColor
    button.AutoButtonColor = false
    button.Parent = self.SidebarTabs

    local bc = Instance.new("UICorner", button)
    bc.CornerRadius = UDim.new(0,12)

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1,0,1,0)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.Parent = self.ContentArea

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1,-16,1,-16)
    scroll.Position = UDim2.new(0,8,0,8)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.CanvasSize = UDim2.new()
    scroll.Parent = content

    local list = Instance.new("UIListLayout", scroll)
    list.Padding = UDim.new(0,8)

    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0,0,0,list.AbsoluteContentSize.Y + 10)
    end)
    
    TabButton.MouseLeave:Connect(function()
        if self.isClosing then return end
        if not TabContent.Visible then
            TweenService:Create(TabButton, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.15
            }):Play()
            TweenService:Create(buttonText, TweenInfo.new(0.15), {
                TextColor3 = WarpHub.DefaultColors.SubTextColor
            }):Play()

    local function select()
        for _,t in pairs(self.tabs) do
            t.content.Visible = false
            t.button.TextColor3 = WarpHub.DefaultColors.SubTextColor
        end
    end)
    
    TabButton.MouseButton1Click:Connect(selectTab)
    
    -- Auto-select first tab
    if #self.tabs == 1 then
        task.wait(0.5)
        selectTab()
        content.Visible = true
        button.TextColor3 = WarpHub.DefaultColors.TextColor
        self.currentTab = tab
    end
    
    -- Add elements to parent
    TabButton.Parent = self.SidebarTabs
    TabContent.Parent = self.ContentArea
    
    -- Tab methods - SIMPLIFIED FOR LOADSTRING USAGE
    function tabObj:AddButton(name, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 36)
        Button.BackgroundColor3 = WarpHub.DefaultColors.GlassColor
        Button.BackgroundTransparency = 0.12
        Button.AutoButtonColor = false
        Button.Text = ""
        Button.LayoutOrder = #TabScrolling:GetChildren() + 1
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 14)
        buttonCorner.Parent = Button
        
        local buttonStroke = Instance.new("UIStroke")
        buttonStroke.Color = Color3.fromRGB(255, 255, 255)
        buttonStroke.Transparency = 0.9
        buttonStroke.Thickness = 1.2
        buttonStroke.Parent = Button
        
        local buttonText = Instance.new("TextLabel")
        buttonText.Size = UDim2.new(1, -16, 1, 0)
        buttonText.Position = UDim2.new(0, 10, 0, 0)
        buttonText.BackgroundTransparency = 1
        buttonText.Text = name
        buttonText.TextColor3 = WarpHub.DefaultColors.TextColor
        buttonText.TextSize = 13
        buttonText.Font = Enum.Font.GothamMedium
        buttonText.TextXAlignment = Enum.TextXAlignment.Left
        buttonText.Parent = Button
        
        Button.MouseButton1Click:Connect(function()
            if callback then 
                local success, err = pcall(callback)
                if not success then
                    warn("Button callback error:", err)
                end
            end
        end)
        
        Button.MouseEnter:Connect(function()
            if self.isClosing then return end
            TweenService:Create(Button, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.05,
                BackgroundColor3 = WarpHub.DefaultColors.AccentColor
            }):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            if self.isClosing then return end
            TweenService:Create(Button, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.12,
                BackgroundColor3 = WarpHub.DefaultColors.GlassColor
            }):Play()

    button.MouseButton1Click:Connect(select)

    if #self.tabs == 0 then
        task.delay(0.1, select)
    end

    tab.button = button
    tab.content = content
    tab.scroll = scroll

    table.insert(self.tabs, tab)

    --==============================
    -- ELEMENTS
    --==============================
    function tab:AddButton(text, callback)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1,0,0,36)
        b.Text = text
        b.Font = Enum.Font.GothamMedium
        b.TextSize = 13
        b.TextColor3 = WarpHub.DefaultColors.TextColor
        b.BackgroundColor3 = WarpHub.DefaultColors.GlassColor
        b.BackgroundTransparency = 0.12
        b.AutoButtonColor = false
        b.Parent = scroll

        Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)

        b.MouseButton1Click:Connect(function()
            if callback then pcall(callback) end
        end)
        
        Button.Parent = TabScrolling
        table.insert(tabObj.elements, Button)
        return Button
    end
    
    function tabObj:AddToggle(name, default, callback)
        local Toggle = Instance.new("Frame")
        Toggle.Size = UDim2.new(1, 0, 0, 36)
        Toggle.BackgroundTransparency = 1
        Toggle.LayoutOrder = #TabScrolling:GetChildren() + 1
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = WarpHub.DefaultColors.TextColor
        label.TextSize = 13
        label.Font = Enum.Font.GothamMedium
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = Toggle
        
        local toggleButton = Instance.new("Frame")
        toggleButton.Size = UDim2.new(0, 40, 0, 20)
        toggleButton.Position = UDim2.new(1, -40, 0.5, -10)
        toggleButton.BackgroundColor3 = default and WarpHub.DefaultColors.AccentColor or WarpHub.DefaultColors.GlassColor
        toggleButton.BackgroundTransparency = default and 0.06 or 0.15
        toggleButton.BorderSizePixel = 0
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 10)
        toggleCorner.Parent = toggleButton
        
        local toggleStroke = Instance.new("UIStroke")
        toggleStroke.Color = Color3.fromRGB(255, 255, 255)
        toggleStroke.Transparency = 0.9
        toggleStroke.Thickness = 1.2
        toggleStroke.Parent = toggleButton
        
        local toggleState = default or false
        
        local function updateToggle()
            if toggleState then
                TweenService:Create(toggleButton, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.06,
                    BackgroundColor3 = WarpHub.DefaultColors.AccentColor
                }):Play()
            else
                TweenService:Create(toggleButton, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.15,
                    BackgroundColor3 = WarpHub.DefaultColors.GlassColor
                }):Play()
            end
            
            if callback then 
                pcall(callback, toggleState)
            end

    function tab:AddToggle(text, default, callback)
        local state = default or false

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,0,0,36)
        btn.Text = text
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 13
        btn.TextColor3 = WarpHub.DefaultColors.TextColor
        btn.AutoButtonColor = false
        btn.BackgroundTransparency = 0
        btn.Parent = scroll

        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)

        local function refresh()
            btn.BackgroundColor3 = state and WarpHub.DefaultColors.AccentColor or WarpHub.DefaultColors.GlassColor
            if callback then pcall(callback, state) end
        end
        
        toggleButton.MouseButton1Click:Connect(function()
            toggleState = not toggleState
            updateToggle()
        end)
        
        toggleButton.MouseEnter:Connect(function()
            TweenService:Create(toggleButton, TweenInfo.new(0.1), {
                Size = UDim2.new(0, 42, 0, 22)
            }):Play()
        end)
        
        toggleButton.MouseLeave:Connect(function()
            TweenService:Create(toggleButton, TweenInfo.new(0.1), {
                Size = UDim2.new(0, 40, 0, 20)
            }):Play()

        btn.MouseButton1Click:Connect(function()
            state = not state
            refresh()
        end)
        
        label.Parent = Toggle
        toggleButton.Parent = Toggle
        Toggle.Parent = TabScrolling
        table.insert(tabObj.elements, Toggle)
        return Toggle

        refresh()
    end
    
    function tabObj:AddSlider(name, min, max, default, callback)
        local currentValue = math.clamp(default or min, min, max)
        
        local Slider = Instance.new("Frame")
        Slider.Size = UDim2.new(1, 0, 0, 52)
        Slider.BackgroundTransparency = 1
        Slider.LayoutOrder = #TabScrolling:GetChildren() + 1
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -50, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = WarpHub.DefaultColors.TextColor
        label.TextSize = 13
        label.Font = Enum.Font.GothamMedium
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = Slider
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 45, 0, 20)
        valueLabel.Position = UDim2.new(1, -45, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(currentValue)
        valueLabel.TextColor3 = WarpHub.DefaultColors.AccentColor
        valueLabel.TextSize = 13
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = Slider
        
        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, 0, 0, 6)
        track.Position = UDim2.new(0, 0, 0, 30)
        track.BackgroundColor3 = WarpHub.DefaultColors.GlassColor
        track.BackgroundTransparency = 0.15
        track.BorderSizePixel = 0
        
        local trackCorner = Instance.new("UICorner")
        trackCorner.CornerRadius = UDim.new(0, 3)
        trackCorner.Parent = track
        
        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((currentValue - min) / (max - min), 0, 1, 0)

    function tab:AddSlider(text, min, max, default, callback)
        local value = default or min

        local holder = Instance.new("Frame", scroll)
        holder.Size = UDim2.new(1,0,0,52)
        holder.BackgroundTransparency = 1

        local lbl = Instance.new("TextLabel", holder)
        lbl.Size = UDim2.new(1,0,0,20)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = WarpHub.DefaultColors.TextColor
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextSize = 13

        local bar = Instance.new("Frame", holder)
        bar.Size = UDim2.new(1,0,0,6)
        bar.Position = UDim2.new(0,0,0,34)
        bar.BackgroundColor3 = WarpHub.DefaultColors.GlassColor
        Instance.new("UICorner", bar).CornerRadius = UDim.new(0,3)

        local fill = Instance.new("Frame", bar)
        fill.BackgroundColor3 = WarpHub.DefaultColors.AccentColor
        fill.BackgroundTransparency = 0.1
        fill.BorderSizePixel = 0
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 3)
        fillCorner.Parent = fill
        
        local handle = Instance.new("Frame")
        handle.Size = UDim2.new(0, 16, 0, 16)
        handle.Position = UDim2.new((currentValue - min) / (max - min), -8, 0.5, -8)
        handle.BackgroundColor3 = WarpHub.DefaultColors.AccentColor
        handle.BackgroundTransparency = 0.06
        handle.BorderSizePixel = 0
        
        local handleCorner = Instance.new("UICorner")
        handleCorner.CornerRadius = UDim.new(0, 8)
        handleCorner.Parent = handle
        
        local handleStroke = Instance.new("UIStroke")
        handleStroke.Color = Color3.fromRGB(255, 255, 255)
        handleStroke.Transparency = 0.9
        handleStroke.Thickness = 1.2
        handleStroke.Parent = handle
        
        local sliding = false
        
        local function updateSlider(value)
            currentValue = math.clamp(value, min, max)
            local percent = (currentValue - min) / (max - min)
            
            fill.Size = UDim2.new(percent, 0, 1, 0)
            valueLabel.Text = tostring(math.floor(currentValue))
            
            TweenService:Create(handle, TweenInfo.new(0.1), {
                Position = UDim2.new(percent, -8, 0.5, -8)
            }):Play()
            
            if callback then 
                pcall(callback, currentValue)
            end
        end
        
        handle.MouseButton1Down:Connect(function()
            sliding = true
            TweenService:Create(handle, TweenInfo.new(0.1), {
                Size = UDim2.new(0, 18, 0, 18)
            }):Play()
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                sliding = false
                TweenService:Create(handle, TweenInfo.new(0.15), {
                    Size = UDim2.new(0, 16, 0, 16)
                }):Play()
        Instance.new("UICorner", fill).CornerRadius = UDim.new(0,3)

        local dragging = false

        bar.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true
            end
        end)
        
        local connection = RunService.RenderStepped:Connect(function()
            if sliding then
                local mousePos = UserInputService:GetMouseLocation()
                local trackPos = track.AbsolutePosition
                local trackSize = track.AbsoluteSize
                
                local relativeX = (mousePos.X - trackPos.X) / trackSize.X
                relativeX = math.clamp(relativeX, 0, 1)
                
                local value = min + (relativeX * (max - min))
                updateSlider(value)

        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        Slider.Destroying:Connect(function()
            connection:Disconnect()
        end)
        
        fill.Parent = track
        handle.Parent = track
        track.Parent = Slider
        Slider.Parent = TabScrolling
        table.insert(tabObj.elements, Slider)
        return Slider
    end
    
    function tabObj:AddLabel(text)
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 0, 30)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = WarpHub.DefaultColors.TextColor
        Label.TextSize = 14
        Label.Font = Enum.Font.GothamMedium
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.LayoutOrder = #TabScrolling:GetChildren() + 1
        Label.Parent = TabScrolling
        table.insert(tabObj.elements, Label)
        return Label
    end
    
    function tabObj:AddDivider(text)
        -- Call the WarpHub method instead of trying to call it on self
        local divider = WarpHub:createSectionDivider(text or "")
        divider.LayoutOrder = #TabScrolling:GetChildren() + 1
        divider.Parent = TabScrolling
        table.insert(tabObj.elements, divider)
        return divider
    end
    
    function tabObj:AddSection(name)
        local section = {
            name = name,
            elements = {}
        }
    
        -- Add section title as a divider using the correct method
        local sectionTitle = WarpHub:createSectionDivider(name)
        sectionTitle.LayoutOrder = #TabScrolling:GetChildren() + 1
        sectionTitle.Parent = TabScrolling
        table.insert(tabObj.elements, sectionTitle)
        table.insert(tabObj.sections, section)
        return section
    end
    
    function tabObj:AddTextBox(name, placeholder, callback)
        local TextBox = Instance.new("Frame")
        TextBox.Size = UDim2.new(1, 0, 0, 36)
        TextBox.BackgroundTransparency = 1
        TextBox.LayoutOrder = #TabScrolling:GetChildren() + 1
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.4, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = WarpHub.DefaultColors.TextColor
        label.TextSize = 13
        label.Font = Enum.Font.GothamMedium
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = TextBox
        
        local inputBox = Instance.new("TextBox")
        inputBox.Size = UDim2.new(0.55, 0, 0.7, 0)
        inputBox.Position = UDim2.new(0.4, 0, 0.15, 0)
        inputBox.BackgroundColor3 = WarpHub.DefaultColors.GlassColor
        inputBox.BackgroundTransparency = 0.2
        inputBox.TextColor3 = WarpHub.DefaultColors.TextColor
        inputBox.Text = ""
        inputBox.TextSize = 12
        inputBox.Font = Enum.Font.GothamMedium
        inputBox.PlaceholderText = placeholder or "Enter text..."
        inputBox.PlaceholderColor3 = WarpHub.DefaultColors.SubTextColor
        inputBox.ClearTextOnFocus = false
        
        local inputCorner = Instance.new("UICorner")
        inputCorner.CornerRadius = UDim.new(0, 6)
        inputCorner.Parent = inputBox
        
        inputBox.FocusLost:Connect(function(enterPressed)
            if enterPressed and callback then
                pcall(callback, inputBox.Text)

        RunService.RenderStepped:Connect(function()
            if dragging then
                local x = math.clamp(
                    (UserInputService:GetMouseLocation().X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
                    0,1
                )
                value = math.floor(min + (max-min)*x)
                fill.Size = UDim2.new(x,0,1,0)
                if callback then pcall(callback,value) end
            end
        end)
        
        inputBox.Parent = TextBox
        TextBox.Parent = TabScrolling
        table.insert(tabObj.elements, TextBox)
        return TextBox
    end
    
    return tabObj
end

-- Destroy window
function WarpHub:Destroy()
    if self.ScreenGui and self.ScreenGui.Parent then
        self.ScreenGui:Destroy()
    end
end

-- Toggle visibility
function WarpHub:Toggle()
    if self.ScreenGui then
        self.ScreenGui.Enabled = not self.ScreenGui.Enabled
    end
end

-- Show window
function WarpHub:Show()
    if self.ScreenGui then
        self.ScreenGui.Enabled = true
    function tab:AddLabel(text)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1,0,0,26)
        l.BackgroundTransparency = 1
        l.Text = text
        l.Font = Enum.Font.GothamMedium
        l.TextSize = 13
        l.TextColor3 = WarpHub.DefaultColors.TextColor
        l.TextXAlignment = Left
        l.Parent = scroll
    end
end

-- Hide window
function WarpHub:Hide()
    if self.ScreenGui then
        self.ScreenGui.Enabled = false
    end
    return tab
end

-- Add a simple Quick function for easy usage
function WarpHub.Quick(title, tabName, icon)
    local window = WarpHub:CreateWindow(title)
    local tab = window:AddTab(tabName or "Main", icon)
    return window, tab
--==============================
-- QUICK
--==============================
function WarpHub.Quick(title, tabName)
    local win = WarpHub:CreateWindow(title)
    local tab = win:AddTab(tabName or "Main")
    return win, tab
end

-- Return the library
return WarpHub
