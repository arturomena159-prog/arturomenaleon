# Portfolio — Arturo Mena León

Sitio web portfolio personal. Archivo principal: `index.html`. Fotos en `Assets/img/analogue/`.

## Sobre el usuario
Arturo Mena León — profesional de audio con base en Londres. Sin conocimientos de programación. Me llama "Noa". Comunicación en español, informal.
Disciplinas: Dolby Atmos Mixer, Re-recording Mixer, Production Sound Mixer, Foley Artist, Baterista/Percusionista, Fotógrafo Analógico 35mm.

## Estructura del sitio (9 páginas, navegación horizontal deslizable)
| # | ID | Contenido |
|---|-----|-----------|
| 0 | page-home | Portada — nombre, roles, tagline |
| 1 | page-about | Sobre mí — bio + estadísticas |
| 2 | page-film | Cine — servicios de audio cinematográfico |
| 3 | page-atmos | Atmos — 3 players SoundToggle |
| 4 | page-mix | Mix & Master — servicios |
| 5 | page-music | Música — percusión y sesiones |
| 6 | page-photo | Fotografía — galería 8 fotos analógicas |
| 7 | page-projects | Proyectos — tabs Cine/Música con grid de portadas |
| 8 | page-contact | Contacto |

## Players SoundToggle (página Atmos)
Formato: `.player-item` con role + title encima, iframe height=150 scrolling=no, en fila flex-row. Sin caja/card alrededor.
- Crooks Inc — Let Go → `soundtoggle.io/ColMena159/let-go/export`
- Rene Antonio — 2022 → `soundtoggle.io/ColMena159/2022/export`
- Arni Montes — Dos noches raras → `soundtoggle.io/ColMena159/dos-noches-raras/export`

## muso.ai
URL: `https://credits.muso.ai/profile/1c1522a0-a27a-43f8-ae18-5fbcb6132e48`
No tiene embed — integrado como link en página Proyectos.

## Pendiente completar
- Portadas reales para grid de Proyectos (Cine: 8 slots, Música: 17 slots por rol: Atmos/Mix/Master)
- Embeds SoundToggle para Mix & Master (mezclas estéreo)
- Links reales de LinkedIn e Instagram en Contacto
- `href="mailto:..."` en Contacto todavía en placeholder

## Preferencias de diseño
- Menos es más: embeds compactos, sin cajas pesadas alrededor
- Organización por rol (no por género) en portfolios técnicos
- Explicaciones pedagógicas pero breves después de cada cambio
- Para añadir un player nuevo: copiar un `.player-item` y cambiar el `src=` del iframe
