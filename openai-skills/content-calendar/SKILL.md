---
name: content-calendar
description: Plan a social media content calendar (a week or a month of posts) and set up a recurring posting schedule with Upload-Post's posting queue, so content drips out at fixed times on Instagram, TikTok, YouTube, LinkedIn, X, Facebook and more. Use when the user wants a posting schedule, a weekly plan, consistent posting, best times to post, or asks when their next post goes out. For a single post use publish-video or schedule-social-posts.
---

# Content calendar and posting queue

The queue is a weekly grid of time slots per profile. Anything published with `addToQueue: true` takes the next free slot, so the user gets a steady rhythm without picking dates.

## 1. Read the current setup

Get the profile name from `list_users`, then call `get_queue_settings` with `profile_username` (always pass it). It returns `timezone`, `slots`, `days_of_week`, `max_posts_per_slot`.

Call `preview_queue` with the same `profile_username` to see what is lined up. For "when is my next post?" pass `nextSlot: true` and quote the local time.

Show it as a short weekly view, not JSON.

## 2. Choose times from real data

Do not invent "best times to post". Look at the user's own results with `get_analytics` (`profileUsername`) and `get_total_impressions`. Only fall back to generic advice (two slots a day, late morning and early evening, weekdays) when there is no history, and say so.

## 3. Change the schedule

`update_queue_settings` takes `profile_username`, `timezone` (IANA), `slots` (`{ hour, minute }` in local time, up to 24), `days_of_week` (0 = Monday … 6 = Sunday), `max_posts_per_slot`.

It replaces the whole configuration. Read the current settings, apply the change on top, describe the new grid in plain words (say the day names, not numbers), get a yes, then write. Changing slots moves posts already queued.

## 4. Fill the calendar

For a week or month of content: draft the posts with the user (themes, captions, which network), then publish each one with `addToQueue: true` through `publish-video` or `schedule-social-posts`. Space clips out instead of posting several to the same account at once. Finish with `preview_queue` so the user sees the full calendar.
