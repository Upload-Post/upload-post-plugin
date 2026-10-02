---
name: reply-to-comments
description: Read, reply to, and moderate comments on Instagram, TikTok, YouTube, Facebook, LinkedIn, X, Threads and Bluesky posts, send Instagram DMs to commenters, and reply to Google Business Profile reviews through Upload-Post. Use when the user asks about comments, wants to answer or hide comments, clean up spam, engage with their audience, or respond to reviews. For automatic keyword-triggered DMs use instagram-auto-dm.
---

# Reply to comments and reviews

## 1. Find the post

Comment tools take `user`, `platform`, and the post as `postId` or `postUrl`. YouTube `postId` is the video id; LinkedIn is the post urn; TikTok needs `postId` (the video id), not a URL. If the user does not have it, `get_media` lists recent posts on the account and `get_history` lists what went out through Upload-Post.

## 2. Read and triage

`get_post_comments` (up to 50 per page, `after` to page; pass `commentId` to read replies). Do not paste the raw list. Group it: questions (answer first), buying signals ("price?", "link?"), praise, spam.

## 3. Reply

- Reply or top-level comment on any supported network: `create_comment` with `message` and exactly one of `commentId` (reply), `postId`, or `postUrl`. Instagram accepts replies only (`commentId`). TikTok always needs `postId`, plus `commentId` to reply in a thread.
- Public reply under an Instagram comment: `public_reply_to_comment`.
- Private DM to an Instagram commenter: `reply_to_comment` (only within Instagram's 7-day window; up to 3 link `buttons`).

Draft replies in the user's own voice and get approval before sending; they are public.

## 4. Moderate

- Reversible: `comment_action` (`hide`/`unhide`, `like`, `pin` on TikTok, `edit` on Facebook, `hold` on YouTube, `approve`/`ignore` on Threads, `enable_comments`/`disable_comments` on an Instagram post).
- Permanent: `delete_comment` (not on Threads; LinkedIn also needs `postId`). Show the exact comments first and confirm; never delete on a vague "clean up the spam".

## Google Business reviews

`get_google_business_locations` → `get_google_business_reviews` (keep each `review_name`) → `reply_to_google_business_review`. It creates or overwrites the owner reply, so check for an existing one. For low ratings, acknowledge the specific issue and get approval before sending.
