---
name: autodm-setup
description: Set up an Instagram comment-to-DM funnel. The user picks a live post, optional trigger keywords, and a private DM (with up to 3 link buttons). Commenters whose comment matches get the DM automatically. Use when the user mentions comment funnel, auto-DM, lead magnet from comments, keyword-triggered DM, DM automation, or wants to capture leads from Instagram comments.
---

# Set up a comment-to-DM funnel

The Upload-Post AutoDM feature watches an Instagram post for new comments. When a comment matches the trigger keywords, the commenter gets a private DM with whatever payload the creator wants (a link, a lead magnet, a discount code). AutoDM sends the DM only — it does not post a public reply under the comment.

## 1. Pick the post and profile

- `post_url` — the Instagram post URL. The post must already be live; there is no way to pre-arm a monitor for a post that does not exist yet.
- `profile_username` — the Upload-Post profile that owns the Instagram account (from `list_users`).

## 2. Pick the keywords

`trigger_keywords` takes one keyword or an array. Without it, every commenter gets the DM. Good keywords:

- One word: `GUIDE`, `RECIPE`, `LINK`.
- Specific enough that random comments do not match: prefer `GUIDE` over `YES`.
- Avoid words that appear in normal conversation about the topic.

Suggest the caption tells people what to comment ("Comment GUIDE and I'll send it to you").

## 3. Write the DM

- `reply_message` — the DM body. Short, with the actual deliverable.
- `buttons` — optional, up to 3 link buttons, each `{ title, url }`. Use these for the link rather than pasting a raw URL into the text.

If the user also wants a public "Sent! Check your DMs" under each comment, that is not part of AutoDM — it would have to be done separately with `public_reply_to_comment` (see `/upload-post:manage-comments`).

## 4. Start the monitor

The Upload-Post MCP exposes a single tool for AutoDMs: `manage_autodms`. To create one, call it with:

- `action: "start"`
- `profile_username`, `post_url`, `reply_message` (required)
- `trigger_keywords`, `buttons` (optional)
- `monitoring_interval` — optional polling interval in minutes, minimum 15.

Read back the post, keywords, and DM text before starting. Every later action needs the `monitor_id`; if it is not in the start response, `action: "status"` lists it.

Other actions on the same tool take `monitor_id`: `logs`, `pause`, `resume`, `stop`, `delete`. `status` lists monitors (add `include_inactive: true` to include stopped and expired ones). Manage the existing monitor rather than spinning up a second one on the same post, and confirm before `stop` or `delete`.

## 5. Validate

Suggest the user test it themselves: comment the keyword on the post from a second Instagram account and confirm the DM arrives (allow for the polling interval). Then run `manage_autodms` with `action: "logs"` and the `monitor_id` to confirm the trigger fired.

## 6. Monitor over time

After it is live:

- `manage_autodms` with `action: "status"` → monitors and their counters.
- `manage_autodms` with `action: "logs"` + `monitor_id` → list of triggers (who commented, when).
- `list_dm_conversations` → broader view of all DMs the profile has sent, including manual ones.

Surface the unique-commenters count, not just total DMs sent — repeat commenters skew the headline number.

## Compliance

Instagram requires that the recipient has interacted with the account first (commenting counts). Do not promise the user 100% delivery — Instagram silently drops a fraction of automated DMs, especially to new accounts. Set the expectation upfront.
