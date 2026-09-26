# Homepage Views Nautas

[![Discourse Theme](https://github.com/somos-criptonautas/discourse-homepage-views-nautas/actions/workflows/discourse-theme.yml/badge.svg)](https://github.com/somos-criptonautas/discourse-homepage-views-nautas/actions/workflows/discourse-theme.yml)

**ENGLISH** | [ESPAÑOL](README.es.md)

Discourse theme component that lets each person choose how the community opens: **simple** (Dumbcourse, text only), **moderna** (the forum) or **anonist** (AI chat). Built for the [Criptonautas Android app](https://github.com/somos-criptonautas/comunidad-criptonautas-app), where it shows a full-screen "Elige tu vista" on first launch.

## Requirements

- Discourse 2026.x.
- [discourse-phosphor-duotone-icons](https://github.com/somos-criptonautas/discourse-phosphor-duotone-icons) for the option icons.
- For *simple*: Dumbcourse enabled in [discourse-dumb-nautas](https://github.com/satonotdead/discourse-dumb-nautas).
- For *anonist*: Discourse AI with the AI bot conversations page enabled.

## How it works

- The chooser shows once, full screen, when the community is opened at `/` and nothing was chosen yet. With `view_chooser_app_only` (default) only in the installed app (Android or PWA).
- After that, a launch at `/` goes straight to the chosen view. Only `/`, once per page load: notifications, shared links and other pages (`/latest`, `/custom`) open as usual, and group homepages only ever see *moderna* users.
- The choice is stored per device, like core's interface options. People change it in **Preferences → Interface → View when opening the community**, or by opening `/?vista=elegir` (also works for anonymous visitors and from Dumbcourse).
- Colours come from the active palette, so light and dark follow the site. The logo is the site's small logo.

## Settings

| Setting | Default | What it does |
|---|---|---|
| `view_chooser_app_only` | `true` | Show the chooser only in the installed app. Turn off to show it in the browser too. |
| `view_simple_url` | `/dumb` | Path of the *simple* view. Empty hides the option. |
| `view_anonist_url` | `/discourse-ai/ai-bot/conversations` | Path of the *anonist* view. Empty hides the option. |

Copy is translatable from **Admin → Appearance → Themes → Homepage Views Nautas → Translations** (English and Spanish included).

## Development

```bash
pnpm install
pnpm lint
```

## License

MIT
