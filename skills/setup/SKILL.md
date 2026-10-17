---
name: setup
description: Get a new Upload-Post user from install to their first published or scheduled post. Check the connection, list profiles and connected social accounts, hand over a one-click link to connect TikTok, Instagram, YouTube, LinkedIn, X and the rest, then offer a first post. Use when the user first installs the plugin, asks how to get started or how to connect a social network, says the plugin is not working, when no account is connected, or runs /upload-post:setup.
---

# Upload-Post setup

The goal is the user's first post, not a checklist. Run the checks quietly, stop only where something is missing, and fix it with them before moving on.

## 1. Connection

Call `get_account_info`. It is the cheapest call: it validates the session and returns the account and plan state.

- **It works**: move to step 2 without comment.
- **The tools are missing or it returns an auth error**: Upload-Post is not connected yet. Tell the user how to connect it where they are:
  - **Claude.ai or the desktop app (including Cowork)**: Customize → Connectors → Upload-Post → *Connect*.
  - **Claude Code**: run `/mcp`, select `upload-post` and choose *Authenticate*.

  A browser tab opens on `app.upload-post.com`; they log in or sign up (free plan, no card) and approve. Then call `get_account_info` again.
- **Network error**: a proxy or VPN may block `mcp.upload-post.com`.

The user can revoke access at any time from **Connected Apps** in the Upload-Post dashboard.

## 2. Profiles and social accounts

Call `list_users`. Upload-Post groups social accounts under **profiles** (one per brand or client). Each profile has a `username` and the networks connected to it. Almost every upload, analytics, comment and DM tool takes that `username` as `user`. Never invent a profile name.

- One profile: use it without asking.
- Several: ask which one before anything that writes.

Summarise it in one line: profile → connected networks.

## 3. Connect a social account

If there is no profile, nothing is connected, or the network the user wants is missing or needs reconnecting, call `get_connect_link` and give the user its `connect_url`. With no profile it creates one and returns a one-click link; otherwise it opens the page where they click each network and approve.

Ask them to tell you when they are done, then call `list_users` again to confirm. A response with `next_step` or `connect_url` (for example `reauth_required`) means the same thing: pass the link on instead of retrying.

Do not use the `whitelabel-connect` skill here. It is for generating links for clients in a white-label or agency setup, not for the user's own accounts.

## 4. First post

Once at least one network is connected, offer a first post straight away instead of a menu. Ask what they want to share, or suggest a short text post to a connected network, and run it with the `schedule-campaign` skill. A scheduled post counts too.

If they would rather do something else, suggest the skill that fits what they mentioned:

- A repeating posting rhythm → `posting-queue`
- A long video → `repurpose-video`
- Leads from Instagram comments → `autodm-setup`
- Comments or reviews piling up → `manage-comments`
- Understanding their numbers → `analyze-performance`

If a tool reports that the plan limit was reached, say so plainly and point to https://app.upload-post.com to manage the plan; do not retry.
