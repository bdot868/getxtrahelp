//
//  ReusableView.swift
//  TheUSDoctor
//
//  Created by mac on 30/01/20.
//  Copyright © 2020 Differenzsystem Pvt. LTD. All rights reserved.
//

import UIKit

protocol ReusableViewDelegate: class {
    func buttonClicked(_ sender : UIButton)
    func rightButtonClicked(_ sender : UIButton)
}

@IBDesignable
class ReusableView: UIView {
    
    //MARK: IBOutlets
    @IBOutlet weak var leftImgView: UIImageView!
   
    @IBOutlet weak var rightImg: UIImageView!
    @IBOutlet weak var txtInput: UITextField!
    @IBOutlet weak var vwLeftContainer: UIView!
    @IBOutlet weak var vwLeftMainContainer: UIView!
    @IBOutlet weak var vwRightMainContainer: UIView!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var vwDownArrow: UIView!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var btnRightSelect: UIButton!
    @IBOutlet weak var lblTopLabel: UILabel!
    @IBOutlet weak var vwTopLabel: UIView!
    @IBOutlet weak var vwRightText: UIView!
    @IBOutlet weak var lblRightText: UILabel!
    @IBOutlet weak var vwDollarMain: UIView!
    @IBOutlet weak var lblDollarLabel: UILabel!
    //MARK: Variables
    var contentView:UIView?
    let nibName = "ReusableView"
    weak var reusableViewDelegate: ReusableViewDelegate?
    
    @IBInspectable var isSetFocusTextField : Bool = false {
        didSet{
            self.vwMain.borderColor = isSetFocusTextField ? UIColor.CustomColor.appColor : UIColor.CustomColor.borderColor
        }
    }
    
    /*@IBInspectable var keyboard : keyboardEnumType = .defaultkeyboard {
        self.txtInput.keyboardType = UIKeyboardType.init(rawValue: keyboard.rawValue)!
        /*get{
            return self.txtInput.keyboardType.rawValue
        }
        set(keyboardIndex){
            self.txtInput.keyboardType = UIKeyboardType.init(rawValue: keyboardIndex)!

        }*/
    }*/
    
    /*0: default // Default type for the current input method.

    1: asciiCapable // Displays a keyboard which can enter ASCII characters

    2: numbersAndPunctuation // Numbers and assorted punctuation.

    3: URL // A type optimized for URL entry (shows . / .com prominently).

    4: numberPad // A number pad with locale-appropriate digits (0-9, ۰-۹, ०-९, etc.). Suitable for PIN entry.

    5: phonePad // A phone pad (1-9, *, 0, #, with letters under the numbers).

    6: namePhonePad // A type optimized for entering a person's name or phone number.

    7: emailAddress // A type optimized for multiple email address entry (shows space @ . prominently).

    8: decimalPad // A number pad with a decimal point.

    9: twitter // A type optimized for twitter text entry (easy access to @ #)*/
    
   @IBInspectable var keyboard:Int{
        get{
            //self.txtInput.returnKeyType.rawValue
            return self.txtInput.keyboardType.rawValue
        }
        set(keyboardIndex){
            self.txtInput.keyboardType = UIKeyboardType.init(rawValue: keyboardIndex)!

        }
    }
    /*public enum UIReturnKeyType : Int
        case `default` = 0
        case go = 1
        case google = 2
        case join = 3
        case next = 4
        case route = 5
        case search = 6
        case send = 7
        case yahoo = 8
        case done = 9
        case emergencyCall = 10
        @available(iOS 9.0, *)
        case `continue` = 11
    }*/
    @IBInspectable var keyboardReturnType:Int{
        get{
            //self.txtInput.returnKeyType.rawValue
            return self.txtInput.returnKeyType.rawValue
        }
        set(keyboardIndex){
            self.txtInput.returnKeyType = UIReturnKeyType.init(rawValue: keyboardIndex)!

        }
    }
    
    @IBInspectable var isShowPassword : Bool = false {
        didSet {
            
            //self.btnRightSelect.setImage(isShowPassword ? #imageLiteral(resourceName: "ic_HideEye"): #imageLiteral(resourceName: "ic_Eye"), for: .normal)
            self.txtInput.isSecureTextEntry = !isShowPassword
        }
    }
    
    @IBInspectable var isPassword : Bool = false {
        didSet {
            self.txtInput.isSecureTextEntry = isPassword
        }
    }
    
//    @IBInspectable var keyboardReturnType : UIReturnKeyType = .next {
//        didSet{
//            self.txtInput.returnKeyType = keyboardReturnType
//        }
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
        
        initialConfig()
        self.txtInput.delegate = self
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    //MARK: IBInspectable
    @IBInspectable var placeholderText: String {
        get { return self.txtInput.placeholder ?? "" }
        set {
            self.txtInput.placeholder = newValue.localized()
        }
    }
    
    @IBInspectable var topHeaderLabelText: String = "" {
        didSet {
            self.lblTopLabel.text = topHeaderLabelText.localized()
        }
    }
     
    @IBInspectable var isDropDown : Bool = false {
        didSet {
            self.btnSelect.isHidden = !isDropDown
            self.vwDownArrow.isHidden = !isDropDown
        }
    }
    
    @IBInspectable var isHideTopLabelView : Bool = false {
        didSet {
            self.vwTopLabel.isHidden = isHideTopLabelView
        }
    }
    
    @IBInspectable var ShowRightLabelView : Bool = false {
        didSet {
            self.vwRightText.isHidden = !ShowRightLabelView
        }
    }
    
    @IBInspectable var rightLabelText: String = "" {
        didSet {
            self.lblRightText.text = rightLabelText.localized()
        }
    }
    
    @IBInspectable var isHideLeftImage: Bool = false {
        didSet {
            self.vwLeftMainContainer.isHidden = isHideLeftImage
        }
    }
    
    @IBInspectable var isHideRightImage: Bool = false {
        didSet {
            self.vwDownArrow.isHidden = isHideRightImage
        }
    }
    
    @IBInspectable var isShowRightDollarView: Bool = false {
        didSet {
            self.vwDollarMain.isHidden = !isShowRightDollarView
        }
    }
    
    @IBInspectable var isCenterTExtAlignTextField: Bool = false {
        didSet {
            self.txtInput.textAlignment = .center
        }
    }
    
    @IBInspectable var istxtInputUserInteractionEnable : Bool = true {
        didSet {
            self.txtInput.isUserInteractionEnabled = istxtInputUserInteractionEnable
        }
    }
    
    @IBInspectable var setBorderColor : UIColor = UIColor.CustomColor.appTextColor {
        didSet {
            self.txtInput.borderColor(setBorderColor)
        }
    }
    
    @IBInspectable var txtInputPadding : CGFloat = 0 {
        didSet {
            //self.txtInput.textRect(forBounds: CGRect(x: 10, y: 0, width: 0, height: 0))
            self.txtInput.setLeftPaddingPoints(txtInputPadding)
            self.txtInput.setRightPaddingPoints(txtInputPadding/2)
        }
    }
        
    @IBInspectable var txtInputRightPadding : CGFloat = 0 {
        didSet {
            self.txtInput.setRightPaddingPoints(txtInputRightPadding)
        }
    }
    
    @IBInspectable var RightImage : UIImage  {
        get {return self.rightImg.image ?? UIImage()}
        set {
            self.rightImg.image = newValue
        }
    }
    
    @IBInspectable var LeftImage : UIImage  {
        get {return self.leftImgView.image ?? UIImage()}
        set {
            self.leftImgView.image = newValue
        }
    }
    
    @IBInspectable var txtInputFontSize : CGFloat = 0 {
        didSet {
            self.txtInput.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: txtInputFontSize))
        }
    }
    
    var isFromCardNumber: Bool = false
    var isFromCardExpire: Bool = false
    var isFromCardCVV: Bool = false
    var isFromBankRoutingNumber: Bool = false
    
    //MARK: - Helper Methods
    private func initialConfig() {
        
        self.txtInput.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        self.txtInput.textColor = UIColor.CustomColor.blackColor
        
        //self.txtInput.placeholder = self.txtInput.placeholder?.localized() ?? ""
        self.txtInput.setPlaceHolderColor(text: self.txtInput.placeholder?.localized() ?? "", color: UIColor.CustomColor.appPlaceholderColor)
        /*self.txtInput.placeholderFont = UIFont.PoppinsLight(ofSize: GetAppFontSize(size: 13.0))
        self.txtInput.titleFont = UIFont.PoppinsLight(ofSize: GetAppFontSize(size: 13.0))
        self.txtInput.selectedTitleColor = UIColor.CustomColor.whitecolorAlpha
        self.txtInput.titleColor = UIColor.CustomColor.whitecolorAlpha
        
        self.txtInput.lineColor = UIColor.clear
        self.txtInput.lineHeight = 0.0
        self.txtInput.selectedLineColor = UIColor.clear*/
        
        self.txtInput.delegate = self
        self.vwMain.backgroundColor = UIColor.CustomColor.whitecolor
        self.vwMain.borderColor = UIColor.CustomColor.borderColor
        self.vwMain.borderWidth = 1.5
        self.vwMain.cornerRadius = cornerRadiousValue.buttonCorner
        self.vwMain.cornerRadius = 15.0
        
        self.lblTopLabel.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 15.0))
        self.lblTopLabel.textColor = UIColor.CustomColor.SubscriptuionSubColor
        
        self.lblRightText.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 10.0))
        self.lblRightText.textColor = UIColor.CustomColor.appColor
        
        self.lblDollarLabel.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 15.0))
        self.lblDollarLabel.textColor = UIColor.CustomColor.SubscriptuionSubColor
    }
}

//MARK: - IBActions
extension ReusableView {
    /**
     This method is Right TextField view Button Click
     */
    @IBAction func btnSelectClicked(_ sender: UIButton) {
        reusableViewDelegate?.buttonClicked(sender)
    }
    
    @IBAction func btnRightSelectClicked(_ sender: UIButton) {
        reusableViewDelegate?.rightButtonClicked(sender)
    }

    @objc private func onButton_Click(_ sender : UIButton) {
        
    }
}

extension ReusableView : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //self.isSetFocusTextField = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //self.isSetFocusTextField = false
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //self.isSetFocusTextField = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.isFromCardNumber {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format(with: Masking.kCardNumberMasking, phone: newString)
            return false
        } else if self.isFromCardExpire {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format(with: Masking.kCardExire, phone: newString)
            return false
        } else if self.isFromCardCVV {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format(with: Masking.kCardCVV, phone: newString)
            return false
        } else if self.isFromBankRoutingNumber {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = format(with: Masking.kRoutingNumberMasking, phone: newString)
            return false
        } else {
            if textField.keyboardType == .phonePad {
                guard let text = textField.text else { return false }
                let newString = (text as NSString).replacingCharacters(in: range, with: string)
                textField.text = format(with: Masking.kPhoneNumberMasking, phone: newString)
                return false
            }
        }
        return true
    }
}
