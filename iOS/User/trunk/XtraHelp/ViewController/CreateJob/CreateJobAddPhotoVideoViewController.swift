//
//  CreateJobAddPhotoVideoViewController.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 09/12/21.
//

import UIKit

class CreateJobAddPhotoVideoViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblTopHeader: UILabel?
    
    @IBOutlet weak var cvPhotoVideo: UICollectionView?
    
    //StartCAneclJob
    @IBOutlet weak var vwBottomJobCancelStartMain: UIView?
    @IBOutlet weak var vwJobCancelMain: UIView?
    @IBOutlet weak var vwJobStartMain: UIView?
    @IBOutlet weak var lblJobCancel: UILabel?
    @IBOutlet weak var lblJobStart: UILabel?
    
    // MARK: - Variables
    private var arrPhotoVideo : [AddPhotoVideoModel] = []
    var paramDict : [String:Any] = [:]
    private let imagePicker = ImagePicker()
    private let videoPicker = VideoPicker()
    
    var selectedCategory : JobCategoryModel?
    
    // MARK: - LIfe Cycle Methods
    override func viewDidLoad(){
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        self.configureNavigationBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        [self.vwJobCancelMain].forEach({
            $0?.roundCorners(corners: [.topRight], radius: ($0?.frame.width ?? 0.0)/2.0)
        })
        
        if let vw = self.vwJobStartMain {
            vw.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: vw.frame, colors: [UIColor.CustomColor.buttonBGGCOne,UIColor.CustomColor.gradiantColorBottom])
            vw.roundCorners(corners: [.topLeft], radius: vw.frame.width / 2)
        }
        
        //self.arrPhotoVideo.append("")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}

// MARK: - Init Configure
extension CreateJobAddPhotoVideoViewController {
    
    private func InitConfig(){
        
        self.imagePicker.viewController = self
        self.videoPicker.viewController = self
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.lblTopHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblTopHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 35.0))
        
        [self.lblJobCancel,self.lblJobStart].forEach({
            $0?.textColor = UIColor.CustomColor.whitecolor
            $0?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size:15.0))
        })
        
        self.vwJobCancelMain?.backgroundColor = UIColor.CustomColor.tabBarColor
       
        self.cvPhotoVideo?.delegate = self
        self.cvPhotoVideo?.dataSource = self
        self.cvPhotoVideo?.register(CreateJobAddPhotoVideoCell.self)
    }
    
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllerTitle(title: "", TitleColor: UIColor.CustomColor.textHedareLogin, navigationItem: self.navigationItem)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.textHedareLogin, tintColor: UIColor.CustomColor.textHedareLogin)
        navigationController?.navigationBar.removeShadowLine()
    }
    
}

//MARK: - UICollectionView Delegate and Datasource Method
extension CreateJobAddPhotoVideoViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrPhotoVideo.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CreateJobAddPhotoVideoCell.self)
        //cell.imgVideo?.isHidden = (indexPath.row == 0) || (indexPath.row == 4) || (indexPath.row == 5)
        cell.isAddNewPhotoVideo = (indexPath.row == self.arrPhotoVideo.count)
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
        
        cell.btnAdd?.tag = indexPath.row
        cell.btnAdd?.addTarget(self, action: #selector(self.btnAddClicked(_:)), for: .touchUpInside)
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
        
        return CGSize(width: (collectionView.frame.width / 3.0) - 10.0, height: collectionView.frame.width / 3.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.appNavigationController?.push(JobShowPhotoVideoViewController.self,configuration: { vc in
            vc.arrPhotoVideo = self.arrPhotoVideo
            vc.selecetdIndex = indexPath.row
        })
    }
    
    @objc func btnDeleteClicked(_ btn : UIButton){
        self.arrPhotoVideo.remove(at: btn.tag)
        self.cvPhotoVideo?.reloadData()
    }
    
    @objc func btnAddClicked(_ btn : UIButton){
        //self.arrPhotoVideo.append("")
        //self.cvPhotoVideo?.reloadData()
        
        let alertmenu = UIAlertController(title: "Select Photo/Video", message: nil, preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: "Photo", style: .default) { alert in
            self.imagePicker.pickImage(btn, "Select Image") { (img,url) in
                self.mediaAPICall(img: img,index : btn.tag)
            }
        }
        
        let videoAction = UIAlertAction(title: "Video", style: .default) { alert in
            self.videoPicker.isAllowsEditing = false
            self.videoPicker.pickImage(btn,Title: "Select Video") { (data,url)  in
                //self.videoData = data
                
                AVAsset(url: url).generateThumbnail { [weak self] (image) in
                    DispatchQueue.main.async {
                        guard let image = image else { return }
                        //self?.thumnailImg = image
                        self?.videomediaAPICall(img: image, videodata: data, index: btn.tag)
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: AlertControllerKey.kCancel, style: .cancel) { alert in
            
        }
    
        alertmenu.popoverPresentationController?.sourceView = btn as? UIView
        alertmenu.addAction(photoAction)
        alertmenu.addAction(videoAction)
        alertmenu.addAction(cancelAction)
        self.present(alertmenu, animated: true, completion: nil)
        
        
    }
}

// MARK: - IBAction
extension CreateJobAddPhotoVideoViewController {
    
    @IBAction func btnJObCancelClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnJobStartClicked(_ sender: UIButton) {
        //self.appNavigationController?.push(CreateJobTimeScheduleViewController.self)
        let filter =  self.arrPhotoVideo.filter({!$0.mediaName.isEmpty})
        var arr : [[String:Any]] = []
        if filter.count > 0 {
            for i in stride(from: 0, to: filter.count, by: 1) {
                let obj = filter[i]
                var dic : [String:Any] = [
                    kmediaName : obj.mediaName
                ]
                if obj.isVideo {
                    dic[kvideoImage] = obj.videoImageThumbUrl
                }
                arr.append(dic)
            }
        }
        self.paramDict[kmedia] = arr
        self.appNavigationController?.push(CreateJobTimeScheduleViewController.self,configuration: { vc in
            vc.paramDict = self.paramDict
            if let catObj = self.selectedCategory {
                vc.selectedCategory = catObj
            }
        })
    }
}

// MARK: - API Call
extension CreateJobAddPhotoVideoViewController {
    
    private func mediaAPICall(img : UIImage,index : Int) {
        let dict : [String:Any] = [
            klangType : XtraHelp.sharedInstance.languageType
        ]
        
        UserModel.uploadCertificateMedia(with: dict, image: img, success: { (msg,urldata) in
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
        
        AddPhotoVideoModel.addVideoAPI(with: videodata, image: nil, param: dict, success: { (msg,urldata,videoThumnailurl) in
            let model = AddPhotoVideoModel.init(UserJobMediaId: "", JobId: "", MediaNameUrl: urldata, MediaName: msg, isvideo: true, VideoImage: videoThumnailurl, videothumpimg: img, MediaNameThumbUrl: "", VideoImageUrl: videoThumnailurl, VideoImageThumbUrl: videoThumnailurl)
            self.arrPhotoVideo.append(model)
            self.cvPhotoVideo?.reloadData()
        }, failure: {[unowned self] (statuscode,error, errorType) in
            print(error)
            if !error.isEmpty {
                self.showMessage(error, themeStyle: .error)
            }
        })
    }
}

// MARK: - ViewControllerDescribable
extension CreateJobAddPhotoVideoViewController: ViewControllerDescribable{
    static var storyboardName: StoryboardNameDescribable{
        return UIStoryboard.Name.CreateJob
    }
}

// MARK: - AppNavigationControllerInteractable
extension CreateJobAddPhotoVideoViewController: AppNavigationControllerInteractable { }

