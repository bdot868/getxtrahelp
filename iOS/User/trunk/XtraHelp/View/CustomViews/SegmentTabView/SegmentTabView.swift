//
//  SegmentTabView.swift
//  Momentor
//
//  Created by Wdev3 on 23/02/21.
//

import UIKit
protocol SegmentTabDelegate {
    func tabSelect(_ sender : UIButton)
}

class SegmentTabView: UIView {

    // MARK: - IBOutlet
    @IBOutlet weak var lblTabName: UILabel!
    
    @IBOutlet weak var vwTabBottomBar: UIView!
    @IBOutlet weak var vwRightDotMain: UIView!
    @IBOutlet weak var vwRightDot: UIView!
    
    @IBOutlet weak var btnSelectTab: UIButton!
    
    //MARK: Variables
    var contentView:UIView?
    let nibName = "SegmentTabView"
    var segmentDelegate : SegmentTabDelegate?
    
    //MARK: - Life Cycle Methods
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        self.vwTabBottomBar.cornerRadius = self.vwTabBottomBar.frame.height / 2
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
    @IBInspectable
    var setBottomBarBackgroundColor : UIColor = UIColor.CustomColor.whitecolor {
        didSet{
            self.vwTabBottomBar.backgroundColor = UIColor.CustomColor.registerColor
        }
    }
    @IBInspectable
    var setRightViewBackgroundColor : UIColor = UIColor.CustomColor.whitecolor {
        didSet{
            self.vwRightDot.backgroundColor = setRightViewBackgroundColor
        }
    }
    @IBInspectable
    var setTabName : String = "" {
        didSet{
            self.lblTabName.text = setTabName
        }
    }
    @IBInspectable
    var isHideRightDotView : Bool = false{
        didSet{
            self.vwRightDotMain.isHidden = isHideRightDotView
        }
    }
    
    @IBInspectable
    var isHideBottomBarView : Bool = false{
        didSet{
            self.vwTabBottomBar.isHidden = isHideBottomBarView
        }
    }
    
    @IBInspectable
    var isSelectTab : Bool = false{
        didSet{
            //self.vwTabBottomBar.isHidden = isHideBottomBarView
            self.lblTabName.textColor = isSelectTab ? UIColor.CustomColor.tabBarColor : UIColor.CustomColor.SubscriptuionSubColor
            self.vwTabBottomBar.isHidden = !isSelectTab
            self.lblTabName.font = isSelectTab ? UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 12.0)) :  UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        }
    }
    
    // MARK: - Init Configure
    private func InitConfig(){
        self.lblTabName.textColor = UIColor.CustomColor.tabBarColor
        self.lblTabName.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 11.0))
        
        self.vwRightDot.backgroundColor = UIColor.CustomColor.verificationTextColor
        self.vwTabBottomBar.backgroundColor = UIColor.CustomColor.tabBarColor
       
    }

    @IBAction func btnSelectTabClicked(_ sender: UIButton) {
        self.segmentDelegate?.tabSelect(sender)
    }
}
