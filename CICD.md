# 🚀 CI/CD - GitHub Actions

## Configuración Inicial

### 1. Habilitar GitHub Pages
1. Ve a **Settings > Pages** en tu repositorio
2. En **Source**, selecciona **GitHub Actions**

### 2. Variables de Entorno (Opcional)
Si necesitas variables sensibles, agrégalas en **Settings > Secrets and variables > Actions**

## Pipelines Disponibles

### 📋 CI (ci.yml)
Se ejecuta automáticamente en:
- **Push** a `main` o `develop`
- **Pull Request** a `main` o `develop`

**Jobs:**
- `analyze` - Análisis estático y lint
- `test` - Tests con cobertura
- `build-web` - Build para web
- `build-android` - Build APK y AAB
- `build-backend` - Análisis del backend Dart

---

### 🌐 Deploy Web (deploy-web.yml)
Se ejecuta automáticamente al hacer push a `main`.

**Funcionalidad:**
- Build de Flutter web
- Deploy automático a GitHub Pages
- URL: `https://<usuario>.github.io/modulos/`

---

### 📦 Release (release.yml)
Se ejecuta al crear un tag con formato `v*`.

**Crear un release:**
```bash
# Tag y push
git tag v1.0.0
git push origin v1.0.0

# O crear desde GitHub: Releases > Draft a new release
```

**Artefactos generados:**
- `app-release.apk` - Android APK
- `app-release.aab` - Android App Bundle
- `web-build.zip` - Build web
- `windows-build.zip` - Build Windows
- `linux-build.zip` - Build Linux

---

## 🛠️ Comandos Útiles

### Ejecutar CI localmente
```bash
# Análisis
flutter analyze
dart format --set-exit-if-changed .

# Tests
flutter test --coverage

# Build web
flutter build web --release

# Build Android
flutter build apk --release
flutter build appbundle --release

# Build Windows
flutter build windows --release

# Build Linux
flutter build linux --release
```

### Backend
```bash
cd backend
dart pub get
dart analyze
dart format --set-exit-if-changed .
```

---

## 📊 Badges (Opcional)

Agrega estos badges a tu README.md:

```markdown
[![CI](https://github.com/<usuario>/modulos/actions/workflows/ci.yml/badge.svg)](https://github.com/<usuario>/modulos/actions/workflows/ci.yml)
[![Deploy](https://github.com/<usuario>/modulos/actions/workflows/deploy-web.yml/badge.svg)](https://github.com/<usuario>/modulos/actions/workflows/deploy-web.yml)
```

---

## 🔧 Solución de Problemas

### Build falla en Android
- Verifica que `android/local.properties` no esté en el repo
- Asegúrate de tener la versión de Java correcta (17)

### Deploy web falla
- Verifica que GitHub Pages esté habilitado con source "GitHub Actions"
- Revisa que `--base-href` coincida con el nombre del repositorio

### Tests fallan
- Ejecuta `flutter pub get` localmente
- Verifica que los tests pasen con `flutter test`
