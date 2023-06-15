//
//  CreateJobAddPhotoVideoCell.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 09/12/21.
//

import UIKit

class CreateJobAddPhotoVideoCell: UICollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var vwMain: UIView?
    @IBOutlet weak var vwCancelSubMain: UIView?
    
    @IBOutlet weak var imgPhoto: UIImageView?
    @IBOutlet weak var imgVideo: UIImageView?
    
    @IBOutlet weak var vwPhotoVideoMain: UIView?
    @IBOutlet weak var vwAddNewMain: UIView?
    
    @IBOutlet weak var btnDelete: UIButton?
    @IBOutlet weak var btnAdd: UIButton?
    @IBOutlet weak var btnSelect: UIButton?
    
    // MARK: - Variables
    var isSelectPhotoVideo : Bool = false {
        didSet{
            self.vwMain?.borderColor = isSelectPhotoVideo ? UIColor.CustomColor.appColor : UIColor.clear
            self.vwMain?.borderWidth = isSelectPhotoVideo ? 2.0 : 0.0
        }
    }
    
    var isAddNewPhotoVideo : Bool = false {
        didSet{
            self.vwAddNewMain?.isHidden = !isAddNewPhotoVideo
            self.vwPhotoVideoMain?.isHidden = isAddNewPhotoVideo
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        /*if let vw = self.vwCancelSubMain {
            vw.clipsToBounds = true
            vw.maskToBounds = true
            //delay(seconds: 0.1, execute: {
            vw.cornerRadius = vw.frame.height / 2
            vw.shadow(UIColor.CustomColor.shadowColorBlack, radius: 5.0, offset: CGSize(width: 4, height: 2), opacity: 1)
            vw.maskToBounds = false
            //})
        }*/
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
extension CreateJobAddPhotoVideoCell : NibReusable {}
