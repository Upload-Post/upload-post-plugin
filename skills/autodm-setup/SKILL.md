---
description: Set up an Instagram comment-to-DM funnel. The user picks a post, a keyword trigger, a public reply, and a private DM. Comments matching the keyword get auto-replied publicly and the commenter gets a DM. Use when the user mentions comment funnel, auto-DM, lead magnet from comments, keyword-triggered DM, DM automation, or wants to capture leads from Instagram comments.
---

# Set up a comment-to-DM funnel

The Upload-Post AutoDM feature watches an Instagram post for comments containing a keyword. When it matches, it sends a public reply and a private DM with whatever payload the creator wants (a link, a lead magnet, a discount code).

## 1. Pick the post

Ask the user for the Instagram post URL or shortcode. If they want to set it up before the post exists, save the config and apply it once the post is live.

## 2. Pick the keyword

Ask for the trigger. Good keywords:

- One word, lowercase (Upload-Post normalises by default).
- Specific enough that random comments do not match: prefer `GUIDE` or `RECIPE` over `YES`.
- Avoid words that appear in normal conversation about the topic.

## 3. Write the messages

Two messages, both short:

- **Public reply** (visible under the comment): something like "Sent! Check your DMs." Keeps the post engagement up without spoiling the offer.
- **DM body**: the actual deliverable. Link, file, code, instructions. Instagram allows one link per DM — make it count.

## 4. Start the monitor

The Upload-Post MCP exposes a single tool for AutoDMs: `manage_autodms`. To create one, call it with:

- `action: "start"`
- `user` — the profile username.
- `config` — free-form object with at minimum: `postId` (or `postUrl`), `triggerKeyword`, `publicReply`, `dmBody`. Optional fields the API accepts include case sensitivity, max DMs per day, and expiry date.

Other actions on the same tool: `status` (read the monitor's state), `logs` (see recent triggers), `pause`, `resume`, `stop`, `delete`. Use them rather than spinning up a second monitor.

## 5. Validate

Suggest the user test it themselves: comment the keyword on the post from a second Instagram account and confirm both messages arrive. Then run `manage_autodms` with `action: "logs"` to confirm the trigger fired.

## 6. Monitor over time

After it is live:

- `manage_autodms` with `action: "status"` → current state and counters.
- `manage_autodms` with `action: "logs"` → list of triggers (who commented, when, what the DM contained).
- `list_dm_conversations` → broader view of all DMs the profile has sent, including manual ones.

Surface the unique-commenters count, not just total DMs sent — repeat commenters skew the headline number.

## Compliance

Instagram requires that the recipient has interacted with the account first (commenting counts). Do not promise the user 100% delivery — Instagram silently drops a fraction of automated DMs, especially to new accounts. Set the expectation upfront.
