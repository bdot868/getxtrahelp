//
//  AppNavigationControllerInteractable.swift
//  Om App
//
//  Created by mac on 16/01/2020.
//  Copyright © 2019 Differenzsystem Pvt. LTD. All rights reserved.
//

import UIKit

/*protocol AppNavigationControllerInteractable {
    var appNavigationController: AppNavigationController? { get }
}

// MARK: - Default implementation
extension AppNavigationControllerInteractable {
    var appNavigationController: AppNavigationController? {
        return (UIApplication.shared.keyWindow?.rootViewController as? AppSideMenuMainViewController)?.rootViewController as? AppNavigationController
    }
}*/

/*protocol AppNavigationControllerInteractable {
    var appNavigationController: AppNavigationController? { get }
    //func setuNavigationBarNOtitle(navigationItem: UINavigationItem, isShowBackButtonDashboard: Bool, barTintColor: UIColor)
    //func setuNavigationBarWithTitle(navigationItem: UINavigationItem ,title: String, isShowBackButtonDashboard: Bool, barTintColor: UIColor, titleColor: UIColor, tintColor: UIColor)
    
}

// MARK: - Default implementation
extension AppNavigationControllerInteractable {
    var appNavigationController: AppNavigationController? {
        //return (UIApplication.shared.keyWindow?.rootViewController as? AppSideMenuMainViewController)?.rootViewController as? AppNavigationController
        return UIApplication.shared.keyWindow?.rootViewController as? AppNavigationController
    }
}*/

protocol AppNavigationControllerInteractable {
    var appNavigationController: AppNavigationController? { get }
}

// MARK: - Default implementation
extension AppNavigationControllerInteractable {
    var appNavigationController: AppNavigationController? {
        return (UIApplication.shared.keyWindow?.rootViewController as? AppSideMenuMainViewController)?.rootViewController as? AppNavigationController
    }
}
