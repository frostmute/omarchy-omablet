# Omablet for Omarchy

![Omablet preview](preview.png)

**Omablet** is a touch-first control panel for Omarchy tablets and 2-in-1 laptops running Hyprland. It provides display rotation and auto-rotate controls, synchronized touch and stylus digitizer mapping, quick access to **Omaqwerty** and **Omaglide**, and lock-screen controls.

## Features

- **Display & Touch Synchronization**: Rotates internal displays (`eDP`, `DSI`) while simultaneously keeping touchscreen and stylus inputs (`touchdevice:transform`, `tablet:transform`) properly aligned in all orientations.
- **Hyprland Compatibility**: Fully compatible with modern Hyprland Lua configurations (`hl.monitor`, `hl.config`) and legacy configurations.
- **Automatic Rotation**: Uses `iio-sensor-proxy` and accelerometer sensors to dynamically rotate the display as you turn your device.
- **Immediate Re-alignment**: Enabling auto-rotate immediately queries sensor state over DBus (`net.hadess.SensorProxy`) without requiring you to re-tilt the device.
- **Rotation Lock**: Manual rotation (left, right, upright) locks auto-rotation to avoid accidental orientation changes while reading or writing. You can also explicitly toggle rotation lock.
- **Companion Integration**: One-tap toggles for docked on-screen keyboard (**Omaqwerty**) and virtual pointer (**Omaglide**).

## Included Companions

- [Omaqwerty](https://github.com/frostmute/omarchy-omaqwerty) — docked touch keyboard
- [Omaglide](https://github.com/frostmute/omarchy-omaglide) — touch trackpad and virtual pointer

*Both companions are optional and can be installed independently.*

## Prerequisites

For automatic rotation based on hardware accelerometer sensors, ensure `iio-sensor-proxy` is installed and running:

```sh
omarchy pkg add iio-sensor-proxy
systemctl --user enable --now iio-sensor-proxy
```

Display and scale detection utilizes `jq`.

## Install

Install and enable the plugin with:

```sh
omarchy plugin add https://github.com/frostmute/omarchy-omablet.git --enable
```

If the bar widget does not immediately appear, restart the shell:

```sh
omarchy restart shell
```

## Usage

### Panel

- Click the **Omablet** icon (`󰍛`) in your status bar, or summon it with:
  ```sh
  omarchy-shell shell toggle io.github.frostmute.tablet-mode
  ```
- **Auto-rotate**: Enables sensor tracking and immediately rotates the display and touch inputs to the current physical orientation.
- **Lock rotation**: Locks the current orientation, ignoring accelerometer movements.
- **Rotate left / Rotate right / Upright**: Manually changes orientation (90° counter-clockwise, 90° clockwise, or normal 0°) and locks auto-rotation.
- **On-screen keyboard**: Toggles Omaqwerty / tablet keyboard.
- **On-screen trackpad**: Toggles Omaglide / onscreen trackpad.
- **Lock screen**: Locks the current session (`omarchy system lock`).

### CLI Backend

The rotation backend can also be triggered directly or bound to custom hardware buttons / keybindings:

```sh
# Set orientation manually (and locks auto-rotate)
tablet-mode normal      # Upright (0°)
tablet-mode right       # 90° clockwise
tablet-mode inverted    # 180° upside-down
tablet-mode left        # 270° clockwise (90° counter-clockwise)

# Toggle auto-rotation
tablet-mode auto        # Unlock and apply physical sensor orientation
tablet-mode lock        # Lock current rotation

# Accelerometer daemon (managed automatically by Omablet panel)
tablet-mode watch
```

## Remove

```sh
omarchy plugin remove io.github.frostmute.tablet-mode
```

## License

MIT
