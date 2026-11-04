import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  
  override var window: UIWindow? {
    get {
      if let w = super.window {
        return w
      }
      if #available(iOS 13.0, *) {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
          return scene.windows.first { $0.isKeyWindow } ?? scene.windows.first
        }
      }
      return nil
    }
    set {
      super.window = newValue
    }
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
   if #available(iOS 10.0, *) {
     UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
   }
   GMSServices.provideAPIKey("AIzaSyDNbeNlSQb8NyHK-z-JlVQWicssGnzyJms")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
