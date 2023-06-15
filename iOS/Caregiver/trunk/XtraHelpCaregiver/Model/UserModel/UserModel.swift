//
//  UserModel.swift
//  OmApp
//
//  Created by KETAN SODVADIYA on 24/01/19.
//  Copyright © 2019 OM App. All rights reserved.
//

import UIKit
import SVProgressHUD
final class UserModel: NSObject,NSCoding {
    
    var profileStatus : ProfileStatusEnum
    var fillpassword : String
    var emergencyContact : String
    var contactPersonName : String
    var birthdate : String
    var id : String
    var LastName : String
    var deviceToken : String
    var country : String
    var stateName : String
    var stateId : String
    var zipcode : String
    
    var referralCode : String
    var location : String
    var timeZone : String
    var dob : String
    var FirstName : String
    var role : String
    var verificationCode : String
    var address : String
    var appNotification : String
    var email : String
    var image : String
    var deviceId : String
    var unitNo : String
    var name : String
    var forgotCode : String
    var longitude : String
    var cityName : String
    var cityId : String
    var deviceType : String
    var status : String
    var onsitePrice : String
    var activeStatus : String
    var profileimage : String
    var thumbprofileimage : String
    
    var gender : GenderEnum
    var token : String
    var age : String
    var userName : String
    var password : String
    var phone : String
    var latitude : String
    //var preferredLanguage : [LanguageModel]
    
    var hearAboutUsId : String
    var familyVaccinated : String
    var soonPlanningHireDate : String
    var isStripeConnect : String
    var isPayment : String
    var isPayout : String
    var isBankDetail : String
    //var soonPlanningHireDate : String*/
    
    var inboxMsgText : String
    var inboxMsgMail : String
    var jobMsgText : String
    var jobMsgMail : String
    var caregiverUpdateText : String
    var caregiverUpdateMail : String
    
    // MARK: - init
    init?(dictionary: [String:Any]) {
        
        //self.profileStatus = dictionary[kprofileStatus] as? String ?? ""
        self.fillpassword = dictionary[kfillpassword] as? String ?? ""
        self.emergencyContact = dictionary[kemergencyContact] as? String ?? ""
        self.contactPersonName = dictionary[kcontactPersonName] as? String ?? ""
        self.birthdate = dictionary[kbirthdate] as? String ?? ""
        self.id = dictionary[kid] as? String ?? ""
        self.LastName = dictionary[kLastName] as? String ?? ""
        self.deviceToken = dictionary[kdeviceToken] as? String ?? ""
        self.country = dictionary[kcountry] as? String ?? ""
        self.stateName = dictionary[kstateName] as? String ?? ""
        self.zipcode = dictionary[kzipcode] as? String ?? ""
        self.referralCode = dictionary[kreferralCode] as? String ?? ""
        self.location = dictionary[klocation] as? String ?? ""
        self.timeZone = dictionary[ktimeZone] as? String ?? ""
        self.dob = dictionary[kbirthdate] as? String ?? ""
        self.FirstName = dictionary[kFirstName] as? String ?? ""
        self.role = dictionary[krole] as? String ?? ""
        self.verificationCode = dictionary[kverificationCode] as? String ?? ""
        self.address = dictionary[kaddress] as? String ?? ""
        self.appNotification = dictionary[kappNotification] as? String ?? ""
        self.email = dictionary[kEmail] as? String ?? ""
        self.image = dictionary[kimage] as? String ?? ""
        self.deviceId = dictionary[kdeviceId] as? String ?? ""
        self.unitNo = dictionary[kunitNo] as? String ?? ""
        self.name = dictionary[kname] as? String ?? ""
        self.forgotCode = dictionary[kforgotCode] as? String ?? ""
        self.longitude = dictionary[klongitude] as? String ?? ""
        self.cityName = dictionary[kcityName] as? String ?? ""
        self.deviceType = dictionary[kdeviceType] as? String ?? ""
        self.status = dictionary[kstatus] as? String ?? ""
        self.onsitePrice = dictionary[konsitePrice] as? String ?? ""
        self.activeStatus = dictionary[kactiveStatus] as? String ?? ""
        self.profileimage = dictionary[kprofileimage] as? String ?? ""
        self.thumbprofileimage = dictionary[kthumbprofileimage] as? String ?? ""
        
        self.gender = GenderEnum(rawValue: (Int(dictionary[kgender] as? String ?? "0")) ?? 0) ?? .None
        self.profileStatus = ProfileStatusEnum(rawValue: (dictionary[kprofileStatus] as? String ?? "0")) ?? .Default
        
        self.token = dictionary[ktoken] as? String ?? ""
        self.age = dictionary[kage] as? String ?? ""
        self.userName = dictionary[kuserName] as? String ?? ""
        self.password = dictionary[kpassword] as? String ?? ""
        self.phone = dictionary[kphone] as? String ?? ""
        self.latitude = dictionary[klatitude] as? String ?? ""
        self.stateId = dictionary[kstateId] as? String ?? ""
        self.cityId = dictionary[kcityId] as? String ?? ""
        
        
        self.hearAboutUsId = dictionary[khearAboutUsId] as? String ?? ""
        self.familyVaccinated = dictionary[kfamilyVaccinated] as? String ?? ""
        self.soonPlanningHireDate = dictionary[ksoonPlanningHireDate] as? String ?? ""
        
        self.isStripeConnect = dictionary[kisStripeConnect] as? String ?? ""
        self.isPayment = dictionary[kisPayment] as? String ?? ""
        self.isPayout = dictionary[kisPayout] as? String ?? ""
        self.isBankDetail = dictionary[kisBankDetail] as? String ?? ""
        /*self.familyVaccinated = dictionary[kfamilyVaccinated] as? String ?? ""
        self.familyVaccinated = dictionary[kfamilyVaccinated] as? String ?? ""*/
        
        self.inboxMsgText = dictionary[kinboxMsgText] as? String ?? ""
        self.inboxMsgMail = dictionary[kinboxMsgMail] as? String ?? ""
        self.jobMsgText = dictionary[kjobMsgText] as? String ?? ""
        self.jobMsgMail = dictionary[kjobMsgMail] as? String ?? ""
        self.caregiverUpdateText = dictionary[kcaregiverUpdateText] as? String ?? ""
        self.caregiverUpdateMail = dictionary[kcaregiverUpdateMail] as? String ?? ""
    }
    
    // MARK: - NSCoding
    required init(coder aDecoder: NSCoder) {
        
        //self.profileStatus = aDecoder.decodeObject(forKey: kprofileStatus) as? String ?? ""
        self.fillpassword = aDecoder.decodeObject(forKey: kfillpassword) as? String ?? ""
        self.emergencyContact = aDecoder.decodeObject(forKey: kemergencyContact) as? String ?? ""
        self.contactPersonName = aDecoder.decodeObject(forKey: kcontactPersonName) as? String ?? ""
        self.birthdate = aDecoder.decodeObject(forKey: kbirthdate) as? String ?? ""
        self.id = aDecoder.decodeObject(forKey: kid) as? String ?? ""
        self.LastName = aDecoder.decodeObject(forKey: kLastName) as? String ?? ""
        self.deviceToken = aDecoder.decodeObject(forKey: kdeviceToken) as? String ?? ""
        self.country = aDecoder.decodeObject(forKey: kcountry)  as? String ?? ""
        self.stateName = aDecoder.decodeObject(forKey: kstateName)  as? String ?? ""
        self.zipcode = aDecoder.decodeObject(forKey: kzipcode)  as? String ?? ""
        self.referralCode = aDecoder.decodeObject(forKey: kreferralCode)  as? String ?? ""
        self.location = aDecoder.decodeObject(forKey: klocation)  as? String ?? ""
        self.timeZone = aDecoder.decodeObject(forKey: ktimeZone)  as? String ?? ""
        self.dob = aDecoder.decodeObject(forKey: kbirthdate)  as? String ?? ""
        self.FirstName = aDecoder.decodeObject(forKey: kFirstName)  as? String ?? ""
        self.role = aDecoder.decodeObject(forKey: krole)  as? String ?? ""
        self.verificationCode = aDecoder.decodeObject(forKey: kverificationCode)  as? String ?? ""
        self.address = aDecoder.decodeObject(forKey: kaddress)  as? String ?? ""
        self.appNotification = aDecoder.decodeObject(forKey: kappNotification)  as? String ?? ""
        self.email = aDecoder.decodeObject(forKey: kEmail)  as? String ?? ""
        self.image = aDecoder.decodeObject(forKey: kimage)  as? String ?? ""
        self.deviceId = aDecoder.decodeObject(forKey: kdeviceId)  as? String ?? ""
        self.unitNo = aDecoder.decodeObject(forKey: kunitNo)  as? String ?? ""
        self.name = aDecoder.decodeObject(forKey: kname)  as? String ?? ""
        self.forgotCode = aDecoder.decodeObject(forKey: kforgotCode)  as? String ?? ""
        self.longitude = aDecoder.decodeObject(forKey: klongitude)  as? String ?? ""
        self.cityName = aDecoder.decodeObject(forKey: kcityName)  as? String ?? ""
        self.deviceType = aDecoder.decodeObject(forKey: kdeviceType)  as? String ?? ""
        self.status = aDecoder.decodeObject(forKey: kstatus)  as? String ?? ""
        self.onsitePrice = aDecoder.decodeObject(forKey: konsitePrice)  as? String ?? ""
        self.activeStatus = aDecoder.decodeObject(forKey: kactiveStatus)  as? String ?? ""
        self.profileimage = aDecoder.decodeObject(forKey: kprofileimage)  as? String ?? ""
        self.thumbprofileimage = aDecoder.decodeObject(forKey: kthumbprofileimage)  as? String ?? ""
        
        self.token = aDecoder.decodeObject(forKey: ktoken)  as? String ?? ""
        self.age = aDecoder.decodeObject(forKey: kage)  as? String ?? ""
        self.userName = aDecoder.decodeObject(forKey: kuserName)  as? String ?? ""
        self.password = aDecoder.decodeObject(forKey: kpassword)  as? String ?? ""
        self.phone = aDecoder.decodeObject(forKey: kphone)  as? String ?? ""
        self.latitude = aDecoder.decodeObject(forKey: klatitude)  as? String ?? ""
        self.stateId = aDecoder.decodeObject(forKey: kstateId)  as? String ?? ""
        self.cityId = aDecoder.decodeObject(forKey: kcityId)  as? String ?? ""
        
        self.gender = GenderEnum(rawValue: (Int(aDecoder.decodeObject(forKey: kgender) as? String ?? "0")) ?? 0) ?? .None
        self.profileStatus = ProfileStatusEnum(rawValue: (aDecoder.decodeObject(forKey: kprofileStatus) as? String ?? "0")) ?? .Default
        
        self.hearAboutUsId = aDecoder.decodeObject(forKey: khearAboutUsId)  as? String ?? ""
        self.familyVaccinated = aDecoder.decodeObject(forKey: kfamilyVaccinated)  as? String ?? ""
        self.soonPlanningHireDate = aDecoder.decodeObject(forKey: ksoonPlanningHireDate)  as? String ?? ""
        
        self.isStripeConnect = aDecoder.decodeObject(forKey: kisStripeConnect)  as? String ?? ""
        self.isPayment = aDecoder.decodeObject(forKey: kisPayment)  as? String ?? ""
        self.isPayout = aDecoder.decodeObject(forKey: kisPayout)  as? String ?? ""
        self.isBankDetail = aDecoder.decodeObject(forKey: kisBankDetail)  as? String ?? ""
        
        self.inboxMsgText = aDecoder.decodeObject(forKey: kinboxMsgText)  as? String ?? ""
        self.inboxMsgMail = aDecoder.decodeObject(forKey: kinboxMsgMail)  as? String ?? ""
        self.jobMsgText = aDecoder.decodeObject(forKey: kjobMsgText)  as? String ?? ""
        self.jobMsgMail = aDecoder.decodeObject(forKey: kjobMsgMail)  as? String ?? ""
        self.caregiverUpdateText = aDecoder.decodeObject(forKey: kcaregiverUpdateText)  as? String ?? ""
        self.caregiverUpdateMail = aDecoder.decodeObject(forKey: kcaregiverUpdateMail)  as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        //aCoder.encode(profileStatus, forKey: kprofileStatus)
        aCoder.encode(fillpassword, forKey: kfillpassword)
        aCoder.encode(emergencyContact, forKey: kemergencyContact)
        aCoder.encode(contactPersonName, forKey: kcontactPersonName)
        aCoder.encode(birthdate, forKey: kbirthdate)
        aCoder.encode(id, forKey: kid)
        aCoder.encode(LastName, forKey: kLastName)
        aCoder.encode(deviceToken, forKey: kdeviceToken)
        aCoder.encode(country, forKey: kcountry)
        aCoder.encode(stateName, forKey: kstateName)
        aCoder.encode(zipcode, forKey: kzipcode)
        aCoder.encode(referralCode, forKey: kreferralCode)
        aCoder.encode(location, forKey: klocation)
        aCoder.encode(timeZone, forKey: ktimeZone)
        aCoder.encode(dob, forKey: kbirthdate)
        aCoder.encode(FirstName, forKey: kFirstName)
        aCoder.encode(role, forKey: krole)
        aCoder.encode(verificationCode, forKey: kverificationCode)
        aCoder.encode(address, forKey: kaddress)
        aCoder.encode(appNotification, forKey: kappNotification)
        aCoder.encode(email, forKey: kEmail)
        aCoder.encode(image, forKey: kimage)
        aCoder.encode(deviceId, forKey: kdeviceId)
        aCoder.encode(unitNo, forKey: kunitNo)
        aCoder.encode(name, forKey: kname)
        aCoder.encode(forgotCode, forKey: kforgotCode)
        aCoder.encode(longitude, forKey: klongitude)
        aCoder.encode(cityName, forKey: kcityName)
        aCoder.encode(deviceType, forKey: kdeviceType)
        aCoder.encode(status, forKey: kstatus)
        aCoder.encode(onsitePrice, forKey: konsitePrice)
        aCoder.encode(activeStatus, forKey: kactiveStatus)
        aCoder.encode(profileimage, forKey: kprofileimage)
        aCoder.encode(thumbprofileimage, forKey: kthumbprofileimage)
        aCoder.encode(gender.apiValue, forKey: kgender)
        aCoder.encode(profileStatus.apiValue, forKey: kprofileStatus)
        
        
        aCoder.encode(token, forKey: ktoken)
        aCoder.encode(age, forKey: kage)
        aCoder.encode(userName, forKey: kuserName)
        aCoder.encode(password, forKey: kpassword)
        aCoder.encode(phone, forKey: kphone)
        aCoder.encode(latitude, forKey: klatitude)
        aCoder.encode(stateId, forKey: kstateId)
        aCoder.encode(cityId, forKey: kcityId)
        
        aCoder.encode(hearAboutUsId, forKey: khearAboutUsId)
        aCoder.encode(familyVaccinated, forKey: kfamilyVaccinated)
        aCoder.encode(soonPlanningHireDate, forKey: ksoonPlanningHireDate)
        
        aCoder.encode(isStripeConnect, forKey: kisStripeConnect)
        aCoder.encode(isPayment, forKey: kisPayment)
        aCoder.encode(isPayout, forKey: kisPayout)
        aCoder.encode(isBankDetail, forKey: kisBankDetail)
        
        aCoder.encode(inboxMsgText, forKey: kinboxMsgText)
        aCoder.encode(inboxMsgMail, forKey: kinboxMsgMail)
        aCoder.encode(jobMsgText, forKey: kjobMsgText)
        aCoder.encode(jobMsgMail, forKey: kjobMsgMail)
        aCoder.encode(caregiverUpdateText, forKey: kcaregiverUpdateText)
        aCoder.encode(caregiverUpdateMail, forKey: kcaregiverUpdateMail)
    }
    
    //Save user object in UserDefault
    func saveCurrentUserInDefault() {
        do {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
            UserDefaults.standard.set(encodedData, forKey: UserDefaultsKey.kLoginUser)
        } catch {
            print("Not found")
        }
    }
    
    //Get user object from UserDefault
    class func getCurrentUserFromDefault() -> UserModel? {
        do {
            
            if let decoded  = UserDefaults.standard.data(forKey: UserDefaultsKey.kLoginUser),      let user = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as? UserModel {
                return user
            }
        } catch {
            print("Couldn't read file.")
            return nil
        }
        return nil
    }
    
    //Remove user object from UserDefault
    class func removeUserFromDefault() {
        UserDefaults.standard.set(nil, forKey: UserDefaultsKey.kLoginUser)
    }
    
    //Save user VOIP token in UserDefault
    class func saveVoipTokenInDefault(token: String) {
        UserDefaults.standard.set(token, forKey: UserDefaultsKey.kVoipToken)
        UserDefaults.standard.synchronize()
    }
    
    class func getVoipToken() -> String?{
        return getValueFromNSUserDefaults(key: UserDefaultsKey.kVoipToken) as? String
    }
    
    // MARK: - API call
    class func userLogin(with param: [String:Any]?, success withResponse: @escaping (_ user: UserModel, _ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kLogin, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess,let dataDict = dict[kData] as? [String:Any], let user = UserModel(dictionary: dataDict) {
                user.saveCurrentUserInDefault()
                
                WebSocketChat.shared.isSocketConnected = false
                WebSocketChat.shared.connectSocket()
                
                withResponse(user, message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func userSocialLogin(with param: [String:Any]?, success withResponse: @escaping (_ user: UserModel, _ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.ksocialLogin, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess,let dataDict = dict[kData] as? [String:Any], let user = UserModel(dictionary: dataDict) {
                user.saveCurrentUserInDefault()
                
                WebSocketChat.shared.isSocketConnected = false
                WebSocketChat.shared.connectSocket()
                
                withResponse(user, message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func checkforgotVerificationCode(with param: [String:Any]?, success withResponse: @escaping (_ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kcheckForgotCode, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess {
                
                withResponse(message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func registerUser(withParam param: [String:Any], success withResponse: @escaping (_ user: UserModel, _ strMessage : String) -> (), failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kRegisterUser, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess,let dataDict = dict[kData] as? [String:Any], let user = UserModel(dictionary: dataDict) {
                UserDefaults.isUserLogin = true
                user.saveCurrentUserInDefault()
                
                withResponse(user, message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func verifyCode(with param: [String:Any]?, success withResponse: @escaping (_ user: UserModel, _ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kverify, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess,let dataDict = dict[kData] as? [String:Any], let user = UserModel(dictionary: dataDict) {
                UserDefaults.isUserLogin = true
                user.saveCurrentUserInDefault()
                
                WebSocketChat.shared.isSocketConnected = false
                WebSocketChat.shared.connectSocket()
                
                withResponse(user, message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func GetProfileUser(with param: [String:Any]?, success withResponse: @escaping (_ user: UserModel, _ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kGetProfile, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess,let dataDict = dict[kData] as? [String:Any], let user = UserModel(dictionary: dataDict) {
                var token = ""
                if let u = UserModel.getCurrentUserFromDefault() {
                    token = u.token
                }
                
                user.saveCurrentUserInDefault()
                
                if let userdata = UserModel.getCurrentUserFromDefault(){
                    if userdata.token == "" {
                        userdata.token = token
                        userdata.saveCurrentUserInDefault()
                    }
                }
                
                withResponse(user, message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func saveSignupProfileDetails(with param: [String:Any]?,type : ProfileStatusEnum, success withResponse: @escaping (_ user: UserModel, _ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        var url = AppConstant.API.ksavePersonalDetails
        switch type {
        case .Default:
            break
        case .Subscription:
            url = AppConstant.API.ksavePersonalDetails
        case .PersonalDetails:
            url = AppConstant.API.ksavePersonalDetails
        case .CertificationsLicenses:
            url = AppConstant.API.ksaveCertificationsLicenses
        case .YourAddress:
            url = AppConstant.API.ksaveAddressOrLocation
        case .WorkDetails:
            url = AppConstant.API.ksaveWorkDetails
        case .Insurance:
            url = AppConstant.API.ksaveInsurance
        case .SetAvailabilityAndUnderReview:
            url = AppConstant.API.ksaveCaregiverAvailabilitySetting
        case .ReviewAndAccepted:
            url = AppConstant.API.ksavePersonalDetails
        }
        
        APIManager.makeRequest(with: url, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess,let dataDict = dict[kData] as? [String:Any], let user = UserModel(dictionary: dataDict) {
                var token = ""
                if let u = UserModel.getCurrentUserFromDefault() {
                    token = u.token
                }
                
                user.saveCurrentUserInDefault()
                
                if let userdata = UserModel.getCurrentUserFromDefault(){
                    if userdata.token == "" {
                        userdata.token = token
                        userdata.saveCurrentUserInDefault()
                    }
                }
                
                withResponse(user, message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func savePersonalDetails(with param: [String:Any]?, success withResponse: @escaping (_ user: UserModel, _ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.ksavePersonalDetails, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess,let dataDict = dict[kData] as? [String:Any], let user = UserModel(dictionary: dataDict) {
                var token = ""
                if let u = UserModel.getCurrentUserFromDefault() {
                    token = u.token
                }
                
                user.saveCurrentUserInDefault()
                
                if let userdata = UserModel.getCurrentUserFromDefault(){
                    if userdata.token == "" {
                        userdata.token = token
                        userdata.saveCurrentUserInDefault()
                    }
                }
                
                withResponse(user, message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func saveCertificationsLicenses(with param: [String:Any]?, success withResponse: @escaping (_ user: UserModel, _ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.ksaveCertificationsLicenses, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess,let dataDict = dict[kData] as? [String:Any], let user = UserModel(dictionary: dataDict) {
                var token = ""
                if let u = UserModel.getCurrentUserFromDefault() {
                    token = u.token
                }
                
                user.saveCurrentUserInDefault()
                
                if let userdata = UserModel.getCurrentUserFromDefault(){
                    if userdata.token == "" {
                        userdata.token = token
                        userdata.saveCurrentUserInDefault()
                    }
                }
                
                withResponse(user, message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func saveAddressOrLocation(with param: [String:Any]?, success withResponse: @escaping (_ user: UserModel, _ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.ksaveAddressOrLocation, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess,let dataDict = dict[kData] as? [String:Any], let user = UserModel(dictionary: dataDict) {
                var token = ""
                if let u = UserModel.getCurrentUserFromDefault() {
                    token = u.token
                }
                
                user.saveCurrentUserInDefault()
                
                if let userdata = UserModel.getCurrentUserFromDefault(){
                    if userdata.token == "" {
                        userdata.token = token
                        userdata.saveCurrentUserInDefault()
                    }
                }
                
                withResponse(user, message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func saveWorkDetails(with param: [String:Any]?, success withResponse: @escaping (_ user: UserModel, _ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.ksaveWorkDetails, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess,let dataDict = dict[kData] as? [String:Any], let user = UserModel(dictionary: dataDict) {
                var token = ""
                if let u = UserModel.getCurrentUserFromDefault() {
                    token = u.token
                }
                
                user.saveCurrentUserInDefault()
                
                if let userdata = UserModel.getCurrentUserFromDefault(){
                    if userdata.token == "" {
                        userdata.token = token
                        userdata.saveCurrentUserInDefault()
                    }
                }
                
                withResponse(user, message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func updateProfileStatus(with param: [String:Any]?, success withResponse: @escaping (_ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kupdateProfileStatus, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess {
                
                withResponse(message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func SaveProfileUser(with param: [String:Any]?, success withResponse: @escaping (_ user: UserModel, _ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kUpdateUserProfile, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess,let dataDict = dict[kData] as? [String:Any], let user = UserModel(dictionary: dataDict) {
                var token = ""
                if let u = UserModel.getCurrentUserFromDefault() {
                    token = u.token
                }
                
                user.saveCurrentUserInDefault()
                
                if let userdata = UserModel.getCurrentUserFromDefault(){
                    if userdata.token == "" {
                        userdata.token = token
                        userdata.saveCurrentUserInDefault()
                    }
                }
                
                withResponse(user, message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func uploadMedia(with param : [String:Any]?,image: UIImage?, success withResponse: @escaping (_ msg : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        
        APIManager.makeMultipartFormDataRequest(AppConstant.API.kmediaUpload,image: image, imageName: kfiles, withParameter: param, withSuccess: { (response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if isSuccess,let dataDict = dict[kData] as? [[String:Any]]{
                
                if let first = dataDict.first {
                    let msg = first[kmediaName] as? String ?? ""
                    withResponse(msg)
                } else {
                    failure(statuscode,message, .response)
                }
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func uploadCertificateMedia(with param : [String:Any]?,image: UIImage?, success withResponse: @escaping (_ certificateName : String,_ certificateURL : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        
        APIManager.makeMultipartFormDataRequest(AppConstant.API.kmediaUpload,image: image, imageName: kfiles, withParameter: param, withSuccess: { (response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if isSuccess,let dataDict = dict[kData] as? [[String:Any]]{
                
                if let first = dataDict.first {
                    let msg = first[kmediaName] as? String ?? ""
                    let cerurl = first[kmediaBaseUrl] as? String ?? ""
                    withResponse(msg,cerurl)
                } else {
                    failure(statuscode,message, .response)
                }
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func uploadPDFMedia(with param : [String:Any]?,pdfdata: Data?, success withResponse: @escaping (_ medianame : String,_ mediaURL : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        
        APIManager.makePDFMultipartFormDataRequest(AppConstant.API.kmediaUpload,pdfdata: pdfdata, pdfkeyName: kfiles, withParameter: param, withSuccess: { (response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if isSuccess,let dataDict = dict[kData] as? [[String:Any]]{
                
                if let first = dataDict.first {
                    if let first = dataDict.first {
                        let medianame = first[kmediaName] as? String ?? ""
                        let mediaurl = first[kmediaBaseUrl] as? String ?? ""
                        withResponse(medianame,mediaurl)
                    } else {
                        failure(statuscode,message, .response)
                    }
                } else {
                    failure(statuscode,message, .response)
                }
                
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func logoutUser(with param: [String:Any]?, success withResponse: @escaping (_ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.klogout, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue || statuscode == APIStatusCode.AuthTokenInvalied.rawValue) ? true : false
            if  isSuccess {
                self.removeUserFromDefault()
                withResponse(message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func changePassword(with param: [String:Any]?, success withResponse: @escaping (_ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kChangePassword, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess {
                withResponse(message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func forgotPassword(with param: [String:Any]?, success withResponse: @escaping (_ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kforgotPassword, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess {
                withResponse(message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func resendVerificationCode(with param: [String:Any]?, success withResponse: @escaping (_ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kresendVerification, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess {
                
                withResponse(message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func setAppFeedback(with param: [String:Any]?, success withResponse: @escaping (_ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.ksetAppFeedback, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess {
                withResponse(message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    class func resetPassword(with param: [String:Any]?, success withResponse: @escaping (_ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kresetPassword, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess {
                withResponse(message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func updateVOIPToken(with param: [String:Any]?, success withResponse: @escaping (_ strMessage : String) -> Void, failure: @escaping FailureBlock) {
        
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.ksetVoipToken_URL, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess {
                
                withResponse(message)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func generateAccessTokenVOIP(with param: [String:Any]?, success withResponse: @escaping (_ strMessage : String,_ senderdata : SenderReceiverDataModel,_ roomid : String) -> Void, failure: @escaping FailureBlock) {
        
        
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kgenerateAccessToken_URL, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if  isSuccess,let dataDict = dict[kData] as? [String:Any], let senderreciverdata = SenderReceiverDataModel(dict: dataDict) {
                let roomid : String = dataDict[kroom_name] as? String ?? ""
                withResponse(message,senderreciverdata,roomid)
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func getCaregiverAvailabilitySetting(with param: [String:Any]?, success withResponse: @escaping (_ arrAvalibility: [AvailibilitySettingTimeModel],_ arrAvailibilitytimeoff : [AvailabilityTimeOffModel]) -> Void, failure: @escaping FailureBlock) {
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kgetCaregiverAvailabilitySetting, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            
            if  isSuccess,let dataDict = dict[kData] as? [String:Any] {
                let arrAvailibility = (dataDict[kavailabilitySetting] as? [[String:Any]] ?? []).compactMap(AvailibilitySettingTimeModel.init)
                let arrTimeoff = (dataDict[ktimeOff] as? [[String:Any]] ?? []).compactMap(AvailabilityTimeOffModel.init)
                withResponse(arrAvailibility,arrTimeoff)
            } else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func saveCaregiverAvailability(with param: [String:Any]?, success withResponse: @escaping (_ msg: String) -> Void, failure: @escaping FailureBlock) {
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.ksaveCaregiverAvailability, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            
            if  isSuccess {
                withResponse(message)
            } else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func uploadFeedMedia(with param : [String:Any]?,image: UIImage?, success withResponse: @escaping (_ certificateName : String,_ certificateURL : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        
        APIManager.makeMultipartFormDataRequest(AppConstant.API.kmediaUpload,image: image, imageName: kfiles, withParameter: param, withSuccess: { (response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            if isSuccess,let dataDict = dict[kData] as? [[String:Any]]{
                
                if let first = dataDict.first {
                    let msg = first[kmediaName] as? String ?? ""
                    let cerurl = first[kmediaBaseUrl] as? String ?? ""
                    withResponse(msg,cerurl)
                } else {
                    failure(statuscode,message, .response)
                }
            }
            else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
    
    class func removeSingleAvailability(with param: [String:Any]?, success withResponse: @escaping (_ msg: String) -> Void, failure: @escaping FailureBlock) {
        SVProgressHUD.show()
        APIManager.makeRequest(with: AppConstant.API.kremoveSingleAvailabilityNew, method: .post, parameter: param, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            let message = dict[kMessage] as? String ?? ""
            let statuscode = dict[kstatus] as? String ?? "0"
            let isSuccess : Bool = (statuscode == APIStatusCode.success.rawValue ? true : false)
            
            if  isSuccess {
                withResponse(message)
            } else {
                failure(statuscode,message, .response)
            }
        }, failure: { (error) in
            SVProgressHUD.dismiss()
            failure("0",error, .server)
        }, connectionFailed: { (connectionError) in
            SVProgressHUD.dismiss()
            failure("0",connectionError, .connection)
        })
    }
}
