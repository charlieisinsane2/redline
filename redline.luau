--[[
    RedLine Visual Studio - Main Module
]]

if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(1)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if _G.RedlineStudio then pcall(function() _G.RedlineStudio:Destroy() end) end

local Theme = {
    Background = Color3.fromRGB(25, 25, 25),
    Sidebar = Color3.fromRGB(20, 20, 20),
    Topbar = Color3.fromRGB(30, 30, 30),
    Card = Color3.fromRGB(30, 30, 30),
    Element = Color3.fromRGB(40, 40, 40),
    Text = Color3.fromRGB(200, 200, 200),
    SubText = Color3.fromRGB(150, 150, 150),
    Accent = Color3.fromRGB(220, 50, 50),
    Gold = Color3.fromRGB(255, 200, 0),
}

local State = {
    Enabled = false,
    OutlineEnabled = true,
    Rotate = true,
    FillColor = Color3.fromRGB(220, 50, 50),
    OutlineColor = Color3.fromRGB(255, 255, 255),
    FillOpacity = 0.3,
    OutlineOpacity = 0,
    Hue = 0,
    Saturation = 1,
    Value = 1,
    Material = Enum.Material.Neon,
}

local AimbotState = {
    Enabled = false,
    RenderFOV = true,
    FOV = 90,
    Key = Enum.KeyCode.Q,
    TargetPart = "Head",
    IsAiming = false,
}

local ESPState = {
    Enabled = false,
    Color = Color3.fromRGB(0, 255, 0),
}

local Connections = {}
local accentObjects = {}
local function track(conn) table.insert(Connections, conn); return conn end

local function create(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local function tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function updateAccent(color)
    Theme.Accent = color
    for _, obj in ipairs(accentObjects) do
        if obj and obj.Parent then
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                obj.TextColor3 = color
            elseif obj:IsA("Frame") or obj:IsA("ImageButton") then
                obj.BackgroundColor3 = color
            elseif obj:IsA("UIStroke") then
                obj.Color = color
            end
        end
    end
end

local gui = create("ScreenGui", {
    Name = "RedlineStudio",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 999,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)
_G.RedlineStudio = gui

local fovCircle = create("Frame", {
    Size = UDim2.fromOffset(AimbotState.FOV * 2, AimbotState.FOV * 2),
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundTransparency = 1,
    Visible = false,
}, gui)
local fovStroke = create("UIStroke", {Color = Theme.Accent, Thickness = 1, Transparency = 0.5}, fovCircle)
create("UICorner", {CornerRadius = UDim.new(1, 0)}, fovCircle)
table.insert(accentObjects, fovStroke)

local window = create("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(860, 520),
    BackgroundColor3 = Theme.Background,
    ClipsDescendants = true,
}, gui)
create("UICorner", {CornerRadius = UDim.new(0, 6)}, window)
create("UIStroke", {Color = Color3.fromRGB(0, 0, 0), Thickness = 2, Transparency = 0.5}, window)

local topbar = create("Frame", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Theme.Topbar,
    BorderSizePixel = 0,
}, window)

local titleContainer = create("Frame", {
    Position = UDim2.fromOffset(15, 0),
    Size = UDim2.new(0, 150, 1, 0),
    BackgroundTransparency = 1,
}, topbar)

local rLbl = create("TextLabel", {
    Size = UDim2.new(0, 15, 1, 0), Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1, Text = "R", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Color3.fromRGB(255, 255, 255), TextXAlignment = Enum.TextXAlignment.Left,
}, titleContainer)
local rGrad = create("UIGradient", {Color = ColorSequence.new(Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 200, 0)), Rotation = 45}, rLbl)

create("TextLabel", {
    Size = UDim2.new(0, 35, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, Text = "ed", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Color3.fromRGB(255, 255, 255), TextXAlignment = Enum.TextXAlignment.Left,
}, titleContainer)

local lLbl = create("TextLabel", {
    Size = UDim2.new(0, 15, 1, 0), Position = UDim2.new(0, 50, 0, 0), BackgroundTransparency = 1, Text = "L", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Color3.fromRGB(255, 255, 255), TextXAlignment = Enum.TextXAlignment.Left,
}, titleContainer)
local lGrad = create("UIGradient", {Color = ColorSequence.new(Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 200, 0)), Rotation = 45}, lLbl)

create("TextLabel", {
    Size = UDim2.new(0, 35, 1, 0), Position = UDim2.new(0, 65, 0, 0), BackgroundTransparency = 1, Text = "ine", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Color3.fromRGB(255, 255, 255), TextXAlignment = Enum.TextXAlignment.Left,
}, titleContainer)

track(RunService.RenderStepped:Connect(function()
    local offset = (os.clock() % 2) - 1
    rGrad.Offset = Vector2.new(offset, 0)
    lGrad.Offset = Vector2.new(offset, 0)
end))

local closeBtn = create("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(24, 24), BackgroundColor3 = Theme.Element, Text = "×", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Theme.Text, AutoButtonColor = false,
}, topbar)
create("UICorner", {CornerRadius = UDim.new(0, 4)}, closeBtn)

local sidebar = create("Frame", {
    Position = UDim2.fromOffset(0, 40), Size = UDim2.new(0, 150, 1, -40), BackgroundColor3 = Theme.Sidebar, BorderSizePixel = 0,
}, window)
create("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, sidebar)
create("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}, sidebar)

local content = create("Frame", {
    Position = UDim2.fromOffset(150, 40), Size = UDim2.new(1, -150, 1, -40), BackgroundTransparency = 1,
}, window)

local extPanel = create("Frame", {
    Position = UDim2.new(1, -200, 0, 40), Size = UDim2.new(0, 200, 1, -40), BackgroundColor3 = Theme.Sidebar, BorderSizePixel = 0, Visible = false,
}, window)
create("UIListLayout", {Padding = UDim.new(0, 10)}, extPanel)
create("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}, extPanel)

local extTitle = create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = "VISUAL EDITOR", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.Accent, TextXAlignment = Enum.TextXAlignment.Left,
}, extPanel)
table.insert(accentObjects, extTitle)

local pages = {}
local function createPage(name)
    local page = create("Frame", {Name = name, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false}, content)
    local left = create("ScrollingFrame", {
        Position = UDim2.fromOffset(10, 10), Size = UDim2.new(0.5, -15, 1, -20), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, page)
    local right = create("ScrollingFrame", {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 10), Size = UDim2.new(0.5, -15, 1, -20), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, page)
    create("UIListLayout", {Padding = UDim.new(0, 10)}, left)
    create("UIListLayout", {Padding = UDim.new(0, 10)}, right)
    pages[name] = {Page = page, Left = left, Right = right}
    return pages[name]
end

local combat = createPage("Combat")
local visuals = createPage("Visuals")
local themes = createPage("Themes")
local test = createPage("Test")

local function switchPage(pageName)
    for name, data in pairs(pages) do data.Page.Visible = (name == pageName) end
end

local function setExtensionOpen(open)
    if open then
        extPanel.Visible = true
        tween(window, {Size = UDim2.fromOffset(1060, 520)})
        tween(content, {Size = UDim2.new(1, -350, 1, -40)})
    else
        tween(window, {Size = UDim2.fromOffset(860, 520)})
        tween(content, {Size = UDim2.new(1, -150, 1, -40)})
        task.delay(0.15, function()
            if not pages["Visuals"].Page.Visible then extPanel.Visible = false end
        end)
    end
end

local function createCard(parent, title, order, onToggleCallback)
    local card = create("Frame", {Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = Theme.Card, AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = order}, parent)
    create("UICorner", {CornerRadius = UDim.new(0, 4)}, card)
    create("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}, card)
    create("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, card)

    local header = create("TextButton", {Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = 0}, card)
    local arrow = create("TextLabel", {Size = UDim2.fromOffset(20, 30), BackgroundTransparency = 1, Text = "▶", Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = Theme.SubText, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center}, header)
    
    local titleLbl = create("TextLabel", {Position = UDim2.fromOffset(20, 0), Size = UDim2.new(1, -90, 1, 0), BackgroundTransparency = 1, Text = title:upper(), Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.Accent, TextXAlignment = Enum.TextXAlignment.Left}, header)
    table.insert(accentObjects, titleLbl)

    local starBtn = create("TextButton", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -50, 0.5, 0), Size = UDim2.fromOffset(20, 20), BackgroundTransparency = 1, Text = "☆", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Theme.SubText, AutoButtonColor = false}, header)
    
    local miniTrack = create("TextButton", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -20, 0.5, 0), Size = UDim2.fromOffset(24, 12), BackgroundColor3 = Theme.Element, Text = "", AutoButtonColor = false}, header)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, miniTrack)
    local miniKnob = create("Frame", {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 2, 0.5, 0), Size = UDim2.fromOffset(8, 8), BackgroundColor3 = Color3.fromRGB(240, 240, 240)}, miniTrack)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, miniKnob)

    local contentFrame = create("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = 1, ClipsDescendants = true, Visible = false}, card)
    create("UIPadding", {PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}, contentFrame)
    create("UIListLayout", {Padding = UDim.new(0, 6)}, contentFrame)

    local expanded, enabled = false, false

    header.MouseButton1Click:Connect(function()
        expanded = not expanded
        contentFrame.Visible = expanded
        arrow.Text = expanded and "▼" or "▶"
    end)

    starBtn.MouseButton1Click:Connect(function()
        local starred = starBtn.Text == "☆"
        starBtn.Text = starred and "★" or "☆"
        starBtn.TextColor3 = starred and Theme.Gold or Theme.SubText
    end)

    miniTrack.MouseButton1Click:Connect(function()
        enabled = not enabled
        tween(miniTrack, {BackgroundColor3 = enabled and Theme.Accent or Theme.Element})
        tween(miniKnob, {Position = enabled and UDim2.new(1, -10, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)})
        if onToggleCallback then onToggleCallback(enabled) end
    end)

    return contentFrame
end

local function createToggle(parent, text, default, callback)
    local val = default
    local row = create("Frame", {Size = UDim2.new(1, 0, 0, 25), BackgroundTransparency = 1}, parent)
    create("TextLabel", {Size = UDim2.new(1, -40, 1, 0), BackgroundTransparency = 1, Text = text, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, row)
    local track = create("TextButton", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(34, 16), BackgroundColor3 = val and Theme.Accent or Theme.Element, Text = "", AutoButtonColor = false}, row)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, track)
    table.insert(accentObjects, track)
    local knob = create("Frame", {AnchorPoint = Vector2.new(0, 0.5), Position = val and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0), Size = UDim2.fromOffset(12, 12), BackgroundColor3 = Color3.fromRGB(240, 240, 240)}, track)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, knob)

    track.MouseButton1Click:Connect(function()
        val = not val
        tween(track, {BackgroundColor3 = val and Theme.Accent or Theme.Element})
        tween(knob, {Position = val and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)})
        if callback then callback(val) end
    end)
end

local function createSlider(parent, text, min, max, default, decimals, callback)
    local val = default
    local row = create("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1}, parent)
    create("TextLabel", {Size = UDim2.new(1, -50, 1, 0), BackgroundTransparency = 1, Text = text, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, row)
    local valLbl = create("TextLabel", {Position = UDim2.new(1, -40, 0, 0), Size = UDim2.fromOffset(40, 15), BackgroundTransparency = 1, Text = string.format("%."..(decimals or 0).."f", val), Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Theme.Accent, TextXAlignment = Enum.TextXAlignment.Right}, row)
    table.insert(accentObjects, valLbl)
    local bar = create("Frame", {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 10), Size = UDim2.new(1, 0, 0, 4), BackgroundColor3 = Theme.Element}, row)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, bar)
    local fill = create("Frame", {Size = UDim2.new((val - min) / (max - min), 0, 1, 0), BackgroundColor3 = Theme.Accent}, bar)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, fill)
    table.insert(accentObjects, fill)
    local hit = create("TextButton", {Size = UDim2.new(1, 0, 1, 20), Position = UDim2.fromOffset(0, -8), BackgroundTransparency = 1, Text = "", AutoButtonColor = false}, bar)

    local dragging = false
    local function update(input)
        local pct = math.clamp((input.Position.X - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
        val = min + (max - min) * pct
        valLbl.Text = string.format("%."..(decimals or 0).."f", val)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        if callback then callback(val) end
    end

    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; update(input) end
    end)
    track(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end
    end))
    track(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end))
end

local function createDropdown(parent, text, options, default, callback)
    local val = default
    local row = create("Frame", {Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 2}, parent)
    create("TextLabel", {Size = UDim2.new(0.4, 0, 1, 0), BackgroundTransparency = 1, Text = text, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, row)
    local btn = create("TextButton", {Position = UDim2.new(0.4, 0, 0, 0), Size = UDim2.new(0.6, 0, 0, 22), BackgroundColor3 = Theme.Element, Text = val, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Theme.Text, AutoButtonColor = false}, row)
    create("UICorner", {CornerRadius = UDim.new(0, 4)}, btn)
    local list = create("Frame", {Position = UDim2.new(0.4, 0, 0, 24), Size = UDim2.new(0.6, 0, 0, #options * 22), BackgroundColor3 = Theme.Element, Visible = false, ZIndex = 5}, row)
    create("UICorner", {CornerRadius = UDim.new(0, 4)}, list)
    create("UIListLayout", {Padding = UDim.new(0, 2)}, list)
    create("UIPadding", {PaddingTop = UDim.new(0, 2)}, list)

    for _, opt in ipairs(options) do
        local b = create("TextButton", {Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = opt, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = val == opt and Theme.Accent or Theme.Text, AutoButtonColor = false}, list)
        table.insert(accentObjects, b)
        b.MouseButton1Click:Connect(function()
            val = opt; btn.Text = opt; list.Visible = false; row.Size = UDim2.new(1, 0, 0, 30)
            for _, child in ipairs(list:GetChildren()) do
                if child:IsA("TextButton") then child.TextColor3 = child.Text == val and Theme.Accent or Theme.Text end
            end
            if callback then callback(opt) end
        end)
    end

    btn.MouseButton1Click:Connect(function()
        list.Visible = not list.Visible
        row.Size = UDim2.new(1, 0, 0, list.Visible and (30 + #options * 22) or 30)
    end)
end

local function createKeybind(parent, text, defaultKey, callback)
    local key = defaultKey
    local row = create("Frame", {Size = UDim2.new(1, 0, 0, 25), BackgroundTransparency = 1}, parent)
    create("TextLabel", {Size = UDim2.new(1, -60, 1, 0), BackgroundTransparency = 1, Text = text, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, row)
    local btn = create("TextButton", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(50, 20), BackgroundColor3 = Theme.Element, Text = key.Name, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Theme.Accent, AutoButtonColor = false}, row)
    create("UICorner", {CornerRadius = UDim.new(0, 4)}, btn)
    table.insert(accentObjects, btn)

    local listening = false
    btn.MouseButton1Click:Connect(function()
        listening = false
        task.delay(0.15, function()
            listening = true
            btn.Text = "..."
            btn.TextColor3 = Theme.Text
        end)
    end)

    track(UserInputService.InputBegan:Connect(function(input)
        if listening then
            local newKey = nil
            local uName = input.UserInputType.Name
            
            if input.UserInputType == Enum.UserInputType.Keyboard then
                newKey = input.KeyCode
            elseif uName == "MouseButton1" then
                newKey = Enum.KeyCode.MouseButton1
            elseif uName == "MouseButton2" then
                newKey = Enum.KeyCode.MouseButton2
            elseif uName == "MouseButton3" then
                newKey = Enum.KeyCode.MouseButton3
            end
            
            if newKey then
                key = newKey
                btn.Text = key.Name
                btn.TextColor3 = Theme.Accent
                if callback then callback(key) end
                listening = false
            end
        end
    end))
end

local function createColorPicker(parent, title, order, callback)
    local card = createCard(parent, title, order)
    local square = create("ImageButton", {Size = UDim2.new(1, 0, 0, 100), BackgroundColor3 = Color3.fromHSV(State.Hue, 1, 1), AutoButtonColor = false}, card)
    create("UICorner", {CornerRadius = UDim.new(0, 4)}, square)
    local whiteGrad = create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0}, square)
    create("UIGradient", {Color = ColorSequence.new(Color3.new(1,1,1)), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})}, whiteGrad)
    local blackGrad = create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(0,0,0), BorderSizePixel = 0}, square)
    create("UIGradient", {Rotation = 90, Color = ColorSequence.new(Color3.new(0,0,0)), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})}, blackGrad)
    local cursor = create("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(8, 8), BackgroundColor3 = Color3.new(1,1,1), ZIndex = 5}, square)
    create("UICorner", {CornerRadius = UDim.new(1, 0)}, cursor)
    create("UIStroke", {Color = Color3.new(0,0,0), Thickness = 1}, cursor)

    local hueBar = create("ImageButton", {Size = UDim2.new(1, 0, 0, 15), BackgroundColor3 = Color3.new(1,1,1), AutoButtonColor = false}, card)
    create("UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)), ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)), ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))})}, hueBar)
    create("UICorner", {CornerRadius = UDim.new(0, 4)}, hueBar)
    local hueCursor = create("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 4, 1, 4), BackgroundColor3 = Color3.new(1,1,1), ZIndex = 5}, hueBar)
    create("UIStroke", {Color = Color3.new(0,0,0), Thickness = 1}, hueCursor)

    local function updateColor()
        State.FillColor = Color3.fromHSV(State.Hue, State.Saturation, State.Value)
        square.BackgroundColor3 = Color3.fromHSV(State.Hue, 1, 1)
        cursor.Position = UDim2.new(State.Saturation, 0, 1 - State.Value, 0)
        hueCursor.Position = UDim2.new(State.Hue, 0, 0.5, 0)
        if callback then callback(State.FillColor) end
    end

    local sqDrag, hueDrag = false, false
    local function updateSq(input)
        local w, h = math.max(square.AbsoluteSize.X, 1), math.max(square.AbsoluteSize.Y, 1)
        State.Saturation = math.clamp((input.Position.X - square.AbsolutePosition.X) / w, 0, 1)
        State.Value = 1 - math.clamp((input.Position.Y - square.AbsolutePosition.Y) / h, 0, 1)
        updateColor()
    end
    local function updateHue(input)
        local w = math.max(hueBar.AbsoluteSize.X, 1)
        State.Hue = math.clamp((input.Position.X - hueBar.AbsolutePosition.X) / w, 0, 1)
        updateColor()
    end

    square.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sqDrag = true; updateSq(input) end end)
    hueBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then hueDrag = true; updateHue(input) end end)
    track(UserInputService.InputChanged:Connect(function(input)
        if sqDrag and input.UserInputType == Enum.UserInputType.MouseMovement then updateSq(input) end
        if hueDrag and input.UserInputType == Enum.UserInputType.MouseMovement then updateHue(input) end
    end))
    track(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then sqDrag = false; hueDrag = false end
    end))
    updateColor()
end

local navButtons = {}
local function addNav(name, pageName, useExt)
    local btn = create("TextButton", {Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Theme.Sidebar, Text = "", AutoButtonColor = false}, sidebar)
    create("UICorner", {CornerRadius = UDim.new(0, 4)}, btn)
    local title = create("TextLabel", {Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -10, 1, 0), BackgroundTransparency = 1, Text = name, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = Theme.SubText, TextXAlignment = Enum.TextXAlignment.Left}, btn)
    local accentBar = create("Frame", {Size = UDim2.fromOffset(2, 12), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, -5, 0.5, 0), BackgroundColor3 = Theme.Accent, Visible = false}, btn)
    table.insert(accentObjects, accentBar)
    navButtons[name] = {Btn = btn, Title = title, Accent = accentBar}
    btn.MouseEnter:Connect(function() if not accentBar.Visible then tween(title, {TextColor3 = Theme.Text}) end end)
    btn.MouseLeave:Connect(function() if not accentBar.Visible then tween(title, {TextColor3 = Theme.SubText}) end end)
    btn.MouseButton1Click:Connect(function()
        for n, d in pairs(navButtons) do
            d.Accent.Visible = (n == name)
            tween(d.Title, {TextColor3 = (n == name) and Theme.Accent or Theme.SubText})
        end
        switchPage(pageName)
        setExtensionOpen(useExt)
    end)
end

addNav("Combat", "Combat", false)
addNav("Visuals", "Visuals", true)
addNav("Themes", "Themes", false)
addNav("Test", "Test", false)

local aimbotCard = createCard(combat.Left, "Aimbot", 1, function(val) AimbotState.Enabled = val end)
createToggle(aimbotCard, "Render FOV Circle", true, function(v) AimbotState.RenderFOV = v end)
createKeybind(aimbotCard, "Aim Key", Enum.KeyCode.Q, function(k) AimbotState.Key = k end)
createSlider(aimbotCard, "FOV Radius", 10, 500, 90, 0, function(v) AimbotState.FOV = v end)
createDropdown(aimbotCard, "Target Part", {"Head", "Torso", "HumanoidRootPart"}, "Head", function(v) AimbotState.TargetPart = v end)

local previewCard = createCard(visuals.Right, "Preview", 1)
local vp = create("ViewportFrame", {Size = UDim2.new(1, 0, 0, 150), BackgroundColor3 = Color3.fromRGB(20, 20, 20), BorderSizePixel = 0}, previewCard)
create("UICorner", {CornerRadius = UDim.new(0, 4)}, vp)
local cam = create("Camera", {FieldOfView = 30}, vp)
vp.CurrentCamera = cam

local clone
local rot = 0
local function applyChams(realChar)
    local targets = {}
    if realChar then table.insert(targets, realChar) else
        table.insert(targets, clone)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character then table.insert(targets, p.Character) end
        end
    end
    for _, target in ipairs(targets) do
        local hl = target:FindFirstChild("RL_Chams")
        if not hl then hl = create("Highlight", {Name = "RL_Chams", Adornee = target, DepthMode = Enum.HighlightDepthMode.AlwaysOnTop}, target) end
        hl.Enabled = State.Enabled
        hl.FillColor = State.FillColor
        hl.OutlineColor = State.OutlineColor
        hl.FillTransparency = State.FillOpacity
        hl.OutlineTransparency = State.OutlineOpacity
        for _, d in ipairs(target:GetDescendants()) do
            if d:IsA("BasePart") then
                if State.Enabled then
                    if not d:GetAttribute("RL_OrigColor") then d:SetAttribute("RL_OrigColor", d.Color) end
                    d.Color = State.FillColor; d.Material = State.Material; d.Transparency = State.FillOpacity
                else
                    local orig = d:GetAttribute("RL_OrigColor")
                    if orig then d.Color = orig; d.Material = Enum.Material.Plastic; d.Transparency = 0 end
                end
            end
        end
    end
end

local function loadAvatar()
    if clone then clone:Destroy() end
    local char = player.Character
    if not char then return end
    char.Archivable = true
    clone = char:Clone()
    char.Archivable = false
    for _, d in ipairs(clone:GetDescendants()) do
        if d:IsA("BasePart") then d.Anchored = true; d.CanCollide = false; d.CastShadow = false
        elseif d:IsA("Script") or d:IsA("LocalScript") or d:IsA("Tool") then d:Destroy() end
    end
    clone.Parent = vp
    clone:PivotTo(CFrame.new())
    local _, size = clone:GetBoundingBox()
    local h = math.max(size.Y, 4)
    cam.CFrame = CFrame.lookAt(Vector3.new(0, h * 0.5, h * 2.5), Vector3.new(0, h * 0.5, 0))
    applyChams()
end

player.CharacterAdded:Connect(function() task.wait(1) if gui.Parent then loadAvatar() end end)

local chamsCard = createCard(visuals.Left, "Chams", 1, function(v) State.Enabled = v; applyChams() end)
createToggle(chamsCard, "Outline", State.OutlineEnabled, function(v) State.OutlineEnabled = v; applyChams() end)
createToggle(chamsCard, "Rotate Preview", State.Rotate, function(v) State.Rotate = v end)
local matMap = {Solid = Enum.Material.SmoothPlastic, Neon = Enum.Material.Neon, Glass = Enum.Material.Glass, ForceField = Enum.Material.ForceField, Metal = Enum.Material.Metal}
createDropdown(chamsCard, "Material", {"Solid", "Neon", "Glass", "ForceField", "Metal"}, "Neon", function(v) State.Material = matMap[v]; applyChams() end)
createSlider(chamsCard, "Fill Opacity", 0, 1, State.FillOpacity, 2, function(v) State.FillOpacity = v; applyChams() end)
createSlider(chamsCard, "Outline Opacity", 0, 1, State.OutlineOpacity, 2, function(v) State.OutlineOpacity = v; applyChams() end)
createColorPicker(visuals.Right, "Color Picker", 2, function(color) State.FillColor = color; applyChams() end)

local espCard = createCard(visuals.Left, "2D ESP", 2, function(v) ESPState.Enabled = v end)
local er, eg, eb = 0, 255, 0
local function updateEspColor() ESPState.Color = Color3.fromRGB(er, eg, eb) end
createSlider(espCard, "ESP Red", 0, 255, er, 0, function(v) er = v; updateEspColor() end)
createSlider(espCard, "ESP Green", 0, 255, eg, 0, function(v) eg = v; updateEspColor() end)
createSlider(espCard, "ESP Blue", 0, 255, eb, 0, function(v) eb = v; updateEspColor() end)

local espFrames = {}
local function getEspBox(p)
    if not espFrames[p] then
        local box = create("Frame", {BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false}, gui)
        create("UIStroke", {Color = ESPState.Color, Thickness = 2}, box)
        espFrames[p] = box
    end
    return espFrames[p]
end

Players.PlayerRemoving:Connect(function(p)
    if espFrames[p] then espFrames[p]:Destroy() end
    espFrames[p] = nil
end)

local themeCard = createCard(themes.Left, "Theme Selector", 1)
local themeList = {
    {"RedLine", Color3.fromRGB(220, 50, 50)}, {"BlueWave", Color3.fromRGB(50, 150, 255)}, {"GreenPulse", Color3.fromRGB(50, 220, 100)}, {"PurpleHaze", Color3.fromRGB(150, 50, 220)}, {"Gold Rush", Color3.fromRGB(255, 200, 0)}
}
for i, data in ipairs(themeList) do
    local tName, tColor = unpack(data)
    local themeBtn = create("TextButton", {Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Theme.Element, Text = "", AutoButtonColor = false, LayoutOrder = i}, themeCard)
    create("UICorner", {CornerRadius = UDim.new(0, 4)}, themeBtn)
    local colorPreview = create("Frame", {Position = UDim2.fromOffset(5, 5), Size = UDim2.new(0, 30, 1, -10), BackgroundColor3 = tColor, BorderSizePixel = 0}, themeBtn)
    create("UICorner", {CornerRadius = UDim.new(0, 4)}, colorPreview)
    create("TextLabel", {Position = UDim2.fromOffset(45, 0), Size = UDim2.new(1, -50, 1, 0), BackgroundTransparency = 1, Text = tName, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left}, themeBtn)
    themeBtn.MouseButton1Click:Connect(function() updateAccent(tColor) end)
end

loadAvatar()
applyChams()
switchPage("Visuals")
setExtensionOpen(true)
navButtons["Visuals"].Accent.Visible = true
navButtons["Visuals"].Title.TextColor3 = Theme.Accent

local dragging, dragStart, startPos = false, nil, nil
closeBtn.MouseButton1Click:Connect(function() window.Visible = false end)
ContextActionService:BindAction("RedLineToggle", function(actionName, inputState) if inputState == Enum.UserInputState.Begin then window.Visible = not window.Visible end end, false, Enum.KeyCode.RightShift)

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePos = UserInputService:GetMouseLocation()
        local tp, ts, cp, cs = topbar.AbsolutePosition, topbar.AbsoluteSize, closeBtn.AbsolutePosition, closeBtn.AbsoluteSize
        local overTopbar = mousePos.X >= tp.X and mousePos.X <= tp.X + ts.X and mousePos.Y >= tp.Y and mousePos.Y <= tp.Y + ts.Y
        local overClose = mousePos.X >= cp.X and mousePos.X <= cp.X + cs.X and mousePos.Y >= cp.Y and mousePos.Y <= cp.Y + cs.Y
        if overTopbar and not overClose then dragging = true; dragStart = input.Position; startPos = window.Position end
    end
    
    if AimbotState.Enabled then
        local isAimKey, uName = false, input.UserInputType.Name
        if AimbotState.Key == Enum.KeyCode.MouseButton1 and uName == "MouseButton1" then isAimKey = true
        elseif AimbotState.Key == Enum.KeyCode.MouseButton2 and uName == "MouseButton2" then isAimKey = true
        elseif AimbotState.Key == Enum.KeyCode.MouseButton3 and uName == "MouseButton3" then isAimKey = true
        elseif input.KeyCode == AimbotState.Key then isAimKey = true end
        
        if isAimKey then AimbotState.IsAiming = true end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    
    local isAimKey, uName = false, input.UserInputType.Name
    if AimbotState.Key == Enum.KeyCode.MouseButton1 and uName == "MouseButton1" then isAimKey = true
    elseif AimbotState.Key == Enum.KeyCode.MouseButton2 and uName == "MouseButton2" then isAimKey = true
    elseif AimbotState.Key == Enum.KeyCode.MouseButton3 and uName == "MouseButton3" then isAimKey = true
    elseif input.KeyCode == AimbotState.Key then isAimKey = true end
    
    if isAimKey then AimbotState.IsAiming = false end
end)

track(RunService.RenderStepped:Connect(function(dt)
    if clone and State.Rotate then
        rot += dt * 1
        clone:PivotTo(CFrame.new() * CFrame.Angles(0, rot, 0))
    end

    fovCircle.Visible = AimbotState.Enabled and AimbotState.RenderFOV
    fovCircle.Size = UDim2.fromOffset(AimbotState.FOV * 2, AimbotState.FOV * 2)

    if AimbotState.Enabled and AimbotState.IsAiming then
        local camera = workspace.CurrentCamera
        local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
        local closestDist = AimbotState.FOV
        local closestPart = nil

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
                local targetPart = p.Character:FindFirstChild(AimbotState.TargetPart) or p.Character.HumanoidRootPart
                local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestPart = targetPart
                    end
                end
            end
        end

        if closestPart then
            camera.CFrame = CFrame.new(camera.CFrame.Position, closestPart.Position)
        end
    end

    if ESPState.Enabled then
        for _, p in ipairs(Players:GetPlayers()) do
            local box = getEspBox(p)
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
                local char = p.Character
                local root = char.HumanoidRootPart
                local head = char:FindFirstChild("Head") or root
                local camera = workspace.CurrentCamera
                local rootPos, onScreen = camera:WorldToViewportPoint(root.Position)
                local headPos = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1, 0))
                local legPos = camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                
                if onScreen then
                    local height = math.abs(headPos.Y - legPos.Y)
                    local width = height / 2
                    box.Size = UDim2.new(0, width, 0, height)
                    box.Position = UDim2.new(0, rootPos.X - width/2, 0, rootPos.Y - height/2)
                    box.Visible = true
                    box:FindFirstChild("UIStroke").Color = ESPState.Color
                else
                    box.Visible = false
                end
            else
                box.Visible = false
            end
        end
    else
        for _, box in pairs(espFrames) do box.Visible = false end
    end
end))

gui.Destroying:Connect(function()
    pcall(function() ContextActionService:UnbindAction("RedLineToggle") end)
    for _, conn in ipairs(Connections) do pcall(conn.Disconnect, conn) end
    _G.RedlineStudio = nil
end)

print("[RedLine] Visual Studio loaded. Press RightShift to toggle.")
