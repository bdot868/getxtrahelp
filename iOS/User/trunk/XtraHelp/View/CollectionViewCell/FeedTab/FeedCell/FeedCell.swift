//
//  FeedCell.swift
//  Momentor
//
//  Created by wmdevios-h on 18/09/21.
//

import UIKit
protocol FeedCellDelegate {
    func btnLikeSelect(btn : UIButton,cell : FeedCell)
    func btnMoreSelect(btn : UIButton,cell : FeedCell)
}

class FeedCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var imgProfile: UIImageView?
    
    @IBOutlet weak var lblUsername: UILabel?
    @IBOutlet weak var lblTime: UILabel?
    @IBOutlet weak var lblFeedDesc: UILabel?
    @IBOutlet weak var lblLikeCount: UILabel?
    @IBOutlet weak var lblCommentCount: UILabel?
    
    @IBOutlet weak var vwFeedImageMain: UIView?
    @IBOutlet weak var vwTopContentMain: UIView?
    @IBOutlet weak var vwBottomContentMain: UIView?
    @IBOutlet weak var vwLikeMain: UIView?
    @IBOutlet weak var vwCommentMain: UIView?
    @IBOutlet weak var vwMoreMain: UIView?
    
    @IBOutlet weak var btnCommentSelect: UIButton?
    @IBOutlet weak var brnComment: UIButton?
    @IBOutlet weak var btnLikeSelect: UIButton?
    @IBOutlet weak var btnLike: UIButton?
    @IBOutlet weak var btnMoreSelect: UIButton?
    
    @IBOutlet weak var cvFeedImages: UICollectionView?
    
    @IBOutlet weak var constraintCVImageHeight: NSLayoutConstraint?
    
    // MARK: - Variables
    var arrFeedImages : [AddPhotoVideoModel]  = [] {
        didSet {
            self.cvFeedImages?.reloadData()
        }
    }
    
    var isShowContentTextOnly : Bool = false {
        didSet {
            self.vwFeedImageMain?.isHidden = isShowContentTextOnly
        }
    }
    var delegate : FeedCellDelegate?
    
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
        if let img = self.imgProfile {
            img.cornerRadius = img.frame.height / 2.0
        }
    }
    
    // MARK: - Init Configure Methods
    private func InitConfig(){
        self.lblUsername?.textColor = UIColor.CustomColor.TextColor
        self.lblUsername?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 16.0))
        
        self.lblTime?.textColor = UIColor.CustomColor.AcceptLabelTextColor
        self.lblTime?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
        
        self.lblFeedDesc?.textColor = UIColor.CustomColor.AcceptLabelTextColor
        self.lblFeedDesc?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 15.0))
        
        [self.lblLikeCount,self.lblCommentCount].forEach({
            $0?.textColor = UIColor.CustomColor.blackColor
            $0?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
        })
        
        self.cvFeedImages?.dataSource = self
        self.cvFeedImages?.delegate = self
        self.cvFeedImages?.register(FeedImageCell.self)
        //self.cvFeedImages?.register(UINib.init(nibName: CellIdentifier.kFeedImageCell, bundle: nil), forCellWithReuseIdentifier: CellIdentifier.kFeedImageCell)
        //self.cvFeedImages?.interitemSpacing = 30.0
        //self.cvFeedImages?.transformer = FSPagerViewTransformer(type: .zoomOut)
        
       // delay(seconds: 0.1) {
            
            self.constraintCVImageHeight?.constant = ScreenSize.SCREEN_WIDTH * 0.7
            
            
            self.cvFeedImages?.reloadData()
            /*if let cv = self.cvFeedImages {
                cv.itemSize = CGSize(width: ScreenSize.SCREEN_WIDTH - 100.0, height: cv.frame.height)
            }*/
       // }
    }
    
    func setFeedData(obj : FeedModel){
        self.lblFeedDesc?.text = obj.feed.decodingEmoji()
        self.lblUsername?.text = obj.name
        self.imgProfile?.setImage(withUrl: obj.thumbprofileimage, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        
        self.arrFeedImages = obj.imageVideo
        self.lblTime?.text = obj.formatedTime
        self.lblLikeCount?.text = obj.totalLikes
        self.lblCommentCount?.text = obj.totalComments
        
        if self.arrFeedImages.isEmpty && !obj.feed.isEmpty {
            self.isShowContentTextOnly = true
        } else if !self.arrFeedImages.isEmpty && obj.feed.isEmpty {
            self.lblFeedDesc?.isHidden = true
            self.isShowContentTextOnly = false
        } else {
            self.vwFeedImageMain?.isHidden = false
            self.lblFeedDesc?.isHidden = false
        }
        
        self.btnLike?.isSelected = obj.isLiked == "1"
    }
    
    @IBAction func btnLikeClicked(_ sender: UIButton) {
        if let btn = self.btnLike {
            self.btnLike?.isSelected = !(self.btnLike?.isSelected ?? false)
            self.delegate?.btnLikeSelect(btn: btn,cell: self)
        }
    }
    
    @IBAction func btnMoreClicked(_ sender: UIButton) {
        //if let btn = self.btnReportComment {
            //self.btnReportComment?.isSelected = !(self.btnReportComment?.isSelected ?? false)
            //self.vwReportCommentMain?.isHidden = !(self.btnReportComment?.isSelected ?? false)
            //self.delegate?.btnMoreSelect(btn: btn,cell: self)
       // }
    }
}

//MARK: - UICollectionView Delegate and Datasource Method
extension FeedCell : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrFeedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FeedImageCell.self)
        if self.arrFeedImages.count > 0 {
            let obj = self.arrFeedImages[indexPath.row]
            
            cell.imgFeed?.setImage(withUrl: obj.isVideo ? obj.videoImageThumbUrl :  obj.mediaNameUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.AppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if self.arrFeedImages.count == 1 {
            return 0
        }
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.arrFeedImages.count == 1 {
            return CGSize(width: (collectionView.frame.width - 10.0), height: ScreenSize.SCREEN_WIDTH * 0.7)
        }
        return CGSize(width: (ScreenSize.SCREEN_WIDTH * 0.7), height: ScreenSize.SCREEN_WIDTH * 0.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

// MARK: - NibReusable
extension FeedCell: NibReusable { }
