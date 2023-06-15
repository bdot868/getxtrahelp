//
//  AppDelegate.swift
//  XtraHelp
//
//  Created by DeviOS1 on 11/09/21.
//

import UIKit
import CoreData
import SVProgressHUD
import IQKeyboardManager
import GooglePlaces
import GoogleSignIn
import GoogleMaps
import GoogleUtilities
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        //Thread.sleep(forTimeInterval: 3.0)
        Thread.sleep(forTimeInterval: 2.0)
        self.setSVProgressHUDconfiguration()
        self.configureLocalNotifications()
        self.setIQKeyboardManager()
        LocationManager.shared.startLocationTracking()
        self.configureGoogle()
        TWTRTwitter.sharedInstance().start(withConsumerKey:"qFjm9MvtCEdcKF3kV9mmpUfpG", consumerSecret:"4XCBiBfPqRIqJ4IxjXYqpMhKaa6a659eLX5gAtUYsE5M7vhpPU")
        //self.pushKitRegistration()
        //WebSocketChat.shared.connectSocket()
        window?.rootViewController = AppSideMenuMainViewController.instantiated { vc in
            vc.rootNavigationController?.menuDelegate = vc
        }
       
//        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        GIDSignIn.sharedInstance.handle(url)//sharedInstance().handle(url)
        ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.portrait.rawValue)
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
    
        let container = NSPersistentContainer(name: "XtraHelp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: - Local Notifications
fileprivate extension AppDelegate {
    func configureLocalNotifications() {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {(accepted, error) in
                if !accepted {
                    print("Notification access denied.")
                }
            }
            //UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            // Fallback on earlier versions
        }
        
        Messaging.messaging().delegate = self
    }
}

extension AppDelegate : MessagingDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")
        if let str = fcmToken {
            let dataDict:[String: String] = ["token": str ]
            //UserDefaults.standard.set(String(describing: fcmToken), forKey: UD_Device_Token)
            UserDefaults.setDeviceToken = str
            NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        }
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }

    
    /*Messaging.messaging().token { token, error in
      if let error = error {
        print("Error fetching FCM registration token: \(error)")
      } else if let token = token {
        print("FCM registration token: \(token)")
        self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
      }
    }*/
    
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token " + token)
        //Chiry.sharedInstance.deviceToken = token
        //UserDefaults.setDeviceToken = token
        
        Messaging.messaging().apnsToken = deviceToken
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let notificationData = notification.request.content.userInfo
        print(notificationData)
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: notificationData, options: .prettyPrinted) {
            print("Response: \n",String(data: jsonData, encoding: String.Encoding.utf8) ?? "nil")
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        let userInfostr = notificationData["payload"] as? String ?? ""
        if let userInfo : [String:Any] = userInfostr.convertStringToDictionary() {
            if let msgdic = userInfo["messages"] as? [String:Any], let msgdata = msgdic["messageData"] as? [String:Any] {
                if let modeldtata = msgdata["model"] as? String {
                    
                    //NotificationCenter.default.post(name: Notification.Name(NotificationPostname.kUpdateNotificationCount), object: nil, userInfo: nil)
                }
            }
        }
        completionHandler([.alert, .sound,.badge])
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        // send info from response somewhere before delete notification!!!
        let notificationData = response.notification.request.content.userInfo
        print(notificationData)
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: notificationData, options: .prettyPrinted) {
            print("Response: \n",String(data: jsonData, encoding: String.Encoding.utf8) ?? "nil")
        }
        let userInfostr = notificationData["payload"] as? String ?? ""
        if let userInfo : [String:Any] = userInfostr.convertStringToDictionary() {
            //let dictData = userInfo["data"] as? [String :Any] ?? [:]
            if(UserDefaults.isUserLogin){
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    NotificationCenter.default.post(name:NSNotification.Name(rawValue: NotificationPostname.kPushNotification), object: userInfo, userInfo: userInfo)
                }
            }
        }
        completionHandler()
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        print(data)
    }
}

//MARK: - Private Methods
extension AppDelegate {
    // MARK: - SVProgressHUD configuration Method
    func setSVProgressHUDconfiguration() {
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.flat)
        //        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.native)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.custom)
        SVProgressHUD.setBackgroundLayerColor(UIColor.black.withAlphaComponent(0.2))
        SVProgressHUD.setForegroundColor(UIColor.CustomColor.appColor)
        SVProgressHUD.setBackgroundColor(UIColor.white.withAlphaComponent(0.8))
        let size = DeviceType.IS_PAD ? CGSize(width: 150, height: 150) : CGSize(width: 75, height: 75)
        SVProgressHUD.setMinimumSize(size)
    }
    
    func setIQKeyboardManager() {
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().toolbarTintColor = UIColor.CustomColor.appColor
        IQKeyboardManager.shared().previousNextDisplayMode = .alwaysShow
        //IQKeyboardManager.shared().shouldShowTextFieldPlaceholder = false
        //IQKeyboardManager.shared().toolbarPreviousNextAllowedClasses.add(UIStackView.self)
        IQKeyboardManager.shared().shouldShowToolbarPlaceholder = false
    }
    
    func setupLocationManager() {
        let _ = LocationManager.init()
        //LocationManager.shared.startLocationTracking()
    }
    
    private func configureGoogle() {
        GMSPlacesClient.provideAPIKey(APIKeys.GooglePlaceAPIKey)
        GMSServices.provideAPIKey(APIKeys.GooglePlaceAPIKey)
        //GoogleApi.shared.initialiseWithKey(APIKeys.GooglePlaceAPIKey)
    }
}

// MARK: - Appearance
extension AppDelegate {
 
    // MARK: - Instance methods
    /**
     This method is used to set rootViewController
     */
    func clearUserDataForLogout() {
        //OnixNetwork.sharedInstance.currentUser = nil
        UserDefaults.isUserLogin = false
        UserModel.removeUserFromDefault()
        UserDefaults.isShowCreateJobTutorial = false
        UserDefaults.isShowCreateJobTutorial = true
    }
    
}
