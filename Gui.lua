local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local PremiumGUI = {}
PremiumGUI.__index = PremiumGUI

function PremiumGUI.new()
    local self = setmetatable({}, PremiumGUI)
    self:Initialize()
    return self
end

function PremiumGUI:Initialize()
    self:CreateMainUI()
    
    self.minSize = Vector2.new(200, 150)
    self.maxSize = Vector2.new(600, 400)
    self.isResizing = false
    self.resizeStartPos = nil
    self.startSize = nil
    
    self:SetupDrag()
    self:SetupResize()
end

function PremiumGUI:CreateMainUI()
    -- ScreenGui
    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Name = "PremiumMobileGUI"
    self.screenGui.ResetOnSpawn = false
    self.screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.screenGui.Parent = game.CoreGui

    -- Main Frame
    self.mainFrame = Instance.new("Frame")
    self.mainFrame.Name = "MainFrame"
    self.mainFrame.Size = UDim2.new(0, 300, 0, 200)
    self.mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    self.mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    self.mainFrame.BackgroundTransparency = 0.1
    self.mainFrame.BorderSizePixel = 0
    self.mainFrame.ClipsDescendants = true
    self.mainFrame.Parent = self.screenGui

    -- UICorner
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = self.mainFrame

    -- UIStroke
    local UIStroke = Instance.new("UIStroke")
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Color3.fromRGB(60, 60, 80)
    UIStroke.LineJoinMode = Enum.LineJoinMode.Round
    UIStroke.Thickness = 2
    UIStroke.Parent = self.mainFrame

    -- Header
    self:CreateHeader()
    
    -- Content Frame
    self.contentFrame = Instance.new("Frame")
    self.contentFrame.Name = "ContentFrame"
    self.contentFrame.Size = UDim2.new(1, -20, 1, -60)
    self.contentFrame.Position = UDim2.new(0, 10, 0, 50)
    self.contentFrame.BackgroundTransparency = 1
    self.contentFrame.Parent = self.mainFrame

    -- Resize Handle
    self:CreateResizeHandle()
    
    -- Animate In
    self:AnimateIn()
end

function PremiumGUI:CreateHeader()
    -- Title
    self.title = Instance.new("TextLabel")
    self.title.Name = "Title"
    self.title.Size = UDim2.new(1, 0, 0, 40)
    self.title.Position = UDim2.new(0, 0, 0, 0)
    self.title.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    self.title.BackgroundTransparency = 0
    self.title.Font = Enum.Font.GothamSemibold
    self.title.Text = "Premium GUI"
    self.title.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.title.TextSize = 18
    self.title.Parent = self.mainFrame

    -- Title Corner
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = self.title

    -- Close Button
    self.closeButton = Instance.new("TextButton")
    self.closeButton.Name = "CloseButton"
    self.closeButton.Size = UDim2.new(0, 30, 0, 30)
    self.closeButton.Position = UDim2.new(1, -35, 0, 5)
    self.closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    self.closeButton.Font = Enum.Font.GothamBold
    self.closeButton.Text = "X"
    self.closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.closeButton.TextSize = 14
    self.closeButton.Parent = self.mainFrame

    -- Close Button Corner
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = self.closeButton
    
    -- Close Button Event
    self.closeButton.MouseButton1Click:Connect(function()
        self:Close()
    end)
end

function PremiumGUI:CreateResizeHandle()
    self.resizeHandle = Instance.new("Frame")
    self.resizeHandle.Name = "ResizeHandle"
    self.resizeHandle.Size = UDim2.new(0, 20, 0, 20)
    self.resizeHandle.Position = UDim2.new(1, -20, 1, -20)
    self.resizeHandle.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    self.resizeHandle.BackgroundTransparency = 0.7
    self.resizeHandle.BorderSizePixel = 0
    self.resizeHandle.Parent = self.mainFrame

    -- Resize Icon (3 diagonal lines)
    for i = 1, 3 do
        local line = Instance.new("Frame")
        line.Name = "Line"..i
        line.Size = UDim2.new(0, 10, 0, 2)
        line.Position = UDim2.new(0, 5, 0, 5 + (i-1)*5)
        line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        line.BorderSizePixel = 0
        line.Rotation = 45
        line.Parent = self.resizeHandle
    end
end

function PremiumGUI:SetupDrag()
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        self.mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    self.title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    self.title.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

function PremiumGUI:SetupResize()
    self.resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self.isResizing = true
            self.resizeStartPos = input.Position
            self.startSize = self.mainFrame.Size
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    self.isResizing = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if self.isResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - self.resizeStartPos
            local newWidth = math.clamp(self.startSize.Width.Offset + delta.X, self.minSize.X, self.maxSize.X)
            local newHeight = math.clamp(self.startSize.Height.Offset + delta.Y, self.minSize.Y, self.maxSize.Y)
            self.mainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)
end

function PremiumGUI:AnimateIn()
    self.mainFrame.Size = UDim2.new(0, 10, 0, 10)
    self.mainFrame.BackgroundTransparency = 1
    self.title.BackgroundTransparency = 1
    self.title.TextTransparency = 1

    local tweenIn = TweenService:Create(
        self.mainFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad),
        {Size = UDim2.new(0, 300, 0, 200), BackgroundTransparency = 0.1}
    )
    
    local tweenTitle = TweenService:Create(
        self.title,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad),
        {BackgroundTransparency = 0, TextTransparency = 0}
    )
    
    tweenIn:Play()
    tweenTitle:Play()
end

function PremiumGUI:Close()
    local tweenOut = TweenService:Create(
        self.mainFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad),
        {Size = UDim2.new(0, 10, 0, 10), BackgroundTransparency = 1}
    )
    
    local tweenTitleOut = TweenService:Create(
        self.title,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad),
        {BackgroundTransparency = 1, TextTransparency = 1}
    )
    
    tweenOut:Play()
    tweenTitleOut:Play()
    
    tweenOut.Completed:Wait()
    self.mainFrame.Visible = false
    self:CreateRestoreButton()
end

function PremiumGUI:CreateRestoreButton()
    if self.restoreButton then
        self.restoreButton:Destroy()
    end
    
    self.restoreButton = Instance.new("TextButton")
    self.restoreButton.Name = "RestoreButton"
    self.restoreButton.Size = UDim2.new(0, 40, 0, 40)
    self.restoreButton.Position = UDim2.new(0, 10, 0, 10)
    self.restoreButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    self.restoreButton.Font = Enum.Font.GothamBold
    self.restoreButton.Text = ">"
    self.restoreButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.restoreButton.TextSize = 16
    self.restoreButton.ZIndex = 10
    self.restoreButton.Parent = self.screenGui
    
    local RestoreCorner = Instance.new("UICorner")
    RestoreCorner.CornerRadius = UDim.new(0, 8)
    RestoreCorner.Parent = self.restoreButton
    
    local RestoreStroke = Instance.new("UIStroke")
    RestoreStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    RestoreStroke.Color = Color3.fromRGB(60, 60, 80)
    RestoreStroke.LineJoinMode = Enum.LineJoinMode.Round
    RestoreStroke.Thickness = 2
    RestoreStroke.Parent = self.restoreButton
    
    -- Drag logic
    local btnDragging = false
    local btnDragStart
    local btnStartPos
    
    self.restoreButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            btnDragging = true
            btnDragStart = input.Position
            btnStartPos = self.restoreButton.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    btnDragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if btnDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - btnDragStart
            self.restoreButton.Position = UDim2.new(
                btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X,
                btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Restore logic
    self.restoreButton.MouseButton1Click:Connect(function()
        if not btnDragging then
            self.mainFrame.Visible = true
            self.restoreButton:Destroy()
            self:AnimateIn()
        end
    end)
end

-- Public API
function PremiumGUI:AddButton(name, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, -20, 0, 35)
    button.Position = UDim2.new(0, 10, 0, #self.contentFrame:GetChildren() * 40)
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    button.Font = Enum.Font.Gotham
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Parent = self.contentFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    if callback then
        button.MouseButton1Click:Connect(callback)
    end
    
    -- Update content size
    self.contentFrame.Size = UDim2.new(1, -20, 0, #self.contentFrame:GetChildren() * 40 + 10)
    self.mainFrame.Size = UDim2.new(
        0, math.clamp(self.mainFrame.Size.Width.Offset, self.minSize.X, self.maxSize.X), 
        0, math.clamp(60 + self.contentFrame.Size.Y.Offset, self.minSize.Y, self.maxSize.Y)
    )
    
    return button
end
ndndd
