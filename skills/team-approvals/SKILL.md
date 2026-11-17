---
name: team-approvals
description: Review and approve or reject posts that team members (Editors and Contributors) sent for approval, check team roles, members and the activity log, and set up webhook subscriptions for integrations. Use when the user asks what is waiting for approval, wants to approve, reject, edit or discard a member's post, asks who did what in the team, or wants an extra webhook destination for an integration such as n8n.
---

# Team approvals, roles and webhook subscriptions

Team roles, post approvals and webhook subscriptions are **not generally available yet**. Until they are switched on for the account, the approval tools answer `503 post_approvals_disabled` and the subscription tools `503 webhook_subscriptions_disabled`: the feature is off, not a temporary failure, so say so and stop.

## 1. Who can do what

`get_team_info` with `action: "roles"` returns whether roles and approvals are enabled, the role matrix and the caller's own role and profiles. Roles: `owner`, `admin` (everything), `editor` (posts go to approval), `contributor` (posts are saved as drafts), `viewer` (read only). While roles are off every member works as an admin.

- `action: "members"`: the owner's members with `status`, `role` and `profiles` (`null` = every profile).
- `action: "shared_with_me"`: accounts whose team the caller belongs to.
- `action: "audit"`: what members did, newest first (owner and admins only); filters `actor`, `audit_action`, `profile_username`, `target_id`, `since`, `until`, `limit`, `cursor`.

Inviting members and changing roles or profiles is done by the account owner in the dashboard (Team page). There is no tool for it: send the user there.

## 2. Review the queue

1. `list_pending_approvals` lists open posts (`pending_approval` from Editors, `draft` from Contributors), newest first. `count_only: true` only counts them. Filters: `status`, `profile_username`, `author`, `limit`, `before`; `approval_id` reads one with its preview.
2. Show the user the caption, platforms, profile, date and author of each post before deciding. Never approve on your own.
3. `approve_post` needs the `version` of the item as the user reviewed it. If someone edited it since, the call answers `409 approval_version_changed` with the current item: show the new version and ask again. Optional `comment`, `scheduled_date` + `timezone`, or `publish_now: true` (drafts need a date or `publish_now`).
4. `reject_post` needs a `comment` (the author sees it). `edit_pending_post` changes it while open (each edit bumps `version`); `withdraw_pending_post` discards it and deletes its media.
5. `409 approval_closed`: someone already decided it. `409 approval_expired`: its date passed and it will never be published.

An Editor's upload answers `pending_approval: true` with an `approval_id` instead of a job: it is not a failure, it is waiting for a reviewer.

## 3. Errors members may see

- `403 team_role_forbidden`: the role does not allow that action.
- `403 team_profile_forbidden`: the profile is not one of the member's.
- `403 team_page_not_pinned` / `team_page_forbidden`: on Facebook and LinkedIn a member limited to some profiles can only post to the Page pinned to that profile; the owner or an admin has to pin it.
- `403 team_approvals_disabled`: approvals are off, so Editors and Contributors cannot post yet.

## 4. Webhook subscriptions

Extra webhook destinations, each with its own events and optional profile, besides the account webhook (`manage_webhook_settings`).

- `create_webhook_subscription` (`url`: public `https`, `events`, optional `profile_username`, `source`, `name`). Idempotent: the same URL, events and profile return the existing one. At most 10 active per account (`409 subscription_limit_reached`).
- `list_webhook_subscriptions` (filters `status`, `source`, `url`; `subscription_id` reads one), `delete_webhook_subscription`, `test_webhook_subscription` (sends a sample now: confirm first).
- Deliveries carry the usual signature headers plus `X-Upload-Post-Subscription: <id>`; `list_webhook_deliveries` shows them.
- Approval events (`post_approval_requested`, `post_approved`, `post_rejected`, `post_approval_expired`) only arrive when listed.
