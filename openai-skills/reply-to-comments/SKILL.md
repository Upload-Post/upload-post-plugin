---
name: reply-to-comments
description: Read, reply to, and moderate comments on Instagram, TikTok, YouTube, Facebook, LinkedIn, X, Threads and Bluesky posts, read the replies under a comment, read and send Instagram and Bluesky DMs, and reply to Google Business Profile reviews through Upload-Post. Use when the user asks about comments, wants to answer or hide comments, clean up spam, engage with their audience, or respond to reviews. For automatic keyword-triggered DMs use instagram-auto-dm.
---

# Reply to comments and reviews

## 1. Find the post

Comment tools take `user`, `platform`, and the post as `postId` or `postUrl`. YouTube `postId` is the video id; LinkedIn is the post urn; TikTok needs `postId` (the video id), not a URL. If the user does not have it, `get_media` lists recent posts on the account and `get_history` lists what went out through Upload-Post.

## 2. Read and triage

`get_post_comments` (up to 50 per page, `after` to page; pass `commentId` to read the replies under a comment on Instagram, Facebook, LinkedIn Page posts, TikTok, Threads or YouTube; X and Bluesky do not support it). Facebook: keep `postId` as `{page_id}_{post_id}`. LinkedIn: pass the comment's `comment_urn`. Check the replies before answering so the account does not reply twice. Do not paste the raw list. Group it: questions (answer first), buying signals ("price?", "link?"), praise, spam.

## 3. Reply

- Reply or top-level comment on any supported network: `create_comment` with `message` and exactly one of `commentId` (reply), `postId`, or `postUrl`. Instagram accepts replies only (`commentId`). TikTok always needs `postId`, plus `commentId` to reply in a thread.
- Public reply under an Instagram comment: `public_reply_to_comment`.
- Private DM to an Instagram commenter: `reply_to_comment` (only within Instagram's 7-day window; up to 3 link `buttons`).

Draft replies in the user's own voice and get approval before sending; they are public.

## 4. Moderate

- Reversible: `comment_action` (`hide`/`unhide`, `like`, `pin` on TikTok, `edit` on Facebook, `hold` on YouTube, `approve`/`ignore` on Threads, `enable_comments`/`disable_comments` on an Instagram post).
- Permanent: `delete_comment` (not on Threads; LinkedIn also needs `postId`). Show the exact comments first and confirm; never delete on a vague "clean up the spam".

## Direct messages (Instagram, Bluesky)

- `list_dm_conversations` with `user` and `platform` (`instagram` or `bluesky`); Bluesky also takes `conversation_id`, `messages_cursor`, `status` (`request`/`accepted`) and `read_state: "unread"`.
- `send_dm` with `user`, `platform`, `recipient_id`, `message`. Bluesky: `recipient_id` is a handle, DID or profile link (or pass `conversation_id`), up to 1000 characters, optional `reply_to` and one shared post in `attachments`; `sender_action` for `mark_read`, `react`/`unreact` (one emoji), `delete`, `accept`, `mute`, `unmute`, `leave`.
- Bluesky needs an app password created with "Allow access to your direct messages": on `403 bluesky_dm_scope_missing` tell the user to create one and reconnect Bluesky. On `504 bluesky_send_unconfirmed` read the conversation before sending again.

Show the DM text and get approval before sending.

## Google Business reviews

`get_google_business_locations` → `get_google_business_reviews` (keep each `review_name`) → `reply_to_google_business_review`. It creates or overwrites the owner reply, so check for an existing one. For low ratings, acknowledge the specific issue and get approval before sending.
