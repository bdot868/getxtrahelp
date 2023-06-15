//
//  AppSideMenuMainViewController.swift
//  Momentor
//
//  Created by mac on 16/01/2020.
//  Copyright © 2019 Differenzsystem Pvt. LTD. All rights reserved.
//

import UIKit
import ViewControllerDescribable
import LGSideMenuController

final class AppSideMenuMainViewController: LGSideMenuController
{
    
    weak var leftSideMenu: AppSideMenuViewController?
    weak var rootNavigationController: AppNavigationController?
    
    var leftMenuViewWidth: CGFloat = 0.0
    var sideMenuWidth: Int = 0
    
    override func awakeFromNib() {
        configureUI()
        configureLeftSideMenu()
        configureRootViewController()
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //self.hideLeftView(sender: <#T##Any?#>)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
}

// MARK: - ViewControllerDescribable
extension AppSideMenuMainViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.main
    }
}


// MARK: - AppNavigationControllerMenuDelegate
extension AppSideMenuMainViewController: AppNavigationControllerMenuDelegate {
    func appNavigationController(_ appNavigationController: AppNavigationController,
                                 setLeftMenuEnabled isLeftMenuEnabled: Bool) {
        //isRightViewEnabled = isLeftMenuEnabled
        isLeftViewEnabled = isLeftMenuEnabled
    }
    
    func appNavigationController(_ appNavigationController: AppNavigationController,
                                 setLeftMenuSwipeEnabled isLeftMenuSwipeEnabled: Bool) {
        isLeftViewSwipeGestureEnabled = isLeftMenuSwipeEnabled
        //isRightViewSwipeGestureEnabled = isLeftMenuSwipeEnabled
    }
    
    func appNavigationControllerWasInvokedUpdateMenu(_ appNavigationController: AppNavigationController) {
        leftSideMenu?.updateSections()
        //rightsidemen
    }
   
}

extension AppSideMenuMainViewController : LGSideMenuDelegate {
    func willShowLeftView(sideMenuController: LGSideMenuController) {
        
    }
    
    func didShowLeftView(sideMenuController: LGSideMenuController) {
        
    }
    
    func willHideLeftView(sideMenuController: LGSideMenuController) {
        
    }
    
    func didHideLeftView(sideMenuController: LGSideMenuController) {
        
    }
    
    func willShowRightView(sideMenuController: LGSideMenuController) {
        
    }
    
    func didShowRightView(sideMenuController: LGSideMenuController) {
        
    }
    
    func willHideRightView(sideMenuController: LGSideMenuController) {
        
    }
    
    func didHideRightView(sideMenuController: LGSideMenuController) {
        
    }
    
    func showAnimationsForLeftView(sideMenuController: LGSideMenuController, duration: TimeInterval, timingFunction: CAMediaTimingFunction) {
        
    }
    
    func hideAnimationsForLeftView(sideMenuController: LGSideMenuController, duration: TimeInterval, timingFunction: CAMediaTimingFunction) {
        
    }
    
    func showAnimationsForRightView(sideMenuController: LGSideMenuController, duration: TimeInterval, timingFunction: CAMediaTimingFunction) {
        
    }
    
    func hideAnimationsForRightView(sideMenuController: LGSideMenuController, duration: TimeInterval, timingFunction: CAMediaTimingFunction) {
        
    }
    
    func didTransformRootView(sideMenuController: LGSideMenuController, percentage: CGFloat) {
        
    }
    
    func didTransformLeftView(sideMenuController: LGSideMenuController, percentage: CGFloat) {
        
    }
    
    func didTransformRightView(sideMenuController: LGSideMenuController, percentage: CGFloat) {
        
    }
    
    /*func willHideLeftView(_ leftView: UIView, sideMenuController: LGSideMenuController) {
        print("Will Hide")
        //sideMenuController.rootViewContainer?.layer.cornerRadius = 0.0
    }
    
    func willShowLeftView(_ leftView: UIView, sideMenuController: LGSideMenuController) {
        print("Will Show")
        //sideMenuController.rootViewContainer?.layer.cornerRadius = 20.0
        //sideMenuController.rootViewContainer?.borderColor(UIColor.clear)
    }
    
    func didHideLeftView(_ leftView: UIView, sideMenuController: LGSideMenuController) {
        print("Did Hide")
        //sideMenuController.rootViewContainer?.layer.cornerRadius = 0.0
    }
    
    func didShowLeftView(_ leftView: UIView, sideMenuController: LGSideMenuController) {
        print("Did Show")
        //sideMenuController.rootViewContainer?.layer.cornerRadius = 20.0
        //sideMenuController.rootViewContainer?.borderColor(UIColor.clear)
    }*/
}

// MARK: - UI helpers
fileprivate extension AppSideMenuMainViewController {
    func configureUI() {
        
        /*if DeviceType.IS_PAD {
            sideMenuWidth = 250
        } else{
            sideMenuWidth = 180
        }*/
        leftMenuViewWidth = ScreenSize.SCREEN_WIDTH//(UIScreen.main.bounds.width  - (DeviceType.IS_PAD ? 250 : 250))
        //leftMenuViewWidth = ScreenSize.SCREEN_WIDTH
        sideMenuController?.delegate = self
        sideMenuController?.isLeftViewEnabled = true
        //sideMenuController?.leftViewBackgroundColor = UIColor.CustomColor.appColor
        //sideMenuController?.leftViewBackgroundAlpha = 0.5
        //sideMenuController?.rootViewCoverAlphaForLeftView = 0.5
        //sideMenuController?.rightViewBackgroundColor = UIColor.white
        sideMenuController?.isRootViewStatusBarHidden = false
        //sideMenuController?.leftViewCoverBlurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        //sideMenuController?.swipeGestureArea = .full
        //sideMenuController?.leftViewSwipeGestureArea = .full
        sideMenuController?.swipeGestureArea = .full
        
        //sideMenuController?.rightViewSwipeGestureArea = .full
        
    }
    
    func configureLeftSideMenu() {
        let sideMenuViewController = AppSideMenuViewController.instantiated { [unowned self] vc in
            vc.delegate = self.rootNavigationController
        }
        
        leftSideMenu = sideMenuViewController
    
        leftViewController = sideMenuViewController
        //rightViewController = sideMenuViewController
        leftViewWidth = leftMenuViewWidth
        //rightViewWidth = leftMenuViewWidth
        leftViewPresentationStyle = .slideAbove
        
        isLeftViewSwipeGestureEnabled = false
        isRightViewSwipeGestureEnabled = false
        //let greenCoverColor = UIColor(red: 0.0, green: 0.1, blue: 0.0, alpha: 0.3)
        //leftViewBackgroundColor = UIColor(red: 0.5, green: 0.65, blue: 0.5, alpha: 0.95)
        //rootViewCoverColorForLeftView = greenCoverColor
        //if #available(iOS 13.0, *) {
        rootViewCoverAlphaForLeftView = 0.5
        rootViewCoverBlurEffectForLeftView = UIBlurEffect(style: UIBlurEffect.Style.prominent)
        leftViewLayerShadowColor = UIColor.clear
        //sideMenuController?.rootViewCoverColorForLeftView = UIColor.CustomColor.whitecolor
        
        //} else {
            // Fallback on earlier versions
        //}
    }
    
    func configureRootViewController()
    {
        let appNavigationController = AppNavigationController.instantiated { [unowned self] vc in
            vc.menuDelegate = self
        }
        
        rootNavigationController = appNavigationController
        rootViewController = appNavigationController
        leftSideMenu?.delegate = appNavigationController
    }
}
