---
description: Connect a social account (Instagram, TikTok, YouTube, X, LinkedIn, Facebook, Threads, Pinterest, Reddit, Bluesky, Snapchat) to Upload-Post via OAuth. Use when the user asks to connect, link, add, authorize, or hook up a social account, or when /upload-post:setup detects no connected profiles.
---

# Connect a social account

Upload-Post handles OAuth via short-lived JWT links. The flow is: generate a JWT-signed connect URL → user opens it → completes OAuth → returns to Upload-Post → the account is now linked.

## Step 1 — ask which platform

If the user has not said which platform, ask. Supported: `tiktok`, `instagram`, `youtube`, `x`, `linkedin`, `facebook`, `threads`, `pinterest`, `reddit`, `bluesky`, `snapchat`.

## Step 2 — generate the connect URL

Call `generate_jwt` with the profile `username` and the `platforms` array containing the chosen platform. Optional fields worth setting:

- `redirectUrl` — where to send the user after OAuth completes.
- `logoImage`, `connectTitle`, `connectDescription` — only if branding the flow.

The tool returns a one-time URL.

## Step 3 — hand the link to the user

Print the URL and tell the user:

- Open it in their browser while logged into the social platform they are connecting.
- Approve the OAuth scopes when prompted.
- They will be redirected back to Upload-Post on success.

## Step 4 — verify

After the user confirms they finished the flow, call `list_users` and look at the profile's `social_accounts` map. The platform should now have a non-empty entry with a `handle` and `display_name`. If not, the OAuth probably failed — common causes: cancelled mid-flow, business account required (Instagram), or scopes denied. Check `reauth_required: true` on existing platforms too — that means the token expired and the user needs to redo the flow.

## Multiple accounts

Per-platform limits and per-plan quotas live in the user's Upload-Post plan. If `list_accounts` returns a quota error, surface the upgrade link rather than retrying.
