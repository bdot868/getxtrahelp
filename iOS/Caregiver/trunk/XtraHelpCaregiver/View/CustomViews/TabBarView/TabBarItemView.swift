//
//  TabBarView.swift
//  Momentor
//
//  Created by Wdev3 on 19/02/21.
//

import UIKit

protocol TabbarItemDelegate {
    func selectTabButton(_ sender : UIButton)
}

class TabBarItemView: UIView {

    @IBOutlet weak var selectImg: UIImageView!
    // MARK: - IBOutlet
    @IBOutlet weak var imgTab: UIImageView!
    @IBOutlet weak var lblTabName: UILabel!
    @IBOutlet weak var vwImageActive: UIView!
    @IBOutlet weak var btnSelect: UIButton!
    
    //MARK: Variables
    var contentView:UIView?
    let nibName = "TabBarItemView"
    var delegate : TabbarItemDelegate?
    
    //MARK: - Life Cycle Methods
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
    
    @IBInspectable var isSelectedTab: Bool = false {
        didSet {
            //self.vwImageActive.isHidden = !isSelectedTab
            
            //transitionCrossDissolve
            UIView.transition(with: self.lblTabName, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
//                                self.lblTabName.isHidden = !self.isSelectedTab
                                //self.imgTab.isHidden = isSelectedTab
                self.imgTab.tintColor = self.isSelectedTab ? UIColor.CustomColor.appColor : UIColor.CustomColor.whitecolor
                self.lblTabName.textColor = self.isSelectedTab ? UIColor.CustomColor.appColor : UIColor.CustomColor.whitecolor
                              })
            
            UIView.transition(with: self.imgTab, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                                //self.lblTabName.isHidden = !isSelectedTab
                                self.selectImg.isHidden = !self.isSelectedTab
                              })
            
        }
    }
    
    //MARK: - Helper Methods
    private func initialConfig() {

        self.lblTabName.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 13.0))
        self.lblTabName.textColor = UIColor.CustomColor.whitecolor
    }
    @IBAction func btnSelectClicked(_ sender: UIButton) {
        self.delegate?.selectTabButton(sender)
    }
}
