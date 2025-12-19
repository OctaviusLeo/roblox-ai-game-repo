-- OpenAI.lua
-- Thin HTTP client for OpenAI Responses API + Moderations.
-- Server-side ONLY.

local HttpService = game:GetService("HttpService")

local OpenAI = {}
OpenAI.__index = OpenAI

local function safeJsonDecode(str)
    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(str)
    end)
    if ok then return decoded end
    return nil
end

local function extractOutputText(responseObj)
    if type(responseObj) ~= "table" then
        return nil
    end

    -- Some SDKs expose output_text; keep as a convenience if present.
    if type(responseObj.output_text) == "string" and #responseObj.output_text > 0 then
        return responseObj.output_text
    end

    local output = responseObj.output
    if type(output) ~= "table" then
        return nil
    end

    for _, item in ipairs(output) do
        if item and item.type == "message" and item.role == "assistant" and type(item.content) == "table" then
            for _, c in ipairs(item.content) do
                if c and c.type == "output_text" and type(c.text) == "string" then
                    return c.text
                end
            end
        end
    end

    return nil
end

function OpenAI.new(apiKey, responsesUrl, moderationsUrl)
    assert(type(apiKey) == "string" and #apiKey > 0, "OpenAI API key missing")
    local self = setmetatable({}, OpenAI)
    self._apiKey = apiKey
    self._responsesUrl = responsesUrl
    self._moderationsUrl = moderationsUrl
    return self
end

function OpenAI:_postJson(url, bodyTable)
    local body = HttpService:JSONEncode(bodyTable)

    local result = HttpService:RequestAsync({
        Url = url,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
            ["Authorization"] = "Bearer " .. self._apiKey,
        },
        Body = body,
    })

    if not result.Success then
        return nil, ("HTTP request failed (%s): %s"):format(tostring(result.StatusCode), tostring(result.Body))
    end

    local decoded = safeJsonDecode(result.Body)
    if not decoded then
        return nil, "Failed to decode JSON response"
    end

    return decoded, nil
end

function OpenAI:moderateText(model, text)
    local payload = {
        model = model,
        input = text,
    }
    local decoded, err = self:_postJson(self._moderationsUrl, payload)
    if not decoded then
        return nil, err
    end

    -- Expected shape:
    -- { results = [ { flagged = bool, categories = {...}, category_scores = {...} } ] }
    local results = decoded.results
    if type(results) == "table" and results[1] and type(results[1].flagged) == "boolean" then
        return results[1], nil
    end

    return nil, "Unexpected moderation response shape"
end

function OpenAI:responsesCreate(model, input, maxOutputTokens, systemInstructions)
    -- "input" can be a string or a list of message objects.
    local payload = {
        model = model,
        input = input,
        max_output_tokens = maxOutputTokens,
        store = false,
    }

    -- Optional system instruction field; keep compatible with both string and message-list input.
    if type(systemInstructions) == "string" and #systemInstructions > 0 then
        payload.instructions = systemInstructions
    end

    local decoded, err = self:_postJson(self._responsesUrl, payload)
    if not decoded then
        return nil, err
    end

    local text = extractOutputText(decoded)
    if not text then
        return nil, "No output_text found in response"
    end

    return text, nil
end

return OpenAI
