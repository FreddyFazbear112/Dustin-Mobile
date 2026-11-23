# Dustin Mobile build notes

## Startup mod

The engine reads `mods/autoload.txt` during startup and switches directly to the mod named in that file. The configured mod ID is currently `Dustin`.

Place the extracted Dustin mod at `mods/Dustin/` (the folder must contain the mod's manifest and assets). The mod archive itself is not vendored in this repository yet, so the app cannot launch the actual mod until those files are added.

For iOS, the engine reads the mods directory from its app storage directory. For Android, it reads the external storage mods directory. Ensure the Dustin folder and `autoload.txt` are present in the corresponding writable mods directory on the device.

## Unsigned builds

The repository no longer references the sample `key.keystore` or its hardcoded credentials. Android release signing must be supplied separately by the build operator. iOS device installation still requires Apple code signing and provisioning; an unsigned iOS build is useful for build validation but cannot be installed directly on a normal iPhone.

## Stability focus

- Build release configurations for device testing; avoid debug builds for performance measurements.
- Keep mod assets external and load only what the engine needs.
- Test song transitions, pause/resume, background/foreground, low-memory warnings, and repeated restarts on physical devices.
- Verify all mod scripts and shaders against the mobile target before enabling them by default.
