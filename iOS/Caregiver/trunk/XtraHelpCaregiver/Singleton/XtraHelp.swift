//
//  XtraHelp.swift
//  XtraHelp
//
//  Created by DeviOS1 on 11/09/21.
//

import Foundation
import UIKit
import CoreLocation

class XtraHelp: NSObject {
    static let sharedInstance = XtraHelp()
    
    /*var searchArrFilterJobCatagories : [JobCategoryModel] = []
    var searchArrCaregiverSpecialities : [WorkSpecialityModel] = []
    var searchFilterNewestOldest : String = ""
    var searchFilterBehavioral : String = ""
    var searchFilterVerbal : String = ""
    var searchFilterAllergies : String = ""
    var searchFilterDistance : String = ""
    var searchFilterVaccinated: String = ""
    var searchFilterJobType: String = ""*/
    
    var jobfilterdelegate :filterJobDelegate?
    
    var currentUser: UserModel?
    var deviceToken = ""
    var DeviceType = "1"
    var navigationBackgroundImage: UIImage?
    
    var isMoveToTabbarScreen : TabbarItemType?

    var selectedUserType : userRole = .User
    var languageType : String = "1"
    
    var isCallCertificateReloadData : Bool = false
    var isCallLocationReloadData : Bool = false
    var isCallJobReloadData : Bool = false
    var isCallJobDetailReloadData : Bool = false
    var isCallHomeReloadData : Bool = false
    var isCallReloadProfileData : Bool = false
    var isCallDashboardJobReloadData : Bool = false
    var setJobEndSelecetdTab : SegmentJobTabEnum?
    
    var selectedHomeAddress : String = ""
    var selectedHomeLatitude : Double = 0.0
    var selectedHomeLongitude : Double = 0.0
    
    var unreadPushNotiCount : Int = 0
    var unreadChatMsgCount : Int = 0

    var tabbarHeight : CGFloat = 0.0

    var systemOSVersion : String = UIDevice.current.systemVersion

    var version : String = Bundle.main.releaseVersionNumber ?? ""
    var build : String = Bundle.main.buildVersionNumber ?? ""
    var deviceID : String = UIDevice.current.identifierForVendor?.uuidString ?? ""
    var userRole : String = "3"
    var carGiverType : String = "2"

    var localTimeZoneIdentifier: String { return TimeZone.current.identifier }

    var AppVersion : String = "\(Bundle.main.releaseVersionNumber ?? "") \(Bundle.main.buildVersionNumber ?? "")"

    var currentAddressString : String = ""
//
    func getAddressFromLatLong(lat: Double,long: Double,complation : @escaping (_ address : String,_ country : String,_ state : String,_ city : String,_ street : String,_ zipcode : String) -> Void )  {

        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat , longitude: long)
        var address : String = ""
        var countryname : String = ""
        var statename : String = ""
        var cityname : String = ""
        var streetname : String = ""
        var zipcode : String = ""
        var locstreet : String = ""
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in

            //print("Response GeoLocation : \(placemarks)")
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]

            if placeMark != nil {
                // Country
                if let country = placeMark.country {
                    //print("Country :- \(country)")
                    countryname = country
                    // City

                }

                if let city = placeMark.subAdministrativeArea {
                    //print("City :- \(city)")
                    cityname = city

                }

                // State
                if let state = placeMark.administrativeArea{
                    //print("State :- \(state)")
                    statename = state
                }
                // Street
                if let street = placeMark.thoroughfare{
                    //print("Street :- \(street)")
                    streetname = placeMark.subLocality ?? ""

                }

                // ZIP
                if let zip = placeMark.postalCode{
                    //print("ZIP :- \(zip)")
                    zipcode = zip

                }

                // Location name
                if let locationName = placeMark?.name {
                    //print("Location Name :- \(locationName)")
                    locstreet = locationName
                }

                if locstreet != "" {
                    address = locstreet
                }
                if streetname != "" {
                    address = "\(address == "" ? "" : "\(address),")\(streetname)"
                }

                if cityname != "" {
                    address = "\(address == "" ? "" : "\(address),")\(cityname)"
                }

                if countryname != "" {
                    address = "\(address == "" ? "" : "\(address),")\(countryname)"
                }
            }

            complation(address,countryname,statename,cityname,streetname,zipcode)
        })
    }
//
//    /*class func showUploadMenu(onBtnMenuClick: @escaping (_ menubtn : uploadMenuBtn)-> (Void)) {
//
//        guard let windowIs = UIApplication.shared.keyWindow else {
//            return
//        }
//        let menuView: UploadView = .fromNib()
//        menuView.frame = windowIs.frame
//        menuView.onBtnClick = {
//            menu in
//            print(menu.rawValue)
//            onBtnMenuClick(menu)
//        }
//
//        UIView.transition(with: windowIs, duration: 0.6,options: .curveEaseIn, animations: {
//            windowIs.addSubview(menuView)
//        }, completion: nil)
//    }*/
//
//    func hexStringToUIColor (hex:String) -> UIColor {
//        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
//
//        if (cString.hasPrefix("#")) {
//            cString.remove(at: cString.startIndex)
//        }
//
//        if ((cString.count) != 6) {
//            return UIColor.gray
//        }
//
//        var rgbValue:UInt32 = 0
//        Scanner(string: cString).scanHexInt32(&rgbValue)
//
//        return UIColor(
//            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
//            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
//            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
//            alpha: CGFloat(1.0)
//        )
//    }
//
//    class func showContextMenu(safeareaheight : CGFloat,onBtnMenuClick: @escaping (_ menubtn : contentMenuBtn)-> (Void)) {
//
//        guard let windowIs = UIApplication.shared.keyWindow else {
//            return
//        }
//        let menuView: ContextMenuView = .fromNib()
//        menuView.frame = windowIs.frame
//        menuView.constarintTopVwMainContent.constant = safeareaheight
//        menuView.onBtnClick = {
//            menu in
//            print(menu.rawValue)
//            onBtnMenuClick(menu)
//        }
//
//        UIView.transition(with: windowIs, duration: 0.5, options: .curveEaseIn, animations: {
//            windowIs.addSubview(menuView)
//        }, completion: nil)
//    }
    
    func getExperienceYear() -> [String] {
        var arr : [String] = []
        for i in stride(from: 0, to: 27, by: 1) {
            if i == 26 {
                arr.append("\(i - 1)+")
            } else {
                arr.append("\(i)")
            }
        }
        return arr
    }
    
    func getYear() -> [String] {
        let currentyear : Int = Date().getYearFromDate()
        var arr : [String] = []
        for i in stride(from: 1990, to: currentyear, by: 1) {
            arr.append("\(i)")
        }
        return arr
    }
    func getMonth() -> [String] {
        var arr : [String] = []
        
        return arr
    }
    
    func getMonthBetween(from start: Date, to end: Date) -> [String] {
            var allDates: [String] = []
            guard start < end else { return allDates }
            
            let calendar = Calendar.current
            let month = calendar.dateComponents([.month], from: start, to: end).month ?? 0
            
            for i in 0...month {
                if let date = calendar.date(byAdding: .month, value: i, to: start) {
                    allDates.append(date.getTimeString(inFormate: AppConstant.DateFormat.k_MMMM))
                }
            }
            return allDates
        }
    
    func getYearBetween(from start: Date, to end: Date) -> [String] {
        var allDates: [String] = []
        guard start < end else { return allDates }
        
        let calendar = Calendar.current
        let month = calendar.dateComponents([.year], from: start, to: end).year ?? 0
        
        for i in 0...month {
            if let date = calendar.date(byAdding: .year, value: i, to: start) {
                allDates.append(date.getTimeString(inFormate: AppConstant.DateFormat.k_yyyy))
            }
        }
        return allDates
    }
    
    func estimatedHeightOfLabel(text: String) -> CGFloat {

        let size = CGSize(width: (((ScreenSize.SCREEN_WIDTH - 40) / 2.0) - 10.0), height: 1000)

        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)

        let attributes = [NSAttributedString.Key.font:  UIFont.RubikRegular(ofSize: GetAppFontSize(size: 15.0))]

        let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes, context: nil).height

        return rectangleHeight
    }
    
}
