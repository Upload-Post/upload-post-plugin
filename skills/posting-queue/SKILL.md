---
name: posting-queue
description: Configure and inspect the Upload-Post posting queue — the recurring time slots that queued content drips into, fixed or filled automatically with the best times to post. Use when the user wants a posting schedule or rhythm, asks when their next post goes out or when the best time to post is, wants to change posting times or days, or says they want to queue content instead of picking exact timestamps.
---

# Manage the posting queue

The queue is a recurring weekly grid of slots per profile. Anything uploaded with `addToQueue: true` fills the next free slot instead of needing an explicit timestamp. This is how a user gets a consistent rhythm without picking dates by hand.

## 1. Read the current setup

Call `get_queue_settings` with `profile_username`. The schema marks it optional, but the API rejects the call with `400 profile_username is required` — always pass it. Get the name from `list_users` first if you do not have it.

It returns `timezone`, `slots`, `days_of_week`, `max_posts_per_slot`, and `full_slots` (slots already at capacity). With automatic slots it also returns `slots_mode: "auto"`, `auto_slots` (the hours chosen from the best times), `effective_slots` (what the queue is filling right now) and `auto_slots_info` (when they were computed and the `source` / `confidence` of each network).

Then call `preview_queue` (same `profile_username`) to show what is actually lined up. Pass `nextSlot: true` when the user only asks "when does my next post go out?" — it returns just `next_slot` with `datetime_utc`, `datetime_local` and `timezone`, instead of the whole grid. Quote the **local** time back to the user; the UTC field is for your own arithmetic.

Present it as a compact weekly view, not raw JSON. For example:

```
Europe/Madrid · Mon–Fri
  10:00  → "Behind the scenes" (Thu)
  16:00  → free
```

## 2. Change it

`update_queue_settings` takes:

- `profile_username` — required.
- `timezone` — IANA name (`Europe/Madrid`, `America/New_York`). Slots are local to this, so changing it moves every slot.
- `slots` — array of `{ hour, minute }` in 24-hour local time, sorted by time, max 24. `minute` defaults to 0.
- `days_of_week` — allowed posting days, **0 = Monday through 6 = Sunday**. Say this out loud when confirming; the off-by-one against the JS convention (where 0 = Sunday) is the most common mistake.
- `max_posts_per_slot` — 1–100.

**This call replaces the configuration wholesale** — it is marked destructive for a reason. Omitted fields are not merged with what was there. So: read the current settings, apply the user's change on top, describe the grid you are *about to* send in plain language, get a yes, and only then write. Changing slots re-times content that is already queued.

## 3. Best times and automatic slots

If the user has no idea what to pick, do not invent a "best time to post" from thin air. Call `get_best_times` with `profile_username` and `platform` (TikTok, Instagram, Facebook, YouTube, LinkedIn, Threads, Pinterest or Bluesky), plus `timezone` so the hours come back in local time. It answers `best_times` (best first), `by_hour`, `by_day`, and says where they come from:

- `source: "audience_activity"` — the network reports when followers are online (TikTok Business, Instagram with 100+ followers).
- `source: "account_posts"` — the account's own recent posts compared with its median post.
- `source: "upload_post_history"` — posts published through Upload-Post.
- `source: "none"` — not enough data yet; say so, and only then fall back to generic advice (2 slots/day, late morning and early evening, weekdays).

Quote the `confidence` with the hours. `refresh: true` only recomputes an answer older than 24 hours (YouTube 7 days); otherwise the cached one comes back.

To let the queue follow those hours by itself, call `update_queue_settings` with `slots: "auto"` (or `slots_mode: "auto"`), `auto_slots_count` (1-12 hours per day) and optionally `auto_platforms` (up to 6 networks; default every connected network with best times). The fixed `slots` stay stored as a fallback while there is no data, posts already scheduled do not move, and sending a `slots` array (or `slots_mode: "fixed"`) switches back. The same wholesale-replace rule applies: read first, describe, confirm.

## Handing off

- Content ready to fill the queue → `/upload-post:schedule-campaign` with `addToQueue: true`.
- A batch of clips to drip out → `/upload-post:repurpose-video`, then queue them.
- Wondering whether the rhythm is working → `/upload-post:analyze-performance`.
