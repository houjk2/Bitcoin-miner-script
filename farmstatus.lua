-- Gui to Lua
-- Version: 3.2

-- Instances:

local notif = Instance.new("ScreenGui")
local gputarget = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TextLabel = Instance.new("TextLabel")
local notification = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local TextLabel_2 = Instance.new("TextLabel")

--Properties:

notif.Name = "notif"
notif.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

gputarget.Name = "gputarget"
gputarget.Parent = notif
gputarget.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
gputarget.BackgroundTransparency = 0.300
gputarget.BorderSizePixel = 0
gputarget.Position = UDim2.new(0.035937503, 0, 0.789579576, 0)
gputarget.Size = UDim2.new(0.1796875, 0, 0.0694444478, 0)

UICorner.CornerRadius = UDim.new(0.200000012, 0)
UICorner.Parent = gputarget

TextLabel.Parent = gputarget
TextLabel.Text = "Deciding Gpu Target..."
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderSizePixel = 0
TextLabel.Size = UDim2.new(0, 345, 0, 76)
TextLabel.Font = Enum.Font.Oswald
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextStrokeTransparency = 0.000
TextLabel.TextWrapped = true

notification.Name = "notification"
notification.Parent = notif
notification.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
notification.BackgroundTransparency = 0.300
notification.BorderSizePixel = 0
notification.Position = UDim2.new(0.035937503, 0, 0.875246263, 0)
notification.Size = UDim2.new(0.1796875, 0, 0.0694444478, 0)

UICorner_2.CornerRadius = UDim.new(0.200000012, 0)
UICorner_2.Parent = notification

TextLabel_2.Parent = notification
TextLabel_2.Text = "Loading Information..."
TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.BackgroundTransparency = 1.000
TextLabel_2.BorderSizePixel = 0
TextLabel_2.Size = UDim2.new(0, 345, 0, 76)
TextLabel_2.Font = Enum.Font.Oswald
TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.TextScaled = true
TextLabel_2.TextSize = 14.000
TextLabel_2.TextStrokeTransparency = 0.000
TextLabel_2.TextWrapped = true
