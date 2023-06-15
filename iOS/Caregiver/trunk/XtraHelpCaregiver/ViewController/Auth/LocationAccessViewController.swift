//
//  LocationAccessViewController.swift
//  Chiry
//
//  Created by Harshad on 18/06/21.
//

import UIKit

class LocationAccessViewController: UIViewController {

    @IBOutlet weak var lblSubHeader: UILabel?
    
    @IBOutlet weak var btnCancel: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.lblSubHeader?.textColor = UIColor.CustomColor.labelTextColor
        self.lblSubHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
        
        self.btnCancel?.setTitleColor(UIColor.CustomColor.appColor, for: .normal)
        self.btnCancel?.titleLabel?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}

//MARK:- UiButton Action
extension LocationAccessViewController {
    
    @IBAction func btnGoToSetting(_ sender: Any) {
        if let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(Bundle.main.bundleIdentifier ?? "")") {
            UIApplication.shared.open(url, options: [:]) { (status) in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
// MARK: - ViewControllerDescribable
extension LocationAccessViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.auth
    }
}

// MARK: - AppNavigationControllerInteractable
extension LocationAccessViewController: AppNavigationControllerInteractable { }
