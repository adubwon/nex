-- WarpHub UI Library
-- Load this library with: loadstring(game:HttpGet("YOUR_RAW_URL"))()

local WarpHub = {}
WarpHub.__index = WarpHub

WarpHub.Version = "1.0"
WarpHub.AccentColor = Color3.fromRGB(168, 128, 255)
WarpHub.SecondaryColor = Color3.fromRGB(128, 96, 255)
WarpHub.GlassColor = Color3.fromRGB(20, 20, 30)
WarpHub.GlassTransparency = 0.12
WarpHub.DarkGlassColor = Color3.fromRGB(10, 10, 18)
WarpHub.DarkGlassTransparency = 0.08
WarpHub.TextColor = Color3.fromRGB(255, 255, 255)
WarpHub.SubTextColor = Color3.fromRGB(220, 220, 240)

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end

local function createGlassFrame(parent, size, position, transparency, color, noStroke)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = color or WarpHub.GlassColor
    frame.BackgroundTransparency = transparency or WarpHub.GlassTransparency
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
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

local function showSplashScreen()
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
    
    local logoBg = createGlassFrame(logoContainer, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), 0.2, WarpHub.AccentColor)
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
    logo.TextStrokeColor3 = WarpHub.AccentColor
    
    local logoGradient = Instance.new("UIGradient")
    logoGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, WarpHub.AccentColor),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, WarpHub.SecondaryColor)
    })
    logoGradient.Parent = logo
    
    logo.Parent = logoContainer
    
    splashGui.Parent = game:GetService("CoreGui")
    
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

function WarpHub:CreateWindow(title)
    local self = setmetatable({}, WarpHub)
    
    showSplashScreen()
    task.wait(3.5)
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "WarpHubUI"
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    self.ScreenGui.ResetOnSpawn = false
    
    local screenSize = workspace.CurrentCamera.ViewportSize
    local isMobileDevice = isMobile()
    
    self.windowWidth = isMobileDevice and math.min(580, screenSize.X * 0.9) or 620
    self.windowHeight = isMobileDevice and math.min(480, screenSize.Y * 0.8) or 500
    
    self.MainFrame = createGlassFrame(nil, UDim2.new(0, self.windowWidth, 0, self.windowHeight), 
        UDim2.new(0.5, -self.windowWidth/2, 0.5, -self.windowHeight/2), WarpHub.DarkGlassTransparency)
    self.MainFrame.BackgroundColor3 = WarpHub.DarkGlassColor
    self.MainFrame.Visible = false
    
    local sidebarWidth = 140
    local topBarHeight = 46
    
    self.TopBar = createGlassFrame(self.MainFrame, UDim2.new(1, -24, 0, topBarHeight), UDim2.new(0, 12, 0, 12), 0.1)
    self.TopBar.BackgroundColor3 = WarpHub.GlassColor
    
    local titleContainer = Instance.new("Frame")
    titleContainer.Size = UDim2.new(0, 200, 1, 0)
    titleContainer.BackgroundTransparency = 1
    
    local windowTitle = Instance.new("TextLabel")
    windowTitle.Size = UDim2.new(1, -16, 1, 0)
    windowTitle.Position = UDim2.new(0, 12, 0, 0)
    windowTitle.BackgroundTransparency = 1
    windowTitle.Text = title or "WARP HUB"
    windowTitle.TextColor3 = WarpHub.TextColor
    windowTitle.TextSize = isMobileDevice and 18 or 20
    windowTitle.Font = Enum.Font.GothamBlack
    windowTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local titleGlow = Instance.new("UIGradient")
    titleGlow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, WarpHub.AccentColor),
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
    self.MinimizeButton.ImageColor3 = WarpHub.TextColor
    
    -- Close button
    self.CloseButton = Instance.new("ImageButton")
    self.CloseButton.Size = UDim2.new(0, 22, 0, 22)
    self.CloseButton.Position = UDim2.new(1, -24, 0.5, -11)
    self.CloseButton.BackgroundTransparency = 1
    self.CloseButton.Image = "rbxassetid://3926305904"
    self.CloseButton.ImageRectOffset = Vector2.new(284, 4)
    self.CloseButton.ImageRectSize = Vector2.new(24, 24)
    self.CloseButton.ImageColor3 = WarpHub.TextColor
    
    self.Sidebar = createGlassFrame(self.MainFrame, UDim2.new(0, sidebarWidth, 1, -(topBarHeight + 24)), 
        UDim2.new(0, 12, 0, topBarHeight + 18), 0.1)
    
    self.ContentArea = createGlassFrame(self.MainFrame, UDim2.new(1, -(sidebarWidth + 24), 1, -(topBarHeight + 24)), 
        UDim2.new(0, sidebarWidth + 18, 0, topBarHeight + 18), 0.1)
    
    self.SidebarTabs = Instance.new("Frame")
    self.SidebarTabs.Size = UDim2.new(1, -10, 1, -10)
    self.SidebarTabs.Position = UDim2.new(0, 5, 0, 5)
    self.SidebarTabs.BackgroundTransparency = 1
    
    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, 6)
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Parent = self.SidebarTabs
    
    windowTitle.Parent = titleContainer
    titleContainer.Parent = self.TopBar
    self.MinimizeButton.Parent = self.TopBar
    self.CloseButton.Parent = self.TopBar
    self.SidebarTabs.Parent = self.Sidebar
    self.MainFrame.Parent = self.ScreenGui
    self.ScreenGui.Parent = game:GetService("CoreGui")
    
    self.isMinimized = false
    self.isClosing = false
    self.tabs = {}
    self.currentTab = nil
    
    self:setupWindow()
    
    return self
end

function WarpHub:setupWindow()
    local function animateIn()
        self.MainFrame.Visible = true
        
        self.MainFrame.Size = UDim2.new(0, 10, 0, 10)
        self.MainFrame.Position = UDim2.new(0.5, -5, 0.5, -5)
        self.MainFrame.BackgroundTransparency = 1
        
        local tween = TweenService:Create(self.MainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0), {
            Size = UDim2.new(0, self.windowWidth, 0, self.windowHeight),
            Position = UDim2.new(0.5, -self.windowWidth/2, 0.5, -self.windowHeight/2),
            BackgroundTransparency = WarpHub.DarkGlassTransparency
        })
        tween:Play()
        
        tween.Completed:Wait()
        
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
            TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, self.windowWidth, 0, self.windowHeight),
                Position = UDim2.new(0.5, -self.windowWidth/2, 0.5, -self.windowHeight/2)
            }):Play()
            TweenService:Create(self.MinimizeButton, TweenInfo.new(0.15), {
                ImageColor3 = WarpHub.TextColor
            }):Play()
        else
            TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, self.windowWidth, 0, 70),
                Position = UDim2.new(0.5, -self.windowWidth/2, 0.5, -35)
            }):Play()
            TweenService:Create(self.MinimizeButton, TweenInfo.new(0.15), {
                ImageColor3 = WarpHub.AccentColor
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
    
    animateIn()
    
    local dragging = false
    local dragStart = Vector2.new(0, 0)
    local startPos = UDim2.new(0, 0, 0, 0)
    
    self.TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    self.MinimizeButton.MouseButton1Click:Connect(toggleMinimize)
    self.CloseButton.MouseButton1Click:Connect(closeUI)
    
    -- Hover effects
    self.MinimizeButton.MouseEnter:Connect(function()
        if self.isClosing then return end
        TweenService:Create(self.MinimizeButton, TweenInfo.new(0.15), {
            ImageColor3 = WarpHub.AccentColor,
            Size = UDim2.new(0, 24, 0, 24)
        }):Play()
    end)
    
    self.MinimizeButton.MouseLeave:Connect(function()
        if self.isClosing then return end
        TweenService:Create(self.MinimizeButton, TweenInfo.new(0.15), {
            ImageColor3 = self.isMinimized and WarpHub.AccentColor or WarpHub.TextColor,
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
            ImageColor3 = WarpHub.TextColor,
            Size = UDim2.new(0, 22, 0, 22)
        }):Play()
    end)
end

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
    line.BackgroundColor3 = WarpHub.AccentColor
    line.BackgroundTransparency = 0.3
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(0, 90, 0, 20)
    textLabel.Position = UDim2.new(0.5, -45, 0.5, -10)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text:upper()
    textLabel.TextColor3 = WarpHub.AccentColor
    textLabel.TextSize = 11
    textLabel.Font = Enum.Font.GothamBold
    
    lineContainer.Parent = divider
    line.Parent = lineContainer
    textLabel.Parent = lineContainer
    
    return divider
end

function WarpHub:AddTab(name)
    local tab = {}
    setmetatable(tab, {__index = self})
    
    local buttonHeight = 38
    local buttonFontSize = 13
    
    -- Store reference to self for use in closures
    local windowInstance = self
    
    -- Create TabButton as TextButton
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, -10, 0, buttonHeight)
    TabButton.BackgroundColor3 = WarpHub.GlassColor
    TabButton.BackgroundTransparency = 0.15
    TabButton.AutoButtonColor = false
    TabButton.Text = ""
    TabButton.BorderSizePixel = 0
    TabButton.LayoutOrder = #self.SidebarTabs:GetChildren() + 1
    
    -- Add glass effect styling
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = TabButton
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.9
    stroke.Thickness = 1.2
    stroke.Parent = TabButton
    
    local buttonText = Instance.new("TextLabel")
    buttonText.Size = UDim2.new(1, -16, 1, 0)
    buttonText.Position = UDim2.new(0, 10, 0, 0)
    buttonText.BackgroundTransparency = 1
    buttonText.Text = name
    buttonText.TextColor3 = WarpHub.SubTextColor
    buttonText.TextSize = buttonFontSize
    buttonText.Font = Enum.Font.GothamMedium
    buttonText.TextXAlignment = Enum.TextXAlignment.Left
    buttonText.Parent = TabButton
    
    -- Create TabContent as a Frame
    local TabContent = Instance.new("Frame")
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.Visible = false
    
    -- Create ScrollingFrame inside TabContent
    local TabScrolling = Instance.new("ScrollingFrame")
    TabScrolling.Size = UDim2.new(1, -16, 1, -16)
    TabScrolling.Position = UDim2.new(0, 8, 0, 8)
    TabScrolling.BackgroundTransparency = 1
    TabScrolling.ScrollBarThickness = 4
    TabScrolling.ScrollBarImageColor3 = WarpHub.AccentColor
    TabScrolling.ScrollBarImageTransparency = 0.5
    TabScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 8)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Parent = TabScrolling
    
    TabScrolling.Parent = TabContent
    
    -- FIX: Add TabContent to ContentArea instead of ContentScrolling
    TabButton.Parent = self.SidebarTabs
    TabContent.Parent = self.ContentArea  -- This is the fix
    
    -- Store tab data properly
    local tabData = {
        button = TabButton, 
        content = TabContent, 
        scrolling = TabScrolling,
        text = buttonText,
        name = name
    }
    table.insert(self.tabs, tabData)
    
    -- Function to select this tab
    local function selectTab()
        for _, tData in pairs(self.tabs) do
            tData.content.Visible = false
            TweenService:Create(tData.button, TweenInfo.new(0.25), {
                BackgroundTransparency = 0.15,
                BackgroundColor3 = WarpHub.GlassColor
            }):Play()
            TweenService:Create(tData.text, TweenInfo.new(0.25), {
                TextColor3 = WarpHub.SubTextColor
            }):Play()
        end
        
        -- Show this tab's content
        TabContent.Visible = true
        TweenService:Create(TabButton, TweenInfo.new(0.25), {
            BackgroundTransparency = 0.06,
            BackgroundColor3 = WarpHub.AccentColor
        }):Play()
        TweenService:Create(buttonText, TweenInfo.new(0.25), {
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        
        self.currentTab = tabData
    end
    
    -- Connect button events
    TabButton.MouseEnter:Connect(function()
        if self.isClosing then return end
        if TabContent.Visible == false then
            TweenService:Create(TabButton, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.1
            }):Play()
            TweenService:Create(buttonText, TweenInfo.new(0.15), {
                TextColor3 = WarpHub.TextColor
            }):Play()
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if self.isClosing then return end
        if TabContent.Visible == false then
            TweenService:Create(TabButton, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.15
            }):Play()
            TweenService:Create(buttonText, TweenInfo.new(0.15), {
                TextColor3 = WarpHub.SubTextColor
            }):Play()
        end
    end)
    
    TabButton.MouseButton1Click:Connect(selectTab)
    
    -- Select first tab automatically
    if #self.tabs == 1 then
        task.wait(0.5)
        selectTab()
    end
    
    -- Define tab methods
    function tab:AddSection(title)
        local section = {}
        
        local Section = createGlassFrame(nil, UDim2.new(1, 0, 0, 40), 
            UDim2.new(0, 0, 0, 0), 0.08)
        Section.BackgroundColor3 = WarpHub.GlassColor
        Section.LayoutOrder = #TabScrolling:GetChildren() + 1
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -16, 1, 0)
        titleLabel.Position = UDim2.new(0, 10, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = WarpHub.TextColor
        titleLabel.TextSize = 15
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        titleLabel.Parent = Section
        Section.Parent = TabScrolling
        
        -- Create a container for section elements
        local SectionContainer = Instance.new("Frame")
        SectionContainer.Size = UDim2.new(1, 0, 0, 0)
        SectionContainer.BackgroundTransparency = 1
        SectionContainer.LayoutOrder = #TabScrolling:GetChildren() + 1
        
        local SectionList = Instance.new("UIListLayout")
        SectionList.Padding = UDim.new(0, 6)
        SectionList.SortOrder = Enum.SortOrder.LayoutOrder
        SectionList.Parent = SectionContainer
        
        SectionContainer.Parent = TabScrolling
        
        function section:AddButton(name, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 36)
            Button.BackgroundColor3 = WarpHub.GlassColor
            Button.BackgroundTransparency = 0.12
            Button.AutoButtonColor = false
            Button.Text = ""
            Button.BorderSizePixel = 0
            Button.LayoutOrder = #SectionContainer:GetChildren() + 1
            
            -- Add glass styling
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
            buttonText.TextColor3 = WarpHub.TextColor
            buttonText.TextSize = 13
            buttonText.Font = Enum.Font.GothamMedium
            buttonText.TextXAlignment = Enum.TextXAlignment.Left
            buttonText.Parent = Button
            
            Button.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
            
            Button.MouseEnter:Connect(function()
                if windowInstance.isClosing then return end
                TweenService:Create(Button, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.05,
                    BackgroundColor3 = WarpHub.AccentColor
                }):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                if windowInstance.isClosing then return end
                TweenService:Create(Button, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.12,
                    BackgroundColor3 = WarpHub.GlassColor
                }):Play()
            end)
            
            Button.Parent = SectionContainer
            return Button
        end
        
        function section:AddSlider(name, min, max, default, callback)
            local Slider = Instance.new("Frame")
            Slider.Size = UDim2.new(1, 0, 0, 52)
            Slider.BackgroundTransparency = 1
            Slider.LayoutOrder = #SectionContainer:GetChildren() + 1
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -50, 0, 20)
            label.Position = UDim2.new(0, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = WarpHub.TextColor
            label.TextSize = 13
            label.Font = Enum.Font.GothamMedium
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = Slider
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0, 45, 0, 20)
            valueLabel.Position = UDim2.new(1, -45, 0, 0)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(default)
            valueLabel.TextColor3 = WarpHub.AccentColor
            valueLabel.TextSize = 13
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.Parent = Slider
            
            local track = createGlassFrame(Slider, UDim2.new(1, 0, 0, 6), 
                UDim2.new(0, 0, 0, 30), 0.15)
            track.BackgroundColor3 = WarpHub.GlassColor
            
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = WarpHub.AccentColor
            fill.BackgroundTransparency = 0.1
            fill.BorderSizePixel = 0
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(0, 3)
            fillCorner.Parent = fill
            
            local handle = Instance.new("Frame")
            handle.Size = UDim2.new(0, 16, 0, 16)
            handle.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
            handle.BackgroundColor3 = WarpHub.AccentColor
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
            local currentValue = default
            
            local function updateSlider(value)
                local percent = (value - min) / (max - min)
                percent = math.clamp(percent, 0, 1)
                
                fill.Size = UDim2.new(percent, 0, 1, 0)
                valueLabel.Text = tostring(math.floor(value))
                currentValue = math.floor(value)
                
                TweenService:Create(handle, TweenInfo.new(0.1), {
                    Position = UDim2.new(percent, -8, 0.5, -8)
                }):Play()
                
                if callback then callback(currentValue) end
            end
            
            handle.MouseButton1Down:Connect(function()
                if windowInstance.isClosing then return end
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
            
            local connection
            connection = RunService.RenderStepped:Connect(function()
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
                if connection then
                    connection:Disconnect()
                end
            end)
            
            fill.Parent = track
            handle.Parent = track
            track.Parent = Slider
            Slider.Parent = SectionContainer
            
            return Slider
        end
        
        function section:AddToggle(name, default, callback)
            local Toggle = Instance.new("Frame")
            Toggle.Size = UDim2.new(1, 0, 0, 36)
            Toggle.BackgroundTransparency = 1
            Toggle.LayoutOrder = #SectionContainer:GetChildren() + 1
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.7, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = WarpHub.TextColor
            label.TextSize = 13
            label.Font = Enum.Font.GothamMedium
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = Toggle
            
            local toggleButton = Instance.new("Frame")
            toggleButton.Size = UDim2.new(0, 40, 0, 20)
            toggleButton.Position = UDim2.new(1, -40, 0.5, -10)
            toggleButton.BackgroundColor3 = default and WarpHub.AccentColor or WarpHub.GlassColor
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
            
            local toggleState = default
            
            local function updateToggle()
                if toggleState then
                    TweenService:Create(toggleButton, TweenInfo.new(0.15), {
                        BackgroundTransparency = 0.06,
                        BackgroundColor3 = WarpHub.AccentColor
                    }):Play()
                else
                    TweenService:Create(toggleButton, TweenInfo.new(0.15), {
                        BackgroundTransparency = 0.15,
                        BackgroundColor3 = WarpHub.GlassColor
                    }):Play()
                end
                
                if callback then callback(toggleState) end
            end
            
            toggleButton.MouseButton1Click:Connect(function()
                if windowInstance.isClosing then return end
                toggleState = not toggleState
                updateToggle()
            end)
            
            toggleButton.MouseEnter:Connect(function()
                if windowInstance.isClosing then return end
                TweenService:Create(toggleButton, TweenInfo.new(0.1), {
                    Size = UDim2.new(0, 42, 0, 22)
                }):Play()
            end)
            
            toggleButton.MouseLeave:Connect(function()
                if windowInstance.isClosing then return end
                TweenService:Create(toggleButton, TweenInfo.new(0.1), {
                    Size = UDim2.new(0, 40, 0, 20)
                }):Play()
            end)
            
            label.Parent = Toggle
            toggleButton.Parent = Toggle
            Toggle.Parent = SectionContainer
            
            updateToggle()
            return Toggle
        end
        
        function section:AddDivider(text)
            local divider = windowInstance:createSectionDivider(text)
            divider.LayoutOrder = #SectionContainer:GetChildren() + 1
            divider.Parent = SectionContainer
            return divider
        end
        
        function section:AddTextBox(name, placeholder, callback)
            local TextBox = Instance.new("Frame")
            TextBox.Size = UDim2.new(1, 0, 0, 36)
            TextBox.BackgroundTransparency = 1
            TextBox.LayoutOrder = #SectionContainer:GetChildren() + 1
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.4, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = WarpHub.TextColor
            label.TextSize = 13
            label.Font = Enum.Font.GothamMedium
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = TextBox
            
            local inputBox = Instance.new("TextBox")
            inputBox.Size = UDim2.new(0.55, 0, 0.7, 0)
            inputBox.Position = UDim2.new(0.4, 0, 0.15, 0)
            inputBox.BackgroundColor3 = WarpHub.GlassColor
            inputBox.BackgroundTransparency = 0.2
            inputBox.TextColor3 = WarpHub.TextColor
            inputBox.Text = ""
            inputBox.TextSize = 12
            inputBox.Font = Enum.Font.GothamMedium
            inputBox.PlaceholderText = placeholder or "Enter text..."
            inputBox.PlaceholderColor3 = WarpHub.SubTextColor
            
            local inputCorner = Instance.new("UICorner")
            inputCorner.CornerRadius = UDim.new(0, 6)
            inputCorner.Parent = inputBox
            
            inputBox.FocusLost:Connect(function(enterPressed)
                if enterPressed and callback then
                    callback(inputBox.Text)
                end
            end)
            
            inputBox.Parent = TextBox
            TextBox.Parent = SectionContainer
            return TextBox
        end
        
        function section:AddDropdown(name, options, default, callback)
            local Dropdown = Instance.new("Frame")
            Dropdown.Size = UDim2.new(1, 0, 0, 36)
            Dropdown.BackgroundTransparency = 1
            Dropdown.LayoutOrder = #SectionContainer:GetChildren() + 1
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.4, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = WarpHub.TextColor
            label.TextSize = 13
            label.Font = Enum.Font.GothamMedium
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = Dropdown
            
            local dropdownButton = Instance.new("TextButton")
            dropdownButton.Size = UDim2.new(0.55, 0, 0.7, 0)
            dropdownButton.Position = UDim2.new(0.4, 0, 0.15, 0)
            dropdownButton.BackgroundColor3 = WarpHub.GlassColor
            dropdownButton.BackgroundTransparency = 0.2
            dropdownButton.TextColor3 = WarpHub.TextColor
            dropdownButton.Text = default or "Select..."
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
            local selectedOption = default
            
            local dropdownFrame = createGlassFrame(nil, UDim2.new(0.55, 0, 0, 120), 
                UDim2.new(0.4, 0, 1.1, 0), 0.1)
            dropdownFrame.BackgroundColor3 = WarpHub.GlassColor
            dropdownFrame.Visible = false
            dropdownFrame.ZIndex = 10
            
            local dropdownScrolling = Instance.new("ScrollingFrame")
            dropdownScrolling.Size = UDim2.new(1, -8, 1, -8)
            dropdownScrolling.Position = UDim2.new(0, 4, 0, 4)
            dropdownScrolling.BackgroundTransparency = 1
            dropdownScrolling.ScrollBarThickness = 2
            dropdownScrolling.ScrollBarImageColor3 = WarpHub.AccentColor
            dropdownScrolling.CanvasSize = UDim2.new(0, 0, 0, #options * 30)
            
            local dropdownList = Instance.new("UIListLayout")
            dropdownList.Padding = UDim.new(0, 2)
            dropdownList.SortOrder = Enum.SortOrder.LayoutOrder
            dropdownList.Parent = dropdownScrolling
            
            for i, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Size = UDim2.new(1, 0, 0, 28)
                optionButton.BackgroundColor3 = WarpHub.GlassColor
                optionButton.BackgroundTransparency = 0.3
                optionButton.TextColor3 = WarpHub.TextColor
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
                        callback(option)
                    end
                end)
                
                optionButton.MouseEnter:Connect(function()
                    TweenService:Create(optionButton, TweenInfo.new(0.15), {
                        BackgroundTransparency = 0.1,
                        BackgroundColor3 = WarpHub.AccentColor
                    }):Play()
                end)
                
                optionButton.MouseLeave:Connect(function()
                    TweenService:Create(optionButton, TweenInfo.new(0.15), {
                        BackgroundTransparency = 0.3,
                        BackgroundColor3 = WarpHub.GlassColor
                    }):Play()
                end)
                
                optionButton.Parent = dropdownScrolling
            end
            
            dropdownScrolling.Parent = dropdownFrame
            dropdownFrame.Parent = Dropdown
            
            local function toggleDropdown()
                dropdownOpen = not dropdownOpen
                dropdownFrame.Visible = dropdownOpen
            end
            
            dropdownButton.MouseButton1Click:Connect(toggleDropdown)
            
            -- Close dropdown when clicking outside
            local function closeDropdown(input)
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
            end
            
            UserInputService.InputBegan:Connect(closeDropdown)
            
            dropdownButton.Parent = Dropdown
            Dropdown.Parent = SectionContainer
            
            return Dropdown
        end
        
        return section
    end
    
    return tab
end

function WarpHub:Destroy()
    if self.ScreenGui and self.ScreenGui.Parent then
        self.ScreenGui:Destroy()
    end
end

-- Return the library for loadstring
return WarpHub
