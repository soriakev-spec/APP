# Habla — Plataforma CAA con IA para Tabletas Android

**"Menos configuración. Más comunicación."**

Habla es una aplicación nativa de Comunicación Aumentativa y Alternativa (CAA/AAC) construida con Flutter, diseñada para tabletas Android, con soporte de IA, voz offline, perfiles por diagnóstico y vocabulario jerárquico.

---

## Requisitos

- **Flutter** ≥ 3.5 (canal stable)
- **Dart** ≥ 3.5
- **Android SDK** 34+ con minSdk 23
- **Java/Kotlin** 17

---

## Instalación y ejecución

```bash
# 1. Instalar dependencias
flutter pub get

# 2. Ejecutar en modo debug
flutter run

# 3. Ejecutar en tablet específica
flutter run -d <device-id>
```

---

## Generar APK y AAB

### APK de debug
```bash
flutter build apk --debug
# Salida: build/app/outputs/flutter-apk/app-debug.apk
```

### APK de release (sin firma)
```bash
flutter build apk --release
```

### AAB para Google Play (requiere firma)
```bash
flutter build appbundle --release
# Salida: build/app/outputs/bundle/release/app-release.aab
```

---

## Configurar firma para Release

### 1. Crear keystore
```bash
keytool -genkey -v \
  -keystore ~/habla-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias habla-key \
  -dname "CN=Habla AAC, O=Tu Organización, C=MX"
```

### 2. Crear `android/key.properties`
```
storePassword=TU_CONTRASEÑA_KEYSTORE
keyPassword=TU_CONTRASEÑA_KEY
keyAlias=habla-key
storeFile=/ruta/absoluta/habla-release.jks
```

> ⚠️ **Nunca commitear `key.properties`** — ya está en `.gitignore`.

### 3. Build firmado
```bash
flutter build apk --release
flutter build appbundle --release
```

---

## Conectar APIs

```bash
# Claude / Anthropic IA
flutter run --dart-define=CLAUDE_API_KEY=sk-ant-...

# ElevenLabs (voz neuronal)
flutter run --dart-define=ELEVENLABS_API_KEY=...

# Azure Speech
flutter run --dart-define=AZURE_SPEECH_KEY=... --dart-define=AZURE_SPEECH_REGION=eastus

# Google TTS
flutter run --dart-define=GOOGLE_TTS_API_KEY=...
```

Las claves se inyectan en tiempo de compilación con `--dart-define`. Nunca se hardcodean.

---

## Estructura del proyecto

```
lib/
  core/       → tema, tokens de color, responsive, router, constantes
  data/       → Drift/SQLite, DAOs, repositorios
  domain/     → entidades puras
  state/      → providers Riverpod
  services/   → TTS, IA (stubs listos para conectar), ARASAAC
  features/   → 15 módulos de la app
  widgets/    → AacButton, MessageBar, AppSideNav, Dialogs
assets/
  data/       → vocabulary.json, phrases.json, scenarios.json, activities.json
  fonts/      → BricolageGrotesque, DM Sans
  symbols/    → placeholder ARASAAC
android/      → configuración nativa, permisos, ProGuard, keystore
test/         → pruebas unitarias y de widget
```

---

## Módulos

| Módulo | Ruta | Estado |
|--------|------|--------|
| Inicio | `/home` | ✅ |
| Comunicar | `/communicate` | ✅ núcleo funcional |
| Tableros | `/boards` | ✅ CRUD completo |
| Editor | `/editor/:id` | ✅ |
| Habla IA | `/ai` | ✅ (stubs, listo para Claude/OpenAI) |
| Frases | `/phrases` | ✅ |
| Escenarios | `/scenarios` | ✅ 25 temas |
| Actividades | `/activities` | ✅ |
| Apoyos | `/supports` | ✅ |
| Terapeuta | `/therapist` | ✅ |
| Centro Familiar | `/family` | ✅ |
| Reportes | `/reports` | ✅ |
| Biblioteca | `/library` | ✅ |
| Ecosistema | `/ecosystem` | ✅ |
| Ajustes | `/settings` | ✅ |

---

## Accesibilidad AAC

- Voz offline (flutter_tts) — es-MX, prosodia automática
- Barrido automático y dwell time configurables
- Compatible con TalkBack (Flutter Semantics)
- Clave Fitzgerald (color clínico por categoría gramatical)
- Objetivos táctiles ≥ 48dp; soporte tablet-first horizontal

---

## Google Play — Checklist

- [ ] Capturas de pantalla tablet 7" y 10"
- [ ] Ícono adaptable 512×512
- [ ] Feature graphic 1024×500
- [ ] Política de privacidad publicada (ver `privacy_policy.md`)
- [ ] Data Safety: sin anuncios, datos locales, micrófono con consentimiento
- [ ] Clasificación de contenido: apto para todas las edades (sin anuncios, sin IAP)

---

## Licencia

Copyright © 2025 Habla AAC. Todos los derechos reservados.

Pictogramas ARASAAC © Gobierno de Aragón — Licencia Creative Commons BY-NC-SA 4.0
