---
description: Onboard a new Upload-Post user. Configure UPLOAD_POST_API_KEY, verify the MCP connection, and confirm that at least one social account is connected. Use when the user first installs the plugin, asks how to get started, says the plugin is not working, or runs /upload-post:setup.
---

# Upload-Post setup

Walk the user through three checks. Stop as soon as one fails and help them fix it before moving on.

## 1. API key

The Upload-Post MCP server reads `UPLOAD_POST_API_KEY` from the environment. Check whether it is set:

```bash
echo "${UPLOAD_POST_API_KEY:-MISSING}"
```

If missing:

- Tell the user to grab their API key at https://app.upload-post.com/settings/api
- Show them how to export it for the current shell and how to persist it in `~/.zshrc` or `~/.bashrc`:

  ```bash
  export UPLOAD_POST_API_KEY="upk_live_..."
  ```

- Remind them to restart Claude Code so the MCP server picks up the new env.

## 2. MCP connection

Call `get_account_info`. It is the cheapest call — it validates the API key and returns nothing else. If it succeeds, the connection is live.

If it errors with auth: the key is wrong or expired — send the user back to step 1.
If it errors with network: the user may be on a VPN that blocks `mcp.upload-post.com` or the npx install is failing — suggest `npx -y @upload-post/mcp --version` to verify the package downloads.

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
- Has a long video → `/upload-post:repurpose-video`
- Wants leads from Instagram → `/upload-post:autodm-setup`
- Wants to understand their numbers → `/upload-post:analyze-performance`
