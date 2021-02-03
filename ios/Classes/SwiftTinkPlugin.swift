import Flutter
import UIKit

private struct PluginMethods {
    static let authenticate = "authenticate"
}

func invalidArgumentsError(message:String) -> FlutterError {
    return FlutterError(code: "studio.techpro.tink_plugin.error.invalid_input", message: message, details: nil)
}


public class SwiftTinkPlugin: NSObject, FlutterPlugin, UIAdaptivePresentationControllerDelegate {

    private var callback: FlutterResult!
    private var finishData: TinkAuthData = .userCancelled

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "studio.techpro.tink_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftTinkPlugin()
        registrar.addApplicationDelegate(instance)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "authenticate" {
            guard let args = (call.arguments as? [String:Any]),
                  let urlString = args["url"] as? String,
                  let url = URL(string: urlString) else {
                result(invalidArgumentsError(message: "Should be valid URL as argument"))
                return
            }
            self.callback = result
            authenticate(with: url)
        } else{
            result(FlutterMethodNotImplemented)
        }
    }

    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.finish()
    }

    func finish() {
        self.callback(finishData.asJSONString())
        self.callback = nil
        self.finishData = .userCancelled
    }

    func finishWith(tinkData: TinkAuthData) {
        self.finishData = tinkData
        self.finish()
    }

    open func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        if url.host == "tinkauth" {
            if let tinkData = TinkAuthDataExtractor.extract(url: url) {
                self.finishWith(tinkData: tinkData)
                return true
            }
            return false
        }
        return false;
    }

    private func authenticate(with url: URL){

        let tinkController = TinkAuthViewController(authURL: url)

        tinkController.tinkAuthDataCallback = {[weak self] data in
            self?.finishWith(tinkData: data)
        }

        let root = UIApplication.shared.keyWindow!.rootViewController!
        let navigationController = UINavigationController(rootViewController: tinkController)
        navigationController.presentationController?.delegate = self
        root.present(navigationController, animated: true, completion: nil)
    }

}
