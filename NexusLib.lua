-- NexusLib Module

local NexusLib = {}
NexusLib.__index = NexusLib

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- Initial configuration and themes
local themes = {
    Primary = Color3.fromRGB(28, 28, 38),
    Secondary = Color3.fromRGB(45, 45, 60),
    Accent = Color3.fromRGB(85, 170, 255),
    Text = Color3.fromRGB(255, 255, 255)
}

-- Animation settings
local ANIMATION_SETTINGS = {
    FadeDuration = 0.2,
    HoverIntensity = 0.1,
    ClickScale = 0.95,
    RippleColor = Color3.new(1, 1, 1), -- Default, can be set to themes.Accent later
    TransitionType = "FadeScale" -- or "Swipe"
}

-----------------------------------------------------------
-- Utility Functions
-----------------------------------------------------------

-- Utility function to create instances with properties
local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        instance[prop] = value
    end
    return instance
end

-- Utility function to animate an instance using tweens
local function Animate(instance, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    TweenService:Create(instance, tweenInfo, properties):Play()
end

-- Utility function to lighten a color for hover effects
local function LightenColor(color, intensity)
    return Color3.new(
        math.clamp(color.R + intensity, 0, 1),
        math.clamp(color.G + intensity, 0, 1),
        math.clamp(color.B + intensity, 0, 1)
    )
end

-----------------------------------------------------------
-- Main Window Creation with Entrance Animation
-----------------------------------------------------------
function NexusLib:CreateWindow(options)
    local window = {
        Tabs = {},
        CurrentTab = nil
    }

    -- Create the main container
    window.Main = CreateInstance("ScreenGui", {
        Name = options.Name or "NexusLib",
        Parent = options.Parent or game.CoreGui
    })

    window.MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        BackgroundColor3 = themes.Primary,
        Parent = window.Main
    })
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = window.MainFrame
    })

    -- Header
    window.Header = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = themes.Secondary,
        Parent = window.MainFrame
    })
    CreateInstance("TextLabel", {
        Text = options.Title or "NexusLib UI",
        Font = Enum.Font.GothamBold,
        TextColor3 = themes.Text,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = window.Header
    })

    -- Tab container
    window.TabContainer = CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -60),
        Position = UDim2.new(0, 10, 0, 50),
        BackgroundTransparency = 1,
        ScrollBarThickness = 5,
        Parent = window.MainFrame
    })
    CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 10),
        Parent = window.TabContainer
    })

    -- Entrance animation for the window
    window.MainFrame.Transparency = 1
    Animate(window.MainFrame, {Transparency = 0}, ANIMATION_SETTINGS.FadeDuration)

    return setmetatable(window, NexusLib)
end

-----------------------------------------------------------
-- Tab Management
-----------------------------------------------------------
function NexusLib:AddTab(name)
    local tab = {
        Name = name,
        Sections = {}
    }

    local tabButton = CreateInstance("TextButton", {
        Text = name,
        Size = UDim2.new(0, 120, 0, 30),
        BackgroundColor3 = themes.Secondary,
        TextColor3 = themes.Text,
        Parent = self.TabContainer
    })

    tab.Content = CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -50),
        Position = UDim2.new(0, 10, 0, 40),
        Visible = false,
        Parent = self.MainFrame
    })

    table.insert(self.Tabs, tab)
    if not self.CurrentTab then
        self:SwitchTab(tab)
    end

    return tab
end

-----------------------------------------------------------
-- Adding a Section to a Tab
-----------------------------------------------------------
function NexusLib.Tab:AddSection(title)
    local section = {
        Title = title,
        Elements = {}
    }

    section.Container = CreateInstance("Frame", {
        Size = UDim2.new(1, -10, 0, 0),
        BackgroundTransparency = 1,
        Parent = self.Content
    })

    CreateInstance("TextLabel", {
        Text = title,
        Font = Enum.Font.GothamSemibold,
        TextColor3 = themes.Text,
        Size = UDim2.new(1, 0, 0, 25),
        Parent = section.Container
    })

    CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 8),
        Parent = section.Container
    })

    table.insert(self.Sections, section)
    return section
end

-----------------------------------------------------------
-- UI Elements with Animations
-----------------------------------------------------------

-- Button with hover, click, and ripple effects
function NexusLib.Section:AddButton(options)
    local button = CreateInstance("TextButton", {
        Text = "  " .. options.Text,
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = themes.Secondary,
        TextColor3 = themes.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Container
    })
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = button
    })

    if options.Callback then
        button.MouseButton1Click:Connect(options.Callback)
    end

    -- Hover effect animation
    button.MouseEnter:Connect(function()
        Animate(button, {
            BackgroundColor3 = LightenColor(themes.Secondary, ANIMATION_SETTINGS.HoverIntensity),
            Size = UDim2.new(1, 0, 0, 38)
        }, 0.15)
    end)
    button.MouseLeave:Connect(function()
        Animate(button, {
            BackgroundColor3 = themes.Secondary,
            Size = UDim2.new(1, 0, 0, 35)
        }, 0.2)
    end)

    -- Click effect animation
    button.MouseButton1Down:Connect(function()
        Animate(button, {Size = UDim2.new(1, 0, 0, 33)}, 0.05)
    end)
    button.MouseButton1Up:Connect(function()
        Animate(button, {Size = UDim2.new(1, 0, 0, 35)}, 0.1)
    end)

    -- Ripple effect animation
    button.MouseButton1Click:Connect(function(x, y)
        local ripple = CreateInstance("Frame", {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0, x - button.AbsolutePosition.X, 0, y - button.AbsolutePosition.Y),
            BackgroundColor3 = ANIMATION_SETTINGS.RippleColor,
            Parent = button
        })
        CreateInstance("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ripple})
        Animate(ripple, {
            Size = UDim2.new(2, 0, 2, 0),
            Position = UDim2.new(-0.5, 0, -0.5, 0),
            BackgroundTransparency = 1
        }, 0.6)
        spawn(function()
            wait(0.6)
            ripple:Destroy()
        end)
    end)

    return button
end

-- Toggle (can be extended with more animations if needed)
function NexusLib.Section:AddToggle(options)
    local toggle = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundTransparency = 1,
        Parent = self.Container
    })

    local state = CreateInstance("Frame", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -30, 0.5, -10),
        BackgroundColor3 = themes.Secondary,
        Parent = toggle
    })
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = state
    })
    CreateInstance("TextLabel", {
        Text = options.Text,
        Font = Enum.Font.Gotham,
        TextColor3 = themes.Text,
        Size = UDim2.new(1, -40, 1, 0),
        Parent = toggle
    })

    local active = false
    toggle.MouseButton1Click:Connect(function()
        active = not active
        state.BackgroundColor3 = active and themes.Accent or themes.Secondary
        if options.Callback then
            options.Callback(active)
        end
    end)
    return toggle
end

-- Slider element with animation updates
function NexusLib.Section:AddSlider(options)
    local slider = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        Parent = self.Container
    })

    local value = math.clamp(options.Default or options.Min, options.Min, options.Max)
    
    local textLabel = CreateInstance("TextLabel", {
        Text = options.Text .. ": " .. value,
        Font = Enum.Font.Gotham,
        TextColor3 = themes.Text,
        Size = UDim2.new(1, 0, 0, 20),
        Parent = slider
    })

    local track = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 5),
        Position = UDim2.new(0, 0, 0, 25),
        BackgroundColor3 = themes.Secondary,
        Parent = slider
    })

    local fill = CreateInstance("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = themes.Accent,
        Parent = track
    })

    local thumb = CreateInstance("Frame", {
        Size = UDim2.new(0, 10, 0, 10),
        Position = UDim2.new(0, 0, 0.5, -5),
        BackgroundColor3 = themes.Text,
        Parent = track
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(1, 0), Parent = thumb})

    local function update(val)
        local percent = (val - options.Min) / (options.Max - options.Min)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        thumb.Position = UDim2.new(percent, -5, 0.5, -5)
        textLabel.Text = options.Text .. ": " .. math.floor(val)
        if options.Callback then
            options.Callback(val)
        end
    end

    track.MouseButton1Down:Connect(function()
        local connection
        connection = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local percent = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
                value = math.clamp(options.Min + (options.Max - options.Min) * percent, options.Min, options.Max)
                update(value)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
            end
        end)
    end)
    update(value)
    return slider
end

-- Color Picker element (simplified; complete HSV selection can be implemented as needed)
function NexusLib.Section:AddColorPicker(options)
    local colorPicker = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = self.Container
    })
    local preview = CreateInstance("Frame", {
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -30, 0.5, -12.5),
        BackgroundColor3 = options.Default or Color3.new(1,1,1),
        Parent = colorPicker
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 4), Parent = preview})
    
    local colorWindow
    preview.MouseButton1Click:Connect(function()
        if colorWindow then colorWindow:Destroy() end
        colorWindow = CreateInstance("Frame", {
            Size = UDim2.new(0, 200, 0, 200),
            Position = UDim2.new(1, 10, 0, 0),
            BackgroundColor3 = themes.Primary,
            Parent = colorPicker
        })
        -- Implement full HSV selector here as needed
    end)
    return colorPicker
end

-- Dropdown element with selection animations
function NexusLib.Section:AddDropdown(options)
    local dropdown = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = self.Container
    })
    local selected = options.Default
    local listVisible = false
    local button = CreateInstance("TextButton", {
        Text = selected or "Select...",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = themes.Secondary,
        TextColor3 = themes.Text,
        Parent = dropdown
    })
    local list = CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, 0, 0, 100),
        Position = UDim2.new(0, 0, 1, 5),
        BackgroundColor3 = themes.Primary,
        Visible = false,
        Parent = dropdown
    })
    local function toggleList()
        listVisible = not listVisible
        list.Visible = listVisible
    end
    local function selectItem(value)
        selected = value
        button.Text = value
        toggleList()
        if options.Callback then
            options.Callback(value)
        end
    end
    button.MouseButton1Click:Connect(toggleList)
    for _, option in pairs(options.Options) do
        local entry = CreateInstance("TextButton", {
            Text = option,
            Size = UDim2.new(1, 0, 0, 25),
            BackgroundColor3 = themes.Secondary,
            TextColor3 = themes.Text,
            Parent = list
        })
        entry.MouseButton1Click:Connect(function()
            selectItem(option)
        end)
    end
    return dropdown
end

-----------------------------------------------------------
-- Additional Features
-----------------------------------------------------------

-- Change a theme dynamically (update UI elements as needed)
function NexusLib:SetTheme(themeName, color)
    themes[themeName] = color
    -- Update all UI elements if required
end

-- Simple Save System Example
local SaveManager = {}

function SaveManager:SaveConfig(window, configName)
    local config = {}
    for _, tab in pairs(window.Tabs) do
        for _, section in pairs(tab.Sections) do
            for _, element in pairs(section.Elements) do
                if element.Type == "Slider" then
                    config[element.Identifier] = element.Value
                elseif element.Type == "Toggle" then
                    config[element.Identifier] = element.State
                end
            end
        end
    end
    writefile(configName .. ".json", HttpService:JSONEncode(config))
end

function SaveManager:LoadConfig(window, configName)
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(configName .. ".json"))
    end)
    if success then
        for _, tab in pairs(window.Tabs) do
            for _, section in pairs(tab.Sections) do
                for _, element in pairs(section.Elements) do
                    if data[element.Identifier] then
                        if element.Type == "Slider" then
                            element:SetValue(data[element.Identifier])
                        elseif element.Type == "Toggle" then
                            element:SetState(data[element.Identifier])
                        end
                    end
                end
            end
        end
    end
end

function NexusLib:EnableSaveSystem()
    self.SaveManager = SaveManager
end

-----------------------------------------------------------
-- Additional Animations
-----------------------------------------------------------

-- Window close animation
function NexusLib:Destroy()
    Animate(self.MainFrame, {Transparency = 1}, ANIMATION_SETTINGS.FadeDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    wait(ANIMATION_SETTINGS.FadeDuration)
    self.Main:Destroy()
end

-- Transition animation between tabs
function NexusLib:SwitchTab(tab)
    if self.CurrentTab then
        if ANIMATION_SETTINGS.TransitionType == "FadeScale" then
            Animate(self.CurrentTab.Content, {
                Transparency = 1,
                Size = UDim2.new(0.9, 0, 0.9, 0)
            }, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        else
            Animate(self.CurrentTab.Content, {
                Position = UDim2.new(-0.2, 0, 0, 0)
            }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        end
        wait(0.2)
        self.CurrentTab.Content.Visible = false
    end
    tab.Content.Transparency = 1
    tab.Content.Visible = true
    if ANIMATION_SETTINGS.TransitionType == "FadeScale" then
        tab.Content.Size = UDim2.new(0.9, 0, 0.9, 0)
        Animate(tab.Content, {
            Transparency = 0,
            Size = UDim2.new(1, 0, 1, 0)
        }, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    else
        tab.Content.Position = UDim2.new(1.2, 0, 0, 0)
        Animate(tab.Content, {
            Position = UDim2.new(0, 0, 0, 0)
        }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end
    self.CurrentTab = tab
end

-- Create an animated loading spinner
function NexusLib:CreateLoadingSpinner(parent)
    local spinner = CreateInstance("Frame", {
        Size = UDim2.new(0, 40, 0, 40),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    local circle = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = spinner
    })
    CreateInstance("UIAspectRatioConstraint", {Parent = circle})
    
    local gradient = CreateInstance("UIGradient", {
        Rotation = 0,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.49, 0),
            NumberSequenceKeypoint.new(0.5, 1),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Parent = circle
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(1, 0), Parent = circle})
    
    spawn(function()
        while spinner.Parent do
            Animate(gradient, {Rotation = 360}, 2, Enum.EasingStyle.Linear)
            wait(2)
        end
    end)
    
    return spinner
end

-----------------------------------------------------------
-- Custom Configuration (Example)
-----------------------------------------------------------
-- For example, we can redefine the transition type and ripple color:
ANIMATION_SETTINGS.TransitionType = "Swipe"
ANIMATION_SETTINGS.RippleColor = themes.Accent

return NexusLib
