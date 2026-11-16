# Upload-Post extension

This extension connects Gemini CLI to the hosted Upload-Post MCP server (`https://mcp.upload-post.com/mcp`). It publishes and schedules content to TikTok, Instagram, YouTube, LinkedIn, Facebook, X, Threads, Pinterest, Reddit, Bluesky, Telegram and Google Business Profile, and reads analytics, comments and DMs.

## Authentication

The server uses OAuth 2.1 with PKCE and dynamic client registration. On first use Gemini CLI opens a browser tab to sign in (a free account needs no card). Run `/mcp auth upload-post` to re-authenticate. An API key also works: send it as the header `Authorization: ApiKey <key>` from a `settings.json` override of the `upload-post` server.

## Using the tools

- Start with `list_users` to see the profiles and which social accounts are connected. Every upload targets a profile (`user`) and a list of `platforms`.
- Publishing: `upload_video`, `upload_photos`, `upload_text`, `upload_document`. Each post is either immediate, scheduled (`scheduledDate` + `timezone`) or appended to the posting queue (`addToQueue`).
- Pages and boards: resolve IDs with `get_facebook_pages`, `get_linkedin_pages`, `get_pinterest_boards` or `get_google_business_locations` before posting there.
- After posting, check `get_status` or `get_history`. Uploads are asynchronous.
- Scheduled posts: `list_scheduled`, `edit_scheduled`, `cancel_scheduled`. Queue: `get_queue_settings`, `update_queue_settings` (`slots: "auto"` follows the best times), `preview_queue`. Best hours per network: `get_best_times` (with `source` and `confidence`).
- Live posts: `edit_post` (Facebook, LinkedIn, X, Google Business, Telegram), `repost_post` (LinkedIn, X, Threads, Telegram forward/copy), `post_action` (Bluesky bookmark/pin/reply and quote settings, Telegram reactions).
- Telegram, Bluesky, Google Business: `manage_telegram_chat`, `manage_telegram_bot`, `bluesky_read`, `manage_bluesky_account`, `google_business_read`, `update_google_business_location` (an `action` plus `params` with the API's field names).
- YouTube after publishing: `youtube_read`, `manage_youtube_playlists`, `manage_youtube_comments`, `manage_youtube_channel`, `manage_youtube_videos`, `manage_youtube_live`. They share a daily allowance (check `youtube_read` with `action: "quota"`); destructive actions need the API's `confirm: true`, set only after the user agrees.
- Sponsored posts: `paidPartnership: true` in `platformOptions` (Facebook also needs `facebookSponsorId`).
- Analytics: `get_analytics`, `get_post_analytics`, `get_total_impressions`, `get_platform_metrics`.
- Comments and DMs: `get_post_comments` (`commentId` reads the replies under a comment), `create_comment`, `reply_to_comment`, `public_reply_to_comment`, `send_dm` and `list_dm_conversations` (Instagram and Bluesky), `manage_autodms` (one post), `create_autodm_rule` / `list_autodm_rules` / `pause_autodm_rule` / `resume_autodm_rule` / `delete_autodm_rule` (whole Instagram account).
- LinkedIn mentions: `resolve_linkedin_organization` gives the exact name and urn for `@[Name](urn:li:organization:ID)`.
- Webhooks: `list_webhook_deliveries`, `get_webhook_delivery`, `redeliver_webhook` (last 7 days).

## Safety rules

- Publishing, replying, sending DMs and deleting are public or irreversible. Show the user the exact caption, media, target accounts and schedule, and get explicit confirmation before calling any upload, comment, DM, delete or `unpublish_post` tool.
- Default to scheduling or the queue when the user has not asked to post right now.
- `update_queue_settings` replaces the whole configuration; read it with `get_queue_settings` first and send the full object back.
- `unpublish_post` does not work on Instagram, TikTok or Threads: those posts must be deleted in the native app.
- Edits, reposts, Telegram moderation and Google Business location edits change public things: confirm first, and set the API's `confirm: true` only after the user said yes. Never set `paidPartnership` unless the user says the post is sponsored.
- Private replies to commenters are Instagram-only and only within 7 days. AutoDM rules and `redeliver_webhook` act on their own once called: confirm first.
- Bluesky DMs need an app password with DM access (`403 bluesky_dm_scope_missing` otherwise). After `504 bluesky_send_unconfirmed` read the conversation before resending.
- Never print or log API keys or JWTs. `generate_jwt` links let a third party connect accounts to a profile; share them only with the intended person.
- Respect each platform's rules and the user's quota. If a tool returns a quota or token error, report it instead of retrying in a loop.

Docs: https://docs.upload-post.com/guides/mcp-server-integration/
