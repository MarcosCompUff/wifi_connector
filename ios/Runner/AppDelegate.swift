import Flutter
import UIKit
import NetworkExtension

class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let wifiChannel = FlutterMethodChannel(name: "wifi_connector/connector",
                                                 binaryMessenger: controller.binaryMessenger)
    wifiChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      switch call.method {
      case "connectWifi":
        guard let args = call.arguments else {
          return
        }
        if let myArgs = args as? [String: Any],
           let ssid = myArgs["ssid"] as? String,
           let senha = myArgs["senha"] as? String {
          self.connectWifi(ssid: ssid, senha: senha, result: result)
        } else {
          result(FlutterError(code: "Invalid arguments",
                              message: "SSID and password cannot be null",
                              details: nil))
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func connectWifi(ssid: String, senha: String, result: @escaping FlutterResult) {
    let hotspotConfig = NEHotspotConfiguration(ssid: ssid, passphrase: senha, isWEP: false)
    hotspotConfig.joinOnce = true

    NEHotspotConfigurationManager.shared.apply(hotspotConfig) { (error) in
      if let error = error {
        result(FlutterError(code: "Failed to add network suggestion",
                            message: "Error: \(error.localizedDescription)",
                            details: nil))
      } else {
        result("Network suggestion added")
      }
    }
  }
}
