import os
import re
from pathlib import Path


VIDEO_FILES = [
    r"Videos\ARD 44 Vertical #1.mp4",
    r"Videos\CostaRicaEdit2026.mp4",
    r"Videos\DB Reel Final.mp4",
    r"Videos\Dream Build Main Final.mp4",
    r"Videos\Jazz.mp4",
    r"Videos\Singin in the grass.mp4",
    r"Videos\SplashRevised.mp4",
    r"Videos\Yankaaz.mp4",
    r"Videos\An Incomplete Memory of a High School Summer.mp4",
]


def slugify_filename(name: str) -> str:
    name = name.strip()
    name = re.sub(r"\.mp4$", "", name, flags=re.IGNORECASE)
    name = re.sub(r"[^\w\s-]+", "", name)
    name = re.sub(r"[\s_-]+", "-", name).strip("-").lower()
    return name or "video"


def main() -> int:
    try:
        import imageio
    except Exception as e:
        raise SystemExit(
            "Missing dependency. Run:\n"
            "  python -m pip install --upgrade imageio[ffmpeg]\n"
        ) from e

    root = Path(__file__).resolve().parent
    out_dir = root / "Photos" / "video-thumbs"
    out_dir.mkdir(parents=True, exist_ok=True)

    for rel in VIDEO_FILES:
        src = root / rel
        if not src.exists():
            print(f"SKIP (missing): {src}")
            continue

        out_name = slugify_filename(src.name) + ".jpg"
        out_path = out_dir / out_name

        reader = None
        try:
            reader = imageio.get_reader(str(src), "ffmpeg")
            meta = reader.get_meta_data()
            fps = float(meta.get("fps") or 30.0)
            frame_index = int(round(0.75 * fps))
            frame_index = max(0, frame_index)
            frame = reader.get_data(frame_index)
        finally:
            if reader is not None:
                try:
                    reader.close()
                except Exception:
                    pass

        imageio.imwrite(str(out_path), frame, quality=85)
        print(f"WROTE: {out_path}")

    print(f"\nDone. Thumbnails in: {out_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

