---
name: manage-youtube
description: Manage a YouTube channel after publishing — video details and thumbnails, playlists, captions, the comment inbox and moderation, channel settings, sections, banner and watermark, search, live broadcasts, streams and live chat — within the account's daily YouTube allowance. Use when the user wants to organise videos into playlists, add or fix subtitles, answer or moderate YouTube comments, change the channel description or keywords, find videos, or schedule and run a live stream.
---

# Manage a YouTube channel

Six MCP tools cover the channel. Each takes an `action` and a `params` object with the API's own field names, plus the profile in `user`.

- `youtube_read` — reads: `videos` (`ids`, `chart: "mostPopular"`, `my_rating`), `quota`, `rating`, `playlists`, `playlist_items`, `playlist_image`, `captions`, `comments` (`video_id` or `scope: "channel"`, `moderation_status`), `comment_replies`, `search`, `categories`, `languages`, `regions`, `channel`, `channel_lookup` (`for_handle`), `channel_sections`, `subscriptions`, `activities`, `broadcasts`, `broadcast`, `streams`, `stream`, `live_chat`, `super_chats`.
- `manage_youtube_playlists` — `create`, `update`, `delete`, `add_video` (`video_id`, `position`, `note`), `update_video`, `remove_video`, `set_image`, `replace_image`, `delete_image`.
- `manage_youtube_comments` — `create` (`text` + `parent_id` to reply, or `video_id`), `edit`, `delete`, `moderate` (up to 50 `comment_ids`, `status`: `published`, `heldForReview`, `rejected`; `ban_author`).
- `manage_youtube_channel` — `update` (description, keywords, country, default language, trailer, translations; settings and translations in separate calls; the channel name cannot be changed), sections, `set_banner`, `set_watermark` / `remove_watermark`, `subscribe` / `unsubscribe`.
- `manage_youtube_videos` — `rate`, `set_thumbnail`, `upload_caption` (file URL, `language`, `name`, `is_draft`), `update_caption`, `delete_caption`. Title, description, tags, privacy and translations of a published video change with `edit_post` (`platform: "youtube"`).
- `manage_youtube_live` — broadcasts (`create_broadcast` with `title`, `scheduled_start_time`, `privacy_status`, optionally `create_stream`; `update_broadcast`, `delete_broadcast`, `bind`, `transition` to `testing` / `live` / `complete`, `insert_cuepoint`), streams, and chat (`send_chat_message`, polls, `close_poll`, `delete_chat_message`; only in your own broadcasts).

At upload, `upload_video` also takes `youtubeLocalizations` (translated title and description per language; needs the default language) and `youtubeBrandPartner` (the brand's `UC…` channel ID).

## 1. Check the budget first

These calls share a daily allowance per Upload-Post account, in YouTube quota units, reset at midnight Pacific Time: **2,000 units on paid plans, 200 on free; searches 5 and 1 a day**. Uploads have their own allowance and are never limited by it. Before a batch, call `youtube_read` with `action: "quota"` and tell the user what the plan costs.

- Reads: 1 unit (live chat 5 per page: following a chat every few seconds burns the day quickly).
- Playlist and comment writes: about 50 units each (moderating 50 comments is one call).
- Captions are the expensive part: list 50, upload 400, replace 450, download 200. The free plan cannot upload or download captions (`403 youtube_plan_daily_limit_too_low`).
- Searches have their own tiny daily limit: prefer `for_mine` or a playlist listing when looking for the user's own videos.

## 2. Confirm before anything destructive

Deleting a playlist, removing a video from one, deleting a caption, comment, section, broadcast or stream, rejecting comments, replacing a watermark or image, and moving a broadcast to `live` or `complete` need the API's `confirm: true`. Without it the API answers `confirmation_required` and nothing reaches YouTube. Show the user exactly what will change, get a yes, and only then repeat the call with `confirm: true`. Never add it on your own.

## 3. Read the answers right

- Lists carry `items`, `next_page_token` and `page_info`.
- On updates `""` means no change; remove a value with `null` or the `*_remove` lists.
- `502 youtube_write_outcome_unknown`: the write may have happened. Read it back before trying again; never retry it blindly.
- `403 youtube_insufficient_scope` on captions: the channel was connected before that permission existed: reconnect YouTube.
- The stream key of a live stream is a secret: never print it in full.

## Handing off

- New video to publish → `/upload-post:schedule-campaign`.
- Numbers and what to post next → `/upload-post:analyze-performance`.
- Comments on other networks → `/upload-post:manage-comments`.

Reference: https://docs.upload-post.com/api/youtube-videos
