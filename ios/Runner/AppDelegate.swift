import Flutter
import UIKit
import UserNotifications
import AudioToolbox

@main
@objc class AppDelegate: FlutterAppDelegate, NotificationApi {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)

    GeneratedPluginRegistrant.register(with: self)

    // Configurar el delegate para recibir notificaciones cuando la app está en primer plano
    UNUserNotificationCenter.current().delegate = self

    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let binaryMessenger = controller.binaryMessenger
    NotificationApiSetup.setUp(binaryMessenger: binaryMessenger, api: self)

    return result
  }


  // MARK: - UNUserNotificationCenterDelegate

  // Permite mostrar notificaciones cuando la app está en primer plano
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    // Mostrar banner, sonido, badge y que quede en el panel de notificaciones
    if #available(iOS 14.0, *) {
      completionHandler([.banner, .sound, .badge, .list])
    } else {
      completionHandler([.alert, .sound, .badge])
    }
    // Vibrar el dispositivo
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
  }

  // MARK: - NotificationApi Implementation

  func showNotification(payload: NotificationPayload) throws {
    let content = UNMutableNotificationContent()
    content.title = payload.title
    content.body = payload.message
    content.sound = .default
    content.badge = 1

    // iOS 15+: Nivel de interrupción para que sea más visible
    if #available(iOS 15.0, *) {
      content.interruptionLevel = .timeSensitive
    }

    // iOS 13+: Agrupar notificaciones
    if #available(iOS 13.0, *) {
      content.threadIdentifier = "likes_notifications"
    }

    // Usar trigger con retraso para que la notificación quede en el panel
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

    let request = UNNotificationRequest(
      identifier: payload.id,
      content: content,
      trigger: trigger
    )

    UNUserNotificationCenter.current().add(request)
  }

  func requestNotificationPermissions(completion: @escaping (Result<Bool, Error>) -> Void) {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if let error = error {
        completion(.failure(error))
      } else {
        completion(.success(granted))
      }
    }
  }

  func openNotificationSettings() throws {
    // iOS 16.0+ permite abrir directamente la configuración de notificaciones
    if #available(iOS 16.0, *) {
      if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
        if UIApplication.shared.canOpenURL(url) {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
      }
    } else {
      // Para iOS < 16.0, abrir la configuración general de la app
      if let url = URL(string: UIApplication.openSettingsURLString) {
        if UIApplication.shared.canOpenURL(url) {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
      }
    }
  }
}
