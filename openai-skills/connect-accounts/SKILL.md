---
name: connect-accounts
description: Get started with Upload-Post - check the connection, list profiles and connected social accounts (Instagram, TikTok, YouTube, Facebook, X, LinkedIn, Threads, Pinterest, Bluesky, Google Business and more), and guide the user to connect a new social account or fix one that needs reconnecting. Use on first use, when no accounts are connected, when the user asks how to connect a social network, which accounts are connected, about plans or limits, or when a tool returns reauth_required or tiktok_reconnect_required.
---

# Connect accounts

## 1. Check the session

Call `get_account_info`. It confirms the Upload-Post session and returns the account and plan state. If it fails with an auth error, ask the user to reconnect Upload-Post in ChatGPT's app settings.

## 2. Profiles and accounts

Call `list_users`. Upload-Post groups social accounts under profiles (one per brand or client). Each profile has a `username` and its connected networks. Most tools take that `username` as `user` or `profileUsername`. Never invent a profile name.

To check specific networks before publishing, pass them in `platforms`. When the account has no profile, nothing connected, or a requested network is missing or expired, the response includes `next_step` and `connect_url`: follow `next_step`.

Summarise it plainly: profile → connected networks.

## 3. Connect or reconnect

Social accounts are connected on the web, not in the chat. Call `get_connect_link` and give the user its `connect_url`:

- New account with no profile: it creates a profile named `default` and returns a one-click link to connect accounts to it (valid 48 hours).
- Existing profiles: it returns the dashboard page where they pick the profile and click the network.

Ask the user to tell you when they are done, then call `list_users` again to confirm before publishing.

- `reauth_required` or `tiktok_reconnect_required`: the account must be reconnected through the same link. A TikTok account connected before a feature existed (music, location, analytics) needs a reconnect to get that capability.
- Upload errors such as "profile not found" or "platform not connected" already include the link and what to tell the user; pass it on instead of retrying.
- Facebook and LinkedIn company Pages: connect the account, then pick the Page when posting (`get_facebook_pages`, `get_linkedin_pages`).

## 4. Plans

If a tool reports that the plan limit was reached, say so plainly and point to https://app.upload-post.com to manage the plan; do not retry.

## 5. Next step

Suggest what fits what the user said: `publish-video`, `schedule-social-posts`, `content-calendar`, `social-media-analytics`, `reply-to-comments`, `instagram-auto-dm`, or `video-to-shorts`.
