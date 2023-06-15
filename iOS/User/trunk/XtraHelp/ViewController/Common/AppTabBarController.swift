//
//  AppTabBarController.swift
//  DifferenzTemplate
//
//  Created by mac on 27/11/19.
//  Copyright © 2019 Differenzsystem Pvt. LTD. All rights reserved.
//

import UIKit
import ViewControllerDescribable

protocol AppTabBarControllerDelegate: class {
    func appTabBarControllerWasClosed(_ tabBarController: AppTabBarController)
}

class AppTabBarController: UITabBarController {
weak var behaviourDelegate: AppTabBarControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}
// MARK: - ViewControllerDescribable
extension AppTabBarController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.main
    }
}

// MARK: - Tabs declaration
extension AppTabBarController {
    enum TabType: Int {
        case home,
        Broadcasts,
        FeedPost,
        OP,
        Trending
        
        var name: String {
            switch self {
            case .home:
                return "Home"
                
            case .Broadcasts:
                return "Broadcasts"
                
            case .FeedPost:
                return "feed"
                
            case .OP:
                return "OP"
            case .Trending:
                return "Trending"
            }
        }
    }
}

// MARK: - UI helpers
fileprivate extension AppTabBarController {
    func configureUI() {
        tabBar.isTranslucent = false
        tabBar.clipsToBounds = true
        tabBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tabBar.backgroundColor = .clear
        tabBar.shadowImage = UIImage()

        let unselectedItemTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        let selectedItemTintColor = #colorLiteral(red: 0.4235294118, green: 0.3921568627, blue: 0.9490196078, alpha: 1)
        tabBar.unselectedItemTintColor = unselectedItemTintColor
        tabBar.tintColor = selectedItemTintColor
       
//        let unselectedItemFont = R.font.ralewayMedium(size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
//        let selectedItemFont = R.font.ralewayBold(size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .bold)
//
//        tabBarItem.setTitleTextAttributes([.font : unselectedItemFont,
//                                           .foregroundColor : unselectedItemTintColor], for: .normal)
//        tabBarItem.setTitleTextAttributes([.font : selectedItemFont,
//                                           .foregroundColor : selectedItemTintColor], for: .selected)
    }
    // MARK: - Button Action
    
    @objc func btnFeedPostClick(_ sender: UIButton) {
      
        self.selectedIndex = 2
        if let nav = self.viewControllers?[2] as? UINavigationController {
            nav.popToRootViewController(animated: false)
        }
    }
}

// MARK: - Interaction
extension AppTabBarController {
    func change(to tab: TabType) {
        selectedIndex = tab.rawValue
    }
}
