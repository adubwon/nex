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

-- Main Window Creation function (standalone, not a method)
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
        Size = Library.UDim2(0, 150, 1, 0),
        Parent = theholderdwbbg,
    })
    
    Library.CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12, 0, 0),
        Parent = sidebarHolder,
    })
    
    -- Tab holder
    local anothersidebarholder = Library.CreateInstance("Frame", {
        Name = "TabHolder",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = Library.UDim2(0, 0, 0, 40),
        Size = Library.UDim2(1, 0, 1, -40),
        Parent = sidebarHolder,
    })
    
    local tabHolder = Library.CreateInstance("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = Library.UDim2(1, 0, 1, 0),
        Parent = anothersidebarholder,
    })
    
    Library.CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tabHolder,
    })
    
    Library.CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = tabHolder,
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
    
    -- Sidebar border
    Library.CreateInstance("Frame", {
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
        Size = Library.UDim2(1, -150, 1, 0),
        Parent = theholderdwbbg,
    })
    
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
        
        -- Tab button
        local atab = Library.CreateInstance("TextButton", {
            Name = "TabButton",
            Text = "",
            AutoButtonColor = false,
            BackgroundColor3 = Color3.fromRGB(39, 39, 42),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = Library.UDim2(1, -20, 0, 29),
            Parent = self.Elements.TabHolder,
        })
        
        Library.CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = atab,
        })
        
        local uIStroke = Library.CreateInstance("UIStroke", {
            Color = Color3.fromRGB(31, 31, 34),
            Enabled = false,
            Parent = atab,
        })
        
        local tabContent = Library.CreateInstance("ScrollingFrame", {
            Name = "TabContent_" .. Tab.Name,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 0,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = Library.UDim2(0, 10, 0, 1),
            Size = Library.UDim2(1, -20, 1, -10),
            Visible = false,
            Parent = self.Elements.ContentArea,
        })
        
        Library.CreateInstance("UIListLayout", {
            Padding = UDim.new(0, 16),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = tabContent,
        })
        
        Library.CreateInstance("UIPadding", {
            PaddingTop = UDim.new(0, 12),
            Parent = tabContent,
        })
        
        local tabIcon
        if Tab.Icon then
            tabIcon = Library.CreateInstance("ImageLabel", {
                Image = Tab.Icon,
                ImageColor3 = Color3.fromRGB(115, 115, 115),
                BackgroundTransparency = 1,
                Size = Library.UDim2(0, 12, 0, 12),
                LayoutOrder = 1,
                Parent = atab,
            })
        end
        
        local tabName = Library.CreateInstance("TextLabel", {
            Text = Tab.Name,
            FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
            TextColor3 = Color3.fromRGB(115, 115, 115),
            TextSize = Library.GetScaledTextSize(12),
            BackgroundTransparency = 1,
            Size = Library.UDim2(0, 0, 1, 0),
            Parent = atab,
        })
        
        tabName.AutomaticSize = Enum.AutomaticSize.X
        
        Library.CreateInstance("UIListLayout", {
            Padding = UDim.new(0, 10),
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Parent = atab,
        })
        
        Library.CreateInstance("UIPadding", {
            PaddingLeft = UDim.new(0, 8),
            Parent = atab,
        })
        
        -- Tab functions
        function Tab:Turn(bool)
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
        
        -- Section creation function for this tab
        function Tab:Section(Properties)
            if not Properties then Properties = {} end
            
            local Section = {
                Name = Properties.Name or "Section",
                Tab = self,
                Side = Properties.Side or "Left",
                Elements = {},
                Content = {},
                ShowTitle = Properties.ShowTitle ~= false,
            }
            
            -- Create side containers if they don't exist
            if not self.Elements[Section.Side] then
                local sideContainer = Library.CreateInstance("Frame", {
                    Name = Section.Side .. "Container",
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = Library.UDim2(1, 0, 0, 0),
                    Parent = self.Elements.Content,
                })
                
                Library.CreateInstance("UIListLayout", {
                    Padding = UDim.new(0, 13),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = sideContainer,
                })
                
                self.Elements[Section.Side] = sideContainer
            end
            
            -- Section frame
            local section = Library.CreateInstance("Frame", {
                Name = "Section",
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Color3.fromRGB(17, 17, 17),
                BackgroundTransparency = 0.4,
                BorderSizePixel = 0,
                Size = Library.UDim2(1, 0, 0, 0),
                Parent = self.Elements[Section.Side],
            })
            
            Library.CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = section,
            })
            
            Library.CreateInstance("UIStroke", {
                Color = Color3.fromRGB(45, 45, 45),
                Transparency = 0.4,
                Parent = section,
            })
            
            Library.CreateInstance("UIListLayout", {
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = section,
            })
            
            Library.CreateInstance("UIPadding", {
                PaddingTop = UDim.new(0, 5),
                PaddingBottom = UDim.new(0, 12),
                Parent = section,
            })
            
            -- Title
            if Section.ShowTitle then
                local titleFrame = Library.CreateInstance("Frame", {
                    BackgroundTransparency = 1,
                    Size = Library.UDim2(1, 0, 0, 22),
                    LayoutOrder = 0,
                    Parent = section,
                })
                
                local title = Library.CreateInstance("TextLabel", {
                    Text = Section.Name,
                    FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
                    TextColor3 = Color3.fromRGB(221, 221, 221),
                    TextSize = Library.GetScaledTextSize(14),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Position = Library.UDim2(0, 8, 0, 0),
                    Size = Library.UDim2(1, -16, 0, 25),
                    Parent = titleFrame,
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
            
            Library.CreateInstance("UIListLayout", {
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = aholder,
            })
            
            Library.CreateInstance("UIPadding", {
                PaddingLeft = UDim.new(0, 3),
                PaddingRight = UDim.new(0, 3),
                PaddingTop = UDim.new(0, 3),
                PaddingBottom = UDim.new(0, 3),
                Parent = aholder,
            })
            
            Section.Elements.SectionFrame = section
            Section.Elements.SectionContent = aholder
            
            -- Toggle creation function for this section
            function Section:Toggle(Properties)
                if not Properties then Properties = {} end
                
                local Toggle = {
                    Name = Properties.Name or "Toggle",
                    Default = Properties.Default or false,
                    Callback = Properties.Callback or function() end,
                    Value = Properties.Default or false,
                    Elements = {},
                }
                
                local toggle = Library.CreateInstance("Frame", {
                    Name = "Toggle",
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
                
                -- Toggle button with glass effect
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
                
                -- Glass effect
                Library.CreateInstance("Frame", {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.9,
                    BorderSizePixel = 0,
                    Size = Library.UDim2(1, 0, 1, 0),
                    Parent = toggleButton,
                })
                
                -- Rounded corners
                Library.CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = toggleButton,
                })
                
                Library.CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = toggleButton:FindFirstChild("Frame") or Instance.new("Frame"),
                })
                
                -- Glass border
                local glassStroke = Library.CreateInstance("UIStroke", {
                    Color = Color3.fromRGB(255, 255, 255),
                    Transparency = 0.8,
                    Thickness = 1,
                    Parent = toggleButton,
                })
                
                -- Toggle knob (circle that moves)
                local toggleKnob = Library.CreateInstance("Frame", {
                    Name = "ToggleKnob",
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.3,
                    BorderSizePixel = 0,
                    Position = Library.UDim2(0, 2, 0.5, -8),
                    Size = Library.UDim2(0, 16, 0, 16),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Parent = toggleButton,
                })
                
                -- Knob corner
                Library.CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = toggleKnob,
                })
                
                -- Check mark (appears when toggled on)
                local checkMark = Library.CreateInstance("ImageLabel", {
                    Image = "rbxassetid://7072706620",
                    ImageColor3 = Color3.fromRGB(0, 255, 100),
                    ImageTransparency = 1,
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = Library.UDim2(1, -5, 0.5, 0),
                    Size = Library.UDim2(0, 14, 0, 14),
                    Parent = toggleButton,
                })
                
                -- Set initial state
                if Toggle.Value then
                    toggleKnob.Position = Library.UDim2(1, -19, 0.5, -8)
                    checkMark.ImageTransparency = 0
                    glassStroke.Color = Color3.fromRGB(100, 100, 255)
                    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                end
                
                -- Toggle functionality
                toggleButton.MouseButton1Click:Connect(function()
                    Toggle.Value = not Toggle.Value
                    
                    if Toggle.Value then
                        -- Move knob to right
                        TweenService:Create(toggleKnob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Position = Library.UDim2(1, -19, 0.5, -8),
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
                    else
                        -- Move knob to left
                        TweenService:Create(toggleKnob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Position = Library.UDim2(0, 2, 0.5, -8),
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
                    end
                    
                    -- Callback
                    Toggle.Callback(Toggle.Value)
                end)
                
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
            
            -- Dropdown creation function for this section
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
                    Name = "Dropdown",
                    BackgroundTransparency = 1,
                    Size = Library.UDim2(1, 0, 0, 25),
                    Parent = self.Elements.SectionContent,
                })
                
                local dropdownname = Library.CreateInstance("TextLabel", {
                    Text = Dropdown.Name,
                    FontFace = Font.new("rbxassetid://12187365364"),
                    TextColor3 = Color3.fromRGB(115, 115, 115),
                    TextSize = Library.GetScaledTextSize(12),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Position = Library.UDim2(0, 8, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = Library.UDim2(1, -12, 0, 15),
                    Parent = dropdown,
                })
                
                -- Dropdown button with glass effect
                local dropdownButton = Library.CreateInstance("TextButton", {
                    Name = "DropdownButton",
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BackgroundTransparency = 0.2,
                    BorderSizePixel = 0,
                    Position = Library.UDim2(1, -7, 0.5, 0),
                    Size = Library.UDim2(0, 80, 0, 21),
                    Parent = dropdown,
                })
                
                -- Glass effect
                Library.CreateInstance("Frame", {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.9,
                    BorderSizePixel = 0,
                    Size = Library.UDim2(1, 0, 1, 0),
                    Parent = dropdownButton,
                })
                
                -- Corners
                Library.CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = dropdownButton,
                })
                
                -- Glass border
                Library.CreateInstance("UIStroke", {
                    Color = Color3.fromRGB(255, 255, 255),
                    Transparency = 0.8,
                    Thickness = 1,
                    Parent = dropdownButton,
                })
                
                -- Current selection text
                local currentText = Library.CreateInstance("TextLabel", {
                    Text = Dropdown.Default or "...",
                    FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
                    TextColor3 = Color3.fromRGB(115, 115, 115),
                    TextSize = Library.GetScaledTextSize(12),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Position = Library.UDim2(0, 8, 0, 0),
                    Size = Library.UDim2(1, -30, 1, 0),
                    Parent = dropdownButton,
                })
                
                -- Dropdown icon
                local dropdownIcon = Library.CreateInstance("ImageLabel", {
                    Image = "rbxassetid://115894980866040",
                    ImageColor3 = Color3.fromRGB(44, 44, 41),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Position = Library.UDim2(1, -12, 0.5, 0),
                    Size = Library.UDim2(0, 14, 0, 14),
                    Parent = dropdownButton,
                })
                
                Dropdown.Elements = {
                    Frame = dropdown,
                    Button = dropdownButton,
                    CurrentText = currentText,
                    Icon = dropdownIcon,
                }
                
                function Dropdown.Set(value)
                    Dropdown.Value = value
                    currentText.Text = value or "..."
                    Dropdown.Callback(value)
                end
                
                function Dropdown.GetValue()
                    return Dropdown.Value
                end
                
                function Dropdown.Refresh(newOptions)
                    Dropdown.Options = newOptions
                    -- Implementation for refreshing dropdown options
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
