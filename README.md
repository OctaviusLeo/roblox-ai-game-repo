# Roblox AI-Powered NPC Interaction System

[![Roblox](https://img.shields.io/badge/Roblox-Game%20Development-00A2FF?style=flat&logo=roblox)](https://www.roblox.com/users/35190321/profile)
[![OpenAI](https://img.shields.io/badge/OpenAI-API-412991?style=flat&logo=openai)](https://openai.com/)
[![Lua](https://img.shields.io/badge/Lua-Game%20Logic-2C2D72?style=flat&logo=lua)](https://www.lua.org/)

A production-ready Roblox game system featuring **AI-powered NPC interactions** with enterprise-grade security, content moderation, and scalable architecture. This project demonstrates advanced game development capabilities including server-side API integration, real-time chat filtering, and intelligent conversation management.

**[Live Demo](https://www.roblox.com/users/35190321/profile)** | **[Video Walkthrough](#)**

---

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Technical Architecture](#technical-architecture)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [Project Structure](#project-structure)
- [Security & Best Practices](#security--best-practices)
- [Troubleshooting](#troubleshooting)
- [Future Development](#future-development)
- [Technologies Used](#technologies-used)

---

## Overview

This repository contains a **fully functional AI-integrated Roblox game** that enables dynamic player-NPC conversations powered by OpenAI's language models. Built with professional development practices using **Rojo** for version control and modular architecture, this project showcases:

- **Full-stack game development** with client-server architecture
- **API integration** with external AI services
- **Security-first design** with content filtering and rate limiting
- **Scalable conversation management** with per-player memory systems

<details>
<summary><strong>What Players Experience</strong></summary>

### In-Game Features
- **Interactive NPC Chat UI**: Press **E** near NPCs to initiate conversations
- **Real-time AI Responses**: Natural language processing for dynamic dialogue
- **Safe Environment**: All messages filtered through Roblox's TextService and OpenAI moderation
- **Smooth Performance**: Optimized client-server communication with minimal latency

### Technical Flow
```
Player Input > Client UI > Server (HttpService) > OpenAI API > Content Filtering > Response Display
```

</details>

---

## Key Features

<details>
<summary><strong>Enterprise-Grade Security</strong></summary>

- **Server-Side API Calls**: All OpenAI requests handled securely on the server
- **Dual Content Filtering**: 
  - Roblox TextService:FilterStringAsync for platform compliance
  - OpenAI Moderation API for additional content safety
- **API Key Protection**: Secure configuration management with `.gitignore` exclusions
- **Zero Client Exposure**: No sensitive data transmitted to game clients

</details>

<details>
<summary><strong>Performance & Scalability</strong></summary>

- **Per-Player Rate Limiting**: Prevents API abuse and manages costs
- **Conversation Memory Management**: Efficient short-term context retention per player
- **Optimized HTTP Requests**: Asynchronous communication with error handling
- **Resource-Efficient Design**: Minimal server load with smart caching

</details>

<details>
<summary><strong>Developer Experience</strong></summary>

- **Rojo Integration**: Modern workflow with Git-friendly project structure
- **Modular Architecture**: Clean separation of concerns (Config, Services, Client)
- **Easy Model Switching**: Simple configuration for different OpenAI models
- **Template-Based Setup**: Quick deployment with configuration templates
- **Comprehensive Error Handling**: Detailed logging for debugging

</details>

---

## Technical Architecture

<details>
<summary><strong>System Architecture Diagram</strong></summary>

```
[Game Client]
(StarterPlayer)
      |
      | RemoteEvent
      v
[Server Layer]
(ServerScript)
- AIChatService
- Bootstrap
- OpenAI Module
      |
      | HttpService
      v
[OpenAI API]
(External)
```

</details>

<details>
<summary><strong>Component Breakdown</strong></summary>

### Server Components
- **AIChatService.server.lua**: Main orchestration layer for chat logic
- **Bootstrap.server.lua**: Initialization and dependency injection
- **OpenAI.lua**: API wrapper module with error handling and rate limiting
- **Config.lua**: Centralized configuration (API keys, model settings)

### Client Components
- **AIChatClient.client.lua**: UI management and server communication

### Configuration
- **default.project.json**: Rojo project definition for sync configuration

</details>

---

## Getting Started

### Prerequisites

- **Roblox Studio** (Latest version)
- **Rojo** (v7.0+) - [Installation Guide](https://rojo.space/docs/v7/getting-started/installation/)
- **Rojo Studio Plugin** - [Install from Roblox](https://www.roblox.com/library/13916111004/Rojo-7-4-1)
- **OpenAI API Key** - [Get one here](https://platform.openai.com/api-keys)

### Installation Steps

<details>
<summary><strong>Step 1: Clone & Setup</strong></summary>

```powershell
# Clone the repository
git clone <repository-url>
cd roblox-ai-game-repo

# Install Rojo (if not already installed)
# Option 1: Using Aftman
aftman install

# Option 2: Using Foreman
foreman install

# Option 3: Direct download from rojo.space
```

</details>

<details>
<summary><strong>Step 2: Configure Roblox Studio</strong></summary>

1. Open **Roblox Studio**
2. Create a new place or open an existing one
2. Go to **Game Settings** > **Security**
3. Enable **"Allow HTTP Requests"**
5. Install the **Rojo Studio Plugin** from the [Roblox Library](https://www.roblox.com/library/13916111004/)

</details>

<details>
<summary><strong>Step 3: Start Rojo Server</strong></summary>

```powershell
# From the project root directory
rojo serve
```

You should see: `Rojo server listening on 0.0.0.0:34872`

</details>

<details>
<summary><strong>Step 4: Sync with Studio</strong></summary>

1. In **Roblox Studio**, click the **Rojo plugin** toolbar button
2. Click **"Connect"** (should connect to `localhost:34872`)
3. Click **"Sync In"** to sync the project files

</details>

<details>
<summary><strong>Step 5: Configure API Key</strong></summary>

```powershell
# Copy the configuration template
Copy-Item src/ServerScriptService/Config.template.lua src/ServerScriptService/Config.lua

# Edit Config.lua and add your OpenAI API key
# WARNING: NEVER commit this file to version control
```

**Config.lua Example:**
```lua
return {
    OPENAI_API_KEY = "sk-your-api-key-here",
    MODEL = "gpt-4o-mini",
    MAX_TOKENS = 150,
    -- Additional configuration...
}
```

</details>

<details>
<summary><strong>Step 6: Test the Game</strong></summary>

1. Press **F5** in Roblox Studio to start the game
2. Walk your character to the NPC
3. Press **E** to open the chat interface
4. Start chatting with the AI-powered NPC!

</details>

---

## Configuration

<details>
<summary><strong>Model Selection</strong></summary>

Edit the `MODEL` parameter in [Config.lua](roblox-ai-game/src/ServerScriptService/Config.lua):

```lua
MODEL = "gpt-4o-mini"  -- Fast and cost-effective (default)
-- MODEL = "gpt-4o"    -- More capable, higher cost
-- MODEL = "gpt-4"     -- Most capable, highest cost
```

</details>

<details>
<summary><strong>Rate Limiting</strong></summary>

Adjust rate limits to control API usage:

```lua
RATE_LIMIT = {
    MAX_REQUESTS = 10,      -- Max requests per time window
    TIME_WINDOW = 60,       -- Time window in seconds
}
```

</details>

<details>
<summary><strong>Conversation Memory</strong></summary>

Configure memory retention:

```lua
MEMORY_CONFIG = {
    MAX_HISTORY = 10,       -- Number of messages to remember
    CONTEXT_WINDOW = 5,     -- Messages sent with each request
}
```

</details>

---

## Project Structure

```
roblox-ai-game-repo/
|-- roblox-ai-game/              # Main game project
|   |-- default.project.json     # Rojo project configuration
|   +-- src/
|       |-- ServerScriptService/ # Server-side logic
|       |   |-- AIChatService.server.lua    # Main chat orchestration
|       |   |-- Bootstrap.server.lua        # System initialization
|       |   |-- OpenAI.lua                  # OpenAI API module
|       |   +-- Config.template.lua         # Configuration template
|       +-- StarterPlayer/
|           +-- StarterPlayerScripts/
|               +-- AIChatClient.client.lua # Client UI & communication
|-- cse482-reddit-events/        # Additional project (separate)
+-- README.md                    # This file
```

---

## Security & Best Practices

<details>
<summary><strong>API Key Management</strong></summary>

### DO:
- Store API keys in `Config.lua` (ignored by Git)
- Keep all secrets in ServerScriptService
- Use environment variables for production deployments
- Regularly rotate API keys

### DON'T:
- Commit `Config.lua` to version control
- Expose API keys to client scripts
- Hardcode keys in public code
- Share keys in screenshots or videos

</details>

<details>
<summary><strong>Content Moderation</strong></summary>

This system implements **dual-layer moderation**:

1. **Input Filtering**: All player messages filtered before API call
2. **Output Filtering**: AI responses filtered before display
3. **Moderation API**: Optional OpenAI moderation for additional safety
4. **Rate Limiting**: Prevents spam and abuse

</details>

---

## Troubleshooting

<details>
<summary><strong>HTTP Request Errors</strong></summary>

**Problem**: `HttpService is not enabled` or `403 Forbidden`

**Solution**:
1. Open **Game Settings** in Roblox Studio
2. Navigate to **Security** tab
3. Enable **"Allow HTTP Requests"**
4. Verify the server can reach `api.openai.com`

</details>

<details>
<summary><strong>Blank/Empty Responses</strong></summary>

**Problem**: NPC doesn't respond or shows blank messages

**Solution**:
1. Check **Output** window in Studio for errors
2. Verify API key is correct in `Config.lua`
3. Check OpenAI API status page
4. Review HTTP response status codes in logs
5. Ensure sufficient API credits in OpenAI account

</details>

<details>
<summary><strong>Rojo Connection Issues</strong></summary>

**Problem**: Can't connect to Rojo server

**Solution**:
1. Ensure `rojo serve` is running in terminal
2. Check firewall settings (port 34872)
3. Verify Rojo plugin is up to date
4. Try restarting both Rojo and Roblox Studio

</details>

<details>
<summary><strong>Rate Limit Warnings</strong></summary>

**Problem**: "Too many requests" error

**Solution**:
- Adjust `RATE_LIMIT` settings in `Config.lua`
- Implement cooldown messages for players
- Consider upgrading OpenAI API tier
- Review per-player request patterns

</details>

---

## Future Development

<details>
<summary><strong>Planned Features</strong></summary>

### Phase 1: Core Gameplay
- [ ] **Item Exchange System**: Equivalent exchange mechanic for item trading
- [ ] **Combat System**: Enemy encounters and boss battles
- [ ] **Quest System**: Dynamic quest generation using AI
- [ ] **Character Stats**: RPG-style progression system

### Phase 2: AI Integration
- [ ] **Context-Aware NPCs**: NPCs with persistent memory and personality
- [ ] **Dynamic Quest Generation**: AI-generated quests based on player behavior
- [ ] **Procedural Dialogue**: Unique conversations per interaction
- [ ] **Multi-NPC Interactions**: Group conversations and NPC-to-NPC dialogue

### Phase 3: Advanced Features
- [ ] **Voice Integration**: Text-to-speech for NPC responses
- [ ] **Sentiment Analysis**: NPCs react to player tone and emotion
- [ ] **World State Awareness**: AI responds to in-game events
- [ ] **Player Behavior Analytics**: Adaptive difficulty and content

</details>

<details>
<summary><strong>Research Goals</strong></summary>

This project serves as an **experimental platform** to explore:
- AI limitations and capabilities within Roblox's Luau environment
- Real-time natural language processing in game engines
- Scalable conversation systems for multiplayer environments
- Player engagement metrics with AI-driven content
- Cost optimization strategies for AI-powered games

</details>

---

## Technologies Used

<div align="center">

| Technology | Purpose |
|------------|---------|
| **Roblox Studio** | Game development environment |
| **Luau** | Server & client scripting language |
| **Rojo** | Version control & project management |
| **OpenAI API** | Natural language AI processing |
| **HttpService** | External API communication |
| **TextService** | Content filtering & moderation |
| **RemoteEvents** | Client-server communication |

</div>

---

## License

This project is available for educational and portfolio purposes.

---

## Contributing

This is a personal portfolio project, but feedback and suggestions are welcome! Feel free to:
- Open an issue for bug reports
- Suggest features or improvements
- Share your own AI-game experiments

---

## Contact

**Developer**: [Roblox Profile](https://www.roblox.com/users/35190321/profile)

---

<div align="center">

**If you found this project interesting, please star this repository!**

*Built with passion for AI and game development*

</div> 