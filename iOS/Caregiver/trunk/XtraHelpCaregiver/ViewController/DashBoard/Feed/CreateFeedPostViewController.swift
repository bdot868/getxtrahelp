//
//  CreateFeedPostViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 26/11/21.
//

import UIKit

protocol FeedDelegate {
    func updateFeedData()
}

class CreateFeedPostViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var vwTopMain: UIView?
    @IBOutlet weak var vwContentMain: UIView?
    
    @IBOutlet weak var constraintBottomMain: NSLayoutConstraint?
    
    @IBOutlet weak var txtPost: ReusableTextview?
    
    @IBOutlet weak var btnPost: UIButton?
    
    @IBOutlet weak var imgProfile: UIImageView?
    
    @IBOutlet weak var cvPhotoVideo: UICollectionView?
    
    // MARK: - Variables
    private var arrPhotoVideo : [AddPhotoVideoModel] = []
    private let imagePicker = ImagePicker()
    private let videoPicker = VideoPicker()
    var delegate : FeedDelegate?
    var selectedFeedData : FeedModel?
    var isFromEdit : Bool = false
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InitConfig()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        self.addKeyboardObserver()
        self.configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardObserver()
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Enable IQKeyboardManager
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Disable IQKeyboardManager
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
       // if let vwseg = self.txtPost {
            //self.heightSegmentConstarint?.constant = self.view.safeAreaInsets.top + 30.0 + vwseg.frame.height
        //self.topConstraintMain?.constant = self.view.safeAreaInsets.top
            //self.vwTopMain?.layoutIfNeeded()
            
        //}
        /*if let vw = self.vwTopMain {
            vw.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: vw.frame, colors: [UIColor.CustomColor.gradiantColorBottom,UIColor.CustomColor.gradiantColorTop])
        }*/
        
        //self.vwTopMain?.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 30.0)
        
        if let img = self.imgProfile {
            img.cornerRadius = img.frame.height/2
        }
    }
}

// MARK: - Init Configure
extension CreateFeedPostViewController {
    private func InitConfig(){
        
        self.imagePicker.viewController = self
        self.videoPicker.viewController = self
        
        /*self.txtPost?.placeholder = "What's in your mind?"
        self.txtPost?.placeholderColor = UIColor.CustomColor.appPlaceholderColor
        self.txtPost?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        self.txtPost?.textColor = UIColor.CustomColor.blackColor*/
        //self.txtPost?.delegate = self
       
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
       
        //self.vwContentMain?.cornerRadius = 10.0
        
        self.btnPost?.titleLabel?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 14.0))
        self.btnPost?.setTitleColor(UIColor.CustomColor.appColor, for: .normal)
        
        
        //self.vwTopMain?.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 30.0)
        
        self.cvPhotoVideo?.delegate = self
        self.cvPhotoVideo?.dataSource = self
        self.cvPhotoVideo?.register(CreateJobAddPhotoVideoCell.self)
        
        if let user = UserModel.getCurrentUserFromDefault() {
            self.imgProfile?.setImage(withUrl: user.profileimage, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.UserAppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        }
        
        if self.isFromEdit,let obj = self.selectedFeedData {
            self.btnPost?.setTitle("Update", for: .normal)
            self.txtPost?.txtInput?.text = obj.feed.decodingEmoji()
            self.arrPhotoVideo = obj.imageVideo
            self.cvPhotoVideo?.reloadData()
        }
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllerTitle(title: "", TitleColor: UIColor.CustomColor.textHedareLogin, navigationItem: self.navigationItem)
        
        self.title = "Create Feed"
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
}

//MARK: - UICollectionView Delegate and Datasource Method
extension CreateFeedPostViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrPhotoVideo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CreateJobAddPhotoVideoCell.self)
        //cell.imgVideo?.isHidden = (indexPath.row == 0) || (indexPath.row == 4) || (indexPath.row == 5)
        //cell.isAddNewPhotoVideo = (indexPath.row == self.arrPhotoVideo.count)
        cell.btnSelect?.isHidden = false
        if indexPath.row != self.arrPhotoVideo.count{
            if self.arrPhotoVideo.count > 0 {
                let obj = self.arrPhotoVideo[indexPath.row]
                cell.imgVideo?.isHidden = !obj.isVideo
                if obj.isVideo {
                    cell.imgPhoto?.image = obj.videoThumpImg
                } else {
                    cell.imgPhoto?.setImage(withUrl: obj.mediaNameUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.AppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
                }
            }
        }
        cell.btnDelete?.tag = indexPath.row
        cell.btnDelete?.addTarget(self, action: #selector(self.btnDeleteClicked(_:)), for: .touchUpInside)
        
        cell.btnSelect?.tag = indexPath.row
        cell.btnSelect?.addTarget(self, action: #selector(self.btnSelectClicked(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    @objc func btnDeleteClicked(_ btn : UIButton){
        self.arrPhotoVideo.remove(at: btn.tag)
        self.cvPhotoVideo?.reloadData()
    }
    
    @objc func btnSelectClicked(_ btn : UIButton){
        if self.arrPhotoVideo.count > 0 {
            let obj = self.arrPhotoVideo[btn.tag]
            if obj.isVideo {
                if let videoURL = URL(string: obj.mediaNameUrl) {
                    let player = AVPlayer(url: videoURL)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    self.present(playerViewController, animated: true) {
                        if let myplayer = playerViewController.player {
                            myplayer.play()
                        }
                    }
                }
            } else {
                self.appNavigationController?.present(ImagePreviewViewController.self, configuration: { (vc) in
                    vc.imageUrl = obj.mediaNameUrl
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .crossDissolve
                })
            }
        }
    }
}

//MARK: - NotificateionValueDelegate methods
extension CreateFeedPostViewController {
    
    //MARK:- Notification observer for keyboard
    func addKeyboardObserver () {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // *** Hide keyboard when tapping outside ***
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func removeKeyboardObserver () {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                }
            }
            
            self.constraintBottomMain?.constant = keyboardHeight + (DeviceType.IS_PAD ? 18 : 9)
            view.layoutIfNeeded()
        }
    }
    
    @objc func tapGestureHandler() {
        view.endEditing(true)
    }
}

// MARK: - IBAction
extension CreateFeedPostViewController {
    @IBAction func btnPostClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if (self.txtPost?.txtInput?.isEmpty ?? false) && self.arrPhotoVideo.isEmpty {
            self.showMessage("Please add feed data", themeStyle: .warning, presentationStyle: .top)
            return
        }
        self.setFeedAPI()
    }
    
    @IBAction func btnAddImageClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.imagePicker.isAllowsEditing = true
        self.imagePicker.pickImage(sender, "Select Image") { (img,url) in
            self.mediaAPICall(img: img,index : sender.tag)
        }
    }
    @IBAction func btnAddVideoClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.videoPicker.isAllowsEditing = false
        self.videoPicker.pickImage(sender,Title: "Select Video") { (data,url)  in
            //self.videoData = data
            
            AVAsset(url: url).generateThumbnail { [weak self] (image) in
                DispatchQueue.main.async {
                    guard let image = image else { return }
                    //self?.thumnailImg = image
                    self?.videomediaAPICall(img: image, videodata: data, index: sender.tag)
                }
            }
        }
    }
}

// MARK: - API Call
extension CreateFeedPostViewController {
    
    private func mediaAPICall(img : UIImage,index : Int) {
        let dict : [String:Any] = [
            klangType : XtraHelp.sharedInstance.languageType
        ]
        
        UserModel.uploadFeedMedia(with: dict, image: img, success: { (msg,urldata) in
            //let model = AddPhotoVideoModel.init(Id: "", FeedId: "", MediaNameUrl: urldata, MediaName: msg, isvideo: false, VideoImage: "", videothumpimg: UIImage(), MediaNameThumbUrl: "", VideoImageUrl: "", VideoImageThumbUrl: "")
            let model = AddPhotoVideoModel.init(UserJobMediaId: "", JobId: "", MediaNameUrl: urldata, MediaName: msg, isvideo: false, VideoImage: "", videothumpimg: UIImage(), MediaNameThumbUrl: "", VideoImageUrl: "", VideoImageThumbUrl: "")
            
            self.arrPhotoVideo.append(model)
            self.cvPhotoVideo?.reloadData()
        }, failure: {[unowned self] (statuscode,error, errorType) in
            print(error)
            if !error.isEmpty {
                self.showMessage(error, themeStyle: .error)
            }
        })
    }
    
    private func videomediaAPICall(img : UIImage,videodata : NSData,index : Int) {
        let dict : [String:Any] = [
            klangType : XtraHelp.sharedInstance.languageType
        ]
        
        AddPhotoVideoModel.addFeedVideoAPI(with: videodata, image: nil, param: dict, success: { (videomedianame,videourldata,videoImgThumnailurl,videoImgName) in
            let model = AddPhotoVideoModel.init(UserJobMediaId: "", JobId: "", MediaNameUrl: videourldata, MediaName: videomedianame, isvideo: true, VideoImage: videoImgName, videothumpimg: img, MediaNameThumbUrl: videoImgName, VideoImageUrl: videoImgThumnailurl, VideoImageThumbUrl: videoImgThumnailurl)
            self.arrPhotoVideo.append(model)
            self.cvPhotoVideo?.reloadData()
        }, failure: {[unowned self] (statuscode,error, errorType) in
            print(error)
            if !error.isEmpty {
                self.showMessage(error, themeStyle: .error)
            }
        })
    }
    
    private func setFeedAPI(){
        if let user = UserModel.getCurrentUserFromDefault() {
            //self.view.endEditing(true)
            var arr : [[String:Any]] = []
            for i in stride(from: 0, to: self.arrPhotoVideo.count, by: 1) {
                let obj = self.arrPhotoVideo[i]
                let dict : [String:Any] = [
                    kmediaName : obj.mediaName,
                    kvideoImage : obj.mediaNameThumbUrl
                ]
                arr.append(dict)
            }
            
            var dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kdescription : (self.txtPost?.txtInput?.text ?? "").encodindEmoji(),
                kmedia : arr
            ]
            
            if self.isFromEdit,let obj = self.selectedFeedData {
                dict[kuserFeedId] = obj.id
            }
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            FeedModel.setFeed(with: param, success: { (msg) in
                self.delegate?.updateFeedData()
                self.navigationController?.popViewController(animated: true)
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    self.showMessage(error, themeStyle: .error)
                }
            })
        }
    }
}

// MARK: - ViewControllerDescribable
extension CreateFeedPostViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.FeedTab
    }
}

// MARK: - AppNavigationControllerInteractable
extension CreateFeedPostViewController: AppNavigationControllerInteractable { }
