# PROYECTO: Comparador A/B de Mezclas — "AB Tool"
## Brief completo para Claude Code

---

## CONTEXTO

Soy Arturo Mena León, ingeniero de audio en Londres (re-recording mixer, Atmos, production sound). Tengo un portafolio en **arturomenaleon.com** (HTML/CSS/JS vanilla, deploy vía GitHub + Netlify, desarrollado en VS Code con Claude Code).

Quiero construir mi propia herramienta de comparación A/B de mezclas para reemplazar SoundToggle: páginas donde mis clientes escuchen la maqueta original contra mi mezcla, con cambio instantáneo y sincronía a nivel de muestra, todo bajo mi dominio y mi marca.

**Ya existe un prototipo funcional** del comparador (archivo `ab-player.html` incluido en este proyecto): Web Audio API, dos buffers reproduciéndose simultáneamente, toggle por crossfade de ganancias de 4 ms, waveform en canvas, seek, atajos de teclado, paleta "glacial mist" (`#E9EDEC` → `#2A3A3E`, acento `#46605C`). Úsalo como base — no partir de cero.

---

## MODO MASTERCLASS (importante)

No quiero solo el código: quiero aprender mientras se construye. En cada sesión:

- Antes de escribir un bloque significativo, explícame **qué** vamos a hacer y **por qué** esa es la mejor forma (alternativas descartadas incluidas).
- Después de escribirlo, camina conmigo por las partes clave: la lógica del Web Audio API, el manejo de estado, el schema del manifest, los comandos de terminal que uses (git, wrangler, npm) y qué hace cada uno.
- Usa analogías de audio cuando apliquen — soy ingeniero de sonido, no programador. Piensa en gain staging, buses, routing, sesiones de Pro Tools.
- Si tomo una mala decisión técnica, dímelo directo. Prefiero honestidad brutal a diplomacia.
- Español mexicano casual está perfecto para las explicaciones.

---

## STACK (decidido, no cambiar sin justificación fuerte)

| Capa | Herramienta | Costo |
|---|---|---|
| Frontend | HTML/CSS/JS vanilla (consistente con mi sitio actual) | $0 |
| Hosting páginas | Netlify (ya lo uso) | $0 |
| Hosting audio | Cloudflare R2, subdominio `audio.arturomenaleon.com` | $0 hasta 10 GB |
| Formato de audio | **FLAC** para comparación (lossless, ~50% del peso de WAV). WAV solo como descarga de entrega final. Nada de MP3 en el comparador. | — |
| Comentarios (Fase 4) | Supabase (Postgres + API REST, tier gratuito) | $0 |
| Repo | GitHub | $0 |

---

## ARQUITECTURA GENERAL

Cada proyecto de cliente es una carpeta estática con URL no adivinable:

```
arturomenaleon.com/abtool/{slug-aleatorio}/ ← página del proyecto (comparador privado)
arturomenaleon.com/portfolio/               ← galería pública (Fase 3)
audio.arturomenaleon.com/{proyecto}/...     ← FLACs en R2
```

Cada proyecto se define con un **`manifest.json`** — la única fuente de verdad. La página del comparador es una plantilla única que lee el manifest. Schema propuesto (ajustable):

```json
{
  "id": "sultan-x7k2",
  "title": "Sultán",
  "artist": "Vicko Solís",
  "genre": "indie",
  "status": "in_progress",        // in_progress | approved
  "approved_version": null,        // p.ej. "1.4" cuando se apruebe
  "public": false,                 // ¿aparece en la galería?
  "reference": {
    "label": "Maqueta",
    "file": "https://audio.arturomenaleon.com/sultan-x7k2/maqueta.flac"
  },
  "versions": [
    { "v": "1.0", "date": "2026-07-10", "notes": "Primera pasada", "file": "...v1-0.flac" },
    { "v": "1.1", "date": "2026-07-14", "notes": "Bajo -2dB, vocal rider", "file": "...v1-1.flac" }
  ]
}
```

---

## FASES

### FASE 1 — Comparador con sistema de versiones
- Partir del prototipo `ab-player.html`.
- **A siempre es la referencia (maqueta). B es seleccionable** entre todas las versiones vía dropdown o selector.
- Cambiar de versión en B carga el FLAC nuevo, manteniendo posición de reproducción si es posible.
- La página lee todo del `manifest.json` (título, artista, versiones, notas de cada versión con fecha).
- Retrospectiva: el cliente (o yo) puede comparar maqueta vs 1.1, vs 1.2, vs 1.3... para ver cómo evolucionó la mezcla.
- Eliminar una versión = borrar su línea del manifest + borrar el FLAC de R2 (documentar el comando de wrangler para esto). Versiones con cambios insignificantes se purgan para no consumir almacenamiento.
- Generador de proyectos: un script (Node o bash) que pida título/artista, genere slug aleatorio, cree la carpeta con manifest vacío y me dé los comandos para subir audio a R2.

### FASE 2 — Aprobación y sellado
- Cuando el cliente aprueba, yo edito el manifest: `status: "approved"`, `approved_version: "1.4"`.
- La página en estado aprobado se **sella**: muestra un banner de "Mezcla aprobada — v1.4", el selector B queda por defecto en la versión aprobada (las anteriores siguen visibles como historial de proceso, opcionalmente ocultables).
- El sellado es visual y de manifest — no hace falta backend.

### FASE 3 — Galería / Portafolio
- `arturomenaleon.com/portfolio/` lista todos los proyectos con `public: true` y `status: "approved"`.
- Curaduría manual: yo decido qué se muestra. (Ejemplo: mezclo hip hop por encargo pero no es el público que busco → `public: false` y no aparece.)
- Cada tarjeta: título, artista, género, link al comparador sellado.
- Integrar la sección al diseño existente de mi sitio (paleta glacial mist, mismo nav).
- Un index maestro (`projects.json` o build script que escanee las carpetas) alimenta la galería.

### FASE 4 — Comentarios persistentes con contraseña (Supabase)
- Comentarios anclados a timestamp: el cliente pausa, escribe, y el comentario guarda `{proyecto, version, timestamp, texto, autor, fecha}`.
- Los comentarios **quedan visibles en la página** para el cliente y para mí (no solo email) — se muestran como marcadores sobre el waveform y como lista.
- **Contraseña compartida por proyecto** (campo en manifest o en Supabase): sin contraseña puedes escuchar pero no comentar. Yo le paso la contraseña al cliente por WhatsApp.
- Nota de honestidad técnica: al ser sitio estático, la protección es de nivel práctico, no de nivel bancario. Para este caso de uso es suficiente. Explicarme los límites cuando lleguemos aquí.
- Notificaciones (email/aviso cuando comentan o aprueban): **fuera de alcance por ahora**, considerar después.

### FASE 5 — White-label para Mario
- Mi amigo Mario Vallejo (también ingeniero) usará la herramienta bajo SU nombre, su dominio y su hosting — sus clientes no deben ver rastro de mi marca.
- Toda la personalización vive en UN archivo `config.js`: nombre, dominio, subdominio de audio, paleta de colores, logo/monograma.
- El repo se estructura como **template repository** de GitHub: Mario hace "Use this template", edita `config.js`, conecta su Netlify y su R2, y listo.
- Incluir un `README.md` con guía de instalación paso a paso pensada para un ingeniero de audio, no para un dev: crear cuenta R2, configurar subdominio, conectar Netlify, subir su primer proyecto.

---

## CRITERIOS DE CALIDAD

- Responsive hasta móvil (los clientes escuchan en el teléfono).
- El toggle A/B debe seguir siendo instantáneo y sin clics con FLACs largos.
- Manejo de errores visible: si un FLAC no carga, decirlo claro, no pantalla muerta.
- Indicador de carga durante la descarga/decodificación de FLACs (pueden pesar 30-50 MB).
- Accesibilidad básica: teclado, focus visible, reduced motion.
- Sin frameworks. Sin build steps innecesarios. Vanilla y legible — yo tengo que poder mantenerlo.

## ORDEN DE TRABAJO SUGERIDO

1. Sesión 1: Fase 1 completa (comparador multi-versión + manifest + generador de proyectos + setup R2).
2. Sesión 2: Fases 2 y 3 (sellado + galería integrada al sitio).
3. Sesión 3: Fase 4 (Supabase, comentarios, contraseña).
4. Sesión 4: Fase 5 (white-label + README para Mario) y pulido final.

Empecemos por la Fase 1. Antes de escribir código, muéstrame el plan de estructura de archivos y explícame cómo va a fluir la data del manifest a la página.
