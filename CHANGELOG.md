# Changelog

All notable changes to the Upload-Post plugin for Claude Code.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.7.0] — 2026-11-16

Needs the Upload-Post MCP server release with the YouTube tools (0.25.0).

### Added

- `manage-youtube` skill: `youtube_read`, `manage_youtube_playlists`, `manage_youtube_comments`, `manage_youtube_channel`, `manage_youtube_videos`, `manage_youtube_live` — playlists, captions, comment inbox and moderation, channel settings, sections, banner and watermark, search, live broadcasts, streams and chat; the daily YouTube allowance and what costs most; `confirm` on destructive actions.
- `youtubeLocalizations` and `youtubeBrandPartner` on `upload_video`; `edit_post` on YouTube videos.
- `FEATURES.md`, `README.md`, `GEMINI.md` and `manage-channels` point to it.

### Versions

- Claude Code, Cursor, Grok and Gemini manifests 0.7.0. The ChatGPT/Codex package is unchanged (1.2.0).

## [0.6.0] — 2026-11-15

Needs the Upload-Post MCP server release that adds `get_best_times`, `edit_post`, `repost_post`, `post_action`, the Telegram, Bluesky and Google Business tools and the new publishing options (0.24.0).

### Added

- `manage-channels` skill: edit, repost / forward and act on live posts (`edit_post`, `repost_post`, `post_action`); Telegram chat and bot (`manage_telegram_chat`, `manage_telegram_bot`); Bluesky reads, account and drafts (`bluesky_read`, `manage_bluesky_account`); Google Business posts, reviews, performance, gallery and location info (`google_business_read`, `update_google_business_location`, legacy / strict edit mode).
- `posting-queue`: best times to post per network with `get_best_times` (`source`, `confidence`) and the automatic queue (`update_queue_settings` with `slots: "auto"`, `auto_slots_count`, `auto_platforms`).
- `schedule-campaign`: sponsored posts (`paidPartnership`, `facebookSponsorId`), Telegram publishing options (buttons, pin, polls, locations, caption overflow, any file via `upload_document`), Bluesky extras (tags, thread overflow, captions), Google Business recurring posts, several photos and Google scheduling; `edit_post` / `repost_post` after publishing and Telegram `delete_all_messages`.
- `analyze-performance`: Telegram analytics, Google Business performance and search keywords, best times.
- `content-strategist` takes its publish times from `get_best_times`.
- `FEATURES.md`, `README.md`, `EXAMPLES.md` and `GEMINI.md` updated.

### Versions

- Claude Code, Cursor, Grok and Gemini manifests 0.6.0. The ChatGPT/Codex package is unchanged (1.2.0): the new tools are not in ChatGPT's reviewed surface yet.

## [0.5.0] — 2026-11-14

Needs the Upload-Post MCP server release that adds account-wide AutoDM rules, webhook delivery tools, Bluesky DMs and `resolve_linkedin_organization`.

### Added

- `autodm-setup`: account-wide Instagram AutoDM rules (`create_autodm_rule`, `list_autodm_rules`, `pause_autodm_rule`, `resume_autodm_rule`, `delete_autodm_rule`): every post and reel, story replies, story mentions and keyword DMs, no expiry, with limits, cooldowns, webhook health and errors. `autodm-architect` helps choose between a per-post monitor and a rule.
- `manage-comments`: Instagram and Bluesky DMs (`list_dm_conversations`, `send_dm`: handles/DIDs, conversation ids, shared posts, sender actions, the DM-enabled app password and `bluesky_send_unconfirmed`), and the replies under a comment on Instagram, Facebook and LinkedIn with their id formats and errors.
- `post-debugger`: webhooks that did not arrive (`list_webhook_deliveries`, `get_webhook_delivery`, `redeliver_webhook`), silent AutoDM rules, `TEAM_SEAT_SUSPENDED` and Bluesky DM errors.
- `schedule-campaign`: LinkedIn mentions with `resolve_linkedin_organization`; Bluesky galleries of up to 10 images.
- `analyze-performance`: `get_post_analytics` by `platformPostId`, TikTok drafts, AutoDM rule stats.
- The same changes in the ChatGPT/Codex skills (`instagram-auto-dm`, `reply-to-comments`, `schedule-social-posts`, `social-media-analytics`) and in `GEMINI.md`.

### Fixed

- `unpublish_post` is not available on Threads (it was listed as supported); Instagram is explained.
- `FEATURES.md` no longer says TikTok comments are unsupported or that AutoDM posts a public reply, and drops the stale tool count.

### Versions

- Claude Code, Cursor, Grok and Gemini manifests 0.5.0; ChatGPT/Codex plugin 1.2.0.

## [0.4.0] — 2026-10-17

### Added

- `plugin.json` directory listing fields: `documentationUrl`, `privacyPolicyUrl`, `supportUrl`, `termsOfServiceUrl` and `icon`.
- `homepage` points at the Claude landing page (`/claude-social-media/`), which covers Claude.ai and Cowork, where most installs come from.
- README "Try it" section with example prompts.

### Changed

- Shorter plugin description that leads with what it does, for the directory card.
- `setup` skill works on Claude.ai, the desktop app and Cowork as well as Claude Code (connect from Customize → Connectors), connects social accounts through `get_connect_link` instead of sending the user to the dashboard, and ends by offering a first post.
- `setup` no longer suggests the local `npx` server with `UPLOAD_POST_API_KEY`; API-key setups stay documented in the README for CI and headless use.

### Fixed

- `autodm-architect` and the README no longer describe a public reply under the comment: AutoDM sends the DM only, with up to 3 link buttons.

## [0.3.0] — 2026-10-02

### Added

- `.claude-plugin/marketplace.json`: the repo is now a self-hosted Claude Code marketplace (`/plugin marketplace add Upload-Post/upload-post-plugin`).
- `gemini-extension.json` and `GEMINI.md`: install as a Gemini CLI extension with `gemini extensions install https://github.com/Upload-Post/upload-post-plugin`.

### Fixed

- Skills synced with the current MCP server tool parameters:
  - `autodm-setup`: `manage_autodms` takes `profile_username`, `post_url`, `reply_message`, `buttons` (max 3), `monitoring_interval` (≥ 15 min), `trigger_keywords`, `monitor_id` and `include_inactive`. AutoDM sends the DM only; there is no public-reply field.
  - `manage-comments`: comments now cover TikTok (`postId` = video id, needs the `comments` capability), X, Threads and Bluesky, plus reversible moderation with `comment_action`.
  - `repurpose-video`: `submit_ffmpeg_job` takes `input_url` or `files`, a `full_command` starting with `ffmpeg` using `{input}`/`{output}` placeholders, and `output_filename`. FFmpeg quota is monthly minutes.
  - `schedule-campaign`: Reddit publishing is currently unavailable (`reddit_unavailable`).
- Every skill now declares a `name:` frontmatter field matching its folder.

## [0.2.0] — 2026-07-28

### Changed

- **Authentication is now OAuth, not an API key.** `.mcp.json` points at the hosted server (`https://mcp.upload-post.com/mcp`) over OAuth 2.1 with dynamic client registration and PKCE, replacing the `npx @upload-post/mcp` stdio server behind `UPLOAD_POST_API_KEY`. Installing no longer requires exporting an environment variable before the plugin works — run `/mcp`, authenticate, done. API-key setups remain documented for CI and headless use.
- Plugin description now reflects the platforms the MCP server actually exposes.
- Documentation links moved from `upload-post.com/mcp-integration-guide` to `docs.upload-post.com`.

### Added

- `posting-queue` skill — configure recurring weekly slots, days and timezone, and preview what lands in the next slot.
- `manage-comments` skill — read, triage, reply to and moderate comments across Instagram, Facebook, YouTube and LinkedIn, plus Google Business reviews.
- Coverage for tools the plugin never surfaced: `retry_post`, `unpublish_post`, `get_history`, `get_media`, and the full queue and comment families.
- `QUICK_START.md`, `FEATURES.md`, `EXAMPLES.md` and this changelog.

### Fixed

- Removed a reference to `select_google_business_location`, a tool that has never existed in the MCP server. Google Business posting takes the location id via `platformOptions.googleBusinessLocationId` after calling `get_google_business_locations`.
- `post-debugger` pointed users at `connect-accounts`, a skill renamed to `whitelabel-connect` in 0.1.0. It now routes platform reconnects to the dashboard, and distinguishes a platform token expiring from the MCP session itself returning 401.
- Documented that `get_queue_settings` requires `profile_username` despite the schema marking it optional — the API rejects the call without it.
- Corrected the queue field names to `days_of_week` (0 = Monday) and `max_posts_per_slot`, and flagged that `update_queue_settings` replaces the configuration wholesale rather than merging.
- Stopped suggesting `get_platform_metrics` to derive posting times; it takes no arguments and only lists available metric names.

## [0.1.0] — 2026-05-20

### Added

- Initial release: MCP server wiring, six skills (`setup`, `whitelabel-connect`, `schedule-campaign`, `repurpose-video`, `autodm-setup`, `analyze-performance`) and three agents (`content-strategist`, `autodm-architect`, `post-debugger`).

[0.3.0]: https://github.com/Upload-Post/upload-post-plugin/releases/tag/v0.3.0
[0.2.0]: https://github.com/Upload-Post/upload-post-plugin/releases/tag/v0.2.0
[0.1.0]: https://github.com/Upload-Post/upload-post-plugin/releases/tag/v0.1.0
