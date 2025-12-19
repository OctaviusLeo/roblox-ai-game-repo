# Roblox AI NPC (Rojo) - Minimal Working Example

This repo is a **minimal Roblox experience** that lets players talk to an in-game "AI NPC".
AI calls are made **server-side** via HttpService, with:
- Roblox **text filtering** (TextService:FilterStringAsync + TextFilterResult methods)
- OpenAI **moderation** (optional but enabled by default)
- Per-player **rate limiting**
- Short per-player **conversation memory**

## What you get in-game
- A simple on-screen chat UI (press **E** on the NPC prompt to open)
- Player message -> server -> OpenAI -> filtered response -> UI

## Requirements
- Roblox Studio
- HTTP requests enabled in your experience (Game Settings -> Security -> **Allow HTTP Requests**)
- An OpenAI API key

## Quick start (Rojo workflow)
1. Install Rojo (any method you prefer) and the Rojo Studio plugin.
2. In Roblox Studio, create/open a place.
3. From a terminal in this repo folder:
   - `rojo serve`
4. In Studio (Rojo plugin), connect and sync the project.
5. Create your config:
   - Copy `src/ServerScriptService/Config.template.lua` to `src/ServerScriptService/Config.lua`
   - Put your key in `Config.lua` (do NOT commit it).
6. Play (F5). Walk to the NPC part and press **E**.

## Switching models
Edit `MODEL` in `Config.lua`. Default is `gpt-5-mini`.

## Notes on secrets
Never expose your API key to clients. Keep it in **ServerScriptService** and out of git.
This repo ignores `Config.lua` via `.gitignore`.

## Troubleshooting
- If you see HTTP errors: confirm **Allow HTTP Requests** is enabled and the server can reach `api.openai.com`.
- If you get blank responses: check output logs for HTTP status/body.
