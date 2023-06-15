//
//  PersonalInfoViewController.swift
//  Momentor
//
//  Created by wmdevios-h on 14/08/21.
//

import UIKit

class PersonalInfoViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var lblHeader: UILabel?
    @IBOutlet weak var lblSubHeader: UILabel?
    @IBOutlet weak var lblUserName: UILabel?
    
    @IBOutlet weak var vwAge: ReusableView?
    @IBOutlet weak var vwGender: ReusableView?
    @IBOutlet weak var vwPhoneNumber: ReusableView?
    
    @IBOutlet weak var vwProfileRound: UIView?
    
    @IBOutlet weak var imgProfile: UIImageView?
    
    @IBOutlet weak var btnAddProfile: UIButton?
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSubmit: XtraHelpButton?
    
    // MARK: - Variables
    private var arrGender : [GenderEnum] = [.Male,.Female, .PreferNotToSay]
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: self.view.frame, colors: [UIColor.CustomColor.gradiantColorBottom,UIColor.CustomColor.gradiantColorTop])
    }
}

// MARK: - Init Configure
extension PersonalInfoViewController {
    private func InitConfig(){
        self.btnBack.setTitle("", for: .normal)
        self.btnSubmit?.setTitle("", for: .normal)
        self.lblHeader?.setHeaderCommonAttributedTextLable(firstText: "Personal\n", SecondText: "Information")
        
        self.lblUserName?.setHelloUserAttributedTextLable(firstText: "Hello\n", SecondText: "John,")
       
        self.lblSubHeader?.textColor = UIColor.CustomColor.whitecolor
        self.lblSubHeader?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        
        self.vwGender?.reusableViewDelegate = self
        
        delay(seconds: 0.2) {
            self.vwProfileRound?.cornerRadius = (self.vwProfileRound?.frame.height ?? 0.0) / 2
        }
    }
    private func configureNavigationBar() {
        
        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllerTitle(title: "", TitleColor: UIColor.CustomColor.whitecolor, navigationItem: self.navigationItem)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.clear, tintColor: UIColor.CustomColor.borderColor)
        navigationController?.navigationBar.removeShadowLine()
    }
}

// MARK: - IBAction
extension PersonalInfoViewController {
    @IBAction func btnAddProfileClicked(_ sender: UIButton) {
    }
    
    @IBAction func btnSubmitClicked(_ sender: NextRoundButton) {
//        self.appNavigationController?.push(CategoriesViewController.self)
    }
}

// MARK: - ReusableView Delegate
extension PersonalInfoViewController : ReusableViewDelegate
{
    
    func rightButtonClicked(_ sender: UIButton)
    {
        
    }
   
    func buttonClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.openGender(sender: sender)
    }
    
    private func openGender(sender : UIButton){
        let arr = self.arrGender.map({$0.name})
        var selecetdIndex : Int = 0
        for i in stride(from: 0, to: self.arrGender.count, by: 1){
            if (self.vwGender?.txtInput.text ?? "") == self.arrGender[i].name {
                selecetdIndex = i
                break
            }
        }
        
        let picker = ActionSheetStringPicker(title: "Select Gender", rows: arr, initialSelection: selecetdIndex, doneBlock: { (picker, indexes, values) in
            //self.selectedGender = self.arrGender[indexes]
            self.vwGender?.txtInput.text = self.arrGender[indexes].name
            return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
        picker?.toolbarButtonsColor = UIColor.CustomColor.appColor
        picker?.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.CustomColor.labelTextColor]
        picker?.show()
    }
}

// MARK: - ViewControllerDescribable
extension PersonalInfoViewController: ViewControllerDescribable
{
    static var storyboardName: StoryboardNameDescribable
    {
        return UIStoryboard.Name.auth
    }
}

// MARK: - AppNavigationControllerInteractable
extension PersonalInfoViewController: AppNavigationControllerInteractable { }
