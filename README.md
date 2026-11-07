# HAMA VIP Overlay

A minimal Theos tweak starter that displays a **static, non-interactive image overlay**.
It does not read or modify game memory, automate input, change gameplay, or bypass anti-cheat.

## Add your image
1. Put your PNG in `layout/` and name it `HAMAOverlay.png`.
2. The package resource path expected by the source is `/Library/Application Support/HAMAOverlay/HAMAOverlay.png`.
3. Add the resource staging rule for your image in the Makefile before building:
   `HAMAOverlay_INSTALL_PATH = /Library/Application Support/HAMAOverlay`
   `HAMAOverlay_FILES` is for source files; use a Theos resource variable/rule appropriate to your installed Theos version.

## Build
Push to `main` or run **Actions → Build HAMA VIP Overlay → Run workflow**.
The Debian package is uploaded as a workflow artifact.

## Notes
- This is a starter template, not a tested release.
- Target bundle IDs can vary by region/version and must be verified on the device.
- Overlay placement is an initial proportional estimate in `main.mm`; adjust `x`, `y`, and `imageWidth` to match your screen/reference.
- Requires a compatible jailbroken test device and tweak injection environment.
- Use only where permitted by the app/game terms. No anti-cheat bypass is included.
