import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)

    GeneratedPluginRegistrant.register(with: self)

    // Configurar el delegate para recibir notificaciones cuando la app está en primer plano
    UNUserNotificationCenter.current().delegate = NotificationHandler.shared

    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let binaryMessenger = controller.binaryMessenger
    NotificationApiSetup.setUp(binaryMessenger: binaryMessenger, api: NotificationHandler.shared)

    return result
  }
}
