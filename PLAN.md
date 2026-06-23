# PLAN.md — Habla AAC App

## Decisión de Arquitectura

### Flutter vs. React Native vs. Kotlin/Compose

| Criterio | Flutter | React Native | Kotlin/Compose |
|---|---|---|---|
| Compilación nativa | ✅ No WebView | ⚠️ Bridge JS | ✅ Nativo |
| Una base código | ✅ Android+iOS | ✅ | ❌ Solo Android |
| TTS offline | ✅ flutter_tts | ⚠️ Puentes | ✅ Nativo |
| UI consistente | ✅ Skia/Impeller | ⚠️ Componentes nativos | ✅ |
| Rendimiento listas grandes | ✅ | ⚠️ | ✅ |
| Ecosistema CAA | ✅ flutter_tts, Drift, Riverpod | ⚠️ | ⚠️ |
| Velocidad de desarrollo | ✅ Hot reload | ✅ | ⚠️ |

**Decisión: Flutter** — Compilación nativa (sin WebView), una sola base de código, UI consistente de alto rendimiento, TTS offline con `flutter_tts`, SQLite robusto con Drift, y ecosistema maduro para la capa de servicios desacoplada.

### Estado: Riverpod vs Provider vs BLoC

**Decisión: Riverpod** — Tipado fuerte, sin BuildContext, testeable sin widgets, `AsyncNotifier` para operaciones asíncronas, `family` para providers paramétricos (por perfil), y `Ref` para composición de providers sin boilerplate de BLoC.

---

## Arquitectura

```
lib/
  core/
    theme/        → tokens de color, tipografía, Fitzgerald, responsive
    router/       → GoRouter con rutas por módulo
    constants/    → rutas, strings, config
    errors/       → AppException, manejo de errores
    utils/        → extensions, helpers
  data/
    models/       → DTOs (perfiles, tableros, vocabulario, frases)
    local/        → Drift DB + DAOs + shared_preferences
    repositories/ → implementaciones concretas
  domain/
    entities/     → objetos de negocio puros
    usecases/     → lógica pura, testeable
  state/
    providers/    → Riverpod providers globales
  services/
    tts/          → TtsEngine (sistema, ElevenLabs, Azure, Google)
    ai/           → AiService (Claude, OpenAI)
    symbols/      → SymbolService (ARASAAC)
    sync/         → SyncService
    updates/      → InAppUpdateService
  features/
    home/         → 4.1 Inicio
    communicate/  → 4.2 Comunicar (núcleo)
    boards/       → 4.3 Tableros
    editor/       → 4.4 Editor
    ai_panel/     → 4.5 IA
    phrases/      → 4.6 Frases
    scenarios/    → 4.7 Temas
    activities/   → 4.8 Actividades
    supports/     → 4.9 Apoyos
    therapist/    → 4.10 Terapeuta
    family/       → 4.11 Centro Familiar
    reports/      → 4.12 Reportes
    library/      → 4.13 Biblioteca
    ecosystem/    → 4.14 Ecosistema
    settings/     → 4.15 Ajustes
  widgets/
    aac_button/   → botón AAC reutilizable
    message_bar/  → barra de mensaje
    grid/         → cuadrícula configurable
    nav/          → barra lateral tablet
    dialogs/      → diálogos in-app (no prompt/confirm)
test/
  unit/           → casos de uso, gramática, predicción
  widget/         → comunicador, tableros
assets/
  fonts/          → Bricolage Grotesque, DM Sans
  symbols/        → ARASAAC base pack (offline)
  data/           → vocabulario base JSON, frases, temas
android/          → config nativa, permisos, firma
```

---

## Plan por Fases

### Fase 1 — Configuración Android + Proyecto Flutter ✅
- Inicializar proyecto: `applicationId = com.habla.aac`, minSdk 23, targetSdk 34
- Permisos en Manifest: INTERNET, ACCESS_NETWORK_STATE, RECORD_AUDIO
- `key.properties.example` + instrucciones firma
- Build release: R8/ProGuard, shrinkResources

**Criterio de aceptación:** `flutter build apk --release` exitoso

### Fase 2 — Diseño / Sistema de Tema ✅
- Tokens de color (teal `#143A36`, superficie `#F4F0E8`, violeta IA `#5B53C9`)
- Clave Fitzgerald (personas=amarillo, verbos=verde, descriptores=azul, etc.)
- Tipografía: Bricolage Grotesque + DM Sans
- Breakpoints responsive, orientación, dark mode

**Criterio:** ThemeData completo, tokens tipados, sin magic strings de color

### Fase 3 — Estado + Persistencia ✅
- Drift schema: perfiles, tableros, vocabulario, frases, telemetría
- Repositorios con interfaces en domain/
- `shared_preferences` para ajustes simples
- Migration strategy (versioned migrations)

**Criterio:** CRUD completo persistente; datos aislados por perfil; datos sobreviven reinicio

### Fase 4 — Servicios (Stubs) ✅
- `TtsEngine` interface + `SystemTtsEngine` (flutter_tts) + stubs cloud
- `AiService` interface + stubs (Claude, OpenAI)
- `SymbolService` interface + ARASAAC stub con caché
- `InAppUpdateService` stub

**Criterio:** UI no cambia al conectar implementación real

### Fase 5 — Shell + Navegación Tablet ✅
- GoRouter: rutas /home, /communicate, /boards, /editor, /ai, /phrases, /scenarios, /activities, /supports, /therapist, /family, /reports, /library, /ecosystem, /settings
- `AppShell`: barra lateral fija en tablet (>600px), bottom nav en móvil
- Responsive layout con breakpoints

**Criterio:** Navegación funcional; sin overflow en tablet ni móvil

### Fase 6 — Perfiles (Sistema Multiusuario) ✅
- CRUD completo (Crear, Editar, Duplicar, Eliminar con confirmación, Exportar, Importar)
- 7 perfiles base por diagnóstico con vocabulario inicial automático
- Cambio de perfil en tiempo real (Riverpod invalidate cascade)
- Diálogos in-app propios

**Criterio:** Cambio de perfil refleja en Comunicar, Tableros, Frases, Historial instantáneamente

### Fase 7 — Comunicar (Núcleo) ✅
- 6 tamaños de cuadrícula (4/8/15/30/60/90)
- 3 disposiciones: Pictogramas, Escena Visual, Teclado+Predicción
- Categorías y subcategorías para todos los perfiles
- Barra de mensaje: TTS, borrar, limpiar, Expandir IA, gramática, favoritos, historial
- Predicción contextual; Motor Plan; búsqueda universal; pestaña ⭐ Sugeridas
- Vocabulario jerárquico ~370 palabras

**Criterio:** Comunicar 100% funcional; sin errores al cambiar perfil

### Fase 8 — Tableros + Editor ✅
- CRUD tableros por alumno (crear, editar, duplicar, renombrar, eliminar, importar .obf/.obz, exportar, asignar, activar)
- Activar tablero refleja en Comunicar de inmediato
- Editor: drag-and-drop, deshacer/rehacer, edición masiva, plantillas
- Inspector Contenido/Estilo/Acción
- IA: sugerir vocabulario, detectar faltante

**Criterio:** Cambios en editor visibles en Comunicar sin reiniciar

### Fase 9 — Vocabularios + Frases + Temas ✅
- Frases ~260 por contexto + personalizadas por alumno
- 20+ temas con 20-50 frases cada uno (secciones: Frases/Preguntas/Respuestas/etc.)
- Biblioteca personalizada por alumno

**Criterio:** Datos correctos por perfil; sin mezcla entre alumnos

### Fase 10 — Actividades Terapéuticas ✅
- 16 actividades, ~118 cuestionarios, ~450 preguntas
- Generadores de distractores automáticos
- Motor de opción múltiple con XP y recompensas

**Criterio:** Al menos 5 actividades funcionales con cuestionarios completos

### Fase 11 — Apoyos ✅
- Historias sociales (editor + reproductor TTS pantalla completa)
- Secuencias Primero→Luego→Después
- Rutinas con recordatorios; temporizadores; calendario; recompensas

**Criterio:** Crear y reproducir historia social con TTS; seguimiento de tareas

### Fase 12 — Terapeuta / Familia / Reportes / Biblioteca / Ecosistema ✅
- Terapeuta: KPIs, gráficas (fl_chart), metas, recomendaciones IA aplicables
- Familia: resumen diario, objetivos, aprobación cambios IA, notificaciones
- Reportes: constructor, exportar PDF
- Biblioteca: ARASAAC + fotos + IA generator
- Ecosistema: automatizaciones, integraciones, marketplace, timeline

**Criterio:** Pantallas reales con TODO arquitectónico donde quede incompleto

### Fase 13 — Ajustes ✅
- Voz (engine, idioma, velocidad, pitch), Accesibilidad (barrido, dwell, contraste), Copias de seguridad, Sincronización, Apariencia, Gestión de Perfiles

### Fase 14 — Pruebas ✅
- unit: expansión de frase, conjugación gramatical, predicción contextual, CRUD perfiles
- widget: comunicador grid, barra de mensaje, cambio de perfil

### Fase 15 — Build Release ✅
- `flutter analyze` limpio
- `flutter build apk --release`
- `flutter build appbundle --release`
- ProGuard rules, shrinkResources

---

## Datos de Relleno Objetivo

- **370** palabras vocabulario jerárquico (10 categorías, subcategorías)
- **260** frases por contexto (15+ categorías, 3 niveles de complejidad)
- **25** temas de vida real (~600 frases)
- **16** actividades terapéuticas (~118 cuestionarios, ~450 preguntas)
- **7** perfiles base por diagnóstico

## Paquete: `com.habla.aac`
## Idioma por defecto: `es-MX`
## Multiidioma: es, en, pt, ca, eu, gl
