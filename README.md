# Upload-Post for Claude, Cursor, Gemini CLI, Grok Bot and Grok Build

Schedule, repurpose, and grow on social media — directly from Claude (Claude.ai, Cowork and Claude Code).

The Upload-Post plugin connects Claude to the hosted [Upload-Post MCP server](https://docs.upload-post.com/guides/mcp-server-integration) (50 tools) and ships opinionated skills and agents on top. Schedule cross-platform campaigns, turn long videos into viral shorts, work the comment section, build Instagram comment-to-DM funnels, and analyse account performance — without leaving the chat.

**No API key to copy.** The server speaks OAuth 2.1, so installing and authenticating takes two commands and a browser click.

**Free plan, no credit card required.** Try it before you decide.

## Try it

After installing, ask Claude things like:

- "Connect my Instagram and TikTok to Upload-Post."
- "Post this video to TikTok, Instagram Reels and YouTube Shorts tomorrow at 6 pm."
- "Schedule this announcement on LinkedIn and X for Monday at 9:00."
- "Cut this podcast episode into five shorts and schedule one a day."
- "Reply to the new comments on my last Instagram post."
- "When someone comments GUIDE on this reel, DM them the download link."
- "Which of my posts did best this month, and what should I post next?"

More in [EXAMPLES.md](./EXAMPLES.md).

## What's inside

### Skills (slash commands)

| Skill | What it does |
| :---- | :----------- |
| `/upload-post:setup` | One-time onboarding. Walks the OAuth connection, verifies the MCP link, and checks you have at least one social account connected. |
| `/upload-post:whitelabel-connect` | Generate a JWT connection link so a client or end-user can OAuth their socials into a profile inside your workspace — for white-label embeds and agency onboarding. (Connecting your own accounts? Use [app.upload-post.com/manage-users](https://app.upload-post.com/manage-users) — a couple of clicks per network.) |
| `/upload-post:schedule-campaign` | Schedule a post across multiple platforms at once. Handles per-platform validation (aspect ratio, length, Facebook pages, Pinterest boards). |
| `/upload-post:repurpose-video` | Take a long video, transcribe it, pick viral moments, cut clips with FFmpeg, optionally add hook overlays, then schedule to TikTok / Reels / Shorts. |
| `/upload-post:posting-queue` | Set up a recurring weekly posting rhythm (slots, days, timezone) and see what lands in the next slot. |
| `/upload-post:manage-comments` | Read, triage, reply to and moderate comments on Instagram / Facebook / YouTube / LinkedIn / TikTok / X / Threads / Bluesky, plus Google Business reviews. |
| `/upload-post:autodm-setup` | Build an Instagram comment-to-DM funnel: keyword trigger → private DM with up to 3 link buttons. |
| `/upload-post:analyze-performance` | Pull analytics across accounts, identify what is working, and propose concrete next moves. |

### Agents

- **`content-strategist`** — reads your analytics and proposes 3–5 specific next posts.
- **`autodm-architect`** — designs full comment-to-DM funnels (trigger + DM body + link buttons + CTA).
- **`post-debugger`** — diagnoses failed uploads, expired tokens, and quota errors.

### MCP server

The plugin wires the hosted Upload-Post MCP server (`https://mcp.upload-post.com/mcp`) into Claude. 50 tools cover uploads (video / photo / text / documents), scheduling and the posting queue, analytics, comments and Google Business reviews, DMs and AutoDMs, FFmpeg encoding jobs, media staging, and account management. See the [MCP integration guide](https://docs.upload-post.com/guides/mcp-server-integration) for the full tool list.

Authentication is OAuth 2.1 with dynamic client registration (RFC 7591) and PKCE — Claude registers itself, opens the approval page, and stores the token. Nothing to paste. Revoke any time from **Connected Apps** in the dashboard.

## Why this plugin (vs. alternatives)

- **Free plan, no credit card.** Get an API key and try the whole thing before paying. Most social-automation tools gate everything behind a card.
- **AutoShorts pipeline.** Long-form → viral clips → scheduled across short-form platforms, in one skill. Not a feature most schedulers ship.
- **Instagram comment-to-DM funnels.** First-class support for AutoDMs and lead capture from comments.
- **50 MCP tools, not a CLI wrapper.** Claude calls real tools with structured inputs; no copy-pasting curl commands.

## Install

### From this repo's marketplace (Claude Code)

```text
/plugin marketplace add Upload-Post/upload-post-plugin
/plugin install upload-post@upload-post
```

### From the community marketplace

```text
/plugin marketplace add anthropics/claude-plugins-community
/plugin install upload-post@claude-community
```

### Gemini CLI

```bash
gemini extensions install https://github.com/Upload-Post/upload-post-plugin
```

The extension (`gemini-extension.json`) registers the hosted MCP server and loads `GEMINI.md` as context. On first use Gemini CLI opens the OAuth sign-in; run `/mcp auth upload-post` to re-authenticate.

### Grok Bot, Cursor and Grok Build

The same repo ships `.cursor-plugin/plugin.json` + `mcp.json` (Cursor Marketplace, which also feeds Grok Bot's plugin catalog) and `.grok-plugin/plugin.json` + `.mcp.json` (Grok Build plugin marketplace).

- **Grok Bot:** Plugins in the sidebar → search **Upload-Post** → Add, then approve the Upload-Post sign-in.
- **Cursor:** Marketplace → search **Upload-Post** → Add.
- **Grok Build:** install `upload-post` from the xAI plugin marketplace.

Until a listing is live, add the MCP server manually with the URL `https://mcp.upload-post.com/mcp`.

**Network and credentials:** the only endpoint is `https://mcp.upload-post.com` (OAuth 2.1 + PKCE; API keys via `Authorization: ApiKey <key>` are also accepted). The plugin contains no scripts, hooks or binaries.

### Locally (development)

```bash
git clone https://github.com/Upload-Post/upload-post-plugin
claude --plugin-dir ./upload-post-plugin
```

## Configure

1. Connect Upload-Post. A browser tab opens; log in or create a free account (no card) and approve.
   - **Claude.ai, desktop app or Cowork:** Customize → Connectors → Upload-Post → **Connect**.
   - **Claude Code:** run `/mcp`, pick `upload-post`, choose **Authenticate**.

2. Ask Claude to set up Upload-Post (or run `/upload-post:setup` in Claude Code). It verifies the connection, gives you a one-click link to connect your social accounts and helps you publish your first post.

That's it — there is no API key to copy and no environment variable to export.

<details>
<summary>Prefer a long-lived API key (CI, headless, shared machines)?</summary>

Grab a key at [app.upload-post.com/settings/api](https://app.upload-post.com/settings/api) and either send it as a header against the same hosted endpoint:

```json
{
  "mcpServers": {
    "upload-post": {
      "type": "http",
      "url": "https://mcp.upload-post.com/mcp",
      "headers": { "Authorization": "ApiKey upk_live_..." }
    }
  }
}
```

…or run the server locally over stdio:

```json
{
  "mcpServers": {
    "upload-post": {
      "command": "npx",
      "args": ["-y", "@upload-post/mcp"],
      "env": { "UPLOAD_POST_API_KEY": "upk_live_..." }
    }
  }
}
```

</details>

## First-run flow

```text
/upload-post:setup
# Connect your own accounts at app.upload-post.com/manage-users (web, no JWT needed)
/upload-post:schedule-campaign         # post something
/upload-post:posting-queue             # set a weekly rhythm so you stop picking dates
/upload-post:analyze-performance       # see what worked after a few days
/upload-post:repurpose-video           # turn a long video into shorts
/upload-post:manage-comments           # reply to what came back
/upload-post:autodm-setup              # capture leads from a hot post
```

## Troubleshooting

| Symptom | Likely cause | Fix |
| :------ | :----------- | :-- |
| No `upload-post` tools available | Not authenticated yet | Claude.ai / Cowork: Customize → Connectors → Upload-Post → **Connect**. Claude Code: `/mcp` → `upload-post` → **Authenticate** |
| Every tool returns 401 | OAuth token revoked or expired | Reconnect as above. Check **Connected Apps** in the dashboard |
| OAuth browser tab never opens | Proxy or VPN blocking the host | `curl -sI https://mcp.upload-post.com/.well-known/oauth-protected-resource` should return 200 |
| `list_users` returns empty | No social accounts linked yet | Ask Claude for a connection link, or connect them at [app.upload-post.com/manage-users](https://app.upload-post.com/manage-users) |
| Upload fails with `quota_exceeded` | Free-plan daily limit hit | Wait until quota resets or upgrade |
| Scheduled post never went out | Token for that account expired | The `post-debugger` agent will diagnose; usually reconnect from [manage-users](https://app.upload-post.com/manage-users) |

## Documentation

- [Quick start](./QUICK_START.md) — install, authenticate, publish, in about two minutes.
- [Features](./FEATURES.md) — platform support matrix by content type, all 50 tools by family, and the known limitations.
- [Examples](./EXAMPLES.md) — real prompts and what the plugin does with them.
- [Changelog](./CHANGELOG.md) — what changed between versions.

## Links

- Upload-Post: [upload-post.com](https://upload-post.com)
- API & MCP docs: [docs.upload-post.com/guides/mcp-server-integration](https://docs.upload-post.com/guides/mcp-server-integration)
- MCP server source: [github.com/Upload-Post/upload-post-mcp](https://github.com/Upload-Post/upload-post-mcp) (MIT)
- Support: info@upload-post.com

## License

MIT. See [LICENSE](./LICENSE).
