---
name: connect-accounts
description: Get started with Upload-Post - check the connection, list profiles and connected social accounts (Instagram, TikTok, YouTube, Facebook, X, LinkedIn, Threads, Pinterest, Bluesky, Google Business and more), and guide the user to connect a new social account or fix one that needs reconnecting. Use on first use, when no accounts are connected, when the user asks how to connect a social network, which accounts are connected, about plans or limits, or when a tool returns reauth_required or tiktok_reconnect_required.
---

# Connect accounts

## 1. Check the session

Call `get_account_info`. It confirms the Upload-Post session and returns the account and plan state. If it fails with an auth error, ask the user to reconnect Upload-Post in ChatGPT's app settings.

## 2. Profiles and accounts

Call `list_users`. Upload-Post groups social accounts under profiles (one per brand or client). Each profile has a `username` and its connected networks. Most tools take that `username` as `user` or `profileUsername`.

Summarise it plainly: profile → connected networks.

## 3. Connect or reconnect

Social accounts are connected on the web, not in the chat. Send the user to https://app.upload-post.com/manage-users: pick or create a profile, click the network, accept the platform's permission screen. It takes a couple of clicks per network, then come back and call `list_users` again.

- `reauth_required` or `tiktok_reconnect_required`: the account must be reconnected from that same page. A TikTok account connected before a feature existed (music, location, analytics) needs a reconnect to get that capability.
- Facebook and LinkedIn company Pages: connect the account, then pick the Page when posting (`get_facebook_pages`, `get_linkedin_pages`).

## 4. Plans

If a tool reports that the plan limit was reached, say so plainly and point to https://app.upload-post.com to manage the plan; do not retry.

## 5. Next step

Suggest what fits what the user said: `publish-video`, `schedule-social-posts`, `content-calendar`, `social-media-analytics`, `reply-to-comments`, `instagram-auto-dm`, or `video-to-shorts`.
