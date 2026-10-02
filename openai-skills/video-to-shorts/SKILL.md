---
name: video-to-shorts
description: Repurpose a long video (podcast, interview, webinar, livestream, YouTube video) into short vertical clips for TikTok, Instagram Reels and YouTube Shorts - pick the best moments, cut and reframe them with Upload-Post's FFmpeg jobs, then schedule them across accounts. Use when the user wants to repurpose content, make shorts or clips from a long video, or turn one video into many posts. Do not use for editing that needs a full video editor (effects, multi-track timelines).
---

# Video to shorts

Pipeline: find moments → cut with FFmpeg → reframe to 9:16 → schedule.

## 1. Source and moments

The source must be a public HTTPS URL for the FFmpeg tools. If the user only has the file locally, ask them to share a link (cloud storage with a direct download link works).

Upload-Post does not transcribe. Pick moments from what the user gives you: a transcript with timestamps, YouTube chapters, or timestamps they choose. Good clips: a hook in the first 3 seconds, self-contained, 20–60 seconds. Propose 3–8 candidates with timestamps and a one-line summary; let the user approve before cutting.

## 2. Budget

Call `get_ffmpeg_consumption` first. Free plans have a limited number of FFmpeg jobs. If a job fails on quota, show the upgrade path instead of retrying.

## 3. Cut and reframe

For each approved clip call `submit_ffmpeg_job` with `input_url` and a `full_command` starting with `ffmpeg`, plus `output_filename` (e.g. `clip-1.mp4`). Do the trim and the 9:16 crop/scale in one command when the source is horizontal. Shell metacharacters are rejected.

Poll `get_ffmpeg_job` with the `job_id` until done, then `download_ffmpeg_result` for the clip URL.

## 4. Schedule

Publish each clip with `upload_video` (`videoPathOrUrl` = the clip URL) to `tiktok`, `instagram` (`instagramMediaType: REELS`) and `youtube`, with its own hook as the caption. Spread them out with `addToQueue: true` (see `content-calendar`) instead of posting them all at once.
