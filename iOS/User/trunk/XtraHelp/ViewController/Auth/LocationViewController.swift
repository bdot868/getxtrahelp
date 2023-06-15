//
//  LocationViewController.swift
//  Chiry
//
//  Created by Wdev3 on 18/02/21.
//

import UIKit

protocol locationDelegate
{
    func setupLocation(address : String,country : String,city : String,street : String,zipcode : String,lat : Double,long : Double)
}

class LocationViewController: UIViewController
{
    // MARK: - IBOutlet
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet var bagVw: UIView!
    @IBOutlet weak var lblLocation: UILabel!

    @IBOutlet weak var vwMapMain: UIView!//GMSMapView!
    @IBOutlet weak var vwLocation: UIView!
    @IBOutlet weak var vwEnterLocation: ReusableView!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    // MARK: - Variables
    var delegate : locationDelegate?
    private var countryname : String = ""
    private var cityname : String = ""
    private var streetname : String = ""
    private var zipcode : String = ""
    private var selectedLatitude : Double = 0.0
    private var selectedLongitude : Double = 0.0

    //MARK: - Life Cycle Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.InitConfig()
    }
    
    @IBAction func clickToBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToContinue(_ sender: Any)
    {
       // let vc = loadVC(strStoryboardId: UIStoryboard.Name.auth.rawValue, strVCId: "ProfileSuccessViewController") as! ProfileSuccessViewController
       // self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Init Configure
extension LocationViewController {
    
    private func InitConfig()
    {
        
        self.btnBack.setTitle("", for: .normal)
        self.lblHeader.textColor = UIColor.CustomColor.headerBackColor
        self.lblHeader.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 24.0))
        
        self.lblLocation.textColor = UIColor.CustomColor.headerBackColor
        self.lblLocation.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        
        self.vwMapMain.cornerRadius = 20.0
        self.vwLocation.cornerRadius = 20.0
        self.bagVw.backgroundColor = UIColor.CustomColor.appThemeColor
        self.vwLocation.backgroundColor = UIColor.CustomColor.locationNameBackColor
        
        //DispatchQueue.main.async {
        delay(seconds: 0.2) {
          
            if let data = LocationManager.shared.currentLocation {
                let coordinate = CLLocationCoordinate2D(latitude: data.coordinate.latitude, longitude: data.coordinate.longitude)
                let camera = GMSCameraPosition.camera(withLatitude:coordinate.latitude, longitude: coordinate.longitude, zoom: 15.0)

                let mapView = GMSMapView.map(withFrame: self.vwMapMain.frame, camera: camera)
                
                self.vwMapMain.addSubview(mapView)

                let marker: GMSMarker = GMSMarker()
                marker.icon = #imageLiteral(resourceName: "ic_MarkerMap")
                marker.position = coordinate
                marker.map = mapView
                
                self.selectedLatitude = data.coordinate.latitude
                self.selectedLongitude = data.coordinate.longitude
                
                XtraHelp.sharedInstance.getAddressFromLatLong(lat: data.coordinate.latitude, long: data.coordinate.longitude) { (str,country,city,street,zipcode,new)  in
                    XtraHelp.sharedInstance.currentAddressString = str
                    self.lblLocation.text = str
                    self.countryname = country
                    self.cityname = city
                    self.streetname = street
                    self.zipcode = zipcode
                }
            }
        }
    }
}


// MARK: - ViewControllerDescribable
extension LocationViewController: ViewControllerDescribable
{
    static var storyboardName: StoryboardNameDescribable
    {
        return UIStoryboard.Name.auth
    }
}

// MARK: - AppNavigationControllerInteractable
extension LocationViewController: AppNavigationControllerInteractable { }
