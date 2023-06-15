//
//  LinkedinManagerViewController.swift
//  Momentor
//
//  Created by wmdevios-h on 11/08/21.
//

import UIKit
import WebKit

protocol LinkedinDelegate {
    func linkeDinData(firstname : String,lastname : String,email : String,profile : String,linkedinID : String)
}

class LinkedinManagerViewController: UIViewController {
    
    @IBOutlet weak var vwNavigation: UIView!
    
    @IBOutlet weak var vwWeb: UIView!
    
    static let shared = LinkedinManagerViewController()
    
    var delegate : LinkedinDelegate?
    
    var linkedInId = ""
    var linkedInFirstName = ""
    var linkedInLastName = ""
    var linkedInEmail = ""
    var linkedInProfilePicURL = ""
    var linkedInAccessToken = ""
    
    var webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.InitConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.webView.cleanAllCookies()
        //self.webView.refreshCookies()
        self.linkedInAuthVC()
        self.ConfigureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.webView.cleanAllCookies()
    }
}

// MARK: - Init Configure Methods
extension LinkedinManagerViewController {
    private func InitConfigure() {
        
    }
    
    func linkedInAuthVC() {
        
        
        self.view.backgroundColor = UIColor.CustomColor.LinkedinColor
        //self.vwNavigation.backgroundColor = UIColor.CustomColor.LinkedinColor
        
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.uiDelegate = self
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: self.vwWeb.topAnchor),
            webView.leadingAnchor.constraint(equalTo: self.vwWeb.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: self.vwWeb.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: self.vwWeb.trailingAnchor)
            ])

        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"

        let authURLFull = "https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=78ab6vx75k4ahc&scope=\(LinkedInConstants.SCOPE)&state=\(state)&redirect_uri=https://xtrahelp.com"
        self.webView.cleanAllCookies()
        self.webView.refreshCookies()
        print(authURLFull)
        if let loadurl =  URL(string: authURLFull) {
            if let urlRequest = URLRequest(url: loadurl) as? URLRequest {
                SVProgressHUD.show()
                webView.load(urlRequest)
            }
        }
    }

    @objc func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func refreshAction() {
        self.webView.reload()
    }
    
    private func ConfigureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar
        .configure(barTintColor: UIColor.white, tintColor: UIColor.white)
        navigationController?.navigationBar.removeShadowLine()
        
        self.navigationItem.setHidesBackButton(true, animated: true)

        //appNavigationController?.appNavigationControllerTitle(title: "Linkedin.in", TitleColor: UIColor.white,navigationItem: self.navigationItem, isShowRightBtn : true,RightBtnTitle: "Reload")
        appNavigationController?.appNavigationControllerLinkdnTitle(title: "Linkedin.in", navigationItem: self.navigationItem,RightBtnTitle: "Reload")
        self.appNavigationController?.btnNextClickBlock = {
            //SVProgressHUD.show()
            self.webView.cleanAllCookies()
            self.webView.refreshCookies()
            self.webView.reload()
        }
        navigationController?.title = "Linkedin.in"
        self.title = "Linkedin.in"
    }
    
}

// MARK: - IBAction
extension LinkedinManagerViewController {
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnReloadClicked(_ sender: UIButton) {
        SVProgressHUD.show()
        self.webView.cleanAllCookies()
        self.webView.refreshCookies()
        self.webView.reload()
    }
}

// MARK: - WKNavigationDelegate
extension LinkedinManagerViewController: WKNavigationDelegate,WKUIDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation, withError error: Error) {
        SVProgressHUD.dismiss()
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        RequestForCallbackURL(request: navigationAction.request)
        
        //Close the View Controller after getting the authorization code
        if let urlStr = navigationAction.request.url?.absoluteString {
            if urlStr.contains("?code=") {
                //self.dismiss(animated: true, completion: nil)
            }
        }
        decisionHandler(.allow)
    }

    func RequestForCallbackURL(request: URLRequest) {
        // Get the authorization code string after the '?code=' and before '&state='
        let requestURLString = (request.url?.absoluteString) as? String ?? ""
        if requestURLString.hasPrefix(LinkedInConstants.REDIRECT_URI) {
            if requestURLString.contains("?code=") {
                if let range = requestURLString.range(of: "=") {
                    let linkedinCode = requestURLString[range.upperBound...]
                    if let range = linkedinCode.range(of: "&state=") {
                        let linkedinCodeFinal = linkedinCode[..<range.lowerBound]
                        handleAuth(linkedInAuthorizationCode: String(linkedinCodeFinal))
                    }
                }
            }
        }
    }

    func handleAuth(linkedInAuthorizationCode: String) {
        linkedinRequestForAccessToken(authCode: linkedInAuthorizationCode)
    }

    func linkedinRequestForAccessToken(authCode: String) {
        let grantType = "authorization_code"

        // Set the POST parameters.
        let postParams = "grant_type=" + grantType + "&code=" + authCode + "&redirect_uri=" + LinkedInConstants.REDIRECT_URI + "&client_id=" + LinkedInConstants.CLIENT_ID + "&client_secret=" + LinkedInConstants.CLIENT_SECRET
        
        let postData = postParams.data(using: String.Encoding.utf8)
        if let mutableurl = URL(string: LinkedInConstants.TOKENURL) {
            SVProgressHUD.show()
            let request = NSMutableURLRequest(url: mutableurl)
            request.httpMethod = "POST"
            request.httpBody = postData
            request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                SVProgressHUD.dismiss()
                if let res = response as? HTTPURLResponse{
                    let statusCode = res.statusCode
                    if statusCode == 200 {
                        if let reponsedata = data {
                            do {
                                let results = try JSONSerialization.jsonObject(with: reponsedata, options: .allowFragments) as? [AnyHashable: Any]
                                
                                let accessToken = results?["access_token"] as? String ?? ""
                                print("accessToken is: \(accessToken)")
                                
                                let expiresIn = results?["expires_in"] as? Int ?? 0
                                print("expires in: \(expiresIn)")
                                
                                // Get user's id, first name, last name, profile pic url
                               // self.fetchLinkedInUserProfile(accessToken: accessToken)
                                self.fetchLinkedInEmailAddress(accessToken: accessToken)
                            } catch {
                                print("Failed")
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
            task.resume()
        }
    }

    func fetchLinkedInUserProfile(accessToken: String) {
        let tokenURLFull : String = "https://api.linkedin.com/v2/me?projection=(id,firstName,lastName,profilePicture(displayImage~:playableStreams))&oauth2_access_token=\(accessToken)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        //vanityName
        //let tokenURLFull : String = "https://api.linkedin.com/v2/me?projection=(id,firstName,lastName,profilePicture)&oauth2_access_token=\(accessToken)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let verify = NSURL(string: tokenURLFull) {
            SVProgressHUD.show()
 
           // let verify: NSURL = NSURL(string: tokenURLFull!)!
            let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
            //request.httpMethod = "GET"
            //request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                SVProgressHUD.dismiss()
                if error == nil {
                    
                    if let res = response as? HTTPURLResponse{
                        let statusCode = res.statusCode
                        if statusCode == 200 {
                            if let reponsedata = data {

                                //print(data)
                                //self.fetchLinkedInEmailAddress(accessToken: accessToken)
                                let linkedInProfileModel = try? JSONDecoder().decode(LinkedInProfileModel.self, from: reponsedata)
                                /*do {
                                    let json = try JSONSerialization.jsonObject(with: reponsedata, options: []) as? [String : Any]
                                    if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                                        print("Response: \n",String(data: jsonData, encoding: String.Encoding.utf8) ?? "nil")
                                    }
                                    
                                } catch {
                                        
                                }*/
                                
                                //let f = try? JSONDecoder.
                                //AccessToken
                                print("LinkedIn Access Token: \(accessToken)")
                                self.linkedInAccessToken = accessToken
                                
                                // LinkedIn Id
                                let linkedinId: String = linkedInProfileModel?.id ?? ""
                                print("LinkedIn Id: \(linkedinId ?? "")")
                                self.linkedInId = linkedinId
                                
                                // LinkedIn First Name
                                let linkedinFirstName: String = linkedInProfileModel?.firstName.localized.enUS ?? ""
                                print("LinkedIn First Name: \(linkedinFirstName ?? "")")
                                self.linkedInFirstName = linkedinFirstName
                                
                                // LinkedIn Last Name
                                let linkedinLastName: String = linkedInProfileModel?.lastName.localized.enUS ?? ""
                                print("LinkedIn Last Name: \(linkedinLastName ?? "")")
                                self.linkedInLastName = linkedinLastName
                                
                                // LinkedIn Profile Picture URL
                                var linkedinProfilePic: String = ""
                                
                                /*
                                 Change row of the 'elements' array to get diffrent size of the profile url
                                 elements[0] = 100x100
                                 elements[1] = 200x200
                                 elements[2] = 400x400
                                 elements[3] = 800x800
                                 */
                                
                                if let pic = linkedInProfileModel?.profilePicture {
                                    
                                    let dimage = pic.displayImage.elements
                                    if dimage.count > 0 {
                                        for i in stride(from: 0, to: dimage.count, by: 1) {
                                            if i == 2 {
                                                if dimage[i].identifiers.count > 0 {
                                                    if let first = dimage[i].identifiers.first {
                                                        linkedinProfilePic = first.identifier
                                                        //break
                                                    }
                                                }
                                                break
                                            }
                                        }
                                    }
                                }
                                
                               /* if let pictureUrls = linkedInProfileModel?.profilePicture.displayImage.elements[2].identifiers[0].identifier {
                                    linkedinProfilePic = pictureUrls
                                } else {
                                    linkedinProfilePic = "Not exists"
                                }*/
                                print("LinkedIn Profile Avatar URL: \(linkedinProfilePic ?? "")")
                                self.linkedInProfilePicURL = linkedinProfilePic
                                
                                DispatchQueue.main.async {
                                    
                                    //self.dismiss(animated: true, completion: nil)
                                    self.dismiss(animated: true) {
                                        if let del = self.delegate {
                                            del.linkeDinData(firstname: self.linkedInFirstName, lastname: self.linkedInLastName, email: self.linkedInEmail, profile: self.linkedInProfilePicURL, linkedinID: self.linkedInId)
                                        }
                                    }
                                    
                                }
                                
                                // Get user's email address
                                //self.fetchLinkedInEmailAddress(accessToken: accessToken)
                            }
                        } else {
                                print(res)
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
            task.resume()
        }
    }

    func fetchLinkedInEmailAddress(accessToken: String) {
        let tokenURLFull = "https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))&oauth2_access_token=\(accessToken)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let verify = NSURL(string: tokenURLFull ?? "") {
            SVProgressHUD.show()
            // let verify: NSURL = NSURL(string: tokenURLFull!)!
            let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
            
           // let verify: NSURL = NSURL(string: tokenURLFull!)!
           // let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                SVProgressHUD.dismiss()
                if error == nil {
                    
                        if let res = response as? HTTPURLResponse{
                            let statusCode = res.statusCode
                            if statusCode == 200 {
                                if let reponsedata = data {
                                    //print(data)
                                    let linkedInEmailModel = try? JSONDecoder().decode(LinkedInEmailModel.self, from: reponsedata)
                                    
                                    // LinkedIn Email
                                    if let el =  linkedInEmailModel?.elements{
                                        if el.count > 0 {
                                            if let first = el.first, let linkedinEmail = first.elementHandle.emailAddress as? String {
                                                print("LinkedIn Email: \(linkedinEmail )")
                                                self.linkedInEmail = linkedinEmail
                                            }
                                        }
                                    }
                                   
                                    /*DispatchQueue.main.async {
                                     self.performSegue(withIdentifier: "detailseg", sender: self)
                                     }*/
                                    self.fetchLinkedInUserProfile(accessToken: accessToken)
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.dismiss(animated: true, completion: nil)
                                }
                            }
                        }
                }
            }
            task.resume()
        }
    }


}

// MARK: - ViewControllerDescribable
extension LinkedinManagerViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.auth
    }
}
// MARK: - AppNavigationControllerInteractable
extension LinkedinManagerViewController: AppNavigationControllerInteractable { }
