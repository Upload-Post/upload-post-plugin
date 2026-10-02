---
name: schedule-social-posts
description: Publish or schedule photos, carousels, text posts, link posts, and LinkedIn documents across Instagram, Facebook, X (Twitter), LinkedIn, Threads, Pinterest, Bluesky, TikTok, Google Business Profile, Telegram, Discord, Mastodon and WordPress through Upload-Post, with a different caption per network if wanted. Also list, edit, or cancel scheduled posts. Use when the user wants to post, cross-post, share, or schedule social media content, or asks what is scheduled. For videos use publish-video; for planning many posts over weeks use content-calendar.
---

# Schedule social posts

## 1. Pick the profile and networks

Call `list_users` for the profile `username` and its connected accounts. One profile: use it. Several: ask. None: follow `connect-accounts`.

Some networks need a target first:

- Facebook Page: `get_facebook_pages`, then `facebookPageId` in `platformOptions`.
- LinkedIn company Page: `get_linkedin_pages`, then `linkedinPageId`.
- Pinterest board: `get_pinterest_boards`.
- Google Business location: `get_google_business_locations`, then `googleBusinessLocationId` in `platformOptions`.

## 2. Pick the tool

- Photo or carousel: `upload_photos` with `photosPathsOrUrls` (one URL for a single image, several for a carousel), plus `altText` if the user gives it.
- Text or link post: `upload_text`; the text goes in `title`, a link preview in `linkUrl` (LinkedIn, Bluesky, Facebook).
- PDF or slide deck: `upload_document` (LinkedIn only) with `documentPathOrUrl` and `title`.

Images must be public HTTPS URLs. If the user only has the image in this chat or on their computer, explain that, and ask for a link or suggest uploading it at https://app.upload-post.com.

## 3. Captions

Write one caption, then offer native variants: short on X, professional on LinkedIn, hashtags on Instagram. Per-network text goes in `platformOptions` (`instagramTitle`, `linkedinTitle`, `xTitle`, …). `firstComment` posts a comment right after publishing.

## 4. Timing

- Now: no `scheduledDate`.
- Exact time: `scheduledDate` (ISO 8601) plus `timezone` (IANA). Read the local time back.
- Next queue slot: `addToQueue: true`.

## 5. Confirm and manage

Report each network with its scheduled time or status (`get_status` on the `request_id`).

- "What's scheduled?" → `list_scheduled`.
- Change the time or text → `edit_scheduled` with `jobId` (`scheduledDate`, `timezone`, `title`, `caption`, or `platformContent` for one network). Do not create a duplicate.
- Cancel → `cancel_scheduled` with `jobId`. Confirm first; it cannot be undone.
- Published already → `get_history`. A failed network → `retry_post`. Take a post down → `unpublish_post` (Facebook, YouTube, X, LinkedIn, Threads only; confirm first).

Reddit publishing is currently unavailable.
