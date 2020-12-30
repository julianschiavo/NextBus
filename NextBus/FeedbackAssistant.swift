//
//  FeedbackAssistant.swift
//  NextBus
//
//  Created by Julian Schiavo on 20/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

//import DeviceKit
import MessageUI
import UIKit

class FeedbackAssistant: NSObject, MFMailComposeViewControllerDelegate {
    
    // MARK: - Shared Instance
    
    static let shared = FeedbackAssistant()
    
    // MARK: - Feedback Assistant
    
    let supportEmailAddress = "support@clustercards.app"
    
    let genericEmailTemplate = """
        <html>
            <head>
                <style>* { font-family: -apple-system, 'SF Pro Display', BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol'!important; }</style>
            </head>
            <body>
                <p>
                    <br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
                </p>
                <p>
                    <b>\(Localizations.supportDoNotEditText)</b><br><br>
                    <br>
                    <b>Issue ID:</b> %@<br>
                    <br>
                    <b>App Version:</b> %@<br>
                    <b>App Build Number:</b> %@<br>
                    <br>
                    <b>Device Version:</b> %@ %@<br>
                    <br>
                </p>
            </body>
        </html>
    """
    
    /// Takes a screenshot of the current screen and returns the corresponding image
    ///
    /// - Returns: (Optional) image captured as a screenshot
    func takeScreenshot() -> UIImage? {
        var screenshotImage: UIImage?
        
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let windowLayer = scene.windows.first?.layer else { return nil }
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(windowLayer.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        windowLayer.render(in: context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenshotImage
    }
    
    func generateGenericEmailTemplate(uuid: String, appVersion: String, appBuildNumber: String) -> String {
        let systemName = UIDevice.current.systemName
        let systemVersion = UIDevice.current.systemVersion
        return String(format: genericEmailTemplate, uuid, appVersion, appBuildNumber, systemName, systemVersion)
    }
    
    func createNewSupportRequest(on viewController: UIViewController) {
        let includeScreenshotOption = UIAlertAction(title: Localizations.supportIncludeScreenshotButton, style: .default) { [weak viewController] _ in
            guard let viewController = viewController else { return }
            self.createNewSupportRequest(on: viewController, includeScreenshot: true)
        }
        
        let noScreenshotOption = UIAlertAction(title: Localizations.supportDoNotIncludeScreenshotButton, style: .default) { [weak viewController] _ in
            guard let viewController = viewController else { return }
            self.createNewSupportRequest(on: viewController, includeScreenshot: false)
        }
        
        let alertController = UIAlertController(title: Localizations.supportIncludeScreenshotTitle, message: Localizations.supportIncludeScreenshotText, preferredStyle: .alert)
        alertController.addAction(noScreenshotOption)
        alertController.addAction(includeScreenshotOption)
        viewController.present(alertController, animated: true)
    }
    
    private func createNewSupportRequest(on viewController: UIViewController, includeScreenshot shouldIncludeScreenshot: Bool) {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else { return }
        
        // Try to use the first part of the UUID and fall back to the entire UUID
        // The entire UUID has to be a Substring to make it the same type as the split UUID (which can't be a String because it's an Optional)
        let emailIdentifier = UUID().uuidString.split(separator: "-").first ?? Substring(UUID().uuidString)
        
        let emailTemplate = generateGenericEmailTemplate(uuid: String(emailIdentifier), appVersion: version, appBuildNumber: build)
        
        var screenshot: UIImage?
        if shouldIncludeScreenshot {
            screenshot = takeScreenshot()
        }
        
        showComposeViewController(on: viewController, emailIdentifier: String(emailIdentifier), emailTemplate: emailTemplate, screenshot: screenshot)
    }
    
    private func showComposeViewController(on viewController: UIViewController, emailIdentifier: String, emailTemplate: String, screenshot: UIImage?) {
        let composeViewController = MFMailComposeViewController()
        composeViewController.setSubject("Next Bus Support Request - \(emailIdentifier)")
        composeViewController.setMessageBody(emailTemplate, isHTML: true)
        composeViewController.setToRecipients([supportEmailAddress])
        
        if let screenshotData = screenshot?.jpegData(compressionQuality: 1.0) {
            composeViewController.addAttachmentData(screenshotData, mimeType: "image/jpeg", fileName: "screenshot.jpg")
        }
        
        if let mailComposeDelegate = viewController as? MFMailComposeViewControllerDelegate {
            composeViewController.mailComposeDelegate = mailComposeDelegate
        } else {
            composeViewController.mailComposeDelegate = self
        }
        
        composeViewController.modalPresentationStyle = .pageSheet
        viewController.present(composeViewController, animated: true)
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    // MARK: - Init
    
    private override init() {
        super.init()
    }
}
