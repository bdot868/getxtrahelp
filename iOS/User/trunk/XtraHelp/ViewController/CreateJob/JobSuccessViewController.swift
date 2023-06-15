//
//  JobSuccessViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 04/12/21.
//

import UIKit

class JobSuccessViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblHeader: UILabel?
    @IBOutlet weak var lblSubHeader: UILabel?
    @IBOutlet weak var lblSherAppHeader: UILabel?
    
    @IBOutlet weak var btnSubmit: XtraHelpButton?
    
    @IBOutlet weak var btnTwitter: UIButton?
    @IBOutlet weak var btnFacebook: UIButton?
    @IBOutlet weak var btnInsta: UIButton?
    @IBOutlet weak var btnSher: UIButton?
    // MARK: - Variables
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

// MARK: - Init Configure
extension JobSuccessViewController {
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblHeader?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 28.0))
        
        self.lblSubHeader?.textColor = UIColor.CustomColor.SubscriptuionSubColor
        self.lblSubHeader?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        
        self.lblSherAppHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblSherAppHeader?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 14.0))
        
    }
}

// MARK: - IBAction
extension JobSuccessViewController {
    @IBAction func btnSubmitClicked(_ sender: XtraHelpButton) {
        //self.navigationController?.popToRootViewController(animated: true)
        XtraHelp.sharedInstance.isMoveToTabbarScreen = .MyJobs
        XtraHelp.sharedInstance.setJobEndSelecetdTab = .Posted
        self.appNavigationController?.showDashBoardViewController()
    }
    @IBAction func btnFacebookClicked(_ sender: UIButton) {
        let shareLinkContent = ShareLinkContent()
        shareLinkContent.quote = shareContentApp.kContent
        if let url = URL(string: shareContentApp.kLink) {
            shareLinkContent.contentURL = url
        }
        
        shareLinkContent.hashtag = Hashtag("#XtraHelp")
        
        let sharingDialog = ShareDialog.init(fromViewController: self, content: shareLinkContent, delegate: self)
        sharingDialog.show()
    }
    
    @IBAction func btnInstaClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func btnTwitterClicked(_ sender: UIButton) {
        let shareString = "https://twitter.com/intent/tweet?text=\(shareContentApp.kContent)&url=\(shareContentApp.kLink)"
        
        if let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            // cast to an url
            if let url = URL(string: escapedShareString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    @IBAction func btnSherClicked(_ sender: UIButton) {
        let text = shareContentApp.kContent
        
        var textToShare : [AnyObject] = [ text as AnyObject ]
        if let url = URL(string: shareContentApp.kLink) {
            textToShare = [text as AnyObject,url as AnyObject]
        }
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sender
        
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: - SharingDelegate
extension JobSuccessViewController: SharingDelegate {
  func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
    print("didCompleteWithResults")
  }

  func sharer(_ sharer: Sharing, didFailWithError error: Error) {
    print("didFailWithError: \(error.localizedDescription)")
  }

  func sharerDidCancel(_ sharer: Sharing) {
    print("sharerDidCancel")
  }
}

// MARK: - ViewControllerDescribable
extension JobSuccessViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.CreateJob
    }
}

// MARK: - AppNavigationControllerInteractable
extension JobSuccessViewController: AppNavigationControllerInteractable { }
