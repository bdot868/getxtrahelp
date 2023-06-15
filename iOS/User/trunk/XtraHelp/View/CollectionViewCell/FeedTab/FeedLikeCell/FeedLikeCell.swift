//
//  FeedLikeCell.swift
//  Momentor
//
//  Created by wm-devIOShp on 25/10/21.
//

import UIKit

class FeedLikeCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var lblUsername: UILabel?
    
    @IBOutlet weak var vwProfilemageSub: UIView?
    
    @IBOutlet weak var imgProfilemage: UIImageView?
    
    @IBOutlet weak var vwSelectMain: UIView?
    @IBOutlet weak var btnSelect: UIButton?
    @IBOutlet weak var btnSelectMain: UIButton?
    // MARK: - Variables
    var isFromSubstituteJob : Bool = false {
        didSet{
            self.btnSelectMain?.isHidden = !isFromSubstituteJob
            self.vwSelectMain?.isHidden = !isFromSubstituteJob
        }
    }
    
    // MARK: - LIfe Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.InitConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let img = self.imgProfilemage {
            img.cornerRadius = img.frame.height / 2.0
        }
        
        if let vw = self.vwProfilemageSub {
            vw.cornerRadius = vw.frame.height / 2.0
        }
    }
    
    // MARK: - Init Configure Methods
    private func InitConfig(){
        self.lblUsername?.textColor = UIColor.CustomColor.commonLabelColor
        self.lblUsername?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
    }
    
    func setLikeFeedUserData(obj : FeedUserLikeModel){
        self.imgProfilemage?.setImage(withUrl: obj.profileimage, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        self.lblUsername?.text = obj.name
    }
}

// MARK: - NibReusable
extension FeedLikeCell: NibReusable { }
