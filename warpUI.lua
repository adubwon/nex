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
    windowTitle.Size = UDim2.new(1, -16, 0.6, 0)
    windowTitle.Position = UDim2.new(0, 12, 0, 4)
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
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -16, 0.4, 0)
    subtitle.Position = UDim2.new(0, 12, 0.6, 0)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Executor UI"
    subtitle.TextColor3 = WarpHub.AccentColor
    subtitle.TextSize = 11
    subtitle.Font = Enum.Font.GothamBold
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Minimize button (no background)
    self.MinimizeButton = Instance.new("ImageButton")
    self.MinimizeButton.Size = UDim2.new(0, 22, 0, 22)
    self.MinimizeButton.Position = UDim2.new(1, -52, 0.5, -11)
    self.MinimizeButton.BackgroundTransparency = 1
    self.MinimizeButton.Image = "rbxassetid://3926305904"
    self.MinimizeButton.ImageRectOffset = Vector2.new(564, 284)
    self.MinimizeButton.ImageRectSize = Vector2.new(36, 36)
    self.MinimizeButton.ImageColor3 = WarpHub.TextColor
    
    -- Close button (no background)
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
    
    self.ContentScrolling = Instance.new("ScrollingFrame")
    self.ContentScrolling.Size = UDim2.new(1, -16, 1, -16)
    self.ContentScrolling.Position = UDim2.new(0, 8, 0, 8)
    self.ContentScrolling.BackgroundTransparency = 1
    self.ContentScrolling.ScrollBarThickness = 4
    self.ContentScrolling.ScrollBarImageColor3 = WarpHub.AccentColor
    self.ContentScrolling.ScrollBarImageTransparency = 0.5
    self.ContentScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ContentScrolling.Parent = self.ContentArea
    
    self.SidebarTabs = Instance.new("Frame")
    self.SidebarTabs.Size = UDim2.new(1, -10, 1, -10)
    self.SidebarTabs.Position = UDim2.new(0, 5, 0, 5)
    self.SidebarTabs.BackgroundTransparency = 1
    self.SidebarTabs.Parent = self.Sidebar
    
    windowTitle.Parent = titleContainer
    subtitle.Parent = titleContainer
    titleContainer.Parent = self.TopBar
    self.MinimizeButton.Parent = self.TopBar
    self.CloseButton.Parent = self.TopBar
    self.MainFrame.Parent = self.ScreenGui
    self.ScreenGui.Parent = game:GetService("CoreGui")
    
    self.isMinimized = false
    self.isClosing = false
    self.tabs = {}
    
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

function WarpHub:updateContentSize()
    task.wait(0.05)
    local ySize = 0
    for _, child in pairs(self.ContentScrolling:GetChildren()) do
        if child:IsA("Frame") then
            ySize = ySize + child.AbsoluteSize.Y + 8
        end
    end
    self.ContentScrolling.CanvasSize = UDim2.new(0, 0, 0, ySize + 10)
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
    textLabel.BackgroundColor3 = self.ContentArea.BackgroundColor3
    
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
    
    local TabButton = createGlassFrame(nil, UDim2.new(1, -10, 0, buttonHeight), 
        UDim2.new(0, 5, 0, (#self.SidebarTabs:GetChildren() * (buttonHeight + 6)) + 5), 0.15)
    TabButton.BackgroundColor3 = WarpHub.GlassColor
    TabButton.AutoButtonColor = false
    
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
    
    local TabContent = Instance.new("Frame")
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.Visible = false
    TabContent.Parent = self.ContentScrolling
    
    TabButton.Parent = self.SidebarTabs
    TabContent.Parent = self.ContentScrolling
    
    table.insert(self.tabs, {button = TabButton, content = TabContent, text = buttonText})
    
    local function selectTab()
        for _, tabData in pairs(self.tabs) do
            tabData.content.Visible = false
            TweenService:Create(tabData.button, TweenInfo.new(0.25), {
                BackgroundTransparency = 0.15,
                BackgroundColor3 = WarpHub.GlassColor
            }):Play()
            TweenService:Create(tabData.text, TweenInfo.new(0.25), {
                TextColor3 = WarpHub.SubTextColor
            }):Play()
        end
        
        TabContent.Visible = true
        TweenService:Create(TabButton, TweenInfo.new(0.25), {
            BackgroundTransparency = 0.06,
            BackgroundColor3 = WarpHub.AccentColor
        }):Play()
        TweenService:Create(buttonText, TweenInfo.new(0.25), {
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        
        self:updateContentSize()
    end
    
    TabButton.MouseEnter:Connect(function()
        if self.isClosing then return end
        if not TabContent.Visible then
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
        if not TabContent.Visible then
            TweenService:Create(TabButton, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.15
            }):Play()
            TweenService:Create(buttonText, TweenInfo.new(0.15), {
                TextColor3 = WarpHub.SubTextColor
            }):Play()
        end
    end)
    
    TabButton.MouseButton1Click:Connect(selectTab)
    
    if #self.tabs == 1 then
        task.wait(0.5)
        selectTab()
    end
    
    function tab:AddSection(title)
        local section = {}
        
        local Section = createGlassFrame(nil, UDim2.new(1, -12, 0, 40), 
            UDim2.new(0, 6, 0, #TabContent:GetChildren() * 48 + 6), 0.08)
        Section.BackgroundColor3 = WarpHub.GlassColor
        
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
        Section.Parent = TabContent
        self:updateContentSize()
        
        function section:AddButton(name, callback)
            local Button = createGlassFrame(nil, UDim2.new(1, -12, 0, 36), 
                UDim2.new(0, 6, 0, #TabContent:GetChildren() * 44 + 6), 0.12)
            Button.BackgroundColor3 = WarpHub.GlassColor
            Button.AutoButtonColor = false
            
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
                if self.isClosing then return end
                TweenService:Create(Button, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.05,
                    BackgroundColor3 = WarpHub.AccentColor
                }):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                if self.isClosing then return end
                TweenService:Create(Button, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.12,
                    BackgroundColor3 = WarpHub.GlassColor
                }):Play()
            end)
            
            Button.Parent = TabContent
            self:updateContentSize()
            return Button
        end
        
        function section:AddSlider(name, min, max, default, callback)
            local Slider = Instance.new("Frame")
            Slider.Size = UDim2.new(1, -12, 0, 52)
            Slider.Position = UDim2.new(0, 6, 0, #TabContent:GetChildren() * 60 + 6)
            Slider.BackgroundTransparency = 1
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -50, 0, 20)
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
            
            local handle = createGlassFrame(nil, UDim2.new(0, 16, 0, 16), 
                UDim2.new((default - min) / (max - min), -8, 0.5, -8), 0.06, WarpHub.AccentColor)
            
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
                if self.isClosing then return end
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
            
            UserInputService.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = UserInputService:GetMouseLocation()
                    local trackPos = track.AbsolutePosition
                    local trackSize = track.AbsoluteSize
                    
                    local relativeX = (mousePos.X - trackPos.X) / trackSize.X
                    relativeX = math.clamp(relativeX, 0, 1)
                    
                    local value = min + (relativeX * (max - min))
                    updateSlider(value)
                end
            end)
            
            fill.Parent = track
            handle.Parent = track
            track.Parent = Slider
            Slider.Parent = TabContent
            
            self:updateContentSize()
            return Slider
        end
        
        function section:AddToggle(name, default, callback)
            local Toggle = Instance.new("Frame")
            Toggle.Size = UDim2.new(1, -12, 0, 36)
            Toggle.Position = UDim2.new(0, 6, 0, #TabContent:GetChildren() * 44 + 6)
            Toggle.BackgroundTransparency = 1
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.7, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = WarpHub.TextColor
            label.TextSize = 13
            label.Font = Enum.Font.GothamMedium
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = Toggle
            
            local toggleButton = createGlassFrame(nil, UDim2.new(0, 40, 0, 20), 
                UDim2.new(1, -40, 0.5, -10), default and 0.06 or 0.15, 
                default and WarpHub.AccentColor or WarpHub.GlassColor)
            
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
                if self.isClosing then return end
                toggleState = not toggleState
                updateToggle()
            end)
            
            toggleButton.MouseEnter:Connect(function()
                if self.isClosing then return end
                TweenService:Create(toggleButton, TweenInfo.new(0.1), {
                    Size = UDim2.new(0, 42, 0, 22)
                }):Play()
            end)
            
            toggleButton.MouseLeave:Connect(function()
                if self.isClosing then return end
                TweenService:Create(toggleButton, TweenInfo.new(0.1), {
                    Size = UDim2.new(0, 40, 0, 20)
                }):Play()
            end)
            
            label.Parent = Toggle
            toggleButton.Parent = Toggle
            Toggle.Parent = TabContent
            
            updateToggle()
            self:updateContentSize()
            return Toggle
        end
        
        function section:AddDivider(text)
            local divider = self:createSectionDivider(text)
            divider.Parent = TabContent
            self:updateContentSize()
            return divider
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
