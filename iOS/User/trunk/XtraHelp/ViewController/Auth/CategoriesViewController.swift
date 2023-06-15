////
////  CategoriesViewController.swift
////  Momentor
////
////  Created by wmdevios-h on 14/08/21.
////
//
//import UIKit
//
//class CategoriesViewController: UIViewController {
//
//    // MARK: - IBOutlet
//    @IBOutlet weak var lblHeader: UILabel?
//    @IBOutlet weak var lblNeedHeader: UILabel?
//
//    @IBOutlet weak var vwAddCategories: ReusableView?
//
//    @IBOutlet weak var btnSubmit: NextRoundButton?
//
//    @IBOutlet weak var constraintCVCategoriesHeight: NSLayoutConstraint?
//
//    @IBOutlet weak var cvCategories: UICollectionView?
//    // MARK: - Variables
//
//    //MARK: - Life Cycle Methods
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.InitConfig()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.configureNavigationBar()
//        self.addCollectionviewOberver()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.removeCollectionviewObserver()
//    }
//
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        self.view.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: self.view.frame, colors: [UIColor.CustomColor.gradiantColorBottom,UIColor.CustomColor.gradiantColorTop])
//    }
//}
//
//// MARK: - Init Configure
//extension CategoriesViewController {
//    private func InitConfig(){
//
//        self.lblHeader?.setHeaderCommonAttributedTextLable(firstText: "Select interested\n", SecondText: "Categories")
//
//        self.lblNeedHeader?.textColor = UIColor.CustomColor.whitecolor
//        self.lblNeedHeader?.font = UIFont.PoppinsRegular(ofSize: GetAppFontSize(size: 16.0))
//
//        self.cvCategories?.register(CategoryCell.self)
//        self.cvCategories?.dataSource = self
//        self.cvCategories?.delegate = self
//    }
//    private func configureNavigationBar() {
//
//        appNavigationController?.setNavigationBarHidden(true, animated: true)
//        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
//
//        appNavigationController?.appNavigationControllerTitle(title: "", TitleColor: UIColor.CustomColor.whitecolor, navigationItem: self.navigationItem)
//
//        navigationController?.navigationBar
//            .configure(barTintColor: UIColor.clear, tintColor: UIColor.CustomColor.borderColor)
//        navigationController?.navigationBar.removeShadowLine()
//    }
//}
//
////MARK: - Tableview Observer
//extension CategoriesViewController {
//
//    private func addCollectionviewOberver() {
//        self.cvCategories?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
//    }
//
//    func removeCollectionviewObserver() {
//        if self.cvCategories?.observationInfo != nil {
//            self.cvCategories?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
//        }
//    }
//
//    /**
//     This method is used to observeValue in table view.
//     */
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//
//        if let obj = object as? UICollectionView {
//            if obj == self.cvCategories && keyPath == ObserverName.kcontentSize {
//                self.constraintCVCategoriesHeight?.constant = self.cvCategories?.contentSize.height ?? 0.0
//            }
//        }
//    }
//}
//
////MARK: - UICollectionView Delegate and Datasource Method
//extension CategoriesViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 4
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CategoryCell.self)
//
//        cell.isSelectedcategory = (indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 5) ? true : false
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let width : CGFloat = (collectionView.frame.width/2) - 5.0
//        return CGSize(width: width, height: width)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//    }
//}
//
//// MARK: - IBAction
//extension CategoriesViewController {
//
//    @IBAction func btnSubmitClicked(_ sender: NextRoundButton) {
//        self.appNavigationController?.present(PopupViewController.self,configuration: { (vc) in
//            vc.modalPresentationStyle = .overFullScreen
//            vc.modalTransitionStyle = .crossDissolve
//        })
//    }
//}
//
//// MARK: - ViewControllerDescribable
//extension CategoriesViewController: ViewControllerDescribable {
//    static var storyboardName: StoryboardNameDescribable {
//        return UIStoryboard.Name.auth
//    }
//}
//
//// MARK: - AppNavigationControllerInteractable
//extension CategoriesViewController: AppNavigationControllerInteractable { }
