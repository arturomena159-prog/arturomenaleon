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

## Imágenes del proyecto (Assets/img/)
- `analogue film photo/` — 8 fotos analógicas para galería (página Fotografía)
- `album covers/` — 15 portadas de álbumes para grid de Proyectos/Música
- `film posters/` — 3 posters para grid de Proyectos/Cine

### Grid Proyectos — Cine (5 películas, orden en el grid: SAVI, Ode to Rose, Red Envelope, Green With Envy, The Suicide)
| Archivo | Título | Rol |
|---------|--------|-----|
| Green With Envy Poster.jpg | Green With Envy | Production Sound Mixer |
| SAVI Poster.jpg | SAVI | Foley Mixer & Editor |
| The suicide Poster.jpeg | The Suicide | Sound & Production Assistant |
| ode-to-rose-poster.jpg | Ode to Rose | Production Sound Mixer |
| red-envelope-poster.jpg | Red Envelope | Re-recording Mixer |

### Grid Proyectos — Música (15 álbumes)
| Archivo | Artista — Álbum | Rol | Tab |
|---------|-----------------|-----|-----|
| Adan Cruz Adanxito.jpg | Adan Cruz — Adanxito | Dolby Atmos Engineer | atmos |
| Adan Cruz Adrian Marcelo.jpg | Adan Cruz — Adrián Marcelo | Dolby Atmos Engineer | atmos |
| Miss Blanche Devuelveme a mi Chica.jpg | Miss Blanche — Devuélveme a mi Chica | Dolby Atmos Mixing | atmos |
| Rene Antonio 2024.jpg | Rene Antonio — 2024 | Dolby Atmos Mixing | atmos |
| Sultan El Inicio.jpg | Sultan — El Inicio | Dolby Atmos & Stereo Mix | atmos |
| Nate Skies Make it Out.jpg | Nate Skies — Make It Out | Mixing & Mastering | mix |
| Nate Skies Scarz.jpg | Nate Skies — Scarz | Mixing & Mastering | mix |
| Marly Marly Lo Siento Pero no lo Siento.jpg | Marly — Lo Siento Pero No Lo Siento | Stereo Mix | mix |
| Luis Fernando Donde Estas Amor.jpg | Luis Fernando — Donde Estás Amor | Recording & Mixing | mix |
| Adan Cruz Aja.jpg | Adan Cruz — Aja | Mixing & Recording | mix |
| Adan Cruz Otro Destino.jpg | Adan Cruz — Otro Destino | Assistant Recording | assistant |
| Aleman El Terre.jpg | Alemán — El Terre | Assistant Recording | assistant |
| Gran Silencio Mexico Sabroso.jpg | Gran Silencio — México Sabroso | Assistant Recording | assistant |
| Javie Lopez Clasicos en Vivo.jpg | Javier López — Clásicos en Vivo | Assistant Recording | assistant |
| Marly Marly Arigato.jpg | Marly — Arigato | Assistant Recording | assistant |

Los tabs de música son: Todos / Dolby Atmos (`data-role="atmos"`) / Mezcla (`data-role="mix"`) / Asistente (`data-role="assistant"`)

## Palette y diseño
- `--bg: #1d2b36` — slate-oceánico cinematic. No negro puro (muy oscuro), no azul claro (ilegible).
- Body tiene radial-gradient sutil para evitar azul sólido
- Home page usa spacer div + `flex-direction: column` (sin `justify-content: flex-end` — causaba que el nombre se recortara)
- Usar **"Dolby Atmos Mixing"** (nunca "Immersive Mixing") — término correcto en la industria
- Organizar portfolio musical **por rol** (Atmos / Mezcla / Asistente), no por género

## Fotos personales (Assets/img/On Set/)
- `headshot-gear.jpeg` — close-up trabajando con cables, oscuro, dramático. Usado en Sobre mí.
- `boom-greenhouse.jpeg` — Arturo sonriendo con boom en invernadero. Usado en Cine.
- `clap-greenhouse-1/2.jpeg`, `set-field-crew.jpeg`, `set-boom-wide.jpeg`, `set-greenhouse-1/2.jpeg` — fotos de rodaje extra
- `set-video.mp4` — video de set (no integrado aún)

## Work Photo Frame (.work-photo)
Para integrar fotos al diseño sin que "floten": border fino + caption label abajo.
```html
<div class="work-photo">
  <img src="ruta/foto.jpg" alt="descripción">
  <p class="work-photo-caption">Etiqueta corta</p>
</div>
```
Hover: border turquesa + imagen a color completo. Usar para cualquier foto de trabajo nueva.

## Fondo dinámico animado
- `.bg-shift-1` y `.bg-shift-2`: overlays de color que hacen fade suave (32s/44s, desfasados)
- `.bg-blob-1/2/3`: blobs turquesa con trayectorias independientes (38s/52s/44s)
- Todos usan opacity animation para máxima suavidad (GPU composited, sin stepped)
- Los divs van justo después de `<body>`, antes de `<div id="app">`

## Pendiente completar
- Embeds SoundToggle para Mix & Master (mezclas estéreo)
- Links reales de LinkedIn e Instagram en Contacto
- Headshot profesional para reemplazar headshot-gear.jpeg en Sobre mí

## Preferencias de diseño
- Menos es más: embeds compactos, sin cajas pesadas alrededor
- Explicaciones pedagógicas pero breves después de cada cambio
- Para añadir un player nuevo: copiar un `.player-item` y cambiar el `src=` del iframe
- Para añadir portada al grid: copiar un `.cover-slot` o `.poster-slot`, cambiar el `style="background-image:url(...)"` y el texto del overlay
- Para fotos de trabajo: usar siempre `.work-photo` con caption para que se integren al diseño
