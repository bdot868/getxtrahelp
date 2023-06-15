//
//  SearchView.swift
//  Momentor
//
//  Created by Wdev3 on 23/02/21.
//

import UIKit
import ChameleonFramework

class SearchView: UIView {

    //MARK: IBOutlets
    @IBOutlet weak var vwSearchMain: UIView?
    @IBOutlet weak var vwSearchSubview: UIView?
    @IBOutlet weak var vwCancelMain: UIView?
    @IBOutlet weak var vwSearchImgMain: UIView?
    @IBOutlet weak var imgSearch: UIImageView!
    
    @IBOutlet weak var btnCancel: UIButton?
    
    @IBOutlet weak var txtSearch: UITextField?
    
    //MARK: Variables
    var contentView:UIView?
    let nibName = "SearchView"
    var btnSearchClickBlock : (() -> ())?
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        /*if let vwsearch = self.vwSearchSubview {
            vwsearch.backgroundColor = GradientColor(gradientStyle: .topToBottom, frame: vwsearch.frame, colors: [UIColor.CustomColor.gradiantColorTop,UIColor.CustomColor.gradiantColorBottom])
            
            vwsearch.clipsToBounds = true
            vwsearch.cornerRadius = 10.0
            vwsearch.shadow(UIColor.CustomColor.shadowColorBlack, radius: 5.0, offset: CGSize(width: 0, height: 0), opacity: 1)
            vwsearch.maskToBounds = false
        }*/
        
        if let vwsearch = self.vwSearchMain {
            vwsearch.cornerRadius = vwsearch.frame.height/2
        }
    }
    
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
        
        self.InitConfig()
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    //MARK: IBInspectable
    @IBInspectable var placeholderText: String {
        get { return self.txtSearch?.placeholder ?? "" }
        set {
            self.txtSearch?.placeholder = newValue.localized()
        }
    }
    
    @IBInspectable var bgColor: UIColor = UIColor.CustomColor.whitecolor {
        didSet {
            self.vwSearchMain?.backgroundColor = bgColor
        }
    }
    
    @IBInspectable var isHideSearchImgLeft : Bool = false {
        didSet {
            self.vwSearchImgMain?.isHidden = isHideSearchImgLeft
        }
    }
    
    // MARK: - Init Configure
    private func InitConfig(){
        
        self.txtSearch?.textColor = UIColor.CustomColor.blackColor
        self.txtSearch?.setPlaceHolderColor(text: "Search", color: UIColor.CustomColor.textConnectLogin)
        self.txtSearch?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        self.txtSearch?.tintColor = UIColor.CustomColor.blackColor
        
        self.btnCancel?.titleLabel?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
        self.btnCancel?.setTitleColor(UIColor.CustomColor.categoriesBorderColor, for: .normal)
        
        self.vwSearchMain?.backgroundColor = UIColor.CustomColor.whitecolor
        self.vwSearchMain?.borderColor = UIColor.CustomColor.borderColor
        self.vwSearchMain?.borderWidth = 1.0
        
        self.txtSearch?.delegate = self
        self.txtSearch?.addTarget(self, action: #selector(self.textFieldSearchDidChange(_:)), for: .editingChanged)
        
        //self.imgSearch.tintColor = UIColor.CustomColor.SearchDefaulrColor
        
    }

    @IBAction func btnSearchClicked(_ sender: UIButton) {
        self.btnSearchClickBlock?()
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        self.txtSearch?.text = ""
        self.vwCancelMain?.isHidden = true
    }
}

//MARK :- UITextFieldDelegate
extension SearchView : UITextFieldDelegate {
    @objc func textFieldSearchDidChange(_ textField: UITextField) {
       // self.imgSearch.tintColor = (textField.text?.isEmpty ?? true) ? UIColor.CustomColor.SearchDefaulrColor : UIColor.CustomColor.tabBarColor
        //self.vwCancelMain?.isHidden = (textField.text?.count ?? 0) > 0 ? false : true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //self.vwCancelMain?.isHidden = (textField.text?.count ?? 0) > 0 ? false : true
       // self.imgSearch.tintColor = (textField.text?.isEmpty ?? true) ? UIColor.CustomColor.SearchDefaulrColor : UIColor.CustomColor.tabBarColor
        return true
    }
}
