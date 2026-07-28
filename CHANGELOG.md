# Changelog

All notable changes to the Upload-Post plugin for Claude Code.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

[0.2.0]: https://github.com/Upload-Post/upload-post-plugin/releases/tag/v0.2.0
[0.1.0]: https://github.com/Upload-Post/upload-post-plugin/releases/tag/v0.1.0
