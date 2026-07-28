# Features

Everything this plugin exposes, and which platform supports what. Verified against Upload-Post MCP server **0.6.1** (50 tools).

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
| Reddit | ✅ | ✅ | ✅ | ✅ |
| Bluesky | ✅ | ✅ | ✅ | — |
| Google Business | ✅ | ✅ | ✅ | — |
| Discord | ✅ | ✅ | ✅ | — |
| Telegram | ✅ | ✅ | ✅ | — |
| Mastodon | ✅ | ✅ | ✅ | — |
| WordPress | ✅ | ✅ | ✅ | — |
| Lemmy | — | ✅ | ✅ | — |
| Slack | — | — | ✅ | — |
| Nostr | — | — | ✅ | — |
| Dev.to | — | — | ✅ | — |
| Hashnode | — | — | ✅ | — |
| Whop | — | — | ✅ | — |
| Listmonk | — | — | ✅ | — |

**22 platforms** total: 15 accept video, 15 accept photos and carousels, 18 accept text, 9 report analytics. Documents (PDF carousels) are LinkedIn-only.

## Skills

| Skill | What it does |
| :-- | :-- |
| `setup` | OAuth onboarding, connection check, profile discovery |
| `schedule-campaign` | Cross-platform publishing with per-platform validation and options |
| `posting-queue` | Recurring weekly slots, timezone, next-slot preview |
| `repurpose-video` | Long video → transcript → viral moments → cut clips → scheduled shorts |
| `manage-comments` | Read, triage, reply and moderate comments; Google Business reviews |
| `autodm-setup` | Instagram comment-to-DM funnels (keyword → public reply → private DM) |
| `analyze-performance` | Analytics across accounts, interpreted, with a concrete next move |
| `whitelabel-connect` | JWT connection links so your clients OAuth into your workspace |

## Agents

| Agent | Use it for |
| :-- | :-- |
| `content-strategist` | Reads your analytics, proposes 3–5 specific next posts |
| `autodm-architect` | Designs full comment-to-DM funnels end to end |
| `post-debugger` | Root-causes failed uploads, expired tokens, quota errors |

## Tool families

The MCP server groups its 50 tools as follows.

**Publishing** — `upload_video`, `upload_photos`, `upload_text`, `upload_document`. Each accepts a fixed schedule (`scheduledDate` + `timezone`), a queue append (`addToQueue`), or immediate publish, plus per-platform `platformOptions`.

**Scheduling & queue** — `list_scheduled`, `edit_scheduled`, `cancel_scheduled`, `get_queue_settings`, `update_queue_settings`, `preview_queue`.

**Post lifecycle** — `get_status`, `get_job_status`, `get_history`, `get_media`, `retry_post`, `unpublish_post`.

**Analytics** — `get_analytics`, `get_total_impressions`, `get_post_analytics`, `get_platform_metrics`, `get_reddit_detailed_posts`.

**Comments & reviews** — `get_post_comments`, `create_comment`, `delete_comment`, `public_reply_to_comment`, `reply_to_comment`, `get_google_business_reviews`, `reply_to_google_business_review`.

**DMs & automation** — `send_dm`, `list_dm_conversations`, `manage_autodms`.

**Targets & destinations** — `get_facebook_pages`, `get_linkedin_pages`, `get_pinterest_boards`, `get_google_business_locations`.

**Profiles & white-label** — `list_users`, `create_user`, `delete_user`, `get_account_info`, `generate_jwt`, `validate_jwt`.

**Media staging** — `create_media_upload`, `complete_media_upload`, `get_media_upload`, `delete_media_upload`, `open_upload_studio`.

**Video encoding** — `submit_ffmpeg_job`, `get_ffmpeg_job`, `download_ffmpeg_result`, `get_ffmpeg_consumption`.

## Notable limitations

Worth knowing before you plan around them:

- **Comments**: TikTok is not supported at all. `reply_to_comment` (private DM to a commenter) and `public_reply_to_comment` are Instagram-only, and Instagram's private-reply window closes after 7 days.
- **`create_comment` on Instagram** accepts replies only, never top-level comments.
- **`unpublish_post`** works on Facebook, YouTube, X, LinkedIn and Threads. Instagram and TikTok deletions must be done in the native app.
- **`update_queue_settings`** replaces the configuration wholesale rather than merging.
- **Analytics** cover 9 of the 22 platforms — the rest publish but do not report back.
