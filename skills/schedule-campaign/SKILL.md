---
name: schedule-campaign
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
- **LinkedIn**: needs a page id if posting as a company — call `get_linkedin_pages` first. Mentions go in the LinkedIn text as `@[Exact Page Name](urn:li:organization:ID)`, `@[Name](urn:li:person:ID)` or `@company-vanity`. A company name must match LinkedIn exactly, capitals included, or it is published as plain text: get the urn and exact name with `resolve_linkedin_organization` (`user`, `url` = the Page URL or vanity) and paste its `mention`. For photos and videos put mentions in the description, not only the title.
- **Bluesky**: 4 images per post; with `platformOptions.blueskyGallery: true` up to 10 as a gallery. Extra images are dropped with a warning, the post does not fail.
- **Reddit**: publishing is currently unavailable (`reddit_unavailable`) until the Reddit app is restored. Do not include it as a target; if the user asks for Reddit, say so and offer the other platforms.
- **Facebook**: needs a page id — call `get_facebook_pages`.
- **Pinterest**: needs a board id — call `get_pinterest_boards`.
- **Google Business**: needs a location id — call `get_google_business_locations`, then pass the id as `googleBusinessLocationId` inside `platformOptions`. There is no separate "select location" tool. Recurring EVENT/OFFER posts: `gbpRecurrence` (`DAILY`/`WEEKLY`/`MONTHLY`) with `gbpRecurrenceDays`, `gbpRecurrenceDayOfMonth`, `gbpRecurrenceWeekOccurrence`, `gbpRecurrenceEnd`; several photos in one post: `gbpMultiMedia: true`; `gbpUploadToGallery`; `gbpScheduledTime` is Google's own schedule (cancelling in Upload-Post does not stop it).
- **Telegram**: the bot publishes in the connected chat. `platformOptions` take the Bot API options: `telegramReplyMarkup` (URL buttons), `telegramPin`, `telegramReplyToMessageId`, `telegramMessageThreadId`, `telegramDisableNotification`, `telegramProtectContent`, `telegramCaptionOverflow: "split"` for captions over 1,024 characters; text posts can be a `telegramPoll`, `telegramLocation`, `telegramVenue`, `telegramContact` or `telegramDice`. An invalid option fails only the Telegram result (`telegram_invalid_parameter`). Any file (audio, voice, sticker, GIF) goes through `upload_document`.
- **Bluesky extras**: `blueskyTags` (up to 8 hashtags not shown in the text), `blueskyThreadOverflow: true` (text over 300 characters continues as replies instead of being cut), `blueskyCaptions` (WebVTT on video), `blueskyVideoPresentation: "gif"`, `blueskyGifAsVideo`.
- **Sponsored content**: `paidPartnership: true` sets each network's native label (TikTok branded content, YouTube paid promotion, X paid partnership); Facebook also needs `facebookSponsorId` (the sponsor's Page). Other networks publish without it and return a warning. TikTok refuses it with `SELF_ONLY` privacy (`commercial_disclosure_privacy_conflict`) and drafts do not carry it. Ask the user whether a post is sponsored when the caption names a brand deal; never set it on your own.

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
- `addToQueue: true` — alternative to a fixed time; appends to the profile's queue instead of pinning an exact timestamp. Use `preview_queue` first if the user wants to see which slot it will land in (see `/upload-post:posting-queue`). If they ask "when is the best time?", call `get_best_times` rather than guessing.
- `platformOptions` — per-platform overrides as a flat object with camelCase keys (`tiktokPrivacyLevel`, `youtubeMadeForKids`, `facebookPageId`, etc.).
- `asyncUpload: true` (default) — returns a `request_id`; poll `get_status` for completion.

If the user wants identical content on every platform, one call with the full `platforms` array is enough. If they want per-platform copy or media, make one call per platform in parallel.

## 4. Confirm

Read back: platform → handle → scheduled time → `request_id`. If a platform failed, surface the error and ask whether to retry that platform alone or abort the whole campaign.

## Listing and editing

If the user asks "what do I have scheduled", call `list_scheduled`. To change a scheduled post, use `edit_scheduled` or `cancel_scheduled` rather than creating a new one. For everything already published, `get_history` gives the paginated log across all profiles.

## After the fact

- **A platform failed** → `retry_post` with the `requestId` (async upload) or `jobId` (scheduled/queued). It re-runs the same payload; do not rebuild the campaign by hand.
- **The user wants to fix a live post** → `edit_post` (Facebook, LinkedIn, X, Google Business, Telegram) or reshare it with `repost_post` (LinkedIn, X, Threads; Telegram forward or copy). See `/upload-post:manage-channels`.
- **The user wants a published post taken down** → `unpublish_post` with `user`, `platform` and `postId`. It is destructive and irreversible, so confirm first. A Telegram post can be several messages (album, rest of a long caption, first comment): pass `delete_all_messages: true` to remove them all; bots can delete for 48 hours. Instagram, TikTok and Threads cannot be unpublished through Upload-Post (Instagram only allows it to apps connected with Facebook Login, and Upload-Post uses Instagram Login): those deletions must be done in the native app.
- **The user wants to see what is already live on an account** → `get_media` pulls recent posts straight from the connected platform, useful to avoid reposting the same thing.
