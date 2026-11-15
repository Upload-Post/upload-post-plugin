---
name: analyze-performance
description: Pull analytics from Upload-Post (account-level and post-level), summarise what is working, and suggest content moves. Use when the user asks about analytics, performance, engagement, impressions, reach, top posts, or what to post next.
---

# Analyse account performance

Pulling raw numbers is easy. The value is in the interpretation. Do both.

## 1. Scope the question

Before calling tools, narrow down:

- One platform or all of them?
- One account or the whole portfolio?
- Time window (default to last 28 days)?
- Headline metric (reach, engagement rate, follower growth, DM conversion)?

If the user is vague, default to: all connected accounts, last 28 days, engagement rate.

## 2. Fetch

Call the analytics tools in parallel:

- `get_analytics` with `profileUsername` — overall snapshot for the profile.
- `get_total_impressions` with `profileUsername` — headline number across platforms.
- `get_platform_metrics` — per-platform breakdown for the workspace.
- `get_post_analytics` with `requestId` — deep dive on a specific upload; or with `platformPostId` + `platform` + `user` for any post of the account (for example one from `get_media`). A TikTok draft has metrics only once the creator publishes it as public from the TikTok app; a draft published as private never gets per-post analytics.
- `get_history` — paginated log of what was actually published, and when. Use it to build the denominator (posting cadence) that the engagement numbers hang off.
- `manage_autodms` with `action: "status"` and `user` — AutoDM counters, if any are running; `list_autodm_rules` for account-wide rules (`stats` per trigger).
- Telegram: `get_analytics` with `telegram` returns subscribers or members, reactions (`engagement`/`likes`) and active boosts; the Bot API has no views, so do not promise reach. `manage_telegram_chat` with `action: "get_boosts"` details the boosts.
- Google Business: `google_business_read` with `action: "performance"` (daily impressions, calls, website clicks, directions for `start_date`/`end_date`) and `action: "search_keywords"` (the monthly searches that showed the location).
- When the question is *when* to post, `get_best_times` per network answers it with its `source` and `confidence`.

For qualitative signal, `get_post_comments` on the top and bottom post is worth more than another metric: what people actually said explains the numbers.

## 3. Summarise

Lead with the headline number and the delta vs the previous period. Then three bullets:

- **What worked**: the top post, why it stood out (format, length, hook).
- **What underperformed**: the bottom post, with a guess at why.
- **One concrete next move**: not "post more reels" — something specific like "your 25–35s reels with a face-cam hook are 3x your other content; cut two more from your last livestream."

## 4. Hand off to action

If the user agrees with the next move, route them to the right skill: `repurpose-video` if it is about shorts, `schedule-campaign` if they have content ready, `posting-queue` if the problem is cadence rather than content, `manage-comments` if the win is in replying, `autodm-setup` if the action is about converting engagement into leads.

## Cross-platform comparisons

Be careful comparing raw impressions across platforms — TikTok and YouTube Shorts inflate views vs Instagram. Compare engagement rate (engagements / reach) instead.
