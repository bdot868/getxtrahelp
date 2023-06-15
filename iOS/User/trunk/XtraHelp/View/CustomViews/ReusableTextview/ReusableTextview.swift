//
//  ReusableTextview.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 16/11/21.
//

import UIKit

class ReusableTextview: UIView {

    //MARK: IBOutlets
    @IBOutlet weak var txtInput: UITextView?
    
    @IBOutlet weak var vwMain: UIView?
    
    @IBOutlet weak var lblHeader: UILabel?
    //MARK: Variables
    var contentView:UIView?
    let nibName = "ReusableTextview"
   
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
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    //MARK: IBInspectable
    @IBInspectable var placeholderText: String {
        get { return self.txtInput?.placeholder ?? "" }
        set {
            self.txtInput?.placeholder = newValue.localized()
        }
    }
    
    @IBInspectable var topHeaderText: String = "" {
        didSet {
            self.lblHeader?.text = topHeaderText.localized()
        }
    }
    @IBInspectable var isShowHeader : Bool = false {
        didSet {
            self.lblHeader?.isHidden = !isShowHeader
        }
    }
    
    @IBInspectable var isSetFocusTextField : Bool = false {
        didSet{
            self.vwMain?.borderColor = isSetFocusTextField ? UIColor.CustomColor.appColor : UIColor.CustomColor.borderColor
        }
    }
    
    //MARK: - Helper Methods
    private func initialConfig() {
        
        self.txtInput?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        self.txtInput?.textColor = UIColor.CustomColor.blackColor
        self.txtInput?.placeholderColor = UIColor.CustomColor.appPlaceholderColor
        self.txtInput?.placeholder = self.txtInput?.placeholder?.localized() ?? ""
        
        self.vwMain?.cornerRadius = 15.0
        self.vwMain?.backgroundColor = UIColor.CustomColor.whitecolor
        self.vwMain?.borderColor = UIColor.CustomColor.borderColor
        self.vwMain?.borderWidth = 1.5
        self.vwMain?.cornerRadius = cornerRadiousValue.buttonCorner
        
        self.lblHeader?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 13.0))
        self.lblHeader?.textColor = UIColor.CustomColor.tabBarColor
    }
}
