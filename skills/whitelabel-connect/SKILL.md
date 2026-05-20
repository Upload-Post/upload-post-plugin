---
description: Generate a JWT-authenticated connection URL so a client or end-user can OAuth their social accounts into a profile inside YOUR Upload-Post workspace. For white-label integrations, SaaS embeds and agency client onboarding. NOT for connecting your own accounts — for that, send the user to https://app.upload-post.com/manage-users in their browser.
---

# Generate a white-label connection link

Use this skill when you operate a SaaS, agency or platform that wants end-users (your clients) to connect their social accounts to a profile inside your Upload-Post workspace. They run the OAuth themselves; the connected account ends up under a profile you administer.

## When NOT to use this

If the user wants to connect **their own** social accounts to **their own** Upload-Post workspace, stop. They do not need a JWT flow. Direct them to:

```
https://app.upload-post.com/manage-users
```

Create a profile, click the platform, accept the OAuth prompt. A couple of clicks per network and they're connected. Faster, no code, no link to pass around.

## When to use this

- You run an agency and want each client to connect their own Instagram / TikTok / YouTube to a profile inside your account.
- You have a SaaS product embedding Upload-Post and need to hand users a connection URL.
- You are onboarding a partner who should never see your API key.

## Workflow

### 1. Pick or create the profile

Each connected account belongs to a profile (a `username` value inside your workspace). If the client does not have a profile yet, create one with `create_user`. Tell them this is the bucket their connected accounts will live in.

### 2. Generate the URL

Call `generate_jwt` with:

- `username` — the profile name (the bucket).
- `platforms` — array of platforms the user should be allowed to connect; defaults to all.
- `redirectUrl` — where to send the client after they finish OAuth.
- Optional: `logoImage`, `connectTitle`, `connectDescription` — branded copy on the connect page.
- Optional: `showCalendar`, `readonlyCalendar` — embed the scheduler view too.

The tool returns a one-time URL.

### 3. Hand the URL to the client

Pass the link by email, Slack, in your product UI — however you onboard. They open it, pick the platform, complete the platform's native OAuth, and end up at your `redirectUrl`.

### 4. Verify

Call `list_users` and inspect the client's profile in `social_accounts`. The platform should have a non-empty entry with `handle` and `display_name`. If `reauth_required: true` shows up later, the token expired — generate a fresh JWT URL and resend.

## Bulk onboarding

If you are onboarding many clients at once, batch the calls: one `create_user` + one `generate_jwt` per client. Store the URLs in your own system and send them out. There is no built-in mass-mailer in Upload-Post — that is on your side.
