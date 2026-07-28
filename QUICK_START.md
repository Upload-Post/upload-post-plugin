# Quick start

From zero to a published post in about two minutes.

## 1. Install

```text
/plugin marketplace add anthropics/claude-plugins-community
/plugin install upload-post@claude-community
```

## 2. Authenticate

```text
/mcp
```

Pick `upload-post`, choose **Authenticate**. A browser tab opens on `app.upload-post.com`; log in or create a free account (no card), approve, and the tab closes itself.

There is no API key to copy and no environment variable to set. The server implements OAuth 2.1 with dynamic client registration, so Claude Code registers itself.

## 3. Connect a social account

Upload-Post groups your social accounts under a **profile**. Create one and link networks at:

```text
https://app.upload-post.com/manage-users
```

A couple of clicks per network. Then, back in Claude Code:

```text
/upload-post:setup
```

This verifies the OAuth session, lists your profiles, and shows what is connected where.

## 4. Post something

Just ask in plain language:

```text
Post this to TikTok and Instagram Reels: ~/Videos/demo.mp4
Caption: "Three things I wish I knew before shipping."
```

Or drive it with the skill:

```text
/upload-post:schedule-campaign
```

## 5. Where to go next

| You have… | Run |
| :-- | :-- |
| A long video to cut into shorts | `/upload-post:repurpose-video` |
| No posting rhythm, tired of picking dates | `/upload-post:posting-queue` |
| Comments or reviews piling up | `/upload-post:manage-comments` |
| A post pulling engagement you want to convert | `/upload-post:autodm-setup` |
| A week of data and a question | `/upload-post:analyze-performance` |
| Clients whose accounts you manage | `/upload-post:whitelabel-connect` |

## Troubleshooting

| Symptom | Fix |
| :-- | :-- |
| No `upload-post` tools available | Not authenticated — `/mcp` → `upload-post` → **Authenticate** |
| Every tool returns 401 | Token revoked or expired — re-authenticate. Check **Connected Apps** in the dashboard |
| OAuth tab never opens | Proxy or VPN. `curl -sI https://mcp.upload-post.com/.well-known/oauth-protected-resource` should return 200 |
| `list_users` returns nothing | No profile yet — create one at [manage-users](https://app.upload-post.com/manage-users) |
| A scheduled post never went out | That platform's token expired. Ask the `post-debugger` agent |

Still stuck: info@upload-post.com.
