# Challenge Flutter SSR - Posts & Likes App

Aplicación Flutter que consume la API de JSONPlaceholder para mostrar posts con sus comentarios, permite dar "likes" con persistencia local y envía notificaciones nativas al dar like mediante comunicación tipada con Pigeon.

## 🎨 Capturas de Pantalla

<br>
<p align="center">
<img src="screenshots/Simulator Screenshot - iPhone 17 Pro - 2026-01-27 at 19.14.02.png" width="40%">
<img src="screenshots/Simulator Screenshot - iPhone 17 Pro - 2026-01-27 at 19.16.43.png" width="40%">
<img src="screenshots/Simulator Screenshot - iPhone 17 Pro - 2026-01-27 at 19.16.52.png" width="40%">
<img src="screenshots/Simulator Screenshot - iPhone 17 Pro - 2026-01-27 at 19.17.41.png" width="40%">
</p>

## Video Demo

<p align="center">
  <a href="https://youtu.be/P-eW860LmJI" target="_blank">
    <img src="https://img.youtube.com/vi/P-eW860LmJI/0.jpg" alt="Demo en YouTube" style="width:100%;max-width:900px;">
  </a>
</p>

## 📋 Características

- ✅ **Lista de Posts**: Obtención y visualización de posts desde JSONPlaceholder API
- ✅ **Búsqueda**: Filtrado de posts en tiempo real por título o contenido
- ✅ **Detalle de Post**: Vista individual con lista de comentarios
- ✅ **Sistema de Likes**: Toggle de likes con persistencia local usando SharedPreferences
- ✅ **Notificaciones Nativas**: Comunicación Flutter ↔ Nativo usando Pigeon (sin MethodChannel manual)
- ✅ **Pull to Refresh**: Actualización manual de la lista de posts
- ✅ **Manejo de Errores**: Estados de loading, error y vacío con UI apropiada

## 🏗️ Arquitectura

El proyecto implementa **Clean Architecture** con las siguientes capas:

```
lib/
├── core/                          # Funcionalidades compartidas
│   ├── error/                     # Manejo de errores (Failures)
│   ├── native/                    # Servicios nativos (Pigeon)
│   ├── network/                   # Cliente HTTP (Dio)
│   └── router/                    # Navegación (GoRouter)
│
└── features/
    └── posts/
        ├── domain/                # Capa de Dominio (Reglas de Negocio)
        │   ├── entities/          # Entidades de negocio
        │   ├── repositories/      # Interfaces de repositorios
        │   └── usecases/          # Casos de uso
        │
        ├── data/                  # Capa de Datos (Implementaciones)
        │   ├── models/            # Modelos con serialización JSON
        │   ├── datasources/       # Remote (API) y Local (Storage)
        │   └── repositories/      # Implementación de repositorios
        │
        └── presentation/          # Capa de Presentación (UI)
            ├── notifiers/         # Lógica de estado (Riverpod Notifier)
            ├── providers/         # Proveedores de Riverpod
            ├── screens/           # Pantallas
            ├── state/             # Clases de estado
            └── widgets/           # Componentes reutilizables
```

### Patrones Implementados

- **Clean Architecture**: Separación estricta en 3 capas (Domain, Data, Presentation)
- **Repository Pattern**: Abstracción del acceso a datos
- **Use Cases**: Lógica de negocio encapsulada
- **State Management**: Riverpod con Notifier pattern (moderno, no StateNotifier)
- **Either Monad**: Manejo funcional de errores con `fpdart`
- **Dependency Injection**: Mediante Riverpod providers

## 🛠️ Tecnologías y Librerías

### Core Dependencies

```yaml
flutter_riverpod: ^3.0.3         # State Management
go_router: ^17.0.1                # Navegación declarativa
dio: ^5.9.0                       # Cliente HTTP
fpdart: ^1.2.0                    # Programación funcional (Either)
shared_preferences: ^2.3.4        # Persistencia local
pigeon: ^26.1.7                   # Comunicación nativa tipada
equatable: ^2.0.8                 # Comparación de valores
intl: ^0.20.2                     # Formateo de fechas
```

### Dev Dependencies

```yaml
json_serializable: ^6.11.2        # Generación de código JSON
build_runner: ^2.4.17             # Herramienta de generación
```

## 🔧 Setup del Proyecto

### 1. Prerrequisitos

- Flutter SDK >=3.10.7
- Dart SDK >=3.10.0
- Visual Studio Code / Xcode (para desarrollo nativo)
- Git

### 2. Instalación

```bash
# Clonar el repositorio
git clone <repository-url>
cd challenge_flutter_ssr

# Instalar dependencias
flutter pub get

# Generar código de Pigeon (IMPORTANTE)
dart run pigeon --input pigeons/api.dart

# Generar código de serialización JSON
dart run build_runner build --delete-conflicting-outputs
```

### 3. Configuración de Pigeon

**Comando exacto usado para generar código nativo:**

```bash
dart run pigeon --input pigeons/api.dart
```

Este comando genera automáticamente:
- ✅ `lib/core/native/pigeon_api.g.dart` - Código Dart
- ✅ `android/app/src/main/kotlin/.../PigeonApi.g.kt` - Código Android
- ✅ `ios/Runner/PigeonApi.g.swift` - Código iOS

**Configuración en `pigeons/api.dart`:**

```dart
@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/core/native/pigeon_api.g.dart',
  kotlinOut: 'android/app/src/main/kotlin/com/example/challenge_flutter_ssr/PigeonApi.g.kt',
  swiftOut: 'ios/Runner/PigeonApi.g.swift',
))
```

**⚠️ IMPORTANTE para iOS:**
El archivo `PigeonApi.g.swift` debe ser agregado manualmente al proyecto de Xcode:
1. Abrir `open ios/Runner.xcworkspace`
2. Click derecho en carpeta Runner → "Add Files to Runner..."
3. Seleccionar `ios/Runner/PigeonApi.g.swift`
4. ✅ Marcar "Target: Runner"
5. Clean Build Folder (⇧⌘K) y Build (⌘B)

### 4. Ejecutar la App

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Simulador específico
flutter run -d <device-id>
```

## 📱 Configuración Nativa

### Android (Kotlin)

**Permisos en `AndroidManifest.xml`:**
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

**MainActivity.kt:**
- Implementa `NotificationApi` de Pigeon
- Canal de notificación con importancia alta
- Solicitud automática de permisos en Android 13+
- Verificación de permisos antes de mostrar notificaciones

### iOS (Swift)

**AppDelegate.swift:**
- Implementa `NotificationApi` de Pigeon
- Conforma a `UNUserNotificationCenterDelegate`
- Solicitud de permisos al inicio
- Configuración para mostrar notificaciones en primer plano

**Capacidades requeridas:** Ninguna adicional (Push Notifications NO necesario)

## 🧪 Testing

```bash
# Analizar el código
flutter analyze

# Ejecutar tests (si existen)
flutter test
```

## 📊 Flujo de Datos

```
┌─────────────┐
│  UI Layer   │  PostsListScreen / PostDetailScreen
└──────┬──────┘
       │ watch/read
┌──────▼──────┐
│  Notifiers  │  PostsNotifier / PostDetailNotifier
└──────┬──────┘
       │ call
┌──────▼──────┐
│  Use Cases  │  PostsUseCase (getPosts, toggleLike, etc.)
└──────┬──────┘
       │ execute
┌──────▼──────┐
│ Repository  │  PostsRepositoryImpl (fusiona remote + local)
└──────┬──────┘
       │
  ┌────┴─────┐
  │          │
┌─▼────┐  ┌─▼─────┐
│Remote│  │ Local │
│ (API)│  │(Cache)│
└──────┘  └───────┘
```

## 🤖 Uso de IA en el Desarrollo

Este proyecto fue desarrollado con asistencia de **GitHub Copilot** (Claude Sonnet 4.5) para:

### 1. Configuración Nativa
- ✅ Implementación de Pigeon APIs en Kotlin y Swift
- ✅ Configuración de notificaciones nativas en ambas plataformas
- ✅ Manejo de permisos en Android 13+ e iOS
- ✅ Resolución de problemas de compatibilidad

### 2. Debugging y Optimización
- ✅ Corrección de errores de compilación

### 3. Documentación
- ✅ Generación de este README
- ✅ Comentarios en código
- ✅ Documentación de setup de Pigeon


## 📝 API Endpoints

**Base URL:** `https://jsonplaceholder.typicode.com`

- `GET /posts` - Obtener todos los posts
- `GET /posts/{id}` - Obtener post por ID
- `GET /posts/{id}/comments` - Obtener comentarios de un post

## 🐛 Problemas Conocidos

- ⚠️ La advertencia de depreciación en iOS (`rootViewController` en `didFinishLaunchingWithOptions`) se puede ignorar. Usar `window?.rootViewController` es el patrón funcional actual según la documentación oficial de Pigeon.

## 📄 Licencia

Este proyecto es un challenge técnico para demostración de habilidades.

## 👤 Autor

**Elkis Rovira**
- GitHub: [@andresroviram](https://github.com/andresroviram)

---

**Fecha de desarrollo:** Enero 2026
**Flutter SDK:** 3.38.7
**Dart SDK:** 3.10.7
