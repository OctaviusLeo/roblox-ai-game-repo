-- AIChatClient.client.lua
-- Creates a minimal UI, opens it when the server says, sends messages to server, shows responses.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local AIChatOpen = Remotes:WaitForChild("AIChatOpen")
local AIChatRequest = Remotes:WaitForChild("AIChatRequest")
local AIChatResponse = Remotes:WaitForChild("AIChatResponse")

-- UI creation (all via code to keep the repo minimal)
local gui = Instance.new("ScreenGui")
gui.Name = "AIChatGui"
gui.ResetOnSpawn = false
gui.Enabled = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Name = "Root"
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.fromScale(0.5, 0.75)
frame.Size = UDim2.fromOffset(520, 260)
frame.BackgroundTransparency = 0.1
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -80, 0, 28)
title.Position = UDim2.fromOffset(10, 8)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "AI NPC"
title.TextScaled = true
title.Parent = frame

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.Size = UDim2.fromOffset(60, 28)
closeBtn.Position = UDim2.new(1, -70, 0, 8)
closeBtn.Text = "X"
closeBtn.Parent = frame

local log = Instance.new("TextLabel")
log.Name = "Log"
log.Size = UDim2.new(1, -20, 0, 170)
log.Position = UDim2.fromOffset(10, 44)
log.BackgroundTransparency = 0.15
log.TextXAlignment = Enum.TextXAlignment.Left
log.TextYAlignment = Enum.TextYAlignment.Top
log.TextWrapped = true
log.TextScaled = false
log.TextSize = 16
log.Text = ""
log.RichText = false
log.Parent = frame

local input = Instance.new("TextBox")
input.Name = "Input"
input.Size = UDim2.new(1, -120, 0, 32)
input.Position = UDim2.fromOffset(10, 224)
input.PlaceholderText = "Type a message..."
input.ClearTextOnFocus = false
input.Text = ""
input.Parent = frame

local sendBtn = Instance.new("TextButton")
sendBtn.Name = "Send"
sendBtn.Size = UDim2.fromOffset(90, 32)
sendBtn.Position = UDim2.new(1, -100, 0, 224)
sendBtn.Text = "Send"
sendBtn.Parent = frame

local function appendLine(name, text)
    local line = ("%s: %s"):format(name, text)
    if #log.Text == 0 then
        log.Text = line
    else
        log.Text = log.Text .. "\n\n" .. line
    end
end

local function openUi()
    gui.Enabled = true
    input:CaptureFocus()
end

local function closeUi()
    gui.Enabled = false
    input:ReleaseFocus()
end

closeBtn.MouseButton1Click:Connect(closeUi)

AIChatOpen.OnClientEvent:Connect(function()
    openUi()
end)

AIChatResponse.OnClientEvent:Connect(function(fromName, text)
    if type(fromName) ~= "string" then fromName = "?" end
    if type(text) ~= "string" then text = "" end
    appendLine(fromName, text)
end)

local function send()
    local t = input.Text
    if type(t) ~= "string" or #t == 0 then return end
    input.Text = ""
    AIChatRequest:FireServer(t)
end

sendBtn.MouseButton1Click:Connect(send)

input.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        send()
    end
end)

-- Optional: press Escape to close if open
UserInputService.InputBegan:Connect(function(inp, gameProcessed)
    if gameProcessed then return end
    if inp.KeyCode == Enum.KeyCode.Escape and gui.Enabled then
        closeUi()
    end
end)
