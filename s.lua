-- Modern Roblox UI Library with Glassy Design - Updated Version
local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Make Library available as both module and table
local self = Library

-- Utility functions
function Library.CreateInstance(className, properties)
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

function Library.IsMouseOverFrame(frame)
    if not frame then return false end
    local mouse = game.Players.LocalPlayer:GetMouse()
    local framePos = frame.AbsolutePosition
    local frameSize = frame.AbsoluteSize
    
    return mouse.X >= framePos.X and mouse.X <= framePos.X + frameSize.X and
           mouse.Y >= framePos.Y and mouse.Y <= framePos.Y + frameSize.Y
end

-- Helper function to count table size
local function getTableSize(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

-- Store all active dropdowns to prevent conflicts
local ActiveDropdowns = {}

-- Function to close all other dropdowns when one opens
local function closeOtherDropdowns(exceptId)
    for id, dropdownData in pairs(ActiveDropdowns) do
        if id ~= exceptId and dropdownData and dropdownData.Close then
            dropdownData.Close()
        end
    end
end

-- Main Window Creation function
function Library.CreateWindow(Properties)
    if not Properties then Properties = {} end
    
    local Window = {
        Name = Properties.Name or "UI Library",
        Position = Properties.Position or UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Properties.AnchorPoint or Vector2.new(0.5, 0.5),
        Size = Properties.Size or Library.UDim2(0, 670, 0, 415),
        Tabs = {},
        Minimized = false,
        Visible = true,
        Elements = {},
    }
    
    -- Main ScreenGui
    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    local mainframe = Library.CreateInstance("ScreenGui", {
        Name = "ModernUILibrary",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = playerGui,
    })
    
    local theholderdwbbg = Library.CreateInstance("Frame", {
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
    local glassFrame = Library.CreateInstance("Frame", {
        Name = "GlassFrame",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.9,
        BorderSizePixel = 0,
        Size = Library.UDim2(1, 0, 1, 0),
        Parent = theholderdwbbg,
    })
    
    -- Rounded corners
    Library.CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = theholderdwbbg,
    })
    
    Library.CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = glassFrame,
    })
    
    -- Glass border
    Library.CreateInstance("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 0.8,
        Thickness = 1,
        Parent = theholderdwbbg,
    })
    
    -- Title Bar
    local titleBar = Library.CreateInstance("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = Color3.fromRGB(30, 30, 35),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Size = Library.UDim2(1, 0, 0, 30),
        Parent = theholderdwbbg,
    })
    
    Library.CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12, 0, 0),
        Parent = titleBar,
    })
    
    local titleText = Library.CreateInstance("TextLabel", {
        Name = "TitleText",
        Text = Window.Name,
        FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
        TextColor3 = Color3.fromRGB(220, 220, 220),
        TextSize = Library.GetScaledTextSize(14),
        BackgroundTransparency = 1,
        Position = Library.UDim2(0, 15, 0, 0),
        Size = Library.UDim2(0, 200, 1, 0),
        Parent = titleBar,
    })
    
    -- Window control buttons
    local minimizeButton = Library.CreateInstance("TextButton", {
        Name = "MinimizeButton",
        Text = "─",
        FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold),
        TextColor3 = Color3.fromRGB(220, 220, 220),
        TextSize = Library.GetScaledTextSize(14),
        AutoButtonColor = false,
        BackgroundColor3 = Color3.fromRGB(40, 40, 45),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Position = Library.UDim2(1, -55, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Size = Library.UDim2(0, 20, 0, 20),
        Parent = titleBar,
    })
    
    Library.CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = minimizeButton,
    })
    
    local closeButton = Library.CreateInstance("TextButton", {
        Name = "CloseButton",
        Text = "×",
        FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold),
        TextColor3 = Color3.fromRGB(220, 220, 220),
        TextSize = Library.GetScaledTextSize(16),
        AutoButtonColor = false,
        BackgroundColor3 = Color3.fromRGB(40, 40, 45),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Position = Library.UDim2(1, -25, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Size = Library.UDim2(0, 20, 0, 20),
        Parent = titleBar,
    })
    
    Library.CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = closeButton,
    })
    
    -- Hover effects for control buttons
    minimizeButton.MouseEnter:Connect(function()
        TweenService:Create(minimizeButton, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(50, 50, 60),
        }):Play()
    end)
    
    minimizeButton.MouseLeave:Connect(function()
        TweenService:Create(minimizeButton, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 45),
        }):Play()
    end)
    
    closeButton.MouseEnter:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(220, 60, 60),
        }):Play()
    end)
    
    closeButton.MouseLeave:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 45),
        }):Play()
    end)
    
    -- Content area (below title bar)
    local contentArea = Library.CreateInstance("Frame", {
        Name = "ContentArea",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = Library.UDim2(0, 0, 0, 30),
        Size = Library.UDim2(1, 0, 1, -30),
        Parent = theholderdwbbg,
    })
    
    -- Drag functionality (only on title bar)
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
    
    titleBar.InputBegan:Connect(function(input)
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
    
    -- Sidebar
    local sidebarHolder = Library.CreateInstance("Frame", {
        Name = "SidebarHolder",
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Size = Library.UDim2(0, 155, 1, 0),
        Parent = contentArea,
    })
    
    Library.CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 0, 0, 12),
        Parent = sidebarHolder,
    })
    
    -- Search bar
    local search = Library.CreateInstance("Frame", {
        Name = "Search",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = Library.UDim2(1, 0, 0, 40),
        Parent = sidebarHolder,
    })
    
    local line = Library.CreateInstance("Frame", {
        Name = "line",
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Size = Library.UDim2(1, 0, 0, 1),
        Parent = search,
    })
    
    local line1 = Library.CreateInstance("Frame", {
        Name = "line",
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Position = Library.UDim2(0, 0, 1, 0),
        Size = Library.UDim2(1, 0, 0, 1),
        Parent = search,
    })
    
    local searchzone = Library.CreateInstance("Frame", {
        Name = "searchzone",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(35, 35, 33),
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        Position = Library.UDim2(0.5, 0, 0.5, 0),
        Size = Library.UDim2(1, -30, 0, 25),
        Parent = search,
    })
    
    Library.CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = searchzone,
    })
    
    local keyicon = Library.CreateInstance("ImageLabel", {
        Name = "Keyicon",
        Image = "rbxassetid://139032822388177",
        ImageColor3 = Color3.fromRGB(80, 80, 75),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Position = Library.UDim2(1, -25, 0.5, 0),
        Size = Library.UDim2(0, 14, 0, 14),
        Parent = searchzone,
    })
    
    local searchinput = Library.CreateInstance("TextBox", {
        Name = "TextBox",
        FontFace = Font.new("rbxassetid://12187365364"),
        PlaceholderText = "(beta) Search...",
        Text = "",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = Library.GetScaledTextSize(12),
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = Library.UDim2(0, 9, 0, 0),
        Size = Library.UDim2(1, -42, 1, 0),
        Parent = searchzone,
    })
    
    Library.CreateInstance("UIStroke", {
        Color = Color3.fromRGB(45, 45, 45),
        Transparency = 0.6,
        Parent = searchzone,
    })
    
    -- Tab holder
    local tabHolder = Library.CreateInstance("ScrollingFrame", {
        Name = "TabContainer",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60),
        Position = Library.UDim2(0, 0, 0, 40),
        Size = Library.UDim2(1, 0, 1, -40),
        Parent = sidebarHolder,
    })
    
    local tabLayout = Library.CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tabHolder,
    })
    
    Library.CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        Parent = tabHolder,
    })
    
    -- Update ScrollingFrame size
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabHolder.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Sidebar border
    local line2 = Library.CreateInstance("Frame", {
        Name = "Line",
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Position = Library.UDim2(1, 0, 0, 0),
        Size = Library.UDim2(0, 1, 1, 0),
        Parent = sidebarHolder,
    })
    
    -- Content area (main)
    local content = Library.CreateInstance("Frame", {
        Name = "content",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Size = Library.UDim2(1, -155, 1, 0),
        Position = Library.UDim2(0, 155, 0, 0),
        Parent = contentArea,
    })
    
    -- Search functionality
    searchinput:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = searchinput.Text:lower()
        
        if searchText == "" then
            for _, tab in pairs(Window.Tabs) do
                if tab.Elements and tab.Elements.TabButton then
                    tab.Elements.TabButton.Visible = true
                end
            end
        else
            local visibleTabs = {}
            
            for _, tab in pairs(Window.Tabs) do
                local tabName = tab.Name:lower()
                local shouldShow = tabName:find(searchText, 1, true) ~= nil
                
                if tab.Elements and tab.Elements.TabButton then
                    tab.Elements.TabButton.Visible = shouldShow
                end
                
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
                    if tab.Open and tab.Elements and tab.Elements.TabButton and not tab.Elements.TabButton.Visible then
                        tab:Turn(false)
                    end
                end
            end
        end
    end)
    
    searchinput.FocusLost:Connect(function()
        if searchinput.Text == "" then
            for _, tab in pairs(Window.Tabs) do
                if tab.Elements and tab.Elements.TabButton then
                    tab.Elements.TabButton.Visible = true
                end
            end
        end
    end)
    
    -- Control button functionality
    minimizeButton.MouseButton1Click:Connect(function()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            contentArea.Visible = false
            minimizeButton.Text = "□"
            theholderdwbbg.Size = Library.UDim2(0, 200, 0, 30)
        else
            contentArea.Visible = true
            minimizeButton.Text = "─"
            theholderdwbbg.Size = Window.Size
        end
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        mainframe:Destroy()
        Window.Visible = false
    end)
    
    -- Right Control toggle
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.RightControl then
            theholderdwbbg.Visible = not theholderdwbbg.Visible
        end
    end)
    
    -- Window functions
    function Window.UpdateTabs()
        for _, tab in pairs(Window.Tabs) do
            tab:Turn(tab.Open)
        end
    end
    
    function Window.ToggleVisibility()
        Window.Visible = not Window.Visible
        theholderdwbbg.Visible = Window.Visible
    end
    
    -- Tab creation function
    function Window:Tab(Properties)
        if not Properties then Properties = {} end
        
        local Tab = {
            Name = Properties.Title or "Tab",
            Icon = Properties.Icon,
            Window = self,
            Open = false,
            Sections = {},
            Elements = {},
        }
        
        -- Tab button with thin white border
        local atab = Library.CreateInstance("TextButton", {
            Name = "TabButton_" .. Tab.Name,
            Text = "",
            AutoButtonColor = false,
            BackgroundColor3 = Color3.fromRGB(35, 35, 38),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = Library.UDim2(1, -20, 0, 35),
            Parent = tabHolder,
            LayoutOrder = #Window.Tabs + 1,
        })
        
        Library.CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = atab,
        })
        
        -- Thin white border around tab
        local tabBorder = Library.CreateInstance("UIStroke", {
            Color = Color3.fromRGB(80, 80, 85),
            Transparency = 0.8,
            Enabled = false,
            Thickness = 1.5,
            Parent = atab,
        })
        
        -- Tab content area
        local tabContent = Library.CreateInstance("ScrollingFrame", {
            Name = "TabContent_" .. Tab.Name,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60),
            ScrollBarThickness = 3,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = Library.UDim2(0, 10, 0, 10),
            Size = Library.UDim2(1, -20, 1, -20),
            Visible = false,
            Parent = content,
        })
        
        local contentLayout = Library.CreateInstance("UIListLayout", {
            Padding = UDim.new(0, 15),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = tabContent,
        })
        
        Library.CreateInstance("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 15),
            Parent = tabContent,
        })
        
        -- Update ScrollingFrame size
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Tab icon and name container
        local tabContentHolder = Library.CreateInstance("Frame", {
            BackgroundTransparency = 1,
            Size = Library.UDim2(1, 0, 1, 0),
            Parent = atab,
        })
        
        Library.CreateInstance("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
            Parent = tabContentHolder,
        })
        
        local innerLayout = Library.CreateInstance("UIListLayout", {
            Padding = UDim.new(0, 10),
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Parent = tabContentHolder,
        })
        
        local tabIcon
        if Tab.Icon then
            tabIcon = Library.CreateInstance("ImageLabel", {
                Image = Tab.Icon,
                ImageColor3 = Color3.fromRGB(140, 140, 140),
                BackgroundTransparency = 1,
                Size = Library.UDim2(0, 16, 0, 16),
                LayoutOrder = 1,
                Parent = tabContentHolder,
            })
        end
        
        local tabName = Library.CreateInstance("TextLabel", {
            Text = Tab.Name,
            FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
            TextColor3 = Color3.fromRGB(140, 140, 140),
            TextSize = Library.GetScaledTextSize(13),
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Size = Library.UDim2(0, 0, 1, 0),
            LayoutOrder = 2,
            Parent = tabContentHolder,
        })
        
        tabName.AutomaticSize = Enum.AutomaticSize.X
        
        -- Tab functions
        function Tab:Turn(bool)
            Tab.Open = bool
            local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            
            if bool then
                TweenService:Create(atab, tweenInfo, {
                    BackgroundTransparency = 0.7,
                }):Play()
                
                tabBorder.Enabled = true
                tabBorder.Transparency = 0.3
                TweenService:Create(tabBorder, tweenInfo, {
                    Color = Color3.fromRGB(150, 150, 155),
                }):Play()
                
                if tabIcon then
                    TweenService:Create(tabIcon, tweenInfo, {
                        ImageColor3 = Color3.fromRGB(220, 220, 220),
                    }):Play()
                end
                
                TweenService:Create(tabName, tweenInfo, {
                    TextColor3 = Color3.fromRGB(220, 220, 220),
                }):Play()
                
                tabContent.Visible = true
            else
                TweenService:Create(atab, tweenInfo, {
                    BackgroundTransparency = 1,
                }):Play()
                
                tabBorder.Enabled = false
                
                if tabIcon then
                    TweenService:Create(tabIcon, tweenInfo, {
                        ImageColor3 = Color3.fromRGB(140, 140, 140),
                    }):Play()
                end
                
                TweenService:Create(tabName, tweenInfo, {
                    TextColor3 = Color3.fromRGB(140, 140, 140),
                }):Play()
                
                tabContent.Visible = false
            end
        end
        
        -- Tab interaction
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
                
                tabBorder.Enabled = true
                TweenService:Create(tabBorder, TweenInfo.new(0.15), {
                    Transparency = 0.5,
                }):Play()
                
                if tabIcon then
                    TweenService:Create(tabIcon, TweenInfo.new(0.15), {
                        ImageColor3 = Color3.fromRGB(180, 180, 180),
                    }):Play()
                end
                
                TweenService:Create(tabName, TweenInfo.new(0.15), {
                    TextColor3 = Color3.fromRGB(180, 180, 180),
                }):Play()
            end
        end)
        
        atab.MouseLeave:Connect(function()
            if not Tab.Open then
                TweenService:Create(atab, TweenInfo.new(0.15), {
                    BackgroundTransparency = 1,
                }):Play()
                
                tabBorder.Enabled = false
                
                if tabIcon then
                    TweenService:Create(tabIcon, TweenInfo.new(0.15), {
                        ImageColor3 = Color3.fromRGB(140, 140, 140),
                    }):Play()
                end
                
                TweenService:Create(tabName, TweenInfo.new(0.15), {
                    TextColor3 = Color3.fromRGB(140, 140, 140),
                }):Play()
            end
        end)
        
        Tab.Elements = {
            TabButton = atab,
            Content = tabContent,
            TabIcon = tabIcon,
            TabName = tabName,
        }
        
        -- Define Section creation function properly
        function Tab:Section(Properties)
            if not Properties then Properties = {} end
            
            local Section = {
                Name = Properties.Name or "Section",
                Tab = self,
                ShowTitle = Properties.ShowTitle ~= false,
                Elements = {},
                Content = {},
            }
            
            -- Section frame
            local section = Library.CreateInstance("Frame", {
                Name = "Section_" .. Section.Name,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Color3.fromRGB(25, 25, 28),
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                Size = Library.UDim2(1, 0, 0, 0),
                Parent = Tab.Elements.Content,
            })
            
            Library.CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = section,
            })
            
            Library.CreateInstance("UIStroke", {
                Color = Color3.fromRGB(50, 50, 55),
                Transparency = 0.3,
                Thickness = 1,
                Parent = section,
            })
            
            local sectionLayout = Library.CreateInstance("UIListLayout", {
                Padding = UDim.new(0, 10),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = section,
            })
            
            Library.CreateInstance("UIPadding", {
                PaddingTop = UDim.new(0, 12),
                PaddingLeft = UDim.new(0, 12),
                PaddingRight = UDim.new(0, 12),
                PaddingBottom = UDim.new(0, 12),
                Parent = section,
            })
            
            -- Title
            if Section.ShowTitle then
                local title = Library.CreateInstance("TextLabel", {
                    Text = Section.Name,
                    FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
                    TextColor3 = Color3.fromRGB(200, 200, 200),
                    TextSize = Library.GetScaledTextSize(14),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Size = Library.UDim2(1, 0, 0, 20),
                    LayoutOrder = 0,
                    Parent = section,
                })
                
                Section.Elements.Title = title
            end
            
            -- Content container
            local aholder = Library.CreateInstance("Frame", {
                Name = "ContentHolder",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = Library.UDim2(1, 0, 0, 0),
                LayoutOrder = 1,
                Parent = section,
            })
            
            local contentLayout = Library.CreateInstance("UIListLayout", {
                Padding = UDim.new(0, 10),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = aholder,
            })
            
            Library.CreateInstance("UIPadding", {
                PaddingLeft = UDim.new(0, 2),
                PaddingRight = UDim.new(0, 2),
                Parent = aholder,
            })
            
            Section.Elements.SectionFrame = section
            Section.Elements.SectionContent = aholder
            
            -- Define all component methods within the Section
            
            -- FIXED Toggle function (even, properly aligned)
            function Section:Toggle(Properties)
                if not Properties then Properties = {} end
                
                local Toggle = {
                    Name = Properties.Name or "Toggle",
                    Default = Properties.Default or false,
                    Callback = Properties.Callback or function() end,
                    Value = Properties.Default or false,
                }
                
                local toggle = Library.CreateInstance("Frame", {
                    Name = "Toggle_" .. Toggle.Name,
                    BackgroundTransparency = 1,
                    Size = Library.UDim2(1, 0, 0, 28),
                    Parent = self.Elements.SectionContent,
                })
                
                local toggleLabel = Library.CreateInstance("TextLabel", {
                    Text = Toggle.Name,
                    FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium),
                    TextColor3 = Color3.fromRGB(150, 150, 150),
                    TextSize = Library.GetScaledTextSize(12),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Position = Library.UDim2(0, 0, 0, 0),
                    Size = Library.UDim2(1, -50, 1, 0),
                    Parent = toggle,
                })
                
                -- FIXED: Even, properly aligned toggle button
                local toggleButton = Library.CreateInstance("TextButton", {
                    Name = "ToggleButton",
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                    BackgroundTransparency = 0.2,
                    BorderSizePixel = 0,
                    Position = Library.UDim2(1, 0, 0.5, 0),
                    Size = Library.UDim2(0, 40, 0, 22),
                    Parent = toggle,
                })
                
                Library.CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = toggleButton,
                })
                
                local glassStroke = Library.CreateInstance("UIStroke", {
                    Color = Color3.fromRGB(100, 100, 100),
                    Transparency = 0.6,
                    Thickness = 1.5,
                    Parent = toggleButton,
                })
                
                -- FIXED: Even toggle knob
                local toggleKnob = Library.CreateInstance("Frame", {
                    Name = "ToggleKnob",
                    BackgroundColor3 = Color3.fromRGB(240, 240, 240),
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    Position = Library.UDim2(0, 3, 0.5, 0),
                    Size = Library.UDim2(0, 16, 0, 16),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Parent = toggleButton,
                })
                
                Library.CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = toggleKnob,
                })
                
                Library.CreateInstance("UIStroke", {
                    Color = Color3.fromRGB(255, 255, 255),
                    Transparency = 0.3,
                    Parent = toggleKnob,
                })
                
                -- Set initial state
                if Toggle.Value then
                    toggleKnob.Position = Library.UDim2(1, -19, 0.5, 0)
                    toggleButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
                    glassStroke.Color = Color3.fromRGB(120, 180, 255)
                    toggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                end
                
                -- Toggle functionality
                toggleButton.MouseButton1Click:Connect(function()
                    Toggle.Value = not Toggle.Value
                    
                    if Toggle.Value then
                        TweenService:Create(toggleKnob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Position = Library.UDim2(1, -19, 0.5, 0),
                        }):Play()
                        
                        TweenService:Create(toggleButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(80, 160, 255),
                        }):Play()
                        
                        TweenService:Create(glassStroke, TweenInfo.new(0.2), {
                            Color = Color3.fromRGB(120, 180, 255),
                        }):Play()
                    else
                        TweenService:Create(toggleKnob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Position = Library.UDim2(0, 3, 0.5, 0),
                        }):Play()
                        
                        TweenService:Create(toggleButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        }):Play()
                        
                        TweenService:Create(glassStroke, TweenInfo.new(0.2), {
                            Color = Color3.fromRGB(100, 100, 100),
                        }):Play()
                    end
                    
                    Toggle.Callback(Toggle.Value)
                end)
                
                -- Hover effects
                local function onHover()
                    TweenService:Create(toggleLabel, TweenInfo.new(0.15), {
                        TextColor3 = Color3.fromRGB(220, 220, 220),
                    }):Play()
                    
                    if not Toggle.Value then
                        TweenService:Create(toggleButton, TweenInfo.new(0.15), {
                            BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                        }):Play()
                    end
                end
                
                local function onLeave()
                    TweenService:Create(toggleLabel, TweenInfo.new(0.15), {
                        TextColor3 = Color3.fromRGB(150, 150, 150),
                    }):Play()
                    
                    if not Toggle.Value then
                        TweenService:Create(toggleButton, TweenInfo.new(0.15), {
                            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        }):Play()
                    end
                end
                
                toggle.MouseEnter:Connect(onHover)
                toggleButton.MouseEnter:Connect(onHover)
                toggleLabel.MouseEnter:Connect(onHover)
                
                toggle.MouseLeave:Connect(onLeave)
                toggleButton.MouseLeave:Connect(onLeave)
                toggleLabel.MouseLeave:Connect(onLeave)
                
                Toggle.Elements = {
                    Frame = toggle,
                    Button = toggleButton,
                    Label = toggleLabel,
                    Knob = toggleKnob,
                }
                
                function Toggle.Set(value)
                    if Toggle.Value ~= value then
                        toggleButton.MouseButton1Click:Fire()
                    end
                end
                
                function Toggle.GetValue()
                    return Toggle.Value
                end
                
                return Toggle
            end
            
            -- Button function
            function Section:Button(Properties)
                if not Properties then Properties = {} end
                
                local Button = {
                    Name = Properties.Name or "Button",
                    Callback = Properties.Callback or function() end,
                }
                
                local button = Library.CreateInstance("TextButton", {
                    Name = "Button_" .. Button.Name,
                    Text = Button.Name,
                    FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium),
                    TextColor3 = Color3.fromRGB(200, 200, 200),
                    TextSize = Library.GetScaledTextSize(12),
                    AutoButtonColor = false,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 45),
                    BackgroundTransparency = 0.3,
                    BorderSizePixel = 0,
                    Size = Library.UDim2(1, 0, 0, 32),
                    Parent = self.Elements.SectionContent,
                })
                
                Library.CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = button,
                })
                
                Library.CreateInstance("UIStroke", {
                    Color = Color3.fromRGB(80, 80, 85),
                    Transparency = 0.5,
                    Thickness = 1,
                    Parent = button,
                })
                
                -- Button functionality
                button.MouseButton1Click:Connect(function()
                    -- Press animation
                    TweenService:Create(button, TweenInfo.new(0.1), {
                        BackgroundTransparency = 0.5,
                        Size = Library.UDim2(1, -4, 0, 30),
                    }):Play()
                    
                    TweenService:Create(button, TweenInfo.new(0.1), {
                        BackgroundTransparency = 0.3,
                        Size = Library.UDim2(1, 0, 0, 32),
                    }):Play()
                    
                    -- Call callback
                    Button.Callback()
                end)
                
                -- Hover effects
                button.MouseEnter:Connect(function()
                    TweenService:Create(button, TweenInfo.new(0.15), {
                        BackgroundColor3 = Color3.fromRGB(50, 50, 55),
                        TextColor3 = Color3.fromRGB(220, 220, 220),
                    }):Play()
                end)
                
                button.MouseLeave:Connect(function()
                    TweenService:Create(button, TweenInfo.new(0.15), {
                        BackgroundColor3 = Color3.fromRGB(40, 40, 45),
                        TextColor3 = Color3.fromRGB(200, 200, 200),
                    }):Play()
                end)
                
                Button.Elements = {
                    Button = button,
                }
                
                return Button
            end
            
            -- Slider function
            function Section:Slider(Properties)
                if not Properties then Properties = {} end
                
                local Slider = {
                    Name = Properties.Name or "Slider",
                    Min = Properties.Min or 0,
                    Max = Properties.Max or 100,
                    Default = Properties.Default or Properties.Min,
                    Decimals = Properties.Decimals or 0,
                    Suffix = Properties.Suffix or "",
                    Callback = Properties.Callback or function() end,
                    Value = Properties.Default or Properties.Min,
                }
                Slider.Value = Slider.Default
                
                local sliderframe = Library.CreateInstance("Frame", {
                    Name = "Sliderframe",
                    BackgroundTransparency = 1,
                    Size = Library.UDim2(1, 0, 0, 28),
                    Parent = self.Elements.SectionContent,
                })
                
                local textHolder = Library.CreateInstance("Frame", {
                    Name = "TextHolder",
                    BackgroundTransparency = 1,
                    Size = Library.UDim2(1, -52, 1, 0),
                    Parent = sliderframe,
                })
                
                local slidername = Library.CreateInstance("TextLabel", {
                    Name = "Slidername",
                    FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium),
                    Text = Slider.Name,
                    TextColor3 = Color3.fromRGB(150, 150, 150),
                    TextSize = Library.GetScaledTextSize(12),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Position = Library.UDim2(0, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = Library.UDim2(1, -90, 0, 15),
                    Parent = textHolder,
                })
                
                local thebgofsliderbar = Library.CreateInstance("Frame", {
                    Name = "Thebgofsliderbar",
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = Color3.fromRGB(33, 32, 43),
                    BackgroundTransparency = 0.5,
                    Position = Library.UDim2(1, 0, 0.5, 0),
                    Size = Library.UDim2(0, 90, 0, 8),
                    Parent = sliderframe,
                })
                
                Library.CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = thebgofsliderbar,
                })
                
                local uIStroke1 = Library.CreateInstance("UIStroke", {
                    Color = Color3.fromRGB(45, 45, 45),
                    Transparency = 0.6,
                    Parent = thebgofsliderbar,
                })
                
                local thesliderbar = Library.CreateInstance("Frame", {
                    Name = "Thesliderbar",
                    BackgroundColor3 = Color3.fromRGB(100, 180, 255),
                    Size = Library.UDim2(0, 0, 1, 0),
                    Parent = thebgofsliderbar,
                })
                
                Library.CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = thesliderbar,
                })
                
                local slidertextbox = Library.CreateInstance("TextBox", {
                    Name = "Slidertextbox",
                    FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium),
                    Text = "50",
                    TextColor3 = Color3.fromRGB(180, 180, 180),
                    TextSize = Library.GetScaledTextSize(11),
                    TextXAlignment = Enum.TextXAlignment.Center,
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = Library.UDim2(1, -95, 0.5, 0),
                    Size = Library.UDim2(0, 40, 1, 0),
                    Parent = sliderframe,
                })
                
                local Sliding = false
                local format = "%." .. Slider.Decimals .. "f"
                
                local function SetValue(value, fromInput)
                    fromInput = fromInput or false
                    local power = 10 ^ Slider.Decimals
                    value = math.floor((value * power) + 0.5) / power
                    value = math.clamp(value, Slider.Min, Slider.Max)
                    
                    Slider.Value = value
                    local percent = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
                    if (Slider.Max - Slider.Min) == 0 then
                        percent = 0
                    end
                    
                    local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    TweenService:Create(thesliderbar, tweenInfo, {
                        Size = UDim2.new(percent, 0, 1, 0),
                    }):Play()
                    
                    if not fromInput or slidertextbox.Text ~= (string.format(format, Slider.Value) .. Slider.Suffix) then
                        slidertextbox.Text = string.format(format, Slider.Value) .. Slider.Suffix
                    end
                    
                    Slider.Callback(Slider.Value)
                end
                
                local function HandleSlide(input)
                    local barStartX = thebgofsliderbar.AbsolutePosition.X
                    local barSizeX = thebgofsliderbar.AbsoluteSize.X
                    if barSizeX <= 0 then
                        return
                    end
                    
                    local percentage = math.clamp((input.Position.X - barStartX) / barSizeX, 0, 1)
                    local value = Slider.Min + (Slider.Max - Slider.Min) * percentage
                    SetValue(value)
                end
                
                thebgofsliderbar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Sliding = true
                        HandleSlide(input)
                        if slidertextbox:IsFocused() then
                            slidertextbox:ReleaseFocus()
                        end
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Sliding = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if Sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        HandleSlide(input)
                    end
                end)
                
                slidertextbox.FocusLost:Connect(function(enterPressed)
                    if enterPressed then
                        local textContent = slidertextbox.Text
                        local numericString = textContent
                        
                        if Slider.Suffix and Slider.Suffix ~= "" then
                            local escapedSuffixPattern = Slider.Suffix:gsub("([%(%)%.%%%+%-%*%?%[%^%$])", "%%%1")
                            numericString = textContent:gsub(escapedSuffixPattern, "")
                        end
                        
                        local numValue = tonumber(numericString)
                        
                        if numValue then
                            SetValue(numValue, true)
                        else
                            slidertextbox.Text = string.format(format, Slider.Value) .. Slider.Suffix
                        end
                    else
                        slidertextbox.Text = string.format(format, Slider.Value) .. Slider.Suffix
                    end
                end)
                
                sliderframe.MouseEnter:Connect(function()
                    local hoverTween = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    
                    TweenService:Create(slidername, hoverTween, {
                        TextColor3 = Color3.fromRGB(220, 220, 220),
                    }):Play()
                    
                    TweenService:Create(slidertextbox, hoverTween, {
                        TextColor3 = Color3.fromRGB(220, 220, 220),
                    }):Play()
                end)
                
                sliderframe.MouseLeave:Connect(function()
                    local hoverTween = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    
                    TweenService:Create(slidername, hoverTween, {
                        TextColor3 = Color3.fromRGB(150, 150, 150),
                    }):Play()
                    
                    TweenService:Create(slidertextbox, hoverTween, {
                        TextColor3 = Color3.fromRGB(180, 180, 180),
                    }):Play()
                end)
                
                SetValue(Slider.Default)
                
                function Slider.Set(self, value)
                    SetValue(value)
                end
                
                function Slider.GetValue(self)
                    return Slider.Value
                end
                
                return Slider
            end
            
            -- COMPLETELY FIXED Dropdown function with all issues resolved
            function Section:Dropdown(Properties)
                if not Properties then Properties = {} end
                
                local Dropdown = {
                    Name = Properties.Name or "Dropdown",
                    Options = Properties.Options or {},
                    Default = Properties.Default,
                    MultiSelect = Properties.MultiSelect or false,
                    Callback = Properties.Callback or function() end,
                    Value = Properties.Default or nil,
                    Searchable = Properties.Searchable ~= false,
                    isOpen = false,
                    SelectedOptions = {},
                    Elements = {},
                    id = math.random(1, 999999),
                    clickOutsideConnection = nil
                }
                
                if Dropdown.MultiSelect then
                    Dropdown.Value = {}
                    Dropdown.SelectedOptions = {}
                end
                
                local dropdown = Library.CreateInstance("Frame", {
                    Name = "Dropdown_" .. Dropdown.Name,
                    BackgroundTransparency = 1,
                    Size = Library.UDim2(1, 0, 0, 28),
                    Parent = self.Elements.SectionContent,
                })
                
                local dropdownname = Library.CreateInstance("TextLabel", {
                    Text = Dropdown.Name,
                    FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium),
                    TextColor3 = Color3.fromRGB(150, 150, 150),
                    TextSize = Library.GetScaledTextSize(12),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Position = Library.UDim2(0, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = Library.UDim2(1, -90, 0, 15),
                    Parent = dropdown,
                })
                
                -- Dropdown button
                local dropdownButton = Library.CreateInstance("TextButton", {
                    Name = "DropdownButton",
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                    BackgroundTransparency = 0.2,
                    BorderSizePixel = 0,
                    Position = Library.UDim2(1, 0, 0.5, 0),
                    Size = Library.UDim2(0, 85, 0, 24),
                    ZIndex = 10,
                    Parent = dropdown,
                })
                
                Library.CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = dropdownButton,
                })
                
                Library.CreateInstance("UIStroke", {
                    Color = Color3.fromRGB(100, 100, 100),
                    Transparency = 0.6,
                    Thickness = 1.5,
                    Parent = dropdownButton,
                })
                
                -- Current selection text
                local currentText = Library.CreateInstance("TextLabel", {
                    Text = Dropdown.MultiSelect and "Select..." or (Dropdown.Default or "Select..."),
                    FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium),
                    TextColor3 = Color3.fromRGB(180, 180, 180),
                    TextSize = Library.GetScaledTextSize(11),
                    TextXAlignment = Enum.TextXAlignment.Center,
                    BackgroundTransparency = 1,
                    Position = Library.UDim2(0, 8, 0, 0),
                    Size = Library.UDim2(1, -30, 1, 0),
                    ZIndex = 11,
                    Parent = dropdownButton,
                })
                
                -- Dropdown icon
                local dropdownIcon = Library.CreateInstance("ImageLabel", {
                    Image = "rbxassetid://115894980866040",
                    ImageColor3 = Color3.fromRGB(180, 180, 180),
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundTransparency = 1,
                    Position = Library.UDim2(1, -6, 0.5, 0),
                    Size = Library.UDim2(0, 14, 0, 14),
                    ZIndex = 11,
                    Parent = dropdownButton,
                })
                
                -- Create dropdown overlay elements (created once, reused)
                local dropdownScreenGui
                local optionsFrame
                local optionsContainer
                local searchInput
                
                local function createOverlayElements()
                    if dropdownScreenGui and dropdownScreenGui.Parent then
                        dropdownScreenGui:Destroy()
                    end
                    
                    dropdownScreenGui = Library.CreateInstance("ScreenGui", {
                        Name = "DropdownOverlay_" .. Dropdown.id,
                        ResetOnSpawn = false,
                        ZIndexBehavior = Enum.ZIndexBehavior.Global,
                        Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
                    })
                    
                    optionsFrame = Library.CreateInstance("Frame", {
                        Name = "OptionsFrame",
                        BackgroundColor3 = Color3.fromRGB(30, 30, 35),
                        BackgroundTransparency = 0.1,
                        BorderSizePixel = 0,
                        Size = Library.UDim2(0, 85, 0, 0),
                        Visible = false,
                        ZIndex = 1000,
                        Parent = dropdownScreenGui,
                    })
                    
                    Library.CreateInstance("UICorner", {
                        CornerRadius = UDim.new(0, 6),
                        Parent = optionsFrame,
                    })
                    
                    Library.CreateInstance("UIStroke", {
                        Color = Color3.fromRGB(60, 60, 65),
                        Thickness = 1,
                        Parent = optionsFrame,
                    })
                    
                    -- Search input for searchable dropdowns
                    local optionsStartY = 5
                    if Dropdown.Searchable then
                        searchInput = Library.CreateInstance("TextBox", {
                            Name = "SearchInput",
                            FontFace = Font.new("rbxassetid://12187365364"),
                            PlaceholderText = "Search...",
                            PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
                            Text = "",
                            TextColor3 = Color3.fromRGB(220, 220, 220),
                            TextSize = Library.GetScaledTextSize(11),
                            BackgroundColor3 = Color3.fromRGB(40, 40, 45),
                            BackgroundTransparency = 0.2,
                            BorderSizePixel = 0,
                            Size = Library.UDim2(1, -10, 0, 25),
                            Position = Library.UDim2(0, 5, 0, 5),
                            ZIndex = 1001,
                            Parent = optionsFrame,
                        })
                        
                        Library.CreateInstance("UICorner", {
                            CornerRadius = UDim.new(0, 4),
                            Parent = searchInput,
                        })
                        
                        Library.CreateInstance("UIPadding", {
                            PaddingLeft = UDim.new(0, 8),
                            PaddingRight = UDim.new(0, 8),
                            Parent = searchInput,
                        })
                        
                        optionsStartY = 35
                    end
                    
                    -- Options container
                    optionsContainer = Library.CreateInstance("ScrollingFrame", {
                        Name = "OptionsContainer",
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        ScrollBarImageColor3 = Color3.fromRGB(70, 70, 75),
                        ScrollBarThickness = 3,
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Size = Library.UDim2(1, -10, 0, 0),
                        Position = Library.UDim2(0, 5, 0, optionsStartY),
                        ZIndex = 1001,
                        Parent = optionsFrame,
                    })
                    
                    local optionsLayout = Library.CreateInstance("UIListLayout", {
                        Padding = UDim.new(0, 5),
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Parent = optionsContainer,
                    })
                    
                    return dropdownScreenGui, optionsFrame, optionsContainer, searchInput
                end
                
                -- Function to update displayed options
                local function updateOptionsDisplay()
                    if not optionsContainer then
                        createOverlayElements()
                    end
                    
                    -- Clear existing options
                    for _, child in pairs(optionsContainer:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    -- Filter options based on search
                    local filteredOptions = Dropdown.Options
                    if Dropdown.Searchable and searchInput and searchInput.Text ~= "" then
                        local searchTerm = searchInput.Text:lower()
                        filteredOptions = {}
                        for _, option in ipairs(Dropdown.Options) do
                            if option:lower():find(searchTerm, 1, true) then
                                table.insert(filteredOptions, option)
                            end
                        end
                    end
                    
                    -- Limit height and show scrollbar if too many options
                    local maxHeight = 200
                    local optionsStartY = Dropdown.Searchable and 35 or 5
                    
                    if #filteredOptions > 8 then
                        optionsContainer.Size = Library.UDim2(1, 0, 0, 200 - optionsStartY - 10)
                        optionsContainer.CanvasSize = UDim2.new(0, 0, 0, #filteredOptions * 30)
                    else
                        optionsContainer.Size = Library.UDim2(1, 0, 0, #filteredOptions * 30)
                        optionsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
                    end
                    
                    optionsFrame.Size = Library.UDim2(0, 85, 0, optionsStartY + math.min(maxHeight, #filteredOptions * 30 + 10))
                    
                    for i, option in ipairs(filteredOptions) do
                        local optionButton = Library.CreateInstance("TextButton", {
                            Text = option,
                            FontFace = Font.new("rbxassetid://12187365364"),
                            TextColor3 = Color3.fromRGB(180, 180, 180),
                            TextSize = Library.GetScaledTextSize(11),
                            BackgroundColor3 = Color3.fromRGB(40, 40, 45),
                            BackgroundTransparency = 1,
                            BorderSizePixel = 0,
                            Size = Library.UDim2(1, 0, 0, 25),
                            ZIndex = 1002,
                            Parent = optionsContainer,
                        })
                        
                        Library.CreateInstance("UICorner", {
                            CornerRadius = UDim.new(0, 4),
                            Parent = optionButton,
                        })
                        
                        -- Check if this option is selected
                        local isSelected = false
                        if Dropdown.MultiSelect then
                            isSelected = Dropdown.SelectedOptions[option] == true
                        else
                            isSelected = Dropdown.Value == option
                        end
                        
                        if isSelected then
                            optionButton.TextColor3 = Color3.fromRGB(120, 180, 255)
                        end
                        
                        optionButton.MouseButton1Click:Connect(function()
                            if Dropdown.MultiSelect then
                                -- Toggle selection
                                if Dropdown.SelectedOptions[option] then
                                    Dropdown.SelectedOptions[option] = nil
                                    optionButton.TextColor3 = Color3.fromRGB(180, 180, 180)
                                else
                                    Dropdown.SelectedOptions[option] = true
                                    optionButton.TextColor3 = Color3.fromRGB(120, 180, 255)
                                end
                                
                                -- Update display text
                                local selectedCount = 0
                                local displayText = ""
                                for opt, _ in pairs(Dropdown.SelectedOptions) do
                                    selectedCount = selectedCount + 1
                                    if selectedCount == 1 then
                                        displayText = opt
                                    elseif selectedCount == 2 then
                                        displayText = displayText .. ", " .. opt
                                    elseif selectedCount == 3 then
                                        local totalSize = getTableSize(Dropdown.SelectedOptions)
                                        displayText = displayText .. " +" .. (totalSize - 2) .. " more"
                                        break
                                    end
                                end
                                
                                if selectedCount == 0 then
                                    currentText.Text = "Select..."
                                else
                                    currentText.Text = displayText
                                end
                                
                                Dropdown.Value = {}
                                for opt, _ in pairs(Dropdown.SelectedOptions) do
                                    table.insert(Dropdown.Value, opt)
                                end
                            else
                                -- Single select - toggle selection
                                if Dropdown.Value == option then
                                    Dropdown.Value = nil
                                    currentText.Text = "Select..."
                                    optionButton.TextColor3 = Color3.fromRGB(180, 180, 180)
                                else
                                    -- Clear any previous selection
                                    if Dropdown.Value then
                                        -- Update previous selection appearance if visible
                                        for _, btn in pairs(optionsContainer:GetChildren()) do
                                            if btn:IsA("TextButton") and btn.Text == Dropdown.Value then
                                                btn.TextColor3 = Color3.fromRGB(180, 180, 180)
                                                break
                                            end
                                        end
                                    end
                                    
                                    Dropdown.Value = option
                                    currentText.Text = option
                                    optionButton.TextColor3 = Color3.fromRGB(120, 180, 255)
                                end
                            end
                            
                            Dropdown.Callback(Dropdown.Value)
                        end)
                        
                        optionButton.MouseEnter:Connect(function()
                            TweenService:Create(optionButton, TweenInfo.new(0.15), {
                                BackgroundTransparency = 0.8,
                                TextColor3 = Color3.fromRGB(220, 220, 220),
                            }):Play()
                        end)
                        
                        optionButton.MouseLeave:Connect(function()
                            local isSelected = Dropdown.MultiSelect and Dropdown.SelectedOptions[option] or Dropdown.Value == option
                            TweenService:Create(optionButton, TweenInfo.new(0.15), {
                                BackgroundTransparency = 1,
                                TextColor3 = isSelected and Color3.fromRGB(120, 180, 255) or Color3.fromRGB(180, 180, 180),
                            }):Play()
                        end)
                    end
                end
                
                -- Function to close dropdown
                local function closeDropdown()
                    if Dropdown.isOpen then
                        Dropdown.isOpen = false
                        
                        if optionsFrame then
                            TweenService:Create(optionsFrame, TweenInfo.new(0.2), {
                                Size = Library.UDim2(0, 85, 0, 0),
                            }):Play()
                            
                            task.wait(0.2)
                            optionsFrame.Visible = false
                        end
                        
                        TweenService:Create(dropdownButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        }):Play()
                        
                        TweenService:Create(dropdownIcon, TweenInfo.new(0.2), {
                            Rotation = 0,
                            ImageColor3 = Color3.fromRGB(180, 180, 180),
                        }):Play()
                        
                        -- Remove from active dropdowns
                        ActiveDropdowns[Dropdown.id] = nil
                        
                        -- Disconnect click outside listener
                        if Dropdown.clickOutsideConnection then
                            Dropdown.clickOutsideConnection:Disconnect()
                            Dropdown.clickOutsideConnection = nil
                        end
                    end
                end
                
                -- Function to open dropdown
                local function openDropdown()
                    -- Close other dropdowns first
                    closeOtherDropdowns(Dropdown.id)
                    
                    Dropdown.isOpen = true
                    
                    -- Create or recreate overlay elements
                    createOverlayElements()
                    updateOptionsDisplay()
                    
                    -- Position the dropdown
                    local buttonPos = dropdownButton.AbsolutePosition
                    local buttonSize = dropdownButton.AbsoluteSize
                    local screenSize = workspace.CurrentCamera.ViewportSize
                    
                    local yPos = buttonPos.Y + buttonSize.Y + 5
                    local frameHeight = optionsFrame.Size.Y.Offset
                    
                    -- Check if goes off screen
                    if yPos + frameHeight > screenSize.Y then
                        yPos = buttonPos.Y - frameHeight - 5
                    end
                    
                    optionsFrame.Position = UDim2.new(0, buttonPos.X, 0, yPos)
                    optionsFrame.Visible = true
                    
                    TweenService:Create(dropdownButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(45, 45, 50),
                    }):Play()
                    
                    TweenService:Create(dropdownIcon, TweenInfo.new(0.2), {
                        Rotation = 180,
                        ImageColor3 = Color3.fromRGB(220, 220, 220),
                    }):Play()
                    
                    -- Add to active dropdowns
                    ActiveDropdowns[Dropdown.id] = {
                        id = Dropdown.id,
                        Close = closeDropdown,
                        Frame = optionsFrame,
                        Button = dropdownButton
                    }
                    
                    -- Set up click outside listener
                    if Dropdown.clickOutsideConnection then
                        Dropdown.clickOutsideConnection:Disconnect()
                    end
                    
                    Dropdown.clickOutsideConnection = UserInputService.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            local mouse = game.Players.LocalPlayer:GetMouse()
                            local framePos = optionsFrame.AbsolutePosition
                            local frameSize = optionsFrame.AbsoluteSize
                            
                            -- Check if click is inside dropdown button or options frame
                            local isInButton = mouse.X >= buttonPos.X and mouse.X <= buttonPos.X + buttonSize.X and
                                               mouse.Y >= buttonPos.Y and mouse.Y <= buttonPos.Y + buttonSize.Y
                            
                            local isInFrame = mouse.X >= framePos.X and mouse.X <= framePos.X + frameSize.X and
                                              mouse.Y >= framePos.Y and mouse.Y <= framePos.Y + frameSize.Y
                            
                            if not isInButton and not isInFrame then
                                closeDropdown()
                            end
                        end
                    end)
                    
                    -- Search functionality
                    if Dropdown.Searchable and searchInput then
                        searchInput:GetPropertyChangedSignal("Text"):Connect(function()
                            updateOptionsDisplay()
                        end)
                    end
                end
                
                -- Function to toggle dropdown
                local function toggleDropdown()
                    if Dropdown.isOpen then
                        closeDropdown()
                    else
                        openDropdown()
                    end
                end
                
                -- Dropdown button click
                dropdownButton.MouseButton1Click:Connect(toggleDropdown)
                
                Dropdown.Elements = {
                    Frame = dropdown,
                    Button = dropdownButton,
                    CurrentText = currentText,
                    Icon = dropdownIcon,
                }
                
                function Dropdown.Set(value)
                    if Dropdown.MultiSelect then
                        Dropdown.SelectedOptions = {}
                        Dropdown.Value = {}
                        for _, opt in ipairs(value) do
                            Dropdown.SelectedOptions[opt] = true
                            table.insert(Dropdown.Value, opt)
                        end
                        
                        -- Update display
                        local selectedCount = 0
                        local displayText = ""
                        for opt, _ in pairs(Dropdown.SelectedOptions) do
                            selectedCount = selectedCount + 1
                            if selectedCount == 1 then
                                displayText = opt
                            elseif selectedCount == 2 then
                                displayText = displayText .. ", " .. opt
                            elseif selectedCount == 3 then
                                local totalSize = getTableSize(Dropdown.SelectedOptions)
                                displayText = displayText .. " +" .. (totalSize - 2) .. " more"
                                break
                            end
                        end
                        
                        currentText.Text = selectedCount > 0 and displayText or "Select..."
                    else
                        Dropdown.Value = value
                        currentText.Text = value or "Select..."
                    end
                    
                    Dropdown.Callback(Dropdown.Value)
                end
                
                function Dropdown.GetValue()
                    return Dropdown.Value
                end
                
                function Dropdown.Refresh(newOptions)
                    Dropdown.Options = newOptions
                    if Dropdown.isOpen then
                        updateOptionsDisplay()
                    end
                end
                
                -- Store close function for external access
                Dropdown.Close = closeDropdown
                
                return Dropdown
            end
            
            return Section
        end
        
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            Tab:Turn(true)
        end
        
        return Tab
    end
    
    -- Store Window elements
    Window.Elements = {
        MainFrame = mainframe,
        MainHolder = theholderdwbbg,
        ContentArea = content,
        TabHolder = tabHolder,
        SearchInput = searchinput,
        SidebarHolder = sidebarHolder,
    }
    
    return Window
end

-- Add alias for CreateWindow
Library.Window = Library.CreateWindow

print("Modern UI Library Loaded Successfully!")
return Library
