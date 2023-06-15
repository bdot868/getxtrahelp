//
//  GiveRatingReviewViewController.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 10/02/22.
//

import UIKit

class GiveRatingReviewViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblUserName: UILabel?
    @IBOutlet weak var lblAvgReting: UILabel?
   
    @IBOutlet weak var vwProfileRound: UIView?
    @IBOutlet weak var vwProfile: UIView?
    @IBOutlet weak var imgProfile: UIImageView?
    // MARK: - Variables
    @IBOutlet weak var vwRating: CosmosView?
    @IBOutlet weak var vwGiveRate: CosmosView?
    @IBOutlet weak var vwReviewText: ReusableTextview?
    // MARK: - Variables
    var selectedJobData : JobModel?
    private var selectedRating : Double = 0
    
    // MARK: - LIfe Cycle Methods
    override func viewDidLoad(){
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.configureNavigationBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
    }
}

// MARK: - Init Configure
extension GiveRatingReviewViewController {
    
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        delay(seconds: 0.2) {
            self.vwProfile?.roundedCornerRadius()
            self.imgProfile?.roundedCornerRadius()
        }
        
        self.lblUserName?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 16.0))
        self.lblUserName?.textColor = UIColor.CustomColor.commonLabelColor
        
        self.lblAvgReting?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 18.0))
        self.lblAvgReting?.textColor = UIColor.CustomColor.commonLabelColor
        
        self.vwProfileRound?.backgroundColor = UIColor.CustomColor.gradiantColorBottom
        
        //delay(seconds: 0.3) {
            if let vw = self.vwProfileRound {
                //vw.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: vw.frame, colors: [UIColor.CustomColor.gradiantColorTop,UIColor.CustomColor.gradiantColorBottom])
                vw.circleCorner = true
            }
        //}
    
        //self.vwGiveRate?.isUserInteractionEnabled = false
        self.vwGiveRate?.didFinishTouchingCosmos = { rating in
            self.selectedRating = rating
        }
        
        if let obj = self.selectedJobData {
            self.lblUserName?.text = obj.userFullName
            self.lblAvgReting?.text = "(\(obj.caregiverRatingAverage))"
            self.vwRating?.rating = Double(obj.caregiverRatingAverage) ?? 0
            self.vwReviewText?.txtInput?.text = obj.jobFeedback
            self.selectedRating = Double(obj.jobRating) ?? 0
            self.vwGiveRate?.rating = Double(obj.jobRating) ?? 0
            self.imgProfile?.setImage(withUrl: obj.profileImageUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        }
        
    }
    
    private func configureNavigationBar(){
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        //appNavigationController?.appNavigationControllerTitle(title: "", TitleColor: UIColor.CustomColor.appColor, navigationItem: self.navigationItem)
        
        appNavigationController?.appNavigationControllersetTitleWithBack(title: "Give Review", TitleColor: UIColor.CustomColor.tabBarColor, navigationItem: self.navigationItem)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
}

// MARK: - IBAction
extension GiveRatingReviewViewController {
    @IBAction func btnSubmitClicked(_ sender: XtraHelpButton) {
        self.view.endEditing(true)
        if let errMessage = self.validateFields() {
            self.showMessage(errMessage, themeStyle: .warning)
            return
        }
        self.setJobReview()
    }
    
    private func validateFields() -> String? {
        if self.selectedRating == 0 {
            return AppConstant.ValidationMessages.KGiveRating
        } else if self.vwReviewText?.txtInput?.isEmpty ?? false {
            return AppConstant.ValidationMessages.KGiveReview
        }
        return nil
    }
}

// MARK: - API Call
extension GiveRatingReviewViewController {
    private func setJobReview(){
        if let user = UserModel.getCurrentUserFromDefault(),let obj = self.selectedJobData {
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kjobId : obj.userJobId,
                krating : self.selectedRating,
                kfeedback : self.vwReviewText?.txtInput?.text ?? ""
                
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            RatingModel.setJobReview(with: param, success: { ( msg) in
                XtraHelp.sharedInstance.isCallJobDetailReloadData = true
                self.navigationController?.popViewController(animated: true)
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    self.showMessage(error,themeStyle : .error)
                }
            })
        }
    }
}

// MARK: - ViewControllerDescribable
extension GiveRatingReviewViewController: ViewControllerDescribable{
    static var storyboardName: StoryboardNameDescribable{
        return UIStoryboard.Name.myJob
    }
}

// MARK: - AppNavigationControllerInteractable
extension GiveRatingReviewViewController: AppNavigationControllerInteractable { }

