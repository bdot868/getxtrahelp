//
//  ConstantIdentifire.swift
//  DDD
//
//  Created by Wdev3 on 30/10/20.
//  Copyright © 2020 Wdev3. All rights reserved.
//

import Foundation

// MARK: - StoryBoard Identifier
struct StoryBoardIdentifier {
    static let HomeTab       = "HomeTab"
    static let DriveTab      = "DriveTab"
    static let BookmarkTab    = "BookmarkTab"
    static  let kSettingPageStoryBoard      =   UIStoryboard(name: "SettingPage", bundle: nil)

}

// MARK: - ViewController Identifier
struct VCIdentifier {
    static let MyJobParentViewController           = "MyJobParentViewController"
    static let CarGiverViewController           = "CarGiverViewController"
    static let HomeViewController           = "HomeViewController"
    static let AppointmentTabViewController       = "AppointmentTabViewController"
    static let FavouriteTabViewController         = "FavouriteTabViewController"
    static let ChatTabListViewController = "ChatTabListViewController"
    static let AddCardVC = "AddCardVC"
    static let FeedViewController  =   "FeedTabListViewController"
    static let CreateJobVC =   "CreateJobVC"
    static let  MyCalenderViewController = "MyCalenderViewController"
    static let MyJobChildViewController = "MyJobChildViewController"
    static let AddAvailabilityViewController = "AddAvailabilityViewController"
    
}

// MARK: - Cell Identifier
struct CellIdentifier {
    static let kAppointmentCell = "AppointmentCell"
    static let kCardCell = "CardCell"
    static let kMembershipPriceCell = "MembershipPriceCell"
}

// MARK: - HeaderView
struct ViewIdentifier {
    static let kCustomerDashBoardHeaderView  = "CustomerDashBoardHeaderView"
    static let kDicusstionHeaderCell  = "DicusstionHeaderCell"
    static let kDicusstionFooterCell = "DicusstionFooterCell"
    static let kCreateFeedTopCell = "CreateFeedTopCell"
    
}

//MARK: - Navigationtitle Name
struct NavigationTitleName {
    static let Profile      = "Profile"
    static let EditProfile  = "Edit Profile Headspace"
    static let SignUp   = "Sign Up"
    static let AccountSetup = "Account Setup"
    static let DashBoard   = "Home"
   
    static let kPushNotification  = "Push Notification"
    static let kFAQ  = "FAQs"
    static let kTermsConditions  = "Terms & Conditions"
    static let kPrivacyPolicy  = "Privacy Policy"
    
    static let kResources = "Resources"
    static let kAboutUs = "About Us"
    static let kSettings = "Settings"
    
    static let kHelpSupport = "Help & Support"
    static let kSupport = "Support"
    static let kNotifications = "Notifications"
    
    static let kRefer = "Refer and Earn"
    
    static let kPurchaseHistory = "Purchase History"
    
    static let kUnit = "Unit 1"
    static let kQuiz = "Quiz"
    
    static let kGiveFeeback = "Give Feeback"
    static let kTableContents = "Table Contents"
    
    static let kQuestionsWronglyAnswered = "Questions Wrongly Answered"
    
    static let kNewTicket = "New Ticket"
    static let kLoginHistory = "Login History"
}
