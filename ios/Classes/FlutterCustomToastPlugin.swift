import Flutter
import UIKit

public class FlutterCustomToastPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_toast_plugin", binaryMessenger: registrar.messenger())
        let instance = Untitled7Plugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "showCustomToast":
            handleShowToast(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func handleShowToast(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let message = args["message"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid argument", details: nil))
            return
        }

        let textColorValue = args["textColor"] as? Int ?? UIColor.black.toHex()
        let fontSize = args["fontSize"] as? Double ?? 14.0
        let fontFamily = args["fontFamily"] as? String ?? UIFont.systemFont(ofSize: CGFloat(fontSize)).fontName
        let backgroundColorValue = args["backgroundColor"] as? Int ?? UIColor.white.toHex()
        let base64Image = args["base64Image"] as? String
        let imageResourceName = args["imageResourceName"] as? String
        let showImage = args["showImage"] as? Bool ?? true
        let maxLines = args["maxLines"] as? Int ?? 3
        let gravityIndex = args["gravity"] as? Int ?? 2
        let duration = args["duration"] as? Double ?? 2.0  // Default to 2.0 seconds if not provided

        // Convert base64 string to UIImage
        let image = imageFromBase64(base64String: base64Image)

        // Convert duration to TimeInterval
        let toastDuration: TimeInterval = duration
        let toastPosition: ToastPosition = self.toastPosition(from: gravityIndex)

        showToast(message: message,
                   textColor: UIColor(hex: textColorValue),
                   fontSize: CGFloat(fontSize),
                   fontFamily: fontFamily,
                   backgroundColor: UIColor(hex: backgroundColorValue),
                   image: image ?? UIImage(named:imageResourceName ?? "AppIcon"),
                   showImage: showImage,
                   maxLines: maxLines,
                   toastDuration: toastDuration,
                   toastPosition: toastPosition)

        result(nil)
    }

    private func imageFromBase64(base64String: String?) -> UIImage? {
        guard let base64String = base64String else { return nil }
        guard let data = Data(base64Encoded: base64String) else { return nil }
        return UIImage(data: data)
    }

    private func showToast(message: String, textColor: UIColor, fontSize: CGFloat, fontFamily: String, backgroundColor: UIColor, image: UIImage?, showImage: Bool, maxLines: Int, toastDuration: TimeInterval, toastPosition: ToastPosition) {
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }

        let maxWidth = UIScreen.main.bounds.width - 40

        // Create the message label
        let messageLabel = UILabel()
        messageLabel.numberOfLines = maxLines
        messageLabel.font = UIFont(name: fontFamily, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        messageLabel.text = message
        messageLabel.textColor = textColor
        messageLabel.textAlignment = .left
        messageLabel.lineBreakMode = .byTruncatingTail

        // Calculate the width based on maxLines and the presence of an image
        let maxLabelWidth = maxWidth - (showImage ? 70 : 20)
        let maxLabelSize = CGSize(width: maxLabelWidth, height: CGFloat.greatestFiniteMagnitude)
        let messageLabelSize = messageLabel.sizeThatFits(maxLabelSize)
        let messageLabelWidth = min(messageLabelSize.width, maxLabelWidth)

        // Create the toast view
        let toastView = UIView()
        toastView.backgroundColor = backgroundColor
        toastView.layer.cornerRadius = 10
        toastView.clipsToBounds = true
        toastView.translatesAutoresizingMaskIntoConstraints = false

        // Add the toast view to the parent view
        rootViewController.view.addSubview(toastView)

        // Set the constraints for the toast view
        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: rootViewController.view.centerXAnchor),
            toastView.bottomAnchor.constraint(equalTo: rootViewController.view.bottomAnchor, constant: toastPosition == .bottom ? -50 : (toastPosition == .top ? 50 : 0)),
            toastView.widthAnchor.constraint(equalToConstant: messageLabelWidth + (showImage ? 70 : 20)),
            toastView.heightAnchor.constraint(equalToConstant: messageLabelSize.height + 20)
        ])

        // Add an image view for the image if needed
        if showImage, let image = image {
            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageView.layer.cornerRadius = 6
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            toastView.addSubview(imageView)

            // Set the constraints for the image view
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: toastView.leadingAnchor, constant: 10),
                imageView.centerYAnchor.constraint(equalTo: toastView.centerYAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 30),
                imageView.heightAnchor.constraint(equalToConstant: 30)
            ])

            // Set the constraints for the message label
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            toastView.addSubview(messageLabel)
            NSLayoutConstraint.activate([
                messageLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
                messageLabel.trailingAnchor.constraint(equalTo: toastView.trailingAnchor, constant: -10),
                messageLabel.topAnchor.constraint(equalTo: toastView.topAnchor, constant: 10),
                messageLabel.bottomAnchor.constraint(equalTo: toastView.bottomAnchor, constant: -10)
            ])
        } else {
            // Set the constraints for the message label
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            toastView.addSubview(messageLabel)
            NSLayoutConstraint.activate([
                messageLabel.leadingAnchor.constraint(equalTo: toastView.leadingAnchor, constant: 10),
                messageLabel.trailingAnchor.constraint(equalTo: toastView.trailingAnchor, constant: -10),
                messageLabel.topAnchor.constraint(equalTo: toastView.topAnchor, constant: 10),
                messageLabel.bottomAnchor.constraint(equalTo: toastView.bottomAnchor, constant: -10)
            ])
        }

        // Animate the toast view to fade in and out
        toastView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            toastView.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: toastDuration, options: [], animations: {
                toastView.alpha = 0
            }) { _ in
                toastView.removeFromSuperview()
            }
        }
    }

    private func toastPosition(from index: Int) -> ToastPosition {
        switch index {
        case 0:
            return .top
        case 1:
            return .center
        default:
            return .bottom
        }
    }
}

// Extensions for UIColor
extension UIColor {
    convenience init(hex: Int) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255.0,
            green: CGFloat((hex >> 8) & 0xFF) / 255.0,
            blue: CGFloat(hex & 0xFF) / 255.0,
            alpha: 1.0
        )
    }

    func toHex() -> Int {
        guard let components = cgColor.components, components.count >= 3 else {
            return 0
        }
        let r = components[0]
        let g = components[1]
        let b = components[2]
        return Int(round(r * 255)) << 16 | Int(round(g * 255)) << 8 | Int(round(b * 255))
    }
}

// Enum for ToastPosition
enum ToastPosition {
    case top
    case center
    case bottom
}
