-- AIChatService.server.lua
-- Handles UI open, player chat requests, filtering, moderation, rate-limiting, and model calls.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService")

local OpenAI = require(script.Parent:WaitForChild("OpenAI"))

local function getOrCreateFolder(parent, name)
    local f = parent:FindFirstChild(name)
    if f and f:IsA("Folder") then return f end
    f = Instance.new("Folder")
    f.Name = name
    f.Parent = parent
    return f
end

local function getOrCreateRemoteEvent(parent, name)
    local r = parent:FindFirstChild(name)
    if r and r:IsA("RemoteEvent") then return r end
    r = Instance.new("RemoteEvent")
    r.Name = name
    r.Parent = parent
    return r
end

local RemotesFolder = getOrCreateFolder(ReplicatedStorage, "Remotes")
local AIChatOpen = getOrCreateRemoteEvent(RemotesFolder, "AIChatOpen")
local AIChatRequest = getOrCreateRemoteEvent(RemotesFolder, "AIChatRequest")
local AIChatResponse = getOrCreateRemoteEvent(RemotesFolder, "AIChatResponse")

-- Load Config.lua (must exist; repo provides a template)
local okConfig, Config = pcall(function()
    return require(script.Parent:WaitForChild("Config"))
end)

if not okConfig then
    warn("[AIChat] Missing Config.lua. Copy Config.template.lua to Config.lua and add your API key.")
    Config = nil
end

local client = nil
if Config and type(Config.OPENAI_API_KEY) == "string" and #Config.OPENAI_API_KEY > 0 then
    client = OpenAI.new(Config.OPENAI_API_KEY, Config.RESPONSES_URL, Config.MODERATIONS_URL)
else
    warn("[AIChat] OpenAI client not initialized (missing key).")
end

-- Token bucket rate limiter per player
local buckets = {} -- userId -> {tokens, lastRefill}

local function now()
    return os.clock()
end

local function allowRequest(userId)
    if not Config or not Config.RATE_LIMIT then
        return true
    end

    local cap = tonumber(Config.RATE_LIMIT.capacity) or 5
    local refillSeconds = tonumber(Config.RATE_LIMIT.refillSeconds) or 30

    local b = buckets[userId]
    if not b then
        b = { tokens = cap, lastRefill = now() }
        buckets[userId] = b
    end

    local t = now()
    local elapsed = t - b.lastRefill
    if elapsed >= refillSeconds then
        b.tokens = cap
        b.lastRefill = t
    end

    if b.tokens <= 0 then
        return false
    end

    b.tokens -= 1
    return true
end

-- In-memory conversation context per player
local memory = {} -- userId -> { {role="user"/"assistant", content="..."}, ... }

local function pushTurn(userId, role, content)
    memory[userId] = memory[userId] or {}
    table.insert(memory[userId], { role = role, content = content })

    local maxTurns = (Config and tonumber(Config.MAX_TURNS_IN_MEMORY)) or 6
    -- Each "turn" is roughly 2 messages, so keep 2*maxTurns messages
    local maxMsgs = math.max(2, maxTurns * 2)
    while #memory[userId] > maxMsgs do
        table.remove(memory[userId], 1)
    end
end

local function getContext(userId)
    local ctx = memory[userId] or {}
    local out = {}

    -- Build a message list compatible with Responses "input".
    -- Put system instruction via "instructions" param (Config/field) instead of a system message,
    -- but keep user/assistant messages in context.
    for _, m in ipairs(ctx) do
        table.insert(out, { role = m.role, content = m.content })
    end

    return out
end

local function filterForUser(fromPlayer, targetPlayer, text)
    -- Server-side text filtering is recommended/required for user-generated content.
    -- FilterStringAsync returns a TextFilterResult; use GetNonChatStringForUserAsync for per-user display.
    local ok, result = pcall(function()
        return TextService:FilterStringAsync(text, fromPlayer.UserId)
    end)
    if not ok or not result then
        return "[Content unavailable]"
    end

    local ok2, filtered = pcall(function()
        return result:GetNonChatStringForUserAsync(targetPlayer.UserId)
    end)
    if ok2 and type(filtered) == "string" then
        return filtered
    end

    return "[Content unavailable]"
end

local function safeErrorToUser()
    return "I am not available right now."
end

local SYSTEM_INSTRUCTIONS = [[
You are a friendly NPC inside a Roblox game.
You must keep responses short (1-3 sentences) and appropriate for all ages.
Do not ask for personal information.
If the user asks for disallowed content, refuse briefly.
]]

local function doModerationIfEnabled(text)
    if not client or not Config or Config.USE_MODERATION ~= true then
        return { flagged = false }, nil
    end

    local result, err = client:moderateText("omni-moderation-latest", text)
    if not result then
        return nil, err
    end

    return result, nil
end

AIChatRequest.OnServerEvent:Connect(function(player, userText)
    if typeof(player) ~= "Instance" or not player:IsA("Player") then
        return
    end

    if type(userText) ~= "string" then
        return
    end

    userText = userText:sub(1, 400) -- hard cap

    if not allowRequest(player.UserId) then
        AIChatResponse:FireClient(player, "NPC", "You're sending messages too fast. Try again in a bit.")
        return
    end

    -- Moderate raw user text (optional)
    local mod, modErr = doModerationIfEnabled(userText)
    if modErr then
        -- If moderation fails, continue (still filtered for display).
        warn("[AIChat] Moderation error:", modErr)
    elseif mod and mod.flagged == true then
        AIChatResponse:FireClient(player, "NPC", "I can't help with that.")
        return
    end

    -- Filter what the player typed for their own UI display
    local filteredUserText = filterForUser(player, player, userText)
    AIChatResponse:FireClient(player, player.DisplayName, filteredUserText)

    if not client or not Config then
        AIChatResponse:FireClient(player, "NPC", safeErrorToUser())
        return
    end

    pushTurn(player.UserId, "user", userText)

    -- Build context for Responses input: list of {role, content}
    local context = getContext(player.UserId)
    -- Add current user message as the last message (already pushed, but ensure last)
    -- (No-op; context already includes it.)

    local text, err = client:responsesCreate(
        Config.MODEL,
        context,
        tonumber(Config.MAX_OUTPUT_TOKENS) or 200,
        SYSTEM_INSTRUCTIONS
    )

    if not text then
        warn("[AIChat] OpenAI error:", err)
        AIChatResponse:FireClient(player, "NPC", safeErrorToUser())
        return
    end

    pushTurn(player.UserId, "assistant", text)

    -- Filter AI output for this player before display
    local filteredAI = filterForUser(player, player, text)
    AIChatResponse:FireClient(player, "NPC", filteredAI)
end)

-- Cleanup on leave
Players.PlayerRemoving:Connect(function(player)
    buckets[player.UserId] = nil
    memory[player.UserId] = nil
end)

-- Public API (for Bootstrap to open UI)
local AIChatService = {}

function AIChatService.OpenForPlayer(player)
    AIChatOpen:FireClient(player)
end

return AIChatService
