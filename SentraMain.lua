local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local UI = {}
UI.__index = UI

function UI.new(title)
    local self = setmetatable({}, UI)
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "UILibrary"
    self.ScreenGui.Parent = game.CoreGui
    
    self.Main = Instance.new("Frame")
    self.Main.Name = "Main"
    self.Main.Parent = self.ScreenGui
    self.Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    self.Main.BorderSizePixel = 1
    self.Main.BorderColor3 = Color3.fromRGB(40, 40, 40)
    self.Main.Position = UDim2.new(0.5, -300, 0.5, -250)
    self.Main.Size = UDim2.new(0, 600, 0, 500)
    
    self.Title = Instance.new("TextLabel")
    self.Title.Name = "Title"
    self.Title.Parent = self.Main
    self.Title.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    self.Title.BorderSizePixel = 1
    self.Title.BorderColor3 = Color3.fromRGB(40, 40, 40)
    self.Title.Position = UDim2.new(0, 0, 0, 0)
    self.Title.Size = UDim2.new(1, 0, 0, 30)
    self.Title.Font = Enum.Font.Code
    self.Title.Text = title or "UI LIBRARY"
    self.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.Title.TextSize = 14
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.TextYAlignment = Enum.TextYAlignment.Center
    
    local titlePadding = Instance.new("UIPadding")
    titlePadding.Parent = self.Title
    titlePadding.PaddingLeft = UDim.new(0, 10)
    
    self.Categories = Instance.new("Frame")
    self.Categories.Name = "Categories"
    self.Categories.Parent = self.Main
    self.Categories.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    self.Categories.BorderSizePixel = 1
    self.Categories.BorderColor3 = Color3.fromRGB(40, 40, 40)
    self.Categories.Position = UDim2.new(0, 0, 0, 30)
    self.Categories.Size = UDim2.new(0, 150, 1, -30)
    
    self.Content = Instance.new("Frame")
    self.Content.Name = "Content"
    self.Content.Parent = self.Main
    self.Content.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    self.Content.BorderSizePixel = 0
    self.Content.Position = UDim2.new(0, 150, 0, 30)
    self.Content.Size = UDim2.new(1, -150, 1, -30)
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.Parent = self.Content
    contentPadding.PaddingTop = UDim.new(0, 10)
    contentPadding.PaddingLeft = UDim.new(0, 10)
    contentPadding.PaddingRight = UDim.new(0, 10)
    contentPadding.PaddingBottom = UDim.new(0, 10)
    
    self.ContentLayout = Instance.new("UIListLayout")
    self.ContentLayout.Parent = self.Content
    self.ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.ContentLayout.Padding = UDim.new(0, 5)
    
    self.CategoryLayout = Instance.new("UIListLayout")
    self.CategoryLayout.Parent = self.Categories
    self.CategoryLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    self.currentCategory = nil
    self.categories = {}
    
    self:makeDraggable()
    
    return self
end

function UI:makeDraggable()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    self.Title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.Main.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

function UI:addCategory(name)
    local categoryButton = Instance.new("TextButton")
    categoryButton.Name = name
    categoryButton.Parent = self.Categories
    categoryButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    categoryButton.BorderSizePixel = 1
    categoryButton.BorderColor3 = Color3.fromRGB(40, 40, 40)
    categoryButton.Size = UDim2.new(1, 0, 0, 40)
    categoryButton.Font = Enum.Font.Code
    categoryButton.Text = name
    categoryButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    categoryButton.TextSize = 12
    
    local categoryContent = Instance.new("ScrollingFrame")
    categoryContent.Name = name .. "Content"
    categoryContent.Parent = self.Content
    categoryContent.BackgroundTransparency = 1
    categoryContent.BorderSizePixel = 0
    categoryContent.Size = UDim2.new(1, 0, 1, 0)
    categoryContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    categoryContent.ScrollBarThickness = 8
    categoryContent.ScrollBarImageColor3 = Color3.fromRGB(40, 40, 40)
    categoryContent.Visible = false
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = categoryContent
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    
    layout.Changed:Connect(function()
        categoryContent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    
    categoryButton.MouseButton1Click:Connect(function()
        self:selectCategory(name)
    end)
    
    categoryButton.MouseEnter:Connect(function()
        categoryButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end)
    
    categoryButton.MouseLeave:Connect(function()
        if self.currentCategory ~= name then
            categoryButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        end
    end)
    
    self.categories[name] = {
        button = categoryButton,
        content = categoryContent
    }
    
    if not self.currentCategory then
        self:selectCategory(name)
    end
    
    return self
end

function UI:selectCategory(name)
    if self.currentCategory then
        self.categories[self.currentCategory].button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        self.categories[self.currentCategory].content.Visible = false
    end
    
    self.currentCategory = name
    self.categories[name].button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    self.categories[name].content.Visible = true
end

function UI:addButton(category, text, callback)
    local content = self.categories[category].content
    
    local button = Instance.new("TextButton")
    button.Name = text
    button.Parent = content
    button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    button.BorderSizePixel = 1
    button.BorderColor3 = Color3.fromRGB(50, 50, 50)
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Font = Enum.Font.Code
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    
    button.MouseButton1Click:Connect(callback)
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    end)
    
    return button
end

function UI:addSlider(category, text, min, max, default, callback)
    local content = self.categories[category].content
    
    local container = Instance.new("Frame")
    container.Name = text
    container.Parent = content
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, -10, 0, 50)
    
    local label = Instance.new("TextLabel")
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Font = Enum.Font.Code
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Parent = container
    sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    sliderFrame.BorderSizePixel = 1
    sliderFrame.BorderColor3 = Color3.fromRGB(50, 50, 50)
    sliderFrame.Position = UDim2.new(0, 0, 0, 25)
    sliderFrame.Size = UDim2.new(1, 0, 0, 20)
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Parent = sliderFrame
    sliderButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderButton.BorderSizePixel = 0
    sliderButton.Size = UDim2.new(0, 20, 1, 0)
    sliderButton.Text = ""
    
    local value = default
    local dragging = false
    
    local function updateSlider()
        local percentage = (value - min) / (max - min)
        sliderButton.Position = UDim2.new(percentage, -10, 0, 0)
        label.Text = text .. ": " .. tostring(math.floor(value * 100) / 100)
    end
    
    updateSlider()
    
    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local framePos = sliderFrame.AbsolutePosition.X
            local frameSize = sliderFrame.AbsoluteSize.X
            local relativePos = math.clamp((mousePos.X - framePos) / frameSize, 0, 1)
            value = min + (max - min) * relativePos
            updateSlider()
            callback(value)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return container
end

function UI:addColorPicker(category, text, default, callback)
    local content = self.categories[category].content
    local color = default or Color3.fromRGB(255, 255, 255)
    
    local container = Instance.new("Frame")
    container.Name = text
    container.Parent = content
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, -10, 0, 120)
    
    local label = Instance.new("TextLabel")
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Font = Enum.Font.Code
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local preview = Instance.new("Frame")
    preview.Parent = container
    preview.BackgroundColor3 = color
    preview.BorderSizePixel = 1
    preview.BorderColor3 = Color3.fromRGB(50, 50, 50)
    preview.Position = UDim2.new(0, 0, 0, 25)
    preview.Size = UDim2.new(1, 0, 0, 20)
    
    local rgbFrame = Instance.new("Frame")
    rgbFrame.Parent = container
    rgbFrame.BackgroundTransparency = 1
    rgbFrame.Position = UDim2.new(0, 0, 0, 50)
    rgbFrame.Size = UDim2.new(1, 0, 0, 60)
    
    local function createRGBSlider(name, yPos, initialValue)
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Parent = rgbFrame
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Position = UDim2.new(0, 0, 0, yPos)
        sliderLabel.Size = UDim2.new(0, 20, 0, 20)
        sliderLabel.Font = Enum.Font.Code
        sliderLabel.Text = name
        sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        sliderLabel.TextSize = 12
        
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Parent = rgbFrame
        sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        sliderFrame.BorderSizePixel = 1
        sliderFrame.BorderColor3 = Color3.fromRGB(50, 50, 50)
        sliderFrame.Position = UDim2.new(0, 25, 0, yPos)
        sliderFrame.Size = UDim2.new(1, -70, 0, 20)
        
        local sliderButton = Instance.new("TextButton")
        sliderButton.Parent = sliderFrame
        sliderButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        sliderButton.BorderSizePixel = 0
        sliderButton.Size = UDim2.new(0, 20, 1, 0)
        sliderButton.Text = ""
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Parent = rgbFrame
        valueLabel.BackgroundTransparency = 1
        valueLabel.Position = UDim2.new(1, -40, 0, yPos)
        valueLabel.Size = UDim2.new(0, 40, 0, 20)
        valueLabel.Font = Enum.Font.Code
        valueLabel.Text = tostring(initialValue)
        valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        valueLabel.TextSize = 12
        
        local value = initialValue
        local dragging = false
        
        local function updateSlider()
            local percentage = value / 255
            sliderButton.Position = UDim2.new(percentage, -10, 0, 0)
            valueLabel.Text = tostring(math.floor(value))
        end
        
        updateSlider()
        
        sliderButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePos = UserInputService:GetMouseLocation()
                local framePos = sliderFrame.AbsolutePosition.X
                local frameSize = sliderFrame.AbsoluteSize.X
                local relativePos = math.clamp((mousePos.X - framePos) / frameSize, 0, 1)
                value = relativePos * 255
                updateSlider()
                return value
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        return function() return value end
    end
    
    local getR = createRGBSlider("R", 0, color.R * 255)
    local getG = createRGBSlider("G", 20, color.G * 255)
    local getB = createRGBSlider("B", 40, color.B * 255)
    
    UserInputService.InputChanged:Connect(function()
        local newColor = Color3.fromRGB(getR(), getG(), getB())
        preview.BackgroundColor3 = newColor
        callback(newColor)
    end)
    
    return container
end

function UI:addComboBox(category, text, options, default, callback)
    local content = self.categories[category].content
    local selectedValue = default or options[1]
    
    local container = Instance.new("Frame")
    container.Name = text
    container.Parent = content
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, -10, 0, 50)
    
    local label = Instance.new("TextLabel")
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Font = Enum.Font.Code
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local comboButton = Instance.new("TextButton")
    comboButton.Parent = container
    comboButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    comboButton.BorderSizePixel = 1
    comboButton.BorderColor3 = Color3.fromRGB(50, 50, 50)
    comboButton.Position = UDim2.new(0, 0, 0, 25)
    comboButton.Size = UDim2.new(1, 0, 0, 25)
    comboButton.Font = Enum.Font.Code
    comboButton.Text = selectedValue .. " ▼"
    comboButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    comboButton.TextSize = 12
    
    local dropdown = Instance.new("Frame")
    dropdown.Parent = container
    dropdown.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    dropdown.BorderSizePixel = 1
    dropdown.BorderColor3 = Color3.fromRGB(50, 50, 50)
    dropdown.Position = UDim2.new(0, 0, 0, 50)
    dropdown.Size = UDim2.new(1, 0, 0, #options * 25)
    dropdown.Visible = false
    dropdown.ZIndex = 10
    
    local dropdownLayout = Instance.new("UIListLayout")
    dropdownLayout.Parent = dropdown
    dropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Parent = dropdown
        optionButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        optionButton.BorderSizePixel = 0
        optionButton.Size = UDim2.new(1, 0, 0, 25)
        optionButton.Font = Enum.Font.Code
        optionButton.Text = option
        optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionButton.TextSize = 12
        optionButton.ZIndex = 10
        
        optionButton.MouseButton1Click:Connect(function()
            selectedValue = option
            comboButton.Text = option .. " ▼"
            dropdown.Visible = false
            callback(option)
        end)
        
        optionButton.MouseEnter:Connect(function()
            optionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        end)
        
        optionButton.MouseLeave:Connect(function()
            optionButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        end)
    end
    
    comboButton.MouseButton1Click:Connect(function()
        dropdown.Visible = not dropdown.Visible
    end)
    
    return container
end

function UI:addToggle(category, text, default, callback)
    local content = self.categories[category].content
    local toggled = default or false
    
    local container = Instance.new("Frame")
    container.Name = text
    container.Parent = content
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, -10, 0, 30)
    
    local button = Instance.new("TextButton")
    button.Parent = container
    button.BackgroundColor3 = toggled and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(25, 25, 25)
    button.BorderSizePixel = 1
    button.BorderColor3 = Color3.fromRGB(50, 50, 50)
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Font = Enum.Font.Code
    button.Text = text .. " [" .. (toggled and "ON" or "OFF") .. "]"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    
    button.MouseButton1Click:Connect(function()
        toggled = not toggled
        button.BackgroundColor3 = toggled and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(25, 25, 25)
        button.Text = text .. " [" .. (toggled and "ON" or "OFF") .. "]"
        callback(toggled)
    end)
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = toggled and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(35, 35, 35)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = toggled and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(25, 25, 25)
    end)
    
    return container
end

function UI:addTextBox(category, text, placeholder, callback)
    local content = self.categories[category].content
    
    local container = Instance.new("Frame")
    container.Name = text
    container.Parent = content
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, -10, 0, 50)
    
    local label = Instance.new("TextLabel")
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Font = Enum.Font.Code
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local textBox = Instance.new("TextBox")
    textBox.Parent = container
    textBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    textBox.BorderSizePixel = 1
    textBox.BorderColor3 = Color3.fromRGB(50, 50, 50)
    textBox.Position = UDim2.new(0, 0, 0, 25)
    textBox.Size = UDim2.new(1, 0, 0, 25)
    textBox.Font = Enum.Font.Code
    textBox.PlaceholderText = placeholder or ""
    textBox.Text = ""
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.TextSize = 12
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    
    local padding = Instance.new("UIPadding")
    padding.Parent = textBox
    padding.PaddingLeft = UDim.new(0, 5)
    
    textBox.FocusLost:Connect(function()
        callback(textBox.Text)
    end)
    
    return container
end

function UI:addLabel(category, text)
    local content = self.categories[category].content
    
    local label = Instance.new("TextLabel")
    label.Parent = content
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -10, 0, 25)
    label.Font = Enum.Font.Code
    label.Text = text
    label.TextColor3 = Color3.fromRGB(180, 180, 180)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    
    return label
end

function UI:destroy()
    self.ScreenGui:Destroy()
end

local ui = UI.new("MINIMAL UI")

ui:addCategory("MAIN")
ui:addCategory("VISUALS")
ui:addCategory("MISC")

ui:addButton("MAIN", "Test Button", function()
    print("Button clicked!")
end)

ui:addToggle("MAIN", "Enable Feature", false, function(state)
    print("Toggle:", state)
end)

ui:addSlider("MAIN", "Speed", 0, 100, 50, function(value)
    print("Speed:", value)
end)

ui:addTextBox("MAIN", "Player Name", "Enter name...", function(text)
    print("Text entered:", text)
end)

ui:addColorPicker("VISUALS", "ESP Color", Color3.fromRGB(255, 0, 0), function(color)
    print("Color changed:", color)
end)

ui:addComboBox("VISUALS", "Render Mode", {"Wireframe", "Solid", "Transparent"}, "Solid", function(option)
    print("Render mode:", option)
end)

ui:addSlider("VISUALS", "Transparency", 0, 1, 0.5, function(value)
    print("Transparency:", value)
end)

ui:addLabel("MISC", "Version: 1.0.0")
ui:addLabel("MISC", "Author: User")

ui:addButton("MISC", "Reset Settings", function()
    print("Settings reset!")
end)

ui:addToggle("MISC", "Debug Mode", false, function(state)
    print("Debug:", state)
end)
