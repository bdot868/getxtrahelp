//
//  SocialLoginManager.swift
//  iTemp
//
//  Created by Wdev3 on 09/12/20.
//  Copyright © 2020 APPLE. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import GoogleSignIn
import FirebaseAuth
import SVProgressHUD

class SocialLoginManager: NSObject {
    
    static let shared = SocialLoginManager()
    
    var viewController : UIViewController = UIViewController()
    var appnavigationcontroller : AppNavigationController?
    
    var locationname : String = ""
    var selectLat : Double = 0.0
    var selectLong : Double = 0.0
    
    //private let readPermissions: [ReadPermission] = [ .publicProfile, .email, .userFriends, .custom("user_posts") ]
    
    var onGetSuccessData: ((_ data : [String:Any])-> (Void))?
    
    func getLocation(){
        LocationManager.shared.getLocationUpdates { (manager, location) -> (Bool) in
            self.selectLat = location.coordinate.latitude
            self.selectLong = location.coordinate.longitude
            
            /*LuckyPaw.sharedInstance.getAddressFromLatLong(lat: self.selectLat, long: self.selectLong) { (str,country,state,city,street,zipcode) in
                LuckyPaw.sharedInstance.currentAddressString = str
                self.locationname = str
            }*/
            return true
        }
        
    }
    
    func loginTwitter(){
        /*var provider = OAuthProvider(providerID: "twitter.com")
        provider.customParameters = [
              "lang": "en",
              "client_id" : "QWdnRzNudGpvZnRYM0ZnbDdlOTE6MTpjaQ",
              "redirect_uri" : "https://xtrahelp.com"
              ]
        provider.getCredentialWith(nil) { credential, error in
              if error != nil {
                // Handle error.
              }
              if let cred = credential {
                Auth.auth().signIn(with: cred) { authResult, error in
                  if error != nil {
                    // Handle error.
                  }
                  // User is signed in.
                  // IdP data available in authResult.additionalUserInfo.profile.
                  // Twitter OAuth access token can also be retrieved by:
                  // authResult.credential.accessToken
                    print(authResult?.credential)
                   // print("Token : \(authResult?.credential.accessToken ?? "")")
                  // Twitter OAuth ID token can be retrieved by calling:
                  // authResult.credential.idToken
                    //print("iDToken : \(authResult?.credential.idToken ?? "")")
                  // Twitter OAuth secret can be retrieved by calling:
                  // authResult.credential.secret
                    //print("secret : \(authResult?.credential.secret ?? "")")
                }
              }
            }*/
        //TWTRTwitter. = self
        
        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
            SVProgressHUD.show()
            if (session != nil) {
                print("signed in as \(session?.userName)");
                let client = TWTRAPIClient.withCurrentUser()
                TWTRAPIClient.withCurrentUser().loadUser(withID: client.userID ?? "") { user, error in
                    if let userdata = user {
                        print(userdata.profileImageURL)
                        let name = (userdata.name).components(separatedBy: " ")
                        var fname : String = ""
                        var lname : String = ""
                        for i in stride(from: 0, to: name.count, by: 1) {
                            if i == 0 {
                                fname = name[i]
                            } else if i == 1 {
                                lname = name[i]
                            }
                        }
                        TWTRAPIClient.withCurrentUser().requestEmail { str, error in
                            SVProgressHUD.dismiss()
                            self.viewController.dismiss(animated: true, completion: nil)
                            if !(str?.isEmpty ?? false) {
                                self.socialLoginAPICall(firstname: fname, lastname: lname, email: str ?? "", authProvider: "twitter", socialuserid: userdata.userID)
                            } else {
                                print("error: \(error?.localizedDescription)")
                            }
                        }
                    } else {
                        SVProgressHUD.dismiss()
                        self.viewController.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                SVProgressHUD.dismiss()
                self.viewController.dismiss(animated: true, completion: nil)
                print("error: \(error?.localizedDescription)");
            }
        })
    }
    
    func loginWithGoogle(){
        
        let gidconfig = GIDConfiguration(clientID: FirebaseApp.app()?.options.clientID ?? "")
        GIDSignIn.sharedInstance.signIn(with: gidconfig, presenting: self.viewController) { user, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let auth = user?.authentication else { return }
            let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken ?? "", accessToken: auth.accessToken)
            Auth.auth().signIn(with: credentials) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    do {
                        try Auth.auth().signOut()
                    } catch {
                        print("Error")
                    }
                   
                    print("Login Successful.")
                    //This is where you should add the functionality of successful login
                    //i.e. dismissing this view or push the home view controller etc
                    let profiledata = authResult?.additionalUserInfo?.profile
                    
                    self.socialLoginAPICall(firstname: profiledata?["given_name"] as? String ?? "", lastname: profiledata?["family_name"] as? String ?? "", email: authResult?.user.email ?? "", authProvider: "google", socialuserid: authResult?.user.uid ?? "")
                }
            }
        }
    }
    
    func loginWithApple(){
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self.viewController as? ASAuthorizationControllerPresentationContextProviding
            authorizationController.performRequests()
            SVProgressHUD.show()
        } else {
            // Fallback on earlier versions
        }
    }
    
    func loginWithFacebook() {
        
        LoginManager().logOut()
        
        LoginManager().logIn(permissions: ["public_profile","email"], from: viewController) {[unowned self] (result, error) in
            guard error == nil else {
                //self.viewController.showAlert(with: error?.localizedDescription ?? "")
                self.viewController.showMessage(error?.localizedDescription ?? "", themeStyle: .warning)
                LoginManager().logOut()
                return
            }
            guard let loginResult = result, !loginResult.isCancelled, loginResult.grantedPermissions.contains("email") else {
                LoginManager().logOut()
                return
            }
            GraphRequest(graphPath:"me", parameters: ["fields":"id, email, first_name, last_name, picture"]).start(completionHandler: {[unowned self] (connection, result, error) in
                guard let dic = result as? [String:Any], error == nil else {
                    print(error?.localizedDescription ?? "")
                    return
                }
                print(dic)
                LoginManager().logOut()
                self.loginFacebookUser(with: dic)
            })
        }
    }
    
    func loginFacebookUser(with responseDic: [String:Any]){
        let firstName = responseDic["first_name"] as? String ?? ""
        let lastName = responseDic["last_name"] as? String ?? ""
        let email = responseDic["email"] as? String ?? ""
        let pictureDic = responseDic["picture"] as? [String:Any] ?? [:]
        let dataDic = pictureDic["data"] as? [String:Any] ?? [:]
        let profileURL = dataDic["url"] as? String ?? ""
        guard let facebookId = responseDic["id"] as? String else {
            self.viewController.showAlert(with: AppConstant.FailureMessage.kFbIdNotFound)
            return
        }
        
        self.socialLoginAPICall(firstname: firstName, lastname: lastName, email: email, authProvider: "facebook", socialuserid: facebookId)
        
    }
    
    private func socialLoginAPICall(firstname : String,lastname : String,email : String,authProvider : String,socialuserid : String){
        
        let dict : [String:Any] = [
            kauth_id : socialuserid,
            kauth_provider : authProvider,
            kdeviceToken : UserDefaults.setDeviceToken,
            klangType : XtraHelp.sharedInstance.languageType,
            kdeviceType : XtraHelp.sharedInstance.DeviceType,
            kdeviceId : XtraHelp.sharedInstance.deviceID,
            ktimeZone : XtraHelp.sharedInstance.localTimeZoneIdentifier,
            kEmail : email,
            krole : XtraHelp.sharedInstance.userRole,
            kisManualEmail : "0",
            kFirstName : firstname,
            kLastName :lastname,
            klocation : self.locationname
            //klatitude : self.selectLat,
            //klongitude : self.selectLong,
            //krole : LuckyPaw.sharedInstance.selectedUserType.rawValue
        ]
        
        let param : [String:Any] = [
            kData : dict
        ]
        
        //let email : String = dic[kEmail] as? String ?? ""
        
        UserModel.userSocialLogin(with: param, success: { (user, msg) in
           
            //UserDefaults.isUserLogin = true
            //self.showMessage(msg, themeStyle: .success)
            //WebSocketChat.shared.connectSocket()
           // if user.profileStatus == "0"{
                //self.appnavigationcontroller?.push(CompleteProfileViewController.self)
            //} else {
            UserDefaults.isUserLogin = true
            //self.appnavigationcontroller?.showDashBoardViewController()
            //}
            
            if user.profileStatus == .Default || user.profileStatus == .Subscription{
                /*self.appnavigationcontroller?.push(MembershipViewController.self,configuration: { (vc) in
                    vc.isFromLogin = true
                })
            } else if user.profileStatus == .Subscription {*/
                self.appnavigationcontroller?.push(SignupPersonalDetailViewController.self,animated: true,configuration: { (vc) in
                    vc.isFromLogin = true
                })
            } else if user.profileStatus == .PersonalDetails {
                self.appnavigationcontroller?.push(SignUpLicensesViewController.self,animated: true,configuration: { (vc) in
                    vc.isFromLogin = true
                })
            } else if user.profileStatus == .CertificationsLicenses {
                self.appnavigationcontroller?.push(SignupLocationViewController.self,animated: true,configuration: { (vc) in
                    vc.isFromLogin = true
                })
            } else if user.profileStatus == .YourAddress {
                self.appnavigationcontroller?.push(SignupWorkDetailViewController.self,animated: true,configuration: { (vc) in
                    vc.isFromLogin = true
                })
            } else if user.profileStatus == .WorkDetails {
                self.appnavigationcontroller?.push(SignUpInsuranceViewController.self,animated: true,configuration: { (vc) in
                    vc.isFromLogin = true
                })
            } else if user.profileStatus == .Insurance {
                self.appnavigationcontroller?.push(MyCalenderViewController.self,animated: true,configuration: { (vc) in
                    vc.isFromLogin = true
                })
            } else if user.profileStatus == .Insurance {
                self.appnavigationcontroller?.push(ProfileSuccessViewController.self,animated: true,configuration: { (vc) in
                    vc.isFromLogin = true
                })
            } else if user.profileStatus == .SetAvailabilityAndUnderReview {
                self.appnavigationcontroller?.push(ProfileSuccessViewController.self,animated: true,configuration: { (vc) in
                    vc.isFromLogin = true
                    vc.SuccessSignup = true
                })
            } else{
                
                WebSocketChat.shared.connectSocket()
                self.appnavigationcontroller?.showDashBoardViewController()
            }
           
        }, failure: {[unowned self] (statuscode,error, errorType) in
            print(error)
            if statuscode == APIStatusCode.verifyAcccout.rawValue {
                /*self.appnavigationcontroller?.detachLeftSideMenu()
                self.appnavigationcontroller?.push(VerificationViewController.self,configuration: { (vc) in
                    vc.userEmail = email
                })*/
                self.appnavigationcontroller?.detachLeftSideMenu()
                self.appnavigationcontroller?.push(VerificationViewController.self,configuration: { (vc) in
                    vc.userEmail = email
                    vc.isFromSignup = true
                })
            } else {
                if !error.isEmpty {
                    self.viewController.showMessage(error, themeStyle: .error)//showAlert(withTitle: errorType.rawValue, with: error)
                }
            }
        })
    }
}

/*extension SocialLoginManager : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let auth = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        Auth.auth().signIn(with: credentials) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                /*do {
                    try Auth.auth().signOut()
                } catch {
                    print("Error")
                }*/
               
                print("Login Successful.")
                //This is where you should add the functionality of successful login
                //i.e. dismissing this view or push the home view controller etc
                let profiledata = authResult?.additionalUserInfo?.profile
                
                self.socialLoginAPICall(firstname: profiledata?["given_name"] as? String ?? "", lastname: profiledata?["family_name"] as? String ?? "", email: authResult?.user.email ?? "", authProvider: "google", socialuserid: authResult?.user.uid ?? "")
            }
        }
    }
    
}*/

extension SocialLoginManager : TWTRComposerViewControllerDelegate {
    func composerDidCancel(_ controller: TWTRComposerViewController) {
        self.viewController.dismiss(animated: true, completion: nil)
    }
    
    func composerDidFail(_ controller: TWTRComposerViewController, withError error: Error) {
        self.viewController.dismiss(animated: true, completion: nil)
    }
    
    func composerDidSucceed(_ controller: TWTRComposerViewController, with tweet: TWTRTweet) {
        self.viewController.dismiss(animated: true, completion: nil)
    }
}

@available(iOS 13.0, *)
extension SocialLoginManager: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        //DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        //}
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            
            var name = String()
            if let givenName = fullName?.givenName {
                name = givenName
            }
            if let familyName = fullName?.familyName {
                name  = name + " " +  familyName
            }
            
            let appleUserFirstName = appleIDCredential.fullName?.givenName

            let appleUserLastName = appleIDCredential.fullName?.familyName

            let appleUserEmail = appleIDCredential.email
            
            
            print("First Name : \(appleUserFirstName ?? "")")
            print("Last Name : \(appleUserLastName ?? "")")
            print("Email : \(appleUserEmail ?? "")")
            
            if appleUserFirstName != nil && appleUserLastName != nil && appleUserEmail != nil && userIdentifier != "" {
                let dictionaryExample : [String:Any] = [kAppleSigninEmail : appleUserEmail ?? "",
                                                              kAppleSigninFirstName : appleUserFirstName ?? "",
                                                              kAppleSigninLastName : appleUserLastName ?? "",
                                                              kAppleSigninAppUserID : userIdentifier]
                do {
                    let dataExample : Data = try NSKeyedArchiver.archivedData(withRootObject: dictionaryExample, requiringSecureCoding: false)
                    let status = KeyChain.save(key: kAppleSigninUserData, data: dataExample as Data)
                    print("Sigin Status : \(status)")
                    
                    self.socialLoginAPICall(firstname: appleUserFirstName ?? "", lastname: appleUserLastName ?? "", email: appleUserEmail ?? "", authProvider: "apple", socialuserid: userIdentifier)
                    
                    
                } catch {
                    
                }
                
            } else {
                if let receivedData = KeyChain.load(key: kAppleSigninUserData) {
                    do{
                        let fetchValue = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(receivedData) as? NSDictionary ?? [:]
                        print(fetchValue)
                        let appuserID : String = fetchValue[kAppleSigninAppUserID] as? String ?? ""
                        let userFirstName : String = fetchValue[kAppleSigninFirstName] as? String ?? ""
                        let userLastName : String = fetchValue[kAppleSigninLastName] as? String ?? ""
                        let userEmail : String = fetchValue[kAppleSigninEmail] as? String ?? ""
                        
                        self.socialLoginAPICall(firstname: userFirstName, lastname: userLastName, email: userEmail, authProvider: "apple", socialuserid: appuserID)
                    }catch{
                        print("Unable to successfully convert NSData to NSDictionary")
                    }
                }
            }
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
                let alertController = UIAlertController(title: "Keychain Credential Received",
                                                        message: message,
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.viewController.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //print("AppleID Credential failed with error: \(error.localizedDescription)”)
        print("AppleID Credential failed with error: \(error.localizedDescription)")
        self.viewController.showMessage("AppleID Credential failed with error: \(error.localizedDescription)", themeStyle: .error)
        SVProgressHUD.dismiss()
    }
}
