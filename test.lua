-- WarpHub UI Library v2.0 - Clean & Bug-Free
-- Fixed version with proper error handling

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")

-- Variables
local player = Players.LocalPlayer
local isMobile = UserInputService.TouchEnabled

-- Main Library Table
local WarpHub = {}
WarpHub.__index = WarpHub

-- Active notifications tracker
WarpHub.ActiveNotifications = {}

-- Configuration
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
    DropdownHover = Color3.fromRGB(50, 50, 60),
    DropdownOpenBackground = Color3.fromRGB(30, 30, 40),
    DropdownText = Color3.fromRGB(255, 255, 255),
    DropdownSelectedText = Color3.fromRGB(168, 128, 255),
    NotificationAccent = Color3.fromRGB(168, 128, 255)
}

-- Helper function to safely create frames
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

-- Notification System - Fixed and clean
function WarpHub:Notify(title, message, duration, notificationType)
    if not title or not message then return nil end
    
    duration = duration or 3
    notificationType = notificationType or "info"
    
    -- Create notification GUI
    local notificationGUI = Instance.new("ScreenGui")
    notificationGUI.Name = "WarpHubNotification_" .. HttpService:GenerateGUID(false):sub(1, 8)
    notificationGUI.ZIndexBehavior = Enum.ZIndexBehavior.Global
    notificationGUI.ResetOnSpawn = false
    
    -- Calculate sizes
    local padding = isMobile and 12 or 16
    local titleHeight = isMobile and 28 or 32
    local messageHeight = isMobile and 40 or 44
    local totalHeight = titleHeight + messageHeight + padding
    
    -- Calculate width based on content
    local titleTextSize = TextService:GetTextSize(title, isMobile and 16 or 18, Enum.Font.GothamBold, Vector2.new(400, 50))
    local messageTextSize = TextService:GetTextSize(message, isMobile and 13 or 14, Enum.Font.GothamMedium, Vector2.new(400, 100))
    local maxWidth = math.max(titleTextSize.X, messageTextSize.X) + 80
    local notificationWidth = math.clamp(maxWidth, isMobile and 280 or 320, isMobile and 360 or 420)
    
    -- Position at top middle
    local screenWidth = workspace.CurrentCamera.ViewportSize.X
    local xPosition = (screenWidth - notificationWidth) / 2
    
    local mainFrame = createFrame(nil, UDim2.new(0, notificationWidth, 0, totalHeight), 
        UDim2.new(0, xPosition, 0, -totalHeight), 
        0.05, WarpHub.Config.DarkGlassColor, isMobile and 10 or 14)
    mainFrame.ZIndex = 1000
    
    -- Border effect
    local borderFrame = Instance.new("Frame")
    borderFrame.Size = UDim2.new(1, 0, 1, 0)
    borderFrame.BackgroundTransparency = 1
    borderFrame.ZIndex = 1001
    
    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0, isMobile and 10 or 14)
    borderCorner.Parent = borderFrame
    
    local borderStroke = Instance.new("UIStroke")
    borderStroke.Color = WarpHub.Config.AccentColor
    borderStroke.Thickness = 2
    borderStroke.Transparency = 0.3
    borderStroke.Parent = borderFrame
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -padding * 2, 0, titleHeight)
    titleLabel.Position = UDim2.new(0, padding, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = WarpHub.Config.AccentColor
    titleLabel.TextSize = isMobile and 16 or 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 1002
    
    -- Message
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -padding * 2, 0, messageHeight)
    messageLabel.Position = UDim2.new(0, padding, 0, titleHeight)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = WarpHub.Config.TextColor
    messageLabel.TextSize = isMobile and 13 or 14
    messageLabel.Font = Enum.Font.GothamMedium
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.TextWrapped = true
    messageLabel.ZIndex = 1002
    
    -- Progress bar
    local progressBarContainer = Instance.new("Frame")
    progressBarContainer.Size = UDim2.new(1, -padding * 2, 0, 2)
    progressBarContainer.Position = UDim2.new(0, padding, 1, -6)
    progressBarContainer.BackgroundColor3 = WarpHub.Config.GlassColor
    progressBarContainer.BackgroundTransparency = 0.5
    progressBarContainer.BorderSizePixel = 0
    progressBarContainer.ZIndex = 1002
    
    local progressBarCorner = Instance.new("UICorner")
    progressBarCorner.CornerRadius = UDim.new(1, 0)
    progressBarCorner.Parent = progressBarContainer
    
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.BackgroundColor3 = WarpHub.Config.AccentColor
    progressBar.BorderSizePixel = 0
    progressBar.ZIndex = 1003
    
    local progressBarInnerCorner = Instance.new("UICorner")
    progressBarInnerCorner.CornerRadius = UDim.new(1, 0)
    progressBarInnerCorner.Parent = progressBar
    
    -- Icon
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, isMobile and 20 or 22, 0, isMobile and 20 or 22)
    icon.Position = UDim2.new(1, -(padding + (isMobile and 20 or 22)), 0, padding / 2)
    icon.BackgroundTransparency = 1
    icon.AnchorPoint = Vector2.new(0.5, 0.5)
    
    local iconAsset = "rbxassetid://6031094678"
    local iconColor = WarpHub.Config.AccentColor
    
    if notificationType == "success" then
        iconAsset = "rbxassetid://6031094667"
        iconColor = Color3.fromRGB(85, 255, 127)
    elseif notificationType == "warning" then
        iconAsset = "rbxassetid://6031094669"
        iconColor = Color3.fromRGB(255, 100, 100)
    elseif notificationType == "error" then
        iconAsset = "rbxassetid://6031094670"
        iconColor = Color3.fromRGB(255, 170, 0)
    end
    
    icon.Image = iconAsset
    icon.ImageColor3 = iconColor
    icon.ZIndex = 1002
    
    -- Assemble
    borderFrame.Parent = mainFrame
    titleLabel.Parent = mainFrame
    messageLabel.Parent = mainFrame
    progressBar.Parent = progressBarContainer
    progressBarContainer.Parent = mainFrame
    icon.Parent = mainFrame
    mainFrame.Parent = notificationGUI
    notificationGUI.Parent = CoreGui
    
    -- Store notification
    local notificationId = #WarpHub.ActiveNotifications + 1
    local notificationData = {
        frame = mainFrame,
        id = notificationId,
        duration = duration,
        gui = notificationGUI,
        xPosition = xPosition,
        totalHeight = totalHeight
    }
    
    table.insert(WarpHub.ActiveNotifications, notificationData)
    
    -- Calculate vertical offset
    local verticalOffset = 20
    for i = 1, notificationId - 1 do
        local notif = WarpHub.ActiveNotifications[i]
        if notif and notif.frame then
            verticalOffset = verticalOffset + notif.totalHeight + 8
        end
    end
    
    -- Slide in
    TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, xPosition, 0, verticalOffset)
    }):Play()
    
    -- Progress animation
    TweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(1, 0, 1, 0)
    }):Play()
    
    -- Auto remove
    local removeConnection
    removeConnection = RunService.Heartbeat:Connect(function(dt)
        duration = duration - dt
        if duration <= 0 then
            removeConnection:Disconnect()
            
            -- Remove from table
            for i, notif in ipairs(WarpHub.ActiveNotifications) do
                if notif.id == notificationId then
                    table.remove(WarpHub.ActiveNotifications, i)
                    break
                end
            end
            
            -- Slide out
            TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0, xPosition, 0, -totalHeight),
                BackgroundTransparency = 1
            }):Play()
            
            TweenService:Create(titleLabel, TweenInfo.new(0.3), {
                TextTransparency = 1
            }):Play()
            
            TweenService:Create(messageLabel, TweenInfo.new(0.3), {
                TextTransparency = 1
            }):Play()
            
            TweenService:Create(icon, TweenInfo.new(0.3), {
                ImageTransparency = 1
            }):Play()
            
            -- Destroy after animation
            task.delay(0.35, function()
                if notificationGUI and notificationGUI.Parent then
                    notificationGUI:Destroy()
                end
            end)
        end
    end)
    
    -- Click to dismiss
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           (isMobile and input.UserInputType == Enum.UserInputType.Touch) then
            if removeConnection then
                removeConnection:Disconnect()
            end
            
            -- Remove from table
            for i, notif in ipairs(WarpHub.ActiveNotifications) do
                if notif.id == notificationId then
                    table.remove(WarpHub.ActiveNotifications, i)
                    break
                end
            end
            
            -- Quick fade out
            TweenService:Create(mainFrame, TweenInfo.new(0.2), {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, xPosition, 0, verticalOffset - 30)
            }):Play()
            
            TweenService:Create(titleLabel, TweenInfo.new(0.2), {
                TextTransparency = 1
            }):Play()
            
            TweenService:Create(messageLabel, TweenInfo.new(0.2), {
                TextTransparency = 1
            }):Play()
            
            TweenService:Create(icon, TweenInfo.new(0.2), {
                ImageTransparency = 1
            }):Play()
            
            task.delay(0.25, function()
                if notificationGUI and notificationGUI.Parent then
                    notificationGUI:Destroy()
                end
            end)
        end
    end)
    
    return notificationId
end

-- Create Window Function - Clean and safe
function WarpHub:CreateWindow(title)
    local self = setmetatable({}, WarpHub)
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "WarpHubUI_" .. HttpService:GenerateGUID(false):sub(1, 8)
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    self.ScreenGui.ResetOnSpawn = false
    
    -- Window dimensions
    self.windowWidth = isMobile and 340 or 520
    self.windowHeight = isMobile and 480 or 520
    
    -- Main frame
    self.MainFrame = createFrame(nil, UDim2.new(0, self.windowWidth, 0, self.windowHeight), 
        UDim2.new(0.5, -self.windowWidth/2, 0.5, -self.windowHeight/2), 
        WarpHub.Config.DarkGlassTransparency, WarpHub.Config.DarkGlassColor, isMobile and 16 or 20)
    self.MainFrame.Parent = self.ScreenGui

    local sidebarWidth = isMobile and 100 or 150
    local topBarHeight = isMobile and 40 or 50
    
    -- Top bar
    self.TopBar = createFrame(self.MainFrame, UDim2.new(1, -20, 0, topBarHeight), 
        UDim2.new(0, 10, 0, 10), 0.1, WarpHub.Config.GlassColor, isMobile and 10 or 12)
    
    -- Window title
    local windowTitle = Instance.new("TextLabel")
    windowTitle.Size = UDim2.new(1, -100, 1, 0)
    windowTitle.Position = UDim2.new(0, 12, 0, 0)
    windowTitle.BackgroundTransparency = 1
    windowTitle.Text = title or "Warp Hub"
    windowTitle.TextColor3 = WarpHub.Config.TextColor
    windowTitle.TextSize = isMobile and 18 or 22
    windowTitle.Font = Enum.Font.GothamBlack
    windowTitle.TextXAlignment = Enum.TextXAlignment.Left
    windowTitle.Parent = self.TopBar
    
    -- Minimize button
    self.MinimizeButton = Instance.new("ImageButton")
    self.MinimizeButton.Size = UDim2.new(0, isMobile and 20 or 24, 0, isMobile and 20 or 24)
    self.MinimizeButton.Position = UDim2.new(1, isMobile and -60 or -84, 0.5, isMobile and -10 or -12)
    self.MinimizeButton.BackgroundTransparency = 1
    self.MinimizeButton.Image = "rbxassetid://3926305904"
    self.MinimizeButton.ImageRectOffset = Vector2.new(564, 284)
    self.MinimizeButton.ImageRectSize = Vector2.new(36, 36)
    self.MinimizeButton.ImageColor3 = WarpHub.Config.TextColor
    self.MinimizeButton.AnchorPoint = Vector2.new(0, 0.5)
    self.MinimizeButton.Parent = self.TopBar
    
    -- Close button
    self.CloseButton = Instance.new("ImageButton")
    self.CloseButton.Size = UDim2.new(0, isMobile and 20 or 24, 0, isMobile and 20 or 24)
    self.CloseButton.Position = UDim2.new(1, isMobile and -30 or -44, 0.5, isMobile and -10 or -12)
    self.CloseButton.BackgroundTransparency = 1
    self.CloseButton.Image = "rbxassetid://3926305904"
    self.CloseButton.ImageRectOffset = Vector2.new(284, 4)
    self.CloseButton.ImageRectSize = Vector2.new(24, 24)
    self.CloseButton.ImageColor3 = WarpHub.Config.TextColor
    self.CloseButton.AnchorPoint = Vector2.new(0, 0.5)
    self.CloseButton.Parent = self.TopBar
    
    -- Sidebar
    self.Sidebar = createFrame(self.MainFrame, UDim2.new(0, sidebarWidth, 1, -(topBarHeight + 20)), 
        UDim2.new(0, 10, 0, topBarHeight + 16), 0.1, WarpHub.Config.GlassColor, isMobile and 10 or 12)
    
    -- Content area
    self.ContentArea = createFrame(self.MainFrame, UDim2.new(1, -(sidebarWidth + 20), 1, -(topBarHeight + 20)), 
        UDim2.new(0, sidebarWidth + 16, 0, topBarHeight + 16), 0.1, WarpHub.Config.GlassColor, isMobile and 10 or 12)
    
    -- Sidebar tabs container
    self.SidebarTabs = Instance.new("Frame")
    self.SidebarTabs.Size = UDim2.new(1, -10, 1, -10)
    self.SidebarTabs.Position = UDim2.new(0, 5, 0, 5)
    self.SidebarTabs.BackgroundTransparency = 1
    
    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, isMobile and 6 or 8)
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Parent = self.SidebarTabs
    
    -- Assemble
    self.SidebarTabs.Parent = self.Sidebar
    self.ScreenGui.Parent = CoreGui
    
    -- State variables
    self.isMinimized = false
    self.isClosing = false
    self.tabs = {}
    self.currentTab = nil
    self.dragging = false
    self.dragStart = Vector2.new(0, 0)
    self.startPos = self.MainFrame.Position
    
    -- Setup window interactions
    self:setupWindow()
    
    return self
end

-- Window setup with proper error handling
function WarpHub:setupWindow()
    if not self.TopBar then return end
    
    -- Toggle minimize
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
    
    -- Close UI
    local function closeUI()
        if self.isClosing then return end
        self.isClosing = true
        
        TweenService:Create(self.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        }):Play()
        
        task.delay(0.5, function()
            if self.ScreenGui and self.ScreenGui.Parent then
                self.ScreenGui:Destroy()
            end
        end)
    end
    
    -- Drag handling
    local function handleDragInput(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           (isMobile and input.UserInputType == Enum.UserInputType.Touch) then
            self.dragging = true
            self.dragStart = input.Position
            self.startPos = self.MainFrame.Position
            
            if isMobile then
                input:Capture()
            end
        end
    end
    
    self.TopBar.InputBegan:Connect(handleDragInput)
    
    local inputChangedConnection = UserInputService.InputChanged:Connect(function(input)
        if self.dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
           (isMobile and input.UserInputType == Enum.UserInputType.Touch)) then
            local delta = input.Position - self.dragStart
            self.MainFrame.Position = UDim2.new(
                self.startPos.X.Scale, 
                math.clamp(self.startPos.X.Offset + delta.X, 0, workspace.CurrentCamera.ViewportSize.X - self.windowWidth),
                self.startPos.Y.Scale, 
                math.clamp(self.startPos.Y.Offset + delta.Y, 0, workspace.CurrentCamera.ViewportSize.Y - self.windowHeight)
            )
        end
    end)
    
    local inputEndedConnection = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           (isMobile and input.UserInputType == Enum.UserInputType.Touch) then
            self.dragging = false
            if isMobile then
                input:Capture()
            end
        end
    end)
    
    -- Button events
    if self.MinimizeButton then
        self.MinimizeButton.MouseButton1Click:Connect(toggleMinimize)
    end
    
    if self.CloseButton then
        self.CloseButton.MouseButton1Click:Connect(closeUI)
    end
    
    -- Hover effects
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
    
    -- Store connections for cleanup
    self.connections = {
        inputChanged = inputChangedConnection,
        inputEnded = inputEndedConnection
    }
end

-- Add Tab function
function WarpHub:AddTab(name)
    if not name then 
        warn("Tab name cannot be nil")
        return nil 
    end
    
    local tab = {}
    setmetatable(tab, self)
    tab.__index = self
    
    -- Tab button
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, -6, 0, isMobile and 36 or 42)
    TabButton.BackgroundColor3 = WarpHub.Config.ButtonColor
    TabButton.BackgroundTransparency = 0.2
    TabButton.AutoButtonColor = false
    TabButton.Text = ""
    TabButton.BorderSizePixel = 0
    TabButton.LayoutOrder = #self.SidebarTabs:GetChildren() + 1
    
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
    
    -- Tab content
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
    
    -- Store tab data
    local tabData = {
        button = TabButton, 
        content = TabContent, 
        scrolling = TabScrolling,
        text = buttonText,
        name = name
    }
    table.insert(self.tabs, tabData)
    
    -- Tab selection function
    local function selectTab()
        for _, tData in ipairs(self.tabs) do
            if tData.content then
                tData.content.Visible = false
            end
            if tData.button then
                TweenService:Create(tData.button, TweenInfo.new(0.25), {
                    BackgroundTransparency = 0.2,
                    BackgroundColor3 = WarpHub.Config.ButtonColor
                }):Play()
            end
            if tData.text then
                TweenService:Create(tData.text, TweenInfo.new(0.25), {
                    TextColor3 = WarpHub.Config.SubTextColor
                }):Play()
            end
        end
        
        if TabContent then
            TabContent.Visible = true
        end
        if TabButton then
            TweenService:Create(TabButton, TweenInfo.new(0.25), {
                BackgroundTransparency = 0.1,
                BackgroundColor3 = WarpHub.Config.AccentColor
            }):Play()
        end
        if buttonText then
            TweenService:Create(buttonText, TweenInfo.new(0.25), {
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        end
        
        self.currentTab = tabData
    end
    
    -- Button interactions
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
    end
    
    -- Parent everything
    if TabButton then
        TabButton.Parent = self.SidebarTabs
    end
    if TabScrolling then
        TabScrolling.Parent = TabContent
    end
    if TabContent then
        TabContent.Parent = self.ContentArea
    end
    
    -- Select first tab automatically
    if #self.tabs == 1 then
        task.spawn(function()
            task.wait(0.1)
            selectTab()
        end)
    end
    
    -- Return tab functions
    function tab:AddSection(title)
        if not title then 
            warn("Section title cannot be nil")
            return {} 
        end
        
        local section = {}
        
        -- Section container
        local SectionContainer = Instance.new("Frame")
        SectionContainer.Size = UDim2.new(1, -6, 0, 0)
        SectionContainer.Position = UDim2.new(0, 3, 0, 0)
        SectionContainer.BackgroundTransparency = 1
        SectionContainer.LayoutOrder = #TabScrolling:GetChildren() + 1
        
        -- Section header
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
        
        -- Section content
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
        
        -- Button
        function section:AddButton(name, callback)
            if not name then return nil end
            
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, isMobile and 36 or 40)
            Button.BackgroundColor3 = WarpHub.Config.ButtonColor
            Button.BackgroundTransparency = 0.15
            Button.AutoButtonColor = false
            Button.Text = ""
            Button.BorderSizePixel = 0
            Button.LayoutOrder = #SectionContent:GetChildren() + 1
            
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
            
            if callback then
                Button.MouseButton1Click:Connect(function()
                    pcall(callback)
                end)
            end
            
            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.08,
                    BackgroundColor3 = WarpHub.Config.ButtonHoverColor
                }):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.15,
                    BackgroundColor3 = WarpHub.Config.ButtonColor
                }):Play()
            end)
            
            Button.Parent = SectionContent
            updateSectionHeight()
            
            return Button
        end
        
        -- Toggle
        function section:AddToggle(name, callback)
            if not name then return nil end
            
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
            label.Parent = Toggle
            
            local toggleButton = Instance.new("TextButton")
            toggleButton.Size = UDim2.new(0, isMobile and 40 or 46, 0, isMobile and 20 or 24)
            toggleButton.Position = UDim2.new(1, isMobile and -40 or -46, 0.5, isMobile and -10 or -12)
            toggleButton.BackgroundColor3 = WarpHub.Config.ButtonColor
            toggleButton.BackgroundTransparency = 0.15
            toggleButton.AutoButtonColor = false
            toggleButton.Text = ""
            toggleButton.BorderSizePixel = 0
            
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
            toggleButton.Parent = Toggle
            Toggle.Parent = SectionContent
            
            updateToggle()
            updateSectionHeight()
            
            local toggleObj = {
                instance = Toggle,
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
        
        -- Dropdown
        function section:AddDropdown(name, options, defaultOption, callback)
            if not name or not options or #options == 0 then return nil end
            
            local selectedOption = defaultOption or options[1]
            local dropdownOpen = false
            
            local Dropdown = Instance.new("Frame")
            Dropdown.Size = UDim2.new(1, 0, 0, isMobile and 36 or 40)
            Dropdown.BackgroundTransparency = 1
            Dropdown.LayoutOrder = #SectionContent:GetChildren() + 1
            Dropdown.ClipsDescendants = true
            
            -- Main button
            local dropdownButton = Instance.new("TextButton")
            dropdownButton.Size = UDim2.new(1, 0, 0, isMobile and 36 or 40)
            dropdownButton.BackgroundColor3 = WarpHub.Config.DropdownBackground
            dropdownButton.BackgroundTransparency = 0.15
            dropdownButton.AutoButtonColor = false
            dropdownButton.Text = ""
            dropdownButton.BorderSizePixel = 0
            
            local dropdownCorner = Instance.new("UICorner")
            dropdownCorner.CornerRadius = UDim.new(0, isMobile and 8 or 10)
            dropdownCorner.Parent = dropdownButton
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.7, -10, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = name .. ": " .. selectedOption
            label.TextColor3 = WarpHub.Config.TextColor
            label.TextSize = isMobile and 13 or 14
            label.Font = Enum.Font.GothamMedium
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextTruncate = Enum.TextTruncate.AtEnd
            label.Parent = dropdownButton
            
            local arrow = Instance.new("ImageLabel")
            arrow.Size = UDim2.new(0, isMobile and 16 or 20, 0, isMobile and 16 or 20)
            arrow.Position = UDim2.new(1, isMobile and -28 or -32, 0.5, isMobile and -8 or -10)
            arrow.BackgroundTransparency = 1
            arrow.Image = "rbxassetid://6031091006"
            arrow.ImageColor3 = WarpHub.Config.AccentColor
            arrow.AnchorPoint = Vector2.new(1, 0.5)
            arrow.Parent = dropdownButton
            
            -- Options frame
            local optionsFrame = Instance.new("Frame")
            optionsFrame.Size = UDim2.new(1, 0, 0, 0)
            optionsFrame.Position = UDim2.new(0, 0, 0, isMobile and 40 or 44)
            optionsFrame.BackgroundColor3 = WarpHub.Config.DropdownOpenBackground
            optionsFrame.BackgroundTransparency = 0.1
            optionsFrame.BorderSizePixel = 0
            optionsFrame.Visible = false
            optionsFrame.ClipsDescendants = true
            
            local optionsCorner = Instance.new("UICorner")
            optionsCorner.CornerRadius = UDim.new(0, isMobile and 6 or 8)
            optionsCorner.Parent = optionsFrame
            
            local optionsScrolling = Instance.new("ScrollingFrame")
            optionsScrolling.Size = UDim2.new(1, -8, 1, -8)
            optionsScrolling.Position = UDim2.new(0, 4, 0, 4)
            optionsScrolling.BackgroundTransparency = 1
            optionsScrolling.ScrollBarThickness = isMobile and 2 or 3
            optionsScrolling.ScrollBarImageColor3 = WarpHub.Config.AccentColor
            optionsScrolling.ScrollBarImageTransparency = 0.5
            optionsScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
            optionsScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
            
            local optionsList = Instance.new("UIListLayout")
            optionsList.Padding = UDim.new(0, isMobile and 4 or 6)
            optionsList.SortOrder = Enum.SortOrder.LayoutOrder
            optionsList.Parent = optionsScrolling
            
            -- Toggle dropdown
            local function toggleDropdown()
                dropdownOpen = not dropdownOpen
                
                if dropdownOpen then
                    local totalHeight = 0
                    for _, option in ipairs(options) do
                        totalHeight = totalHeight + (isMobile and 32 or 36)
                    end
                    totalHeight = totalHeight + (optionsList.Padding.Offset * (#options - 1))
                    totalHeight = math.min(totalHeight + 16, isMobile and 200 or 300)
                    
                    Dropdown.Size = UDim2.new(1, 0, 0, (isMobile and 36 or 40) + totalHeight + 8)
                    optionsFrame.Size = UDim2.new(1, 0, 0, totalHeight)
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
            
            -- Create option buttons
            for i, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Size = UDim2.new(1, 0, 0, isMobile and 32 or 36)
                optionButton.BackgroundColor3 = WarpHub.Config.DropdownBackground
                optionButton.BackgroundTransparency = 0.2
                optionButton.AutoButtonColor = false
                optionButton.Text = ""
                optionButton.BorderSizePixel = 0
                optionButton.LayoutOrder = i
                
                local optionCorner = Instance.new("UICorner")
                optionCorner.CornerRadius = UDim.new(0, isMobile and 6 or 8)
                optionCorner.Parent = optionButton
                
                local optionText = Instance.new("TextLabel")
                optionText.Size = UDim2.new(1, -10, 1, 0)
                optionText.Position = UDim2.new(0, 8, 0, 0)
                optionText.BackgroundTransparency = 1
                optionText.Text = option
                optionText.TextColor3 = option == selectedOption and WarpHub.Config.DropdownSelectedText or WarpHub.Config.DropdownText
                optionText.TextSize = isMobile and 12 or 13
                optionText.Font = Enum.Font.GothamMedium
                optionText.TextXAlignment = Enum.TextXAlignment.Left
                optionText.Parent = optionButton
                
                optionButton.MouseButton1Click:Connect(function()
                    selectedOption = option
                    label.Text = name .. ": " .. selectedOption
                    
                    -- Update all options
                    for _, child in ipairs(optionsScrolling:GetChildren()) do
                        if child:IsA("TextButton") then
                            local text = child:FindFirstChild("TextLabel")
                            if text then
                                text.TextColor3 = text.Text == option and WarpHub.Config.DropdownSelectedText or WarpHub.Config.DropdownText
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
                
                optionButton.Parent = optionsScrolling
            end
            
            -- Main button events
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
            
            -- Assemble
            optionsScrolling.Parent = optionsFrame
            dropdownButton.Parent = Dropdown
            optionsFrame.Parent = Dropdown
            Dropdown.Parent = SectionContent
            
            updateSectionHeight()
            
            -- Return dropdown object
            local dropdownObj = {
                instance = Dropdown,
                selected = selectedOption,
                Update = function(self, newOption)
                    selectedOption = newOption
                    label.Text = name .. ": " .. selectedOption
                    
                    for _, child in ipairs(optionsScrolling:GetChildren()) do
                        if child:IsA("TextButton") then
                            local text = child:FindFirstChild("TextLabel")
                            if text then
                                text.TextColor3 = text.Text == newOption and WarpHub.Config.DropdownSelectedText or WarpHub.Config.DropdownText
                            end
                        end
                    end
                    
                    if callback then
                        pcall(callback, selectedOption)
                    end
                end,
                GetSelected = function(self)
                    return selectedOption
                end,
                SetOptions = function(self, newOptions)
                    if not newOptions or #newOptions == 0 then return end
                    
                    -- Clear old options
                    for _, child in ipairs(optionsScrolling:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    options = newOptions
                    
                    -- Create new options
                    for i, option in ipairs(newOptions) do
                        local optionButton = Instance.new("TextButton")
                        optionButton.Size = UDim2.new(1, 0, 0, isMobile and 32 or 36)
                        optionButton.BackgroundColor3 = WarpHub.Config.DropdownBackground
                        optionButton.BackgroundTransparency = 0.2
                        optionButton.AutoButtonColor = false
                        optionButton.Text = ""
                        optionButton.BorderSizePixel = 0
                        optionButton.LayoutOrder = i
                        
                        local optionCorner = Instance.new("UICorner")
                        optionCorner.CornerRadius = UDim.new(0, isMobile and 6 or 8)
                        optionCorner.Parent = optionButton
                        
                        local optionText = Instance.new("TextLabel")
                        optionText.Size = UDim2.new(1, -10, 1, 0)
                        optionText.Position = UDim2.new(0, 8, 0, 0)
                        optionText.BackgroundTransparency = 1
                        optionText.Text = option
                        optionText.TextColor3 = option == selectedOption and WarpHub.Config.DropdownSelectedText or WarpHub.Config.DropdownText
                        optionText.TextSize = isMobile and 12 or 13
                        optionText.Font = Enum.Font.GothamMedium
                        optionText.TextXAlignment = Enum.TextXAlignment.Left
                        optionText.Parent = optionButton
                        
                        optionButton.MouseButton1Click:Connect(function()
                            selectedOption = option
                            label.Text = name .. ": " .. selectedOption
                            
                            for _, child in ipairs(optionsScrolling:GetChildren()) do
                                if child:IsA("TextButton") then
                                    local text = child:FindFirstChild("TextLabel")
                                    if text then
                                        text.TextColor3 = text.Text == option and WarpHub.Config.DropdownSelectedText or WarpHub.Config.DropdownText
                                    end
                                end
                            end
                            
                            toggleDropdown()
                            
                            if callback then
                                pcall(callback, selectedOption)
                            end
                        end)
                        
                        optionButton.Parent = optionsScrolling
                    end
                    
                    updateSectionHeight()
                end
            }
            
            return dropdownObj
        end
        
        -- Label
        function section:AddLabel(text)
            if not text then return nil end
            
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
            
            return Label
        end
        
        -- Slider
        function section:AddSlider(name, min, max, default, callback)
            if not name then return nil end
            
            min = min or 0
            max = max or 100
            default = default or min
            
            local sliderValue = math.clamp(default, min, max)
            
            local Slider = Instance.new("Frame")
            Slider.Size = UDim2.new(1, 0, 0, isMobile and 50 or 60)
            Slider.BackgroundTransparency = 1
            Slider.LayoutOrder = #SectionContent:GetChildren() + 1
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 0, isMobile and 20 or 24)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = name .. ": " .. sliderValue
            nameLabel.TextColor3 = WarpHub.Config.TextColor
            nameLabel.TextSize = isMobile and 13 or 14
            nameLabel.Font = Enum.Font.GothamMedium
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.Parent = Slider
            
            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, 0, 0, isMobile and 6 or 8)
            track.Position = UDim2.new(0, 0, 0, isMobile and 28 or 34)
            track.BackgroundColor3 = WarpHub.Config.SliderTrack
            track.BackgroundTransparency = 0.2
            track.BorderSizePixel = 0
            
            local trackCorner = Instance.new("UICorner")
            trackCorner.CornerRadius = UDim.new(1, 0)
            trackCorner.Parent = track
            
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(0, 0, 1, 0)
            fill.BackgroundColor3 = WarpHub.Config.SliderFill
            fill.BorderSizePixel = 0
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillCorner.Parent = fill
            
            local handle = Instance.new("TextButton")
            handle.Size = UDim2.new(0, isMobile and 16 or 20, 0, isMobile and 16 or 20)
            handle.BackgroundColor3 = WarpHub.Config.AccentColor
            handle.AutoButtonColor = false
            handle.Text = ""
            handle.BorderSizePixel = 0
            
            local handleCorner = Instance.new("UICorner")
            handleCorner.CornerRadius = UDim.new(1, 0)
            handleCorner.Parent = handle
            
            local function updateSlider(value)
                sliderValue = math.clamp(value, min, max)
                local percentage = (sliderValue - min) / (max - min)
                
                fill.Size = UDim2.new(percentage, 0, 1, 0)
                handle.Position = UDim2.new(percentage, isMobile and -8 or -10, 0, isMobile and -8 or -10)
                nameLabel.Text = name .. ": " .. math.floor(sliderValue)
                
                if callback then
                    pcall(callback, sliderValue)
                end
            end
            
            local dragging = false
            handle.MouseButton1Down:Connect(function()
                dragging = true
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    local mousePosition = input.Position.X
                    local trackPosition = track.AbsolutePosition.X
                    local trackWidth = track.AbsoluteSize.X
                    local relativePosition = (mousePosition - trackPosition) / trackWidth
                    local newValue = min + (max - min) * math.clamp(relativePosition, 0, 1)
                    updateSlider(newValue)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePosition = input.Position.X
                    local trackPosition = track.AbsolutePosition.X
                    local trackWidth = track.AbsoluteSize.X
                    local relativePosition = (mousePosition - trackPosition) / trackWidth
                    local newValue = min + (max - min) * math.clamp(relativePosition, 0, 1)
                    updateSlider(newValue)
                end
            end)
            
            fill.Parent = track
            handle.Parent = track
            track.Parent = Slider
            Slider.Parent = SectionContent
            
            updateSlider(default)
            updateSectionHeight()
            
            local sliderObj = {
                instance = Slider,
                GetValue = function(self)
                    return sliderValue
                end,
                SetValue = function(self, value)
                    updateSlider(value)
                end
            }
            
            return sliderObj
        end
        
        return section
    end
    
    return tab
end

-- Return the library
return WarpHub
