//
//  AccountViewController.swift
//  Momentor
//
//  Created by wm-devIOShp on 23/10/21.
//

import UIKit
//import AAInfographics
import ViewControllerDescribable

class AccountViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var vwTopMain: UIView?
    @IBOutlet weak var vwTopMonthSub: UIView?
    @IBOutlet weak var vwTopYearSub: UIView?
    @IBOutlet weak var vwTotalPriceMain: UIView?
    @IBOutlet weak var vwTransactionsMain: UIView?
    @IBOutlet weak var vwWithdrawMain: UIView?
    @IBOutlet weak var vwChatMain: UIView?
    
    @IBOutlet var vwSeprator: [UIView]?
    
    @IBOutlet weak var btnWithdraw: XtraHelpButton?
    
    @IBOutlet weak var lblTopMonth: UILabel?
    @IBOutlet weak var lblTopYear: UILabel?
    @IBOutlet weak var lblTotalOne: UILabel?
    @IBOutlet weak var lblTotalOneSub: UILabel?
    @IBOutlet weak var lblTotalTwo: UILabel?
    @IBOutlet weak var lblTotalTwoSub: UILabel?
    @IBOutlet weak var lblTotalThree: UILabel?
    @IBOutlet weak var lblTotalThreeSub: UILabel?
    @IBOutlet weak var lblTransactionsHeader: UILabel?
    
    @IBOutlet weak var tblTransactions: UITableView?
    @IBOutlet weak var constraintTblTransactionsHeight: NSLayoutConstraint?
    
    // MARK: - Variables
    //public var chartType: AAChartType?
    //private var aaChartModel: AAChartModel?
    //private var aaChartView: AAChartView = AAChartView()
   
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
        self.addTableviewOberver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeTableviewObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
}
// MARK: - Init Configure
extension AccountViewController {
    private func InitConfig(){
        
        self.view.backgroundColor = UIColor.CustomColor.tutorialBGColor
        
        self.tblTransactions?.register(TransactionCell.self)
        self.tblTransactions?.estimatedRowHeight = 100.0
        self.tblTransactions?.rowHeight = UITableView.automaticDimension
        self.tblTransactions?.delegate = self
        self.tblTransactions?.dataSource = self
        
        [self.lblTotalOne,self.lblTotalTwo,self.lblTotalThree].forEach({
            $0?.textColor = UIColor.CustomColor.OnlineSidemenuColor
            $0?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 18.0))
        })
        
        [self.lblTotalOneSub,self.lblTotalTwoSub,self.lblTotalThreeSub].forEach({
            $0?.textColor = UIColor.CustomColor.searchPlaceholderColor
            $0?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 12.0))
        })
        
        [self.lblTopMonth,self.lblTopYear].forEach({
            $0?.textColor = UIColor.CustomColor.blackColor
            $0?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        })
        
        [self.vwTopMonthSub,self.vwTopYearSub].forEach({
            $0?.cornerRadius = 10.0
            $0?.borderColor = UIColor.CustomColor.borderColor
            $0?.borderWidth = 1.5
        })
        
        self.vwSeprator?.forEach({
            $0.backgroundColor = UIColor.CustomColor.progressBarBackColor
        })
        
        self.lblTransactionsHeader?.textColor = UIColor.CustomColor.NavTitleColor
        self.lblTransactionsHeader?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 18.0))
        
        self.vwTotalPriceMain?.cornerRadius = 10.0
        
        //self.setUpAAChartView()
    }
    
    /*private func configureGradientColorAreasplineChart() -> AAChartModel {
        let gradientColorDic1 = AAGradientColor.linearGradient(
            direction: .toBottom,
            startColor: "#F39F44",//"rgba(50,108,122,1.0)",//深粉色, alpha 透明度 1
            endColor: "#FBDDBE"//"rgba(255,255,255,1.0)"//热情的粉红, alpha 透明度 0.3
        )
        
        return AAChartModel()
            .chartType(.areaspline)
            .categories(["JAN", "FEB", "MAR", "APR", "MAY", "JUN",
                         "JULY", "AUG", "SEPT", "OCT", "NOV", "DEC"])
            .yAxisTitle("")
            .markerRadius(0)//marker点半径为8个像素
            .markerSymbolStyle(.normal)//marker点为空心效果
            .markerSymbol(.circle)//marker点为圆形点○
            .legendEnabled(true)
            .dataLabelsEnabled(false)
            .series([
                AASeriesElement()
                    .name("Total")
                    //.negativeFillColor(gradientColorDic1)
                    .lineWidth(0.0)
                    .color(AAColor.clear)//rgbaColor(220, 20, 60, 1))//AARgba(220, 20, 60, 1))//猩红色, alpha 透明度 1
                    .fillColor(gradientColorDic1)
                    .data([0.7, 30, 80, 60, 70, 30, 80, 60,10,60]),
            ])
    }*/
    
    /*private func setUpAAChartView() {
        self.aaChartView = AAChartView()
        // let chartViewWidth = view.frame.size.width
         //let chartViewHeight = view.frame.size.height - 220
        self.aaChartView.frame = CGRect(x: 0,
                                     y: 30,
                                     width: self.vwChatMain?.frame.width ?? ScreenSize.SCREEN_WIDTH - 40.0,
                                     height: self.vwChatMain?.frame.height ?? ScreenSize.SCREEN_WIDTH - 40.0)
        //if let view = self.aaChartView {
            self.vwChatMain?.addSubview(self.aaChartView)
            self.aaChartView.scrollEnabled = true//Disable chart content scrolling
            self.aaChartView.isClearBackgroundColor = true
            self.aaChartView.delegate = self
            
            //self.aaChartModel = self.configureGradientColorAreasplineChart()
           // if let model = self.aaChartModel {
                self.aaChartView.aa_drawChartWithChartModel(self.configureGradientColorAreasplineChart())
           // }
        //}
     }*/
    
    private func configureNavigationBar()
    {

        appNavigationController?.setNavigationBarHidden(true, animated: true)
        appNavigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appNavigationController?.appNavigationControllersetTitleWithBack(title: "Account", TitleColor: UIColor.CustomColor.tabBarColor, navigationItem: self.navigationItem)
        
        navigationController?.navigationBar
            .configure(barTintColor: UIColor.CustomColor.tabBarColor, tintColor: UIColor.CustomColor.tabBarColor)
        navigationController?.navigationBar.removeShadowLine()
    }
}

/*extension AccountViewController: AAChartViewDelegate {
    
    open func aaChartViewDidFinishLoad(_ aaChartView: AAChartView) {
       print("🙂🙂🙂, AAChartView Did Finished Load!!!")
    }

    open func aaChartView(_ aaChartView: AAChartView, moveOverEventMessage: AAMoveOverEventMessageModel) {
        print(
            """

            selected point series element name: \(moveOverEventMessage.name ?? "")
            🔥🔥🔥WARNING!!!!!!!!!!!!!!!!!!!! Touch Event Message !!!!!!!!!!!!!!!!!!!! WARNING🔥🔥🔥
            ==========================================================================================
            ------------------------------------------------------------------------------------------
            user finger moved over!!!,get the move over event message: {
            category = \(String(describing: moveOverEventMessage.category))
            index = \(String(describing: moveOverEventMessage.index))
            name = \(String(describing: moveOverEventMessage.name))
            offset = \(String(describing: moveOverEventMessage.offset))
            x = \(String(describing: moveOverEventMessage.x))
            y = \(String(describing: moveOverEventMessage.y))
            }
            +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            
            
            """
        )
    }
}*/

//MARK: - Tableview Observer
extension AccountViewController {
    
    private func addTableviewOberver() {
        self.tblTransactions?.addObserver(self, forKeyPath: ObserverName.kcontentSize, options: .new, context: nil)
    }
    
    func removeTableviewObserver() {
        if self.tblTransactions?.observationInfo != nil {
            self.tblTransactions?.removeObserver(self, forKeyPath: ObserverName.kcontentSize)
        }
    }
    
    /**
     This method is used to observeValue in table view.
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UITableView {
            if obj == self.tblTransactions && keyPath == ObserverName.kcontentSize {
                self.constraintTblTransactionsHeight?.constant = self.tblTransactions?.contentSize.height ?? 0.0
            }
        }
    }
}

//MARK:- UITableView Delegate
extension AccountViewController : UITableViewDataSource, UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(for: indexPath, with: TransactionCell.self)
        cell.isFromAcocunt = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK: - IBAction
extension AccountViewController {
    @IBAction func btnWithdrawClicked(_ sender: XtraHelpButton) {
      
    }
}

// MARK: - ViewControllerDescribable
extension AccountViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.Payment
    }
}

// MARK: - AppNavigationControllerInteractable
extension AccountViewController: AppNavigationControllerInteractable{}
