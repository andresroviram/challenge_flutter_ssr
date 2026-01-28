# Configuración iOS - Agregar PigeonApi.g.swift a Xcode

El archivo `PigeonApi.g.swift` fue generado correctamente pero necesita ser agregado al proyecto de Xcode manualmente.

## Pasos para agregar PigeonApi.g.swift al proyecto:

1. **Abrir el proyecto en Xcode**:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Agregar el archivo al proyecto**:
   - En Xcode, haz clic derecho en la carpeta `Runner` en el Project Navigator (panel izquierdo)
   - Selecciona `Add Files to "Runner"...`
   - Navega a: `ios/Runner/PigeonApi.g.swift`
   - **IMPORTANTE**: Asegúrate de que estas opciones estén marcadas:
     - ✅ Copy items if needed (si está disponible)
     - ✅ Create groups
     - ✅ Target: Runner (debe estar seleccionado)
   - Haz clic en `Add`

3. **Verificar que el archivo está en el target**:
   - Selecciona `PigeonApi.g.swift` en el Project Navigator
   - En el panel derecho (File Inspector), verifica que en "Target Membership" esté marcado `Runner`

4. **Limpiar y compilar**:
   - En Xcode: Product → Clean Build Folder (⇧⌘K)
   - Luego: Product → Build (⌘B)

## Alternativa: Compilar desde línea de comandos

Una vez agregado el archivo a Xcode, puedes usar:

```bash
# Limpiar
flutter clean

# Compilar para simulador
flutter build ios --simulator --debug

# O ejecutar directamente
flutter run -d <device-id>
```

## Verificar que todo funciona

Después de agregar el archivo y compilar, la app debería:
- Compilar sin errores en iOS
- Mostrar notificaciones cuando das like a un post
- Solicitar permisos de notificación la primera vez que se ejecuta

## Ubicaciones importantes:
- Archivo generado: `ios/Runner/PigeonApi.g.swift`
- AppDelegate: `ios/Runner/AppDelegate.swift`
- Configuración Pigeon: `pigeons/api.dart`
