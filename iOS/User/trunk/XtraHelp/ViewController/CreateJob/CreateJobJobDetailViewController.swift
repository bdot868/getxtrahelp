//
//  CreateJobJobDetailViewController.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 09/12/21.
//

import UIKit

class CreateJobJobDetailViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblTopHeader: UILabel?
    @IBOutlet var lblSubText: [UILabel]?
    @IBOutlet weak var lblForLocationHeader: UILabel?
    @IBOutlet weak var lblLocation: UILabel?
    
    @IBOutlet weak var btnChangeLocation: UIButton?
    
    @IBOutlet weak var vwJobName: ReusableView?
    @IBOutlet weak var vwJobPrice: ReusableView?
    @IBOutlet weak var vwJobDesc: ReusableTextview?
    
    @IBOutlet weak var vwLocation: GMSMapView?
    
    //StartCAneclJob
    @IBOutlet weak var vwBottomJobCancelStartMain: UIView?
    @IBOutlet weak var vwJobCancelMain: UIView?
    @IBOutlet weak var vwJobStartMain: UIView?
    @IBOutlet weak var lblJobCancel: UILabel?
    @IBOutlet weak var lblJobStart: UILabel?
    
    // MARK: - Variables
    var countryname : String = ""
    var cityname : String = ""
    var statename : String = ""
    var streetname : String = ""
    var zipcode : String = ""
    var selectedLatitude : Double = 0.0
    var selectedLongitude : Double = 0.0
    var paramDict : [String:Any] = [:]
    
    var selectedCategory : JobCategoryModel?
    
    // MARK: - LIfe Cycle Methods
    override func viewDidLoad(){
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        self.configureNavigationBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        [self.vwJobCancelMain].forEach({
            $0?.roundCorners(corners: [.topRight], radius: ($0?.frame.width ?? 0.0)/2.0)
        })
        
        if let vw = self.vwJobStartMain {
            vw.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: vw.frame, colors: [UIColor.CustomColor.buttonBGGCOne,UIColor.CustomColor.gradiantColorBottom])
            vw.roundCorners(corners: [.topLeft], radius: vw.frame.width / 2)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}

// MARK: - Init Configure
extension CreateJobJobDetailViewController {
    
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblTopHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblTopHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 35.0))
        
        self.lblForLocationHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblForLocationHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 15.0))
        
        self.lblLocation?.textColor = UIColor.CustomColor.blackColor
        self.lblLocation?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 18.0))
        
        self.btnChangeLocation?.titleLabel?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        self.btnChangeLocation?.setTitleColor(UIColor.CustomColor.tutorialColor, for: .normal)
        
        self.lblSubText?.forEach({
            $0.textColor = UIColor.CustomColor.tutorialColor
            $0.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        })
        
        [self.lblJobCancel,self.lblJobStart].forEach({
            $0?.textColor = UIColor.CustomColor.whitecolor
            $0?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size:15.0))
        })
        
        [self.vwJobName,self.vwJobPrice].forEach({
            $0?.txtInput.delegate = self
            $0?.txtInput.addTarget(self, action: #selector(self.textChange(_:)), for: .editingChanged)
        })
        
        self.vwJobDesc?.txtInput?.delegate = self
        self.vwJobPrice?.txtInput.keyboardType = .decimalPad
        
        self.vwJobName?.txtInput.autocapitalizationType = .sentences
        
        self.vwJobCancelMain?.backgroundColor = UIColor.CustomColor.tabBarColor
        
        delay(seconds: 0.4) {
            self.updateLocationData()
        }
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllerTitle(title: "", TitleColor: UIColor.CustomColor.textHedareLogin, navigationItem: self.navigationItem)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
    
    private func updateLocationData(){
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

// MARK: - IBAction
extension CreateJobJobDetailViewController {
    private func validateFields() -> String? {
        let price : Double = Double(self.vwJobPrice?.txtInput.text ?? "0") ?? 0.0
        if self.vwJobName?.txtInput.isEmpty ?? true{
            self.vwJobName?.txtInput.becomeFirstResponder()
            self.vwJobName?.isSetFocusTextField = true
            self.vwJobPrice?.isSetFocusTextField = false
            self.vwJobDesc?.isSetFocusTextField = false
            return AppConstant.ValidationMessages.kEmptyJobName
        } else if self.vwJobPrice?.txtInput.isEmpty ?? true {
            self.vwJobPrice?.isSetFocusTextField = false
            self.vwJobPrice?.isSetFocusTextField = true
            self.vwJobDesc?.isSetFocusTextField = false
            self.vwJobName?.txtInput.becomeFirstResponder()
            return AppConstant.ValidationMessages.kEmptyJobPrice
        } else if (self.lblLocation?.text ?? "").isEmpty {
            self.vwJobName?.isSetFocusTextField = false
            self.vwJobPrice?.isSetFocusTextField = false
            self.vwJobDesc?.isSetFocusTextField = false
            return AppConstant.ValidationMessages.kEmptyJobAddress
        } else if price < 25 {
            self.vwJobPrice?.isSetFocusTextField = false
            self.vwJobPrice?.isSetFocusTextField = true
            self.vwJobDesc?.isSetFocusTextField = false
            self.vwJobName?.txtInput.becomeFirstResponder()
            return AppConstant.ValidationMessages.kValidJobPrice
        } else {
            self.vwJobName?.isSetFocusTextField = false
            self.vwJobPrice?.isSetFocusTextField = false
            self.vwJobDesc?.isSetFocusTextField = false
            return nil
        }
    }
    
    @IBAction func btnJObCancelClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnJobStartClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if let errMessage = self.validateFields() {
            self.showMessage(errMessage.localized(), themeStyle: .warning,presentationStyle: .top)
            return
        }
        //self.appNavigationController?.push(CreateJobAddPhotoVideoViewController.self)
        self.paramDict[kname] = self.vwJobName?.txtInput.text ?? ""
        self.paramDict[kprice] = self.vwJobPrice?.txtInput.text ?? ""
        self.paramDict[klocation] = self.lblLocation?.text ?? ""
        self.paramDict[klatitude] = "\(self.selectedLatitude)"
        self.paramDict[klongitude] = "\(self.selectedLongitude)"
        self.paramDict[kdescription] = self.vwJobDesc?.txtInput?.text ?? ""
        
        self.appNavigationController?.push(CreateJobAddPhotoVideoViewController.self,configuration: { vc in
            vc.paramDict = self.paramDict
            if let catObj = self.selectedCategory {
                vc.selectedCategory = catObj
            }
        })
    }
    
    @IBAction func btnChangeLocationClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.appNavigationController?.push(SignupLocationViewController.self,configuration: { vc in
            vc.isFromCreateJob = true
            vc.delegate = self
            vc.isFromCreateJobAlreadySelectLocation = !((self.lblLocation?.text?.isEmpty) ?? false)
            if !(self.lblLocation?.text ?? "").isEmpty {
                vc.selectedLatitude = self.selectedLatitude
                vc.selectedLongitude = self.selectedLongitude
                vc.locationName = (self.lblLocation?.text ?? "")
            }
        })
    }
}

// MARK: -
extension CreateJobJobDetailViewController : SignupLocationDelegate {
    func setupLocation(address: String, country: String, state: String, city: String, street: String, zipcode: String, lat: Double, long: Double) {
        self.selectedLatitude = lat
        self.selectedLongitude = long
        self.countryname = country
        self.statename = state
        self.cityname = city
        self.zipcode = zipcode
        self.streetname = street
        self.lblLocation?.text = address
        self.setMapMarker(selLat: self.selectedLatitude, selLong: self.selectedLongitude,isUpdateValue: false)
    }
}

//MARK : - UITextViewDelegate
extension CreateJobJobDetailViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == self.vwJobDesc?.txtInput {
            self.vwJobDesc?.isSetFocusTextField = true
            self.vwJobName?.isSetFocusTextField = false
            self.vwJobPrice?.isSetFocusTextField = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == self.vwJobDesc?.txtInput {
            self.vwJobDesc?.isSetFocusTextField = false
            self.vwJobName?.isSetFocusTextField = false
            self.vwJobPrice?.isSetFocusTextField = false
        }
    }
}

//MARK : - UITextFieldDelegate
extension CreateJobJobDetailViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.vwJobPrice?.txtInput {
            if let text = textField.text as NSString? {
                //let text: NSString = textField.text! as NSString
                let resultString = text.replacingCharacters(in: range, with: string)
                
                //Check the specific textField
                if textField == self.vwJobPrice?.txtInput {
                    let textArray = resultString.components(separatedBy: ".")
                    if textArray.count > 2 { //Allow only one "."
                        return false
                    }
                    if textArray.count == 2 {
                        let lastString = textArray.last
                        if lastString!.count > 2 { //Check number of decimal places
                            return false
                        }
                    }
                }
            }
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.vwJobName?.txtInput:
            self.vwJobName?.txtInput.resignFirstResponder()
            self.vwJobPrice?.txtInput.becomeFirstResponder()
        case self.vwJobPrice?.txtInput:
            self.vwJobPrice?.txtInput.resignFirstResponder()
            self.vwJobDesc?.txtInput?.becomeFirstResponder()
        default:
            break
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.vwJobName?.txtInput:
            self.vwJobName?.isSetFocusTextField = true
            self.vwJobPrice?.isSetFocusTextField = false
            self.vwJobDesc?.isSetFocusTextField = false
        case self.vwJobPrice?.txtInput:
            self.vwJobName?.isSetFocusTextField = false
            self.vwJobPrice?.isSetFocusTextField = true
            self.vwJobDesc?.isSetFocusTextField = false
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.vwJobName?.txtInput:
            self.vwJobName?.isSetFocusTextField = false
            self.vwJobPrice?.isSetFocusTextField = true
        case self.vwJobPrice?.txtInput:
            self.vwJobName?.isSetFocusTextField = false
            self.vwJobPrice?.isSetFocusTextField = false
        default:
            break
        }
    }
    
    @objc func textChange(_ sender : UITextField){
        switch sender {
        case self.vwJobName?.txtInput:
            self.vwJobName?.ShowRightLabelView = !(self.vwJobName?.txtInput.isEmpty ?? false)
        case self.vwJobPrice?.txtInput:
            self.vwJobPrice?.ShowRightLabelView = !(self.vwJobPrice?.txtInput.isEmpty ?? false)
        default:
            break
        }
    }
}

// MARK: - API Call
extension CreateJobJobDetailViewController {
    
}

// MARK: - ViewControllerDescribable
extension CreateJobJobDetailViewController: ViewControllerDescribable{
    static var storyboardName: StoryboardNameDescribable{
        return UIStoryboard.Name.CreateJob
    }
}

// MARK: - AppNavigationControllerInteractable
extension CreateJobJobDetailViewController: AppNavigationControllerInteractable { }
