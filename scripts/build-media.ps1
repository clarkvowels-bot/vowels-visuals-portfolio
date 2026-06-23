<#
  build-media.ps1
  -----------------------------------------------------------------------------
  Compresses the site's media from the original masters in /Videos, /Photos and
  /Thumbnails into web-optimized files under /public/assets.

  - Background LOOPS: short, muted, 720p H.264 clips (a few MB each) that the
    pages autoplay behind text. Full films are NOT self-hosted; they live on
    YouTube and are embedded (see the lightbox in the HTML).
  - PHOTOS: downscaled to max 2000px wide, metadata stripped.
  - THUMBNAILS: downscaled to max 800px wide.

  Re-run any time. It only reads the masters; it never modifies them.
  Requires ffmpeg on PATH (winget install Gyan.FFmpeg).

  Tweak the loop in/out points in $Loops below, then re-run.
#>

$ErrorActionPreference = 'Stop'
$root   = Split-Path -Parent $PSScriptRoot
$out    = Join-Path $root 'public\assets'
$vid    = Join-Path $root 'Videos'
$pho    = Join-Path $root 'Photos'

New-Item -ItemType Directory -Force -Path "$out\loops","$out\photos" | Out-Null

# NOTE: Video thumbnails are NOT generated here. The films live on YouTube and the
# Projects/Freelance pages pull thumbnails straight from i.ytimg.com, so they always
# match the uploaded video. Only background loops + photos are compressed locally.

function FF($arguments) {
  & ffmpeg -hide_banner -loglevel error -y @arguments
  if ($LASTEXITCODE -ne 0) { throw "ffmpeg failed: $($arguments -join ' ')" }
}

# ─── Background loops: source file, output slug, start time, duration ────────
$Loops = @(
  @{ src = 'SplashRevised.mp4';                                  slug = 'splash';            start = '00:00:00'; dur = 10 },
  @{ src = 'DB Reel Final.mp4';                                  slug = 'db-reel';           start = '00:00:01'; dur = 10 },
  @{ src = 'An Incomplete Memory of a High School Summer.mp4';   slug = 'incomplete-memory'; start = '00:00:05'; dur = 10 }
)

Write-Host "`n=== Encoding background loops ===" -ForegroundColor Cyan
foreach ($l in $Loops) {
  $in = Join-Path $vid $l.src
  if (-not (Test-Path $in)) { Write-Warning "missing: $($l.src)"; continue }
  $mp4 = Join-Path $out "loops\$($l.slug).mp4"
  $jpg = Join-Path $out "loops\$($l.slug).jpg"   # poster shown until the loop buffers
  Write-Host "  $($l.slug)  <-  $($l.src)"
  # -ss before -i = fast seek on big files. Scale-then-crop to a clean 1280x720, drop audio.
  FF @('-ss', $l.start, '-i', $in, '-t', "$($l.dur)", '-an',
       '-vf', 'scale=1280:720:force_original_aspect_ratio=increase,crop=1280:720',
       '-c:v', 'libx264', '-profile:v', 'high', '-pix_fmt', 'yuv420p',
       '-crf', '28', '-preset', 'slow', '-movflags', '+faststart', $mp4)
  FF @('-ss', $l.start, '-i', $in, '-frames:v', '1',
       '-vf', 'scale=1280:720:force_original_aspect_ratio=increase,crop=1280:720',
       '-q:v', '4', $jpg)
}

# ─── Photos: source file -> output slug ──────────────────────────────────────
$Photos = @(
  @{ src = 'Bike Jump.JPG';     slug = 'bike-jump'   },
  @{ src = 'Cool Rock.JPG';     slug = 'cool-rock'   },
  @{ src = 'FluffySheep.JPG';   slug = 'fluffy-sheep'},
  @{ src = 'Forest Photo.JPG';  slug = 'forest'      },
  @{ src = 'SkiPhoto.JPG';      slug = 'ski'         },
  @{ src = 'TightHeadshot.JPG'; slug = 'headshot'    },
  @{ src = 'Waterfall.JPG';     slug = 'waterfall'   },
  @{ src = 'WideShot.JPG';      slug = 'wide'        }
)

Write-Host "`n=== Compressing photos ===" -ForegroundColor Cyan
foreach ($p in $Photos) {
  $in = Join-Path $pho $p.src
  if (-not (Test-Path $in)) { Write-Warning "missing: $($p.src)"; continue }
  $jpg = Join-Path $out "photos\$($p.slug).jpg"
  Write-Host "  $($p.slug)  <-  $($p.src)"
  FF @('-i', $in, '-vf', "scale='min(2000,iw)':-2", '-map_metadata', '-1', '-q:v', '3', $jpg)
}

Write-Host "`nDone. Output in public\assets." -ForegroundColor Green
