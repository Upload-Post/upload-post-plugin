---
description: Schedule a post (text, photo, video, or thread) across multiple platforms at once. Pick the right MCP upload tool per platform, validate media, set the publish time, and confirm everything is queued. Use when the user wants to schedule, queue, publish, or cross-post content.
---

# Schedule a cross-platform campaign

The Upload-Post MCP exposes per-platform upload tools. Your job is to orchestrate them into one campaign.

## 1. Gather inputs

Ask only for what you do not have. Required:

- **Content type**: text, photo, video, document, or thread.
- **Platforms**: list of target accounts. Default to all connected accounts unless the user narrows it.
- **Media**: file path, URL, or already-uploaded media id.
- **Caption / text body**: usually one message, but the user may want per-platform variants.
- **Schedule time**: ISO 8601, or `now` for immediate publish.

## 2. Validate per platform

Each platform has constraints. Catch the obvious ones before calling the API:

- **TikTok / Reels / Shorts**: vertical 9:16 video, ≤ 60s for Reels/Shorts, ≤ 3min for TikTok.
- **X**: text ≤ 280 chars unless premium; video ≤ 2:20.
- **LinkedIn**: needs a page id if posting as a company — call `get_linkedin_pages` first.
- **Reddit**: needs a subreddit (and sometimes a flair). Inspect `platformOptions` and use `get_reddit_detailed_posts` if the user wants reference posts.
- **Facebook**: needs a page id — call `get_facebook_pages`.
- **Pinterest**: needs a board id — call `get_pinterest_boards`.
- **Google Business**: needs a location id — call `get_google_business_locations`, then pass the id as `googleBusinessLocationId` inside `platformOptions`. There is no separate "select location" tool.

## 3. Schedule

Call the right upload tool by content type:

- Video → `upload_video` (`videoPathOrUrl`)
- Photo / carousel → `upload_photos`
- Text-only → `upload_text`
- Document → `upload_document`

Every call takes:

- `user` — profile username from `list_users`.
- `platforms` — array of platform names.
- `title` and/or `description` — caption.
- `scheduledDate` — ISO 8601 (e.g. `2026-12-25T10:00:00Z`) + `timezone` (IANA, e.g. `Europe/Madrid`).
- `addToQueue: true` — alternative to a fixed time; appends to the profile's queue instead of pinning an exact timestamp. Use `preview_queue` first if the user wants to see which slot it will land in (see `/upload-post:posting-queue`).
- `platformOptions` — per-platform overrides as a flat object with camelCase keys (`tiktokPrivacyLevel`, `youtubeMadeForKids`, `redditSubreddit`, etc.).
- `asyncUpload: true` (default) — returns a `request_id`; poll `get_status` for completion.

If the user wants identical content on every platform, one call with the full `platforms` array is enough. If they want per-platform copy or media, make one call per platform in parallel.

## 4. Confirm

Read back: platform → handle → scheduled time → `request_id`. If a platform failed, surface the error and ask whether to retry that platform alone or abort the whole campaign.

## Listing and editing

If the user asks "what do I have scheduled", call `list_scheduled`. To change a scheduled post, use `edit_scheduled` or `cancel_scheduled` rather than creating a new one. For everything already published, `get_history` gives the paginated log across all profiles.

## After the fact

- **A platform failed** → `retry_post` with the `requestId` (async upload) or `jobId` (scheduled/queued). It re-runs the same payload; do not rebuild the campaign by hand.
- **The user wants a published post taken down** → `unpublish_post` with `user`, `platform` and `postId`. It is destructive and irreversible, so confirm first. Only facebook, youtube, x, linkedin and threads are supported — Instagram and TikTok deletions must be done in the native app.
- **The user wants to see what is already live on an account** → `get_media` pulls recent posts straight from the connected platform, useful to avoid reposting the same thing.
