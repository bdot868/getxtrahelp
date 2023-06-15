//
//  StripeConnectViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 14/02/22.
//

import UIKit

protocol stripeConnectDelegate {
    func successStripe()
}

class StripeConnectViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var webContentView: WKWebView!
    
    @IBOutlet weak var viewWeb: UIView!
    
    // MARK: - Variables
    var stripeID : String = ""
    var stripeURL : String = ""
    var delegate : stripeConnectDelegate?
    var isHideBackbtn : Bool = false
    var isfromLogin : Bool = false
    var isFromHomeScreen : Bool = false
    var isFromHomeShowBankDetail : Bool = false
    var connectAccount : ConnectAccountModel?
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureNavigationBar()
        
        //self.loadStripeConnectURL()
    }
}

// MARK: - Init Configure
extension StripeConnectViewController {
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.whitecolor
        
        //webContentView = WKWebView(frame: viewWeb.bounds, configuration: WKWebViewConfiguration())
        webContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //self.viewWeb.addSubview(webContentView)
        self.webContentView.isOpaque = false
        
        webContentView.uiDelegate = self
        webContentView.navigationDelegate = self
        webContentView.allowsBackForwardNavigationGestures = true
        self.webContentView.cleanAllCookies()
        self.connectStripeAPICall()
    }
    
    private func configureNavigationBar() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        appNavigationController?.setNavigationBarHidden(false, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationItem.setHidesBackButton(true, animated: true)
        //appNavigationController?.appNavigationControllersetTitleWithBack(title: "", TitleColor: .clear, navigationItem: self.navigationItem,isHideBackbtn : self.isHideBackbtn)
        //appNavigationController?.appNavigationControllerTitle(title: "", TitleColor: .clear, navigationItem: self.navigationItem,isHideBackButton: self.isHideBackbtn)
        
        appNavigationController?.appNavigationControllersetTitleWithBack(title: "", TitleColor: UIColor.CustomColor.tabBarColor, navigationItem: self.navigationItem)
        
        self.title = "Stripe"
        
        appNavigationController?.navigationBar
            .configure(barTintColor: UIColor.white, tintColor: UIColor.CustomColor.barbuttoncolor)
        appNavigationController?.navigationBar.removeShadowLine()
        
    }
    
    private func loadStripeConnectURL() {
        
        if let url = NSURL(string: self.stripeURL) {
            SVProgressHUD.show()
            self.webContentView.load(URLRequest(url: url as URL))
        }
    }
}

//MARK: - WKNavigationDelegate,WKUIDelegate
extension StripeConnectViewController : WKNavigationDelegate, WKUIDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        _ = navigationResponse.response as? HTTPURLResponse
        decisionHandler(.allow)
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.url {
            let urlString  = url.absoluteString
            print("URL String : \(urlString)")
            if urlString.hasPrefix(AppConstant.API.StripeRedirectURI) {
                var responseString: String? = nil
                do {
                    responseString = try String(
                        contentsOf: URL(string: urlString)!,
                        encoding: String.Encoding(rawValue: String.Encoding.ascii.rawValue))
                    let  json = convertToDictionary(text: responseString ?? "") ?? [String:Any]()
                    if json["close"] as? Bool == true {
                        //self.delegate?.successStripe()
                        //self.navigationController?.popViewController(animated: true)
                        if let user = UserModel.getCurrentUserFromDefault() {
                            user.isStripeConnect = "1"
                            user.saveCurrentUserInDefault()
                        }
                        /*if isFromHomeScreen {
                            if self.isFromHomeShowBankDetail {
                                self.appNavigationController?.push(BankAccountViewController.self,configuration: { (vc) in
                                    vc.isfromLogin = false
                                    vc.isHideBackbtn = true
                                    vc.isFromHomeScreen = true
                                    vc.isDirectFromHomeScreen = false
                                })
                            } else {
                                Chiry.sharedInstance.isReloadDashboardData = true
                                self.appNavigationController?.popViewController(animated: true)
                            }
                        } else {*/
                            self.appNavigationController?.push(BankAccountViewController.self,configuration: { (vc) in
                                vc.isFromAccountScreen = false
                            })
                        //}
                    }
                } catch {
                }
            } else {
                print("Not Redirect URL")
            }
        }
        decisionHandler(.allow)
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showMessage("\(error.localizedDescription)", themeStyle: .error)
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
// MARK: - API Call
extension StripeConnectViewController {
    private func connectStripeAPICall() {
        if let user = UserModel.getCurrentUserFromDefault() {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            AccountModel.connectStripe(with: param, success: { (msg,accID,stripeURL) in
                /*self.appNavigationController?.push(StripeConnectViewController.self, configuration: { (vc) in
                    vc.stripeURL = stripeURL
                    vc.stripeID = accID
                    vc.delegate = self
                })*/
                self.stripeID = accID
                self.stripeURL = stripeURL
                self.loadStripeConnectURL()
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    //self.showAlert(withTitle: errorType.rawValue, with: error)
                    self.showMessage(error, themeStyle: .error)
                    self.showAlert(withTitle: "", with: error, firstButton: ButtonTitle.Yes, firstHandler: { (alert) in
                        self.connectStripeAPICall()
                    }, secondButton: ButtonTitle.No, secondHandler: nil)
                }
            })
        }
    }
}
// MARK: - API Call
extension StripeConnectViewController {
    
}

// MARK: - ViewControllerDescribable
extension StripeConnectViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.CMS
    }
}

// MARK: - AppNavigationControllerInteractable
extension StripeConnectViewController: AppNavigationControllerInteractable{}

