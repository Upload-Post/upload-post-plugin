---
name: instagram-auto-dm
description: Set up Instagram auto-DMs with Upload-Post - automatically send a direct message (with up to 3 link buttons) to everyone who comments a keyword on an Instagram post, to deliver a lead magnet, link, guide, or discount code. Also check, pause, resume, stop, or read the logs of running auto-DM monitors. Use when the user mentions comment-to-DM, auto DM, "comment GUIDE to get it", DM automation, or capturing leads from Instagram comments. Instagram only.
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

## Expectations

Instagram only allows messages to people who interacted first (a comment counts), and it may drop a share of automated DMs, especially on new accounts. Tell the user to test with a second account by commenting the keyword.
