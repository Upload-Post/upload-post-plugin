---
description: Onboard a new Upload-Post user. Authenticate the hosted MCP server over OAuth, verify the connection, and confirm that at least one social account is connected. Use when the user first installs the plugin, asks how to get started, says the plugin is not working, or runs /upload-post:setup.
---

# Upload-Post setup

Walk the user through three checks. Stop as soon as one fails and help them fix it before moving on.

## 1. Authentication

The plugin points at the hosted MCP server (`https://mcp.upload-post.com/mcp`). There is **no API key to copy and no env var to export** — the server speaks OAuth 2.1 with dynamic client registration, so Claude Code handles it.

Check the connection state with `/mcp`. Expected states:

- **connected** — nothing to do, move to step 2.
- **needs authentication** — tell the user to run `/mcp`, select `upload-post`, and choose *Authenticate*. A browser tab opens on `app.upload-post.com/oauth/authorize`; they log in (or sign up — the free plan needs no card) and approve. The tab closes itself and the tools become available.
- **failed / not listed** — the plugin may not be enabled. Have them check `/plugin` and restart Claude Code.

The user can revoke access at any time from **Connected Apps** in the Upload-Post dashboard.

> **API-key alternative.** Users who prefer a long-lived key (CI, headless, shared machines) can skip OAuth by adding their own MCP entry with an `Authorization: ApiKey <key>` header, or by running the stdio server `npx -y @upload-post/mcp` with `UPLOAD_POST_API_KEY`. Only bring this up if the user asks for it or OAuth is blocked in their environment.

## 2. MCP connection

Call `get_account_info`. It is the cheapest call — it validates the session and returns the account state. If it succeeds, the connection is live.

- **401 / auth error** — the OAuth token was revoked or expired. Re-run `/mcp` → *Authenticate*.
- **Network error** — the user may be behind a proxy or VPN that blocks `mcp.upload-post.com`. Verify with `curl -sI https://mcp.upload-post.com/.well-known/oauth-protected-resource`.

## 3. Profiles and connected accounts

Upload-Post groups social accounts under **profiles** (one workspace can have many). Call `list_users` to enumerate them. Each entry has a `username` (the profile name) and a `social_accounts` map showing what is connected per platform.

Almost every upload, analytics, comment, and DM tool takes a `user` parameter set to one of these profile usernames. If the user has only one profile, default to it silently. If they have several, ask which one to use before running anything that writes.

If `list_users` returns an empty list, or no profile has any connected platform, tell the user to do it from the web in 30 seconds:

```
https://app.upload-post.com/manage-users
```

There they create a profile, click each platform they want to post to, and accept the OAuth prompt. A couple of clicks per network. Do not run the `whitelabel-connect` skill in this case — that is for generating connection URLs for clients in a white-label / agency setup, not for connecting the user's own accounts.

## Wrap-up

When all three checks pass, give a one-line summary and suggest the next move based on what the user mentioned:

- Has content to post → `/upload-post:schedule-campaign`
- Wants a repeating posting rhythm → `/upload-post:posting-queue`
- Has a long video → `/upload-post:repurpose-video`
- Wants leads from Instagram → `/upload-post:autodm-setup`
- Has comments or reviews piling up → `/upload-post:manage-comments`
- Wants to understand their numbers → `/upload-post:analyze-performance`
