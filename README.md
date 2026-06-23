# Clark Vowels — portfolio site

A static site (HTML/CSS, no build step) designed to host for **$0** on Cloudflare Pages.

## How it's structured

```
clarkwebsite/
├─ public/                 ← THE ONLY THING THAT GETS DEPLOYED
│  ├─ *.html               site pages
│  ├─ _headers             Cloudflare cache rules
│  └─ assets/
│     ├─ loops/            short muted background videos (a few MB each)
│     ├─ photos/           compressed photos
│     ├─ lightbox.js       ← the YouTube ID for each film
│     └─ lightbox.css
├─ Videos/  Photos/  Thumbnails/   ← original masters. Local only, gitignored,
│                                     NEVER uploaded (9+ GB).
└─ scripts/build-media.ps1  re-compresses masters → public/assets
```

**Why it's cheap:** the full-length films are not hosted here. They live on YouTube
(unlisted) and play in a popup. Only short, muted background loops are self-hosted,
and they're tiny. The whole deployed site is ~9 MB instead of 9 GB.

## Linking films (already done — here's how to change them)

The 11 films are organized into three groups on the Projects and Freelance pages:
**Long Form**, **Short Form** (vertical Shorts), and **Passion & Personal**.

Each film's YouTube ID lives in one place — the `VIDEOS` map at the top of
`public/assets/lightbox.js`. To swap a video, replace its ID there (the part after
`v=` / `youtu.be/` / `shorts/` in the URL). Any film left blank shows a friendly
"not linked yet" note instead of breaking.

**Thumbnails are pulled automatically from YouTube** (`i.ytimg.com`), so they always
match the uploaded video — there are no thumbnail files to manage. If you change a
film, also update the two `i.ytimg.com/vi/<ID>/...` thumbnail URLs and the
`href`/`data-video` for that card in `projects.html` and `freelance.html`.

## Deploy to Cloudflare Pages (free)

**Option A — drag & drop (simplest):**
1. Go to <https://dash.cloudflare.com> → Workers & Pages → Create → Pages →
   *Upload assets*.
2. Drag the **`public`** folder in. Done — you get a `*.pages.dev` URL.
3. To update later, repeat the upload (or use Option B).

**Option B — Git (auto-deploys on every push):**
1. Push this repo to GitHub (the `.gitignore` already excludes the giant masters).
2. Cloudflare Pages → Create → connect the repo.
3. Build settings: **Build command:** *(leave blank)*,
   **Build output directory:** `public`.

Add a custom domain under the project's *Custom domains* tab when ready.

## Re-compressing media

If you change a photo or want different background-loop clips, edit the source files
in `Videos/`, `Photos/`, `Thumbnails/`, then run:

```powershell
./scripts/build-media.ps1
```

Loop in/out points live at the top of that script (`$Loops`) — tweak `start`/`dur`
and re-run. Requires `ffmpeg` on PATH (`winget install Gyan.FFmpeg`).

## Loose ends (content, not hosting)

These placeholders still exist in the HTML and should be filled in:
- `mailto:your.email@gonzaga.edu` (index, contact)
- `github.com/YOUR_USERNAME`, `linkedin.com/in/YOUR_HANDLE`,
  `instagram.com/YOUR_HANDLE` (index, contact)

The original site files at the repo root (`index.html`, etc.) are superseded by the
copies in `public/` and can be deleted once you've confirmed the new site looks right.
