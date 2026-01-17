-- WarpHub UI Library
-- Version: 2.5
-- Load with: loadstring(game:HttpGet("YOUR_RAW_URL"))()

local WarpHub = {}
WarpHub.__index = WarpHub

-- Version info
WarpHub.Version = "2.5"

-- Default configuration
WarpHub.Config = {
    SplashScreenEnabled = true,
    SplashDuration = 2.5,
    GlassTransparency = 0.12,
    DarkGlassTransparency = 0.08,
    CornerRadius = 14,
    AnimationSpeed = 0.25,
    AccentColor = Color3.fromRGB(168, 128, 255),
    SecondaryColor = Color3.fromRGB(128, 96, 255),
    GlassColor = Color3.fromRGB(20, 20, 30),
    DarkGlassColor = Color3.fromRGB(10, 10, 18),
    TextColor = Color3.fromRGB(255, 255, 255),
    SubTextColor = Color3.fromRGB(220, 220, 240),
    ErrorColor = Color3.fromRGB(255, 85, 85),
    SuccessColor = Color3.fromRGB(85, 255, 127)
}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- Helper function to detect mobile
local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end

-- Helper function to create glass frames
local function createGlassFrame(parent, size, position, transparency, color, noStroke, cornerRadius)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = color or WarpHub.Config.GlassColor
    frame.BackgroundTransparency = transparency or WarpHub.Config.GlassTransparency
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, cornerRadius or WarpHub.Config.CornerRadius)
    corner.Parent = frame

    if not noStroke then
        local stroke = Instance.new("UIStroke")
        stroke.Color = color or WarpHub.Config.GlassColor
        stroke.Thickness = 1.2
        stroke.Transparency = 0.7
        stroke.Parent = frame
    end

    if parent then
        frame.Parent = parent
    end
    
    return frame
end

-- Show splash screen
local function showSplashScreen(config)
    if not config.SplashScreenEnabled then
        return
    end
    
    local splashGui = Instance.new("ScreenGui")
    splashGui.Name = "WarpHubSplash_" .. HttpService:GenerateGUID(false)
    splashGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    splashGui.IgnoreGuiInset = true
    
    local screenDim = Instance.new("Frame")
    screenDim.Size = UDim2.new(1, 0, 1, 0)
    screenDim.BackgroundColor3 = Color3.new(0, 0, 0)
    screenDim.BackgroundTransparency = 1
    screenDim.Parent = splashGui
    
    local logoContainer = Instance.new("Frame")
    logoContainer.Size = UDim2.new(0, 200, 0, 200)
    logoContainer.Position = UDim2.new(0.5, -100, 0.5, -100)
    logoContainer.BackgroundTransparency = 1
    logoContainer.Parent = splashGui
    
    local logoBg = createGlassFrame(logoContainer, UDim2.new(1, 0, 1, 0), 
        UDim2.new(0, 0, 0, 0), 0.2, config.AccentColor)
    logoBg.BackgroundTransparency = 0.8
    
    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(1, 0, 1, 0)
    logo.BackgroundTransparency = 1
    logo.Text = "WARP"
    logo.TextColor3 = Color3.new(1, 1, 1)
    logo.TextSize = 38
    logo.Font = Enum.Font.GothamBlack
    logo.TextStrokeTransparency = 0.7
    logo.TextStrokeColor3 = config.AccentColor
    
    local logoGradient = Instance.new("UIGradient")
    logoGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, config.AccentColor),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, config.SecondaryColor)
    })
    logoGradient.Parent = logo
    
    logo.Parent = logoContainer
    splashGui.Parent = CoreGui
    
    -- Animation sequence
    TweenService:Create(screenDim, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {
        BackgroundTransparency = 0.3
    }):Play()
    
    task.wait(0.2)
    
    TweenService:Create(logoContainer, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 220, 0, 220),
        Position = UDim2.new(0.5, -110, 0.5, -110)
    }):Play()
    
    task.wait(0.3)
    
    TweenService:Create(logoContainer, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 200, 0, 200),
        Position = UDim2.new(0.5, -100, 0.5, -100)
    }):Play()
    
    TweenService:Create(logoBg, TweenInfo.new(0.5), {
        BackgroundTransparency = 0.3
    }):Play()
    
    task.wait(config.SplashDuration)
    
    -- Fade out
    TweenService:Create(screenDim, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
        BackgroundTransparency = 1
    }):Play()
    
    TweenService:Create(logoContainer, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    
    task.wait(0.5)
    splashGui:Destroy()
end

-- Create Window
function WarpHub:CreateWindow(title, settings)
    local self = setmetatable({}, WarpHub)
    
    -- Merge settings with defaults
    local config = table.clone(WarpHub.Config)
    if settings then
        for key, value in pairs(settings) do
            if config[key] ~= nil then
                config[key] = value
            end
        end
    end
    
    self.config = config
    
    -- Show splash screen
    showSplashScreen(config)
    
    -- Create main GUI
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "WarpHubUI_" .. HttpService:GenerateGUID(false)
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    self.ScreenGui.ResetOnSpawn = false
    
    -- Window sizing
    local isMobileDevice = isMobile()
    local screenSize = workspace.CurrentCamera.ViewportSize
    self.windowWidth = isMobileDevice and math.min(400, screenSize.X * 0.9) or 500
    self.windowHeight = isMobileDevice and math.min(480, screenSize.Y * 0.8) or 500
    
    -- Main container
    self.MainFrame = createGlassFrame(nil, UDim2.new(0, self.windowWidth, 0, self.windowHeight), 
        UDim2.new(0.5, -self.windowWidth/2, 0.5, -self.windowHeight/2), 
        config.DarkGlassTransparency, config.DarkGlassColor, false, config.CornerRadius)
    self.MainFrame.Visible = false
    
    local sidebarWidth = 140
    local topBarHeight = 46
    
    -- Top Bar
    self.TopBar = createGlassFrame(self.MainFrame, UDim2.new(1, -24, 0, topBarHeight), 
        UDim2.new(0, 12, 0, 12), 0.1, config.GlassColor, false, config.CornerRadius)
    
    -- Title
    local titleContainer = Instance.new("Frame")
    titleContainer.Size = UDim2.new(0, 200, 1, 0)
    titleContainer.BackgroundTransparency = 1
    titleContainer.Parent = self.TopBar
    
    local windowTitle = Instance.new("TextLabel")
    windowTitle.Size = UDim2.new(1, -12, 1, 0)
    windowTitle.Position = UDim2.new(0, 12, 0, 0)
    windowTitle.BackgroundTransparency = 1
    windowTitle.Text = title or "WARP HUB"
    windowTitle.TextColor3 = config.TextColor
    windowTitle.TextSize = isMobileDevice and 18 or 20
    windowTitle.Font = Enum.Font.GothamBlack
    windowTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local titleGlow = Instance.new("UIGradient")
    titleGlow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, config.AccentColor),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    titleGlow.Parent = windowTitle
    windowTitle.Parent = titleContainer
    
    -- Minimize button
    self.MinimizeButton = Instance.new("ImageButton")
    self.MinimizeButton.Size = UDim2.new(0, 22, 0, 22)
    self.MinimizeButton.Position = UDim2.new(1, -80, 0.5, -11)
    self.MinimizeButton.BackgroundTransparency = 1
    self.MinimizeButton.Image = "rbxassetid://3926305904"
    self.MinimizeButton.ImageRectOffset = Vector2.new(564, 284)
    self.MinimizeButton.ImageRectSize = Vector2.new(36, 36)
    self.MinimizeButton.ImageColor3 = config.TextColor
    
    -- Close button
    self.CloseButton = Instance.new("ImageButton")
    self.CloseButton.Size = UDim2.new(0, 22, 0, 22)
    self.CloseButton.Position = UDim2.new(1, -40, 0.5, -11)
    self.CloseButton.BackgroundTransparency = 1
    self.CloseButton.Image = "rbxassetid://3926305904"
    self.CloseButton.ImageRectOffset = Vector2.new(284, 4)
    self.CloseButton.ImageRectSize = Vector2.new(24, 24)
    self.CloseButton.ImageColor3 = config.TextColor
    
    -- Sidebar
    self.Sidebar = createGlassFrame(self.MainFrame, UDim2.new(0, sidebarWidth, 1, -(topBarHeight + 24)), 
        UDim2.new(0, 12, 0, topBarHeight + 18), 0.1, config.GlassColor, false, config.CornerRadius)
    
    -- Content Area
    self.ContentArea = createGlassFrame(self.MainFrame, UDim2.new(1, -(sidebarWidth + 24), 1, -(topBarHeight + 24)), 
        UDim2.new(0, sidebarWidth + 18, 0, topBarHeight + 18), 0.1, config.GlassColor, false, config.CornerRadius)
    
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
        self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
        self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        self.MainFrame.BackgroundTransparency = 1
        
        TweenService:Create(self.MainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0), {
            Size = UDim2.new(0, self.windowWidth, 0, self.windowHeight),
            Position = UDim2.new(0.5, -self.windowWidth/2, 0.5, -self.windowHeight/2),
            BackgroundTransparency = self.config.DarkGlassTransparency
        }):Play()
        
        -- Bounce effect
        task.wait(0.8)
        TweenService:Create(self.MainFrame, TweenInfo.new(0.2), {
            Size = UDim2.new(0, self.windowWidth + 8, 0, self.windowHeight + 8)
        }):Play()
        
        task.wait(0.2)
        TweenService:Create(self.MainFrame, TweenInfo.new(0.15), {
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
                ImageColor3 = self.config.TextColor
            }):Play()
        else
            -- Minimize window
            TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, self.windowWidth, 0, 70),
                Position = UDim2.new(0.5, -self.windowWidth/2, 0.5, -35)
            }):Play()
            TweenService:Create(self.MinimizeButton, TweenInfo.new(0.15), {
                ImageColor3 = self.config.AccentColor
            }):Play()
        end
        self.isMinimized = not self.isMinimized
    end
    
    local function closeUI()
        if self.isClosing then return end
        self.isClosing = true
        
        TweenService:Create(self.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        }):Play()
        
        task.wait(0.5)
        if self.ScreenGui then
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
            ImageColor3 = self.config.AccentColor,
            Size = UDim2.new(0, 24, 0, 24)
        }):Play()
    end)
    
    self.MinimizeButton.MouseLeave:Connect(function()
        if self.isClosing then return end
        TweenService:Create(self.MinimizeButton, TweenInfo.new(0.15), {
            ImageColor3 = self.isMinimized and self.config.AccentColor or self.config.TextColor,
            Size = UDim2.new(0, 22, 0, 22)
        }):Play()
    end)
    
    self.CloseButton.MouseEnter:Connect(function()
        if self.isClosing then return end
        TweenService:Create(self.CloseButton, TweenInfo.new(0.15), {
            ImageColor3 = self.config.ErrorColor,
            Size = UDim2.new(0, 24, 0, 24)
        }):Play()
    end)
    
    self.CloseButton.MouseLeave:Connect(function()
        if self.isClosing then return end
        TweenService:Create(self.CloseButton, TweenInfo.new(0.15), {
            ImageColor3 = self.config.TextColor,
            Size = UDim2.new(0, 22, 0, 22)
        }):Play()
    end)
    
    -- Start animation
    animateIn()
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
    TabButton.BackgroundColor3 = self.config.GlassColor
    TabButton.BackgroundTransparency = 0.15
    TabButton.AutoButtonColor = false
    TabButton.Text = ""
    TabButton.BorderSizePixel = 0
    TabButton.LayoutOrder = #self.SidebarTabs:GetChildren() + 1
    
    -- Glass styling
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, self.config.CornerRadius)
    corner.Parent = TabButton
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = self.config.GlassColor
    stroke.Thickness = 1.2
    stroke.Transparency = 0.7
    stroke.Parent = TabButton
    
    -- Button text
    local buttonText = Instance.new("TextLabel")
    buttonText.Size = icon and UDim2.new(1, -36, 1, 0) or UDim2.new(1, -16, 1, 0)
    buttonText.Position = UDim2.new(0, icon and 32 or 10, 0, 0)
    buttonText.BackgroundTransparency = 1
    buttonText.Text = name
    buttonText.TextColor3 = self.config.SubTextColor
    buttonText.TextSize = buttonFontSize
    buttonText.Font = Enum.Font.GothamMedium
    buttonText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Optional icon
    if icon then
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(0, 20, 0, 20)
        iconLabel.Position = UDim2.new(0, 6, 0.5, -10)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = icon
        iconLabel.TextColor3 = self.config.SubTextColor
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
    TabScrolling.ScrollBarImageColor3 = self.config.AccentColor
    TabScrolling.ScrollBarImageTransparency = 0.5
    TabScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 12)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Parent = TabScrolling
    
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
    
    local function selectTab()
        for _, tData in ipairs(self.tabs) do
            tData.content.Visible = false
            TweenService:Create(tData.button, TweenInfo.new(0.25), {
                BackgroundTransparency = 0.15,
                BackgroundColor3 = self.config.GlassColor
            }):Play()
            TweenService:Create(tData.text, TweenInfo.new(0.25), {
                TextColor3 = self.config.SubTextColor
            }):Play()
        end
        
        -- Show this tab's content
        TabContent.Visible = true
        TweenService:Create(TabButton, TweenInfo.new(0.25), {
            BackgroundTransparency = 0.06,
            BackgroundColor3 = self.config.AccentColor
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
                TextColor3 = self.config.TextColor
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
                TextColor3 = self.config.SubTextColor
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
    TabScrolling.Parent = TabContent
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
        SectionHeader.Position = UDim2.new(0, 0, 0, 0)
        SectionHeader.BackgroundColor3 = self.config.GlassColor
        SectionHeader.BackgroundTransparency = 0.08
        SectionHeader.BorderSizePixel = 0
        
        local headerCorner = Instance.new("UICorner")
        headerCorner.CornerRadius = UDim.new(0, self.config.CornerRadius)
        headerCorner.Parent = SectionHeader
        
        local headerStroke = Instance.new("UIStroke")
        headerStroke.Color = self.config.GlassColor
        headerStroke.Thickness = 1.2
        headerStroke.Transparency = 0.7
        headerStroke.Parent = SectionHeader
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -10, 1, 0)
        titleLabel.Position = UDim2.new(0, 10, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = self.config.TextColor
        titleLabel.TextSize = 15
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        
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
                if child:IsA("GuiObject") and child.Visible then
                    totalHeight = totalHeight + child.AbsoluteSize.Y
                end
            end
            totalHeight = totalHeight + (ContentList.Padding.Offset * (#SectionContent:GetChildren() - 1))
            SectionContent.Size = UDim2.new(1, 0, 0, totalHeight)
            SectionContainer.Size = UDim2.new(1, -12, 0, 44 + totalHeight)
        end
        
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSectionHeight)
        
        -- Parent elements
        titleLabel.Parent = SectionHeader
        SectionHeader.Parent = SectionContainer
        SectionContent.Parent = SectionContainer
        SectionContainer.Parent = TabScrolling
        
        -- Section methods
        function section:AddButton(name, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 36)
            Button.BackgroundColor3 = self.config.GlassColor
            Button.BackgroundTransparency = 0.12
            Button.AutoButtonColor = false
            Button.Text = ""
            Button.BorderSizePixel = 0
            Button.LayoutOrder = #SectionContent:GetChildren() + 1
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, self.config.CornerRadius)
            buttonCorner.Parent = Button
            
            local buttonStroke = Instance.new("UIStroke")
            buttonStroke.Color = self.config.GlassColor
            buttonStroke.Thickness = 1.2
            buttonStroke.Transparency = 0.7
            buttonStroke.Parent = Button
            
            local buttonText = Instance.new("TextLabel")
            buttonText.Size = UDim2.new(1, -10, 1, 0)
            buttonText.Position = UDim2.new(0, 10, 0, 0)
            buttonText.BackgroundTransparency = 1
            buttonText.Text = name
            buttonText.TextColor3 = self.config.TextColor
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
                    BackgroundColor3 = self.config.AccentColor
                }):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                if self.isClosing then return end
                TweenService:Create(Button, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.12,
                    BackgroundColor3 = self.config.GlassColor
                }):Play()
            end)
            
            Button.Parent = SectionContent
            updateSectionHeight()
            
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
            label.Position = UDim2.new(0, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = self.config.TextColor
            label.TextSize = 13
            label.Font = Enum.Font.GothamMedium
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0, 45, 0, 20)
            valueLabel.Position = UDim2.new(1, -45, 0, 0)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(currentValue)
            valueLabel.TextColor3 = self.config.AccentColor
            valueLabel.TextSize = 13
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            
            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, 0, 0, 6)
            track.Position = UDim2.new(0, 0, 0, 30)
            track.BackgroundColor3 = self.config.GlassColor
            track.BackgroundTransparency = 0.15
            track.BorderSizePixel = 0
            
            local trackCorner = Instance.new("UICorner")
            trackCorner.CornerRadius = UDim.new(1, 0)
            trackCorner.Parent = track
            
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((currentValue - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = self.config.AccentColor
            fill.BackgroundTransparency = 0.1
            fill.BorderSizePixel = 0
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillCorner.Parent = fill
            
            local handle = Instance.new("Frame")
            handle.Size = UDim2.new(0, 16, 0, 16)
            handle.Position = UDim2.new((currentValue - min) / (max - min), -8, 0.5, -8)
            handle.BackgroundColor3 = self.config.AccentColor
            handle.BackgroundTransparency = 0.06
            handle.BorderSizePixel = 0
            
            local handleCorner = Instance.new("UICorner")
            handleCorner.CornerRadius = UDim.new(1, 0)
            handleCorner.Parent = handle
            
            local handleStroke = Instance.new("UIStroke")
            handleStroke.Color = self.config.AccentColor
            handleStroke.Thickness = 2
            handleStroke.Transparency = 0.3
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
                    if sliding then
                        sliding = false
                        TweenService:Create(handle, TweenInfo.new(0.1), {
                            Size = UDim2.new(0, 16, 0, 16)
                        }):Play()
                    end
                end
            end)
            
            local connection = RunService.RenderStepped:Connect(function()
                if sliding then
                    local mousePos = UserInputService:GetMouseLocation()
                    local trackPos = track.AbsolutePosition
                    local trackSize = track.AbsoluteSize.X
                    
                    local relativeX = (mousePos.X - trackPos.X) / trackSize
                    relativeX = math.clamp(relativeX, 0, 1)
                    
                    local value = min + (relativeX * (max - min))
                    value = math.floor(value)
                    
                    updateSlider(value)
                end
            end)
            
            Slider.Destroying:Connect(function()
                connection:Disconnect()
            end)
            
            label.Parent = Slider
            valueLabel.Parent = Slider
            fill.Parent = track
            handle.Parent = track
            track.Parent = Slider
            Slider.Parent = SectionContent
            
            updateSectionHeight()
            
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
            label.TextColor3 = self.config.TextColor
            label.TextSize = 13
            label.Font = Enum.Font.GothamMedium
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local toggleButton = Instance.new("Frame")
            toggleButton.Size = UDim2.new(0, 40, 0, 20)
            toggleButton.Position = UDim2.new(1, -40, 0.5, -10)
            toggleButton.BackgroundColor3 = toggleState and self.config.AccentColor or self.config.GlassColor
            toggleButton.BackgroundTransparency = toggleState and 0.06 or 0.15
            toggleButton.BorderSizePixel = 0
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(1, 0)
            toggleCorner.Parent = toggleButton
            
            local toggleStroke = Instance.new("UIStroke")
            toggleStroke.Color = toggleState and self.config.AccentColor or self.config.GlassColor
            toggleStroke.Thickness = 1.2
            toggleStroke.Transparency = 0.7
            toggleStroke.Parent = toggleButton
            
            local function updateToggle()
                if toggleState then
                    TweenService:Create(toggleButton, TweenInfo.new(0.15), {
                        BackgroundTransparency = 0.06,
                        BackgroundColor3 = self.config.AccentColor
                    }):Play()
                    TweenService:Create(toggleStroke, TweenInfo.new(0.15), {
                        Color = self.config.AccentColor
                    }):Play()
                else
                    TweenService:Create(toggleButton, TweenInfo.new(0.15), {
                        BackgroundTransparency = 0.15,
                        BackgroundColor3 = self.config.GlassColor
                    }):Play()
                    TweenService:Create(toggleStroke, TweenInfo.new(0.15), {
                        Color = self.config.GlassColor
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
            local divider = Instance.new("Frame")
            divider.Size = UDim2.new(1, 0, 0, 26)
            divider.BackgroundTransparency = 1
            divider.LayoutOrder = #SectionContent:GetChildren() + 1
            
            local line = Instance.new("Frame")
            line.Size = UDim2.new(1, 0, 0, 1)
            line.Position = UDim2.new(0, 0, 0.5, 0)
            line.BackgroundColor3 = self.config.AccentColor
            line.BackgroundTransparency = 0.3
            
            if text and text ~= "" then
                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(0, 90, 0, 20)
                textLabel.Position = UDim2.new(0.5, -45, 0.5, -10)
                textLabel.BackgroundTransparency = 1
                textLabel.Text = text:upper()
                textLabel.TextColor3 = self.config.AccentColor
                textLabel.TextSize = 11
                textLabel.Font = Enum.Font.GothamBold
                textLabel.Parent = divider
            end
            
            line.Parent = divider
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
            label.TextColor3 = self.config.TextColor
            label.TextSize = 13
            label.Font = Enum.Font.GothamMedium
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local inputBox = Instance.new("TextBox")
            inputBox.Size = UDim2.new(0.55, 0, 0.7, 0)
            inputBox.Position = UDim2.new(0.4, 0, 0.15, 0)
            inputBox.BackgroundColor3 = self.config.GlassColor
            inputBox.BackgroundTransparency = 0.2
            inputBox.TextColor3 = self.config.TextColor
            inputBox.Text = ""
            inputBox.TextSize = 12
            inputBox.Font = Enum.Font.GothamMedium
            inputBox.PlaceholderText = placeholder or "Enter text..."
            inputBox.PlaceholderColor3 = self.config.SubTextColor
            inputBox.ClearTextOnFocus = false
            
            local inputCorner = Instance.new("UICorner")
            inputCorner.CornerRadius = UDim.new(0, 6)
            inputCorner.Parent = inputBox
            
            inputBox.FocusLost:Connect(function(enterPressed)
                if enterPressed and callback then
                    pcall(callback, inputBox.Text)
                end
            end)
            
            label.Parent = TextBox
            inputBox.Parent = TextBox
            TextBox.Parent = SectionContent
            
            updateSectionHeight()
            
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
            label.TextColor3 = self.config.TextColor
            label.TextSize = 13
            label.Font = Enum.Font.GothamMedium
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local dropdownButton = Instance.new("TextButton")
            dropdownButton.Size = UDim2.new(0.55, 0, 0.7, 0)
            dropdownButton.Position = UDim2.new(0.4, 0, 0.15, 0)
            dropdownButton.BackgroundColor3 = self.config.GlassColor
            dropdownButton.BackgroundTransparency = 0.2
            dropdownButton.TextColor3 = self.config.TextColor
            dropdownButton.Text = selectedOption
            dropdownButton.TextSize = 12
            dropdownButton.Font = Enum.Font.GothamMedium
            dropdownButton.AutoButtonColor = false
            
            local dropdownCorner = Instance.new("UICorner")
            dropdownCorner.CornerRadius = UDim.new(0, 6)
            dropdownCorner.Parent = dropdownButton
            
            local dropdownStroke = Instance.new("UIStroke")
            dropdownStroke.Color = self.config.GlassColor
            dropdownStroke.Thickness = 1.2
            dropdownStroke.Transparency = 0.7
            dropdownStroke.Parent = dropdownButton
            
            local dropdownOpen = false
            
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Size = UDim2.new(0.55, 0, 0, math.min(120, #options * 30 + 8))
            dropdownFrame.Position = UDim2.new(0.4, 0, 1.1, 0)
            dropdownFrame.BackgroundColor3 = self.config.GlassColor
            dropdownFrame.BackgroundTransparency = 0.1
            dropdownFrame.BorderSizePixel = 0
            dropdownFrame.Visible = false
            dropdownFrame.ClipsDescendants = true
            
            local dropdownFrameCorner = Instance.new("UICorner")
            dropdownFrameCorner.CornerRadius = UDim.new(0, 6)
            dropdownFrameCorner.Parent = dropdownFrame
            
            local dropdownScrolling = Instance.new("ScrollingFrame")
            dropdownScrolling.Size = UDim2.new(1, -8, 1, -8)
            dropdownScrolling.Position = UDim2.new(0, 4, 0, 4)
            dropdownScrolling.BackgroundTransparency = 1
            dropdownScrolling.ScrollBarThickness = 2
            dropdownScrolling.ScrollBarImageColor3 = self.config.AccentColor
            dropdownScrolling.CanvasSize = UDim2.new(0, 0, 0, #options * 30)
            
            local dropdownList = Instance.new("UIListLayout")
            dropdownList.Padding = UDim.new(0, 2)
            dropdownList.SortOrder = Enum.SortOrder.LayoutOrder
            dropdownList.Parent = dropdownScrolling
            
            for i, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Size = UDim2.new(1, 0, 0, 28)
                optionButton.BackgroundColor3 = self.config.GlassColor
                optionButton.BackgroundTransparency = 0.3
                optionButton.TextColor3 = self.config.TextColor
                optionButton.Text = option
                optionButton.TextSize = 11
                optionButton.Font = Enum.Font.GothamMedium
                optionButton.AutoButtonColor = false
                optionButton.LayoutOrder = i
                
                optionButton.MouseButton1Click:Connect(function()
                    selectedOption = option
                    dropdownButton.Text = option
                    dropdownOpen = false
                    dropdownFrame.Visible = false
                    
                    if callback then
                        pcall(callback, option)
                    end
                end)
                
                optionButton.MouseEnter:Connect(function()
                    TweenService:Create(optionButton, TweenInfo.new(0.15), {
                        BackgroundTransparency = 0.1,
                        BackgroundColor3 = self.config.AccentColor
                    }):Play()
                end)
                
                optionButton.MouseLeave:Connect(function()
                    TweenService:Create(optionButton, TweenInfo.new(0.15), {
                        BackgroundTransparency = 0.3,
                        BackgroundColor3 = self.config.GlassColor
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
            local outsideClickConnection
            outsideClickConnection = UserInputService.InputBegan:Connect(function(input)
                if dropdownOpen and input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mousePos = input.Position
                    local dropdownPos = dropdownFrame.AbsolutePosition
                    local dropdownSize = dropdownFrame.AbsoluteSize
                    
                    if mousePos.X < dropdownPos.X or mousePos.X > dropdownPos.X + dropdownSize.X or
                       mousePos.Y < dropdownPos.Y or mousePos.Y > dropdownPos.Y + dropdownSize.Y then
                        dropdownOpen = false
                        dropdownFrame.Visible = false
                    end
                end
            end)
            
            Dropdown.Destroying:Connect(function()
                if outsideClickConnection then
                    outsideClickConnection:Disconnect()
                end
            end)
            
            label.Parent = Dropdown
            dropdownButton.Parent = Dropdown
            dropdownScrolling.Parent = dropdownFrame
            dropdownFrame.Parent = Dropdown
            Dropdown.Parent = SectionContent
            
            updateSectionHeight()
            
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
        
        function section:AddLabel(text)
            local Label = Instance.new("Frame")
            Label.Size = UDim2.new(1, 0, 0, 30)
            Label.BackgroundTransparency = 1
            Label.LayoutOrder = #SectionContent:GetChildren() + 1
            
            local labelText = Instance.new("TextLabel")
            labelText.Size = UDim2.new(1, 0, 1, 0)
            labelText.BackgroundTransparency = 1
            labelText.Text = text
            labelText.TextColor3 = self.config.SubTextColor
            labelText.TextSize = 12
            labelText.Font = Enum.Font.GothamMedium
            labelText.TextXAlignment = Enum.TextXAlignment.Left
            labelText.TextWrapped = true
            labelText.Parent = Label
            
            Label.Parent = SectionContent
            updateSectionHeight()
            
            local labelObj = {
                Instance = Label,
                SetText = function(newText)
                    labelText.Text = newText
                end
            }
            
            return labelObj
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
