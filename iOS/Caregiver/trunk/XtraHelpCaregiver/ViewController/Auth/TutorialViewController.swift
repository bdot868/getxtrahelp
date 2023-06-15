//
//  TutorialViewController.swift
//  Momentor
//
//  Created by wmdevios-h on 11/08/21.
//

import UIKit
import ViewControllerDescribable
import ChameleonFramework
import AVFoundation

class TutorialViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var cvSlider: UICollectionView!
    
    @IBOutlet weak var btnBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var topSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnSkip: UIButton!
    
    @IBOutlet weak var vwPageControl: UIView!
    
    @IBOutlet weak var progressbar: UIProgressView!
    
    // MARK: - Variables
    private var arrTutorial : [TutorialImages] = [.tutorial1,.tutorial2,.tutorial3]
    private var currentIndex : Int = 0
    
    //MARK: -  View Life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func btnSkipClicked(_ sender: UIButton)
    {
        self.appNavigationController?.push(LoginViewController.self)
    }
    
    @IBAction func btnNextClicked(_ sender: UIButton)
    {
        //self.btnSkip.isHidden = ()
        if self.currentIndex == self.arrTutorial.count - 1
        {
            self.appNavigationController?.push(LoginViewController.self)
        } else
        {
            self.cvSlider.scrollToNextItem()
        }
    }
    
}

// MARK: - UI helpers
fileprivate extension TutorialViewController {
    //MARK: Private Methods
    private func InitConfig() {
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.cvSlider.register(TutorialCell.self)
        self.cvSlider.dataSource = self
        self.cvSlider.delegate = self
        
        self.btnSkip.setTitleColor(UIColor.CustomColor.appColor, for: .normal)
        self.btnSkip.titleLabel?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        
        /*if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_6
        {
            topSpaceConstraint.constant = 180.0
            btnBottomContraint.constant = 60.0
        }else
        {
            topSpaceConstraint.constant = 200.0
            btnBottomContraint.constant = 80.0
        }*/
        delay(seconds: 0.2) {
            self.progressbar.trackTintColor = UIColor.CustomColor.progressBarBackColor
            self.progressbar.progressTintColor = GradientColor(gradientStyle: .topToBottom, frame: self.progressbar.frame, colors: [UIColor.CustomColor.gradiantColorTop,UIColor.CustomColor.gradiantColorBottom])
        }
        
        self.progressbar.layer.cornerRadius = 6
        self.progressbar.clipsToBounds = true

        for subview in self.progressbar.subviews {
           if let imageView = subview as? UIView {
              imageView.layer.cornerRadius = 6
              imageView.clipsToBounds = true
           }
        }
        
        self.progressbar.progress = (Float(self.currentIndex + 1)) / 3.0
    }
}

//MARK: -  Scrollview Method
extension TutorialViewController {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //self.collectionview.scrollToNearestVisibleCollectionViewCell()
        //self.pageControll.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        print("scrollViewDidEndDecelerating : \(Int(scrollView.contentOffset.x) / Int(scrollView.frame.width))")
        self.currentIndex = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        self.progressbar.progress = (Float(self.currentIndex + 1) ) / 3.0
        self.btnSkip.isHidden = self.currentIndex >= 2
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        //self.pageControll.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        self.currentIndex = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        print("scrollViewDidEndScrollingAnimation : \(Int(scrollView.contentOffset.x) / Int(scrollView.frame.width))")
        self.progressbar.progress = (Float(self.currentIndex + 1) ) / 3.0
        self.btnSkip.isHidden = self.currentIndex >= 2
    }
}

//MARK: - UICollectionView Delegate and Datasource Method
extension TutorialViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.arrTutorial.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TutorialCell.self)
        if self.arrTutorial.count > 0
        {
            cell.setupData(obj: self.arrTutorial[indexPath.row])
            //cell.constarintStackBottom.constant = self.btnNext.frame.height + 100
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //print("Width : \()")
        return CGSize(width: ScreenSize.SCREEN_WIDTH , height: ScreenSize.SCREEN_HEIGHT)
    }
}

//MARK: - IBAction Mthonthd
extension TutorialViewController {
 
}

extension UICollectionView {
    func scrollToNextItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        //print("X : \(self.contentOffset.x) Width : \(self.bounds.size.width)")
        if self.contentOffset.x <= self.bounds.size.width {
            self.moveToFrame(contentOffset: contentOffset)
        }
    }
    
    func moveToFrame(contentOffset : CGFloat) {
        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
       //self.progressbar.progress = (Float(self.currentIndex) ?? 0.0) / 3.0
        //self.pageControl?.setActiveDotIndex(Float(Int(contentOffset.x) / Int(scrollView.frame.width)), animated: true)
    }
}

// MARK: - ViewControllerDescribable
extension TutorialViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.auth
    }
}

// MARK: - AppNavigationControllerInteractable
extension TutorialViewController: AppNavigationControllerInteractable { }

