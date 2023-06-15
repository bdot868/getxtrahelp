//
//  PopupViewController.swift
//  Momentor
//
//  Created by wmdevios-h on 16/08/21.
//

import UIKit

protocol feedPopupDelegate {
    func feedReport(btn : UIButton,obj : FeedModel)
    func feedDelete(btn : UIButton,obj : FeedModel)
    func feedCommentReport(btn : UIButton,obj : FeedUserLikeModel)
    func feedCommentDelete(btn : UIButton,obj : FeedUserLikeModel)
}

class PopupViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblHeader: UILabel?
    
    @IBOutlet weak var vwSub: UIView?
    @IBOutlet weak var vwSubBottom: UIView?
    
    @IBOutlet weak var btnYes: XtraHelpButton?
    @IBOutlet weak var btnNo: UIButton?
    @IBOutlet weak var btnClose: UIButton?
    
    @IBOutlet weak var vwYes: UIView?
    @IBOutlet weak var vwNo: UIView?
    @IBOutlet weak var vwTextArea: UIView?
    @IBOutlet weak var txtDetail: UITextView?
    
    @IBOutlet weak var stackReport: UIStackView?
    @IBOutlet weak var btnReportFeed: UIButton?
    @IBOutlet weak var vwReportFeed: UIView?
    @IBOutlet weak var btnDeleteFeed: UIButton?
    @IBOutlet weak var vwDeleteFeed: UIView?
    
    // MARK: - Variables
    var isFirstYes : Bool = true
    var isFromLovedAbout : Bool = false
    var selectedLovedCategory : LovedCategoryModel?
    var isFromFeedTab : Bool = false
    var isFromFeedComment : Bool = false
    
    var feeddelegate : feedPopupDelegate?
    var selectedFeedData : FeedModel?
    var selectedFeedCommentData : FeedUserLikeModel?
    
    var isFromCategory : Bool = false
    var selectedCategory : JobCategoryModel?
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        self.vwSub?.clipsToBounds = true
        self.vwSub?.shadow(UIColor.CustomColor.shadowColorBlack, radius: 5.0, offset: CGSize(width: 0, height: 0), opacity: 1)
        //self.vwSub?.roundCorners(corners: [.topLeft,.topRight], radius: 40.0)
        self.vwSub?.maskToBounds = false
    }
}

// MARK: - Init Configure
extension PopupViewController {
    private func InitConfig(){
        
        self.lblHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblHeader?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 20.0))
        
        self.btnNo?.titleLabel?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
        self.btnNo?.setTitleColor(UIColor.CustomColor.categoriesBorderColor, for: .normal)
        
        //delay(seconds: 0.2) {
        self.vwSub?.roundCornersTest(corners: [.topLeft,.topRight], radius: 40.0)
        //}
        
        self.vwSub?.backgroundColor = UIColor.CustomColor.tutorialBGColor
        self.vwSubBottom?.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.txtDetail?.textColor = UIColor.CustomColor.SubscriptuionSubColor
        self.txtDetail?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 13.0))
        
        [self.btnReportFeed,self.btnDeleteFeed].forEach({
            $0?.titleLabel?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
            $0?.setTitleColor(UIColor.CustomColor.tabBarColor, for: .normal)
        })
        
        if self.isFromLovedAbout {
            if let data = self.selectedLovedCategory {
                self.lblHeader?.text = data.name
                self.txtDetail?.text = data.loveCatDescription
                self.vwYes?.isHidden = true
                self.vwNo?.isHidden = true
                self.vwTextArea?.isHidden = false
            }
        } else if self.isFromCategory {
            if let data = self.selectedCategory {
                self.lblHeader?.text = data.name
                self.txtDetail?.text = data.categoryDesc
                self.vwYes?.isHidden = true
                self.vwNo?.isHidden = true
                self.vwTextArea?.isHidden = false
            }
        }
        
        if self.isFromFeedTab {
            self.lblHeader?.text = self.isFromFeedComment ? "Feed Comment" : "Feed"
            self.lblHeader?.isHidden = true
            self.vwYes?.isHidden = true
            self.vwNo?.isHidden = true
            self.vwTextArea?.isHidden = true
            self.stackReport?.isHidden = false
            self.btnDeleteFeed?.setTitle(self.isFromFeedComment ? "Delete Comment" : "Delete Feed", for: .normal)
            self.btnReportFeed?.setTitle(self.isFromFeedComment ? "Report Comment" : "Report Feed", for: .normal)
            
            if let user = UserModel.getCurrentUserFromDefault(),let feeddata = self.selectedFeedData {
                self.vwDeleteFeed?.isHidden = !(user.id == feeddata.userId)
                self.vwReportFeed?.isHidden = (user.id == feeddata.userId)
            }
            if let user = UserModel.getCurrentUserFromDefault(),let feeddata = self.selectedFeedCommentData {
                self.vwDeleteFeed?.isHidden = !(user.id == feeddata.userId)
                self.vwReportFeed?.isHidden = (user.id == feeddata.userId)
            }
        }
    }
}

// MARK: - IBAction
extension PopupViewController {
    @IBAction func btnNoClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnYesClicked(_ sender: XtraHelpButton) {
        if isFirstYes {
            self.isFirstYes = false
            self.lblHeader?.text = "Would you like to make your profile available to other mentees interested in category?"
        } else {
            self.dismiss(animated: true) {
                //self.appNavigationController?.push(SuggestedMentorsViewController.self)
            }
        }
    }
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnReportFeedClicked(_ sender: UIButton) {
        if !self.isFromFeedComment {
            self.dismiss(animated: true) {
                if let obj = self.selectedFeedData {
                    self.feeddelegate?.feedReport(btn: sender, obj: obj)
                }
            }
        } else {
            self.dismiss(animated: true) {
                if let obj = self.selectedFeedCommentData {
                    self.feeddelegate?.feedCommentReport(btn: sender, obj: obj)
                }
            }
        }
    }
    
    @IBAction func btnDeleteFeedClicked(_ sender: UIButton) {
        if !self.isFromFeedComment {
            self.dismiss(animated: true) {
                if let obj = self.selectedFeedData {
                    self.feeddelegate?.feedDelete(btn: sender, obj: obj)
                }
            }
        } else {
            self.dismiss(animated: true) {
                if let obj = self.selectedFeedCommentData {
                    self.feeddelegate?.feedCommentDelete(btn: sender, obj: obj)
                }
            }
        }
    }
}

// MARK: - ViewControllerDescribable
extension PopupViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.auth
    }
}

// MARK: - AppNavigationControllerInteractable
extension PopupViewController: AppNavigationControllerInteractable { }

