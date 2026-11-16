---
name: manage-channels
description: Change what is already live and run the accounts behind it — edit, repost or forward a published post; manage a Telegram chat and bot (members, invite links, topics, commands); read Bluesky profiles, search and notifications and keep Bluesky drafts; read Google Business posts, reviews and performance and edit the location info. Use when the user wants to fix a published post, reshare it, moderate a Telegram group or channel, look something up on Bluesky, or update their Google Business listing.
---

# Manage live posts and channels

These tools act on things that already exist: a post that is live, the Telegram chat the bot publishes in, the Bluesky account, the Google Business location. Read first, describe the change, get a yes, then write. Tools that change something public run in two steps: without `confirmed: true` they return `status: "confirmation_required"` and a preview; show it, then repeat with `confirmed: true`.

## 1. Edit, repost and act on a live post

- `edit_post` (`user`, `platform`, `post_id`, `text`): Facebook Page posts, LinkedIn, X (Premium, inside X's edit window; the post id changes), Google Business (`post_id` is the full `accounts/…/locations/…/localPosts/…` name; call to action, event and offer fields in `params`) and Telegram (`text` is the text or caption; `telegram_action`: `pin`, `unpin`, `stop_poll`, `edit_live_location`, `stop_live_location`; buttons with `telegram_reply_markup` in `params`). Instagram, TikTok and Threads posts cannot be edited.
- `repost_post`: LinkedIn (`commentary`, `target_linkedin_page_id`), X, Threads, and Telegram forward or copy (`mode`, `target_chat_id` or `target_user` for another profile's chat, `post_ids` for several messages, `all_messages` to include the caption rest and the first comment).
- `post_action`: Bluesky `bookmark` / `unbookmark`, `pin` / `unpin` on the profile, `reply_settings`, `quote_settings`, `detach_quote` / `reattach_quote`; Telegram `react` (one `emoji`) / `delete_reaction`.
- Deleting is `unpublish_post` (Telegram: `delete_all_messages: true` for every message of the post).

## 2. Telegram chat and bot

`manage_telegram_chat` and `manage_telegram_bot` take an `action` and a `params` object with the API's own field names. The bot needs the matching administrator right in the chat; a missing one answers `403 telegram_not_enough_rights`.

- Chat: `get_info` (members or subscribers, administrators), `update_info` (`title`, `description`, `permissions`…), `get_boosts`, `get_member` / `moderate_member` (`action`: `ban`, `unban`, `restrict`, `promote`, `demote`, `set_title`), invite links (`create_invite_link`, `edit_invite_link`, `revoke_invite_link`, `new_primary_invite_link`), `answer_join_request`, forum topics (`create_topic`, `edit_topic`, `delete_topic`), `unpin_all`, `leave_chat`.
- Bot: `get_profile` / `update_profile` (name, descriptions, menu button), `get_commands` / `set_commands` / `delete_commands`.
- Bans, promotions, revoking links, deleting topics and leaving the chat carry the API's `confirm: true`: set it only after the user said yes.

## 3. Bluesky

- `bluesky_read`: `profiles` (handles or DIDs, empty = the connected account), `search_posts` (needs the profile), `search_accounts`, `followers`, `follows`, `post_engagement` (who liked, reposted or quoted a post), `notifications`, `unread_count`, `labels`, `own_profile`, `settings`, `preferences`, `drafts`, and `xrpc` for allow-listed public Bluesky methods.
- `manage_bluesky_account`: `update_profile`, `set_status` / `clear_status`, `update_settings`, `update_preferences`, `mark_notifications_seen`, `update_notification_preferences`, `set_activity_subscription`, and drafts (`create_draft`, `update_draft`, `delete_draft` — text only; images and video are not kept in API drafts). Bluesky never publishes a draft by itself: to publish later, schedule the post.
- Likes, reposts, follows, lists and reports are not available through Upload-Post.

## 4. Google Business

- `google_business_read`: `list_posts`, `get_post`, reviews (`get_review`, `batch_reviews`; the existing review tools list and answer them), `performance` (daily metrics for a range), `search_keywords` (monthly), gallery (`list_media`, `get_media`, customer photos), `location_info`, `google_updates` (changes Google suggested), `list_locations`, `list_accounts`, catalogs (`categories`, `chains`), `available_attributes` / `attributes`, Place Action links, `food_menus`, `services`, `lodging`. `location_id` is optional: by default the location selected for the profile.
- `update_google_business_location` edits the listing. `edit_mode: "legacy"` (default) changes description, website, phone, hours and categories; `"strict"` can also change the business name, address, service area and open status, supports `dry_run` and needs `confirm` for name, address, primary category, phone and closing the business. `validate_only` works in both. Prefer a `dry_run` first and read back what will change: a wrong edit can send the listing to Google review.

## Handing off

- YouTube playlists, captions, comments, channel and live → `/upload-post:manage-youtube`.

- New content for any of these channels → `/upload-post:schedule-campaign`.
- Replying to comments or reviews → `/upload-post:manage-comments`.
- Numbers → `/upload-post:analyze-performance`.
