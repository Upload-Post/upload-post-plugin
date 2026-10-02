---
name: manage-comments
description: Read, reply to and moderate comments on published posts across Instagram, Facebook, YouTube, LinkedIn, TikTok, X, Threads and Bluesky, and reply to Google Business reviews. Use when the user asks about comments, replies, engagement in the comment section, moderating or deleting a comment, or answering a Google Business review.
---

# Work the comment section

Replying is where reach turns into relationships. This skill covers the read → triage → reply loop on published content. For *automated* keyword-triggered DMs, use `/upload-post:autodm-setup` instead.

## 1. Find the post

Comment tools identify a post by either `postId` or `postUrl`. Platform quirks:

- **YouTube**: `postId` is the videoId.
- **LinkedIn**: `postId` is the post urn.
- **TikTok**: `postId` is the video id and is always required — `postUrl` is not accepted. TikTok comment tools also need the `comments` capability on the profile's TikTok account (check the `capabilities` array in `list_users`). It is granted at connection time, so an account connected before that has to reconnect TikTok first; say so plainly rather than retrying.

If the user does not have the id, `get_media` lists recent posts pulled from the connected account, and `get_history` lists what was published through Upload-Post.

## 2. Read

`get_post_comments` with `user`, `platform` (instagram / facebook / youtube / linkedin / tiktok / x / threads / bluesky; defaults to instagram), and the post identifier. `limit` caps at 50 — Meta's and TikTok's ceiling, not ours — and `after` pages through the rest. Add `commentId` to read the replies under one comment instead of the top-level comments.

Do not paste the raw list back. Triage it:

- **Questions** — deserve an answer, highest priority.
- **Buying signals** — "how much", "link?", "where do I get this". These are leads; consider a private reply.
- **Praise** — a short human reply, or nothing.
- **Spam / abuse** — candidates for deletion.

## 3. Reply

Three different tools, and picking the wrong one is the main failure mode here:

| Intent | Tool | Notes |
| :--- | :--- | :--- |
| Public reply under an existing comment | `public_reply_to_comment` | `user`, `commentId`, `message`. Instagram only. |
| Private DM to the person who commented | `reply_to_comment` | `user`, `commentId`, `message`. Instagram only, and **only within Instagram's 7-day reply window** — after that the API rejects it. |
| Top-level comment, or any reply on Facebook / YouTube / LinkedIn / TikTok / X / Threads / Bluesky | `create_comment` | Provide exactly ONE of `commentId` (reply), `postId`, or `postUrl` (top-level). Instagram accepts replies only, so an Instagram call must pass `commentId`. TikTok always needs `postId` (the video id), plus `commentId` on top of it to reply inside a thread. |

Draft replies in the user's own voice — match the tone of their existing captions rather than defaulting to brand-manager English. Show the drafts and get approval before sending a batch; these are public and irreversible.

## 4. Moderate

Reversible first: `comment_action` takes `user`, `platform`, `action`, and usually `commentId` (+ `postId` where noted). Every action has an inverse, so prefer it over deleting:

- **TikTok**: `hide`/`unhide`, `pin`/`unpin` (with `postId`), `like`/`unlike` (no `postId`).
- **Facebook**: `hide`/`unhide`, `like`/`unlike`, `edit` (with `message`).
- **Instagram**: `hide`/`unhide` a comment, or `enable_comments`/`disable_comments` on a post (`postId`, no `commentId`).
- **YouTube**: `hide`/`unhide`/`hold` (with `postId`; `banAuthor` only with `hide`).
- **Threads**: `hide`/`unhide`, `approve`/`ignore`.

Permanent: `delete_comment` takes `user`, `platform` (instagram / facebook / youtube / linkedin / tiktok / x / bluesky — Threads cannot delete comments), `commentId`, and on LinkedIn also `postId` (the post urn). It is destructive and cannot be undone — always confirm the specific comment text with the user first, never delete on a general instruction like "clean up the spam" without listing what you are about to remove.

## Google Business reviews

Separate surface, same loop:

- `get_google_business_locations` → pick the location id.
- `get_google_business_reviews` → read them. **Keep the `review_name`** from each result (the full `accounts/.../locations/.../reviews/{id}` path) — you need it to reply.
- `reply_to_google_business_review` → `user`, `comment`, and either that `review_name` or `review_id` + `location_id`. It creates *or overwrites* the existing owner reply, so check whether one is already there before sending.

Review replies are public and heavily weighted by local search. For anything below 3 stars, draft a reply that acknowledges the specific complaint, states what changes, and moves the conversation off-platform — then have the user approve it before sending.

## Handing off

- Recurring keyword → DM automation instead of manual replies → `/upload-post:autodm-setup`.
- Comment volume worth measuring → `/upload-post:analyze-performance`.
