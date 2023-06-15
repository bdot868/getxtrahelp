//
//  APIManager.swift
//  Momentor
//
//  Created by mac on 16/01/2020.
//  Copyright © 2019 Differenzsystem Pvt. LTD. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SystemConfiguration

class APIManager: NSObject {
    
    static let sharedInstance = APIManager()
    //private var alamofireManager = AF.SessionManager.default
    
    override init() {
        
    }
    
    // MARK: - Check for internet connection
    
    /**
     This method is used to check internet connectivity.
     - Returns: Return boolean value to indicate device is connected with internet or not
     */
    
    
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    /**
     This method is used to make Alamofire request with or without parameters.
     - Parameters:
     - url: URL of request
     - method: HTTPMethod of request
     - parameter: Parameter of request
     - success: Success closure of method
     - response: Response object of request
     - failure: Failure closure of method
     - error: Failure error
     - connectionFailed: Network connection faild closure of method
     - error: Network error
     */
    
    class func makeRequest(with url: String, method: Alamofire.HTTPMethod, parameter: [String:Any]?, success: @escaping (_ response: Any?) -> Void, failure: @escaping (_ error: String) -> Void, connectionFailed: @escaping (_ error: String) -> Void) {
        
        if(isConnectedToNetwork()) {
            print(method.rawValue, url)
            if let param = parameter, let data = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted) {
                print(String(data: data, encoding: .utf8) ?? "Nil Param")
            }
            var headers: HTTPHeaders = []
            if let user = UserModel.getCurrentUserFromDefault() {
                headers["Content-Type"] = "application/json"
                //headers[kAccessToken] = user.authentication
                //print("Header = [Token : \(user.authentication)]")
            }
            
            AF.request(url, method: method, parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                
                switch (response.result) {
                case .success(let value):
                    if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) {
                        print("Response: \n",String(data: jsonData, encoding: String.Encoding.utf8) ?? "nil")
                    }
                    if let sreturnResponse = value as? [String:Any],let tokenexpire = sreturnResponse[kstatus] as? String{
                        if (tokenexpire == APIStatusCode.AuthTokenInvalied.rawValue || tokenexpire == APIStatusCode.blocked.rawValue) && (!(url.contains("auth/login")) || !(url.contains("auth/socialLogin"))){
                            let msg = sreturnResponse[kMessage] as? String ?? ""
                            //kAppDelegate.showSessionExpireAlert(msg: msg)
                            NotificationCenter.default.post(name:NSNotification.Name(rawValue: NotificationPostname.KAuthenticationTokenExpire), object: msg)
                            //success(nil)
                        } else {
                            success(value)
                        }
                    } else {
                        success(value)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    print(error)
                    failure(error.localizedDescription)
                }
            }
        }
        else {
            connectionFailed(AppConstant.FailureMessage.kNoInternetConnection)
        }
    }
    
    
    
    // MARK: Call API to upload Single image with request data
    class func makeMultipartFormDataRequest(_ URLString: String,image : UIImage?, imageName: String, withParameter parameter: [String: Any]?, withSuccess success: @escaping (_ responseDictionary: Any) -> Void, failure: @escaping (_ error: String) -> Void, connectionFailed: @escaping (_ error: String) -> Void){
        
        if(isConnectedToNetwork())
        {
            let url = URL(string:URLString)!
            print(url)
            
            if let param = parameter, let data = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted) {
                print(String(data: data, encoding: .utf8) ?? "Nil Param")
            }
            
            var jsonString = ""
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameter ?? [:], options: JSONSerialization.WritingOptions.prettyPrinted)
                jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
                print(jsonString)
            } catch let error as NSError {
                print(error)
            }
            
            
            var headers: HTTPHeaders = []
            if let user = UserModel.getCurrentUserFromDefault() {
                headers["Content-Type"] = "application/json"
                //headers[kAccessToken] = user.authentication
                //headers = [kAccessToken : user.accessToken,
                //         "Content-Type" : "application/json"]
                /*if let jsonData = try? JSONSerialization.data(withJSONObject: headers, options: .prettyPrinted) {
                 print("Headers: \n",String(data: jsonData, encoding: String.Encoding.utf8) ?? "nil")
                 }*/
                //print("Access Token : \(user.authentication)")
            }
            
            AF.upload(
                multipartFormData: { multipartFormData in
                    //multipartFormData.append((image?.jpegData(compressionQuality: 0.5)!)!, withName: "upload_data" , fileName: "file.jpeg", mimeType: "image/jpeg")
                    if let img = image, let imageData = img.jpegData(compressionQuality: 0.9) {
                        multipartFormData.append(imageData, withName: imageName, fileName: "temp.jpg", mimeType: "image/jpg")
                    }
                    for (key, value) in parameter ?? [:] {
                        if value is String || value is Int {
                            multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                        }
                    }
            },
                to: url, method: .post , headers: headers)
                .responseJSON { resp in
                    //print(resp)
                    switch resp.result {
                    case .success(let value):
                        
                        if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) {
                            print("Response: \n",String(data: jsonData, encoding: String.Encoding.utf8) ?? "nil")
                        }
                        if let sreturnResponse = value as? [String:Any],let tokenexpire = sreturnResponse[kstatus] as? String{
                            if tokenexpire == APIStatusCode.AuthTokenInvalied.rawValue || tokenexpire == APIStatusCode.blocked.rawValue {
                                let msg = sreturnResponse[kMessage] as? String ?? ""
                                //kAppDelegate.showSessionExpireAlert(msg: msg)
                                NotificationCenter.default.post(name:NSNotification.Name(rawValue: NotificationPostname.KAuthenticationTokenExpire), object: msg)
                            }
                        }
                        success(value)
                    case .failure(let encodingError):
                        print(encodingError)
                        failure(encodingError.localizedDescription)
                    }
                    
            }
        }
        else
        {
            connectionFailed(AppConstant.FailureMessage.kNoInternetConnection)
        }
    }
    
    // MARK: Call API to upload Single image with request data
    class func makePDFMultipartFormDataRequest(_ URLString: String,pdfdata : Data?, pdfkeyName: String, withParameter parameter: [String: Any]?, withSuccess success: @escaping (_ responseDictionary: Any) -> Void, failure: @escaping (_ error: String) -> Void, connectionFailed: @escaping (_ error: String) -> Void){
        
        if(isConnectedToNetwork())
        {
            let url = URL(string:URLString)!
            print(url)
            
            if let param = parameter, let data = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted) {
                print(String(data: data, encoding: .utf8) ?? "Nil Param")
            }
            
            var jsonString = ""
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameter ?? [:], options: JSONSerialization.WritingOptions.prettyPrinted)
                jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
                print(jsonString)
            } catch let error as NSError {
                print(error)
            }
            
            
            var headers: HTTPHeaders = []
            if let user = UserModel.getCurrentUserFromDefault() {
                headers["Content-Type"] = "application/json"
                //headers[kAccessToken] = user.authentication
                //headers = [kAccessToken : user.accessToken,
                //         "Content-Type" : "application/json"]
                /*if let jsonData = try? JSONSerialization.data(withJSONObject: headers, options: .prettyPrinted) {
                 print("Headers: \n",String(data: jsonData, encoding: String.Encoding.utf8) ?? "nil")
                 }*/
                //print("Access Token : \(user.authentication)")
            }
            
            AF.upload(
                multipartFormData: { multipartFormData in
                    //multipartFormData.append((image?.jpegData(compressionQuality: 0.5)!)!, withName: "upload_data" , fileName: "file.jpeg", mimeType: "image/jpeg")
                    if let img = pdfdata {
                        multipartFormData.append(img, withName: pdfkeyName, fileName: "temp.pdf", mimeType: "application/pdf")
                    }
                    for (key, value) in parameter ?? [:] {
                        if value is String || value is Int {
                            multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                        }
                    }
            },
                to: url, method: .post , headers: headers)
                .responseJSON { resp in
                    //print(resp)
                    switch resp.result {
                    case .success(let value):
                        
                        if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) {
                            print("Response: \n",String(data: jsonData, encoding: String.Encoding.utf8) ?? "nil")
                        }
                        if let sreturnResponse = value as? [String:Any],let tokenexpire = sreturnResponse[kstatus] as? String{
                            if tokenexpire == APIStatusCode.AuthTokenInvalied.rawValue || tokenexpire == APIStatusCode.blocked.rawValue {
                                let msg = sreturnResponse[kMessage] as? String ?? ""
                                //kAppDelegate.showSessionExpireAlert(msg: msg)
                                NotificationCenter.default.post(name:NSNotification.Name(rawValue: NotificationPostname.KAuthenticationTokenExpire), object: msg)
                            }
                        }
                        success(value)
                    case .failure(let encodingError):
                        print(encodingError)
                        failure(encodingError.localizedDescription)
                    }
                    
            }
        }
        else
        {
            connectionFailed(AppConstant.FailureMessage.kNoInternetConnection)
        }
    }
    
    // MARK: Call API to upload Single image with request data
    class func makeMultipartFormDataVideoRequest(_ URLString: String,videodata : NSData?, videoName: String,image : UIImage?, imageName: String, withParameter parameter: [String: Any]?, withSuccess success: @escaping (_ responseDictionary: Any) -> Void, failure: @escaping (_ error: String) -> Void, connectionFailed: @escaping (_ error: String) -> Void){
        
        if(isConnectedToNetwork())
        {
            let url = URL(string:URLString)!
            print(url)
            
            if let param = parameter, let data = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted) {
                print(String(data: data, encoding: .utf8) ?? "Nil Param")
            }
            
            var jsonString = ""
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameter ?? [:], options: JSONSerialization.WritingOptions.prettyPrinted)
                jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!
                print(jsonString)
            } catch let error as NSError {
                print(error)
            }
            
            
            var headers: HTTPHeaders = []
            if let user = UserModel.getCurrentUserFromDefault() {
                headers["Content-Type"] = "application/json"
                //headers[kAccessToken] = user.authentication
                //headers = [kAccessToken : user.accessToken,
                //         "Content-Type" : "application/json"]
                /*if let jsonData = try? JSONSerialization.data(withJSONObject: headers, options: .prettyPrinted) {
                 print("Headers: \n",String(data: jsonData, encoding: String.Encoding.utf8) ?? "nil")
                 }*/
                //print("Access Token : \(user.authentication)")
            }
            
            AF.upload(
                multipartFormData: { multipartFormData in
                    //multipartFormData.append((image?.jpegData(compressionQuality: 0.5)!)!, withName: "upload_data" , fileName: "file.jpeg", mimeType: "image/jpeg")
                    /*if let img = image, let imageData = img.jpegData(compressionQuality: 0.6) {
                        multipartFormData.append(imageData, withName: imageName, fileName: "temp.jpg", mimeType: "image/jpg")
                    }*/
                    if let vdata = videodata {
                        multipartFormData.append(vdata as Data, withName: videoName, fileName: "video.mp4", mimeType: "video/mp4")
                    }
                    if let img = image, let imageData = img.jpegData(compressionQuality: 0.9) {
                        multipartFormData.append(imageData, withName: imageName, fileName: "temp.jpg", mimeType: "image/jpg")
                    }
                    for (key, value) in parameter ?? [:] {
                        if value is String || value is Int {
                            multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                        }
                    }
            },
                to: url, method: .post , headers: headers)
                .responseJSON { resp in
                    //print(resp)
                    switch resp.result {
                    case .success(let value):
                        
                        if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) {
                            print("Response: \n",String(data: jsonData, encoding: String.Encoding.utf8) ?? "nil")
                        }
                        if let sreturnResponse = value as? [String:Any],let tokenexpire = sreturnResponse[kstatus] as? String{
                            if tokenexpire == APIStatusCode.AuthTokenInvalied.rawValue || tokenexpire == APIStatusCode.blocked.rawValue {
                                let msg = sreturnResponse[kMessage] as? String ?? ""
                                //kAppDelegate.showSessionExpireAlert(msg: msg)
                                NotificationCenter.default.post(name:NSNotification.Name(rawValue: NotificationPostname.KAuthenticationTokenExpire), object: msg)
                            }
                        }
                        success(value)
                    case .failure(let encodingError):
                        print(encodingError)
                        failure(encodingError.localizedDescription)
                    }
                    
            }
        }
        else
        {
            connectionFailed(AppConstant.FailureMessage.kNoInternetConnection)
        }
    }
    
}
