---
description: Turn a long video (talking head, podcast, livestream, webinar) into multiple viral short clips and schedule them to TikTok, Instagram Reels, and YouTube Shorts. Transcribe, find viral moments with AI, cut with FFmpeg, optionally add hook overlays, then schedule. Use when the user mentions repurposing, autoshorts, viral clips, making shorts, or cutting a long video into clips.
---

# Repurpose a long video into viral shorts

This is the autoshorts pipeline. It chains: transcribe → identify clips → cut → optional overlay → upload to short-form platforms.

## 1. Locate the source video

Accept a local file path or a URL. If it is a YouTube/Vimeo URL the user wants pulled, ask whether to download first or hand the URL directly to the FFmpeg job tool if it accepts remote sources.

## 2. Transcribe

The Upload-Post MCP does not ship a transcription tool today. Two options:

- **The user already has a transcript** (YouTube captions, a Whisper export, an existing autoshorts run). Ask for it and skip to step 3.
- **No transcript yet**. Submit an `submit_ffmpeg_job` with `operation: "transcode"` to extract a `.mp3` of the audio, then run Whisper locally (or any transcription tool the user has). Do not promise transcription as part of the plugin — be honest that the user needs to bring it.

Save segment-level timestamps. You will need them to cut.

## 3. Identify clip candidates

Send the transcript (with timestamps) to the model and ask for viral moments. Good criteria:

- A hook in the first 3 seconds.
- Self-contained — works without the preceding context.
- 20–60 seconds long.
- Has a strong line worth a hook overlay.

Aim for 3–8 candidates. Present them to the user with timestamps and one-line summaries; let them approve before cutting.

## 4. Cut with FFmpeg

For each approved candidate, call `submit_ffmpeg_job`:

- `sourceUrl` — public URL of the source video (or an Upload-Post media URL from a previous upload).
- `operation: "trim"`
- `params: { start: <seconds>, end: <seconds> }`
- `outputFilename` — optional, otherwise auto-named.

The call returns a `job_id`. Poll `get_ffmpeg_job` until it reports done, then `download_ffmpeg_result` to fetch the URL.

If the source is horizontal, chain a second job with `operation: "transcode"` and crop/scale params to 9:16. Or do it in a single pass with `operation: "transcode"` plus a custom params object — check `get_ffmpeg_consumption` to budget jobs before running.

## 5. Hook overlay (optional)

If the candidate has a strong hook line, generate a short overlay (large bold text, first 2–3 seconds) and burn it in via a third FFmpeg pass using `operation: "watermark"`. Skip this if the user is in a hurry.

## 6. Schedule

Hand the resulting clip URLs to the `schedule-campaign` skill (or call `upload_video` directly with `platforms: ["tiktok","instagram","youtube"]`). Stagger them — do not post 5 clips at once to the same account; use `addToQueue: true` to let Upload-Post space them.

## Limits and quota

Free-plan users have a daily FFmpeg-job cap. Call `get_ffmpeg_consumption` upfront to know how much budget you have. If `submit_ffmpeg_job` returns a quota error, surface the upgrade URL rather than retrying.
