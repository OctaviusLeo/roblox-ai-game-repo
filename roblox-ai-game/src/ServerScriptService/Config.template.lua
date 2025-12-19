-- Copy this file to Config.lua (same folder) and fill in your key.
-- DO NOT commit Config.lua.

return {
    OPENAI_API_KEY = "PASTE_KEY_HERE",
    MODEL = "gpt-5-mini",

    -- OpenAI endpoints
    RESPONSES_URL = "https://api.openai.com/v1/responses",
    MODERATIONS_URL = "https://api.openai.com/v1/moderations",

    -- Optional: set to false to skip the Moderations API call.
    USE_MODERATION = true,

    -- Output control
    MAX_OUTPUT_TOKENS = 220,

    -- Rate limit (token bucket)
    RATE_LIMIT = {
        capacity = 5,     -- max bursts
        refillSeconds = 30 -- refill period back to full
    },

    -- Conversation memory per player (number of turns; each turn ~ user+assistant)
    MAX_TURNS_IN_MEMORY = 6,
}
