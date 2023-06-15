//
//  CardCell.swift
//  Momentor
//
//  Created by wm-devIOShp on 15/10/21.
//

import UIKit

class CardCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var vwMainContent: UIView?
    
    @IBOutlet weak var imgCard: UIImageView?
    @IBOutlet weak var imgBackground: UIImageView?
    
    @IBOutlet weak var lblCardHolderNameHeader: UILabel?
    @IBOutlet weak var lblCardHolderName: UILabel?
    @IBOutlet weak var lblCardExpireHeader: UILabel?
    @IBOutlet weak var lblCardExpireValue: UILabel?
    @IBOutlet weak var lblCardCVVHeader: UILabel?
    @IBOutlet weak var lblCardCVVValue: UILabel?
    @IBOutlet weak var lblCardNumber: UILabel?
    @IBOutlet var lblCardNumberDot: [UILabel]?
    
    @IBOutlet weak var vwEdit: UIView?
    @IBOutlet weak var btnEdit: UIButton?
    @IBOutlet weak var btnSelect: UIButton?
    @IBOutlet weak var btnMarkDefault: UIButton?
    @IBOutlet weak var btnSelectMainCard: UIButton?
    
    // MARK: - LIfe Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.InitConfig()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Init Configure
    private func InitConfig(){
        self.vwMainContent?.cornerRadius = cornerRadiousValue.buttonCorner
        self.imgBackground?.cornerRadius = cornerRadiousValue.buttonCorner
        
        self.lblCardNumber?.textColor = UIColor.CustomColor.whitecolor
        self.lblCardNumber?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 16.0))
        
        self.lblCardNumberDot?.forEach({
            lbl in
            lbl.textColor = UIColor.CustomColor.whitecolor
            lbl.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 14.0))
        })
        
        [self.lblCardHolderNameHeader,self.lblCardCVVHeader,self.lblCardExpireHeader].forEach({
            $0?.textColor = UIColor.CustomColor.cardHeaderColor
            $0?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        })
        
        [self.lblCardHolderName,self.lblCardCVVValue,self.lblCardExpireValue].forEach({
            $0?.textColor = UIColor.CustomColor.whitecolor
            $0?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        })
        
        self.btnMarkDefault?.setTitleColor(UIColor.CustomColor.whitecolor, for: .normal)
        self.btnMarkDefault?.titleLabel?.font = UIFont.RubikLight(ofSize: GetAppFontSize(size: 10.0))
    }
    
    func setupCardData(obj : CardModel){
        self.lblCardNumber?.text = obj.number
        self.lblCardHolderName?.text = obj.holderName
        self.lblCardExpireValue?.text = "\(obj.month) / \(obj.year)"
        let cardtye = CardAPIType.init(rawValue: obj.cardBrand) ?? .None
        self.imgCard?.image = cardtye.img
        self.btnMarkDefault?.setTitle((obj.isDefault == "1") ? "Primary" : "Make as Primary", for: .normal)
    }
    
}

// MARK: - NibReusable
extension CardCell : NibReusable{}
