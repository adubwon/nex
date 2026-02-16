-- Luarmor Support
local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local function safeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        return nil
    end
    return result
end

function Library.CreateInstance(className, properties)
    return safeCall(function()
        local instance = Instance.new(className)
        for prop, value in pairs(properties) do
            if prop ~= "Parent" then
                pcall(function()
                    instance[prop] = value
                end)
            end
        end
        if properties.Parent then
            pcall(function()
                instance.Parent = properties.Parent
            end)
        end
        return instance
    end)
end

function Library.UDim2(scaleX, offsetX, scaleY, offsetY)
    return UDim2.new(scaleX, offsetX, scaleY, offsetY)
end

local ActiveDropdowns = {}

local function closeOtherDropdowns(exceptId)
    for id, dropdownData in pairs(ActiveDropdowns) do
        if id ~= exceptId and dropdownData and dropdownData.Close then
            pcall(dropdownData.Close)
        end
    end
end

-- Mobile detection and scaling
local IsMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local Scale = IsMobile and 1.2 or 1

-- Modern theme presets
local Themes = {
    Default = {
        Background = Color3.fromRGB(13, 13, 18),
        Header = Color3.fromRGB(20, 20, 28),
        Sidebar = Color3.fromRGB(16, 16, 22),
        Content = Color3.fromRGB(13, 13, 18),
        Element = Color3.fromRGB(28, 28, 36),
        ElementHover = Color3.fromRGB(38, 38, 48),
        Accent = Color3.fromRGB(108, 93, 255),
        AccentHover = Color3.fromRGB(128, 113, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(190, 190, 210),
        TextMuted = Color3.fromRGB(140, 140, 160),
        Border = Color3.fromRGB(48, 48, 58),
        Glow = Color3.fromRGB(108, 93, 255),
    },
    Dark = {
        Background = Color3.fromRGB(8, 8, 12),
        Header = Color3.fromRGB(12, 12, 18),
        Sidebar = Color3.fromRGB(10, 10, 15),
        Content = Color3.fromRGB(8, 8, 12),
        Element = Color3.fromRGB(22, 22, 28),
        ElementHover = Color3.fromRGB(32, 32, 40),
        Accent = Color3.fromRGB(147, 112, 219),
        AccentHover = Color3.fromRGB(167, 132, 239),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 220),
        TextMuted = Color3.fromRGB(150, 150, 170),
        Border = Color3.fromRGB(40, 40, 50),
        Glow = Color3.fromRGB(147, 112, 219),
    },
    Light = {
        Background = Color3.fromRGB(245, 245, 250),
        Header = Color3.fromRGB(235, 235, 240),
        Sidebar = Color3.fromRGB(240, 240, 245),
        Content = Color3.fromRGB(245, 245, 250),
        Element = Color3.fromRGB(255, 255, 255),
        ElementHover = Color3.fromRGB(245, 245, 255),
        Accent = Color3.fromRGB(88, 86, 214),
        AccentHover = Color3.fromRGB(108, 106, 234),
        Text = Color3.fromRGB(18, 18, 24),
        TextSecondary = Color3.fromRGB(60, 60, 75),
        TextMuted = Color3.fromRGB(110, 110, 125),
        Border = Color3.fromRGB(210, 210, 225),
        Glow = Color3.fromRGB(88, 86, 214),
    },
    Midnight = {
        Background = Color3.fromRGB(5, 5, 15),
        Header = Color3.fromRGB(10, 10, 25),
        Sidebar = Color3.fromRGB(7, 7, 20),
        Content = Color3.fromRGB(5, 5, 15),
        Element = Color3.fromRGB(18, 18, 35),
        ElementHover = Color3.fromRGB(28, 28, 48),
        Accent = Color3.fromRGB(0, 194, 255),
        AccentHover = Color3.fromRGB(50, 214, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(170, 200, 240),
        TextMuted = Color3.fromRGB(100, 130, 180),
        Border = Color3.fromRGB(30, 40, 65),
        Glow = Color3.fromRGB(0, 194, 255),
    }
}

function Library.CreateWindow(Properties)
    if not Properties then Properties = {} end
    
    local CurrentTheme = Themes.Default
    
    local Window = {
        Name = Properties.Name or "UI Library",
        Position = Properties.Position or Library.UDim2(0.5, -350, 0.5, -250),
        Size = Properties.Size or Library.UDim2(0, 700, 0, 500),
        Tabs = {},
        Minimized = false,
        Visible = true,
        Elements = {},
        AllElements = {},
        Mobile = IsMobile,
        Dragging = false,
        DragStart = nil,
        StartPos = nil,
        Theme = CurrentTheme,
    }
    
    local playerGui = safeCall(function()
        return Players.LocalPlayer:WaitForChild("PlayerGui", 5)
    end)
    
    if not playerGui then
        return Window
    end
    
    -- Create main GUI
    local mainframe = Library.CreateInstance("ScreenGui", {
        Name = "ModernUILibrary",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100,
        Parent = playerGui,
    })
    
    -- Main window with modern shadow
    local mainHolder = Library.CreateInstance("Frame", {
        Name = "MainHolder",
        BackgroundColor3 = CurrentTheme.Background,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Position = Window.Position,
        Size = Window.Size,
        Parent = mainframe,
        ClipsDescendants = true,
    })
    
    -- Shadow effect
    local shadow = Library.CreateInstance("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Position = Library.UDim2(0, -15, 0, -15),
        Size = Library.UDim2(1, 30, 1, 30),
        Image = "rbxassetid://13155678415",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        Parent = mainHolder,
    })
    
    Library.CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, IsMobile and 18 or 14),
        Parent = mainHolder,
    })
    
    -- Modern header with gradient
    local titleBar = Library.CreateInstance("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = CurrentTheme.Header,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Size = Library.UDim2(1, 0, 0, IsMobile and 48 or 42),
        Parent = mainHolder,
    })
    
    Library.CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, IsMobile and 18 or 14, 0, 0),
        Parent = titleBar,
    })
    
    -- Header glow effect
    local headerGlow = Library.CreateInstance("Frame", {
        Name = "HeaderGlow",
        BackgroundColor3 = CurrentTheme.Accent,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        Size = Library.UDim2(1, 0, 0, 1),
        Position = Library.UDim2(0, 0, 1, 0),
        Parent = titleBar,
    })
    
    -- Draggable area
    local dragArea = Library.CreateInstance("Frame", {
        Name = "DragArea",
        BackgroundTransparency = 1,
        Size = Library.UDim2(1, -100, 1, 0),
        Position = Library.UDim2(0, 0, 0, 0),
        Parent = titleBar,
    })
    
    -- Title with modern styling
    local titleText = Library.CreateInstance("TextLabel", {
        Name = "TitleText",
        Text = Window.Name,
        Font = Enum.Font.GothamSemibold,
        TextColor3 = CurrentTheme.Text,
        TextSize = IsMobile and 18 or 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = Library.UDim2(0, IsMobile and 18 or 15, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = Library.UDim2(0, 300, 0, IsMobile and 26 or 22),
        Parent = titleBar,
    })
    
    -- Window controls
    local minimizeButton = Library.CreateInstance("TextButton", {
        Name = "MinimizeButton",
        Text = "─",
        Font = Enum.Font.GothamBold,
        TextColor3 = CurrentTheme.Text,
        TextSize = IsMobile and 18 or 16,
        AutoButtonColor = false,
        BackgroundColor3 = CurrentTheme.Element,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Position = Library.UDim2(1, -65, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Size = Library.UDim2(0, IsMobile and 32 or 28, 0, IsMobile and 32 or 28),
        Parent = titleBar,
        ZIndex = 2,
    })
    
    Library.CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, IsMobile and 8 or 6),
        Parent = minimizeButton,
    })
    
    local closeButton = Library.CreateInstance("TextButton", {
        Name = "CloseButton",
        Text = "×",
        Font = Enum.Font.GothamBold,
        TextColor3 = CurrentTheme.Text,
        TextSize = IsMobile and 22 or 20,
        AutoButtonColor = false,
        BackgroundColor3 = CurrentTheme.Element,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Position = Library.UDim2(1, -25, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Size = Library.UDim2(0, IsMobile and 32 or 28, 0, IsMobile and 32 or 28),
        Parent = titleBar,
        ZIndex = 2,
    })
    
    Library.CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, IsMobile and 8 or 6),
        Parent = closeButton,
    })
    
    -- Content area
    local contentArea = Library.CreateInstance("Frame", {
        Name = "ContentArea",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = Library.UDim2(0, 0, 0, IsMobile and 48 or 42),
        Size = Library.UDim2(1, 0, 1, -(IsMobile and 48 or 42)),
        Parent = mainHolder,
    })
    
    -- Dragging functionality
    local function startDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Window.Dragging = true
            Window.DragStart = input.Position
            Window.StartPos = mainHolder.Position
        end
    end
    
    local function updateDrag(input)
        if Window.Dragging then
            local delta = input.Position - Window.DragStart
            mainHolder.Position = UDim2.new(
                Window.StartPos.X.Scale,
                Window.StartPos.X.Offset + delta.X,
                Window.StartPos.Y.Scale,
                Window.StartPos.Y.Offset + delta.Y
            )
        end
    end
    
    local function stopDrag()
        Window.Dragging = false
    end
    
    dragArea.InputBegan:Connect(startDrag)
    dragArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            updateDrag(input)
        end
    end)
    dragArea.InputEnded:Connect(stopDrag)
    
    -- Sidebar with modern design
    local sidebarHolder = Library.CreateInstance("Frame", {
        Name = "SidebarHolder",
        BackgroundColor3 = CurrentTheme.Sidebar,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Size = Library.UDim2(0, IsMobile and 150 or 160, 1, 0),
        Parent = contentArea,
    })
    
    Library.CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 0, 0, IsMobile and 18 or 14),
        Parent = sidebarHolder,
    })
    
    -- Search bar with modern styling
    local search = Library.CreateInstance("Frame", {
        Name = "Search",
        BackgroundTransparency = 1,
        Size = Library.UDim2(1, 0, 0, IsMobile and 60 or 55),
        Parent = sidebarHolder,
    })
    
    local searchzone = Library.CreateInstance("Frame", {
        Name = "searchzone",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = CurrentTheme.Element,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Position = Library.UDim2(0.5, 0, 0.5, 0),
        Size = Library.UDim2(1, -20, 0, IsMobile and 36 or 32),
        Parent = search,
    })
    
    Library.CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, IsMobile and 10 or 8),
        Parent = searchzone,
    })
    
    local searchIcon = Library.CreateInstance("ImageLabel", {
        Name = "SearchIcon",
        Image = "rbxassetid://139032822388177",
        ImageColor3 = CurrentTheme.TextMuted,
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Position = Library.UDim2(0, IsMobile and 10 or 8, 0.5, 0),
        Size = Library.UDim2(0, IsMobile and 18 or 16, 0, IsMobile and 18 or 16),
        Parent = searchzone,
    })
    
    local searchInput = Library.CreateInstance("TextBox", {
        Name = "SearchBox",
        Font = Enum.Font.Gotham,
        PlaceholderText = "Search...",
        PlaceholderColor3 = CurrentTheme.TextMuted,
        Text = "",
        TextColor3 = CurrentTheme.Text,
        TextSize = IsMobile and 15 or 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = Library.UDim2(0, IsMobile and 34 or 30, 0, 0),
        Size = Library.UDim2(1, -(IsMobile and 40 or 35), 1, 0),
        Parent = searchzone,
    })
    
    -- Tab container with proper spacing
    local tabHolder = Library.CreateInstance("ScrollingFrame", {
        Name = "TabContainer",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = IsMobile and 4 or 3,
        ScrollBarImageColor3 = CurrentTheme.Border,
        Position = Library.UDim2(0, 0, 0, IsMobile and 60 or 55),
        Size = Library.UDim2(1, 0, 1, -(IsMobile and 60 or 55)),
        Parent = sidebarHolder,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    })
    
    Library.CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, IsMobile and 12 or 10),
        PaddingLeft = UDim.new(0, IsMobile and 10 or 8),
        PaddingRight = UDim.new(0, IsMobile and 10 or 8),
        PaddingBottom = UDim.new(0, IsMobile and 12 or 10),
        Parent = tabHolder,
    })
    
    local tabLayout = Library.CreateInstance("UIListLayout", {
        Padding = UDim.new(0, IsMobile and 8 or 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tabHolder,
    })
    
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        pcall(function()
            tabHolder.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + (IsMobile and 24 or 20))
        end)
    end)
    
    -- Sidebar divider with glow
    local sidebarDivider = Library.CreateInstance("Frame", {
        Name = "SidebarDivider",
        BackgroundColor3 = CurrentTheme.Accent,
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        Position = Library.UDim2(1, 0, 0, 0),
        Size = Library.UDim2(0, 2, 1, 0),
        Parent = sidebarHolder,
    })
    
    -- Main content with modern styling
    local content = Library.CreateInstance("Frame", {
        Name = "Content",
        BackgroundColor3 = CurrentTheme.Content,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Size = Library.UDim2(1, -(IsMobile and 150 or 160), 1, 0),
        Position = Library.UDim2(0, IsMobile and 150 or 160, 0, 0),
        Parent = contentArea,
    })
    
    Library.CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 0, IsMobile and 18 or 14, 0),
        Parent = content,
    })
    
    -- Content inner glow
    local contentGlow = Library.CreateInstance("Frame", {
        Name = "ContentGlow",
        BackgroundColor3 = CurrentTheme.Accent,
        BackgroundTransparency = 0.95,
        BorderSizePixel = 0,
        Size = Library.UDim2(1, 0, 0, 1),
        Position = Library.UDim2(0, 0, 0, 0),
        Parent = content,
    })
    
    -- Apply theme function
    function Window:ApplyTheme(theme)
        CurrentTheme = theme
        Window.Theme = theme
        
        -- Apply to main elements
        mainHolder.BackgroundColor3 = theme.Background
        titleBar.BackgroundColor3 = theme.Header
        headerGlow.BackgroundColor3 = theme.Accent
        titleText.TextColor3 = theme.Text
        minimizeButton.BackgroundColor3 = theme.Element
        minimizeButton.TextColor3 = theme.Text
        closeButton.BackgroundColor3 = theme.Element
        closeButton.TextColor3 = theme.Text
        sidebarHolder.BackgroundColor3 = theme.Sidebar
        searchzone.BackgroundColor3 = theme.Element
        searchIcon.ImageColor3 = theme.TextMuted
        searchInput.TextColor3 = theme.Text
        searchInput.PlaceholderColor3 = theme.TextMuted
        tabHolder.ScrollBarImageColor3 = theme.Border
        sidebarDivider.BackgroundColor3 = theme.Accent
        content.BackgroundColor3 = theme.Content
        contentGlow.BackgroundColor3 = theme.Accent
        
        -- Update all elements
        for _, element in pairs(Window.AllElements) do
            if element.UpdateTheme then
                element:UpdateTheme(theme)
            end
        end
    end
    
    -- Minimize functionality
    minimizeButton.MouseButton1Click:Connect(function()
        pcall(function()
            Window.Minimized = not Window.Minimized
            if Window.Minimized then
                contentArea.Visible = false
                minimizeButton.Text = "□"
                mainHolder.Size = Library.UDim2(0, IsMobile and 280 or 250, 0, IsMobile and 48 or 42)
            else
                contentArea.Visible = true
                minimizeButton.Text = "─"
                mainHolder.Size = Window.Size
            end
        end)
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        pcall(function()
            mainframe:Destroy()
            Window.Visible = false
        end)
    end)
    
    -- Keybind toggle
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
            pcall(function()
                mainHolder.Visible = not mainHolder.Visible
            end)
        end
    end)
    
    function Window:Tab(Properties)
        if not Properties then Properties = {} end
        
        local Tab = {
            Name = Properties.Title or "Tab",
            Icon = Properties.Icon,
            Window = self,
            Open = false,
            Sections = {},
        }
        
        local tabButton = Library.CreateInstance("TextButton", {
            Name = "TabButton_" .. Tab.Name,
            Text = "",
            AutoButtonColor = false,
            BackgroundColor3 = CurrentTheme.Element,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = Library.UDim2(1, 0, 0, IsMobile and 42 or 38),
            Parent = tabHolder,
            LayoutOrder = #Window.Tabs + 1,
        })
        
        Library.CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, IsMobile and 10 or 8),
            Parent = tabButton,
        })
        
        local tabContent = Library.CreateInstance("ScrollingFrame", {
            Name = "TabContent_" .. Tab.Name,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarImageColor3 = CurrentTheme.Border,
            ScrollBarThickness = IsMobile and 4 or 3,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = Library.UDim2(0, IsMobile and 15 or 12, 0, IsMobile and 15 or 12),
            Size = Library.UDim2(1, -(IsMobile and 30 or 24), 1, -(IsMobile and 30 or 24)),
            Visible = false,
            Parent = content,
        })
        
        local contentLayout = Library.CreateInstance("UIListLayout", {
            Padding = UDim.new(0, IsMobile and 15 or 12),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = tabContent,
        })
        
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            pcall(function()
                tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + (IsMobile and 30 or 24))
            end)
        end)
        
        -- Tab button content with proper spacing
        local buttonContent = Library.CreateInstance("Frame", {
            BackgroundTransparency = 1,
            Size = Library.UDim2(1, 0, 1, 0),
            Parent = tabButton,
        })
        
        Library.CreateInstance("UIPadding", {
            PaddingLeft = UDim.new(0, IsMobile and 12 or 10),
            PaddingRight = UDim.new(0, IsMobile and 12 or 10),
            Parent = buttonContent,
        })
        
        local buttonLayout = Library.CreateInstance("UIListLayout", {
            Padding = UDim.new(0, IsMobile and 10 or 8),
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Parent = buttonContent,
        })
        
        local icon
        if Tab.Icon then
            icon = Library.CreateInstance("ImageLabel", {
                Image = Tab.Icon,
                ImageColor3 = CurrentTheme.TextSecondary,
                BackgroundTransparency = 1,
                Size = Library.UDim2(0, IsMobile and 20 or 18, 0, IsMobile and 20 or 18),
                LayoutOrder = 1,
                Parent = buttonContent,
            })
        else
            icon = Library.CreateInstance("ImageLabel", {
                Image = "rbxassetid://6023426926",
                ImageColor3 = CurrentTheme.TextSecondary,
                BackgroundTransparency = 1,
                Size = Library.UDim2(0, IsMobile and 20 or 18, 0, IsMobile and 20 or 18),
                LayoutOrder = 1,
                Parent = buttonContent,
            })
        end
        
        local name = Library.CreateInstance("TextLabel", {
            Text = Tab.Name,
            Font = Enum.Font.GothamMedium,
            TextColor3 = CurrentTheme.TextSecondary,
            TextSize = IsMobile and 16 or 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Size = Library.UDim2(0, 100, 1, 0),
            LayoutOrder = 2,
            Parent = buttonContent,
        })
        
        function Tab:UpdateTheme(theme)
            if Tab.Open then
                tabButton.BackgroundTransparency = 0.85
                icon.ImageColor3 = theme.Text
                name.TextColor3 = theme.Text
            else
                tabButton.BackgroundTransparency = 1
                icon.ImageColor3 = theme.TextSecondary
                name.TextColor3 = theme.TextSecondary
            end
        end
        
        function Tab:Turn(bool)
            Tab.Open = bool
            
            if bool then
                tabButton.BackgroundTransparency = 0.85
                icon.ImageColor3 = CurrentTheme.Text
                name.TextColor3 = CurrentTheme.Text
                tabContent.Visible = true
            else
                tabButton.BackgroundTransparency = 1
                icon.ImageColor3 = CurrentTheme.TextSecondary
                name.TextColor3 = CurrentTheme.TextSecondary
                tabContent.Visible = false
            end
        end
        
        tabButton.MouseButton1Click:Connect(function()
            if not Tab.Open then
                for _, otherTab in pairs(Tab.Window.Tabs) do
                    if otherTab.Open and otherTab ~= Tab then
                        otherTab:Turn(false)
                    end
                end
                Tab:Turn(true)
            end
        end)
        
        tabButton.MouseEnter:Connect(function()
            if not Tab.Open then
                tabButton.BackgroundTransparency = 0.9
                icon.ImageColor3 = CurrentTheme.Text
                name.TextColor3 = CurrentTheme.Text
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if not Tab.Open then
                tabButton.BackgroundTransparency = 1
                icon.ImageColor3 = CurrentTheme.TextSecondary
                name.TextColor3 = CurrentTheme.TextSecondary
            end
        end)
        
        table.insert(Window.Tabs, Tab)
        
        -- Auto-select first tab if it's not the theme tab (which we don't create automatically anymore)
        if #Window.Tabs == 1 then
            Tab:Turn(true)
        end
        
        function Tab:Section(Properties)
            if not Properties then Properties = {} end
            
            local Section = {
                Name = Properties.Name or "Section",
                Tab = self,
                ShowTitle = Properties.ShowTitle ~= false,
                Elements = {},
                Frame = nil,
            }
            
            -- Section frame with proper padding
            local section = Library.CreateInstance("Frame", {
                Name = "Section_" .. Section.Name,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = CurrentTheme.Element,
                BackgroundTransparency = 0,
                BorderSizePixel = 0,
                Size = Library.UDim2(1, 0, 0, 0),
                Parent = tabContent,
            })
            
            Section.Frame = section
            
            Library.CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, IsMobile and 14 or 12),
                Parent = section,
            })
            
            Library.CreateInstance("UIStroke", {
                Color = CurrentTheme.Border,
                Transparency = 0.5,
                Thickness = 1,
                Parent = section,
            })
            
            -- Main padding for the entire section - COMPACT BUT CLEAN
            Library.CreateInstance("UIPadding", {
                PaddingTop = UDim.new(0, IsMobile and 11 or 9),
                PaddingLeft = UDim.new(0, IsMobile and 16 or 14),
                PaddingRight = UDim.new(0, IsMobile and 16 or 14),
                PaddingBottom = UDim.new(0, IsMobile and 16 or 14),
                Parent = section,
            })
            
            -- Section title with proper spacing
            if Section.ShowTitle then
                local title = Library.CreateInstance("TextLabel", {
                    Text = Section.Name,
                    Font = Enum.Font.GothamSemibold,
                    TextColor3 = CurrentTheme.Text,
                    TextSize = IsMobile and 18 or 16,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Size = Library.UDim2(1, 0, 0, IsMobile and 28 or 24),
                    LayoutOrder = 0,
                    Parent = section,
                    Position = UDim2.new(0, 0, 0, IsMobile and -2 or -3),
                })
                
                
                Section.Elements.Title = title
            end
            
            -- Content holder with proper internal padding
            local contentHolder = Library.CreateInstance("Frame", {
                Name = "ContentHolder",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = Library.UDim2(1, 0, 0, 0),
                LayoutOrder = 1,
                Parent = section,
            })
            
            -- Vertical spacing between elements - COMPACT
            local holderLayout = Library.CreateInstance("UIListLayout", {
                Padding = UDim.new(0, IsMobile and 10 or 8),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = contentHolder,
            })
            
            -- Ensure content holder respects parent padding
            Library.CreateInstance("UIPadding", {
                PaddingTop = UDim.new(0, IsMobile and -5 or -5),  -- Negative value moves it up
                PaddingBottom = UDim.new(0, 0),
                Parent = contentHolder,
            })
            
            -- Toggle Element - COMPACT
            function Section:Toggle(Properties)
                if not Properties then Properties = {} end
                
                local Toggle = {
                    Name = Properties.Name or "Toggle",
                    Default = false,
                    Callback = Properties.Callback or function() end,
                    Value = false,
                    Frame = nil,
                }
                
                local frame = Library.CreateInstance("Frame", {
                    Name = "Toggle_" .. Toggle.Name,
                    BackgroundTransparency = 1,
                    Size = Library.UDim2(1, 0, 0, IsMobile and 36 or 30),
                    Parent = contentHolder,
                })
                
                Toggle.Frame = frame
                
                -- Label with proper width
                local label = Library.CreateInstance("TextLabel", {
                    Text = Toggle.Name,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = CurrentTheme.TextSecondary,
                    TextSize = IsMobile and 15 or 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Position = Library.UDim2(0, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = Library.UDim2(1, -(IsMobile and 70 or 60), 0, IsMobile and 22 or 18),
                    Parent = frame,
                    ClipsDescendants = true,
                })
                
                -- Toggle button
                local button = Library.CreateInstance("TextButton", {
                    Name = "ToggleButton",
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = CurrentTheme.Element,
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    Position = Library.UDim2(1, 0, 0.5, 0),
                    Size = Library.UDim2(0, IsMobile and 55 or 48, 0, IsMobile and 26 or 22),
                    Parent = frame,
                })
                
                Library.CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = button,
                })
                
                local knob = Library.CreateInstance("Frame", {
                    Name = "Knob",
                    BackgroundColor3 = CurrentTheme.Text,
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    Position = Library.UDim2(0, IsMobile and 4 or 3, 0.5, 0),
                    Size = Library.UDim2(0, IsMobile and 20 or 16, 0, IsMobile and 20 or 16),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Parent = button,
                })
                
                Library.CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = knob,
                })
                
                function Toggle:UpdateTheme(theme)
                    label.TextColor3 = theme.TextSecondary
                    if Toggle.Value then
                        button.BackgroundColor3 = theme.Accent
                    else
                        button.BackgroundColor3 = theme.Element
                    end
                    knob.BackgroundColor3 = theme.Text
                end
                
                button.MouseButton1Click:Connect(function()
                    Toggle.Value = not Toggle.Value
                    
                    if Toggle.Value then
                        knob:TweenPosition(UDim2.new(1, -(IsMobile and 24 or 19), 0.5, 0), "Out", "Quad", 0.2, true)
                        button.BackgroundColor3 = CurrentTheme.Accent
                    else
                        knob:TweenPosition(UDim2.new(0, IsMobile and 4 or 3, 0.5, 0), "Out", "Quad", 0.2, true)
                        button.BackgroundColor3 = CurrentTheme.Element
                    end
                    
                    pcall(Toggle.Callback, Toggle.Value)
                end)
                
                function Toggle:Set(value)
                    if Toggle.Value ~= value then
                        button.MouseButton1Click:Fire()
                    end
                end
                
                function Toggle:GetValue()
                    return Toggle.Value
                end
                
                table.insert(Window.AllElements, Toggle)
                return Toggle
            end
            
            -- Button Element - COMPACT
            function Section:Button(Properties)
                if not Properties then Properties = {} end
                
                local Button = {
                    Name = Properties.Name or "Button",
                    Callback = Properties.Callback or function() end,
                    Frame = nil,
                }
                
                local button = Library.CreateInstance("TextButton", {
                    Name = "Button_" .. Button.Name,
                    Text = Button.Name,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = CurrentTheme.Text,
                    TextSize = IsMobile and 15 or 13,
                    AutoButtonColor = false,
                    BackgroundColor3 = CurrentTheme.Element,
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    Size = Library.UDim2(1, 0, 0, IsMobile and 40 or 34),
                    Parent = contentHolder,
                })
                
                Button.Frame = button
                
                Library.CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, IsMobile and 10 or 8),
                    Parent = button,
                })
                
                function Button:UpdateTheme(theme)
                    button.BackgroundColor3 = theme.Element
                    button.TextColor3 = theme.Text
                end
                
                button.MouseButton1Click:Connect(function()
                    button:TweenSize(UDim2.new(1, -4, 0, (IsMobile and 40 or 34) - 4), "Out", "Quad", 0.1, true)
                    task.wait(0.1)
                    button:TweenSize(UDim2.new(1, 0, 0, IsMobile and 40 or 34), "Out", "Quad", 0.1, true)
                    pcall(Button.Callback)
                end)
                
                button.MouseEnter:Connect(function()
                    button.BackgroundColor3 = CurrentTheme.ElementHover
                end)
                
                button.MouseLeave:Connect(function()
                    button.BackgroundColor3 = CurrentTheme.Element
                end)
                
                table.insert(Window.AllElements, Button)
                return Button
            end
            
            -- Slider Element - COMPACT
            function Section:Slider(Properties)
                if not Properties then Properties = {} end
                
                local Slider = {
                    Name = Properties.Name or "Slider",
                    Min = Properties.Min or 0,
                    Max = Properties.Max or 100,
                    Default = Properties.Min or 0,
                    Decimals = Properties.Decimals or 0,
                    Suffix = Properties.Suffix or "",
                    Callback = Properties.Callback or function() end,
                    Value = Properties.Min or 0,
                    Dragging = false,
                    Frame = nil,
                }
                
                local frame = Library.CreateInstance("Frame", {
                    Name = "Slider_" .. Slider.Name,
                    BackgroundTransparency = 1,
                    Size = Library.UDim2(1, 0, 0, IsMobile and 58 or 48),
                    Parent = contentHolder,
                })
                
                Slider.Frame = frame
                
                -- Label
                local label = Library.CreateInstance("TextLabel", {
                    Name = "SliderLabel",
                    Text = Slider.Name,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = CurrentTheme.TextSecondary,
                    TextSize = IsMobile and 15 or 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Position = Library.UDim2(0, 0, 0, 0),
                    Size = Library.UDim2(1, -80, 0, IsMobile and 24 or 20),
                    Parent = frame,
                    ClipsDescendants = true,
                })
                
                -- Value label
                local valueLabel = Library.CreateInstance("TextLabel", {
                    Name = "ValueLabel",
                    Font = Enum.Font.GothamMedium,
                    Text = tostring(Slider.Default) .. Slider.Suffix,
                    TextColor3 = CurrentTheme.Accent,
                    TextSize = IsMobile and 14 or 12,
                    BackgroundTransparency = 1,
                    Position = Library.UDim2(1, 0, 0, 0),
                    AnchorPoint = Vector2.new(1, 0),
                    Size = Library.UDim2(0, 70, 0, IsMobile and 24 or 20),
                    Parent = frame,
                })
                
                -- Slider bar
                local barBg = Library.CreateInstance("Frame", {
                    Name = "BarBackground",
                    BackgroundColor3 = CurrentTheme.Element,
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    Position = Library.UDim2(0, 0, 0, IsMobile and 32 or 28),
                    Size = Library.UDim2(1, 0, 0, IsMobile and 8 or 6),
                    Parent = frame,
                })
                
                Library.CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, IsMobile and 4 or 3),
                    Parent = barBg,
                })
                
                local bar = Library.CreateInstance("Frame", {
                    Name = "Bar",
                    BackgroundColor3 = CurrentTheme.Accent,
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    Size = Library.UDim2(0, 0, 1, 0),
                    Parent = barBg,
                })
                
                Library.CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, IsMobile and 4 or 3),
                    Parent = bar,
                })
                
                function Slider:UpdateTheme(theme)
                    label.TextColor3 = theme.TextSecondary
                    valueLabel.TextColor3 = theme.Accent
                    barBg.BackgroundColor3 = theme.Element
                    bar.BackgroundColor3 = theme.Accent
                end
                
                local format = "%." .. Slider.Decimals .. "f"
                
                local function SetValue(value)
                    local power = 10 ^ Slider.Decimals
                    value = math.floor((value * power) + 0.5) / power
                    value = math.clamp(value, Slider.Min, Slider.Max)
                    
                    Slider.Value = value
                    local percent = (value - Slider.Min) / (Slider.Max - Slider.Min)
                    
                    bar:TweenSize(UDim2.new(percent, 0, 1, 0), "Out", "Quad", 0.1, true)
                    valueLabel.Text = string.format(format, value) .. Slider.Suffix
                    pcall(Slider.Callback, value)
                end
                
                local function handleInput(input)
                    local pos = input.Position
                    local barPos = barBg.AbsolutePosition
                    local barSize = barBg.AbsoluteSize.X
                    
                    local percent = math.clamp((pos.X - barPos.X) / barSize, 0, 1)
                    local value = Slider.Min + (Slider.Max - Slider.Min) * percent
                    SetValue(value)
                end
                
                barBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Slider.Dragging = true
                        handleInput(input)
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if Slider.Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        handleInput(input)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Slider.Dragging = false
                    end
                end)
                
                SetValue(Slider.Default)
                
                function Slider:Set(value)
                    SetValue(value)
                end
                
                function Slider:GetValue()
                    return Slider.Value
                end
                
                table.insert(Window.AllElements, Slider)
                return Slider
            end
            
            -- Dropdown Element - FIXED TEXT TRUNCATION
            function Section:Dropdown(Properties)
                if not Properties then Properties = {} end
                
                local Dropdown = {
                    Name = Properties.Name or "Dropdown",
                    Options = Properties.Options or {},
                    Default = nil,
                    MultiSelect = Properties.MultiSelect or false,
                    Callback = Properties.Callback or function() end,
                    Searchable = Properties.Searchable ~= false,
                    isOpen = false,
                    SelectedOptions = {},
                    id = math.random(1, 999999),
                    Frame = nil,
                }
                
                if Dropdown.MultiSelect then
                    Dropdown.Value = {}
                else
                    Dropdown.Value = nil
                end
                
                local frame = Library.CreateInstance("Frame", {
                    Name = "Dropdown_" .. Dropdown.Name,
                    BackgroundTransparency = 1,
                    Size = Library.UDim2(1, 0, 0, IsMobile and 42 or 36),
                    Parent = contentHolder,
                })
                
                Dropdown.Frame = frame
                
                -- Label
                local label = Library.CreateInstance("TextLabel", {
                    Text = Dropdown.Name,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = CurrentTheme.TextSecondary,
                    TextSize = IsMobile and 15 or 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Position = Library.UDim2(0, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = Library.UDim2(1, -(IsMobile and 180 or 160), 0, IsMobile and 22 or 18),
                    Parent = frame,
                    ClipsDescendants = true,
                })
                
                -- Dropdown button
                local button = Library.CreateInstance("TextButton", {
                    Name = "DropdownButton",
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = CurrentTheme.Element,
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    Position = Library.UDim2(1, 0, 0.5, 0),
                    Size = Library.UDim2(0, IsMobile and 170 or 150, 0, IsMobile and 32 or 28),
                    ZIndex = 10,
                    Parent = frame,
                })
                
                Library.CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, IsMobile and 8 or 6),
                    Parent = button,
                })
                
                -- Selected text with truncation
                local selectedText = Library.CreateInstance("TextLabel", {
                    Name = "SelectedText",
                    Font = Enum.Font.Gotham,
                    Text = "Select...",
                    TextColor3 = CurrentTheme.TextMuted,
                    TextSize = IsMobile and 14 or 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Position = Library.UDim2(0, IsMobile and 10 or 8, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = Library.UDim2(1, -(IsMobile and 35 or 30), 1, -4),
                    ZIndex = 11,
                    Parent = button,
                    ClipsDescendants = true,
                })
                
                -- Arrow icon
                local arrow = Library.CreateInstance("ImageLabel", {
                    Name = "Arrow",
                    Image = "rbxassetid://115894980866040",
                    ImageColor3 = CurrentTheme.TextMuted,
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundTransparency = 1,
                    Position = Library.UDim2(1, -IsMobile and 10 or 8, 0.5, 0),
                    Size = Library.UDim2(0, IsMobile and 16 or 14, 0, IsMobile and 16 or 14),
                    ZIndex = 11,
                    Parent = button,
                })
                
                function Dropdown:UpdateTheme(theme)
                    label.TextColor3 = theme.TextSecondary
                    button.BackgroundColor3 = theme.Element
                    if Dropdown.Value then
                        selectedText.TextColor3 = theme.Text
                    else
                        selectedText.TextColor3 = theme.TextMuted
                    end
                    arrow.ImageColor3 = theme.TextMuted
                end
                
                -- Text truncation function
                local function truncateText(text, maxLength)
                    if #text > maxLength then
                        return text:sub(1, maxLength - 3) .. "..."
                    end
                    return text
                end
                
                local function updateSelectedText()
                    if Dropdown.MultiSelect then
                        local count = 0
                        for _ in pairs(Dropdown.SelectedOptions) do count = count + 1 end
                        if count == 0 then
                            selectedText.Text = "Select..."
                            selectedText.TextColor3 = CurrentTheme.TextMuted
                        elseif count == 1 then
                            for opt,_ in pairs(Dropdown.SelectedOptions) do
                                selectedText.Text = truncateText(opt, IsMobile and 14 or 12)
                                selectedText.TextColor3 = CurrentTheme.Text
                                break
                            end
                        else
                            selectedText.Text = count .. " selected"
                            selectedText.TextColor3 = CurrentTheme.Text
                        end
                    else
                        if Dropdown.Value then
                            selectedText.Text = truncateText(tostring(Dropdown.Value), IsMobile and 14 or 12)
                            selectedText.TextColor3 = CurrentTheme.Text
                        else
                            selectedText.Text = "Select..."
                            selectedText.TextColor3 = CurrentTheme.TextMuted
                        end
                    end
                end
                
                local overlay
                local optionsFrame
                local optionsContainer
                local searchBox
                
                local function createOverlay()
                    overlay = Instance.new("ScreenGui")
                    overlay.Name = "DropdownOverlay_" .. Dropdown.id
                    overlay.ResetOnSpawn = false
                    overlay.ZIndexBehavior = Enum.ZIndexBehavior.Global
                    overlay.DisplayOrder = 999
                    overlay.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
                    
                    optionsFrame = Library.CreateInstance("Frame", {
                        Name = "OptionsFrame",
                        BackgroundColor3 = CurrentTheme.Element,
                        BackgroundTransparency = 0,
                        BorderSizePixel = 0,
                        Size = Library.UDim2(0, IsMobile and 180 or 160, 0, 0),
                        Visible = false,
                        Parent = overlay,
                    })
                    
                    optionsFrame.ZIndex = 9999
                    
                    Library.CreateInstance("UICorner", {
                        CornerRadius = UDim.new(0, IsMobile and 10 or 8),
                        Parent = optionsFrame,
                    })
                    
                    Library.CreateInstance("UIStroke", {
                        Color = CurrentTheme.Accent,
                        Transparency = 0.3,
                        Thickness = 1,
                        Parent = optionsFrame,
                    })
                    
                    local yPos = IsMobile and 8 or 5
                    if Dropdown.Searchable then
                        searchBox = Library.CreateInstance("TextBox", {
                            Name = "SearchBox",
                            Font = Enum.Font.Gotham,
                            PlaceholderText = "Search...",
                            PlaceholderColor3 = CurrentTheme.TextMuted,
                            Text = "",
                            TextColor3 = CurrentTheme.Text,
                            TextSize = IsMobile and 14 or 12,
                            BackgroundColor3 = CurrentTheme.ElementHover,
                            BackgroundTransparency = 0,
                            BorderSizePixel = 0,
                            Size = Library.UDim2(1, -16, 0, IsMobile and 32 or 26),
                            Position = Library.UDim2(0, 8, 0, IsMobile and 8 or 5),
                            Parent = optionsFrame,
                            ClearTextOnFocus = false,
                        })
                        
                        searchBox.ZIndex = 9999
                        
                        Library.CreateInstance("UICorner", {
                            CornerRadius = UDim.new(0, IsMobile and 8 or 6),
                            Parent = searchBox,
                        })
                        
                        yPos = IsMobile and 48 or 36
                    end
                    
                    optionsContainer = Library.CreateInstance("ScrollingFrame", {
                        Name = "OptionsContainer",
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        ScrollBarImageColor3 = CurrentTheme.Accent,
                        ScrollBarThickness = IsMobile and 4 or 3,
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Size = Library.UDim2(1, -16, 0, 0),
                        Position = Library.UDim2(0, 8, 0, yPos),
                        Parent = optionsFrame,
                    })
                    
                    optionsContainer.ZIndex = 9999
                    
                    local layout = Library.CreateInstance("UIListLayout", {
                        Padding = UDim.new(0, 2),
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Parent = optionsContainer,
                    })
                    
                    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                        pcall(function()
                            optionsContainer.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
                        end)
                    end)
                end
                
                local function updateOptions()
                    if not optionsContainer then createOverlay() end
                    
                    for _, child in pairs(optionsContainer:GetChildren()) do
                        if child:IsA("TextButton") then child:Destroy() end
                    end
                    
                    local filtered = Dropdown.Options
                    if Dropdown.Searchable and searchBox and searchBox.Text ~= "" then
                        local term = searchBox.Text:lower()
                        filtered = {}
                        for _, opt in ipairs(Dropdown.Options) do
                            if opt:lower():find(term, 1, true) then
                                table.insert(filtered, opt)
                            end
                        end
                    end
                    
                    local maxHeight = IsMobile and 250 or 200
                    local yStart = Dropdown.Searchable and (IsMobile and 48 or 36) or (IsMobile and 8 or 5)
                    local optHeight = IsMobile and 34 or 26
                    local totalHeight = #filtered * optHeight + 2
                    
                    if totalHeight > maxHeight - yStart - 10 then
                        optionsContainer.Size = Library.UDim2(1, 0, 0, maxHeight - yStart - 10)
                    else
                        optionsContainer.Size = Library.UDim2(1, 0, 0, totalHeight)
                    end
                    
                    optionsFrame.Size = Library.UDim2(0, IsMobile and 180 or 160, 0, yStart + optionsContainer.Size.Y.Offset + (IsMobile and 8 or 5))
                    
                    for _, option in ipairs(filtered) do
                        local optButton = Library.CreateInstance("TextButton", {
                            Text = option,
                            Font = Enum.Font.Gotham,
                            TextColor3 = CurrentTheme.TextSecondary,
                            TextSize = IsMobile and 14 or 12,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            BackgroundColor3 = CurrentTheme.ElementHover,
                            BackgroundTransparency = 1,
                            BorderSizePixel = 0,
                            Size = Library.UDim2(1, 0, 0, optHeight - 2),
                            Parent = optionsContainer,
                            ZIndex = 9999,
                        })
                        
                        Library.CreateInstance("UICorner", {
                            CornerRadius = UDim.new(0, IsMobile and 6 or 4),
                            Parent = optButton,
                        })
                        
                        Library.CreateInstance("UIPadding", {
                            PaddingLeft = UDim.new(0, IsMobile and 10 or 8),
                            PaddingRight = UDim.new(0, IsMobile and 10 or 8),
                            Parent = optButton,
                        })
                        
                        local selected = Dropdown.MultiSelect and Dropdown.SelectedOptions[option] or Dropdown.Value == option
                        if selected then
                            optButton.BackgroundTransparency = 0.7
                            optButton.TextColor3 = CurrentTheme.Accent
                        end
                        
                        optButton.MouseButton1Click:Connect(function()
                            if Dropdown.MultiSelect then
                                if Dropdown.SelectedOptions[option] then
                                    Dropdown.SelectedOptions[option] = nil
                                else
                                    Dropdown.SelectedOptions[option] = true
                                end
                                Dropdown.Value = {}
                                for opt,_ in pairs(Dropdown.SelectedOptions) do
                                    table.insert(Dropdown.Value, opt)
                                end
                            else
                                Dropdown.Value = option
                                Dropdown.SelectedOptions = { [option] = true }
                                closeDropdown()
                            end
                            
                            updateSelectedText()
                            pcall(Dropdown.Callback, Dropdown.Value)
                            updateOptions()
                        end)
                        
                        optButton.MouseEnter:Connect(function()
                            optButton.BackgroundTransparency = 0.3
                            optButton.TextColor3 = CurrentTheme.Text
                        end)
                        
                        optButton.MouseLeave:Connect(function()
                            local sel = Dropdown.MultiSelect and Dropdown.SelectedOptions[option] or Dropdown.Value == option
                            optButton.BackgroundTransparency = sel and 0.7 or 1
                            optButton.TextColor3 = sel and CurrentTheme.Accent or CurrentTheme.TextSecondary
                        end)
                    end
                end
                
                local function closeDropdown()
                    if Dropdown.isOpen then
                        Dropdown.isOpen = false
                        
                        if optionsFrame then
                            optionsFrame.Visible = false
                        end
                        
                        arrow.Rotation = 0
                        
                        ActiveDropdowns[Dropdown.id] = nil
                        
                        if overlay then
                            pcall(function() overlay:Destroy() end)
                            overlay = nil
                        end
                    end
                end
                
                local function openDropdown()
                    closeOtherDropdowns(Dropdown.id)
                    
                    Dropdown.isOpen = true
                    createOverlay()
                    updateOptions()
                    
                    if optionsFrame then
                        local btnPos = button.AbsolutePosition
                        local btnSize = button.AbsoluteSize
                        local screenSize = workspace.CurrentCamera.ViewportSize
                        
                        local yPos = btnPos.Y + btnSize.Y + 2
                        local height = optionsFrame.Size.Y.Offset
                        
                        if yPos + height > screenSize.Y then
                            yPos = btnPos.Y - height - 2
                        end
                        
                        optionsFrame.Position = UDim2.new(0, btnPos.X, 0, yPos)
                        optionsFrame.Visible = true
                        
                        arrow.Rotation = 180
                        
                        ActiveDropdowns[Dropdown.id] = { Close = closeDropdown }
                        
                        if Dropdown.Searchable and searchBox then
                            searchBox:GetPropertyChangedSignal("Text"):Connect(updateOptions)
                        end
                    end
                end
                
                button.MouseButton1Click:Connect(function()
                    if Dropdown.isOpen then closeDropdown() else openDropdown() end
                end)
                
                function Dropdown:Set(value)
                    if Dropdown.MultiSelect then
                        Dropdown.SelectedOptions = {}
                        Dropdown.Value = {}
                        if type(value) == "table" then
                            for _, opt in ipairs(value) do
                                Dropdown.SelectedOptions[opt] = true
                                table.insert(Dropdown.Value, opt)
                            end
                        end
                    else
                        Dropdown.Value = value
                        Dropdown.SelectedOptions = value and { [value] = true } or {}
                    end
                    updateSelectedText()
                    pcall(Dropdown.Callback, Dropdown.Value)
                end
                
                function Dropdown:GetValue()
                    return Dropdown.Value
                end
                
                function Dropdown:Refresh(newOptions, default)
                    Dropdown.Options = newOptions
                    if default then self:Set(default) end
                    if Dropdown.isOpen then updateOptions() end
                end
                
                table.insert(Window.AllElements, Dropdown)
                return Dropdown
            end
            
            -- Label Element - COMPACT
            function Section:Label(Properties)
                if not Properties then Properties = {} end
                
                local Label = {
                    Text = Properties.Text or "",
                    Frame = nil,
                }
                
                local label = Library.CreateInstance("TextLabel", {
                    Text = Label.Text,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = CurrentTheme.TextSecondary,
                    TextSize = IsMobile and 14 or 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Size = Library.UDim2(1, 0, 0, IsMobile and 24 or 20),
                    Parent = contentHolder,
                    ClipsDescendants = true,
                })
                
                Label.Frame = label
                
                function Label:UpdateTheme(theme)
                    label.TextColor3 = theme.TextSecondary
                end
                
                function Label:Set(text)
                    label.Text = text
                end
                
                table.insert(Window.AllElements, Label)
                return Label
            end
            
            return Section
        end
        
        return Tab
    end
    
    Window.Elements = {
        MainFrame = mainframe,
        MainHolder = mainHolder,
        Content = content,
        TabHolder = tabHolder,
        SearchInput = searchInput,
    }
    
    return Window
end

Library.Window = Library.CreateWindow
return Library
