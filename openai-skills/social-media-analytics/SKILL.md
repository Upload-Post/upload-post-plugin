---
name: social-media-analytics
description: Analyze social media performance with Upload-Post analytics - views, impressions, reach, followers, engagement, audience, and per-post results on Instagram, TikTok, YouTube, Facebook, LinkedIn Pages, Threads, Pinterest and more, then recommend what to post next. Use when the user asks how their posts or accounts are doing, for a social media report, top or worst posts, growth, or TikTok hashtag ideas. Do not use for website or ad-campaign analytics.
---

# Social media analytics

Numbers are easy; the value is the interpretation. Do both.

## 1. Scope

Which networks, which profile, which period, which metric. If the user is vague: all connected accounts, last 28 days, engagement.

## 2. Fetch

- `get_analytics` with `profileUsername` (and `platforms`, `pageId` for a Facebook Page, `pageUrn` for a LinkedIn Page; LinkedIn analytics cover company Pages only). Instagram includes follower demographics.
- `get_total_impressions` with `profileUsername` and a `period` (`last_week`, `last_month`, `last_3months`, …) for the headline number.
- `get_history` for what was published and when (posting cadence).
- Per post: `get_post_analytics` with `requestId` (live, limited to 100 calls per 5 minutes). When scanning many posts, prefer `get_cached_post_analytics` (`user`, `platform`).
- TikTok audience and trends: `get_audience` and `get_suggestions` (`type` hashtags or keywords) with `platform: "tiktok"`; they depend on the account's `capabilities` in `list_users`.
- Comments on the best and worst post (`get_post_comments`) often explain the numbers better than another metric.

## 3. Report

Lead with the headline number and the change against the previous period. Then three bullets:

- What worked: the top post and why (format, length, hook).
- What underperformed, with a likely reason.
- One concrete next move, specific to their data.

Compare engagement rate across networks rather than raw views; TikTok and Shorts inflate views next to Instagram.

## 4. Act

If the user agrees, hand off: `video-to-shorts` for more clips, `publish-video` or `schedule-social-posts` for ready content, `content-calendar` if the issue is cadence, `reply-to-comments` if the win is in replies.
