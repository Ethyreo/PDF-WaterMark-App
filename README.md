# Ken's Banga Changa PDF Watermark Super App

A Flutter-based Android app with a retro 8-bit theme for batch watermarking PDFs. Built by Ken for Lovish.

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── screens/
│   ├── splash_screen.dart             # Startup splash ("Built by Ken for Lovish")
│   ├── home_screen.dart               # Main screen: Local Upload & G-Drive Scan
│   └── options_screen.dart            # Watermark source, output folder, naming conventions
├── services/
│   ├── watermark_service.dart         # Core PDF watermarking engine (Syncfusion)
│   ├── google_drive_service.dart      # Google Sign-In + Drive API file downloader
│   └── preferences_service.dart       # SharedPreferences for user settings
├── theme/
│   └── retro_theme.dart               # 8-bit retro color scheme, fonts, button styles
└── utils/
    └── sticky_audio_player.dart       # Sticky Play/Pause/Restart bar (just_audio)

assets/
└── audio/
    └── track.mp3                      # Single background track for the audio player

python_watermark_logic/                # Original Python watermarking scripts (reference)
├── watermark.py                       # Main batch watermarking script
├── convert_watermark.py               # PNG → PDF with 25% opacity
├── create_watermark.py                # Watermark PDF generator
├── download_all.py                    # Google Drive bulk downloader
├── download_missing.py                # Retry for failed downloads
├── watermark.pdf                      # The watermark overlay PDF
└── temp_transparent_watermark.png     # Transparent watermark PNG
```

## Features

- **Local PDF Upload:** Pick one or multiple PDFs from the device and batch watermark them.
- **Google Drive Integration:** Paste a Google Drive folder link, authenticate via Google Sign-In, and download + watermark all PDFs in the folder.
- **Custom Watermark:** Upload a watermark as either a PDF or an Image (PNG/JPG). Images are auto-scaled to 80% of page size and set to 25% opacity.
- **Output Folder Selection:** Choose where watermarked files are saved.
- **Naming Conventions:** Append custom text (e.g., `_Watermarked`) or use sequential naming (e.g., `File_001.pdf`).
- **Sticky Audio Player:** A persistent Play/Pause/Restart bar at the bottom playing `assets/audio/track.mp3`.
- **8-Bit Retro Theme:** Pixel fonts (Press Start 2P), neon green/magenta/cyan color palette, blocky UI.

## Dependencies

| Package | Purpose |
|---|---|
| `syncfusion_flutter_pdf` | PDF reading, watermark overlay, saving |
| `file_picker` | Local file/folder selection |
| `google_sign_in` + `googleapis` | Google Drive authentication and API |
| `just_audio` | Background music player |
| `google_fonts` | Retro pixel fonts |
| `shared_preferences` | Persisting user settings |
| `permission_handler` | Android storage permissions |

## How to Build the APK

```bash
# 1. Install dependencies
flutter pub get

# 2. Build the release APK
flutter build apk

# 3. Find the APK at:
#    build/app/outputs/flutter-apk/app-release.apk
```

## Python Reference Scripts

The `python_watermark_logic/` folder contains the original Python pipeline that was used to batch-watermark 176 PDFs from a Google Drive folder. These scripts are kept for reference and can be run independently with Python 3 + `pypdf`, `reportlab`, `Pillow`, and `tqdm`.
