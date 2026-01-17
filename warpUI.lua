-- WarpHub UI Library
-- Version: 2.2 - Fully Fixed & Executor Safe
-- loadstring(game:HttpGet("RAW_URL_HERE"))()

local WarpHub = {}
WarpHub.__index = WarpHub

--==============================
-- SERVICES
--==============================
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local GuiParent = (gethui and gethui()) or game:GetService("CoreGui")

--==============================
-- CONFIG
--==============================
WarpHub.DefaultColors = {
    AccentColor = Color3.fromRGB(168,128,255),
    SecondaryColor = Color3.fromRGB(128,96,255),
    GlassColor = Color3.fromRGB(20,20,30),
    DarkGlassColor = Color3.fromRGB(10,10,18),
    TextColor = Color3.fromRGB(255,255,255),
    SubTextColor = Color3.fromRGB(200,200,220)
}

WarpHub.Config = {
    GlassTransparency = 0.12,
    DarkGlassTransparency = 0.08,
    CornerRadius = 14
}

--==============================
-- HELPERS
--==============================
local function createGlassFrame(parent, size, pos, transparency, color)
    local f = Instance.new("Frame")
    f.Size = size
    f.Position = pos
    f.BackgroundColor3 = color or WarpHub.DefaultColors.GlassColor
    f.BackgroundTransparency = transparency or WarpHub.Config.GlassTransparency
    f.BorderSizePixel = 0
    f.ClipsDescendants = true

    local c = Instance.new("UICorner", f)
    c.CornerRadius = UDim.new(0, WarpHub.Config.CornerRadius)

    local s = Instance.new("UIStroke", f)
    s.Color = Color3.new(1,1,1)
    s.Transparency = 0.9
    s.Thickness = 1.2

    if parent then f.Parent = parent end
    return f
end

--==============================
-- WINDOW
--==============================
function WarpHub:CreateWindow(title)
    local self = setmetatable({}, WarpHub)

    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "WarpHubUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    self.ScreenGui.Parent = GuiParent

    self.MainFrame = createGlassFrame(
        self.ScreenGui,
        UDim2.new(0,620,0,500),
        UDim2.new(0.5,-310,0.5,-250),
        WarpHub.Config.DarkGlassTransparency,
        WarpHub.DefaultColors.DarkGlassColor
    )

    -- Top Bar
    self.TopBar = createGlassFrame(
        self.MainFrame,
        UDim2.new(1,-24,0,44),
        UDim2.new(0,12,0,12),
        0.1
    )

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1,-20,1,0)
    titleLabel.Position = UDim2.new(0,10,0,0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "WARP HUB"
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 20
    titleLabel.TextXAlignment = Left
    titleLabel.TextColor3 = WarpHub.DefaultColors.TextColor
    titleLabel.Parent = self.TopBar

    -- Sidebar
    self.Sidebar = createGlassFrame(
        self.MainFrame,
        UDim2.new(0,140,1,-70),
        UDim2.new(0,12,0,58),
        0.1
    )

    self.SidebarTabs = Instance.new("Frame", self.Sidebar)
    self.SidebarTabs.Size = UDim2.new(1,-10,1,-10)
    self.SidebarTabs.Position = UDim2.new(0,5,0,5)
    self.SidebarTabs.BackgroundTransparency = 1

    local sideList = Instance.new("UIListLayout", self.SidebarTabs)
    sideList.Padding = UDim.new(0,6)

    -- Content
    self.ContentArea = createGlassFrame(
        self.MainFrame,
        UDim2.new(1,-176,1,-70),
        UDim2.new(0,164,0,58),
        0.1
    )

    self.tabs = {}
    self.currentTab = nil

    return self
end

--==============================
-- TABS
--==============================
function WarpHub:AddTab(name)
    local tab = {}
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1,-10,0,36)
    button.BackgroundColor3 = WarpHub.DefaultColors.GlassColor
    button.BackgroundTransparency = 0.15
    button.Text = name
    button.Font = Enum.Font.GothamMedium
    button.TextSize = 13
    button.TextColor3 = WarpHub.DefaultColors.SubTextColor
    button.AutoButtonColor = false
    button.Parent = self.SidebarTabs

    local bc = Instance.new("UICorner", button)
    bc.CornerRadius = UDim.new(0,12)

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1,0,1,0)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.Parent = self.ContentArea

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1,-16,1,-16)
    scroll.Position = UDim2.new(0,8,0,8)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.CanvasSize = UDim2.new()
    scroll.Parent = content

    local list = Instance.new("UIListLayout", scroll)
    list.Padding = UDim.new(0,8)

    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0,0,0,list.AbsoluteContentSize.Y + 10)
    end)

    local function select()
        for _,t in pairs(self.tabs) do
            t.content.Visible = false
            t.button.TextColor3 = WarpHub.DefaultColors.SubTextColor
        end
        content.Visible = true
        button.TextColor3 = WarpHub.DefaultColors.TextColor
        self.currentTab = tab
    end

    button.MouseButton1Click:Connect(select)

    if #self.tabs == 0 then
        task.delay(0.1, select)
    end

    tab.button = button
    tab.content = content
    tab.scroll = scroll

    table.insert(self.tabs, tab)

    --==============================
    -- ELEMENTS
    --==============================
    function tab:AddButton(text, callback)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1,0,0,36)
        b.Text = text
        b.Font = Enum.Font.GothamMedium
        b.TextSize = 13
        b.TextColor3 = WarpHub.DefaultColors.TextColor
        b.BackgroundColor3 = WarpHub.DefaultColors.GlassColor
        b.BackgroundTransparency = 0.12
        b.AutoButtonColor = false
        b.Parent = scroll

        Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)

        b.MouseButton1Click:Connect(function()
            if callback then pcall(callback) end
        end)
    end

    function tab:AddToggle(text, default, callback)
        local state = default or false

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,0,0,36)
        btn.Text = text
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 13
        btn.TextColor3 = WarpHub.DefaultColors.TextColor
        btn.AutoButtonColor = false
        btn.BackgroundTransparency = 0
        btn.Parent = scroll

        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)

        local function refresh()
            btn.BackgroundColor3 = state and WarpHub.DefaultColors.AccentColor or WarpHub.DefaultColors.GlassColor
            if callback then pcall(callback, state) end
        end

        btn.MouseButton1Click:Connect(function()
            state = not state
            refresh()
        end)

        refresh()
    end

    function tab:AddSlider(text, min, max, default, callback)
        local value = default or min

        local holder = Instance.new("Frame", scroll)
        holder.Size = UDim2.new(1,0,0,52)
        holder.BackgroundTransparency = 1

        local lbl = Instance.new("TextLabel", holder)
        lbl.Size = UDim2.new(1,0,0,20)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = WarpHub.DefaultColors.TextColor
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextSize = 13

        local bar = Instance.new("Frame", holder)
        bar.Size = UDim2.new(1,0,0,6)
        bar.Position = UDim2.new(0,0,0,34)
        bar.BackgroundColor3 = WarpHub.DefaultColors.GlassColor
        Instance.new("UICorner", bar).CornerRadius = UDim.new(0,3)

        local fill = Instance.new("Frame", bar)
        fill.BackgroundColor3 = WarpHub.DefaultColors.AccentColor
        Instance.new("UICorner", fill).CornerRadius = UDim.new(0,3)

        local dragging = false

        bar.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true
            end
        end)

        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        RunService.RenderStepped:Connect(function()
            if dragging then
                local x = math.clamp(
                    (UserInputService:GetMouseLocation().X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
                    0,1
                )
                value = math.floor(min + (max-min)*x)
                fill.Size = UDim2.new(x,0,1,0)
                if callback then pcall(callback,value) end
            end
        end)
    end

    function tab:AddLabel(text)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1,0,0,26)
        l.BackgroundTransparency = 1
        l.Text = text
        l.Font = Enum.Font.GothamMedium
        l.TextSize = 13
        l.TextColor3 = WarpHub.DefaultColors.TextColor
        l.TextXAlignment = Left
        l.Parent = scroll
    end

    return tab
end

--==============================
-- QUICK
--==============================
function WarpHub.Quick(title, tabName)
    local win = WarpHub:CreateWindow(title)
    local tab = win:AddTab(tabName or "Main")
    return win, tab
end

return WarpHub
