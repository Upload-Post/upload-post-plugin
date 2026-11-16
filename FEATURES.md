# Features

Everything this plugin exposes, and which platform supports what. Verified against the Upload-Post MCP server tool set of November 2026.

## Platform support by content type

Support differs per content type — a platform in the video column is not automatically in the text column.

| Platform | Video | Photo | Text | Analytics |
| :-- | :-: | :-: | :-: | :-: |
| TikTok | ✅ | ✅ | — | ✅ |
| Instagram | ✅ | ✅ | — | ✅ |
| YouTube | ✅ | — | — | ✅ |
| X | ✅ | ✅ | ✅ | ✅ |
| LinkedIn | ✅ | ✅ | ✅ | ✅ |
| Facebook | ✅ | ✅ | ✅ | ✅ |
| Threads | ✅ | ✅ | ✅ | ✅ |
| Pinterest | ✅ | ✅ | — | ✅ |
| Reddit | ⏸️ | ⏸️ | ⏸️ | ✅ |
| Bluesky | ✅ | ✅ | ✅ | — |
| Google Business | ✅ | ✅ | ✅ | ✅ |
| Discord | ✅ | ✅ | ✅ | — |
| Telegram | ✅ | ✅ | ✅ | ✅ |
| Mastodon | ✅ | ✅ | ✅ | — |
| WordPress | ✅ | ✅ | ✅ | — |
| Lemmy | — | ✅ | ✅ | — |
| Slack | — | — | ✅ | — |
| Nostr | — | — | ✅ | — |
| Dev.to | — | — | ✅ | — |
| Hashnode | — | — | ✅ | — |
| Whop | — | — | ✅ | — |
| Listmonk | — | — | ✅ | — |

⏸️ Reddit publishing is currently unavailable (`reddit_unavailable`) until the Reddit app is restored.

**22 platforms** total: 15 accept video, 15 accept photos and carousels, 18 accept text, 11 report analytics. Documents (PDF carousels) are LinkedIn; Telegram takes any file (audio, voice, sticker, GIF) through `upload_document`. Google Business analytics come from its own performance metrics; Telegram reports subscribers, reactions and boosts (no views).

## Skills

| Skill | What it does |
| :-- | :-- |
| `setup` | OAuth onboarding, connection check, profile discovery |
| `schedule-campaign` | Cross-platform publishing with per-platform validation and options |
| `posting-queue` | Recurring weekly slots, timezone, next-slot preview, best times to post and automatic slots |
| `repurpose-video` | Long video → transcript → viral moments → cut clips → scheduled shorts |
| `manage-comments` | Read, triage, reply and moderate comments and their replies; Instagram and Bluesky DMs; Google Business reviews |
| `autodm-setup` | Instagram comment-to-DM funnels: one post (monitor) or the whole account (rule: every post, story replies, story mentions, keyword DMs) |
| `analyze-performance` | Analytics across accounts, interpreted, with a concrete next move |
| `manage-youtube` | YouTube after publishing: playlists, captions, comment inbox and moderation, channel settings, search, live broadcasts and chat, daily allowance |
| `manage-channels` | Edit, repost and act on live posts; Telegram chat and bot; Bluesky reads and drafts; Google Business posts, reviews, performance and location info |
| `whitelabel-connect` | JWT connection links so your clients OAuth into your workspace |

## Agents

| Agent | Use it for |
| :-- | :-- |
| `content-strategist` | Reads your analytics, proposes 3–5 specific next posts |
| `autodm-architect` | Designs full comment-to-DM funnels end to end |
| `post-debugger` | Root-causes failed uploads, expired tokens, quota errors, missing webhooks, silent AutoDMs |

## Tool families

The MCP server groups its tools as follows (main ones).

**Publishing** — `upload_video`, `upload_photos`, `upload_text`, `upload_document`. Each accepts a fixed schedule (`scheduledDate` + `timezone`), a queue append (`addToQueue`), or immediate publish, plus per-platform `platformOptions` (including `paidPartnership` / `facebookSponsorId` for sponsored posts and the Telegram, Bluesky and Google Business options).

**Scheduling & queue** — `list_scheduled`, `edit_scheduled`, `cancel_scheduled`, `get_queue_settings`, `update_queue_settings` (fixed slots or `slots: "auto"`), `preview_queue`, `get_best_times`.

**Post lifecycle** — `get_status`, `get_job_status`, `get_history`, `get_media`, `retry_post`, `unpublish_post`, `edit_post`, `repost_post`, `post_action`.

**YouTube** — `youtube_read`, `manage_youtube_playlists`, `manage_youtube_comments`, `manage_youtube_channel`, `manage_youtube_videos`, `manage_youtube_live` (`action` plus `params`); `edit_post` also edits YouTube videos and `upload_video` takes `youtubeLocalizations` / `youtubeBrandPartner`.

**Telegram, Bluesky and Google Business** — `manage_telegram_chat`, `manage_telegram_bot`, `bluesky_read`, `manage_bluesky_account`, `google_business_read`, `update_google_business_location` (an `action` plus `params` with the API's own field names).

**Analytics** — `get_analytics`, `get_total_impressions`, `get_post_analytics`, `get_platform_metrics`, `get_reddit_detailed_posts`.

**Comments & reviews** — `get_post_comments` (replies with `commentId`), `create_comment`, `delete_comment`, `comment_action`, `public_reply_to_comment`, `reply_to_comment`, `get_google_business_reviews`, `reply_to_google_business_review`.

**DMs & automation** — `send_dm`, `list_dm_conversations` (Instagram and Bluesky), `manage_autodms` (one post), `create_autodm_rule`, `list_autodm_rules`, `pause_autodm_rule`, `resume_autodm_rule`, `delete_autodm_rule` (whole Instagram account).

**Webhooks** — `list_webhook_deliveries`, `get_webhook_delivery`, `redeliver_webhook`.

**Targets & destinations** — `get_facebook_pages`, `get_linkedin_pages`, `resolve_linkedin_organization` (urn and exact name for LinkedIn mentions), `get_pinterest_boards`, `get_google_business_locations`.

**Profiles & white-label** — `list_users`, `create_user`, `delete_user`, `get_account_info`, `generate_jwt`, `validate_jwt`.

**Media staging** — `create_media_upload`, `complete_media_upload`, `get_media_upload`, `delete_media_upload`, `open_upload_studio`.

**Video encoding** — `submit_ffmpeg_job`, `get_ffmpeg_job`, `download_ffmpeg_result`, `get_ffmpeg_consumption`.

## Notable limitations

Worth knowing before you plan around them:

- **Comments**: `reply_to_comment` (private DM to a commenter) and `public_reply_to_comment` are Instagram-only, and Instagram's private-reply window closes after 7 days. Replies under a comment can be read on Instagram, Facebook, LinkedIn Pages, TikTok, Threads and YouTube, not on X or Bluesky.
- **`create_comment` on Instagram** accepts replies only, never top-level comments.
- **`unpublish_post`** does not work on Instagram, TikTok or Threads; delete those in the native app.
- **`edit_post`** works on Facebook, LinkedIn, X (Premium, edit window), Google Business and Telegram; Telegram bots can only delete messages for 48 hours.
- **Bluesky**: likes, reposts, follows, lists and reports are not available; drafts are text only.
- **YouTube management** shares a daily allowance per account (2,000 units on paid plans, 200 on free; searches 5 and 1 a day). Captions are the expensive calls; the free plan cannot upload or download them.
- **AutoDM rules** are Instagram-only and run on Instagram webhooks: up to 10 per account, 25 DMs per account every 15 minutes plus the daily DM allowance.
- **Bluesky DMs** need an app password created with "Allow access to your direct messages". Bluesky galleries take up to 10 images.
- **`update_queue_settings`** replaces the configuration wholesale rather than merging.
- **Analytics** cover 11 of the 22 platforms — the rest publish but do not report back.
