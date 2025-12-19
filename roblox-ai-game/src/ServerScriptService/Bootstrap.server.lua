-- Bootstrap.server.lua
-- Spawns a simple NPC part with a ProximityPrompt that opens the AI chat UI.

local Workspace = game:GetService("Workspace")
local ServerScriptService = game:GetService("ServerScriptService")

local AIChatService = require(ServerScriptService:WaitForChild("AIChatService.server"))

local function ensureNPC()
    local existing = Workspace:FindFirstChild("AI_NPC")
    if existing and existing:IsA("Model") then
        return existing
    end

    local model = Instance.new("Model")
    model.Name = "AI_NPC"
    model.Parent = Workspace

    local part = Instance.new("Part")
    part.Name = "Body"
    part.Size = Vector3.new(4, 6, 2)
    part.Anchored = true
    part.Position = Vector3.new(0, 3, 0)
    part.Parent = model

    local prompt = Instance.new("ProximityPrompt")
    prompt.ActionText = "Talk"
    prompt.ObjectText = "AI NPC"
    prompt.KeyboardKeyCode = Enum.KeyCode.E
    prompt.MaxActivationDistance = 10
    prompt.Parent = part

    prompt.Triggered:Connect(function(player)
        AIChatService.OpenForPlayer(player)
    end)

    -- Billboard label
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "Label"
    billboard.Size = UDim2.fromOffset(200, 50)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = part

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.Text = "AI NPC"
    label.TextScaled = true
    label.Parent = billboard

    return model
end

ensureNPC()
