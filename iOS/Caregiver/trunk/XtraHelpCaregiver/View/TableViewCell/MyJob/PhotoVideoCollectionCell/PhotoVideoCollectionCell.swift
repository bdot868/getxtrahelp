//
//  PhotoVideoCollectionCell.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 04/12/21.
//

import UIKit

class PhotoVideoCollectionCell: UICollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var vwMain: UIView?
    
    @IBOutlet weak var imgPhoto: UIImageView?
    @IBOutlet weak var imgVideo: UIImageView?
    
    // MARK: - Variables
    var isSelectPhotoVideo : Bool = false {
        didSet{
            self.vwMain?.borderColor = isSelectPhotoVideo ? UIColor.CustomColor.appColor : UIColor.clear
            self.vwMain?.borderWidth = isSelectPhotoVideo ? 2.0 : 0.0
        }
    }
    
    // MARK: - LIfe Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.InitConfig()
    }
    
    private func InitConfig(){
        self.vwMain?.cornerRadius = 10.0
        self.imgPhoto?.cornerRadius = 10.0
    }
    
}

// MARK: - NibReusable
extension PhotoVideoCollectionCell : NibReusable {}
