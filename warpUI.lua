local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")

local player = Players.LocalPlayer

local isMobile = UserInputService.TouchEnabled

local WarpHub = {}
WarpHub.__index = WarpHub

WarpHub.Config = {
    GlassTransparency = 0.15,
    DarkGlassTransparency = 0.1,
    CornerRadius = isMobile and 12 or 18,
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
    DropdownHover = Color3.fromRGB(50, 50, 60)
}

local function createFrame(parent, size, position, transparency, color, cornerRadius)
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

    local stroke = Instance.new("UIStroke")
    stroke.Color = color or WarpHub.Config.GlassColor
    stroke.Thickness = 1.5
    stroke.Transparency = 0.6
    stroke.Parent = frame

    if parent then
        frame.Parent = parent
    end
    
    return frame
end

function WarpHub:CreateWindow(title)
    local self = setmetatable({}, WarpHub)
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "WarpHubUI_" .. HttpService:GenerateGUID(false)
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    self.ScreenGui.ResetOnSpawn = false
    
    self.windowWidth = isMobile and 380 or 520
    self.windowHeight = isMobile and 520 or 520
    
    self.MainFrame = createFrame(nil, UDim2.new(0, self.windowWidth, 0, self.windowHeight), 
        UDim2.new(0.5, -self.windowWidth/2, 0.5, -self.windowHeight/2), 
        WarpHub.Config.DarkGlassTransparency, WarpHub.Config.DarkGlassColor, isMobile and 16 or 20)

    local sidebarWidth = isMobile and 120 or 150
    local topBarHeight = isMobile and 45 or 50
    
    self.TopBar = createFrame(self.MainFrame, UDim2.new(1, -20, 0, topBarHeight), 
        UDim2.new(0, 10, 0, 10), 0.1, WarpHub.Config.GlassColor, isMobile and 10 or 12)
    
    local titleContainer = Instance.new("Frame")
    titleContainer.Size = UDim2.new(isMobile and 0.6 or 0, isMobile and 0 or 200, 1, 0)
    titleContainer.BackgroundTransparency = 1
    titleContainer.Parent = self.TopBar
    
    local windowTitle = Instance.new("TextLabel")
    windowTitle.Size = UDim2.new(1, -12, 1, 0)
    windowTitle.Position = UDim2.new(0, 12, 0, 0)
    windowTitle.BackgroundTransparency = 1
    windowTitle.Text = title or "Warp Hub"
    windowTitle.TextColor3 = WarpHub.Config.TextColor
    windowTitle.TextSize = isMobile and 18 or 22
    windowTitle.Font = Enum.Font.GothamBlack
    windowTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local titleGlow = Instance.new("UIGradient")
    titleGlow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, WarpHub.Config.AccentColor),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, WarpHub.Config.SecondaryColor)
    })
    titleGlow.Parent = windowTitle
    windowTitle.Parent = titleContainer
    
    self.MinimizeButton = Instance.new("ImageButton")
    self.MinimizeButton.Size = UDim2.new(0, isMobile and 20 or 24, 0, isMobile and 20 or 24)
    self.MinimizeButton.Position = UDim2.new(1, isMobile and -60 or -84, 0.5, isMobile and -10 or -12)
    self.MinimizeButton.BackgroundTransparency = 1
    self.MinimizeButton.Image = "rbxassetid://3926305904"
    self.MinimizeButton.ImageRectOffset = Vector2.new(564, 284)
    self.MinimizeButton.ImageRectSize = Vector2.new(36, 36)
    self.MinimizeButton.ImageColor3 = WarpHub.Config.TextColor
    
    self.CloseButton = Instance.new("ImageButton")
    self.CloseButton.Size = UDim2.new(0, isMobile and 20 or 24, 0, isMobile and 20 or 24)
    self.CloseButton.Position = UDim2.new(1, isMobile and -30 or -44, 0.5, isMobile and -10 or -12)
    self.CloseButton.BackgroundTransparency = 1
    self.CloseButton.Image = "rbxassetid://3926305904"
    self.CloseButton.ImageRectOffset = Vector2.new(284, 4)
    self.CloseButton.ImageRectSize = Vector2.new(24, 24)
    self.CloseButton.ImageColor3 = WarpHub.Config.TextColor
    
    self.Sidebar = createFrame(self.MainFrame, UDim2.new(0, sidebarWidth, 1, -(topBarHeight + 20)), 
        UDim2.new(0, 10, 0, topBarHeight + 16), 0.1, WarpHub.Config.GlassColor, isMobile and 10 or 12)
    
    self.ContentArea = createFrame(self.MainFrame, UDim2.new(1, -(sidebarWidth + 20), 1, -(topBarHeight + 20)), 
        UDim2.new(0, sidebarWidth + 16, 0, topBarHeight + 16), 0.1, WarpHub.Config.GlassColor, isMobile and 10 or 12)
    
    self.SidebarTabs = Instance.new("Frame")
    self.SidebarTabs.Size = UDim2.new(1, -10, 1, -10)
    self.SidebarTabs.Position = UDim2.new(0, 5, 0, 5)
    self.SidebarTabs.BackgroundTransparency = 1
    
    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, isMobile and 6 or 8)
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Parent = self.SidebarTabs
    
    self.MinimizeButton.Parent = self.TopBar
    self.CloseButton.Parent = self.TopBar
    self.SidebarTabs.Parent = self.Sidebar
    self.MainFrame.Parent = self.ScreenGui
    self.ScreenGui.Parent = CoreGui
    
    self.isMinimized = false
    self.isClosing = false
    self.tabs = {}
    self.currentTab = nil
    self.dragging = false
    self.dragStart = Vector2.new(0, 0)
    self.startPos = UDim2.new(0, 0, 0, 0)
    
    self:setupWindow()
    
    return self
end

function WarpHub:setupWindow()
    local function toggleMinimize()
        if self.isClosing then return end
        
        if self.isMinimized then
            TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, self.windowWidth, 0, self.windowHeight),
                Position = UDim2.new(0.5, -self.windowWidth/2, 0.5, -self.windowHeight/2)
            }):Play()
            TweenService:Create(self.MinimizeButton, TweenInfo.new(0.15), {
                ImageColor3 = WarpHub.Config.TextColor
            }):Play()
        else
            TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, self.windowWidth, 0, 70),
                Position = UDim2.new(0.5, -self.windowWidth/2, 0.5, -35)
            }):Play()
            TweenService:Create(self.MinimizeButton, TweenInfo.new(0.15), {
                ImageColor3 = WarpHub.Config.AccentColor
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
    
    local function handleDragInput(input, isTouch)
        if (isTouch and input.UserInputType == Enum.UserInputType.Touch) or 
           (not isTouch and input.UserInputType == Enum.UserInputType.MouseButton1) then
            self.dragging = true
            self.dragStart = input.Position
            self.startPos = self.MainFrame.Position
        end
    end
    
    if self.TopBar then
        self.TopBar.InputBegan:Connect(function(input)
            handleDragInput(input, isMobile)
        end)
    end
    
    UserInputService.InputChanged:Connect(function(input)
        if self.dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
           (isMobile and input.UserInputType == Enum.UserInputType.Touch)) then
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
        if (isMobile and input.UserInputType == Enum.UserInputType.Touch) or 
           (not isMobile and input.UserInputType == Enum.UserInputType.MouseButton1) then
            self.dragging = false
        end
    end)
    
    if self.MinimizeButton then
        self.MinimizeButton.MouseButton1Click:Connect(toggleMinimize)
        if isMobile then
            self.MinimizeButton.TouchTap:Connect(toggleMinimize)
        end
    end
    
    if self.CloseButton then
        self.CloseButton.MouseButton1Click:Connect(closeUI)
        if isMobile then
            self.CloseButton.TouchTap:Connect(closeUI)
        end
    end
    
    if self.MinimizeButton then
        self.MinimizeButton.MouseEnter:Connect(function()
            if self.isClosing then return end
            TweenService:Create(self.MinimizeButton, TweenInfo.new(0.15), {
                ImageColor3 = WarpHub.Config.AccentColor,
                Size = UDim2.new(0, isMobile and 22 or 26, 0, isMobile and 22 or 26)
            }):Play()
        end)
        
        self.MinimizeButton.MouseLeave:Connect(function()
            if self.isClosing then return end
            TweenService:Create(self.MinimizeButton, TweenInfo.new(0.15), {
                ImageColor3 = self.isMinimized and WarpHub.Config.AccentColor or WarpHub.Config.TextColor,
                Size = UDim2.new(0, isMobile and 20 or 24, 0, isMobile and 20 or 24)
            }):Play()
        end)
    end
    
    if self.CloseButton then
        self.CloseButton.MouseEnter:Connect(function()
            if self.isClosing then return end
            TweenService:Create(self.CloseButton, TweenInfo.new(0.15), {
                ImageColor3 = Color3.fromRGB(255, 85, 85),
                Size = UDim2.new(0, isMobile and 22 or 26, 0, isMobile and 22 or 26)
            }):Play()
        end)
        
        self.CloseButton.MouseLeave:Connect(function()
            if self.isClosing then return end
            TweenService:Create(self.CloseButton, TweenInfo.new(0.15), {
                ImageColor3 = WarpHub.Config.TextColor,
                Size = UDim2.new(0, isMobile and 20 or 24, 0, isMobile and 20 or 24)
            }):Play()
        end)
    end
end

function WarpHub:AddTab(name)
    local tab = {}
    setmetatable(tab, {__index = self})
    
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, -6, 0, isMobile and 36 or 42)
    TabButton.BackgroundColor3 = WarpHub.Config.ButtonColor
    TabButton.BackgroundTransparency = 0.2
    TabButton.AutoButtonColor = false
    TabButton.Text = ""
    TabButton.BorderSizePixel = 0
    TabButton.LayoutOrder = #self.SidebarTabs:GetChildren() + 1
    
    if isMobile then
        TabButton.TouchTap:Connect(function()
            TabButton.MouseButton1Click:Fire()
        end)
    end
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, isMobile and 8 or 10)
    corner.Parent = TabButton
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = WarpHub.Config.GlassColor
    stroke.Thickness = 1.5
    stroke.Transparency = 0.5
    stroke.Parent = TabButton
    
    local buttonText = Instance.new("TextLabel")
    buttonText.Size = UDim2.new(1, -12, 1, 0)
    buttonText.Position = UDim2.new(0, 8, 0, 0)
    buttonText.BackgroundTransparency = 1
    buttonText.Text = name
    buttonText.TextColor3 = WarpHub.Config.SubTextColor
    buttonText.TextSize = isMobile and 12 or 14
    buttonText.Font = Enum.Font.GothamSemibold
    buttonText.TextXAlignment = Enum.TextXAlignment.Left
    buttonText.Parent = TabButton
    
    local TabContent = Instance.new("Frame")
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.Visible = false
    
    local TabScrolling = Instance.new("ScrollingFrame")
    TabScrolling.Size = UDim2.new(1, -12, 1, -12)
    TabScrolling.Position = UDim2.new(0, 6, 0, 6)
    TabScrolling.BackgroundTransparency = 1
    TabScrolling.ScrollBarThickness = isMobile and 3 or 4
    TabScrolling.ScrollBarImageColor3 = WarpHub.Config.AccentColor
    TabScrolling.ScrollBarImageTransparency = 0.5
    TabScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, isMobile and 10 or 14)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Parent = TabScrolling
    
    local tabData = {
        button = TabButton, 
        content = TabContent, 
        scrolling = TabScrolling,
        text = buttonText,
        name = name
    }
    table.insert(self.tabs, tabData)
    
    local function selectTab()
        for _, tData in ipairs(self.tabs) do
            tData.content.Visible = false
            TweenService:Create(tData.button, TweenInfo.new(0.25), {
                BackgroundTransparency = 0.2,
                BackgroundColor3 = WarpHub.Config.ButtonColor
            }):Play()
            TweenService:Create(tData.text, TweenInfo.new(0.25), {
                TextColor3 = WarpHub.Config.SubTextColor
            }):Play()
        end
        
        TabContent.Visible = true
        TweenService:Create(TabButton, TweenInfo.new(0.25), {
            BackgroundTransparency = 0.1,
            BackgroundColor3 = WarpHub.Config.AccentColor
        }):Play()
        TweenService:Create(buttonText, TweenInfo.new(0.25), {
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        
        self.currentTab = tabData
    end
    
    if TabButton then
        TabButton.MouseEnter:Connect(function()
            if self.isClosing then return end
            if not TabContent.Visible then
                TweenService:Create(TabButton, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.15,
                    BackgroundColor3 = WarpHub.Config.ButtonHoverColor
                }):Play()
                TweenService:Create(buttonText, TweenInfo.new(0.15), {
                    TextColor3 = WarpHub.Config.TextColor
                }):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if self.isClosing then return end
            if not TabContent.Visible then
                TweenService:Create(TabButton, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.2,
                    BackgroundColor3 = WarpHub.Config.ButtonColor
                }):Play()
                TweenService:Create(buttonText, TweenInfo.new(0.15), {
                    TextColor3 = WarpHub.Config.SubTextColor
                }):Play()
            end
        end)
        
        TabButton.MouseButton1Click:Connect(selectTab)
        
        if isMobile then
            TabButton.TouchTap:Connect(selectTab)
        end
    end
    
    if #self.tabs == 1 then
        task.wait(0.5)
        selectTab()
    end
    
    TabButton.Parent = self.SidebarTabs
    TabScrolling.Parent = TabContent
    TabContent.Parent = self.ContentArea
    
    function tab:AddSection(title)
        local section = {}
        
        local SectionContainer = Instance.new("Frame")
        SectionContainer.Size = UDim2.new(1, -6, 0, 0)
        SectionContainer.Position = UDim2.new(0, 3, 0, 0)
        SectionContainer.BackgroundTransparency = 1
        SectionContainer.LayoutOrder = #TabScrolling:GetChildren() + 1
        
        local SectionHeader = createFrame(SectionContainer, UDim2.new(1, 0, 0, isMobile and 38 or 44), 
            UDim2.new(0, 0, 0, 0), 0.08, WarpHub.Config.GlassColor, isMobile and 8 or 10)
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -12, 1, 0)
        titleLabel.Position = UDim2.new(0, 10, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = WarpHub.Config.TextColor
        titleLabel.TextSize = isMobile and 14 or 16
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = SectionHeader
        
        local SectionContent = Instance.new("Frame")
        SectionContent.Size = UDim2.new(1, 0, 0, 0)
        SectionContent.Position = UDim2.new(0, 0, 0, isMobile and 42 or 48)
        SectionContent.BackgroundTransparency = 1
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.Padding = UDim.new(0, isMobile and 8 or 10)
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Parent = SectionContent
        
        local function updateSectionHeight()
            local totalHeight = 0
            for _, child in ipairs(SectionContent:GetChildren()) do
                if child:IsA("GuiObject") and child.Visible then
                    totalHeight = totalHeight + child.AbsoluteSize.Y
                end
            end
            totalHeight = totalHeight + (ContentList.Padding.Offset * (#SectionContent:GetChildren() - 1))
            SectionContent.Size = UDim2.new(1, 0, 0, totalHeight)
            SectionContainer.Size = UDim2.new(1, -6, 0, (isMobile and 42 or 48) + totalHeight)
        end
        
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSectionHeight)
        
        SectionHeader.Parent = SectionContainer
        SectionContent.Parent = SectionContainer
        SectionContainer.Parent = TabScrolling
        
        function section:AddButton(name, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, isMobile and 36 or 40)
            Button.BackgroundColor3 = WarpHub.Config.ButtonColor
            Button.BackgroundTransparency = 0.15
            Button.AutoButtonColor = false
            Button.Text = ""
            Button.BorderSizePixel = 0
            Button.LayoutOrder = #SectionContent:GetChildren() + 1
            
            if isMobile then
                Button.TouchTap:Connect(function()
                    Button.MouseButton1Click:Fire()
                end)
            end
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, isMobile and 8 or 10)
            buttonCorner.Parent = Button
            
            local buttonStroke = Instance.new("UIStroke")
            buttonStroke.Color = WarpHub.Config.GlassColor
            buttonStroke.Thickness = 1.5
            buttonStroke.Transparency = 0.5
            buttonStroke.Parent = Button
            
            local buttonText = Instance.new("TextLabel")
            buttonText.Size = UDim2.new(1, -12, 1, 0)
            buttonText.Position = UDim2.new(0, 10, 0, 0)
            buttonText.BackgroundTransparency = 1
            buttonText.Text = name
            buttonText.TextColor3 = WarpHub.Config.TextColor
            buttonText.TextSize = isMobile and 13 or 14
            buttonText.Font = Enum.Font.GothamMedium
            buttonText.TextXAlignment = Enum.TextXAlignment.Left
            buttonText.Parent = Button
            
            local buttonIcon = Instance.new("ImageLabel")
            buttonIcon.Size = UDim2.new(0, isMobile and 20 or 24, 0, isMobile and 20 or 24)
            buttonIcon.Position = UDim2.new(1, isMobile and -28 or -32, 0.5, isMobile and -10 or -12)
            buttonIcon.BackgroundTransparency = 1
            buttonIcon.Image = "rbxassetid://6031094678"
            buttonIcon.ImageColor3 = WarpHub.Config.AccentColor
            buttonIcon.Parent = Button
            
            Button.MouseButton1Click:Connect(function()
                if callback then 
                    pcall(callback)
                end
            end)
            
            Button.MouseEnter:Connect(function()
                if self.isClosing then return end
                TweenService:Create(Button, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.08,
                    BackgroundColor3 = WarpHub.Config.ButtonHoverColor
                }):Play()
                TweenService:Create(buttonStroke, TweenInfo.new(0.15), {
                    Color = WarpHub.Config.AccentColor
                }):Play()
                TweenService:Create(buttonIcon, TweenInfo.new(0.15), {
                    ImageColor3 = Color3.fromRGB(255, 255, 255)
                }):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                if self.isClosing then return end
                TweenService:Create(Button, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.15,
                    BackgroundColor3 = WarpHub.Config.ButtonColor
                }):Play()
                TweenService:Create(buttonStroke, TweenInfo.new(0.15), {
                    Color = WarpHub.Config.GlassColor
                }):Play()
                TweenService:Create(buttonIcon, TweenInfo.new(0.15), {
                    ImageColor3 = WarpHub.Config.AccentColor
                }):Play()
            end)
            
            Button.Parent = SectionContent
            updateSectionHeight()
            
            return Button
        end
        
        function section:AddToggle(name, callback)
            local toggleState = false
            
            local Toggle = Instance.new("Frame")
            Toggle.Size = UDim2.new(1, 0, 0, isMobile and 36 or 40)
            Toggle.BackgroundTransparency = 1
            Toggle.LayoutOrder = #SectionContent:GetChildren() + 1
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.7, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = WarpHub.Config.TextColor
            label.TextSize = isMobile and 13 or 14
            label.Font = Enum.Font.GothamMedium
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local toggleButton = Instance.new("TextButton")
            toggleButton.Size = UDim2.new(0, isMobile and 40 or 46, 0, isMobile and 20 or 24)
            toggleButton.Position = UDim2.new(1, isMobile and -40 or -46, 0.5, isMobile and -10 or -12)
            toggleButton.BackgroundColor3 = WarpHub.Config.ButtonColor
            toggleButton.BackgroundTransparency = 0.15
            toggleButton.AutoButtonColor = false
            toggleButton.Text = ""
            toggleButton.BorderSizePixel = 0
            
            if isMobile then
                toggleButton.TouchTap:Connect(function()
                    toggleButton.MouseButton1Click:Fire()
                end)
            end
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, isMobile and 10 or 12)
            toggleCorner.Parent = toggleButton
            
            local toggleCircle = Instance.new("Frame")
            toggleCircle.Size = UDim2.new(0, isMobile and 16 or 20, 0, isMobile and 16 or 20)
            toggleCircle.Position = UDim2.new(0, isMobile and 2 or 2, isMobile and 0.5 or 0.5, isMobile and -8 or -10)
            toggleCircle.BackgroundColor3 = WarpHub.Config.GlassColor
            toggleCircle.BackgroundTransparency = 0.1
            toggleCircle.BorderSizePixel = 0
            
            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(1, 0)
            circleCorner.Parent = toggleCircle
            
            local function updateToggle()
                if toggleState then
                    TweenService:Create(toggleCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        Position = UDim2.new(1, isMobile and -18 or -22, isMobile and 0.5 or 0.5, isMobile and -8 or -10),
                        BackgroundColor3 = WarpHub.Config.AccentColor
                    }):Play()
                    TweenService:Create(toggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = WarpHub.Config.AccentColor,
                        BackgroundTransparency = 0.3
                    }):Play()
                else
                    TweenService:Create(toggleCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        Position = UDim2.new(0, isMobile and 2 or 2, isMobile and 0.5 or 0.5, isMobile and -8 or -10),
                        BackgroundColor3 = WarpHub.Config.GlassColor
                    }):Play()
                    TweenService:Create(toggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = WarpHub.Config.ButtonColor,
                        BackgroundTransparency = 0.15
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
                TweenService:Create(toggleButton, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.1
                }):Play()
            end)
            
            toggleButton.MouseLeave:Connect(function()
                TweenService:Create(toggleButton, TweenInfo.new(0.15), {
                    BackgroundTransparency = toggleState and 0.3 or 0.15
                }):Play()
            end)
            
            toggleCircle.Parent = toggleButton
            label.Parent = Toggle
            toggleButton.Parent = Toggle
            Toggle.Parent = SectionContent
            
            updateToggle()
            updateSectionHeight()
            
            local toggleObj = {
                instance = Toggle,
                state = toggleState,
                Update = function(self, newState)
                    toggleState = newState
                    updateToggle()
                end,
                GetState = function(self)
                    return toggleState
                end
            }
            
            return toggleObj
        end
        
        function section:AddSlider(name, minValue, maxValue, defaultValue, callback)
            local sliderValue = defaultValue or minValue
            
            local Slider = Instance.new("Frame")
            Slider.Size = UDim2.new(1, 0, 0, isMobile and 46 or 50)
            Slider.BackgroundTransparency = 1
            Slider.LayoutOrder = #SectionContent:GetChildren() + 1
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, isMobile and 18 or 20)
            label.BackgroundTransparency = 1
            label.Text = name .. ": " .. tostring(sliderValue)
            label.TextColor3 = WarpHub.Config.TextColor
            label.TextSize = isMobile and 13 or 14
            label.Font = Enum.Font.GothamMedium
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local sliderContainer = Instance.new("Frame")
            sliderContainer.Size = UDim2.new(1, 0, 0, isMobile and 24 or 26)
            sliderContainer.Position = UDim2.new(0, 0, 1, isMobile and -24 or -26)
            sliderContainer.BackgroundTransparency = 1
            
            local track = Instance.new("TextButton")
            track.Size = UDim2.new(1, 0, 0, isMobile and 5 or 6)
            track.Position = UDim2.new(0, 0, isMobile and 0.5 or 0.5, isMobile and -2.5 or -3)
            track.BackgroundColor3 = WarpHub.Config.SliderTrack
            track.BackgroundTransparency = 0.2
            track.AutoButtonColor = false
            track.Text = ""
            track.BorderSizePixel = 0
            
            local trackCorner = Instance.new("UICorner")
            trackCorner.CornerRadius = UDim.new(1, 0)
            trackCorner.Parent = track
            
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(0, 0, 1, 0)
            fill.Position = UDim2.new(0, 0, 0, 0)
            fill.BackgroundColor3 = WarpHub.Config.SliderFill
            fill.BackgroundTransparency = 0
            fill.BorderSizePixel = 0
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillCorner.Parent = fill
            
            local sliderButton = Instance.new("TextButton")
            sliderButton.Size = UDim2.new(0, isMobile and 18 or 20, 0, isMobile and 18 or 20)
            sliderButton.Position = UDim2.new(0, isMobile and -9 or -10, isMobile and 0.5 or 0.5, isMobile and -9 or -10)
            sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderButton.BackgroundTransparency = 0
            sliderButton.AutoButtonColor = false
            sliderButton.Text = ""
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(1, 0)
            buttonCorner.Parent = sliderButton
            
            local buttonStroke = Instance.new("UIStroke")
            buttonStroke.Color = WarpHub.Config.AccentColor
            buttonStroke.Thickness = isMobile and 1.5 or 2
            buttonStroke.Transparency = 0
            buttonStroke.Parent = sliderButton
            
            local function updateSlider(value)
                local normalized = (value - minValue) / (maxValue - minValue)
                local fillWidth = track.AbsoluteSize.X * normalized
                
                fill.Size = UDim2.new(normalized, 0, 1, 0)
                sliderButton.Position = UDim2.new(normalized, isMobile and -9 or -10, isMobile and 0.5 or 0.5, isMobile and -9 or -10)
                label.Text = name .. ": " .. tostring(math.floor(value * 100) / 100)
                sliderValue = value
                
                if callback then
                    pcall(callback, value)
                end
            end
            
            local function onInput(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or 
                   (isMobile and input.UserInputType == Enum.UserInputType.Touch) then
                    local connection
                    connection = RunService.RenderStepped:Connect(function()
                        local mousePos
                        if isMobile then
                            local touch = UserInputService:GetTouchInputs()
                            if #touch > 0 then
                                mousePos = touch[1].Position
                            end
                        else
                            mousePos = UserInputService:GetMouseLocation()
                        end
                        
                        if mousePos then
                            local trackPos = track.AbsolutePosition
                            local trackSize = track.AbsoluteSize
                            
                            local relativeX = (mousePos.X - trackPos.X) / trackSize.X
                            relativeX = math.clamp(relativeX, 0, 1)
                            
                            local newValue = minValue + (relativeX * (maxValue - minValue))
                            updateSlider(newValue)
                        end
                    end)
                    
                    local function onInputEnded(endInput)
                        if endInput.UserInputType == Enum.UserInputType.MouseButton1 or 
                           (isMobile and endInput.UserInputType == Enum.UserInputType.Touch) then
                            if connection then
                                connection:Disconnect()
                            end
                        end
                    end
                    
                    UserInputService.InputEnded:Connect(onInputEnded)
                end
            end
            
            track.InputBegan:Connect(onInput)
            sliderButton.InputBegan:Connect(onInput)
            
            updateSlider(sliderValue)
            
            sliderButton.Parent = sliderContainer
            fill.Parent = track
            track.Parent = sliderContainer
            sliderContainer.Parent = Slider
            label.Parent = Slider
            Slider.Parent = SectionContent
            
            updateSectionHeight()
            
            local sliderObj = {
                instance = Slider,
                value = sliderValue,
                Update = function(self, newValue)
                    updateSlider(newValue)
                end,
                GetValue = function(self)
                    return sliderValue
                end
            }
            
            return sliderObj
        end
        
        function section:AddDropdown(name, options, defaultOption, callback)
            local selectedOption = defaultOption or options[1]
            local dropdownOpen = false
            
            local Dropdown = Instance.new("Frame")
            Dropdown.Size = UDim2.new(1, 0, 0, isMobile and 36 or 40)
            Dropdown.BackgroundTransparency = 1
            Dropdown.LayoutOrder = #SectionContent:GetChildren() + 1
            Dropdown.ClipsDescendants = true
            
            local dropdownButton = Instance.new("TextButton")
            dropdownButton.Size = UDim2.new(1, 0, 0, isMobile and 36 or 40)
            dropdownButton.Position = UDim2.new(0, 0, 0, 0)
            dropdownButton.BackgroundColor3 = WarpHub.Config.DropdownBackground
            dropdownButton.BackgroundTransparency = 0.15
            dropdownButton.AutoButtonColor = false
            dropdownButton.Text = ""
            dropdownButton.BorderSizePixel = 0
            
            if isMobile then
                dropdownButton.TouchTap:Connect(function()
                    dropdownButton.MouseButton1Click:Fire()
                end)
            end
            
            local dropdownCorner = Instance.new("UICorner")
            dropdownCorner.CornerRadius = UDim.new(0, isMobile and 8 or 10)
            dropdownCorner.Parent = dropdownButton
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.7, 0, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = name .. ": " .. selectedOption
            label.TextColor3 = WarpHub.Config.TextColor
            label.TextSize = isMobile and 13 or 14
            label.Font = Enum.Font.GothamMedium
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = dropdownButton
            
            local arrow = Instance.new("ImageLabel")
            arrow.Size = UDim2.new(0, isMobile and 16 or 20, 0, isMobile and 16 or 20)
            arrow.Position = UDim2.new(1, isMobile and -28 or -32, isMobile and 0.5 or 0.5, isMobile and -8 or -10)
            arrow.BackgroundTransparency = 1
            arrow.Image = "rbxassetid://6031091006"
            arrow.ImageColor3 = WarpHub.Config.AccentColor
            arrow.Parent = dropdownButton
            
            local optionsFrame = Instance.new("Frame")
            optionsFrame.Size = UDim2.new(1, -6, 0, 0)
            optionsFrame.Position = UDim2.new(0, 3, 0, isMobile and 40 or 44)
            optionsFrame.BackgroundTransparency = 1
            optionsFrame.Visible = false
            
            local optionsList = Instance.new("UIListLayout")
            optionsList.Padding = UDim.new(0, isMobile and 3 or 4)
            optionsList.SortOrder = Enum.SortOrder.LayoutOrder
            optionsList.Parent = optionsFrame
            
            local function toggleDropdown()
                dropdownOpen = not dropdownOpen
                
                if dropdownOpen then
                    local totalHeight = 0
                    for _, option in ipairs(options) do
                        totalHeight = totalHeight + (isMobile and 32 or 36)
                    end
                    totalHeight = totalHeight + (optionsList.Padding.Offset * (#options - 1))
                    
                    Dropdown.Size = UDim2.new(1, 0, 0, (isMobile and 36 or 40) + totalHeight + 6)
                    optionsFrame.Size = UDim2.new(1, -6, 0, totalHeight)
                    optionsFrame.Visible = true
                    
                    TweenService:Create(arrow, TweenInfo.new(0.2), {
                        Rotation = 180
                    }):Play()
                else
                    Dropdown.Size = UDim2.new(1, 0, 0, isMobile and 36 or 40)
                    optionsFrame.Visible = false
                    
                    TweenService:Create(arrow, TweenInfo.new(0.2), {
                        Rotation = 0
                    }):Play()
                end
                
                updateSectionHeight()
            end
            
            dropdownButton.MouseButton1Click:Connect(toggleDropdown)
            
            dropdownButton.MouseEnter:Connect(function()
                TweenService:Create(dropdownButton, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.1
                }):Play()
            end)
            
            dropdownButton.MouseLeave:Connect(function()
                TweenService:Create(dropdownButton, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.15
                }):Play()
            end)
            
            for i, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Size = UDim2.new(1, 0, 0, isMobile and 32 or 36)
                optionButton.Position = UDim2.new(0, 0, 0, 0)
                optionButton.BackgroundColor3 = WarpHub.Config.DropdownBackground
                optionButton.BackgroundTransparency = 0.2
                optionButton.AutoButtonColor = false
                optionButton.Text = ""
                optionButton.BorderSizePixel = 0
                optionButton.LayoutOrder = i
                
                if isMobile then
                    optionButton.TouchTap:Connect(function()
                        optionButton.MouseButton1Click:Fire()
                    end)
                end
                
                local optionCorner = Instance.new("UICorner")
                optionCorner.CornerRadius = UDim.new(0, isMobile and 6 or 8)
                optionCorner.Parent = optionButton
                
                local optionText = Instance.new("TextLabel")
                optionText.Size = UDim2.new(1, -10, 1, 0)
                optionText.Position = UDim2.new(0, 8, 0, 0)
                optionText.BackgroundTransparency = 1
                optionText.Text = option
                optionText.TextColor3 = option == selectedOption and WarpHub.Config.AccentColor or WarpHub.Config.TextColor
                optionText.TextSize = isMobile and 12 or 13
                optionText.Font = Enum.Font.GothamMedium
                optionText.TextXAlignment = Enum.TextXAlignment.Left
                optionText.Parent = optionButton
                
                optionButton.MouseButton1Click:Connect(function()
                    selectedOption = option
                    label.Text = name .. ": " .. selectedOption
                    
                    for _, child in ipairs(optionsFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            local text = child:FindFirstChild("TextLabel")
                            if text then
                                text.TextColor3 = child == optionButton and WarpHub.Config.AccentColor or WarpHub.Config.TextColor
                            end
                        end
                    end
                    
                    toggleDropdown()
                    
                    if callback then
                        pcall(callback, selectedOption)
                    end
                end)
                
                optionButton.MouseEnter:Connect(function()
                    TweenService:Create(optionButton, TweenInfo.new(0.15), {
                        BackgroundTransparency = 0.1,
                        BackgroundColor3 = WarpHub.Config.DropdownHover
                    }):Play()
                end)
                
                optionButton.MouseLeave:Connect(function()
                    TweenService:Create(optionButton, TweenInfo.new(0.15), {
                        BackgroundTransparency = 0.2,
                        BackgroundColor3 = WarpHub.Config.DropdownBackground
                    }):Play()
                end)
                
                optionButton.Parent = optionsFrame
            end
            
            dropdownButton.Parent = Dropdown
            optionsFrame.Parent = Dropdown
            Dropdown.Parent = SectionContent
            
            updateSectionHeight()
            
            local dropdownObj = {
                instance = Dropdown,
                selected = selectedOption,
                Update = function(self, newOption)
                    selectedOption = newOption
                    label.Text = name .. ": " .. selectedOption
                    
                    for _, child in ipairs(optionsFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            local text = child:FindFirstChild("TextLabel")
                            if text then
                                text.TextColor3 = text.Text == newOption and WarpHub.Config.AccentColor or WarpHub.Config.TextColor
                            end
                        end
                    end
                    
                    if callback then
                        pcall(callback, selectedOption)
                    end
                end,
                GetSelected = function(self)
                    return selectedOption
                end
            }
            
            return dropdownObj
        end
        
        function section:AddInput(name, placeholder, callback)
            local Input = Instance.new("Frame")
            Input.Size = UDim2.new(1, 0, 0, isMobile and 36 or 40)
            Input.BackgroundTransparency = 1
            Input.LayoutOrder = #SectionContent:GetChildren() + 1
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.3, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = WarpHub.Config.TextColor
            label.TextSize = isMobile and 13 or 14
            label.Font = Enum.Font.GothamMedium
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local inputContainer = Instance.new("Frame")
            inputContainer.Size = UDim2.new(0.7, -8, 0.8, 0)
            inputContainer.Position = UDim2.new(0.3, 0, 0.1, 0)
            inputContainer.BackgroundColor3 = WarpHub.Config.InputBackground
            inputContainer.BackgroundTransparency = 0.15
            inputContainer.BorderSizePixel = 0
            
            local inputCorner = Instance.new("UICorner")
            inputCorner.CornerRadius = UDim.new(0, isMobile and 6 or 8)
            inputCorner.Parent = inputContainer
            
            local textBox = Instance.new("TextBox")
            textBox.Size = UDim2.new(1, -56, 1, 0)
            textBox.Position = UDim2.new(0, 8, 0, 0)
            textBox.BackgroundTransparency = 1
            textBox.Text = ""
            textBox.PlaceholderText = placeholder or "Enter text..."
            textBox.TextColor3 = WarpHub.Config.TextColor
            textBox.PlaceholderColor3 = WarpHub.Config.SubTextColor
            textBox.TextSize = isMobile and 12 or 13
            textBox.Font = Enum.Font.GothamMedium
            textBox.TextXAlignment = Enum.TextXAlignment.Left
            textBox.ClearTextOnFocus = false
            
            if isMobile then
                textBox.TextScaled = true
            end
            
            local submitButton = Instance.new("TextButton")
            submitButton.Size = UDim2.new(0, isMobile and 20 or 24, 0, isMobile and 20 or 24)
            submitButton.Position = UDim2.new(1, isMobile and -24 or -28, isMobile and 0.5 or 0.5, isMobile and -10 or -12)
            submitButton.BackgroundColor3 = WarpHub.Config.AccentColor
            submitButton.BackgroundTransparency = 0.2
            submitButton.AutoButtonColor = false
            submitButton.Text = ""
            submitButton.BorderSizePixel = 0
            
            if isMobile then
                submitButton.TouchTap:Connect(function()
                    submitButton.MouseButton1Click:Fire()
                end)
            end
            
            local submitCorner = Instance.new("UICorner")
            submitCorner.CornerRadius = UDim.new(1, 0)
            submitCorner.Parent = submitButton
            
            local submitIcon = Instance.new("ImageLabel")
            submitIcon.Size = UDim2.new(0, isMobile and 12 or 16, 0, isMobile and 12 or 16)
            submitIcon.Position = UDim2.new(isMobile and 0.5 or 0.5, isMobile and -6 or -8, isMobile and 0.5 or 0.5, isMobile and -6 or -8)
            submitIcon.BackgroundTransparency = 1
            submitIcon.Image = "rbxassetid://6031094667"
            submitIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            submitIcon.Parent = submitButton
            
            local function submit()
                if textBox.Text ~= "" then
                    if callback then
                        pcall(callback, textBox.Text)
                    end
                end
            end
            
            submitButton.MouseButton1Click:Connect(submit)
            
            textBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    submit()
                end
            end)
            
            inputContainer.MouseEnter:Connect(function()
                TweenService:Create(inputContainer, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.1
                }):Play()
                TweenService:Create(submitButton, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.1
                }):Play()
            end)
            
            inputContainer.MouseLeave:Connect(function()
                TweenService:Create(inputContainer, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.15
                }):Play()
                TweenService:Create(submitButton, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.2
                }):Play()
            end)
            
            submitButton.Parent = inputContainer
            textBox.Parent = inputContainer
            label.Parent = Input
            inputContainer.Parent = Input
            Input.Parent = SectionContent
            
            updateSectionHeight()
            
            local inputObj = {
                instance = Input,
                textBox = textBox,
                GetText = function(self)
                    return textBox.Text
                end,
                SetText = function(self, newText)
                    textBox.Text = newText
                end,
                Clear = function(self)
                    textBox.Text = ""
                end
            }
            
            return inputObj
        end
        
        function section:AddLabel(text)
            local Label = Instance.new("Frame")
            Label.Size = UDim2.new(1, 0, 0, isMobile and 28 or 32)
            Label.BackgroundTransparency = 1
            Label.LayoutOrder = #SectionContent:GetChildren() + 1
            
            local labelText = Instance.new("TextLabel")
            labelText.Size = UDim2.new(1, -6, 1, 0)
            labelText.Position = UDim2.new(0, 3, 0, 0)
            labelText.BackgroundTransparency = 1
            labelText.Text = text
            labelText.TextColor3 = WarpHub.Config.SubTextColor
            labelText.TextSize = isMobile and 12 or 13
            labelText.Font = Enum.Font.GothamMedium
            labelText.TextXAlignment = Enum.TextXAlignment.Left
            labelText.TextWrapped = true
            labelText.Parent = Label
            
            Label.Parent = SectionContent
            updateSectionHeight()
            
            local labelObj = {
                instance = Label,
                textLabel = labelText,
                UpdateText = function(self, newText)
                    if self.textLabel then
                        self.textLabel.Text = newText
                    end
                end,
                Text = labelText.Text
            }
            
            return labelObj
        end
        
        return section
    end
    
    return tab
end

local function showNotification(title, text, duration)
    duration = duration or 3
    
    local notificationFrame = Instance.new("Frame")
    notificationFrame.Size = UDim2.new(0, isMobile and 280 or 320, 0, isMobile and 80 or 100)
    notificationFrame.Position = UDim2.new(1, isMobile and -290 or -340, 1, isMobile and -100 or -120)
    notificationFrame.BackgroundTransparency = 1
    notificationFrame.ZIndex = 100
    
    local glassFrame = createFrame(notificationFrame, UDim2.new(1, 0, 1, 0), 
        UDim2.new(0, 0, 0, 0), 0.1, WarpHub.Config.GlassColor, isMobile and 10 or 12)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -16, 0, isMobile and 24 or 30)
    titleLabel.Position = UDim2.new(0, 8, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = WarpHub.Config.AccentColor
    titleLabel.TextSize = isMobile and 16 or 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local titleGlow = Instance.new("UIGradient")
    titleGlow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, WarpHub.Config.AccentColor),
        ColorSequenceKeypoint.new(1, WarpHub.Config.SecondaryColor)
    })
    titleGlow.Parent = titleLabel
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -16, 0, isMobile and 32 or 40)
    textLabel.Position = UDim2.new(0, 8, 0, isMobile and 36 or 45)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = WarpHub.Config.TextColor
    textLabel.TextSize = isMobile and 12 or 14
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextWrapped = true
    
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, isMobile and 20 or 24, 0, isMobile and 20 or 24)
    icon.Position = UDim2.new(1, isMobile and -28 or -34, 0, isMobile and 10 or 13)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://6031094678"
    icon.ImageColor3 = WarpHub.Config.AccentColor
    icon.Parent = glassFrame
    
    titleLabel.Parent = glassFrame
    textLabel.Parent = glassFrame
    notificationFrame.Parent = CoreGui
    
    notificationFrame.BackgroundTransparency = 1
    glassFrame.BackgroundTransparency = 1
    titleLabel.TextTransparency = 1
    textLabel.TextTransparency = 1
    icon.ImageTransparency = 1
    
    TweenService:Create(notificationFrame, TweenInfo.new(0.3), {
        BackgroundTransparency = 0
    }):Play()
    
    TweenService:Create(glassFrame, TweenInfo.new(0.3), {
        BackgroundTransparency = 0.1
    }):Play()
    
    TweenService:Create(titleLabel, TweenInfo.new(0.3), {
        TextTransparency = 0
    }):Play()
    
    TweenService:Create(textLabel, TweenInfo.new(0.3), {
        TextTransparency = 0
    }):Play()
    
    TweenService:Create(icon, TweenInfo.new(0.3), {
        ImageTransparency = 0
    }):Play()
    
    task.wait(duration)
    
    TweenService:Create(notificationFrame, TweenInfo.new(0.5), {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, isMobile and -290 or -340, 1, isMobile and 10 or 20)
    }):Play()
    
    TweenService:Create(glassFrame, TweenInfo.new(0.5), {
        BackgroundTransparency = 1
    }):Play()
    
    TweenService:Create(titleLabel, TweenInfo.new(0.5), {
        TextTransparency = 1
    }):Play()
    
    TweenService:Create(textLabel, TweenInfo.new(0.5), {
        TextTransparency = 1
    }):Play()
    
    TweenService:Create(icon, TweenInfo.new(0.5), {
        ImageTransparency = 1
    }):Play()
    
    task.wait(0.5)
    notificationFrame:Destroy()
end

local Window = WarpHub:CreateWindow("Warp Hub UI")

local ButtonsTab = Window:AddTab("Buttons")
local TogglesTab = Window:AddTab("Toggles")
local SlidersTab = Window:AddTab("Sliders")
local DropdownsTab = Window:AddTab("Dropdowns")
local InputsTab = Window:AddTab("Inputs")

local buttonsSection = ButtonsTab:AddSection("Example Button")
local togglesSection = TogglesTab:AddSection("Example Toggle")
local slidersSection = SlidersTab:AddSection("Example Slider")
local dropdownsSection = DropdownsTab:AddSection("Example Dropdown")
local inputsSection = InputsTab:AddSection("Example Input")

buttonsSection:AddButton("Test Button", function()
    showNotification("Button Clicked", "You clicked the test button!", 2)
end)

local toggle1 = togglesSection:AddToggle("Enable Feature", function(state)
    showNotification("Toggle", "Feature: " .. tostring(state), 2)
end)

local slider1 = slidersSection:AddSlider("Volume", 0, 100, 50, function(value)
    showNotification("Volume", "Volume set to: " .. tostring(value), 1)
end)

local playerNames = {}
for _, player in ipairs(Players:GetPlayers()) do
    table.insert(playerNames, player.Name)
end

local dropdown1 = dropdownsSection:AddDropdown("Select Player", playerNames, playerNames[1], function(selected)
    showNotification("Player Selected", "Selected: " .. selected, 2)
end)

local input1 = inputsSection:AddInput("Username", "Enter username", function(text)
    showNotification("Username", "Set to: " .. text, 2)
end)

local function onPlayerAdded(player)
    table.insert(playerNames, player.Name)
    dropdown1.Update(playerNames)
end

local function onPlayerRemoving(player)
    for i, name in ipairs(playerNames) do
        if name == player.Name then
            table.remove(playerNames, i)
            break
        end
    end
    dropdown1.Update(playerNames)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)
