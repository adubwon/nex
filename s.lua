-- Modern Roblox UI Library with Glassy Design
-- Author: Roblox Scripting Assistant

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Utility functions
function Library:CreateInstance(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        if prop ~= "Parent" then
            instance[prop] = value
        end
    end
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

Library.CreateInstance = function(self, className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        if prop ~= "Parent" then
            instance[prop] = value
        end
    end
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

function Library.GetScaledTextSize(size)
    return math.floor(size * 1.1)
end

function Library.UDim2(scaleX, offsetX, scaleY, offsetY)
    return UDim2.new(scaleX, offsetX, scaleY, offsetY)
end

function Library:IsMouseOverFrame(frame)
    if not frame then return false end
    local mouse = game.Players.LocalPlayer:GetMouse()
    local framePos = frame.AbsolutePosition
    local frameSize = frame.AbsoluteSize
    
    return mouse.X >= framePos.X and mouse.X <= framePos.X + frameSize.X and
           mouse.Y >= framePos.Y and mouse.Y <= framePos.Y + frameSize.Y
end

-- Main Window Creation
function Library:Window(Properties)
    if not Properties then Properties = {} end
    
    local Window = {
        Name = Properties.Name or "UI Library",
        Position = Properties.Position or UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Properties.AnchorPoint or Vector2.new(0.5, 0.5),
        Size = Properties.Size or UDim2.new(0, 670, 0, 415),
        Tabs = {},
        Minimized = false,
        Visible = true,
        CreateInstance = Library.CreateInstance, -- Add the method here
    }
    
    -- Main Frame with glass effect
    local mainframe = Library:CreateInstance("ScreenGui", {
        Name = "ModernUILibrary",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
    })
    
    local theholderdwbbg = Library:CreateInstance("Frame", {
        Name = "MainHolder",
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Position = Window.Position,
        AnchorPoint = Window.AnchorPoint,
        Size = Window.Size,
        Parent = mainframe,
    })
    
    -- Glass effect frame
    local glassFrame = Library:CreateInstance("Frame", {
        Name = "GlassFrame",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.9,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = theholderdwbbg,
    })
    
    -- Rounded corners
    local corner = Library:CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = theholderdwbbg,
    })
    
    local glassCorner = Library:CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = glassFrame,
    })
    
    -- Glass border
    local stroke = Library:CreateInstance("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 0.8,
        Thickness = 1,
        Parent = theholderdwbbg,
    })
    
    -- Drag functionality
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        theholderdwbbg.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
    
    theholderdwbbg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = theholderdwbbg.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    theholderdwbbg.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- Sidebar with search
    local sidebarHolder = Library:CreateInstance("Frame", {
        Name = "SidebarHolder",
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 150, 1, 0),
        Parent = theholderdwbbg,
    })
    
    local sidebarCorner = Library:CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12, 0, 0),
        Parent = sidebarHolder,
    })
    
    local sidebarGlass = Library:CreateInstance("Frame", {
        Name = "SidebarGlass",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.9,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = sidebarHolder,
    })
    
    local sidebarGlassCorner = Library:CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12, 0, 0),
        Parent = sidebarGlass,
    })
    
    -- Tab holder
    local anothersidebarholder = Library:CreateInstance("Frame", {
        Name = "TabHolder",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(1, 0, 1, -40),
        Parent = sidebarHolder,
    })
    
    local tabHolder = Library:CreateInstance("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = anothersidebarholder,
    })
    
    local tabListLayout = Library:CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tabHolder,
    })
    
    local tabPadding = Library:CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = tabHolder,
    })
    
    -- Search bar
    local search = Library:CreateInstance("Frame", {
        Name = "Search",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = 2,
        Size = Library.UDim2(1, 0, 0, 40),
        Parent = sidebarHolder,
    })
    
    local line = Library:CreateInstance("Frame", {
        Name = "line",
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Size = Library.UDim2(1, 0, 0, 1),
        Parent = search,
    })
    
    local line1 = Library:CreateInstance("Frame", {
        Name = "line",
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0, 1),
        Size = Library.UDim2(1, 0, 0, 1),
        Parent = search,
    })
    
    local searchzone = Library:CreateInstance("Frame", {
        Name = "searchzone",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(35, 35, 33),
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = Library.UDim2(1, -30, 0, 25),
    })
    
    local uICorner4 = Library:CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = searchzone,
    })
    
    local keyicon = Library:CreateInstance("ImageLabel", {
        Name = "Keyicon",
        Image = "rbxassetid://139032822388177",
        ImageColor3 = Color3.fromRGB(80, 80, 75),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -25, 0.5, 0),
        Size = UDim2.fromOffset(14, 14),
        Parent = searchzone,
    })
    
    local searchinput = Library:CreateInstance("TextBox", {
        Name = "TextBox",
        FontFace = Font.new("rbxassetid://12187365364"),
        PlaceholderText = "Search...",
        Text = "",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = Library.GetScaledTextSize(12),
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(9, 0),
        Size = Library.UDim2(1, -42, 1, 0),
        Parent = searchzone,
    })
    
    local uIStroke2 = Library:CreateInstance("UIStroke", {
        Color = Color3.fromRGB(45, 45, 45),
        Transparency = 0.6,
        Parent = searchzone,
    })
    
    searchzone.Parent = search
    search.Parent = anothersidebarholder
    
    anothersidebarholder.Parent = sidebarHolder
    
    -- Search functionality
    searchinput.Changed:Connect(function(property)
        if property == "Text" then
            local searchText = searchinput.Text:lower()
            
            if searchText == "" then
                for _, tab in pairs(Window.Tabs) do
                    tab.Elements.TabButton.Visible = true
                end
            else
                local visibleTabs = {}
                
                for _, tab in pairs(Window.Tabs) do
                    local tabName = tab.Name:lower()
                    local shouldShow = tabName:find(searchText, 1, true) ~= nil
                    tab.Elements.TabButton.Visible = shouldShow
                    
                    if shouldShow then
                        table.insert(visibleTabs, tab)
                    end
                end
                
                if #visibleTabs == 1 then
                    for _, tab in pairs(Window.Tabs) do
                        if tab.Open then
                            tab:Turn(false)
                        end
                    end
                    visibleTabs[1]:Turn(true)
                elseif #visibleTabs > 1 then
                    for _, tab in pairs(Window.Tabs) do
                        if tab.Open and not tab.Elements.TabButton.Visible then
                            tab:Turn(false)
                        end
                    end
                end
            end
        end
    end)
    
    searchinput.FocusLost:Connect(function()
        if searchinput.Text == "" then
            for _, tab in pairs(Window.Tabs) do
                tab.Elements.TabButton.Visible = true
            end
        end
    end)
    
    -- Sidebar border
    local line2 = Library:CreateInstance("Frame", {
        Name = "Line",
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Position = UDim2.fromScale(1, 0),
        Size = Library.UDim2(0, 1, 1, 0),
        Parent = sidebarHolder,
    })
    
    sidebarHolder.Parent = theholderdwbbg
    
    -- Content area
    local content = Library:CreateInstance("Frame", {
        Name = "content",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        LayoutOrder = 1,
        Size = Library.UDim2(1, -150, 1, 0),
        Parent = theholderdwbbg,
    })
    
    -- Window functions
    function Window.UpdateTabs(self)
        for _, tab in pairs(Window.Tabs) do
            tab:Turn(tab.Open)
        end
    end
    
    function Window.ToggleVisibility(self)
        Window.Visible = not Window.Visible
        theholderdwbbg.Visible = Window.Visible
    end
    
    Window.Elements = {
        MainFrame = mainframe,
        ContentArea = content,
        TabHolder = tabHolder,
        SearchInput = searchinput,
    }
    
    -- Add CreateInstance method to Window object
    Window.CreateInstance = Library.CreateInstance
    
    -- Initialize with first tab
    Window.DefaultTab = nil
    
    -- Set up metatable
    local windowMt = {}
    windowMt.__index = function(self, key)
        if key == "Tab" then
            return function(self, Properties)
                if not Properties then Properties = {} end
                
                local Tab = {
                    Name = Properties.Title or "Tab",
                    Icon = Properties.Icon,
                    Window = self,
                    Open = false,
                    Sections = {},
                    Elements = {},
                    CreateInstance = Library.CreateInstance, -- Add this
                }
                
                -- Tab button
                local atab = Library:CreateInstance("TextButton", {
                    Name = "TabButton",
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundColor3 = Color3.fromRGB(39, 39, 42),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = Library.UDim2(1, -20, 0, 29),
                    Parent = self.Elements.TabHolder,
                })
                
                local uICorner = Library:CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = atab,
                })
                
                local uIStroke = Library:CreateInstance("UIStroke", {
                    Color = Color3.fromRGB(31, 31, 34),
                    Enabled = false,
                    Parent = atab,
                })
                
                local tabContent = Library:CreateInstance("ScrollingFrame", {
                    Name = "TabContent_" .. Tab.Name,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.fromOffset(10, 1),
                    Size = Library.UDim2(1, -20, 1.02, -10),
                    Visible = false,
                    Parent = self.Elements.ContentArea,
                })
                
                local tabLayout = Library:CreateInstance("UIListLayout", {
                    Padding = UDim.new(0, 16),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = tabContent,
                })
                
                local tabPadding = Library:CreateInstance("UIPadding", {
                    PaddingTop = UDim.new(0, 12),
                    Parent = tabContent,
                })
                
                local tabIcon
                if Tab.Icon then
                    tabIcon = Library:CreateInstance("ImageLabel", {
                        Image = Tab.Icon,
                        ImageColor3 = Color3.fromRGB(115, 115, 115),
                        BackgroundTransparency = 1,
                        Size = UDim2.fromOffset(12, 12),
                        LayoutOrder = 1,
                        Parent = atab,
                    })
                end
                
                local tabName = Library:CreateInstance("TextLabel", {
                    Text = Tab.Name,
                    FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
                    TextColor3 = Color3.fromRGB(115, 115, 115),
                    TextSize = Library.GetScaledTextSize(12),
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.X,
                    Size = UDim2.fromScale(0, 1),
                    LayoutOrder = 2,
                    Parent = atab,
                })
                
                local tabInnerLayout = Library:CreateInstance("UIListLayout", {
                    Padding = UDim.new(0, 10),
                    FillDirection = Enum.FillDirection.Horizontal,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Parent = atab,
                })
                
                local tabInnerPadding = Library:CreateInstance("UIPadding", {
                    PaddingLeft = UDim.new(0, 8),
                    Parent = atab,
                })
                
                -- Tab functions
                function Tab.Turn(self, bool)
                    Tab.Open = bool
                    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    
                    if bool then
                        TweenService:Create(atab, tweenInfo, {
                            BackgroundTransparency = 0.7,
                        }):Play()
                        
                        uIStroke.Enabled = true
                        
                        if tabIcon then
                            TweenService:Create(tabIcon, tweenInfo, {
                                ImageColor3 = Color3.fromRGB(255, 255, 255),
                            }):Play()
                        end
                        
                        TweenService:Create(tabName, tweenInfo, {
                            TextColor3 = Color3.fromRGB(235, 235, 235),
                        }):Play()
                        
                        tabContent.Visible = true
                    else
                        TweenService:Create(atab, tweenInfo, {
                            BackgroundTransparency = 1,
                        }):Play()
                        
                        uIStroke.Enabled = false
                        
                        if tabIcon then
                            TweenService:Create(tabIcon, tweenInfo, {
                                ImageColor3 = Color3.fromRGB(115, 115, 115),
                            }):Play()
                        end
                        
                        TweenService:Create(tabName, tweenInfo, {
                            TextColor3 = Color3.fromRGB(115, 115, 115),
                        }):Play()
                        
                        tabContent.Visible = false
                    end
                end
                
                atab.MouseButton1Click:Connect(function()
                    if not Tab.Open then
                        for _, otherTab in pairs(Tab.Window.Tabs) do
                            if otherTab.Open and otherTab ~= Tab then
                                otherTab:Turn(false)
                            end
                        end
                        Tab:Turn(true)
                    end
                end)
                
                atab.MouseEnter:Connect(function()
                    if not Tab.Open then
                        TweenService:Create(atab, TweenInfo.new(0.15), {
                            BackgroundTransparency = 0.85,
                        }):Play()
                    end
                end)
                
                atab.MouseLeave:Connect(function()
                    if not Tab.Open then
                        TweenService:Create(atab, TweenInfo.new(0.15), {
                            BackgroundTransparency = 1,
                        }):Play()
                    end
                end)
                
                Tab.Elements = {
                    TabButton = atab,
                    Content = tabContent,
                    TabIcon = tabIcon,
                    TabName = tabName,
                }
                
                -- Set up section method for this tab
                function Tab.Section(self, Properties)
                    if not Properties then Properties = {} end
                    
                    local Section = {
                        Name = Properties.Name or "Section",
                        Tab = self,
                        Side = Properties.Side or "Left",
                        Elements = {},
                        Content = {},
                        ShowTitle = Properties.ShowTitle ~= false,
                        CreateInstance = Library.CreateInstance, -- Add this
                    }
                    
                    -- Create side containers if they don't exist
                    if not self.Elements[Section.Side] then
                        local sideContainer = Library:CreateInstance("Frame", {
                            Name = Section.Side .. "Container",
                            AutomaticSize = Enum.AutomaticSize.Y,
                            BackgroundTransparency = 1,
                            BorderSizePixel = 0,
                            Size = UDim2.fromScale(1, 0),
                            LayoutOrder = Section.Side == "Left" and 1 or 2,
                            Parent = self.Elements.Content,
                        })
                        
                        local sideLayout = Library:CreateInstance("UIListLayout", {
                            Padding = UDim.new(0, 13),
                            SortOrder = Enum.SortOrder.LayoutOrder,
                            Parent = sideContainer,
                        })
                        
                        self.Elements[Section.Side] = sideContainer
                    end
                    
                    -- Section frame
                    local section = Library:CreateInstance("Frame", {
                        Name = "Section",
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundColor3 = Color3.fromRGB(17, 17, 17),
                        BackgroundTransparency = 0.4,
                        BorderSizePixel = 0,
                        Size = Library.UDim2(1, 0, 0, 0),
                        Parent = self.Elements[Section.Side],
                    })
                    
                    local uICorner = Library:CreateInstance("UICorner", {
                        CornerRadius = UDim.new(0, 6),
                        Parent = section,
                    })
                    
                    local uIStroke = Library:CreateInstance("UIStroke", {
                        Color = Color3.fromRGB(45, 45, 45),
                        Transparency = 0.4,
                        Parent = section,
                    })
                    
                    local sectionLayout = Library:CreateInstance("UIListLayout", {
                        Padding = UDim.new(0, 8),
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Parent = section,
                    })
                    
                    local sectionPadding = Library:CreateInstance("UIPadding", {
                        PaddingTop = UDim.new(0, 5),
                        PaddingBottom = UDim.new(0, 12),
                        Parent = section,
                    })
                    
                    -- Title
                    if Section.ShowTitle then
                        local titleFrame = Library:CreateInstance("Frame", {
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1, 0, 0, 22),
                            LayoutOrder = 0,
                            Parent = section,
                        })
                        
                        local title = Library:CreateInstance("TextLabel", {
                            Text = Section.Name,
                            FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
                            TextColor3 = Color3.fromRGB(221, 221, 221),
                            TextSize = Library.GetScaledTextSize(14),
                            TextXAlignment = Enum.TextXAlignment.Left,
                            BackgroundTransparency = 1,
                            Position = UDim2.fromOffset(8, 0),
                            Size = UDim2.new(1, -16, 0, 25),
                            Parent = titleFrame,
                        })
                        
                        Section.Elements.Title = title
                    end
                    
                    -- Content container
                    local aholder = Library:CreateInstance("Frame", {
                        Name = "ContentHolder",
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, 0, 0, 0),
                        LayoutOrder = 1,
                        Parent = section,
                    })
                    
                    local contentLayout = Library:CreateInstance("UIListLayout", {
                        Padding = UDim.new(0, 8),
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Parent = aholder,
                    })
                    
                    local contentPadding = Library:CreateInstance("UIPadding", {
                        PaddingLeft = UDim.new(0, 3),
                        PaddingRight = UDim.new(0, 3),
                        PaddingTop = UDim.new(0, 3),
                        PaddingBottom = UDim.new(0, 3),
                        Parent = aholder,
                    })
                    
                    Section.Elements.SectionFrame = section
                    Section.Elements.SectionContent = aholder
                    
                    -- Add component methods to section
                    function Section.Toggle(self, Properties)
                        return Library.Sections.Toggle(Section, Properties)
                    end
                    
                    function Section.Dropdown(self, Properties)
                        return Library.Sections.Dropdown(Section, Properties)
                    end
                    
                    return Section
                end
                
                table.insert(self.Tabs, Tab)
                
                if #self.Tabs == 1 then
                    Tab:Turn(true)
                end
                
                return Tab
            end
        end
        return rawget(self, key) or Library[key]
    end
    
    setmetatable(Window, windowMt)
    return Window
end

-- Section methods
Library.Sections = {}

function Library.Sections.Toggle(section, Properties)
    if not Properties then Properties = {} end
    
    local Toggle = {
        Name = Properties.Name or "Toggle",
        Default = Properties.Default or false,
        Flag = Properties.Flag or "Toggle_" .. math.random(1, 10000),
        Callback = Properties.Callback or function() end,
        Value = Properties.Default or false,
        Elements = {},
    }
    
    local toggle = Library:CreateInstance("Frame", {
        Name = "Toggle",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 25),
        Parent = section.Elements.SectionContent,
    })
    
    local toggleLabel = Library:CreateInstance("TextLabel", {
        Text = Toggle.Name,
        FontFace = Font.new("rbxassetid://12187365364"),
        TextColor3 = Color3.fromRGB(115, 115, 115),
        TextSize = Library.GetScaledTextSize(12),
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 2),
        Size = UDim2.new(1, -50, 1, 0),
        Parent = toggle,
    })
    
    -- Toggle button with glass effect
    local toggleButton = Library:CreateInstance("TextButton", {
        Name = "ToggleButton",
        Text = "",
        AutoButtonColor = false,
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -8, 0, 2),
        Size = UDim2.new(0, 36, 0, 21),
        Parent = toggle,
    })
    
    -- Glass effect
    local glassFrame = Library:CreateInstance("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.9,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = toggleButton,
    })
    
    -- Rounded corners
    local toggleCorner = Library:CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = toggleButton,
    })
    
    local glassCorner = Library:CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = glassFrame,
    })
    
    -- Glass border
    local glassStroke = Library:CreateInstance("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 0.8,
        Thickness = 1,
        Parent = toggleButton,
    })
    
    -- Toggle knob (circle that moves)
    local toggleKnob = Library:CreateInstance("Frame", {
        Name = "ToggleKnob",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 2, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16),
        AnchorPoint = Vector2.new(0, 0.5),
        Parent = toggleButton,
    })
    
    -- Knob corner
    local knobCorner = Library:CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = toggleKnob,
    })
    
    -- Knob glass
    local knobGlass = Library:CreateInstance("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = toggleKnob,
    })
    
    local knobGlassCorner = Library:CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = knobGlass,
    })
    
    -- Check mark (appears when toggled on)
    local checkMark = Library:CreateInstance("ImageLabel", {
        Image = "rbxassetid://7072706620",
        ImageColor3 = Color3.fromRGB(0, 255, 100),
        ImageTransparency = 1,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -5, 0.5, 0),
        Size = UDim2.new(0, 14, 0, 14),
        Parent = toggleButton,
    })
    
    -- Outer glow for on state
    local outerGlow = Library:CreateInstance("Frame", {
        Name = "OuterGlow",
        BackgroundColor3 = Color3.fromRGB(100, 100, 255),
        BackgroundTransparency = 0.9,
        BorderSizePixel = 0,
        Position = UDim2.new(-0.05, 0, -0.05, 0),
        Size = UDim2.new(1.1, 0, 1.1, 0),
        ZIndex = -1,
        Visible = false,
        Parent = toggleButton,
    })
    
    local glowCorner = Library:CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = outerGlow,
    })
    
    -- Set initial state
    if Toggle.Value then
        toggleKnob.Position = UDim2.new(1, -19, 0.5, -8)
        checkMark.ImageTransparency = 0
        glassStroke.Color = Color3.fromRGB(100, 100, 255)
        toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        outerGlow.Visible = true
    end
    
    -- Hover effects
    toggleButton.MouseEnter:Connect(function()
        if not Toggle.Value then
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
            }):Play()
        end
    end)
    
    toggleButton.MouseLeave:Connect(function()
        if not Toggle.Value then
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            }):Play()
        end
    end)
    
    -- Toggle functionality
    toggleButton.MouseButton1Click:Connect(function()
        Toggle.Value = not Toggle.Value
        
        if Toggle.Value then
            -- Move knob to right
            TweenService:Create(toggleKnob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -19, 0.5, -8),
            }):Play()
            
            -- Show check mark
            TweenService:Create(checkMark, TweenInfo.new(0.2), {
                ImageTransparency = 0,
            }):Play()
            
            -- Change border color
            TweenService:Create(glassStroke, TweenInfo.new(0.2), {
                Color = Color3.fromRGB(100, 100, 255),
            }):Play()
            
            -- Darken background
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 60),
            }):Play()
            
            -- Show outer glow
            outerGlow.Visible = true
        else
            -- Move knob to left
            TweenService:Create(toggleKnob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 2, 0.5, -8),
            }):Play()
            
            -- Hide check mark
            TweenService:Create(checkMark, TweenInfo.new(0.2), {
                ImageTransparency = 1,
            }):Play()
            
            -- Restore border color
            TweenService:Create(glassStroke, TweenInfo.new(0.2), {
                Color = Color3.fromRGB(255, 255, 255),
            }):Play()
            
            -- Restore background
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            }):Play()
            
            -- Hide outer glow
            outerGlow.Visible = false
        end
        
        -- Callback
        Toggle.Callback(Toggle.Value)
    end)
    
    -- Label hover
    toggle.MouseEnter:Connect(function()
        TweenService:Create(toggleLabel, TweenInfo.new(0.15), {
            TextColor3 = Color3.fromRGB(255, 255, 255),
        }):Play()
    end)
    
    toggle.MouseLeave:Connect(function()
        TweenService:Create(toggleLabel, TweenInfo.new(0.15), {
            TextColor3 = Color3.fromRGB(115, 115, 115),
        }):Play()
    end)
    
    -- Toggle methods
    function Toggle.Set(self, value)
        if Toggle.Value ~= value then
            toggleButton.MouseButton1Click:Fire()
        end
    end
    
    function Toggle.GetValue(self)
        return Toggle.Value
    end
    
    Toggle.Elements = {
        Frame = toggle,
        Button = toggleButton,
        Label = toggleLabel,
        Knob = toggleKnob,
    }
    
    return Toggle
end

function Library.Sections.Dropdown(section, Properties)
    if not Properties then Properties = {} end
    
    local Dropdown = {
        Name = Properties.Name or "Dropdown",
        Options = Properties.Options or {},
        Default = Properties.Default,
        Max = Properties.Max,
        Flag = Properties.Flag or "Dropdown_" .. math.random(1, 10000),
        Callback = Properties.Callback or function() end,
        Value = Properties.Default or (Properties.Max and {} or nil),
        Searchable = Properties.Searchable ~= false,
        isOpen = false,
        Elements = {},
    }
    
    local dropdown = Library:CreateInstance("Frame", {
        Name = "Dropdown",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 25),
        Parent = section.Elements.SectionContent,
    })
    
    local dropdownname = Library:CreateInstance("TextLabel", {
        Text = Dropdown.Name,
        FontFace = Font.new("rbxassetid://12187365364"),
        TextColor3 = Color3.fromRGB(115, 115, 115),
        TextSize = Library.GetScaledTextSize(12),
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(1, -12, 0, 15),
        Parent = dropdown,
    })
    
    -- Dropdown button with glass effect
    local dropdownButton = Library:CreateInstance("TextButton", {
        Name = "DropdownButton",
        Text = "",
        AutoButtonColor = false,
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -7, 0.5, 0),
        Size = UDim2.new(0, 80, 0, 21),
        Parent = dropdown,
    })
    
    -- Glass effect
    local buttonGlass = Library:CreateInstance("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.9,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = dropdownButton,
    })
    
    -- Corners
    local buttonCorner = Library:CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = dropdownButton,
    })
    
    local glassCorner = Library:CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = buttonGlass,
    })
    
    -- Glass border
    local buttonStroke = Library:CreateInstance("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 0.8,
        Thickness = 1,
        Parent = dropdownButton,
    })
    
    -- Current selection text
    local currentText = Library:CreateInstance("TextLabel", {
        Text = Dropdown.Default or "...",
        FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
        TextColor3 = Color3.fromRGB(115, 115, 115),
        TextSize = Library.GetScaledTextSize(12),
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 0),
        Size = UDim2.new(1, -30, 1, 0),
        Parent = dropdownButton,
    })
    
    -- Dropdown icon
    local dropdownIcon = Library:CreateInstance("ImageLabel", {
        Image = "rbxassetid://115894980866040",
        ImageColor3 = Color3.fromRGB(44, 44, 41),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.new(0, 14, 0, 14),
        Parent = dropdownButton,
    })
    
    -- Dropdown list (hidden by default)
    local dropdownList = Library:CreateInstance("Frame", {
        Name = "DropdownList",
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Position = UDim2.new(1, 0, 1, 2),
        Size = UDim2.new(0, math.max(120, dropdownButton.AbsoluteSize.X), 0, 105),
        Visible = false,
        Parent = dropdownButton,
    })
    
    -- Glass effect for list
    local listGlass = Library:CreateInstance("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.9,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = dropdownList,
    })
    
    -- List corners
    local listCorner = Library:CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = dropdownList,
    })
    
    local listGlassCorner = Library:CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = listGlass,
    })
    
    -- Glass border for list
    local listStroke = Library:CreateInstance("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 0.8,
        Thickness = 1,
        Parent = dropdownList,
    })
    
    -- Options container
    local optionsHolder = Library:CreateInstance("ScrollingFrame", {
        Name = "OptionsHolder",
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 0,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = dropdownList,
    })
    
    local optionsLayout = Library:CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = optionsHolder,
    })
    
    local optionsPadding = Library:CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 2),
        PaddingBottom = UDim.new(0, 2),
        Parent = optionsHolder,
    })
    
    -- Search input (if searchable)
    local searchInput
    if Dropdown.Searchable then
        searchInput = Library:CreateInstance("TextBox", {
            Name = "SearchInput",
            FontFace = Font.new("rbxassetid://12187365364"),
            PlaceholderText = "Search...",
            PlaceholderColor3 = Color3.fromRGB(115, 115, 115),
            Text = "",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = Library.GetScaledTextSize(11),
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            BackgroundTransparency = 0.3,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 4, 0, 4),
            Size = UDim2.new(1, -8, 0, 20),
            Parent = dropdownList,
        })
        
        local searchCorner = Library:CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 3),
            Parent = searchInput,
        })
        
        local searchStroke = Library:CreateInstance("UIStroke", {
            Color = Color3.fromRGB(255, 255, 255),
            Transparency = 0.7,
            Parent = searchInput,
        })
        
        -- Search icon
        local searchIcon = Library:CreateInstance("ImageLabel", {
            Image = "rbxassetid://139032822388177",
            ImageColor3 = Color3.fromRGB(80, 80, 75),
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, 6, 0.5, 0),
            Size = UDim2.new(0, 14, 0, 14),
            Parent = searchInput,
        })
        
        local searchPadding = Library:CreateInstance("UIPadding", {
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 16),
            Parent = searchInput,
        })
        
        -- Adjust options holder position
        optionsHolder.Position = UDim2.new(0, 0, 0, 28)
        optionsHolder.Size = UDim2.new(1, 0, 1, -28)
        
        Dropdown.Elements.SearchInput = searchInput
    end
    
    -- Create options
    local optionInstances = {}
    local filteredOptions = Dropdown.Options
    local currentSearch = ""
    
    local function createOption(optionName)
        local optionFrame = Library:CreateInstance("TextButton", {
            Name = optionName,
            Text = "",
            AutoButtonColor = false,
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            BackgroundTransparency = 0.3,
            BorderSizePixel = 0,
            Size = UDim2.new(1, -8, 0, 20),
            Parent = optionsHolder,
        })
        
        local optionCorner = Library:CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 3),
            Parent = optionFrame,
        })
        
        local optionGlass = Library:CreateInstance("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.9,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            Parent = optionFrame,
        })
        
        local optionGlassCorner = Library:CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 3),
            Parent = optionGlass,
        })
        
        local optionLabel = Library:CreateInstance("TextLabel", {
            Text = optionName,
            FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
            TextColor3 = Color3.fromRGB(115, 115, 115),
            TextSize = Library.GetScaledTextSize(12),
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 8, 0, 0),
            Size = UDim2.new(1, -16, 1, 0),
            Parent = optionFrame,
        })
        
        -- Hover effects
        optionFrame.MouseEnter:Connect(function()
            TweenService:Create(optionLabel, TweenInfo.new(0.2), {
                TextColor3 = Color3.fromRGB(255, 255, 255),
            }):Play()
            
            TweenService:Create(optionFrame, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.1,
            }):Play()
        end)
        
        optionFrame.MouseLeave:Connect(function()
            local isSelected = false
            if Dropdown.Max then
                isSelected = table.find(Dropdown.Value or {}, optionName) ~= nil
            else
                isSelected = Dropdown.Value == optionName
            end
            
            TweenService:Create(optionLabel, TweenInfo.new(0.2), {
                TextColor3 = isSelected and Color3.fromRGB(200, 200, 255) or Color3.fromRGB(115, 115, 115),
            }):Play()
            
            TweenService:Create(optionFrame, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.3,
            }):Play()
        end)
        
        -- Selection
        optionFrame.MouseButton1Click:Connect(function()
            if Dropdown.Max then
                if Dropdown.Max == 1 then
                    Dropdown.Value = {optionName}
                    currentText.Text = optionName
                else
                    -- Multi-select logic
                end
            else
                Dropdown.Value = optionName
                currentText.Text = optionName
            end
            
            Dropdown.Callback(Dropdown.Value)
            dropdownButton.MouseButton1Click:Fire() -- Close dropdown
        end)
        
        optionInstances[optionName] = {
            Frame = optionFrame,
            Label = optionLabel,
        }
        
        return optionFrame
    end
    
    -- Populate options
    for _, option in ipairs(Dropdown.Options) do
        createOption(option)
    end
    
    -- Toggle dropdown
    local function toggleDropdown()
        Dropdown.isOpen = not Dropdown.isOpen
        
        if Dropdown.isOpen then
            dropdownList.Visible = true
            TweenService:Create(dropdownIcon, TweenInfo.new(0.2), {
                Rotation = 180,
            }):Play()
            
            TweenService:Create(dropdownList, TweenInfo.new(0.2), {
                BackgroundTransparency = 0,
            }):Play()
            
            if Dropdown.Searchable then
                searchInput:CaptureFocus()
            end
        else
            TweenService:Create(dropdownIcon, TweenInfo.new(0.2), {
                Rotation = 0,
            }):Play()
            
            TweenService:Create(dropdownList, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.2,
            }):Play()
            
            task.wait(0.2)
            dropdownList.Visible = false
            
            if Dropdown.Searchable then
                searchInput.Text = ""
                currentSearch = ""
            end
        end
    end
    
    dropdownButton.MouseButton1Click:Connect(toggleDropdown)
    
    -- Search functionality
    if Dropdown.Searchable and searchInput then
        searchInput.Changed:Connect(function(property)
            if property == "Text" then
                currentSearch = searchInput.Text:lower()
                
                for _, optionData in pairs(optionInstances) do
                    local optionName = optionData.Label.Text:lower()
                    optionData.Frame.Visible = optionName:find(currentSearch, 1, true) ~= nil
                end
            end
        end)
    end
    
    -- Hover effects for main button
    dropdownButton.MouseEnter:Connect(function()
        TweenService:Create(dropdownButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        }):Play()
    end)
    
    dropdownButton.MouseLeave:Connect(function()
        TweenService:Create(dropdownButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        }):Play()
    end)
    
    -- Label hover
    dropdown.MouseEnter:Connect(function()
        TweenService:Create(dropdownname, TweenInfo.new(0.15), {
            TextColor3 = Color3.fromRGB(255, 255, 255),
        }):Play()
    end)
    
    dropdown.MouseLeave:Connect(function()
        TweenService:Create(dropdownname, TweenInfo.new(0.15), {
            TextColor3 = Color3.fromRGB(115, 115, 115),
        }):Play()
    end)
    
    -- Close dropdown when clicking outside
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and Dropdown.isOpen then
            local mousePos = game.Players.LocalPlayer:GetMouse()
            local overDropdown = Library:IsMouseOverFrame(dropdownButton) or Library:IsMouseOverFrame(dropdownList)
            
            if not overDropdown then
                toggleDropdown()
            end
        end
    end)
    
    -- Dropdown methods
    function Dropdown.Set(self, value)
        if Dropdown.Max then
            if Dropdown.Max == 1 then
                Dropdown.Value = {value}
                currentText.Text = value
            end
        else
            Dropdown.Value = value
            currentText.Text = value
        end
        Dropdown.Callback(Dropdown.Value)
    end
    
    function Dropdown.GetValue(self)
        return Dropdown.Value
    end
    
    function Dropdown.Refresh(self, newOptions)
        Dropdown.Options = newOptions
        -- Clear existing options
        for _, optionData in pairs(optionInstances) do
            optionData.Frame:Destroy()
        end
        optionInstances = {}
        
        -- Create new options
        for _, option in ipairs(newOptions) do
            createOption(option)
        end
    end
    
    Dropdown.Elements = {
        Frame = dropdown,
        Button = dropdownButton,
        List = dropdownList,
        CurrentText = currentText,
        Icon = dropdownIcon,
        OptionsHolder = optionsHolder,
        Options = optionInstances,
    }
    
    return Dropdown
end

return Library
