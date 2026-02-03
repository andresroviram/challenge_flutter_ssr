import Foundation
import AppKit
import UserNotifications

class NotificationHandler: NSObject, NotificationApi {
  static let shared = NotificationHandler()
  
  private override init() {
    super.init()
  }
  
  // MARK: - NotificationApi Implementation
  
  func showNotification(payload: NotificationPayload) throws {
    let content = UNMutableNotificationContent()
    content.title = payload.title
    content.body = payload.message
    content.sound = .default
    
    // Sin trigger para que aparezca inmediatamente
    let request = UNNotificationRequest(
      identifier: payload.id,
      content: content,
      trigger: nil
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
    // En macOS, abrir las preferencias del sistema en la sección de notificaciones
    if let url = URL(string: "x-apple.systempreferences:com.apple.preference.notifications") {
      NSWorkspace.shared.open(url)
    }
  }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationHandler: UNUserNotificationCenterDelegate {
  // Permite mostrar notificaciones cuando la app está en primer plano
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    // Mostrar banner y sonido (banner requiere macOS 11.0+)
    if #available(macOS 11.0, *) {
      completionHandler([.banner, .sound])
    } else {
      completionHandler([.alert, .sound])
    }
  }
}
