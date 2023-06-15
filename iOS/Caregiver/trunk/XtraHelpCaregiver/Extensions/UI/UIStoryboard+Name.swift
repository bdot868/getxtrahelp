//
//  UIStoryboard+Name.swift
//  Momentor
//
//  Created by mac on 16/01/2020.
//  Copyright © 2019 Differenzsystem Pvt. LTD. All rights reserved.
//

import UIKit
import ViewControllerDescribable

extension UIStoryboard {
    enum Name: String, StoryboardNameDescribable {
        case main = "Main",
        auth = "Auth",
        myJob = "myJob",
        carGiver = "CarGiver",
        DashBoard = "DashBoard",
        Home = "Home",
        Appointment = "Appointment",
        FavouriteTab = "FavouriteTab",
         FeedTab = "FeedTab",
        CMS = "CMS",
        Payment = "Payment",
        Profile = "Profile",
        MedicalHistory = "MedicalHistory",
        Communication = "Communication",
        Chat = "Chat",
        MyCalender = "MyCalender"
        
    }
    func getViewController(with identifier: String) -> UIViewController {
        return self.instantiateViewController(withIdentifier: identifier)
    }
    class func getStoryboard(for name: String) -> UIStoryboard {
        return UIStoryboard(name: name, bundle: nil)
    }
    
}
