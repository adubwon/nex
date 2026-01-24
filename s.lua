
-- Initialize Library with custom glassy theme
Library = {
    Open = true,
    Tabs = {},
    Accent = Color3.fromRGB(100, 200, 255), -- Cool cyan-blue accent
    Sections = {},
    Flags = {},
    Callbacks = {},
    Elements = {},
    UnNamedFlags = 0,
    Blurframe = nil,
    mainframe = nil,
    CurrentOpenDropdown = nil,
    DropdownActive = false,
    Dependencies = {},

    ThemeObjects = {},
    Holder = nil,
    Keys = {
        [Enum.KeyCode.LeftShift] = "LShift",
        [Enum.KeyCode.Insert] = "Insert",
        [Enum.KeyCode.RightShift] = "RShift",
        [Enum.KeyCode.LeftControl] = "LCtrl",
        [Enum.KeyCode.RightControl] = "RCtrl",
        [Enum.KeyCode.LeftAlt] = "LAlt",
        [Enum.KeyCode.RightAlt] = "RAlt",
        [Enum.KeyCode.CapsLock] = "Caps",
        [Enum.KeyCode.One] = "1",
        [Enum.KeyCode.Two] = "2",
        [Enum.KeyCode.Three] = "3",
        [Enum.KeyCode.Four] = "4",
        [Enum.KeyCode.Five] = "5",
        [Enum.KeyCode.Six] = "6",
        [Enum.KeyCode.Seven] = "7",
        [Enum.KeyCode.Eight] = "8",
        [Enum.KeyCode.Nine] = "9",
        [Enum.KeyCode.Zero] = "0",
        [Enum.KeyCode.KeypadOne] = "Num1",
        [Enum.KeyCode.KeypadTwo] = "Num2",
        [Enum.KeyCode.KeypadThree] = "Num3",
        [Enum.KeyCode.KeypadFour] = "Num4",
        [Enum.KeyCode.KeypadFive] = "Num5",
        [Enum.KeyCode.KeypadSix] = "Num6",
        [Enum.KeyCode.KeypadSeven] = "Num7",
        [Enum.KeyCode.KeypadEight] = "Num8",
        [Enum.KeyCode.KeypadNine] = "Num9",
        [Enum.KeyCode.KeypadZero] = "Num0",
        [Enum.KeyCode.Minus] = "-",
        [Enum.KeyCode.Equals] = "=",
        [Enum.KeyCode.Tilde] = "~",
        [Enum.KeyCode.LeftBracket] = "[",
        [Enum.KeyCode.RightBracket] = "]",
        [Enum.KeyCode.RightParenthesis] = ")",
        [Enum.KeyCode.LeftParenthesis] = "(",
        [Enum.KeyCode.Semicolon] = ",",
        [Enum.KeyCode.Quote] = "'",
        [Enum.KeyCode.BackSlash] = "\\",
        [Enum.KeyCode.Comma] = ",",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Slash] = "/",
        [Enum.KeyCode.Asterisk] = "*",
        [Enum.KeyCode.Plus] = "+",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Backquote] = "`",
        [Enum.UserInputType.MouseButton1] = "MB1",
        [Enum.UserInputType.MouseButton2] = "MB2",
        [Enum.UserInputType.MouseButton3] = "MB3",
    },

    Connections = {},
    connections = {},
    UIKey = Enum.KeyCode.Insert,
    ScreenGUI = nil,
    Fontsize = 12,
}


local Path = game:GetService("RunService"):IsStudio() and game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") or game:GetService("CoreGui")

function Library.Disconnect(self, Connection)
	if (Connection) then
		Connection:Disconnect()
	end
end

Library.Subtabs = {}
setmetatable(Library.Subtabs, { __index = Library.Tabs })

Library.__index = Library
Library.Tabs.__index = Library.Tabs
Library.Sections.__index = Library.Sections
local LocalPlayer = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Mouse = LocalPlayer:GetMouse()

function Library:ChangeAccent(Color)
    self.Accent = Color

    for obj in pairs(self.ThemeObjects) do
        if not obj or not obj.Parent then return end

        if obj:IsA("Frame") or obj:IsA("TextButton") and obj.BackgroundTransparency < 1 then
            obj.BackgroundColor3 = Color
        elseif obj:IsA("TextLabel") then
            obj.TextColor3 = Color
        elseif obj:IsA("TextButton") and obj.BackgroundTransparency == 1 then
            obj.TextColor3 = Color
        elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
            obj.ImageColor3 = Color
        elseif obj:IsA("UIStroke") then
            obj.Color = self:GetStrokeColor()
        end
    end

    local accentHex = Color:ToHex()
    local strokeHex = self:GetStrokeColor():ToHex()

    local function track(obj)
        if not obj or not obj:IsA("Instance") then return end

        if obj:IsA("UIStroke") and obj.Color:ToHex() == strokeHex then
            self.ThemeObjects[obj] = obj
        elseif (obj:IsA("Frame") or obj:IsA("TextButton")) and obj.BackgroundTransparency < 1 and obj.BackgroundColor3:ToHex() == accentHex then
            self.ThemeObjects[obj] = obj
        elseif (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.TextColor3:ToHex() == accentHex then
            self.ThemeObjects[obj] = obj
        elseif (obj:IsA("ImageLabel") or obj:IsA("ImageButton")) and obj.ImageColor3:ToHex() == accentHex then
            self.ThemeObjects[obj] = obj
        end
    end

    for _, tab in pairs(self.Tabs) do
        if type(tab) == "table" and tab.Elements then
            for _, el in pairs(tab.Elements) do
                if type(el) == "table" and el.Holder and typeof(el.Holder) == "Instance" then
                    for _, obj in ipairs(el.Holder:GetDescendants()) do
                        track(obj)
                    end
                end
            end
        end
    end

    for _, tab in pairs(self.Subtabs) do
        if type(tab) == "table" and tab.Elements then
            for _, el in pairs(tab.Elements) do
                if type(el) == "table" and el.Holder and typeof(el.Holder) == "Instance" then
                    for _, obj in ipairs(el.Holder:GetDescendants()) do
                        track(obj)
                    end
                end
            end
        end
    end
end


function Library.Round(self, Number, Float)
	return Float * math.floor(Number / Float)
end

function Library.ReturnMaxChars(self)
	local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	-- mobile max 7, desktop max 11
	return isMobile and 7 or 11
end

function Library.GetCharsFromTable(self, tbl)
    local totalChars = 0
    
    if (type(tbl) == "table") then
        if (#tbl == 0) then
            return totalChars
        end
        
        for _, str in pairs(tbl) do
            totalChars = totalChars + #tostring(str)
        end
    else
        totalChars = #tostring(tbl)
    end
    
    return totalChars
end

function Library.NextFlag()
	Library.UnNamedFlags = Library.UnNamedFlags + 1
	return string.format("%.14g", Library.UnNamedFlags)
end

function Library.CheckDependencies(element)
	if not element or not element.Depends then
		return true
	end
	
	for flag, requiredValue in pairs(element.Depends) do
		local currentValue = Library.Flags[flag]
		
		-- Handle different types of dependency checks
		if type(requiredValue) == "table" then
			-- Handle table-based requirements
			if requiredValue.contains then
				-- Check if currentValue (table) contains any of the required values
				if type(currentValue) ~= "table" then
					return false
				end
				
				local hasRequired = false
				for _, reqVal in ipairs(requiredValue.contains) do
					for _, curVal in ipairs(currentValue) do
						if curVal == reqVal then
							hasRequired = true
							break
						end
					end
					if hasRequired then break end
				end
				
				if not hasRequired then
					return false
				end
			elseif requiredValue.excludes then
				-- Check if currentValue does NOT contain any of the excluded values
				-- Handle single string values first
				if type(currentValue) == "string" then
					for _, excludeVal in ipairs(requiredValue.excludes) do
						if currentValue == excludeVal then
							return false -- Found an excluded value, fail the check
						end
					end
					-- Continue checking other dependencies - don't return true here
				elseif type(currentValue) == "table" then
					-- Handle table values
					for _, excludeVal in ipairs(requiredValue.excludes) do
						for _, curVal in ipairs(currentValue) do
							if curVal == excludeVal then
								return false -- Found an excluded value, fail the check
							end
						end
					end
					-- Continue checking other dependencies - don't return true here
				end
				-- If currentValue is neither string nor table, continue checking other dependencies
			elseif requiredValue.containsAll then
				-- Check if currentValue (table) contains all of the required values
				if type(currentValue) ~= "table" then
					return false
				end
				
				for _, reqVal in ipairs(requiredValue.containsAll) do
					local found = false
					for _, curVal in ipairs(currentValue) do
						if curVal == reqVal then
							found = true
							break
						end
					end
					if not found then
						return false
					end
				end
			else
				-- Direct table comparison
				if currentValue ~= requiredValue then
					return false
				end
			end
		elseif type(requiredValue) == "function" then
			-- Handle function-based requirements for custom logic
			if not requiredValue(currentValue) then
				return false
			end
		else
			-- Handle simple value comparison
			if currentValue ~= requiredValue then
				return false
			end
		end
	end
	
	return true
end

function Library.UpdateElementVisibility(element)
	if not element then return end
	
	local shouldShow = Library.CheckDependencies(element)
	if element.SetVisible then
		element:SetVisible(shouldShow)
	end
end

function Library.UpdateAllDependencies()
	for flag, element in pairs(Library.Elements) do
		if element.Depends then
			Library.UpdateElementVisibility(element)
		end
	end
end

function Library.SetFlag(flag, value)
	Library.Flags[flag] = value
	
	-- Update dependencies when a flag changes
	Library.UpdateAllDependencies()
	
	-- Call the callback if it exists
	if Library.Callbacks[flag] then
		Library.Callbacks[flag](value)
	end
end

function Library.InitializeAllDependencies()
	-- Wait a moment for all elements to be created, then update all dependencies
	task.spawn(function()
		task.wait(0.2)
		Library.UpdateAllDependencies()
	end)
end

function Library.GetConfig(self)
	local Config = ""
    for Index, Value in pairs(self.Flags) do
        local element = Library.Elements[Index]
        local isButton = element and (element.IsButton or element.Name == "Button" or Index:find("Button"))
        if (Index ~= "ConfigConfig_List" and Index ~= "ConfigConfig_Load" and Index ~= "ConfigConfig_Save" and Index ~= "ConfigName" and Index ~= "ConfigList" and not isButton and typeof(Value) ~= "function") then
			local Value2 = Value
			local Final = ""

			if (typeof(Value2) == "Color3") then
				local hue, sat, val = Value2:ToHSV()
				Final = ("rgb(%s,%s,%s,%s)"):format(tostring(hue), tostring(sat), tostring(val), tostring(1))
			elseif (typeof(Value2) == "table" and Value2.Color and Value2.Transparency) then
				local hue, sat, val = Value2.Color:ToHSV()
				Final = ("rgb(%s,%s,%s,%s)"):format(tostring(hue), tostring(sat), tostring(val), tostring(Value2.Transparency))
			elseif (typeof(Value2) == "table" and Value.Mode) then
				local Values = Value.current
				Final = ("key(%s,%s,%s)"):format(Values[1] or "nil", Values[2] or "nil", Value.Mode)
			elseif (Value2 ~= nil) then
				if (typeof(Value2) == "boolean") then
					Value2 = ("bool(%s)"):format(tostring(Value2))
				elseif (typeof(Value2) == "table") then
					local New = "table("
					for Index2, Value3 in pairs(Value2) do
						New = New .. Value3 .. ","
					end
					if (New:sub(#New) == ",") then
						New = New:sub(0, #New - 1)
					end
					Value2 = New .. ")"
				elseif (typeof(Value2) == "string") then
					Value2 = ("string(%s)"):format(Value2)
				elseif (typeof(Value2) == "number") then
					Value2 = ("number(%s)"):format(tostring(Value2))
				end
				Final = Value2
			end
			Config = Config .. Index .. ": " .. tostring(Final) .. "\n"
		end
	end
	return Config
end

function Library.LoadConfig(self, Config)
	if not (Config and type(Config) == "string" and Config:len() > 0) then
		return
	end
	
	local Table = string.split(Config, "\n")

	for Index, Value in pairs(Table) do
		local Table3 = string.split(Value, ":")

		if (#Table3 >= 2) then
			local flagName = Table3[1]
			local flagValue = Table3[2]:sub(2) 

			local element = Library.Elements[flagName]
			local isButton = element and (element.IsButton or element.Name == "Button" or flagName:find("Button"))
			local isFunction = typeof(Library.Flags[flagName]) == "function"
			
			if (flagName == "ConfigConfig_List" or flagName == "ConfigConfig_Load" or flagName == "ConfigConfig_Save" or flagName == "ConfigName" or flagName == "ConfigList" or isButton or isFunction) then
				return
			end

			if (flagValue:sub(1, 3) == "rgb") then
				local values = string.split(flagValue:sub(5, #flagValue - 1), ",")
				if (#values >= 3) then
					local h, s, v, a = tonumber(values[1]), tonumber(values[2]), tonumber(values[3]), tonumber(values[4])
					if (h and s and v) then
						flagValue = Color3.fromHSV(h, s, v)
					end
				end
			elseif (flagValue:sub(1, 3) == "key") then
				local values = string.split(flagValue:sub(5, #flagValue - 1), ",")
				if (values[1] == "nil") then
					values[1] = nil
				end
				if (values[2] == "nil") then
					values[2] = nil
				end
				flagValue = values
			elseif (flagValue:sub(1, 4) == "bool") then
				flagValue = flagValue:sub(6, #flagValue - 1) == "true"
			elseif (flagValue:sub(1, 5) == "table") then
				local tableStr = flagValue:sub(7, #flagValue - 1)
				if (tableStr == "") then
					flagValue = {}
				else
					flagValue = string.split(tableStr, ",")
				end
			elseif (flagValue:sub(1, 6) == "string") then
				flagValue = flagValue:sub(8, #flagValue - 1)
			elseif (flagValue:sub(1, 6) == "number") then
				flagValue = tonumber(flagValue:sub(8, #flagValue - 1))
			elseif (flagValue:sub(1, 4) == "enum") then
				local enumStr = flagValue:sub(6, #flagValue - 1)
				for keyName, keyCode in pairs(Library.Keys) do
					if (tostring(keyName) == enumStr) then
						flagValue = keyName
						break
					end
				end
			end

            Library.Flags[flagName] = flagValue
            if (element and element.Set and not isButton) then
                element:Set(flagValue)
            end
        end
	end
end

function Library.IsMouseOverFrame(self, Frame)
	local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize

	if (Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y) then
		return true
	end

	return false
end

function Library.Coonnection(self, Signal, Callback)
	local Con = Signal:Connect(Callback)
	return Con
end

function Library.connection(self, signal, callback)
	local connection = signal:Connect(callback)
	table.insert(Library.connections, connection)
	return connection
end

function Library.GetStrokeColor(self, brightFactor)
	brightFactor = brightFactor or 1.15

	return Color3.new(
		math.min(Library.Accent.R * brightFactor, 1),
		math.min(Library.Accent.G * brightFactor, 1),
		math.min(Library.Accent.B * brightFactor, 1)
	)
end

local Tabs = Library.Tabs
local Sections = Library.Sections

function Library.MakeDraggable(self, topbarobject, object)
    local Dragging = false
    local DragInput
    local DragStart
    local StartPosition
    
    local function Update(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
        object.Position = pos
    end
    
    topbarobject.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            
            input.Changed:Connect(function()
                if (input.UserInputState == Enum.UserInputState.End) then
                    Dragging = false
                end
            end)
        end
    end)
    
    topbarobject.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            DragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if (input == DragInput and Dragging) then
            Update(input)
        end
    end)
end

function Library.Window(self, Options)
    local Window = {
        Tabs = {},
        Name = Options.Name or "GlassUI",
        Key = Options.Key,
        Logo = Options.Logo,
        Sections = {},
        Elements = {},
        Dragging = { false, UDim2.new(0, 0, 0, 0) },
    }

    if (Window.Key and Window.Key ~= "GlassUIKey123") then 
        return 
    end

    -- Create the main GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GlassUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    -- Main glass container
    local mainContainer = Instance.new("Frame", ScreenGui)
    mainContainer.Name = "MainContainer"
    mainContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    mainContainer.BackgroundTransparency = 0.15
    mainContainer.BorderSizePixel = 0
    mainContainer.ClipsDescendants = true

    -- Glass overlay effect
    local glassOverlay = Instance.new("ImageLabel")
    glassOverlay.Name = "GlassOverlay"
    glassOverlay.Image = "rbxassetid://13180452117" -- Use a glass texture
    glassOverlay.ImageTransparency = 0.85
    glassOverlay.ScaleType = Enum.ScaleType.Tile
    glassOverlay.TileSize = UDim2.fromOffset(200, 200)
    glassOverlay.BackgroundTransparency = 1
    glassOverlay.Size = UDim2.fromScale(1, 1)
    
    local glassGradient = Instance.new("UIGradient")
    glassGradient.Rotation = 45
    glassGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 255))
    })
    glassGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(1, 0.95)
    })
    glassGradient.Parent = glassOverlay
    
    glassOverlay.Parent = mainContainer

    -- Main content area
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.BackgroundTransparency = 1
    contentArea.Size = UDim2.fromScale(1, 1)
    contentArea.Parent = mainContainer

    -- Sidebar with glass effect
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    sidebar.BackgroundTransparency = 0.3
    sidebar.Size = UDim2.new(0, 180, 1, 0)
    sidebar.Parent = contentArea

    local sidebarGlass = Instance.new("ImageLabel")
    sidebarGlass.Name = "SidebarGlass"
    sidebarGlass.Image = "rbxassetid://13180452117"
    sidebarGlass.ImageTransparency = 0.9
    sidebarGlass.ScaleType = Enum.ScaleType.Tile
    sidebarGlass.TileSize = UDim2.fromOffset(150, 150)
    sidebarGlass.BackgroundTransparency = 1
    sidebarGlass.Size = UDim2.fromScale(1, 1)
    
    local sidebarGradient = Instance.new("UIGradient")
    sidebarGradient.Color = ColorSequence.new(Color3.fromRGB(100, 100, 120))
    sidebarGradient.Transparency = NumberSequence.new(0.92)
    sidebarGradient.Parent = sidebarGlass
    
    sidebarGlass.Parent = sidebar

    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    titleBar.BackgroundTransparency = 0.4
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Parent = sidebar

    Library:MakeDraggable(titleBar, mainContainer)

    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Font = Enum.Font.GothamBold
    titleText.Text = Window.Name
    titleText.TextColor3 = Color3.fromRGB(220, 220, 255)
    titleText.TextSize = 18
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.BackgroundTransparency = 1
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.Size = UDim2.new(1, -30, 1, 0)
    titleText.Parent = titleBar

    -- Tab buttons container
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Name = "TabContainer"
    tabContainer.BackgroundTransparency = 1
    tabContainer.ScrollBarThickness = 0
    tabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabContainer.Position = UDim2.new(0, 0, 0, 45)
    tabContainer.Size = UDim2.new(1, 0, 1, -45)
    tabContainer.Parent = sidebar

    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.Name = "TabListLayout"
    tabListLayout.Padding = UDim.new(0, 8)
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Parent = tabContainer

    local tabPadding = Instance.new("UIPadding")
    tabPadding.Name = "TabPadding"
    tabPadding.PaddingLeft = UDim.new(0, 10)
    tabPadding.PaddingTop = UDim.new(0, 10)
    tabPadding.Parent = tabContainer

    -- Content frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.BackgroundTransparency = 1
    contentFrame.Position = UDim2.new(0, 185, 0, 0)
    contentFrame.Size = UDim2.new(1, -185, 1, 0)
    contentFrame.Parent = contentArea

    -- Setup resize functionality
    function Library.Resize(self, object)
        local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
        
        local resizeHandle = Instance.new("Frame")
        resizeHandle.Name = "ResizeHandle"
        resizeHandle.Position = UDim2.new(1, -20, 1, -20)
        resizeHandle.Size = UDim2.new(0, 20, 0, 20)
        resizeHandle.BackgroundTransparency = 1
        resizeHandle.ZIndex = 100
        resizeHandle.Parent = object
        
        local resizeIcon = Instance.new("ImageLabel")
        resizeIcon.Name = "ResizeIcon"
        resizeIcon.Image = "rbxassetid://7072716619"
        resizeIcon.ImageColor3 = Color3.fromRGB(150, 150, 180)
        resizeIcon.ImageTransparency = 0.5
        resizeIcon.Size = UDim2.fromScale(1, 1)
        resizeIcon.BackgroundTransparency = 1
        resizeIcon.Parent = resizeHandle
        
        local resizing = false
        local startPos = nil
        local startSize = nil
        
        local function updateSize(inputPos)
            if not startPos or not startSize then return end
            
            local deltaX = inputPos.X - startPos.X
            local deltaY = inputPos.Y - startPos.Y
            
            local viewport = workspace.CurrentCamera.ViewportSize
            local minWidth = isMobile and math.max(185, viewport.X * 0.4) or 550
            local minHeight = isMobile and math.max(65, viewport.Y * 0.3) or 400
            local maxWidth = isMobile and viewport.X * 0.98 or viewport.X * 0.9
            local maxHeight = isMobile and viewport.Y * 0.95 or viewport.Y * 0.9
            
            local newWidth = math.clamp(startSize.X.Offset + deltaX, minWidth, maxWidth)
            local newHeight = math.clamp(startSize.Y.Offset + deltaY, minHeight, maxHeight)
            
            object.Size = UDim2.new(startSize.X.Scale, newWidth, startSize.Y.Scale, newHeight)
        end
        
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            local inputPos = input.Position
            local handlePos = resizeHandle.AbsolutePosition
            local handleSize = resizeHandle.AbsoluteSize
            
            local inBounds = inputPos.X >= handlePos.X and inputPos.X <= handlePos.X + handleSize.X and
                           inputPos.Y >= handlePos.Y and inputPos.Y <= handlePos.Y + handleSize.Y
            
            if inBounds and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                resizing = true
                startPos = input.Position
                startSize = object.Size
                
                TweenService:Create(resizeIcon, TweenInfo.new(0.2), {
                    ImageColor3 = Library.Accent,
                    ImageTransparency = 0.3
                }):Play()
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input, gameProcessed)
            if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSize(input.Position)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input, gameProcessed)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and resizing then
                resizing = false
                startPos = nil
                startSize = nil
                
                TweenService:Create(resizeIcon, TweenInfo.new(0.2), {
                    ImageColor3 = Color3.fromRGB(150, 150, 180),
                    ImageTransparency = 0.5
                }):Play()
            end
        end)
    end

    -- Window sizing and positioning
    local function calculateWindowSize()
        local viewportSize = workspace.CurrentCamera.ViewportSize
        local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

        local width, height
        if isMobile then
            width = math.min(viewportSize.X * 0.9, 500)
            height = math.min(viewportSize.Y * 0.85, 600)
        else
            width = 800
            height = 550
        end
        
        mainContainer.Size = UDim2.new(0, width, 0, height)
        
        local x = (viewportSize.X - width) / 2
        local y = (viewportSize.Y - height) / 2
        
        if isMobile then
            y = math.max(y, 20)
        end
        
        mainContainer.Position = UDim2.new(0, x, 0, y)
    end

    calculateWindowSize()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(calculateWindowSize)

    -- Store references
    Library.ScreenGUI = ScreenGui
    Library.mainframe = mainContainer

    -- Add resize functionality
    Library:Resize(mainContainer)

    -- Add corner radius to main container
    local containerCorner = Instance.new("UICorner")
    containerCorner.Name = "ContainerCorner"
    containerCorner.CornerRadius = UDim.new(0, 16)
    containerCorner.Parent = mainContainer

    -- Add subtle border
    local containerStroke = Instance.new("UIStroke")
    containerStroke.Name = "ContainerStroke"
    containerStroke.Color = Color3.fromRGB(60, 60, 80)
    containerStroke.Thickness = 2
    containerStroke.Transparency = 0.7
    containerStroke.Parent = mainContainer

    -- Add shadow
    local containerShadow = Instance.new("ImageLabel")
    containerShadow.Name = "ContainerShadow"
    containerShadow.Image = "rbxassetid://1316045217"
    containerShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    containerShadow.ImageTransparency = 0.8
    containerShadow.ScaleType = Enum.ScaleType.Slice
    containerShadow.SliceCenter = Rect.new(10, 10, 118, 118)
    containerShadow.Size = UDim2.new(1, 20, 1, 20)
    containerShadow.Position = UDim2.new(0, -10, 0, -10)
    containerShadow.BackgroundTransparency = 1
    containerShadow.ZIndex = -1
    containerShadow.Parent = mainContainer

    -- UI Key toggle
    Library:connection(UserInputService.InputBegan, function(Input)
        if Input.KeyCode == Library.UIKey then
            Library:SetOpen(not Library.Open)
        end
    end)

    -- Store window reference
    Library.Window = Window

    -- Function to create tabs (simplified version)
    function Window.Tab(self, Properties)
        Properties = Properties or {}
        
        local Tab = {
            Name = Properties.Title or "Tab",
            Icon = Properties.Icon,
            Window = Window,
            Open = false,
            Sections = {},
            Elements = {},
            Vertical = Properties.Vertical or false,
        }

        -- Create tab button
        local tabButton = Instance.new("TextButton")
        tabButton.Name = "TabButton_" .. Tab.Name
        tabButton.Text = ""
        tabButton.AutoButtonColor = false
        tabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        tabButton.BackgroundTransparency = 0.8
        tabButton.Size = UDim2.new(1, -20, 0, 45)
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 10)
        tabCorner.Parent = tabButton
        
        local tabStroke = Instance.new("UIStroke")
        tabStroke.Color = Color3.fromRGB(60, 60, 80)
        tabStroke.Thickness = 1
        tabStroke.Transparency = 0.8
        tabStroke.Parent = tabButton
        
        local tabContent = Instance.new("Frame")
        tabContent.Name = "TabContent_" .. Tab.Name
        tabContent.BackgroundTransparency = 1
        tabContent.Size = UDim2.fromScale(1, 1)
        tabContent.Visible = false
        tabContent.Parent = contentFrame
        
        -- Tab layout
        local tabLayout = Instance.new("UIListLayout")
        tabLayout.Name = "TabLayout"
        tabLayout.Padding = UDim.new(0, 15)
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        tabLayout.Parent = tabContent
        
        local tabPadding = Instance.new("UIPadding")
        tabPadding.Name = "TabPadding"
        tabPadding.PaddingLeft = UDim.new(0, 15)
        tabPadding.PaddingRight = UDim.new(0, 15)
        tabPadding.PaddingTop = UDim.new(0, 15)
        tabPadding.PaddingBottom = UDim.new(0, 15)
        tabPadding.Parent = tabContent

        -- Tab button content
        local buttonContent = Instance.new("Frame")
        buttonContent.Name = "ButtonContent"
        buttonContent.BackgroundTransparency = 1
        buttonContent.Size = UDim2.fromScale(1, 1)
        buttonContent.Parent = tabButton

        local iconLabel = nil
        if Tab.Icon then
            iconLabel = Instance.new("ImageLabel")
            iconLabel.Name = "Icon"
            iconLabel.Image = Tab.Icon
            iconLabel.ImageColor3 = Color3.fromRGB(180, 180, 220)
            iconLabel.ImageTransparency = 0.5
            iconLabel.Size = UDim2.new(0, 24, 0, 24)
            iconLabel.Position = UDim2.new(0, 12, 0.5, 0)
            iconLabel.AnchorPoint = Vector2.new(0, 0.5)
            iconLabel.BackgroundTransparency = 1
            iconLabel.Parent = buttonContent
        end

        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "TextLabel"
        textLabel.Font = Enum.Font.GothamMedium
        textLabel.Text = Tab.Name
        textLabel.TextColor3 = Color3.fromRGB(180, 180, 220)
        textLabel.TextSize = 14
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.BackgroundTransparency = 1
        textLabel.Size = UDim2.new(1, iconLabel and -50 or -24, 1, 0)
        textLabel.Position = UDim2.new(0, iconLabel and 44 or 12, 0, 0)
        textLabel.Parent = buttonContent

        -- Tab functionality
        function Tab.Turn(self, bool)
            Tab.Open = bool
            
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            
            if bool then
                TweenService:Create(tabButton, tweenInfo, {
                    BackgroundTransparency = 0.6,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                }):Play()
                
                TweenService:Create(tabStroke, tweenInfo, {
                    Color = Library.Accent,
                    Transparency = 0.3
                }):Play()
                
                TweenService:Create(textLabel, tweenInfo, {
                    TextColor3 = Color3.fromRGB(240, 240, 255)
                }):Play()
                
                if iconLabel then
                    TweenService:Create(iconLabel, tweenInfo, {
                        ImageColor3 = Library.Accent,
                        ImageTransparency = 0.2
                    }):Play()
                end
                
                tabContent.Visible = true
            else
                TweenService:Create(tabButton, tweenInfo, {
                    BackgroundTransparency = 0.8,
                    BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                }):Play()
                
                TweenService:Create(tabStroke, tweenInfo, {
                    Color = Color3.fromRGB(60, 60, 80),
                    Transparency = 0.8
                }):Play()
                
                TweenService:Create(textLabel, tweenInfo, {
                    TextColor3 = Color3.fromRGB(180, 180, 220)
                }):Play()
                
                if iconLabel then
                    TweenService:Create(iconLabel, tweenInfo, {
                        ImageColor3 = Color3.fromRGB(180, 180, 220),
                        ImageTransparency = 0.5
                    }):Play()
                end
                
                tabContent.Visible = false
            end
        end

        tabButton.MouseButton1Click:Connect(function()
            if not Tab.Open then
                for _, otherTab in pairs(Window.Tabs) do
                    if otherTab.Open and otherTab ~= Tab then
                        otherTab:Turn(false)
                    end
                end
                Tab:Turn(true)
            end
        end)

        tabButton.MouseEnter:Connect(function()
            if Library.DropdownActive then return end
            if not Tab.Open then
                TweenService:Create(tabButton, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0.7
                }):Play()
                
                TweenService:Create(textLabel, TweenInfo.new(0.2), {
                    TextColor3 = Color3.fromRGB(220, 220, 240)
                }):Play()
                
                if iconLabel then
                    TweenService:Create(iconLabel, TweenInfo.new(0.2), {
                        ImageTransparency = 0.3
                    }):Play()
                end
            end
        end)

        tabButton.MouseLeave:Connect(function()
            if not Tab.Open then
                TweenService:Create(tabButton, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0.8
                }):Play()
                
                TweenService:Create(textLabel, TweenInfo.new(0.2), {
                    TextColor3 = Color3.fromRGB(180, 180, 220)
                }):Play()
                
                if iconLabel then
                    TweenService:Create(iconLabel, TweenInfo.new(0.2), {
                        ImageTransparency = 0.5
                    }):Play()
                end
            end
        end)

        Tab.Elements = {
            TabButton = tabButton,
            TabContent = tabContent,
            ButtonContent = buttonContent,
            TextLabel = textLabel,
            IconLabel = iconLabel,
        }

        tabButton.Parent = tabContainer

        if #Window.Tabs == 0 then
            Tab:Turn(true)
        end

        Window.Tabs[#Window.Tabs + 1] = Tab
        return Tab
    end

    -- Open window by default
    Library:SetOpen(true)

    return Window
end

-- Toggle window visibility
function Library.SetOpen(self, bool)
    if typeof(bool) ~= "boolean" then return end
    
    Library.Open = bool
    if self.mainframe then
        self.mainframe.Visible = bool
    end
end 

	function Library.Notification(self, message, time, type)
		time = time or 3
		type = type or "info"
		local notifications = Library.ScreenGUI:FindFirstChild("NotificationHolder")
	if (not notifications) then
		notifications = Instance.new("Frame")
		notifications.Name = "NotificationHolder"
		notifications.BackgroundTransparency = 1
		notifications.AnchorPoint = Vector2.new(1, 0)
		notifications.Position = UDim2.new(1, -15, 0, 15)
		notifications.Size = Library.UDim2(0, 320, 1, -30)
		notifications.ZIndex = 100
		notifications.Parent = Library.ScreenGUI
		
		local layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0, 10)
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		layout.VerticalAlignment = Enum.VerticalAlignment.Top
		layout.Parent = notifications
	end

	local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	local notifWidth = isMobile and math.min(320, workspace.CurrentCamera.ViewportSize.X * 0.9) or 320

	local notification = Instance.new("Frame")
	notification.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
	notification.BackgroundTransparency = 1
	notification.BorderSizePixel = 0
	notification.Size = Library.UDim2(0, notifWidth * 0.9, 0, 0)
	notification.AutomaticSize = Enum.AutomaticSize.Y
	notification.Position = UDim2.new(1, 100, 0, 0)
	notification.ZIndex = 101
	notification.LayoutOrder = tick()
	notification.Parent = notifications

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = notification

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(55, 55, 55)
	stroke.Transparency = 1
	stroke.Thickness = 1.5
	stroke.Parent = notification

	local shadow = Instance.new("Frame")
	shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	shadow.BackgroundTransparency = 1
	shadow.BorderSizePixel = 0
	shadow.Position = UDim2.new(0, 2, 0, 2)
	shadow.Size = Library.UDim2(1, 0, 1, 0)
	shadow.ZIndex = 100
	shadow.Parent = notification

	local shadowCorner = Instance.new("UICorner")
	shadowCorner.CornerRadius = UDim.new(0, 12)
	shadowCorner.Parent = shadow

	local acrylic1 = Instance.new("ImageLabel")
	acrylic1.Image = "rbxassetid://9968344105"
	acrylic1.ImageTransparency = 1
	acrylic1.ScaleType = Enum.ScaleType.Tile
	acrylic1.TileSize = UDim2.fromOffset(128, 128)
	acrylic1.BackgroundTransparency = 1
	acrylic1.Size = UDim2.fromScale(1, 1)
	acrylic1.ZIndex = 102
	acrylic1.Parent = notification

	local acrylic1Corner = Instance.new("UICorner")
	acrylic1Corner.CornerRadius = UDim.new(0, 12)
	acrylic1Corner.Parent = acrylic1

	local acrylic2 = Instance.new("ImageLabel")
	acrylic2.Image = "rbxassetid://9968344227"
	acrylic2.ImageTransparency = 1
	acrylic2.ScaleType = Enum.ScaleType.Tile
	acrylic2.TileSize = UDim2.fromOffset(128, 128)
	acrylic2.BackgroundTransparency = 1
	acrylic2.Size = UDim2.fromScale(1, 1)
	acrylic2.ZIndex = 102
	acrylic2.Parent = notification

	local acrylic2Corner = Instance.new("UICorner")
	acrylic2Corner.CornerRadius = UDim.new(0, 12)
	acrylic2Corner.Parent = acrylic2

	local contentFrame = Instance.new("Frame")
	contentFrame.BackgroundTransparency = 1
	contentFrame.Size = Library.UDim2(1, 0, 0, 0)
	contentFrame.AutomaticSize = Enum.AutomaticSize.Y
	contentFrame.ZIndex = 103
	contentFrame.Parent = notification

	local contentLayout = Instance.new("UIListLayout")
	contentLayout.Padding = UDim.new(0, 8)
	contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	contentLayout.Parent = contentFrame

	local contentPadding = Instance.new("UIPadding")
	contentPadding.PaddingTop = UDim.new(0, 16)
	contentPadding.PaddingBottom = UDim.new(0, 16)
	contentPadding.PaddingLeft = UDim.new(0, 18)
	contentPadding.PaddingRight = UDim.new(0, 18)
	contentPadding.Parent = contentFrame

	local topRow = Instance.new("Frame")
	topRow.BackgroundTransparency = 1
	topRow.Size = Library.UDim2(1, 0, 0, 18)
	topRow.LayoutOrder = 1
	topRow.Parent = contentFrame

	local iconColors = {
		success = Color3.fromRGB(34, 197, 94),
		error = Color3.fromRGB(239, 68, 68),
		warning = Color3.fromRGB(245, 158, 11),
		info = Color3.fromRGB(59, 130, 246)
	}

	local typeColor = iconColors[type] or iconColors.info

	local statusDot = Instance.new("Frame")
	statusDot.BackgroundColor3 = typeColor
	statusDot.BackgroundTransparency = 1
	statusDot.BorderSizePixel = 0
	statusDot.Size = Library.UDim2(0, 8, 0, 8)
	statusDot.Position = UDim2.new(0, 0, 0.5, -4)
	statusDot.Parent = topRow

	local dotCorner = Instance.new("UICorner")
	dotCorner.CornerRadius = UDim.new(1, 0)
	dotCorner.Parent = statusDot

	local typeLabel = Instance.new("TextLabel")
	typeLabel.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
	typeLabel.Text = string.upper(type)
	typeLabel.TextColor3 = typeColor
	typeLabel.TextSize = Library.GetScaledTextSize(10)
	typeLabel.TextXAlignment = Enum.TextXAlignment.Left
	typeLabel.BackgroundTransparency = 1
	typeLabel.TextTransparency = 1
	typeLabel.Position = UDim2.new(0, 16, 0, 0)
	typeLabel.Size = Library.UDim2(1, -40, 1, 0)
	typeLabel.Parent = topRow

	local timeLabel = Instance.new("TextLabel")
	timeLabel.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
	timeLabel.Text = os.date("%H:%M")
	timeLabel.TextColor3 = Color3.fromRGB(115, 115, 115)
	timeLabel.TextSize = Library.GetScaledTextSize(9)
	timeLabel.TextXAlignment = Enum.TextXAlignment.Right
	timeLabel.BackgroundTransparency = 1
	timeLabel.TextTransparency = 1
	timeLabel.AnchorPoint = Vector2.new(1, 0)
	timeLabel.Position = UDim2.new(1, 0, 0, 0)
	timeLabel.Size = Library.UDim2(0, 40, 1, 0)
	timeLabel.Parent = topRow

	local messageLabel = Instance.new("TextLabel")
	messageLabel.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
	messageLabel.Text = message
	messageLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
	messageLabel.TextSize = Library.GetScaledTextSize(12)
	messageLabel.TextWrapped = true
	messageLabel.TextXAlignment = Enum.TextXAlignment.Left
	messageLabel.TextYAlignment = Enum.TextYAlignment.Top
	messageLabel.BackgroundTransparency = 1
	messageLabel.TextTransparency = 1
	messageLabel.Size = Library.UDim2(1, 0, 0, 0)
	messageLabel.AutomaticSize = Enum.AutomaticSize.Y
	messageLabel.LayoutOrder = 2
	messageLabel.Parent = contentFrame
	spawn(function()
		local slideIn = TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(0, notifWidth, 0, 0),
			BackgroundTransparency = 0.1
		})
		
		local fadeInStroke = TweenService:Create(stroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Transparency = 0.3
		})
		
		local fadeInShadow = TweenService:Create(shadow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = 0.7
		})
		
		local fadeInAcrylic1 = TweenService:Create(acrylic1, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			ImageTransparency = 0.97
		})
		
		local fadeInAcrylic2 = TweenService:Create(acrylic2, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			ImageTransparency = 0.94
		})
		
		local fadeInDot = TweenService:Create(statusDot, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = 0
		})
		
		local fadeInType = TweenService:Create(typeLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			TextTransparency = 0
		})
		
		local fadeInTime = TweenService:Create(timeLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			TextTransparency = 0
		})
		
		local fadeInMessage = TweenService:Create(messageLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			TextTransparency = 0
		})
		
		slideIn:Play()
		fadeInStroke:Play()
		fadeInShadow:Play()
		fadeInAcrylic1:Play()
		fadeInAcrylic2:Play()
		fadeInDot:Play()
		fadeInType:Play()
		fadeInTime:Play()
		fadeInMessage:Play()
		
		task.wait(time - 0.5)
		
		local slideOut = TweenService:Create(notification, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = UDim2.new(1, 50, 0, 0),
			BackgroundTransparency = 1
		})
		
		local fadeOut = TweenService:Create(stroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Transparency = 1
		})
		
		slideOut:Play()
		fadeOut:Play()
		
		slideOut.Completed:Connect(function()
			notification:Destroy()
		end)
	end)
end

return Library
