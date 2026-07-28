# Upload-Post for Claude Code

Schedule, repurpose, and grow on social media — directly from Claude Code.

The Upload-Post plugin connects Claude Code to the hosted [Upload-Post MCP server](https://docs.upload-post.com/guides/mcp-server-integration) (50 tools) and ships opinionated skills and agents on top. Schedule cross-platform campaigns, turn long videos into viral shorts, work the comment section, build Instagram comment-to-DM funnels, and analyse account performance — without leaving your terminal.

**No API key to copy.** The server speaks OAuth 2.1, so installing and authenticating takes two commands and a browser click.

**Free plan, no credit card required.** Try it before you decide.

## What's inside

### Skills (slash commands)

| Skill | What it does |
| :---- | :----------- |
| `/upload-post:setup` | One-time onboarding. Walks the OAuth connection, verifies the MCP link, and checks you have at least one social account connected. |
| `/upload-post:whitelabel-connect` | Generate a JWT connection link so a client or end-user can OAuth their socials into a profile inside your workspace — for white-label embeds and agency onboarding. (Connecting your own accounts? Use [app.upload-post.com/manage-users](https://app.upload-post.com/manage-users) — a couple of clicks per network.) |
| `/upload-post:schedule-campaign` | Schedule a post across multiple platforms at once. Handles per-platform validation (aspect ratio, length, Reddit flairs, Facebook pages). |
| `/upload-post:repurpose-video` | Take a long video, transcribe it, pick viral moments, cut clips with FFmpeg, optionally add hook overlays, then schedule to TikTok / Reels / Shorts. |
| `/upload-post:posting-queue` | Set up a recurring weekly posting rhythm (slots, days, timezone) and see what lands in the next slot. |
| `/upload-post:manage-comments` | Read, triage and reply to comments on Instagram / Facebook / YouTube / LinkedIn, plus Google Business reviews. |
| `/upload-post:autodm-setup` | Build an Instagram comment-to-DM funnel: keyword trigger → public reply → private DM. |
| `/upload-post:analyze-performance` | Pull analytics across accounts, identify what is working, and propose concrete next moves. |

### Agents

- **`content-strategist`** — reads your analytics and proposes 3–5 specific next posts.
- **`autodm-architect`** — designs full comment-to-DM funnels (trigger + public reply + DM body + CTA).
- **`post-debugger`** — diagnoses failed uploads, expired tokens, and quota errors.

### MCP server

The plugin wires the hosted Upload-Post MCP server (`https://mcp.upload-post.com/mcp`) into Claude Code. 50 tools cover uploads (video / photo / text / documents), scheduling and the posting queue, analytics, comments and Google Business reviews, DMs and AutoDMs, FFmpeg encoding jobs, media staging, and account management. See the [MCP integration guide](https://docs.upload-post.com/guides/mcp-server-integration) for the full tool list.

Authentication is OAuth 2.1 with dynamic client registration (RFC 7591) and PKCE — Claude Code registers itself, opens the approval page, and stores the token. Nothing to paste. Revoke any time from **Connected Apps** in the dashboard.

## Why this plugin (vs. alternatives)

- **Free plan, no credit card.** Get an API key and try the whole thing before paying. Most social-automation tools gate everything behind a card.
- **AutoShorts pipeline.** Long-form → viral clips → scheduled across short-form platforms, in one skill. Not a feature most schedulers ship.
- **Instagram comment-to-DM funnels.** First-class support for AutoDMs and lead capture from comments.
- **50 MCP tools, not a CLI wrapper.** Claude calls real tools with structured inputs; no copy-pasting curl commands.

## Install

### From the community marketplace

```text
/plugin marketplace add anthropics/claude-plugins-community
/plugin install upload-post@claude-community
```

### Locally (development)

```bash
git clone https://github.com/Upload-Post/upload-post-plugin
claude --plugin-dir ./upload-post-plugin
```

## Configure

1. Run `/mcp`, pick `upload-post`, choose **Authenticate**. A browser tab opens; log in or create a free account (no card) and approve.

2. Back in Claude Code, run `/upload-post:setup`. It verifies the connection and lists any accounts you have already linked.

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
| No `upload-post` tools available | Not authenticated yet | `/mcp` → `upload-post` → **Authenticate** |
| Every tool returns 401 | OAuth token revoked or expired | Re-authenticate with `/mcp`. Check **Connected Apps** in the dashboard |
| OAuth browser tab never opens | Proxy or VPN blocking the host | `curl -sI https://mcp.upload-post.com/.well-known/oauth-protected-resource` should return 200 |
| `list_users` returns empty | No social accounts linked yet | Connect them at [app.upload-post.com/manage-users](https://app.upload-post.com/manage-users) |
| Upload fails with `quota_exceeded` | Free-plan daily limit hit | Wait until quota resets or upgrade |
| Scheduled post never went out | Token for that account expired | The `post-debugger` agent will diagnose; usually reconnect from [manage-users](https://app.upload-post.com/manage-users) |

## Links

- Upload-Post: [upload-post.com](https://upload-post.com)
- API & MCP docs: [docs.upload-post.com/guides/mcp-server-integration](https://docs.upload-post.com/guides/mcp-server-integration)
- MCP server source: [github.com/Upload-Post/upload-post-mcp](https://github.com/Upload-Post/upload-post-mcp) (MIT)
- Support: info@upload-post.com

## License

MIT. See [LICENSE](./LICENSE).
