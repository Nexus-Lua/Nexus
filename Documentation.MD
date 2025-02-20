# NexusLib UI Documentation

Welcome to the **NexusLib UI Documentation**! This document provides detailed information on how to use NexusLib's UI components effectively in your Roblox project.

## Installation

To use NexusLib UI, load the library using the following command:

```lua
local NexusLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nexus-Lua/Nexus/refs/heads/main/NexusLib"))()
```

Ensure that your script has access to `HttpGet` before attempting to load NexusLib.

## Getting Started

Once the library is loaded, you can create a UI instance:

```lua
local UI = NexusLib:CreateUI("My UI")
```

This creates a basic UI window that you can customize further.

---

## UI Components

### Window
#### Creating a Window
```lua
local Window = UI:CreateWindow("Title")
```

#### Properties
- **Title (string)** - The window's title.
- **Draggable (boolean)** - Allows the window to be dragged.
- **Size (UDim2)** - Sets the window size.

#### Methods
- `SetTitle(string title)` - Updates the window title.
- `SetSize(UDim2 size)` - Changes the window size.

#### Example
```lua
local myWindow = UI:CreateWindow("My Custom Window")
myWindow:SetSize(UDim2.new(0, 400, 0, 300))
```

---

### Button
#### Creating a Button
```lua
local Button = myWindow:CreateButton("Click Me")
```

#### Properties
- **Text (string)** - The button label.
- **Size (UDim2)** - Button size.

#### Methods
- `SetText(string text)` - Updates button text.
- `SetCallback(function callback)` - Assigns a function to execute on click.

#### Example
```lua
local button = myWindow:CreateButton("Click Me")
button:SetCallback(function()
    print("Button clicked!")
end)
```

---

### Label
#### Creating a Label
```lua
local Label = myWindow:CreateLabel("This is a label")
```

#### Properties
- **Text (string)** - The label content.
- **TextColor (Color3)** - Changes text color.

#### Methods
- `SetText(string text)` - Updates label content.
- `SetColor(Color3 color)` - Modifies text color.

#### Example
```lua
local label = myWindow:CreateLabel("Welcome to NexusLib UI!")
label:SetColor(Color3.fromRGB(255, 0, 0))
```

---

### Toggle
#### Creating a Toggle
```lua
local Toggle = myWindow:CreateToggle("Enable Feature", false)
```

#### Properties
- **Text (string)** - Toggle label.
- **State (boolean)** - Toggle state (on/off).

#### Methods
- `SetState(boolean state)` - Updates toggle state.
- `SetCallback(function callback)` - Executes function on state change.

#### Example
```lua
local toggle = myWindow:CreateToggle("Enable Sound", false)
toggle:SetCallback(function(state)
    print("Toggle state:", state)
end)
```

---

### Slider
#### Creating a Slider
```lua
local Slider = myWindow:CreateSlider("Volume", 0, 100, 50)
```

#### Properties
- **Text (string)** - Slider label.
- **Min (number)** - Minimum value.
- **Max (number)** - Maximum value.
- **Value (number)** - Default value.

#### Methods
- `SetValue(number value)` - Updates slider value.
- `SetCallback(function callback)` - Executes function when value changes.

#### Example
```lua
local slider = myWindow:CreateSlider("Brightness", 0, 100, 50)
slider:SetCallback(function(value)
    print("Brightness set to:", value)
end)
```

---

### Dropdown
#### Creating a Dropdown
```lua
local Dropdown = myWindow:CreateDropdown("Select Option", {"Option 1", "Option 2"})
```

#### Properties
- **Text (string)** - Dropdown label.
- **Options (table)** - Available options.

#### Methods
- `SetOptions(table options)` - Updates dropdown options.
- `SetCallback(function callback)` - Executes function on selection.

#### Example
```lua
local dropdown = myWindow:CreateDropdown("Choose Color", {"Red", "Green", "Blue"})
dropdown:SetCallback(function(selected)
    print("Selected:", selected)
end)
```

---

## Advanced Features

### UI Theme Customization
Customize UI colors and styles:

```lua
UI:SetTheme({
    BackgroundColor = Color3.fromRGB(30, 30, 30),
    TextColor = Color3.fromRGB(255, 255, 255),
})
```

### Saving & Loading Settings
Save user settings for persistence:

```lua
local settings = UI:SaveSettings()
UI:LoadSettings(settings)
```

---

## Conclusion
NexusLib UI provides a simple yet powerful way to create UI components in Roblox. With customization options and easy-to-use methods, it allows developers to build professional interfaces quickly.

If you encounter any issues or have suggestions, feel free to contribute to the project on GitHub!

Happy coding!
