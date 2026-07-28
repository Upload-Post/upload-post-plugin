# Examples

Real prompts, and what the plugin does with them. You do not need to invoke skills explicitly — Claude picks the right one from context — but the slash command is shown where it helps.

## Publishing

**Cross-post a video**

```text
Post ~/Videos/launch.mp4 to TikTok, Reels and Shorts.
Caption: "We shipped it. Here's what changed."
```

Claude validates the aspect ratio and length per platform, then calls `upload_video` with the three platforms in one call and polls `get_status` until each returns.

**Per-platform copy**

```text
Same video everywhere, but on LinkedIn make the caption professional
and add a line about the engineering tradeoffs.
```

One call per platform instead of one shared call, so each gets its own `title`/`description`.

**Post as a company page**

```text
Publish this to our LinkedIn company page, not my personal profile.
```

Calls `get_linkedin_pages` first, then passes the organization id as `targetLinkedinPageId`.

**Schedule for later**

```text
Schedule this for Tuesday 10am Madrid time.
```

Sets `scheduledDate` in ISO 8601 plus `timezone: "Europe/Madrid"`.

## Posting queue

```text
/upload-post:posting-queue

I want to post weekdays at 9am and 6pm, Madrid time, one post per slot.
```

Reads the current config, shows you the grid it is about to write, confirms, then calls `update_queue_settings`. Remember `days_of_week` runs 0 = Monday.

```text
When does my next queued post go out?
```

`preview_queue` with `nextSlot: true` — answers with the local time, not UTC.

## Repurposing long video

```text
/upload-post:repurpose-video

Take ~/Videos/podcast-ep12.mp4 and pull the best short-form moments out of it.
```

Transcribes, identifies viral moments, cuts them with FFmpeg, optionally burns a hook overlay, shows you the candidates, and schedules the ones you approve.

```text
Cut clips from this but only ones where I'm answering a question,
and drip them into my queue instead of scheduling exact times.
```

## Comments and reviews

```text
What are people saying on my last Instagram post?
```

`get_post_comments`, then triaged into questions / buying signals / praise / spam rather than dumped raw.

```text
Reply to the ones asking about pricing. Send them a DM with the link,
and leave a short public reply so others see it's answered.
```

Uses `reply_to_comment` (private) and `public_reply_to_comment` (public) — both Instagram-only, within the 7-day window.

```text
We got a 2-star Google review yesterday. Draft a reply.
```

`get_google_business_locations` → `get_google_business_reviews` → drafts a response that names the specific complaint, and waits for your approval before `reply_to_google_business_review`.

## Comment-to-DM funnels

```text
/upload-post:autodm-setup

On my last reel, DM anyone who comments "GUIDE" with the link to my
lead magnet, and reply publicly so it looks alive.
```

Sets up an AutoDM monitor: keyword trigger, public reply text, private DM payload.

```text
How many DMs did my funnels send this week?
```

`manage_autodms` with `action: "status"`.

## Analytics

```text
How did last month go?
```

Pulls `get_analytics`, `get_total_impressions` and `get_history`, then leads with the headline number and delta, what worked, what did not, and one concrete next move.

```text
Which format is actually working for me?
```

Compares engagement rate rather than raw impressions — view counts are not comparable across TikTok, Shorts and Reels.

## Debugging

```text
My Tuesday post never went out.
```

The `post-debugger` agent checks `get_status` / `get_job_status`, inspects `social_accounts` for `reauth_required`, categorises the failure, and gives you one fix — not a checklist.

```text
This upload failed twice with the same error.
```

It will stop retrying and investigate instead. `retry_post` replays the same payload, so if the payload is what is broken, retrying cannot help.

## Agency / white-label

```text
/upload-post:whitelabel-connect

I need my client Acme to connect their Instagram into my workspace.
```

Creates the profile and generates a JWT connection URL you send them. They run the OAuth themselves; the account lands under a profile you administer.
