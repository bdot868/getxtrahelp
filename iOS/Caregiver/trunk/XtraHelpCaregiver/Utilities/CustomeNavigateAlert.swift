//
//  CustomeNavigateAlert.swift
//  Momentor
//
//  Created by Harshad on 15/05/21.
//

import UIKit

class CustomeNavigateAlert: NSObject {

    var viewController: UIViewController?
    
    override init() {
        super.init()
        
    }
    
    func openMapNavigation(_ sender:Any,_ pickertitle : String,AppoitnmentLatitude : Double,AppoitnmentLongitude : Double) {
        let getDirectionMenu = UIAlertController(title: nil, message: pickertitle, preferredStyle: .actionSheet)
        let currentlat : Double = LocationManager.shared.currentLocation?.coordinate.latitude ?? 0.0
        let currentlong : Double = LocationManager.shared.currentLocation?.coordinate.longitude ?? 0.0
        //Open Apple Map
        let appleMapAction = UIAlertAction(title: AlertControllerKey.kOpenInMap, style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            let openurl : String = "http://maps.apple.com/maps?saddr=\(currentlat),\(currentlong)&daddr=\(AppoitnmentLatitude),\(AppoitnmentLongitude)&dirflg=d"
            if (UIApplication.shared.canOpenURL(NSURL(string:"http://maps.apple.com")! as URL)) {
                guard let myurl = URL(string : openurl) else { return }
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(myurl)
                } else {
                    UIApplication.shared.openURL(myurl)
                }
                /*UIApplication.shared.openURL(URL(string:openurl)!)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string:openurl)!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(URL(string:openurl)!)
                }*/
            }
            else {
                guard let myurl = URL(string : openurl) else { return }
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(myurl)
                } else {
                    UIApplication.shared.openURL(myurl)
                }
            }
        })
        //OPen Gogole Map
        let openGoogleMapAction = UIAlertAction(title: AlertControllerKey.kOpenInGoogleMap, style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            let openurl : String = "comgooglemaps://?saddr=\(currentlat),\(currentlong)&daddr=\(AppoitnmentLatitude),\(AppoitnmentLongitude)"//&dirflg=d"
            if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
                
                //UIApplication.shared.openURL(NSURL(string: openurl)! as URL)
                guard let myurl = URL(string : openurl) else { return }
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(myurl)
                } else {
                    UIApplication.shared.openURL(myurl)
                }
            } else {
                let openurls : String = "https://www.google.co.in/maps/dir/?saddr=\(currentlat),\(currentlong)&daddr=\(AppoitnmentLatitude),\(AppoitnmentLongitude)&dirflg=w"
                guard let myurl = URL(string : openurls) else { return }
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(myurl, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(myurl)
                }
            }
        })
        //Copy Address
        let copyAddAction = UIAlertAction(title: AlertControllerKey.kCopyAddress, style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            //            self.showAlert(with: Constant.AlertMessages.commingSoon)
            let copyUrl : String = "https://www.google.co.in/maps/dir/?saddr=\(currentlat),\(currentlong)&daddr=\(AppoitnmentLatitude),\(AppoitnmentLongitude)&dirflg=d"
            
            UIPasteboard.general.string = copyUrl
            self.viewController?.showMessage(AppConstant.AlertMessages.copySuccess, themeStyle: .success)
        })
        //cancel
        let cancelAction = UIAlertAction(title: AlertControllerKey.kCancel, style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
 
        })
        
        getDirectionMenu.popoverPresentationController?.sourceView = sender as? UIView
        //        getDirectionMenu.popoverPresentationController?.permittedArrowDirections = .down
        
        getDirectionMenu.addAction(appleMapAction)
        getDirectionMenu.addAction(openGoogleMapAction)
        getDirectionMenu.addAction(copyAddAction)
        getDirectionMenu.addAction(cancelAction)
        viewController?.present(getDirectionMenu, animated: true, completion: nil)
    }
}
