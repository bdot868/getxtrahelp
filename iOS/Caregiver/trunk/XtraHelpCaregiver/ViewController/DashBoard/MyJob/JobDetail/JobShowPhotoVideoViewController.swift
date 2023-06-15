//
//  JobShowPhotoVideoViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 06/12/21.
//

import UIKit

class JobShowPhotoVideoViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var cvPhotoVideo: UICollectionView?
    
    @IBOutlet weak var imgPhotoVideo: UIImageView?
    @IBOutlet weak var imgPlayVideo: UIImageView?
    
    @IBOutlet weak var vwPhotoSub: UIView?
    @IBOutlet weak var btnPlayVideoPhoto: UIButton?
    
    // MARK: - Variables
    var selecetdIndex : Int = 0
    var arrPhotoVideo : [AddPhotoVideoModel] = []
    
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
    }
}

// MARK: - Init Configure
extension JobShowPhotoVideoViewController {
    
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.vwPhotoSub?.cornerRadius = 20.0
        self.imgPhotoVideo?.cornerRadius = 20.0
        
        self.cvPhotoVideo?.delegate = self
        self.cvPhotoVideo?.dataSource = self
        self.self.cvPhotoVideo?.register(PhotoVideoCollectionCell.self)
        
        if self.arrPhotoVideo.count > 0 {
            let obj = self.arrPhotoVideo[self.selecetdIndex]
            self.imgPlayVideo?.isHidden = !obj.isVideo
            self.imgPhotoVideo?.setImage(withUrl: obj.isVideo ? obj.videoImage : obj.mediaNameUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.AppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        }
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
extension JobShowPhotoVideoViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrPhotoVideo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: PhotoVideoCollectionCell.self)
        if self.arrPhotoVideo.count > 0 {
            let obj = self.arrPhotoVideo[indexPath.row]
            cell.isSelectPhotoVideo = (indexPath.row == self.selecetdIndex)
            cell.imgVideo?.isHidden = !obj.isVideo
            cell.imgPhoto?.setImage(withUrl: obj.isVideo ? obj.videoImage : obj.mediaNameUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.AppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.height / 1.2, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selecetdIndex = indexPath.row
        //self.collectionView.scrollToItem(at:IndexPath(item: indexNumber, section: sectionNumber), at: .right, animated: false)
        if self.arrPhotoVideo.count > 0 {
            let obj = self.arrPhotoVideo[indexPath.row]
            self.imgPlayVideo?.isHidden = !obj.isVideo
            self.btnPlayVideoPhoto?.isHidden = !obj.isVideo
            self.imgPhotoVideo?.setImage(withUrl: obj.isVideo ? obj.videoImage : obj.mediaNameUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.AppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
        }
        self.cvPhotoVideo?.reloadData()
    }
}

// MARK: - IBAction
extension JobShowPhotoVideoViewController {
    @IBAction func btnPlayPhotoVideo(_ sender: UIButton) {
        if self.arrPhotoVideo.count > 0 {
            let obj = self.arrPhotoVideo[self.selecetdIndex]
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
            }
        }
    }
}

// MARK: - ViewControllerDescribable
extension JobShowPhotoVideoViewController: ViewControllerDescribable{
    static var storyboardName: StoryboardNameDescribable{
        return UIStoryboard.Name.myJob
    }
}

// MARK: - AppNavigationControllerInteractable
extension JobShowPhotoVideoViewController: AppNavigationControllerInteractable { }
