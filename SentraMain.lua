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
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    self.Main = Instance.new("Frame")
    self.Main.Name = "Main"
    self.Main.Parent = self.ScreenGui
    self.Main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    self.Main.BorderSizePixel = 0
    self.Main.Position = UDim2.new(0.5, -325, 0.5, -275)
    self.Main.Size = UDim2.new(0, 650, 0, 550)
    self.Main.ClipsDescendants = true
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.Parent = self.Main
    mainCorner.CornerRadius = UDim.new(0, 8)
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Parent = self.Main
    mainStroke.Color = Color3.fromRGB(45, 45, 45)
    mainStroke.Thickness = 1
    
    self.TopBar = Instance.new("Frame")
    self.TopBar.Name = "TopBar"
    self.TopBar.Parent = self.Main
    self.TopBar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    self.TopBar.BorderSizePixel = 0
    self.TopBar.Size = UDim2.new(1, 0, 0, 35)
    
    local topCorner = Instance.new("UICorner")
    topCorner.Parent = self.TopBar
    topCorner.CornerRadius = UDim.new(0, 8)
    
    local topStroke = Instance.new("UIStroke")
    topStroke.Parent = self.TopBar
    topStroke.Color = Color3.fromRGB(45, 45, 45)
    topStroke.Thickness = 1
    
    self.Title = Instance.new("TextLabel")
    self.Title.Name = "Title"
    self.Title.Parent = self.TopBar
    self.Title.BackgroundTransparency = 1
    self.Title.Position = UDim2.new(0, 15, 0, 0)
    self.Title.Size = UDim2.new(1, -30, 1, 0)
    self.Title.Font = Enum.Font.GothamBold
    self.Title.Text = title or "UI LIBRARY"
    self.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.Title.TextSize = 14
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.TextYAlignment = Enum.TextYAlignment.Center
    
    self.Categories = Instance.new("Frame")
    self.Categories.Name = "Categories"
    self.Categories.Parent = self.Main
    self.Categories.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    self.Categories.BorderSizePixel = 0
    self.Categories.Position = UDim2.new(0, 0, 0, 40)
    self.Categories.Size = UDim2.new(0, 170, 1, -40)
    
    local catCorner = Instance.new("UICorner")
    catCorner.Parent = self.Categories
    catCorner.CornerRadius = UDim.new(0, 6)
    
    local catStroke = Instance.new("UIStroke")
    catStroke.Parent = self.Categories
    catStroke.Color = Color3.fromRGB(35, 35, 35)
    catStroke.Thickness = 1
    
    self.Content = Instance.new("ScrollingFrame")
    self.Content.Name = "Content"
    self.Content.Parent = self.Main
    self.Content.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    self.Content.BorderSizePixel = 0
    self.Content.Position = UDim2.new(0, 175, 0, 40)
    self.Content.Size = UDim2.new(1, -180, 1, -45)
    self.Content.ScrollBarThickness = 6
    self.Content.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
    self.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.Parent = self.Content
    contentCorner.CornerRadius = UDim.new(0, 6)
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.Parent = self.Content
    contentPadding.PaddingTop = UDim.new(0, 15)
    contentPadding.PaddingLeft = UDim.new(0, 15)
    contentPadding.PaddingRight = UDim.new(0, 15)
    contentPadding.PaddingBottom = UDim.new(0, 15)
    
    self.ContentLayout = Instance.new("UIListLayout")
    self.ContentLayout.Parent = self.Content
    self.ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.ContentLayout.Padding = UDim.new(0, 8)
    
    self.ContentLayout.Changed:Connect(function()
        self.Content.CanvasSize = UDim2.new(0, 0, 0, self.ContentLayout.AbsoluteContentSize.Y + 30)
    end)
    
    self.CategoryLayout = Instance.new("UIListLayout")
    self.CategoryLayout.Parent = self.Categories
    self.CategoryLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.CategoryLayout.Padding = UDim.new(0, 5)
    
    local catPadding = Instance.new("UIPadding")
    catPadding.Parent = self.Categories
    catPadding.PaddingTop = UDim.new(0, 10)
    catPadding.PaddingLeft = UDim.new(0, 10)
    catPadding.PaddingRight = UDim.new(0, 10)
    
    self.currentCategory = nil
    self.categories = {}
    
    self:makeDraggable()
    
    return self
end

function UI:makeDraggable()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    self.TopBar.InputBegan:Connect(function(input)
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
    categoryButton.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    categoryButton.BorderSizePixel = 0
    categoryButton.Size = UDim2.new(1, 0, 0, 36)
    categoryButton.Font = Enum.Font.Gotham
    categoryButton.Text = name
    categoryButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    categoryButton.TextSize = 12
    
    local catButtonCorner = Instance.new("UICorner")
    catButtonCorner.Parent = categoryButton
    catButtonCorner.CornerRadius = UDim.new(0, 5)
    
    local categoryContent = Instance.new("Frame")
    categoryContent.Name = name .. "Content"
    categoryContent.Parent = self.Content
    categoryContent.BackgroundTransparency = 1
    categoryContent.Size = UDim2.new(1, 0, 0, 0)
    categoryContent.Visible = false
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = categoryContent
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    
    categoryButton.MouseButton1Click:Connect(function()
        self:selectCategory(name)
    end)
    
    categoryButton.MouseEnter:Connect(function()
        if self.currentCategory ~= name then
            TweenService:Create(categoryButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
        end
    end)
    
    categoryButton.MouseLeave:Connect(function()
        if self.currentCategory ~= name then
            TweenService:Create(categoryButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 28)}):Play()
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
        TweenService:Create(self.categories[self.currentCategory].button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 28), TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
        self.categories[self.currentCategory].content.Visible = false
    end
    
    self.currentCategory = name
    TweenService:Create(self.categories[name].button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    self.categories[name].content.Visible = true
end

function UI:addButton(category, text, callback)
    local content = self.categories[category].content
    
    local button = Instance.new("TextButton")
    button.Name = text
    button.Parent = content
    button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    button.BorderSizePixel = 0
    button.Size = UDim2.new(1, 0, 0, 32)
    button.Font = Enum.Font.Gotham
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.Parent = button
    buttonCorner.CornerRadius = UDim.new(0, 4)
    
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Parent = button
    buttonStroke.Color = Color3.fromRGB(40, 40, 40)
    buttonStroke.Thickness = 1
    
    button.MouseButton1Click:Connect(callback)
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
        TweenService:Create(buttonStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 60, 60)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
        TweenService:Create(buttonStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(40, 40, 40)}):Play()
    end)
    
    return button
end

function UI:addSlider(category, text, min, max, default, callback)
    local content = self.categories[category].content
    
    local container = Instance.new("Frame")
    container.Name = text
    container.Parent = content
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 55)
    
    local label = Instance.new("TextLabel")
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(1, -60, 0, 20)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Parent = container
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(1, -60, 0, 0)
    valueLabel.Size = UDim2.new(0, 60, 0, 20)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    valueLabel.TextSize = 12
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Parent = container
    sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Position = UDim2.new(0, 0, 0, 25)
    sliderFrame.Size = UDim2.new(1, 0, 0, 20)
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.Parent = sliderFrame
    sliderCorner.CornerRadius = UDim.new(0, 10)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Parent = sliderFrame
    sliderFill.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    sliderFill.BorderSizePixel = 0
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.Parent = sliderFill
    fillCorner.CornerRadius = UDim.new(0, 10)
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Parent = sliderFrame
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.BorderSizePixel = 0
    sliderButton.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    sliderButton.Size = UDim2.new(0, 16, 0, 16)
    sliderButton.Text = ""
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.Parent = sliderButton
    buttonCorner.CornerRadius = UDim.new(0, 8)
    
    local value = default
    local dragging = false
    
    local function updateSlider()
        local percentage = (value - min) / (max - min)
        TweenService:Create(sliderButton, TweenInfo.new(0.1), {Position = UDim2.new(percentage, -8, 0.5, -8)}):Play()
        TweenService:Create(sliderFill, TweenInfo.new(0.1), {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
        valueLabel.Text = tostring(math.floor(value * 100) / 100)
    end
    
    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            TweenService:Create(sliderButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 20, 0, 20)}):Play()
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
            TweenService:Create(sliderButton, TweenInfo.new(0.1), {Size = UDim2.new(0, 16, 0, 16)}):Play()
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
    container.Size = UDim2.new(1, 0, 0, 32)
    
    local label = Instance.new("TextLabel")
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(1, -40, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    
    local colorButton = Instance.new("TextButton")
    colorButton.Parent = container
    colorButton.BackgroundColor3 = color
    colorButton.BorderSizePixel = 0
    colorButton.Position = UDim2.new(1, -32, 0, 4)
    colorButton.Size = UDim2.new(0, 24, 0, 24)
    colorButton.Text = ""
    
    local colorCorner = Instance.new("UICorner")
    colorCorner.Parent = colorButton
    colorCorner.CornerRadius = UDim.new(0, 4)
    
    local colorStroke = Instance.new("UIStroke")
    colorStroke.Parent = colorButton
    colorStroke.Color = Color3.fromRGB(60, 60, 60)
    colorStroke.Thickness = 1
    
    colorButton.MouseButton1Click:Connect(function()
        self:createColorPicker(color, function(newColor)
            color = newColor
            colorButton.BackgroundColor3 = newColor
            callback(newColor)
        end)
    end)
    
    return container
end

function UI:createColorPicker(currentColor, callback)
    local colorWindow = Instance.new("Frame")
    colorWindow.Name = "ColorPicker"
    colorWindow.Parent = self.ScreenGui
    colorWindow.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    colorWindow.BorderSizePixel = 0
    colorWindow.Position = UDim2.new(0.5, -150, 0.5, -125)
    colorWindow.Size = UDim2.new(0, 300, 0, 250)
    colorWindow.ZIndex = 10
    
    local windowCorner = Instance.new("UICorner")
    windowCorner.Parent = colorWindow
    windowCorner.CornerRadius = UDim.new(0, 8)
    
    local windowStroke = Instance.new("UIStroke")
    windowStroke.Parent = colorWindow
    windowStroke.Color = Color3.fromRGB(60, 60, 60)
    windowStroke.Thickness = 1
    
    local titleBar = Instance.new("Frame")
    titleBar.Parent = colorWindow
    titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    titleBar.BorderSizePixel = 0
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.Parent = titleBar
    titleCorner.CornerRadius = UDim.new(0, 8)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = titleBar
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.Size = UDim2.new(1, -40, 1, 0)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "Color Picker"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 12
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextYAlignment = Enum.TextYAlignment.Center
    
    local closeButton = Instance.new("TextButton")
    closeButton.Parent = titleBar
    closeButton.BackgroundTransparency = 1
    closeButton.Position = UDim2.new(1, -30, 0, 0)
    closeButton.Size = UDim2.new(0, 30, 1, 0)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeButton.TextSize = 16
    
    local colorCanvas = Instance.new("ImageLabel")
    colorCanvas.Parent = colorWindow
    colorCanvas.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    colorCanvas.BorderSizePixel = 0
    colorCanvas.Position = UDim2.new(0, 10, 0, 40)
    colorCanvas.Size = UDim2.new(0, 200, 0, 150)
    colorCanvas.Image = "rbxassetid://4155801252"
    
    local canvasCorner = Instance.new("UICorner")
    canvasCorner.Parent = colorCanvas
    canvasCorner.CornerRadius = UDim.new(0, 4)
    
    local hueSlider = Instance.new("ImageLabel")
    hueSlider.Parent = colorWindow
    hueSlider.BackgroundTransparency = 1
    hueSlider.Position = UDim2.new(0, 220, 0, 40)
    hueSlider.Size = UDim2.new(0, 20, 0, 150)
    hueSlider.Image = "rbxassetid://3641079629"
    
    local hueCorner = Instance.new("UICorner")
    hueCorner.Parent = hueSlider
    hueCorner.CornerRadius = UDim.new(0, 4)
    
    local preview = Instance.new("Frame")
    preview.Parent = colorWindow
    preview.BackgroundColor3 = currentColor
    preview.BorderSizePixel = 0
    preview.Position = UDim2.new(0, 250, 0, 40)
    preview.Size = UDim2.new(0, 40, 0, 40)
    
    local previewCorner = Instance.new("UICorner")
    previewCorner.Parent = preview
    previewCorner.CornerRadius = UDim.new(0, 4)
    
    local h, s, v = Color3.toHSV(currentColor)
    local selectedColor = currentColor
    
    local colorSelector = Instance.new("Frame")
    colorSelector.Parent = colorCanvas
    colorSelector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    colorSelector.BorderSizePixel = 2
    colorSelector.BorderColor3 = Color3.fromRGB(0, 0, 0)
    colorSelector.Size = UDim2.new(0, 8, 0, 8)
    colorSelector.Position = UDim2.new(s, -4, 1-v, -4)
    
    local selectorCorner = Instance.new("UICorner")
    selectorCorner.Parent = colorSelector
    selectorCorner.CornerRadius = UDim.new(0, 4)
    
    local hueSelector = Instance.new("Frame")
    hueSelector.Parent = hueSlider
    hueSelector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hueSelector.BorderSizePixel = 2
    hueSelector.BorderColor3 = Color3.fromRGB(0, 0, 0)
    hueSelector.Size = UDim2.new(1, 4, 0, 4)
    hueSelector.Position = UDim2.new(0, -2, h, -2)
    
    local function updateColor()
        selectedColor = Color3.fromHSV(h, s, v)
        preview.BackgroundColor3 = selectedColor
        colorCanvas.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
    end
    
    updateColor()
    
    local colorDragging = false
    local hueDragging = false
    
    colorCanvas.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            colorDragging = true
        end
    end)
    
    hueSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if colorDragging then
                local mousePos = UserInputService:GetMouseLocation()
                local canvasPos = colorCanvas.AbsolutePosition
                local canvasSize = colorCanvas.AbsoluteSize
                
                s = math.clamp((mousePos.X - canvasPos.X) / canvasSize.X, 0, 1)
                v = math.clamp(1 - (mousePos.Y - canvasPos.Y) / canvasSize.Y, 0, 1)
                
                colorSelector.Position = UDim2.new(s, -4, 1-v, -4)
                updateColor()
            elseif hueDragging then
                local mousePos = UserInputService:GetMouseLocation()
                local sliderPos = hueSlider.AbsolutePosition
                local sliderSize = hueSlider.AbsoluteSize
                
                h = math.clamp((mousePos.Y - sliderPos.Y) / sliderSize.Y, 0, 1)
                
                hueSelector.Position = UDim2.new(0, -2, h, -2)
                updateColor()
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            colorDragging = false
            hueDragging = false
        end
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        callback(selectedColor)
        colorWindow:Destroy()
    end)
    
    local clickOutside = Instance.new("TextButton")
    clickOutside.Parent = self.ScreenGui
    clickOutside.BackgroundTransparency = 1
    clickOutside.Size = UDim2.new(1, 0, 1, 0)
    clickOutside.ZIndex = 9
    clickOutside.Text = ""
    
    clickOutside.MouseButton1Click:Connect(function()
        callback(selectedColor)
        colorWindow:Destroy()
        clickOutside:Destroy()
    end)
end

function UI:addComboBox(category, text, options, default, callback)
    local content = self.categories[category].content
    local selectedValue = default or options[1]
    
    local container = Instance.new("Frame")
    container.Name = text
    container.Parent = content
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 55)
    
    local label = Instance.new("TextLabel")
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local comboButton = Instance.new("TextButton")
    comboButton.Parent = container
    comboButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    comboButton.BorderSizePixel = 0
    comboButton.Position = UDim2.new(0, 0, 0, 25)
    comboButton.Size = UDim2.new(1, 0, 0, 30)
    comboButton.Font = Enum.Font.Gotham
    comboButton.Text = selectedValue .. " ▼"
    comboButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    comboButton.TextSize = 12
    
    local comboCorner = Instance.new("UICorner")
    comboCorner.Parent = comboButton
    comboCorner.CornerRadius = UDim.new(0, 4)
    
    local comboStroke = Instance.new("UIStroke")
    comboStroke.Parent = comboButton
    comboStroke.Color = Color3.fromRGB(40, 40, 40)
    comboStroke.Thickness = 1
    
    local dropdown = Instance.new("Frame")
    dropdown.Parent = container
    dropdown.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    dropdown.BorderSizePixel = 0
    dropdown.Position = UDim2.new(0, 0, 0, 56)
    dropdown.Size = UDim2.new(1, 0, 0, #options * 28)
    dropdown.Visible = false
    dropdown.ZIndex = 15
    
    local dropCorner = Instance.new("UICorner")
    dropCorner.Parent = dropdown
    dropCorner.CornerRadius = UDim.new(0, 4)
    
    local dropStroke = Instance.new("UIStroke")
    dropStroke.Parent = dropdown
    dropStroke.Color = Color3.fromRGB(50, 50, 50)
    dropStroke.Thickness = 1
    
    local dropdownLayout = Instance.new("UIListLayout")
    dropdownLayout.Parent = dropdown
    dropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Parent = dropdown
        optionButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        optionButton.BorderSizePixel = 0
        optionButton.Size = UDim2.new(1, 0, 0, 28)
        optionButton.Font = Enum.Font.Gotham
        optionButton.Text = option
        optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionButton.TextSize = 11
        optionButton.ZIndex = 15
        
        optionButton.MouseButton1Click:Connect(function()
            selectedValue = option
            comboButton.Text = option .. " ▼"
            dropdown.Visible = false
            callback(option)
        end)
        
        optionButton.MouseEnter:Connect(function()
            TweenService:Create(optionButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
        end)
        
        optionButton.MouseLeave:Connect(function()
            TweenService:Create(optionButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
        end)
    end
    
    comboButton.MouseButton1Click:Connect(function()
        dropdown.Visible = not dropdown.Visible
        container.Size = UDim2.new(1, 0, 0, dropdown.Visible and (55 + #options * 28) or 55)
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
    container.Size = UDim2.new(1, 0, 0, 32)
    
    local label = Instance.new("TextLabel")
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    
    local toggleFrame = Instance.new("TextButton")
    toggleFrame.Parent = container
    toggleFrame.BackgroundColor3 = toggled and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(30, 30, 30)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Position = UDim2.new(1, -40, 0.5, -10)
    toggleFrame.Size = UDim2.new(0, 40, 0, 20)
    toggleFrame.Text = ""
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.Parent = toggleFrame
    toggleCorner.CornerRadius = UDim.new(0, 10)
    
    local toggleStroke = Instance.new("UIStroke")
    toggleStroke.Parent = toggleFrame
    toggleStroke.Color = Color3.fromRGB(50, 50, 50)
    toggleStroke.Thickness = 1
    
    local toggleButton = Instance.new("Frame")
    toggleButton.Parent = toggleFrame
    toggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.BorderSizePixel = 0
    toggleButton.Position = toggled and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 4, 0.5, -6)
    toggleButton.Size = UDim2.new(0, 12, 0, 12)
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.Parent = toggleButton
    buttonCorner.CornerRadius = UDim.new(0, 6)
    
    toggleFrame.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        local targetPos = toggled and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 4, 0.5, -6)
        local targetBg = toggled and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(30, 30, 30)
        
        TweenService:Create(toggleButton, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(toggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = targetBg}):Play()
        
        callback(toggled)
    end)
    
    return container
end

function UI:addTextBox(category, text, placeholder, callback)
    local content = self.categories[category].content
    
    local container = Instance.new("Frame")
    container.Name = text
    container.Parent = content
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 55)
    
    local label = Instance.new("TextLabel")
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local textBox = Instance.new("TextBox")
    textBox.Parent = container
    textBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    textBox.BorderSizePixel = 0
    textBox.Position = UDim2.new(0, 0, 0, 25)
    textBox.Size = UDim2.new(1, 0, 0, 30)
    textBox.Font = Enum.Font.Gotham
    textBox.PlaceholderText = placeholder or ""
    textBox.Text = ""
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.TextSize = 12
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    
    local textCorner = Instance.new("UICorner")
    textCorner.Parent = textBox
    textCorner.CornerRadius = UDim.new(0, 4)
    
    local textStroke = Instance.new("UIStroke")
    textStroke.Parent = textBox
    textStroke.Color = Color3.fromRGB(40, 40, 40)
    textStroke.Thickness = 1
    
    local padding = Instance.new("UIPadding")
    padding.Parent = textBox
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    
    textBox.Focused:Connect(function()
        TweenService:Create(textStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(70, 70, 70)}):Play()
    end)
    
    textBox.FocusLost:Connect(function()
        TweenService:Create(textStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(40, 40, 40)}):Play()
        callback(textBox.Text)
    end)
    
    return container
end

function UI:addLabel(category, text)
    local content = self.categories[category].content
    
    local label = Instance.new("TextLabel")
    label.Parent = content
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, 25)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(160, 160, 160)
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    
    return label
end

function UI:destroy()
    self.ScreenGui:Destroy()
end

return UI
