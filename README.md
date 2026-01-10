# py_imagedetector | made by Python (dc: python.gg)

## Overview

**py_imagedetector** is a server-side FiveM resource that scans **ox_inventory** for missing and unused item images.  
It provides a fast and reliable way to ensure your inventory setup is clean and all items display correctly in the UI.

**Note:**

- This script is intended for debugging purposes only and should be used by developers or server owners with full access to a localhost or Windows server. If you do not meet these requirements or do not intend to use the script, set `Config.Enabled` to false.
- This script currently only supports **ox_inventory** and requires **ox_lib** for proper resource handling. Make sure these dependencies are installed and running.
- The script reads items from both `items.lua` and `weapons.lua`, including Weapons, Components, and Ammo categories.

The script automatically compares:

- All items registered in ox_inventory (including weapons, components, and ammo)
- All image files in the inventory image folder

It then reports:

- Items that do not have a corresponding image
- Images that are not associated with any item

All results are logged clearly in the server console.

---

## Features

- Case-insensitive item-to-image matching (e.g., `WEAPON_ASSAULTRIFLE` matches `weapon_assaultrifle.png`) (configurable via `Config.CaseSensitive`)
- Detects missing images for inventory items
- Detects unused images that are not linked to any item
- Supports items, weapons, components, and ammo
- Lightweight and server-side only
- Clean, structured console output with summary

---

## How It Works

1. Waits briefly after the resource starts to ensure **ox_inventory** is fully loaded.
2. Reads all items via `items.lua` and `weapons.lua` (Weapons, Components, Ammo).
3. Scans the inventory image folder for `.png` files.
4. Compares items and images (case-insensitive if `Config.CaseSensitive = false`).
5. Logs missing items, unused images, and a summary in the console.

No client-side code is used.

---

## Dependencies

- **ox_inventory**
- **ox_lib** (for proper resource path handling and events)

Ensure both resources are installed and running before using py_imagedetector.

---

## Installation

1. Place the `py_imagedetector` folder in your server’s `resources` directory.
2. Add the following lines in order to your `server.cfg` if you haven't already:

```cfg
ensure ox_lib
ensure ox_inventory
ensure py_imagedetector
```

3. Start your server. The image scan will run automatically on resource start.
