---
name: instagram-auto-dm
description: Set up Instagram auto-DMs with Upload-Post - automatically send a direct message (with up to 3 link buttons) to everyone who comments a keyword on an Instagram post, or on every post of the account, or who replies to a story, mentions the account in a story, or sends a keyword DM, to deliver a lead magnet, link, guide, or discount code. Also check, pause, resume, stop, or read the logs of running auto-DM monitors and rules. Use when the user mentions comment-to-DM, auto DM, "comment GUIDE to get it", DM automation, or capturing leads from Instagram comments. Instagram only.
---

# Instagram auto-DM

An auto-DM monitor watches one Instagram post. When a comment matches a keyword, the commenter gets a private DM.

## 1. Collect the setup

- The Instagram post URL (`post_url`). The post must already be live.
- The profile (`profile_username`) from `list_users`.
- The trigger word(s) (`trigger_keywords`): specific words like `GUIDE` or `RECIPE`, not `yes` or `love`. Without keywords every commenter gets the DM.
- The DM text (`reply_message`): short, with the deliverable. Up to 3 link `buttons` (`{ title, url }`).
- Optional `monitoring_interval` in minutes (15 or more).

Suggest the caption tells people what to comment ("Comment GUIDE and I'll send it to you").

## 2. Start it

`manage_autodms` with `action: "start"` and the fields above. Read back the post, keyword, and message before starting.

## 3. Check and manage

- `action: "status"` lists monitors (`include_inactive` for stopped ones) and their counters.
- `action: "logs"` with `monitor_id` shows who triggered it and when.
- `pause`, `resume`, `stop`, `delete` with `monitor_id`. Do not start a second monitor on the same post; manage the existing one. Confirm before `stop` or `delete`.
- `list_dm_conversations` shows the profile's DM threads, including manual ones.

Report unique commenters, not just DMs sent.

## Every post, stories and DM keywords: account-wide rules

A monitor covers one post for 15 days. For every post and reel of the account (present and future), story replies, story mentions or DMs with a keyword, use an account-wide rule. It never expires.

- `create_autodm_rule`: `profile_username`, `reply_message`, optional `triggers` (`comment` default, `story_reply`, `story_mention`, `dm_keyword` which needs `trigger_keywords`), `trigger_keywords`, `buttons` (up to 3) and `per_user_cooldown_hours` (whole hours, default 24; story and DM triggers never below 24).
- Up to 10 rules per account; 25 DMs per account every 15 minutes plus the daily DM allowance. A post with its own monitor is answered by the monitor.
- `502 webhook_subscription_failed`: Instagram refused the webhook subscription, nothing was created; the user must reconnect Instagram.
- `list_autodm_rules` shows `status`, `stats` and `webhook` health; if `webhook.receiving_events` is false or `webhook.hint` is set, Instagram is not sending events, so the rule cannot fire. `pause_autodm_rule`, `resume_autodm_rule`, `delete_autodm_rule` take `rule_id`; confirm before deleting.

Read back the triggers, keywords and DM text before creating a rule.

## Expectations

Instagram only allows messages to people who interacted first (a comment counts), and it may drop a share of automated DMs, especially on new accounts. Tell the user to test with a second account by commenting the keyword.
