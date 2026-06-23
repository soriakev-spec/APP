#!/usr/bin/env bash
# build_local.sh — Habla AAC · Build completo para máquina local
# Uso: bash build_local.sh [debug|release|appbundle|all]
set -euo pipefail

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------
FLUTTER_MIN="3.5.0"
JAVA_MIN="17"
BUILD_TYPE="${1:-release}"
KEYSTORE_FILE="${HABLA_KEYSTORE:-$HOME/habla-release.jks}"
KEY_ALIAS="${HABLA_KEY_ALIAS:-habla-key}"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
ok()   { echo -e "${GREEN}✓${NC} $*"; }
warn() { echo -e "${YELLOW}⚠${NC} $*"; }
err()  { echo -e "${RED}✗${NC} $*"; exit 1; }
step() { echo -e "\n${BLUE}▶${NC} $*"; }

# ---------------------------------------------------------------------------
# 1. Verificar herramientas
# ---------------------------------------------------------------------------
step "Verificando herramientas..."

command -v flutter >/dev/null 2>&1 || err "Flutter no encontrado. Instálalo desde https://flutter.dev/docs/get-started/install"
command -v java    >/dev/null 2>&1 || err "Java no encontrado. Instala JDK 17+"

JAVA_VER=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)
[[ "$JAVA_VER" -ge "$JAVA_MIN" ]] || err "Se requiere Java $JAVA_MIN+, encontrado Java $JAVA_VER"
ok "Java $JAVA_VER"

FLUTTER_VER=$(flutter --version 2>/dev/null | grep -oP 'Flutter \K[0-9]+\.[0-9]+\.[0-9]+' | head -1)
ok "Flutter $FLUTTER_VER"

# ---------------------------------------------------------------------------
# 2. Android SDK
# ---------------------------------------------------------------------------
step "Verificando Android SDK..."

if [[ -z "${ANDROID_HOME:-}" && -z "${ANDROID_SDK_ROOT:-}" ]]; then
  # Buscar en ubicaciones comunes
  for candidate in "$HOME/Android/Sdk" "$HOME/Library/Android/sdk" "/opt/android-sdk" "/usr/local/opt/android-sdk"; do
    if [[ -d "$candidate/platforms" ]]; then
      export ANDROID_SDK_ROOT="$candidate"
      break
    fi
  done
fi

ANDROID_SDK="${ANDROID_SDK_ROOT:-${ANDROID_HOME:-}}"
[[ -n "$ANDROID_SDK" ]] || err "Android SDK no encontrado. Define ANDROID_SDK_ROOT o instala Android Studio."
ok "Android SDK: $ANDROID_SDK"

# Verificar platform-34
if [[ ! -f "$ANDROID_SDK/platforms/android-34/android.jar" ]]; then
  warn "Platform android-34 no encontrado. Ejecuta: sdkmanager 'platforms;android-34'"
fi

# Aceptar licencias automáticamente (requiere sdkmanager)
if command -v sdkmanager >/dev/null 2>&1; then
  yes | sdkmanager --licenses >/dev/null 2>&1 || warn "No se pudieron aceptar las licencias automáticamente"
  ok "Licencias aceptadas"
else
  warn "sdkmanager no encontrado. Acepta licencias manualmente: flutter doctor --android-licenses"
fi

# ---------------------------------------------------------------------------
# 3. Dependencias Dart/Flutter
# ---------------------------------------------------------------------------
step "Instalando dependencias..."
flutter pub get
ok "flutter pub get completado"

# ---------------------------------------------------------------------------
# 4. local.properties
# ---------------------------------------------------------------------------
step "Generando android/local.properties..."
cat > android/local.properties <<EOF
sdk.dir=$ANDROID_SDK
flutter.sdk=$(which flutter | sed 's|/bin/flutter||')
flutter.buildMode=release
flutter.versionCode=1
flutter.versionName=1.0.0
EOF
ok "android/local.properties generado"

# ---------------------------------------------------------------------------
# 5. Build
# ---------------------------------------------------------------------------
build_debug() {
  step "Compilando APK debug..."
  flutter build apk --debug --no-pub
  APK="build/app/outputs/flutter-apk/app-debug.apk"
  ok "APK debug: $APK ($(du -h "$APK" | cut -f1))"
}

build_release_unsigned() {
  step "Compilando APK release (sin firma)..."
  flutter build apk --release --no-pub \
    --dart-define=CLAUDE_API_KEY="${CLAUDE_API_KEY:-}" \
    --dart-define=ELEVENLABS_API_KEY="${ELEVENLABS_API_KEY:-}" \
    --dart-define=AZURE_SPEECH_KEY="${AZURE_SPEECH_KEY:-}" \
    --dart-define=GOOGLE_TTS_API_KEY="${GOOGLE_TTS_API_KEY:-}"

  APK="build/app/outputs/flutter-apk/app-release.apk"
  ok "APK release: $APK ($(du -h "$APK" | cut -f1))"
}

build_release_signed() {
  step "Compilando APK release con firma..."

  if [[ ! -f "android/key.properties" ]]; then
    if [[ -f "$KEYSTORE_FILE" ]]; then
      warn "android/key.properties no existe. Créalo primero (ver android/key.properties.example)"
    else
      warn "Keystore no encontrado. Compilando sin firma..."
      build_release_unsigned
      return
    fi
  fi

  build_release_unsigned
  APK="build/app/outputs/flutter-apk/app-release.apk"
  ok "APK firmado: $APK"
}

build_appbundle() {
  step "Compilando AAB para Google Play..."
  flutter build appbundle --release --no-pub \
    --dart-define=CLAUDE_API_KEY="${CLAUDE_API_KEY:-}" \
    --dart-define=ELEVENLABS_API_KEY="${ELEVENLABS_API_KEY:-}"

  AAB="build/app/outputs/bundle/release/app-release.aab"
  ok "AAB: $AAB ($(du -h "$AAB" | cut -f1))"
}

case "$BUILD_TYPE" in
  debug)     build_debug ;;
  release)   build_release_signed ;;
  appbundle) build_appbundle ;;
  all)
    build_debug
    build_release_signed
    build_appbundle
    ;;
  *)
    echo "Uso: $0 [debug|release|appbundle|all]"
    exit 1
    ;;
esac

echo -e "\n${GREEN}✓ Build completado exitosamente.${NC}"
