---
name: repurpose-video
description: Turn a long video (talking head, podcast, livestream, webinar) into multiple viral short clips and schedule them to TikTok, Instagram Reels, and YouTube Shorts. Transcribe, find viral moments with AI, cut with FFmpeg, optionally add hook overlays, then schedule. Use when the user mentions repurposing, autoshorts, viral clips, making shorts, or cutting a long video into clips.
---

# Repurpose a long video into viral shorts

This is the autoshorts pipeline. It chains: transcribe → identify clips → cut → optional overlay → upload to short-form platforms.

## 1. Locate the source video

The FFmpeg tools need a public, directly downloadable HTTPS URL (or an Upload-Post media URL from a previous upload). A YouTube/Vimeo watch page is not a file URL. If the user only has a local file, ask them to share a direct download link first.

## 2. Transcribe

The Upload-Post MCP does not ship a transcription tool today. Two options:

- **The user already has a transcript** (YouTube captions, a Whisper export, an existing autoshorts run). Ask for it and skip to step 3.
- **No transcript yet**. Submit a `submit_ffmpeg_job` with `input_url` and a `full_command` that extracts the audio (e.g. `ffmpeg -y -i {input} -vn -ac 1 -b:a 64k {output}` with `output_filename: "audio.mp3"`), then run Whisper locally (or any transcription tool the user has). Do not promise transcription as part of the plugin — be honest that the user needs to bring it.

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

- `input_url` — public URL of the source video (or an Upload-Post media URL from a previous upload). Use `files` (array of URLs) instead only when the job needs several inputs.
- `full_command` — the explicit FFmpeg command. It must start with `ffmpeg` and use the placeholders `{input}` (or `{input0}`, `{input1}`… with `files`) and `{output}` instead of real filenames. Shell metacharacters (`;`, `|`, `&`, `$`, backticks) are rejected by the API. Example trim: `ffmpeg -y -ss 754 -to 801 -i {input} -c:v libx264 -c:a aac {output}`.
- `output_filename` — optional, e.g. `clip-1.mp4`; otherwise auto-named.

The call returns a `job_id`. Poll `get_ffmpeg_job` (`jobId`) until the status is `completed`, then `download_ffmpeg_result` (`jobId`) to get the download URL.

If the source is horizontal, do the trim and the 9:16 reframe in the same command rather than chaining jobs, e.g. add `-vf "crop=ih*9/16:ih,scale=1080:1920"`. Every job counts against the FFmpeg quota, so fewer passes is better.

## 5. Hook overlay (optional)

If the candidate has a strong hook line, generate a short overlay (large bold text, first 2–3 seconds) and burn it in with a `drawtext` filter (e.g. `drawtext=text='…':fontsize=72:x=(w-tw)/2:y=h*0.15:enable='lt(t,3)'`) — ideally in the same `full_command` as the cut. Skip this if the user is in a hurry.

## 6. Schedule

Hand the resulting clip URLs to the `schedule-campaign` skill (or call `upload_video` directly with `platforms: ["tiktok","instagram","youtube"]`). Stagger them — do not post 5 clips at once to the same account; use `addToQueue: true` to let Upload-Post space them.

## Limits and quota

FFmpeg processing is metered in minutes per month against the plan allowance. Call `get_ffmpeg_consumption` upfront to know how much budget you have. If `submit_ffmpeg_job` returns a quota error, surface the upgrade URL rather than retrying.
