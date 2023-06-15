//
//  UIViewController+BackBarButtonItem.swift
//  Momentor
//
//  Created by mac on 16/01/2020.
//  Copyright © 2019 Differenzsystem Pvt. LTD. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftMessages

extension UIViewController {
    
    /*func hideKeyboardWhenTappedAround() {
            let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }*/
    
    func clearBackBarButtonItem() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: String(), style: .plain, target: self, action: nil)
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back")
    }
    
    func showAlert(withTitle title: String = "", with message: String, firstButton: String = ButtonTitle.OK, firstHandler: ((UIAlertAction) -> Void)? = nil, secondButton: String? = nil, secondHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: firstButton, style: .default, handler: firstHandler))
        if secondButton != nil {
            alert.addAction(UIAlertAction(title: secondButton!, style: .default, handler: secondHandler))
        }
        present(alert, animated: true)
    }
    
    func showMessage(_ bodymsg:String, buttonHide: Bool = false, backgroundColor : UIColor = .green, themeStyle : Theme = .warning, presentationStyle: SwiftMessages.PresentationStyle = .bottom, messageDuration: TimeInterval = 2, errorBackgroundColor: UIColor = #colorLiteral(red: 1, green: 0.3294117647, blue: 0.3529411765, alpha: 1), errorForegroundColor: UIColor = .white)
        {
            DispatchQueue.main.async {
                let view: MessageView
                view = MessageView.viewFromNib(layout: .cardView)
                
                view.configureContent(title: "\(bodymsg)", body: nil, iconImage: UIImage(named: "alert"), iconText: nil, buttonImage: nil, buttonTitle: nil, buttonTapHandler: { _ in SwiftMessages.hide() })
        //        if buttonHide {
                    view.button?.isHidden = true
        //        }
                view.titleLabel?.numberOfLines = 0
                
                var config = SwiftMessages.defaultConfig
                config.presentationStyle = presentationStyle
                config.dimMode = .none
                config.duration = .seconds(seconds: messageDuration)
                
                if themeStyle == .info {
                    view.configureTheme(backgroundColor: errorBackgroundColor, foregroundColor: errorForegroundColor, iconImage: UIImage(named: "wifi"), iconText: nil)
                    view.configureContent(title: "No Internet Connection", body: "Check your internet connection.", iconImage: UIImage(named: "wifi"), iconText: nil, buttonImage: nil, buttonTitle: "Setting") { (btn) in
                        print("setting")
                        if let url = URL(string:"App-Prefs:root=WIFI") {
                            if UIApplication.shared.canOpenURL(url) {
                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                } else {
                                    UIApplication.shared.openURL(url)
                                }
                            }
                        }
                    }
                    view.button?.isHidden = false
                }
                else if themeStyle == .warning {
                    view.configureTheme(.warning)
                    
                }
                else if themeStyle == .error {
                    view.configureTheme(backgroundColor: errorBackgroundColor, foregroundColor: errorForegroundColor, iconImage: nil, iconText: nil)
                    view.configureContent(title: bodymsg, body: "")
                }
                else if themeStyle == .success {
                    view.configureTheme(themeStyle)
                }
                view.accessibilityPrefix = "success"
                view.configureDropShadow()
                //var iconStyle: IconStyle = .light
                //iconStyle = .light
                //view.configureTheme(themeStyle, iconStyle: iconStyle)
                SwiftMessages.show(config: config, view: view)
            }
        }
    
    /*func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }*/
    
    func removeChild() {
        self.children.forEach {
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
