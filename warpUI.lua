-- WarpHub UI Library
-- Version: 2.0
-- Load this library with: loadstring(game:HttpGet("YOUR_RAW_URL"))()

local WarpHub = {}
WarpHub.__index = WarpHub

-- Default Colors (can be customized by users)
WarpHub.DefaultColors = {
    AccentColor = Color3.fromRGB(168, 128, 255),
    SecondaryColor = Color3.fromRGB(128, 96, 255),
    GlassColor = Color3.fromRGB(20, 20, 30),
    DarkGlassColor = Color3.fromRGB(10, 10, 18),
    TextColor = Color3.fromRGB(255, 255, 255),
    SubTextColor = Color3.fromRGB(220, 220, 240)
}

-- Configuration settings
WarpHub.Config = {
    Version = "2.0",
    SplashScreenEnabled = true,
    GlassTransparency = 0.12,
    DarkGlassTransparency = 0.08,
    CornerRadius = 14,
    AnimationSpeed = 0.25
}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Helper function to detect mobile
local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end

-- Initialize colors with defaults
function WarpHub:SetColors(colors)
    for colorName, value in pairs(colors) do
        if WarpHub.DefaultColors[colorName] then
            WarpHub.DefaultColors[colorName] = value
        end
    end
end

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

-- Create Window
function WarpHub:CreateWindow(title, settings)
    local self = setmetatable({}, WarpHub)
    
    -- Apply custom settings if provided
    if settings then
        if settings.SplashScreenEnabled ~= nil then
            WarpHub.Config.SplashScreenEnabled = settings.SplashScreenEnabled
        end
        if settings.CustomColors then
            self:SetColors(settings.CustomColors)
        end
    end
    
    -- Show splash screen
    showSplashScreen()
    task.wait(2.5)
    
    -- Create main GUI
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "WarpHubUI_" .. tostring(math.random(10000, 99999))
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    self.ScreenGui.ResetOnSpawn = false
    
    local screenSize = workspace.CurrentCamera.ViewportSize
    local isMobileDevice = isMobile()
    
    self.windowWidth = isMobileDevice and math.min(580, screenSize.X * 0.9) or 620
    self.windowHeight = isMobileDevice and math.min(480, screenSize.Y * 0.8) or 500
    
    self.MainFrame = createGlassFrame(nil, UDim2.new(0, self.windowWidth, 0, self.windowHeight), 
        UDim2.new(0.5, -self.windowWidth/2, 0.5, -self.windowHeight/2), 
        WarpHub.Config.DarkGlassTransparency)
    self.MainFrame.BackgroundColor3 = WarpHub.DefaultColors.DarkGlassColor
    self.MainFrame.Visible = false
    
    local sidebarWidth = 140
    local topBarHeight = 46
    
    -- Top Bar
    self.TopBar = createGlassFrame(self.MainFrame, UDim2.new(1, -24, 0, topBarHeight), 
        UDim2.new(0, 12, 0, 12), 0.1)
    self.TopBar.BackgroundColor3 = WarpHub.DefaultColors.GlassColor
    
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
    self.MinimizeButton = Instance.new("ImageButton")
    self.MinimizeButton.Size = UDim2.new(0, 22, 0, 22)
    self.MinimizeButton.Position = UDim2.new(1, -52, 0.5, -11)
    self.MinimizeButton.BackgroundTransparency = 1
    self.MinimizeButton.Image = "rbxassetid://3926305904"
    self.MinimizeButton.ImageRectOffset = Vector2.new(564, 284)
    self.MinimizeButton.ImageRectSize = Vector2.new(36, 36)
    self.MinimizeButton.ImageColor3 = WarpHub.DefaultColors.TextColor
    
    -- Close button
    self.CloseButton = Instance.new("ImageButton")
    self.CloseButton.Size = UDim2.new(0, 22, 0, 22)
    self.CloseButton.Position = UDim2.new(1, -24, 0.5, -11)
    self.CloseButton.BackgroundTransparency = 1
    self.CloseButton.Image = "rbxassetid://3926305904"
    self.CloseButton.ImageRectOffset = Vector2.new(284, 4)
    self.CloseButton.ImageRectSize = Vector2.new(24, 24)
    self.CloseButton.ImageColor3 = WarpHub.DefaultColors.TextColor
    
    -- Sidebar
    self.Sidebar = createGlassFrame(self.MainFrame, UDim2.new(0, sidebarWidth, 1, -(topBarHeight + 24)), 
        UDim2.new(0, 12, 0, topBarHeight + 18), 0.1)
    
    -- Content Area
    self.ContentArea = createGlassFrame(self.MainFrame, UDim2.new(1, -(sidebarWidth + 24), 1, -(topBarHeight + 24)), 
        UDim2.new(0, sidebarWidth + 18, 0, topBarHeight + 18), 0.1)
    
    -- Sidebar tabs container
    self.SidebarTabs = Instance.new("Frame")
    self.SidebarTabs.Size = UDim2.new(1, -10, 1, -10)
    self.SidebarTabs.Position = UDim2.new(0, 5, 0, 5)
    self.SidebarTabs.BackgroundTransparency = 1
    
    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, 6)
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Parent = self.SidebarTabs
    
    -- Parent elements
    windowTitle.Parent = titleContainer
    titleContainer.Parent = self.TopBar
    self.MinimizeButton.Parent = self.TopBar
    self.CloseButton.Parent = self.TopBar
    self.SidebarTabs.Parent = self.Sidebar
    self.MainFrame.Parent = self.ScreenGui
    self.ScreenGui.Parent = CoreGui
    
    -- Window state
    self.isMinimized = false
    self.isClosing = false
    self.tabs = {}
    self.currentTab = nil
    self.dragging = false
    self.dragStart = Vector2.new(0, 0)
    self.startPos = UDim2.new(0, 0, 0, 0)
    
    -- Initialize window
    self:setupWindow()
    
    return self
end

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
end

-- Add Tab
function WarpHub:AddTab(name, icon)
    local tab = {}
    setmetatable(tab, {__index = self})
    
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
        icon = icon
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
        end
    end)
    
    TabButton.MouseButton1Click:Connect(selectTab)
    
    -- Auto-select first tab
    if #self.tabs == 1 then
        task.wait(0.5)
        selectTab()
    end
    
    -- Add elements to parent
    TabButton.Parent = self.SidebarTabs
    TabContent.Parent = self.ContentArea
    
    -- Tab methods
    function tab:AddSection(title)
        local section = {}
        
        -- Section container
        local SectionContainer = Instance.new("Frame")
        SectionContainer.Size = UDim2.new(1, -12, 0, 0)
        SectionContainer.Position = UDim2.new(0, 6, 0, 0)
        SectionContainer.BackgroundTransparency = 1
        SectionContainer.LayoutOrder = #TabScrolling:GetChildren() + 1
        
        -- Section header
        local SectionHeader = Instance.new("Frame")
        SectionHeader.Size = UDim2.new(1, 0, 0, 40)
        SectionHeader.BackgroundColor3 = WarpHub.DefaultColors.GlassColor
        SectionHeader.BackgroundTransparency = 0.08
        SectionHeader.BorderSizePixel = 0
        
        local sectionCorner = Instance.new("UICorner")
        sectionCorner.CornerRadius = UDim.new(0, 14)
        sectionCorner.Parent = SectionHeader
        
        local sectionStroke = Instance.new("UIStroke")
        sectionStroke.Color = Color3.fromRGB(255, 255, 255)
        sectionStroke.Transparency = 0.9
        sectionStroke.Thickness = 1.2
        sectionStroke.Parent = SectionHeader
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -16, 1, 0)
        titleLabel.Position = UDim2.new(0, 10, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = WarpHub.DefaultColors.TextColor
        titleLabel.TextSize = 15
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = SectionHeader
        
        -- Section content
        local SectionContent = Instance.new("Frame")
        SectionContent.Size = UDim2.new(1, 0, 0, 0)
        SectionContent.Position = UDim2.new(0, 0, 0, 44)
        SectionContent.BackgroundTransparency = 1
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.Padding = UDim.new(0, 8)
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Parent = SectionContent
        
        -- Auto-size function
        local function updateSectionHeight()
            local totalHeight = 0
            for _, child in ipairs(SectionContent:GetChildren()) do
                if child:IsA("Frame") or child:IsA("TextButton") then
                    totalHeight = totalHeight + child.Size.Y.Offset
                end
            end
            
            totalHeight = totalHeight + (ContentList.Padding.Offset * (#SectionContent:GetChildren() - 1))
            SectionContent.Size = UDim2.new(1, 0, 0, totalHeight)
            SectionContainer.Size = UDim2.new(1, -12, 0, 44 + totalHeight)
        end
        
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSectionHeight)
        
        -- Parent elements
        SectionHeader.Parent = SectionContainer
        SectionContent.Parent = SectionContainer
        SectionContainer.Parent = TabScrolling
        
        -- Section methods
        function section:AddButton(name, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 36)
            Button.BackgroundColor3 = WarpHub.DefaultColors.GlassColor
            Button.BackgroundTransparency = 0.12
            Button.AutoButtonColor = false
            Button.Text = ""
            Button.LayoutOrder = #SectionContent:GetChildren() + 1
            
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
            end)
            
            Button.Parent = SectionContent
            updateSectionHeight()
            
            -- Return button object for further customization
            local buttonObj = {
                Instance = Button,
                SetText = function(text)
                    buttonText.Text = text
                end,
                SetCallback = function(newCallback)
                    callback = newCallback
                end
            }
            
            return buttonObj
        end
        
        function section:AddSlider(name, min, max, default, callback)
            local sliderObj = {}
            local currentValue = math.clamp(default or min, min, max)
            
            local Slider = Instance.new("Frame")
            Slider.Size = UDim2.new(1, 0, 0, 52)
            Slider.BackgroundTransparency = 1
            Slider.LayoutOrder = #SectionContent:GetChildren() + 1
            
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
                end
            end)
            
            Slider.Destroying:Connect(function()
                connection:Disconnect()
            end)
            
            fill.Parent = track
            handle.Parent = track
            track.Parent = Slider
            Slider.Parent = SectionContent
            
            updateSectionHeight()
            
            -- Return slider object
            sliderObj.Instance = Slider
            sliderObj.GetValue = function() return currentValue end
            sliderObj.SetValue = function(value)
                updateSlider(math.clamp(value, min, max))
            end
            
            return sliderObj
        end
        
        function section:AddToggle(name, default, callback)
            local toggleObj = {}
            local toggleState = default or false
            
            local Toggle = Instance.new("Frame")
            Toggle.Size = UDim2.new(1, 0, 0, 36)
            Toggle.BackgroundTransparency = 1
            Toggle.LayoutOrder = #SectionContent:GetChildren() + 1
            
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
            toggleButton.BackgroundColor3 = toggleState and WarpHub.DefaultColors.AccentColor or WarpHub.DefaultColors.GlassColor
            toggleButton.BackgroundTransparency = toggleState and 0.06 or 0.15
            toggleButton.BorderSizePixel = 0
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 10)
            toggleCorner.Parent = toggleButton
            
            local toggleStroke = Instance.new("UIStroke")
            toggleStroke.Color = Color3.fromRGB(255, 255, 255)
            toggleStroke.Transparency = 0.9
            toggleStroke.Thickness = 1.2
            toggleStroke.Parent = toggleButton
            
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
            end)
            
            label.Parent = Toggle
            toggleButton.Parent = Toggle
            Toggle.Parent = SectionContent
            
            updateToggle()
            updateSectionHeight()
            
            -- Return toggle object
            toggleObj.Instance = Toggle
            toggleObj.GetState = function() return toggleState end
            toggleObj.SetState = function(state)
                toggleState = state
                updateToggle()
            end
            toggleObj.Toggle = function()
                toggleState = not toggleState
                updateToggle()
            end
            
            return toggleObj
        end
        
        function section:AddDivider(text)
            local divider = self:createSectionDivider(text or "")
            divider.LayoutOrder = #SectionContent:GetChildren() + 1
            divider.Parent = SectionContent
            updateSectionHeight()
            return divider
        end
        
        function section:AddTextBox(name, placeholder, callback)
            local textboxObj = {}
            
            local TextBox = Instance.new("Frame")
            TextBox.Size = UDim2.new(1, 0, 0, 36)
            TextBox.BackgroundTransparency = 1
            TextBox.LayoutOrder = #SectionContent:GetChildren() + 1
            
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
                end
            end)
            
            inputBox.Parent = TextBox
            TextBox.Parent = SectionContent
            
            updateSectionHeight()
            
            -- Return textbox object
            textboxObj.Instance = inputBox
            textboxObj.GetText = function() return inputBox.Text end
            textboxObj.SetText = function(text)
                inputBox.Text = text
            end
            
            return textboxObj
        end
        
        function section:AddDropdown(name, options, default, callback)
            local dropdownObj = {}
            local selectedOption = default or (options[1] or "")
            
            local Dropdown = Instance.new("Frame")
            Dropdown.Size = UDim2.new(1, 0, 0, 36)
            Dropdown.BackgroundTransparency = 1
            Dropdown.LayoutOrder = #SectionContent:GetChildren() + 1
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.4, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = WarpHub.DefaultColors.TextColor
            label.TextSize = 13
            label.Font = Enum.Font.GothamMedium
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = Dropdown
            
            local dropdownButton = Instance.new("TextButton")
            dropdownButton.Size = UDim2.new(0.55, 0, 0.7, 0)
            dropdownButton.Position = UDim2.new(0.4, 0, 0.15, 0)
            dropdownButton.BackgroundColor3 = WarpHub.DefaultColors.GlassColor
            dropdownButton.BackgroundTransparency = 0.2
            dropdownButton.TextColor3 = WarpHub.DefaultColors.TextColor
            dropdownButton.Text = selectedOption
            dropdownButton.TextSize = 12
            dropdownButton.Font = Enum.Font.GothamMedium
            dropdownButton.AutoButtonColor = false
            
            local dropdownCorner = Instance.new("UICorner")
            dropdownCorner.CornerRadius = UDim.new(0, 6)
            dropdownCorner.Parent = dropdownButton
            
            local dropdownStroke = Instance.new("UIStroke")
            dropdownStroke.Color = Color3.fromRGB(255, 255, 255)
            dropdownStroke.Transparency = 0.7
            dropdownStroke.Thickness = 1
            dropdownStroke.Parent = dropdownButton
            
            local dropdownOpen = false
            
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Size = UDim2.new(0.55, 0, 0, math.min(120, #options * 30 + 8))
            dropdownFrame.Position = UDim2.new(0.4, 0, 1.1, 0)
            dropdownFrame.BackgroundColor3 = WarpHub.DefaultColors.GlassColor
            dropdownFrame.BackgroundTransparency = 0.1
            dropdownFrame.BorderSizePixel = 0
            dropdownFrame.Visible = false
            dropdownFrame.ZIndex = 10
            
            local dropdownCorner2 = Instance.new("UICorner")
            dropdownCorner2.CornerRadius = UDim.new(0, 6)
            dropdownCorner2.Parent = dropdownFrame
            
            local dropdownStroke2 = Instance.new("UIStroke")
            dropdownStroke2.Color = Color3.fromRGB(255, 255, 255)
            dropdownStroke2.Transparency = 0.9
            dropdownStroke2.Thickness = 1.2
            dropdownStroke2.Parent = dropdownFrame
            
            local dropdownScrolling = Instance.new("ScrollingFrame")
            dropdownScrolling.Size = UDim2.new(1, -8, 1, -8)
            dropdownScrolling.Position = UDim2.new(0, 4, 0, 4)
            dropdownScrolling.BackgroundTransparency = 1
            dropdownScrolling.ScrollBarThickness = 2
            dropdownScrolling.ScrollBarImageColor3 = WarpHub.DefaultColors.AccentColor
            dropdownScrolling.CanvasSize = UDim2.new(0, 0, 0, #options * 30)
            
            local dropdownList = Instance.new("UIListLayout")
            dropdownList.Padding = UDim.new(0, 2)
            dropdownList.SortOrder = Enum.SortOrder.LayoutOrder
            dropdownList.Parent = dropdownScrolling
            
            for i, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Size = UDim2.new(1, 0, 0, 28)
                optionButton.BackgroundColor3 = WarpHub.DefaultColors.GlassColor
                optionButton.BackgroundTransparency = 0.3
                optionButton.TextColor3 = WarpHub.DefaultColors.TextColor
                optionButton.Text = option
                optionButton.TextSize = 11
                optionButton.Font = Enum.Font.GothamMedium
                optionButton.AutoButtonColor = false
                optionButton.LayoutOrder = i
                
                optionButton.MouseButton1Click:Connect(function()
                    selectedOption = option
                    dropdownButton.Text = option
                    dropdownFrame.Visible = false
                    dropdownOpen = false
                    
                    if callback then
                        pcall(callback, option)
                    end
                end)
                
                optionButton.MouseEnter:Connect(function()
                    TweenService:Create(optionButton, TweenInfo.new(0.15), {
                        BackgroundTransparency = 0.1,
                        BackgroundColor3 = WarpHub.DefaultColors.AccentColor
                    }):Play()
                end)
                
                optionButton.MouseLeave:Connect(function()
                    TweenService:Create(optionButton, TweenInfo.new(0.15), {
                        BackgroundTransparency = 0.3,
                        BackgroundColor3 = WarpHub.DefaultColors.GlassColor
                    }):Play()
                end)
                
                optionButton.Parent = dropdownScrolling
            end
            
            local function toggleDropdown()
                dropdownOpen = not dropdownOpen
                dropdownFrame.Visible = dropdownOpen
            end
            
            dropdownButton.MouseButton1Click:Connect(toggleDropdown)
            
            -- Close dropdown when clicking outside
            UserInputService.InputBegan:Connect(function(input)
                if dropdownOpen and input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mousePos = input.Position
                    local dropdownPos = dropdownFrame.AbsolutePosition
                    local dropdownSize = dropdownFrame.AbsoluteSize
                    
                    if not (mousePos.X >= dropdownPos.X and mousePos.X <= dropdownPos.X + dropdownSize.X and
                           mousePos.Y >= dropdownPos.Y and mousePos.Y <= dropdownPos.Y + dropdownSize.Y) then
                        dropdownOpen = false
                        dropdownFrame.Visible = false
                    end
                end
            end)
            
            dropdownScrolling.Parent = dropdownFrame
            dropdownFrame.Parent = Dropdown
            dropdownButton.Parent = Dropdown
            Dropdown.Parent = SectionContent
            
            updateSectionHeight()
            
            -- Return dropdown object
            dropdownObj.Instance = Dropdown
            dropdownObj.GetValue = function() return selectedOption end
            dropdownObj.SetValue = function(value)
                if table.find(options, value) then
                    selectedOption = value
                    dropdownButton.Text = value
                    if callback then pcall(callback, value) end
                end
            end
            
            return dropdownObj
        end
        
        return section
    end
    
    return tab
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
    end
end

-- Hide window
function WarpHub:Hide()
    if self.ScreenGui then
        self.ScreenGui.Enabled = false
    end
end

-- Return the library
return WarpHub
