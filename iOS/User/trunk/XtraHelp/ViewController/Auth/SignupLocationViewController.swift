//
//  SignupLocationViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 16/11/21.
//

import UIKit
import GoogleMaps

protocol SignupLocationDelegate {
    func setupLocation(address : String,country : String,state : String,city : String,street : String,zipcode : String,lat : Double,long : Double)
}

class SignupLocationViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblHeader: UILabel?
    @IBOutlet weak var lblLocationHeader: UILabel?
    @IBOutlet weak var lblLocation: UILabel?
    @IBOutlet weak var lblEnterLocation: UILabel?
    
    @IBOutlet weak var vwLocation: GMSMapView?
    @IBOutlet weak var vwSetLocation: UIView?
    // MARK: - Variables
    var countryname : String = ""
    var cityname : String = ""
    var statename : String = ""
    var streetname : String = ""
    var zipcode : String = ""
    var selectedLatitude : Double = 0.0
    var selectedLongitude : Double = 0.0
    var isFromProfile : Bool = false
    var locationName : String = ""
    var isAlreadySelectedLocation : Bool = false
    var isMoveAnoherVC : Bool = true
    var isFromLogin : Bool = false
    
    var isFromCreateJob : Bool = false
    var isFromCreateJobAlreadySelectLocation : Bool = false
    var delegate : SignupLocationDelegate?
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
        if self.isFromCreateJob {
            if isFromCreateJobAlreadySelectLocation && !self.locationName.isEmpty && (self.selectedLatitude != 0.0 && self.selectedLongitude != 0.0) {
                self.lblLocation?.text = self.locationName
                self.setMapMarker(selLat: self.selectedLatitude, selLong: self.selectedLongitude, isUpdateValue: false)
            } else {
                delay(seconds: 0.2) {
                    if let data = LocationManager.shared.currentLocation {
                        let coordinate = CLLocationCoordinate2D(latitude: data.coordinate.latitude, longitude: data.coordinate.longitude)
                        self.setMapMarker(selLat: coordinate.latitude, selLong: coordinate.longitude)
                    }
                }
            }
        }
    }
     
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

// MARK: - Init Configure
extension SignupLocationViewController {
    
    private func InitConfig(){
        /*var isCallAPI : Bool = true
        if let user = UserModel.getCurrentUserFromDefault() {
            if isMoveAnoherVC {
                if user.profileStatus == .CertificationsLicenses || user.profileStatus == .YourAddress{
                    self.appNavigationController?.push(SignupWorkDetailViewController.self,animated: false) { vc in
                        //vc.isFromDirect = false
                    }
                   isCallAPI = false
                    XtraHelp.sharedInstance.isCallCertificateReloadData = true
                }
            }
        }*/
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 35.0))
        self.lblHeader?.textColor = UIColor.CustomColor.tabBarColor
        
        self.lblLocationHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 15.0))
        self.lblLocationHeader?.textColor = UIColor.CustomColor.tabBarColor
        
        self.lblLocation?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 13.0))
        self.lblLocation?.textColor = UIColor.CustomColor.SliderTextColor
        
        self.vwSetLocation?.backgroundColor = UIColor.CustomColor.whitecolor
        self.vwSetLocation?.borderColor = UIColor.CustomColor.borderColor
        self.vwSetLocation?.borderWidth = 1.5
        self.vwSetLocation?.cornerRadius = cornerRadiousValue.buttonCorner
        self.vwSetLocation?.cornerRadius = 15.0
        
        self.lblEnterLocation?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        self.lblEnterLocation?.textColor = UIColor.CustomColor.appPlaceholderColor
        
        /*delay(seconds: 0.2) {
            //if let data = LocationManager.shared.currentLocation {
                let coordinate = CLLocationCoordinate2D(latitude: 64.2008, longitude: 149.4937)
                self.vwLocation?.camera = GMSCameraPosition.camera(withLatitude:coordinate.latitude, longitude: coordinate.longitude, zoom: 4.0)
                let marker: GMSMarker = GMSMarker()
                marker.icon = #imageLiteral(resourceName: "ic_pin_location")
                marker.position = coordinate
                marker.map = self.vwLocation
            //}
        }*/
        if !self.isFromCreateJob {
            self.updateLocationData()
        }
       
    }
    
    private func updateLocationData(){
        delay(seconds: 0.2) {
            if let user = UserModel.getCurrentUserFromDefault() {
                if user.location.isEmpty {
                    if let data = LocationManager.shared.currentLocation {
                        let coordinate = CLLocationCoordinate2D(latitude: data.coordinate.latitude, longitude: data.coordinate.longitude)
                        self.setMapMarker(selLat: coordinate.latitude, selLong: coordinate.longitude)
                    }
                } else {
                    self.lblLocation?.text = user.location
                    let lat : Double = user.latitude.doubleValue
                    let long : Double = user.longitude.doubleValue
                    self.setMapMarker(selLat: lat, selLong: long, isUpdateValue: true)
                }
            }
        }
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllerTitle(title: "", TitleColor: UIColor.CustomColor.textHedareLogin, navigationItem: self.navigationItem,isFromDirect : self.isFromLogin)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
}

// MARK: - IBAction
extension SignupLocationViewController {
    
    @IBAction func btnContinueClicked(_ sender: UIButton) {
        //self.appNavigationController?.push(SignupWorkDetailViewController.self)
        if (self.lblLocation?.text?.isEmpty ?? true){
            self.showMessage(AppConstant.ValidationMessages.kEmptyLocation,themeStyle: .warning)
        } else {
            if self.isFromCreateJob {
                var city = self.cityname
                if cityname.contains(" County") {
                    city = cityname.replacingOccurrences(of: " County", with: "")
                } else if cityname.contains("County") {
                    city = cityname.replacingOccurrences(of: "County", with: "")
                }
                self.cityname = city
                self.delegate?.setupLocation(address: self.lblLocation?.text ?? "", country: self.countryname, state: self.statename, city: self.cityname, street: self.streetname, zipcode: self.zipcode, lat: self.selectedLatitude, long: self.selectedLongitude)
                self.navigationController?.popViewController(animated: true)
            } else {
                self.saveAddressOrLocation()
            }
        }
    }
    
    @IBAction func btnSelectLocationClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let filter = GMSAutocompleteFilter()
        //filter.type = .address
        let placePickerController = GMSAutocompleteViewController()
        placePickerController.delegate = self
        placePickerController.autocompleteFilter = filter
        present(placePickerController, animated: true, completion: nil)
    }
    
    @IBAction func btnCurrentLocationClicked(_ sender: UIButton) {
        delay(seconds: 0.2) {
            if let data = LocationManager.shared.currentLocation {
                let coordinate = CLLocationCoordinate2D(latitude: data.coordinate.latitude, longitude: data.coordinate.longitude)
                self.setMapMarker(selLat: coordinate.latitude, selLong: coordinate.longitude)
            }
        }
    }
    
    private func setMapMarker(selLat : Double,selLong : Double,isUpdateValue : Bool = true){
        let coordinate = CLLocationCoordinate2D(latitude: selLat, longitude: selLong)
        self.vwLocation?.clear()
        self.vwLocation?.camera = GMSCameraPosition.camera(withLatitude:coordinate.latitude, longitude: coordinate.longitude, zoom: 12.0)
        let marker: GMSMarker = GMSMarker()
        marker.icon = #imageLiteral(resourceName: "ic_pin_location")
        marker.position = coordinate
        marker.map = self.vwLocation
        
        self.selectedLatitude = selLat
        self.selectedLongitude = selLong
        if isUpdateValue {
            self.getAddressFromGoogle(lat: selLat, long: selLong,isUpdateValue : isUpdateValue)
        }
    }
    
    private func getAddressFromGoogle(lat : Double,long : Double,isUpdateValue : Bool = true){
        GoogleLocationModel.getAddressFromLatLong(latitude: lat, longitude: long, success: { (formatedaddress,city,state,country,zipcode,street) in
            
            self.streetname = street
            if isUpdateValue {
                self.countryname = country
                XtraHelp.sharedInstance.currentAddressString = formatedaddress
                self.lblLocation?.text = formatedaddress
                self.cityname = city
                self.zipcode = zipcode
                self.statename = state
            }
           
        }, failure: {[unowned self] (statuscode,error, errorType) in
            print(error)
            if !error.isEmpty {
                self.showMessage(error,themeStyle : .error)
            }
        })

    }
}

// MARK: - GMSAutocompleteViewControllerDelegate
extension SignupLocationViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        //print("Place name: \(place.name)")
        //print("Place ID: \(place.placeID)")
        //print("Place attributions: \(place.attributions)")
        //dismiss(animated: true, completion: nil)
        self.vwLocation?.clear()
        dismiss(animated: true) {
            DispatchQueue.main.async { [self] in
                self.selectedLatitude = place.coordinate.latitude
                self.selectedLongitude = place.coordinate.longitude
                self.lblLocation?.text = place.formattedAddress ?? ""
                self.zipcode = ""
                self.streetname = ""
                var addressShort : String = ""
                for addressComponent in (place.addressComponents)! {
                    for type in (addressComponent.types){
                        print("Type : \(type) = \(addressComponent.name)")
                        switch(type){
                            case "street_number":
                                self.streetname = addressComponent.name
                                print("Street : \(self.streetname)")
                                addressShort = addressComponent.name
                            case "route":
                                addressShort = addressShort + "\(addressShort.isEmpty ? "\(addressComponent.name)" : ",\(addressComponent.name)")"
                            case "premise":
                                addressShort = addressShort + "\(addressShort.isEmpty ? "\(addressComponent.name)" : ",\(addressComponent.name)")"
                            case "neighborhood":
                                addressShort = addressShort + ",\(addressComponent.name)"
                            case "country":
                                self.countryname = addressComponent.name
                                print("Contry : \(self.countryname)")
                            case "postal_code":
                                 self.zipcode = addressComponent.name
                            case "administrative_area_level_2":
                                self.cityname = addressComponent.name
                                print("City : \(self.cityname)")
                            case "administrative_area_level_1":
                                self.statename = addressComponent.name
                                print("State : \(self.statename)")
                            //case "street_number":
                                
                        default:
                            break
                        }
                    }
                }
                print(addressShort)
                //self.lblLocation?.text = addressShort.isEmpty ? (place.formattedAddress ?? "") : addressShort
                self.setMapMarker(selLat: self.selectedLatitude, selLong: self.selectedLongitude,isUpdateValue : false)
            }
        }
        
    }
    
  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    //UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    //UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

}

//MARK : - API Call
extension SignupLocationViewController{
    
    func saveAddressOrLocation() {
        self.view.endEditing(true)
        if let user = UserModel.getCurrentUserFromDefault() {
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kprofileStatus : "4",
                kaddress : self.lblLocation?.text ?? "",
                klatitude : "\(self.selectedLatitude)",
                klongitude : "\(self.selectedLongitude)"
            ]
            let param : [String:Any] = [
                kData : dict
            ]
            UserModel.saveSignupProfileDetails(with: param,type: .YourLocation, success: { (model, msg) in
                UserDefaults.isShowCreateJobTutorial = true
                self.appNavigationController?.push(ProfileSuccessViewController.self,animated: false) { vc in
                    
                }
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    self.showMessage(error,themeStyle : .error)
                }
            })
        }
    }
}


// MARK: - ViewControllerDescribable
extension SignupLocationViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.auth
    }
}

// MARK: - AppNavigationControllerInteractable
extension SignupLocationViewController: AppNavigationControllerInteractable { }

