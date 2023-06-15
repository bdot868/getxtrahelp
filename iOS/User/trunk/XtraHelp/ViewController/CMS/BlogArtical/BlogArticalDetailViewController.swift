//
//  BlogArticalDetailViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 03/12/21.
//

import UIKit

class BlogArticalDetailViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var vwCategoryMain: UIView?
    @IBOutlet weak var vwCategorySub: UIView?
    @IBOutlet weak var vwOverlay: UIView?
    @IBOutlet weak var vwDetailMain: UIView?
    
    @IBOutlet weak var imgArtical: UIImageView?
    
    @IBOutlet weak var lblBlogTitle: UILabel?
    @IBOutlet weak var lblBlogDesc: UILabel?
    @IBOutlet weak var lblCategoryName: UILabel?
    
    // MARK: - Variables
    var selectedBlogData : ResourcesAndBlogsModel?
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let vw = self.vwCategorySub {
            vw.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: vw.frame, colors: [UIColor.CustomColor.gradiantColorTop,UIColor.CustomColor.gradiantColorBottom])
        }
        
        if let vw = self.vwOverlay {
            vw.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: vw.frame, colors: [UIColor.CustomColor.GradiantTabBarColor0,UIColor.CustomColor.GradiantTabBarColor75,UIColor.CustomColor.tabBarColor])
        }
        
    }
}


// MARK: - Init Configure
extension BlogArticalDetailViewController {
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblBlogTitle?.textColor = UIColor.CustomColor.tabBarColor
        self.lblBlogTitle?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 35.0))
        
        self.lblBlogDesc?.textColor = UIColor.CustomColor.BlogDescColor
        self.lblBlogDesc?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        
        self.lblCategoryName?.textColor = UIColor.CustomColor.whitecolor
        self.lblCategoryName?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 10.0))
        
        self.vwCategorySub?.cornerRadius = 4.0
        self.vwDetailMain?.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        delay(seconds: 0.2) {
            self.vwDetailMain?.roundCorners(corners: [.topLeft,.topRight], radius: 40.0)
        }
        
        if let obj = self.selectedBlogData {
            self.lblBlogTitle?.text = obj.title
            self.lblBlogDesc?.text = obj.resdescription
            self.imgArtical?.setImage(withUrl: obj.imageUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.AppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
            self.lblCategoryName?.text = obj.categoryName
        }
        
    }
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllerBlogDetail(navigationItem: self.navigationItem)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
        
        
        /*appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        //appNavigationController?.appNavigationControllerTitle(title: "", TitleColor: UIColor.CustomColor.appColor, navigationItem: self.navigationItem)
        
        appNavigationController?.appNavigationControllerTitle(title: "", TitleColor: UIColor.CustomColor.appColor, navigationItem: self.navigationItem, isHideBackButton: false, isShowRightBtn: true, RightBtnTitle: "Edit Profile")
        
        appNavigationController?.btnNextClickBlock = {
            self.appNavigationController?.push(SignupPersonalDetailViewController.self,configuration: { vc in
                vc.isFromEditProfile = true
            })
        }
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()*/
    }
}

// MARK: - ViewControllerDescribable
extension BlogArticalDetailViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.CMS
    }
}

// MARK: - AppNavigationControllerInteractable
extension BlogArticalDetailViewController: AppNavigationControllerInteractable { }
