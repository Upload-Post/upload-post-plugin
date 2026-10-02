---
name: publish-video
description: Post or schedule a video to Instagram Reels, TikTok, YouTube Shorts, Facebook, X, LinkedIn, Threads, Pinterest, Bluesky and other networks through Upload-Post, including a video file the user has on their computer or attached in the chat. Use when the user wants to upload, post, publish, share, cross-post, or schedule a video, Reel, Short, or TikTok. Do not use for editing or generating the video itself, or for photo or text-only posts (use schedule-social-posts).
---

# Publish a video

Most Upload-Post posts are videos, and most of them go to Instagram, TikTok and YouTube. Get the video in, pick the accounts, write the captions, publish.

## 1. Pick the profile and accounts

Call `list_users`. Each profile has a `username` and the social accounts connected to it.

- One profile: use it without asking.
- Several profiles: ask which one before publishing.
- No profile or no connected accounts: follow `connect-accounts`, then come back.

Default to every connected video network unless the user names specific ones.

## 2. Get the video in

- **The user has the file** (on their computer, or attached in this chat): call `open_upload_studio` with `user`, `platforms`, `title`, and optionally `description`, `firstComment`, `instagramMediaType`. The user picks the file in the widget, it uploads directly, and the widget publishes it. Never pass a `/mnt/data` or sandbox path to `upload_video`; the server cannot read it.
- **`open_upload_studio` is not available** (clients other than ChatGPT): if the client can make HTTP requests, stage the file with `create_media_upload`, PUT the bytes to `upload_url`, call `complete_media_upload`, and use the returned `media_url`. Otherwise ask for a public HTTPS link.
- **The user gives a public link**: call `upload_video` with `videoPathOrUrl`.

## 3. Captions and options

- `title` is the main caption. Per-network overrides go in `platformOptions`: `instagramTitle`, `tiktokTitle`, `youtubeTitle`, `linkedinTitle`, `xTitle`. Offer short, platform-native variants: a hook on TikTok, a searchable title on YouTube.
- Instagram: `instagramMediaType` is `REELS` (default) or `STORIES`.
- Facebook: needs a Page; call `get_facebook_pages` and pass `facebookPageId`.
- TikTok: privacy goes in `tiktokPrivacyLevel`. Trending sounds and locations depend on the account's `capabilities` in `list_users`; find them with `tiktok_music_trending`, `tiktok_music_search`, `tiktok_location_search`.
- YouTube: `youtubePrivacyStatus`, `youtubePlaylistId`, `youtubeTags`, `youtubeThumbnailUrl`.
- `firstComment` posts a comment under the video right after publishing (hashtags, links).

## 4. Now or later

- Now: omit `scheduledDate`.
- At a time: `scheduledDate` in ISO 8601 plus `timezone` (IANA, e.g. `Europe/Madrid`). Confirm the local time back to the user.
- Next free slot: `addToQueue: true` (see `content-calendar`).

Reddit publishing is currently unavailable; say so if asked.

## 5. Confirm

Uploads return a `request_id`. Poll `get_status` until it finishes, then report each network and its result. If one network failed, offer `retry_post` for that one instead of re-uploading everything.
