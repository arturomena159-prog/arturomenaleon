# Prompts para Claude Code — Auditoría arturomenaleon.com
### Instrucciones de uso
1. Abre Claude Code en la carpeta del proyecto.
2. Ejecuta `/model` y selecciona **claude-fable-5** (verifica con `/status`).
3. Pega **un prompt a la vez**. Revisa el sitio en local, y si todo está bien: `git add -A && git commit` con el mensaje sugerido, luego `git push`.
4. Antes del Prompt 1, ten a la mano tus **URLs reales de LinkedIn e Instagram** — hay dos marcadores `[TODO]` que debes rellenar tú.
5. En el Prompt 3 hay marcadores `[TODO]` con números que solo tú conoces (lanzamientos, proyectos). Rellénalos antes de pegar.

---

## PROMPT 1 — Fixes críticos y navegación móvil
*Commit sugerido: `fix: dead links, footer typo, mobile nav, sample buttons`*

```
Contexto: este es mi portafolio personal (sitio estático HTML/CSS/JS, deploy en Netlify vía GitHub). Antes de tocar nada, lee el CLAUDE.md si existe y explora la estructura del proyecto para entender cómo están organizados los archivos. No cambies la paleta de colores, las tipografías ni el sistema de diseño general. Haz únicamente lo siguiente:

1. LINKS MUERTOS: Los enlaces de LinkedIn e Instagram apuntan a "#". Reemplázalos por:
   - LinkedIn: [TODO: pega tu URL real]
   - Instagram: [TODO: pega tu URL real]
   Agrégales target="_blank" y rel="noopener noreferrer".

2. ERRATA EN FOOTER: En algún lugar del sitio (creo que el footer del hero) dice "arturoménaleon.com" con acento en la é. Búscalo en todos los archivos y corrígelo a "arturomenaleon.com". Aprovecha para buscar cualquier otra errata de acentos en URLs o emails.

3. AÑO INCONSISTENTE: Hay footers que dicen © 2025 y otros © 2026. Unifícalos. Mejor aún: genera el año con JavaScript (new Date().getFullYear()) para que nunca vuelva a quedar desactualizado.

4. LINKS DE SOUNDTOGGLE: En la sección de muestras de Atmos hay URLs de SoundToggle pegadas como texto crudo. Conviértelas en botones estilizados consistentes con el sistema de diseño existente (borde fino, tipografía mono en mayúsculas, mismo estilo que el botón "EXPLORAR →"). El texto de cada botón: "ESCUCHAR EN SOUNDTOGGLE →". Deben abrir en pestaña nueva.

5. MENÚ MÓVIL: La navegación se desborda en pantallas chicas — "MÚSICA" (y posiblemente "CONTACTO") quedan cortados fuera del viewport. Implementa un menú hamburguesa para viewports menores a ~900px:
   - Botón hamburguesa animado (tres líneas → X) en la esquina superior derecha, junto al logo A·M·L que permanece visible.
   - Al abrirlo: overlay a pantalla completa con el fondo oscuro del sitio, links apilados verticalmente en la tipografía serif display, grandes, con la misma numeración/estilo del sitio.
   - Cierre al tocar un link o la X. Bloquea el scroll del body mientras está abierto.
   - En desktop la navegación actual queda intacta.
   - Todo accesible: aria-expanded, aria-label, navegable con teclado.

Al terminar, dame un resumen de cada archivo tocado y qué cambió.
```

---

## PROMPT 2 — Reemplazo de burbujas + sistema de marcos para imágenes
*Commit sugerido: `feat: film grain background, editorial image frames, grid fixes`*

```
Continúo puliendo el sitio. No cambies paleta, tipografías ni estructura de contenido. Tres tareas visuales:

1. ELIMINAR LAS BURBUJAS Y PONER GRANO DE PELÍCULA:
   El hero (y quizá otras secciones) tiene un patrón decorativo de rectángulos redondeados semitransparentes (burbujas) que se ve pixelado. Localiza ese código (puede ser un canvas, divs generados por JS, o un background CSS) y elimínalo por completo, incluyendo su JS y CSS asociados.
   En su lugar, agrega una capa de grano de película sutil sobre todo el sitio, coherente con mi identidad de cine y fotografía analógica:
   - Implementación: un div fijo a pantalla completa (position: fixed, inset: 0, pointer-events: none, z-index alto pero debajo de la navegación) con un noise SVG generado con feTurbulence como background-image en data URI. Nada de PNGs externos.
   - Opacidad muy baja: entre 0.04 y 0.06. Debe sentirse como textura, no verse como ruido.
   - Animación opcional muy sutil: mover el background-position con steps() (8 pasos, ~0.5s, infinite) para simular grano de proyección. Envuélvela en @media (prefers-reduced-motion: no-preference) para respetar accesibilidad.
   - Beneficio extra: el grano disimula el banding del gradiente azul oscuro en pantallas OLED. Verifica que el gradiente del fondo se vea limpio.

2. SISTEMA DE MARCOS EDITORIALES PARA TODAS LAS IMÁGENES:
   Las fotos actualmente flotan sin integración. Crea un componente reutilizable:
   - Envuelve cada imagen de contenido en <figure class="media-frame"> con <figcaption>.
   - Estilo del frame: borde de 1px en rgba(255,255,255,0.12), padding interno pequeño (~6-8px) entre borde e imagen para efecto de montaje editorial, fondo apenas más claro que el fondo de la página (rgba(255,255,255,0.02)).
   - Figcaption: tipografía mono del sitio, mayúsculas, letter-spacing amplio, tamaño pequeño, color atenuado, alineado a la izquierda con una línea fina arriba. Mismo estilo que los captions que ya existen ("LONDRES, 2025", "PRODUCTION SOUND · ON SET") — de hecho, migra esos captions existentes a este componente para que todo sea un solo sistema.
   - Aplícalo a: la foto de "Sobre mí", las fotos de la sección Cine, y las fotos de la galería analógica.
   - Para las fotos de la galería que no tengan caption, usa el formato "35MM · [LUGAR O SERIE]" como placeholder y márcame en un comentario HTML cuáles necesitan que yo escriba el texto real.

3. ARREGLAR LAS RETÍCULAS:
   - Galería de fotografía: en móvil quedan huecos enormes junto a las fotos verticales. En viewports menores a ~700px, muéstrala en una sola columna a ancho completo (dentro de su frame). En desktop, usa CSS columns o grid con row spans para un masonry limpio sin huecos.
   - Sección de música: las portadas tienen proporciones dispares y dejan zonas vacías oscuras en las tarjetas. Fuerza miniaturas cuadradas uniformes con aspect-ratio: 1/1 y object-fit: cover, en un grid de 2 columnas en móvil y 3-4 en desktop, todas las tarjetas de la misma altura.
   - Pósters de cine: mismo tratamiento, aspect-ratio consistente (2/3 típico de póster), object-fit: cover.

Al terminar, resume archivos tocados y qué cambió.
```

---

## PROMPT 3 — Pase de contenido (voz humana, sobria)
*Commit sugerido: `content: copy pass — remove formulaic lines, real stats`*

**⚠️ Rellena los [TODO] con tus números reales antes de pegar.**

```
Ahora un pase de contenido. Objetivo: que el copy suene sobrio, concreto y escrito por un humano — cero frases grandilocuentes de plantilla. NO toques el diseño. Cambios exactos:

1. FRASES-AFORISMO REPETIDAS: El sitio tiene una frase poética con guion largo en casi cada sección, y el patrón se siente de fórmula. Elimina estas:
   - "La fotografía analógica no captura momentos — captura decisiones irreversibles." (sección Analógico 35mm) — elimínala por completo, sin reemplazo.
   - "El sonido que no se ve. La imagen que no se olvida." (hero) — reemplázala por una línea de posicionamiento factual: "Sonido para cine y música — de la locación a la mezcla final."
   - Busca cualquier otra frase de este estilo (formato cita en itálicas) en secciones que no mencioné y elimínala también, listándome cuáles encontraste.
   CONSERVA únicamente esta, en la sección Mix & Master, ajustada así: "La mezcla que no se nota, pero se siente."

2. FRASE HUECA: "Sin compromisos en la cadena de señal." → reemplázala por: "Monitoreo calibrado y control de calidad en cada entrega."

3. STATS "EN NÚMEROS" (sección Sobre mí): Los actuales mezclan specs del formato con datos personales y uno es un chiste (∞). Reemplaza los cuatro por datos verificables míos:
   - "10+ / AÑOS EN AUDIO" (se queda igual)
   - "[TODO: número] / LANZAMIENTOS MEZCLADOS"
   - "[TODO: número] / PROYECTOS DE CINE"
   - "2 / PAÍSES BASE — MX · UK"
   Elimina "128 CANALES ATMOS" de aquí (ya aparece como spec en la sección Atmos, donde sí tiene sentido) y elimina "∞ POR VENIR".

4. CONSISTENCIA DE IDIOMA EN TAGS: Los chips/tags mezclan inglés y español sin criterio. Regla: términos técnicos de industria se quedan en inglés (Location Sound, Foley, ADR, Re-recording, Stereo Mix, Mastering, Stem Mixing, Pro Tools, DCP), pero los que tienen equivalente natural cambian: "DOCUMENTARY" → "DOCUMENTAL", "PORTRAITURE" → "RETRATO".

5. Revisa ortografía y acentos en todo el texto en español y corrige lo que encuentres, listándome los cambios.

Al terminar, muéstrame el antes/después de cada texto modificado.
```

---

## PROMPT 4 — Versión bilingüe EN/ES
*Commit sugerido: `feat: english version + language toggle, hreflang`*

**Nota mía (Noa):** aquí decidí poner **inglés como idioma principal en la raíz** y español en `/es/`, porque tu mercado de outreach son productoras y estudios del Reino Unido — es lo que va a ver un cliente que llegue en frío. Si prefieres invertirlo (español en raíz, inglés en `/en/`), dile a Claude Code exactamente eso al inicio del prompt.

```
Quiero el sitio bilingüe. Mi mercado principal son productoras y estudios en Reino Unido, así que el INGLÉS será el idioma por defecto en la raíz del sitio, y el español vivirá en /es/. Plan:

1. ESTRUCTURA:
   - Mueve el contenido actual en español a /es/ (es/index.html y las páginas que existan), ajustando todas las rutas relativas de assets, CSS y JS para que sigan funcionando desde esa subcarpeta.
   - Crea la versión en inglés en la raíz, con exactamente el mismo diseño, estructura y assets. Solo cambia el texto.

2. TRADUCCIÓN: Traduce todo el contenido al inglés con estas reglas:
   - Tono sobrio, directo, de profesional de la industria. NADA de marketing inflado ni frases dramáticas ("crafting immersive sonic experiences" está prohibido). Debe sonar a un mixer británico/internacional describiendo su trabajo, no a una landing page.
   - Usa terminología estándar de la industria: re-recording mixer, production sound mixer, dialogue editing, location sound, foley artist, stems, deliverables, DCP, ADM master.
   - Títulos de sección: mantén el espíritu, no traduzcas literal. Referencias: "Del set a la sala" → "From set to screen". "El sonido tiene altura." → "Sound with height." "Quién soy yo" → "Who I am". "Mix & Master" se queda igual. "Analógico 35mm" → "Analogue 35mm" (ortografía británica).
   - La línea del hero "Sonido para cine y música — de la locación a la mezcla final." → "Sound for film and music — from location to final mix."
   - La cita de Mix & Master → "The mix you don't notice, but feel."
   - Usa ortografía británica en todo (analogue, colour, organisation).
   - Los labels de stats: "YEARS IN AUDIO", "RELEASES MIXED", "FILM PROJECTS", "COUNTRIES — MX · UK".

3. TOGGLE DE IDIOMA: Agrega un selector "EN / ES" en la navegación (visible también en el menú móvil), estilo mono consistente con el sitio, con el idioma activo resaltado. Cada versión enlaza a su página equivalente en el otro idioma, no siempre al home.

4. SEO BILINGÜE:
   - Etiquetas hreflang recíprocas en el <head> de ambas versiones (en, es, y x-default apuntando a la raíz).
   - Atributo lang correcto en cada <html> (en / es).
   - Titles y meta descriptions traducidos por idioma.
   - Si hay sitemap o config de Netlify, actualízalos.

5. Verifica que TODOS los links internos de cada versión se queden dentro de su idioma.

Al terminar, dame la lista de archivos creados/movidos y confirma que el sitio en español funciona idéntico desde /es/.
```

---

## PROMPT 5 — Performance y SEO
*Commit sugerido: `perf: webp images, lazy loading, meta/og tags, clean paths`*

```
Último pase: performance y SEO. No toques diseño ni contenido.

1. IMÁGENES: Los escaneos de película y fotos de set son JPEGs pesados.
   - Convierte todas las imágenes de contenido a WebP (calidad ~80) con <picture> y fallback JPEG, o si el markup se complica, solo WebP (el soporte ya es universal).
   - Redimensiona: ninguna imagen de contenido necesita más de 1600px de ancho para este layout. Genera versiones responsive con srcset si es razonable.
   - loading="lazy" y decoding="async" en todas las imágenes excepto las del primer viewport (hero / primera de cada página).
   - width y height explícitos en cada <img> para evitar layout shift.

2. RUTAS: Hay carpetas y archivos con espacios en el nombre (ej. "Assets/img/On Set/..."). Renómbralos a minúsculas con guiones (assets/img/on-set/...) y actualiza TODAS las referencias en HTML, CSS y JS. Verifica que no quede ninguna referencia rota.

3. META Y SOCIAL:
   - Meta description por página e idioma. Para la raíz (EN), algo como: "Arturo Mena León — re-recording mixer, Dolby Atmos and production sound mixer based in London. Audio post for film and music."
   - Open Graph completo (og:title, og:description, og:image, og:url, og:type) y Twitter Card. Para og:image usa una de mis fotos de set en horizontal, en 1200x630.
   - Favicon: si no existe, genera uno simple con el monograma "A·M·L" en la tipografía y colores del sitio (SVG + fallback PNG/ICO).
   - Canonical tags por página.

4. Revisa la consola del navegador y corrige cualquier error de JS o recurso 404 que encuentres.

Al terminar, dame un resumen y una estimación del peso de página antes/después.
```

---

### Después de las 5 fases
- Prueba el sitio completo en tu teléfono (no solo en el emulador de DevTools).
- Corre Lighthouse en Chrome (pestaña DevTools → Lighthouse) en móvil y pásame los resultados si quieres que afinemos algo.
- Los captions placeholder de la galería ("35MM · ...") — escríbelos tú con lugar/año/película usada. Ese detalle es el que le da credibilidad fotográfica real.
