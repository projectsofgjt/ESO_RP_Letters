# ESO RP Letters

**ESO_RP_Letters** is an immersive roleplay addon for The Elder Scrolls Online that lets you load in-game letters from local `.md` (Markdown) files. Use it to simulate messages from allies, deliver quest clues, or introduce RP plot hooks—all without leaving the game.

## 🎯 Goals

- Let players create and import in-game letters from plain text or Markdown.
- Render those letters inside the ESO UI using the native book/letter textures.
- Help streamers and roleplayers add depth to their character journeys.
- Keep it modular and lightweight.

## 💡 How It Works (Planned)

1. You drop a Markdown file into a designated folder.
2. A small script converts it into ESO's `SavedVariables` format.
3. The addon displays those letters in-game via a hotkey or UI panel.

## 🧪 Status

**Planning phase** — actively developing the architecture and design.
Initial priorities:
- Markdown → SavedVariables converter.
- Lua addon skeleton and UI tab for letter browsing.
- Book-style display with support for paragraphs and quotes.
