//
//  ImagePreviewViewController.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 04/12/21.
//

import UIKit

class ImagePreviewViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var btnClose: UIButton?
    
    @IBOutlet weak var imgPost: UIImageView?
    
    //UIScrollView
    @IBOutlet weak var postImgScrollview: UIScrollView?
    
    // MARK: - Variables
    var imageUrl : String = ""

    // MARK: - LIfe Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InitConfig()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.imgPost?.setImage(withUrl: self.imageUrl, placeholderImage: UIImage(named: DefaultPlaceholderImage.AppPlaceholder) ?? UIImage(), indicatorStyle: .medium, isProgressive: true, imageindicator: .medium)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.btnClose?.roundedCornerRadius()
    }
}

// MARK: - Init Configure Methods
extension ImagePreviewViewController {
    private func InitConfig() {
        self.postImgScrollview?.delegate = self
        self.postImgScrollview?.minimumZoomScale = 1.0
        self.postImgScrollview?.maximumZoomScale = 10.0
        
        self.btnClose?.titleLabel?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 17.0))
        self.btnClose?.setTitleColor(UIColor.CustomColor.blackColor, for: .normal)
    }
}

// MARK: - UIScrollView Delegates
extension ImagePreviewViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView == self.postImgScrollview {
            return self.imgPost
        }
        return nil
    }
}

//MARK: IBAction Mthonthd
extension ImagePreviewViewController {
   
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - ViewControllerDescribable
extension ImagePreviewViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.Chat
    }
}

// MARK: - AppNavigationControllerInteractable
extension ImagePreviewViewController: AppNavigationControllerInteractable{}

