//
//  GoogleLocationModel.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 19/11/21.
//

import UIKit

class GoogleLocationModel: NSObject {
    
    class func getAddressFromLatLong(latitude: Double, longitude : Double,success withResponse: @escaping (_ address : String,_ city : String,_ state : String,_ country : String,_ zipcode : String,_ street : String) -> Void, failure: @escaping FailureBlock) {
        
        SVProgressHUD.show()
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=\(APIKeys.GooglePlaceAPIKey)"
        
        APIManager.makeRequest(with: url, method: .get, parameter: nil, success: {(response) in
            SVProgressHUD.dismiss()
            let dict = response as? [String:Any] ?? [:]
            
            if  let data = dict["results"] as? [NSDictionary],let first = data.first,let addcomponent = first["address_components"] as? [NSDictionary]{
                let formatedaddress : String = first["formatted_address"] as? String ?? ""
                var state : String = ""
                var city : String = ""
                var country : String = ""
                var street : String = ""
                var zipcode : String = ""
                
                for component in addcomponent {
                    if let temp = component.object(forKey: "types") as? [String] {
                        if temp.contains("postal_code") {
                            zipcode = component["long_name"] as? String ?? ""
                        }
                        if temp.contains("administrative_area_level_1") {
                            state = component["long_name"] as? String ?? ""
                        }
                        if temp.contains("locality") {
                            city = component["long_name"] as? String ?? ""
                        }
                        if temp.contains("country") {
                            country = component["long_name"] as? String ?? ""
                        }
                        if temp.contains("transit_station") {
                            street = component["long_name"] as? String ?? ""
                        }
                    }
                }
                print(data)
                withResponse(formatedaddress,city,state,country,zipcode,street)
            }
            else {
                failure("0","0", .response)
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
