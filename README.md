# Upload-Post for Claude Code

Schedule, repurpose, and grow on social media — directly from Claude Code.

The Upload-Post plugin connects Claude Code to the [Upload-Post MCP server](https://www.upload-post.com/mcp-integration-guide) (40+ tools) and ships opinionated skills and agents on top. Schedule cross-platform campaigns, turn long videos into viral shorts, build Instagram comment-to-DM funnels, and analyse account performance — without leaving your terminal.

**Free plan, no credit card required.** Try it before you decide.

## What's inside

### Skills (slash commands)

| Skill | What it does |
| :---- | :----------- |
| `/upload-post:setup` | One-time onboarding. Verifies the API key, the MCP connection, and that you have at least one social account linked. |
| `/upload-post:connect-accounts` | Walks you through connecting Instagram, TikTok, YouTube, X, LinkedIn, Facebook, Threads, Pinterest, Reddit, Bluesky, or Snapchat via OAuth. |
| `/upload-post:schedule-campaign` | Schedule a post across multiple platforms at once. Handles per-platform validation (aspect ratio, length, Reddit flairs, Facebook pages). |
| `/upload-post:repurpose-video` | Take a long video, transcribe it, pick viral moments, cut clips with FFmpeg, optionally add hook overlays, then schedule to TikTok / Reels / Shorts. |
| `/upload-post:autodm-setup` | Build an Instagram comment-to-DM funnel: keyword trigger → public reply → private DM. |
| `/upload-post:analyze-performance` | Pull analytics across accounts, identify what is working, and propose concrete next moves. |

### Agents

- **`content-strategist`** — reads your analytics and proposes 3–5 specific next posts.
- **`autodm-architect`** — designs full comment-to-DM funnels (trigger + public reply + DM body + CTA).
- **`post-debugger`** — diagnoses failed uploads, expired tokens, and quota errors.

### MCP server

The plugin wires the hosted Upload-Post MCP server into Claude Code. Tools cover uploads (video / photo / text / documents), scheduling, analytics, comments, DMs and AutoDMs, FFmpeg jobs, and account management. See the [MCP integration guide](https://www.upload-post.com/mcp-integration-guide) for the full tool list.

## Why this plugin (vs. alternatives)

- **Free plan, no credit card.** Get an API key and try the whole thing before paying. Most social-automation tools gate everything behind a card.
- **AutoShorts pipeline.** Long-form → viral clips → scheduled across short-form platforms, in one skill. Not a feature most schedulers ship.
- **Instagram comment-to-DM funnels.** First-class support for AutoDMs and lead capture from comments.
- **40+ MCP tools, not a CLI wrapper.** Claude calls real tools with structured inputs; no copy-pasting curl commands.

## Install

### From the community marketplace

```text
/plugin marketplace add anthropics/claude-plugins-community
/plugin install upload-post
```

### Locally (development)

```bash
git clone https://github.com/mutonby/upload-post-plugin
claude --plugin-dir ./upload-post-plugin
```

## Configure

1. Grab an API key at [app.upload-post.com/settings/api](https://app.upload-post.com/settings/api). The free plan is enough to test every skill in this plugin.

2. Export it in your shell:

   ```bash
   export UPLOAD_POST_API_KEY="upk_live_..."
   ```

   Persist it in `~/.zshrc` or `~/.bashrc` so the MCP server picks it up on every session.

3. Start Claude Code and run `/upload-post:setup`. It will verify the connection and list any accounts you have already linked.

## First-run flow

```text
/upload-post:setup
/upload-post:connect-accounts          # link your first account
/upload-post:schedule-campaign         # post something
/upload-post:analyze-performance       # see what worked after a few days
/upload-post:repurpose-video           # turn a long video into shorts
/upload-post:autodm-setup              # capture leads from a hot post
```

## Troubleshooting

| Symptom | Likely cause | Fix |
| :------ | :----------- | :-- |
| `UPLOAD_POST_API_KEY missing` on setup | Env var not exported or shell not restarted | `export UPLOAD_POST_API_KEY=...` and restart Claude Code |
| `list_accounts` returns 401 | API key wrong or rotated | Regenerate at app.upload-post.com/settings/api |
| `list_accounts` returns empty | No social accounts linked yet | Run `/upload-post:connect-accounts` |
| Upload fails with `quota_exceeded` | Free-plan daily limit hit | Wait until quota resets or upgrade |
| Scheduled post never went out | Token for that account expired | The `post-debugger` agent will diagnose; usually reconnect via `connect-accounts` |

## Links

- Upload-Post: [upload-post.com](https://upload-post.com)
- API & MCP docs: [upload-post.com/mcp-integration-guide](https://www.upload-post.com/mcp-integration-guide)
- Support: info@upload-post.com

## License

MIT. See [LICENSE](./LICENSE).
