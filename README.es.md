# Homepage Views Nautas

[![Discourse Theme](https://github.com/somos-criptonautas/discourse-homepage-views-nautas/actions/workflows/discourse-theme.yml/badge.svg)](https://github.com/somos-criptonautas/discourse-homepage-views-nautas/actions/workflows/discourse-theme.yml)

[ENGLISH](README.md) | **ESPAÑOL**

Componente de tema de Discourse para que cada persona elija cómo se abre la comunidad: **ligera** (Dumbcourse, solo texto), **moderna** (el foro) o **anonist** (chat IA). Pensado para la [app Android de Criptonautas](https://github.com/somos-criptonautas/comunidad-criptonautas-app), donde muestra «Elige tu vista» a pantalla completa la primera vez que se abre.

## Requisitos

- Discourse 2026.x.
- [discourse-phosphor-duotone-icons](https://github.com/somos-criptonautas/discourse-phosphor-duotone-icons) para los iconos de cada opción.
- Para *ligera*: Dumbcourse activado en [discourse-dumb-nautas](https://github.com/satonotdead/discourse-dumb-nautas).
- Para *anonist*: Discourse AI con la página de conversaciones del bot activada.

## Cómo funciona

- El selector aparece una vez, a pantalla completa, al abrir la comunidad por `/` sin haber elegido todavía. Con `view_chooser_app_only` (por defecto) solo en la app instalada (Android o PWA).
- Desde entonces, abrir por `/` lleva directo a la vista elegida. Solo `/` y una vez por carga: notificaciones, enlaces compartidos y otras páginas (`/latest`, `/custom`) se abren como siempre, y las portadas por grupo solo reciben a quien usa *moderna*.
- La elección se guarda por dispositivo, como las opciones de interfaz del núcleo. Se cambia en **Preferencias → Interfaz → Vista al abrir la comunidad** o abriendo `/?vista=elegir` (sirve también sin sesión y desde Dumbcourse).
- Los colores salen de la paleta activa, así que el modo claro y oscuro siguen al sitio. El logo es el logo pequeño del sitio.

## Ajustes

| Ajuste | Por defecto | Qué hace |
|---|---|---|
| `view_chooser_app_only` | `true` | Muestra el selector solo en la app instalada. Desactívalo para mostrarlo también en el navegador. |
| `view_ligera_url` | `/dumb` | Ruta de la vista *ligera*. Vacía oculta la opción. |
| `view_anonist_url` | `/discourse-ai/ai-bot/conversations` | Ruta de la vista *anonist*. Vacía oculta la opción. |

Los textos se traducen en **Admin → Apariencia → Temas → Homepage Views Nautas → Traducciones** (inglés y español incluidos).

## Desarrollo

```bash
pnpm install
pnpm lint
```

## Licencia

MIT
