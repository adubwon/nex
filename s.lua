-- Modern Roblox UI Library with Glassy Design
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
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
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
    
    -- Sidebar
    local sidebarHolder = Library.CreateInstance("Frame", {
        Name = "SidebarHolder",
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Size = Library.UDim2(0, 155, 1, 0),
        Parent = theholderdwbbg,
    })
    
    Library.CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12, 0, 0),
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
        PlaceholderText = "Search...",
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
    
    -- Content area
    local content = Library.CreateInstance("Frame", {
        Name = "content",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Size = Library.UDim2(1, -155, 1, 0),
        Position = Library.UDim2(0, 155, 0, 0),
        Parent = theholderdwbbg,
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
            
            -- Toggle function
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
                    Size = Library.UDim2(1, 0, 0, 25),
                    Parent = self.Elements.SectionContent,
                })
                
                local toggleLabel = Library.CreateInstance("TextLabel", {
                    Text = Toggle.Name,
                    FontFace = Font.new("rbxassetid://12187365364"),
                    TextColor3 = Color3.fromRGB(115, 115, 115),
                    TextSize = Library.GetScaledTextSize(12),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Position = Library.UDim2(0, 8, 0, 2),
                    Size = Library.UDim2(1, -50, 1, 0),
                    Parent = toggle,
                })
                
                -- Toggle button
                local toggleButton = Library.CreateInstance("TextButton", {
                    Name = "ToggleButton",
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BackgroundTransparency = 0.2,
                    BorderSizePixel = 0,
                    Position = Library.UDim2(1, -8, 0, 2),
                    Size = Library.UDim2(0, 36, 0, 21),
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
                
                -- Toggle knob
                local toggleKnob = Library.CreateInstance("Frame", {
                    Name = "ToggleKnob",
                    BackgroundColor3 = Color3.fromRGB(240, 240, 240),
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    Position = Library.UDim2(0, 3, 0.5, -7),
                    Size = Library.UDim2(0, 14, 0, 14),
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
                    toggleKnob.Position = Library.UDim2(1, -17, 0.5, -7)
                    toggleButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
                    glassStroke.Color = Color3.fromRGB(120, 180, 255)
                    toggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                end
                
                -- Toggle functionality
                toggleButton.MouseButton1Click:Connect(function()
                    Toggle.Value = not Toggle.Value
                    
                    if Toggle.Value then
                        TweenService:Create(toggleKnob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Position = Library.UDim2(1, -17, 0.5, -7),
                        }):Play()
                        
                        TweenService:Create(toggleButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(80, 160, 255),
                        }):Play()
                        
                        TweenService:Create(glassStroke, TweenInfo.new(0.2), {
                            Color = Color3.fromRGB(120, 180, 255),
                        }):Play()
                    else
                        TweenService:Create(toggleKnob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Position = Library.UDim2(0, 3, 0.5, -7),
                        }):Play()
                        
                        TweenService:Create(toggleButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
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
                            BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                        }):Play()
                    end
                end
                
                local function onLeave()
                    TweenService:Create(toggleLabel, TweenInfo.new(0.15), {
                        TextColor3 = Color3.fromRGB(115, 115, 115),
                    }):Play()
                    
                    if not Toggle.Value then
                        TweenService:Create(toggleButton, TweenInfo.new(0.15), {
                            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
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
                    Size = Library.UDim2(1, 0, 0, 20),
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
                    FontFace = Font.new("rbxassetid://12187365364"),
                    Text = Slider.Name,
                    TextColor3 = Color3.fromRGB(115, 115, 115),
                    TextSize = Library.GetScaledTextSize(12),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Position = Library.UDim2(0, 8, 0, 0),
                    Size = Library.UDim2(1, -52, 1, 0),
                    Parent = textHolder,
                })
                
                local thebgofsliderbar = Library.CreateInstance("Frame", {
                    Name = "Thebgofsliderbar",
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = Color3.fromRGB(33, 32, 43),
                    BackgroundTransparency = 1,
                    Position = Library.UDim2(1, -7, 0.5, 0),
                    Size = Library.UDim2(1, -120, 0, 8),
                    Parent = sliderframe,
                })
                
                Library.CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 1),
                    Parent = thebgofsliderbar,
                })
                
                local uIStroke1 = Library.CreateInstance("UIStroke", {
                    Color = Color3.fromRGB(45, 45, 45),
                    Transparency = 0.6,
                    Parent = thebgofsliderbar,
                })
                
                local thesliderbar = Library.CreateInstance("Frame", {
                    Name = "Thesliderbar",
                    BackgroundColor3 = Color3.fromRGB(43, 43, 43),
                    Size = Library.UDim2(0, 0, 1, 0),
                    Parent = thebgofsliderbar,
                })
                
                local uIStroke = Library.CreateInstance("UIStroke", {
                    Color = Color3.fromRGB(38, 38, 36),
                    Parent = thesliderbar,
                })
                
                Library.CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 1),
                    Parent = thesliderbar,
                })
                
                local slidertextbox = Library.CreateInstance("TextBox", {
                    Name = "Slidertextbox",
                    FontFace = Font.new("rbxassetid://12187365364"),
                    Text = "50",
                    TextColor3 = Color3.fromRGB(67, 67, 68),
                    TextSize = Library.GetScaledTextSize(12),
                    TextXAlignment = Enum.TextXAlignment.Right,
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = Library.UDim2(1, 0, 0.5, 0),
                    Size = Library.UDim2(0.5, 0, 1, 4),
                    Parent = thebgofsliderbar,
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
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                    }):Play()
                    
                    TweenService:Create(slidertextbox, hoverTween, {
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                    }):Play()
                end)
                
                sliderframe.MouseLeave:Connect(function()
                    local hoverTween = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    
                    TweenService:Create(slidername, hoverTween, {
                        TextColor3 = Color3.fromRGB(115, 115, 115),
                    }):Play()
                    
                    TweenService:Create(slidertextbox, hoverTween, {
                        TextColor3 = Color3.fromRGB(67, 67, 68),
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
            
            -- Dropdown function
            function Section:Dropdown(Properties)
                if not Properties then Properties = {} end
                
                local Dropdown = {
                    Name = Properties.Name or "Dropdown",
                    Options = Properties.Options or {},
                    Default = Properties.Default,
                    Callback = Properties.Callback or function() end,
                    Value = Properties.Default or nil,
                    Searchable = Properties.Searchable ~= false,
                    isOpen = false,
                    Elements = {},
                }
                
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
                    Text = Dropdown.Default or "Select...",
                    FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium),
                    TextColor3 = Color3.fromRGB(180, 180, 180),
                    TextSize = Library.GetScaledTextSize(11),
                    TextXAlignment = Enum.TextXAlignment.Center,
                    BackgroundTransparency = 1,
                    Position = Library.UDim2(0, 8, 0, 0),
                    Size = Library.UDim2(1, -30, 1, 0),
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
                    Parent = dropdownButton,
                })
                
                -- Dropdown options frame (hidden by default)
                local optionsFrame = Library.CreateInstance("ScrollingFrame", {
                    Name = "OptionsFrame",
                    BackgroundColor3 = Color3.fromRGB(30, 30, 35),
                    BackgroundTransparency = 0.1,
                    BorderSizePixel = 0,
                    ScrollBarThickness = 3,
                    ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65),
                    Position = Library.UDim2(0, 0, 1, 5),
                    Size = Library.UDim2(1, 0, 0, 0),
                    Visible = false,
                    Parent = dropdown,
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
                
                local optionsLayout = Library.CreateInstance("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = optionsFrame,
                })
                
                Library.CreateInstance("UIPadding", {
                    PaddingTop = UDim.new(0, 5),
                    PaddingBottom = UDim.new(0, 5),
                    Parent = optionsFrame,
                })
                
                -- Function to update options
                local function updateOptions()
                    -- Clear existing options
                    for _, child in pairs(optionsFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    -- Add new options
                    for i, option in pairs(Dropdown.Options) do
                        local optionButton = Library.CreateInstance("TextButton", {
                            Text = option,
                            FontFace = Font.new("rbxassetid://12187365364"),
                            TextColor3 = Color3.fromRGB(180, 180, 180),
                            TextSize = Library.GetScaledTextSize(11),
                            BackgroundColor3 = Color3.fromRGB(40, 40, 45),
                            BackgroundTransparency = 1,
                            BorderSizePixel = 0,
                            Size = Library.UDim2(1, -10, 0, 25),
                            Position = Library.UDim2(0, 5, 0, (i-1)*25),
                            Parent = optionsFrame,
                        })
                        
                        Library.CreateInstance("UICorner", {
                            CornerRadius = UDim.new(0, 4),
                            Parent = optionButton,
                        })
                        
                        optionButton.MouseButton1Click:Connect(function()
                            Dropdown.Value = option
                            currentText.Text = option
                            Dropdown.Callback(option)
                            toggleDropdown()
                        end)
                        
                        optionButton.MouseEnter:Connect(function()
                            TweenService:Create(optionButton, TweenInfo.new(0.15), {
                                BackgroundTransparency = 0.8,
                                TextColor3 = Color3.fromRGB(220, 220, 220),
                            }):Play()
                        end)
                        
                        optionButton.MouseLeave:Connect(function()
                            TweenService:Create(optionButton, TweenInfo.new(0.15), {
                                BackgroundTransparency = 1,
                                TextColor3 = Color3.fromRGB(180, 180, 180),
                            }):Play()
                        end)
                    end
                    
                    -- Update options frame size
                    local optionCount = #Dropdown.Options
                    if optionCount > 5 then
                        optionsFrame.Size = Library.UDim2(1, 0, 0, 150)
                        optionsFrame.CanvasSize = UDim2.new(0, 0, 0, optionCount * 25)
                    else
                        optionsFrame.Size = Library.UDim2(1, 0, 0, optionCount * 25 + 10)
                    end
                end
                
                -- Function to toggle dropdown
                local function toggleDropdown()
                    Dropdown.isOpen = not Dropdown.isOpen
                    
                    if Dropdown.isOpen then
                        updateOptions()
                        optionsFrame.Visible = true
                        TweenService:Create(optionsFrame, TweenInfo.new(0.2), {
                            Size = Library.UDim2(1, 0, 0, math.min(150, #Dropdown.Options * 25 + 10)),
                        }):Play()
                        
                        TweenService:Create(dropdownButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(45, 45, 50),
                        }):Play()
                        
                        TweenService:Create(dropdownIcon, TweenInfo.new(0.2), {
                            Rotation = 180,
                            ImageColor3 = Color3.fromRGB(220, 220, 220),
                        }):Play()
                    else
                        TweenService:Create(optionsFrame, TweenInfo.new(0.2), {
                            Size = Library.UDim2(1, 0, 0, 0),
                        }):Play()
                        
                        wait(0.2)
                        optionsFrame.Visible = false
                        
                        TweenService:Create(dropdownButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        }):Play()
                        
                        TweenService:Create(dropdownIcon, TweenInfo.new(0.2), {
                            Rotation = 0,
                            ImageColor3 = Color3.fromRGB(180, 180, 180),
                        }):Play()
                    end
                end
                
                -- Update options on creation
                updateOptions()
                
                -- Dropdown button click
                dropdownButton.MouseButton1Click:Connect(toggleDropdown)
                
                -- Close dropdown when clicking elsewhere
                local connection
                connection = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local mousePos = UserInputService:GetMouseLocation()
                        local buttonPos = dropdownButton.AbsolutePosition
                        local buttonSize = dropdownButton.AbsoluteSize
                        local framePos = optionsFrame.AbsolutePosition
                        local frameSize = optionsFrame.AbsoluteSize
                        
                        local isOverButton = mousePos.X >= buttonPos.X and mousePos.X <= buttonPos.X + buttonSize.X and
                                           mousePos.Y >= buttonPos.Y and mousePos.Y <= buttonPos.Y + buttonSize.Y
                        
                        local isOverFrame = mousePos.X >= framePos.X and mousePos.X <= framePos.X + frameSize.X and
                                           mousePos.Y >= framePos.Y and mousePos.Y <= framePos.Y + frameSize.Y
                        
                        if Dropdown.isOpen and not isOverButton and not isOverFrame then
                            toggleDropdown()
                        end
                    end
                end)
                
                -- Clean up connection when dropdown is destroyed
                dropdown.Destroying:Connect(function()
                    if connection then
                        connection:Disconnect()
                    end
                end)
                
                -- Hover effects
                dropdownButton.MouseEnter:Connect(function()
                    TweenService:Create(dropdownButton, TweenInfo.new(0.15), {
                        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    }):Play()
                    
                    TweenService:Create(dropdownname, TweenInfo.new(0.15), {
                        TextColor3 = Color3.fromRGB(180, 180, 180),
                    }):Play()
                end)
                
                dropdownButton.MouseLeave:Connect(function()
                    if not Dropdown.isOpen then
                        TweenService:Create(dropdownButton, TweenInfo.new(0.15), {
                            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        }):Play()
                        
                        TweenService:Create(dropdownname, TweenInfo.new(0.15), {
                            TextColor3 = Color3.fromRGB(150, 150, 150),
                        }):Play()
                    end
                end)
                
                Dropdown.Elements = {
                    Frame = dropdown,
                    Button = dropdownButton,
                    CurrentText = currentText,
                    Icon = dropdownIcon,
                    Label = dropdownname,
                    OptionsFrame = optionsFrame,
                }
                
                function Dropdown.Set(value)
                    Dropdown.Value = value
                    currentText.Text = value or "Select..."
                    Dropdown.Callback(value)
                end
                
                function Dropdown.GetValue()
                    return Dropdown.Value
                end
                
                function Dropdown.Refresh(newOptions)
                    Dropdown.Options = newOptions
                    updateOptions()
                end
                
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
