//
//  TimeCell.swift
//  Chiry
//
//  Created by Wdev3 on 03/03/21.
//

import UIKit

class TimeCell: UICollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var lblTitle: UILabel?
    
    @IBOutlet weak var vwMain: UIView?
    // MARK: - Variables
    var isSelecetdAvailibility : Bool = false {
        didSet{
            self.vwMain?.backgroundColor = isSelecetdAvailibility ? UIColor.CustomColor.tabBarColor : UIColor.CustomColor.timeUnavailableColor
            self.lblTitle?.textColor = isSelecetdAvailibility ? UIColor.CustomColor.whitecolor : UIColor.CustomColor.timeUnavailableTExtColor
        }
    }
    
    //MARK: - Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.InitConfig()
    }
    
    // MARK: - Init Configure
    private func InitConfig(){
        
        self.vwMain?.backgroundColor = UIColor.CustomColor.tabBarColor
        self.vwMain?.cornerRadius = 4.0
        
        self.lblTitle?.textColor = UIColor.CustomColor.whitecolor
        self.lblTitle?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 13.0))
    }
    
    func setSloteData(obj : CareGiverAvailibilitySlotModel){
        self.lblTitle?.text = obj.time
        self.isSelecetdAvailibility = obj.isBooked == "0"
    }
}

// MARK: - NibReusable
extension TimeCell: NibReusable { }
