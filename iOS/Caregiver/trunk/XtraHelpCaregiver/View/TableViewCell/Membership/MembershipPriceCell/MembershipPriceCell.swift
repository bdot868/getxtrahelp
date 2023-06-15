//
//  MembershipPriceCell.swift
//  Momentor
//
//  Created by wm-devIOShp on 08/10/21.
//

import UIKit

class MembershipPriceCell: FSPagerViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var vwSub: UIView?
    @IBOutlet weak var vwDiscountMain: UIView?
    
    @IBOutlet weak var lblDiscount: UILabel?
    @IBOutlet weak var lblSubcriptionPrice: UILabel?
    @IBOutlet weak var lblPlanType: UILabel?
    
    // MARK: - Variables

    // MARK: - LIfe Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.InitConfig()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        // remove the default shadow.
        self.contentView.layer.shadowColor = nil
        self.contentView.layer.shadowRadius = 0
        self.contentView.layer.shadowOpacity = 0
        self.contentView.layer.shadowOffset = .zero
    }
    
    // MARK: - Init Configure Methods
    private func InitConfig(){
        self.lblDiscount?.textColor = UIColor.CustomColor.whitecolor
        self.lblDiscount?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 22.0))
        
        self.lblPlanType?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 45.0))
        self.lblPlanType?.textColor = UIColor.CustomColor.appColor
        
        self.lblSubcriptionPrice?.setMembershipPriceAttributedTextLable(firstText: "$9.99", SecondText: "\nper month")
        
        self.vwSub?.cornerRadius = 30
        self.vwSub?.backgroundColor = UIColor.CustomColor.tabBarColor
    }
    
    
    func setMembershipData(obj : MembershipPlanEnum){
        /*self.lblPlanType?.text = obj.tabName
        switch obj{
        case .Silver:
            self.lblPlanType?.textColor = obj.colorname
            break
        case .Gold:
            if let lbl = self.lblPlanType {
                delay(seconds: 0.1) {
                    self.lblPlanType?.textColor = GradientColor(gradientStyle: .topToBottom, frame: lbl.frame, colors: [UIColor.CustomColor.gradiantGoldTop,UIColor.CustomColor.gradiantGoldCener,UIColor.CustomColor.gradiantGoldBottomCenter,UIColor.CustomColor.gradiantGoldBottomCenter])
                }
            }
            break
        case .Premium:
            self.lblPlanType?.textColor = obj.colorname
            break
        }*/
    }

}

// MARK: - NibReusable
extension MembershipPriceCell: NibReusable { }
