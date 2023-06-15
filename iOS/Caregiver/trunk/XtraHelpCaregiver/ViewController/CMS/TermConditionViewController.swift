//
//  TermConditionViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 29/11/21.
//

import UIKit

class TermConditionViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var webContentView: WKWebView?
    
    @IBOutlet weak var viewWeb: UIView?
    
    // MARK: - Variables
    var selectedFAQId : String = ""
    var titleName : String = ""
    var pageid : pageIDEnum = .PrivacyPolicy
    var isFromFAQ : Bool = false
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureNavigationBar()
    }
}

// MARK: - Init Configure
extension TermConditionViewController {
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        //webContentView = WKWebView(frame: viewWeb.bounds, configuration: WKWebViewConfiguration())
        webContentView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //self.viewWeb.addSubview(webContentView)
        self.webContentView?.isOpaque = false
        
        webContentView?.uiDelegate = self
        webContentView?.navigationDelegate = self
        webContentView?.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        /*if let link = URL(string:"https://www.apple.com/") {
            let req = URLRequest(url: link)
            self.webContentView.load(req)
        }*/
        //self.getCMSData()
        
        SVProgressHUD.show()
        delay(seconds: 0.1) {
            if self.isFromFAQ {
                self.getFaqDetailAPI()
            }
            else{
                self.getCMSData()
            }
        }
    }
    
    private func configureNavigationBar() {
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllersetTitleWithBack(title: isFromFAQ ? "FAQs" : "\(pageid.name)", TitleColor: UIColor.CustomColor.tabBarColor, navigationItem: self.navigationItem)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
}

// MARK: - API
extension TermConditionViewController {
    
    private func getFaqDetailAPI(){
       if let user = UserModel.getCurrentUserFromDefault() {
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                kfaqId : self.selectedFAQId,
                ktoken : user.token,
                ktype : XtraHelp.sharedInstance.carGiverType
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
           FAQModel.getFAQDetail(with: param, success: { (cmsdata, msg) in
                
                let css = """
                               <head>\
                               <link rel="stylesheet" type="text/css" href="iPhoneResources.css">\
                               </head>
                               """
               
                let newString = cmsdata.FAQdescription.replacingOccurrences(of: "<style>*,p{font-size:20px !important;}</style>", with: "")
                let content = """
                <body> \(newString)</body>
                """
                SVProgressHUD.show()
                self.webContentView?.loadHTMLString("\(css)\(content)", baseURL: URL(fileURLWithPath: Bundle.main.path(forResource: "iPhoneResources", ofType: "css") ?? ""))
                
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    self.showMessage(errorType.rawValue, themeStyle: .error)
                }
            })
        }
    }
    
    private func getCMSData(){
        
        let dict : [String:Any] = [
            klangType : XtraHelp.sharedInstance.languageType,
            kpageId : self.pageid.pageid
        ]
        
        let param : [String:Any] = [
            kData : dict
        ]
        
        CMSModel.getCMSContent(with: param, success: { (cmsdata, msg) in
            
            let css = """
                               <head>\
                               <link rel="stylesheet" type="text/css" href="iPhone.css">\
                               </head>
                               """
            let content = """
            <body> \(cmsdata.cmsdescription)</body>
            """
            SVProgressHUD.show()
            self.webContentView?.loadHTMLString("\(css)\(content)", baseURL: URL(fileURLWithPath: Bundle.main.path(forResource: "iPhone", ofType: "css") ?? ""))
            
        }, failure: {[unowned self] (statuscode,error, errorType) in
            print(error)
            if !error.isEmpty {
                self.showMessage(error, themeStyle: .error)
                //self.showAlert(withTitle: errorType.rawValue, with: error)
            }
        })
    }
}

// MARK: - ViewControllerDescribable
extension TermConditionViewController : WKNavigationDelegate,WKUIDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == WKNavigationType.linkActivated {
                print("link")
                if let url = navigationAction.request.url {
                    print(url.absoluteString)
                   
                    guard let url = URL(string: url.absoluteString) else {
                            return
                        }

                        if ["http", "https"].contains(url.scheme?.lowercased() ?? "") {
                            let safariVC = SFSafariViewController(url: url)
                            safariVC.delegate = self
                            self.present(safariVC, animated: true, completion: nil)
                        } else {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                decisionHandler(WKNavigationActionPolicy.cancel)
                return
            }
            print("no link")
            decisionHandler(WKNavigationActionPolicy.allow)
     }
}

// MARK: - SFSafariViewControllerDelegate
extension TermConditionViewController : SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - ViewControllerDescribable
extension TermConditionViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.CMS
    }
}

// MARK: - AppNavigationControllerInteractable
extension TermConditionViewController: AppNavigationControllerInteractable{}
