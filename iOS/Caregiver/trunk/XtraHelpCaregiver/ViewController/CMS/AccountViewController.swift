//
//  AccountViewController.swift
//  Momentor
//
//  Created by wm-devIOShp on 23/10/21.
//

import UIKit
import AAInfographics
import ViewControllerDescribable

class AccountViewController: UIViewController {

    // MARK: - IBOutlet
    
    @IBOutlet weak var scrollview: UIScrollView?
    
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
    
    @IBOutlet weak var vwBankInfoMain: UIView?
    @IBOutlet weak var btnBankInfo: UIButton?
    // MARK: - Variables
    //public var chartType: AAChartType?
    private var aaChartModel: AAChartModel?
    private var aaChartView: AAChartView = AAChartView()
    
    private var withdrawTotalAmount : Double = 0.0
    
    private var pageNo : Int = 1
    private var totalPages : Int = 0
    private var isLoading = false
    private var arrTransaction : [TransactionModel] = []
    
    private var arrYear : [String] = []
   
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InitConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
        self.addTableviewOberver()
        
        if let user = UserModel.getCurrentUserFromDefault() {
            //self.vwBankInfoMain?.isHidden = !(user.isStripeConnect == "1" && user.isBankDetail == "1")
            self.btnBankInfo?.setTitle(user.isBankDetail == "1" ? "Update Bank Info" : "Add Bank Info", for: .normal)
        }
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
        
        self.arrYear = XtraHelp.sharedInstance.getYearBetween(from: "01-01-2021".getDateFromString(format: AppConstant.DateFormat.k_dd_MM_yyyy), to: Date())
        
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
        
        self.btnBankInfo?.setTitleColor(UIColor.CustomColor.appColor, for: .normal)
        self.btnBankInfo?.titleLabel?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 15.0))
        
        self.vwTotalPriceMain?.cornerRadius = 10.0
        
        if let user = UserModel.getCurrentUserFromDefault() {
            //self.vwBankInfoMain?.isHidden = !(user.isStripeConnect == "1" && user.isBankDetail == "1")
            self.btnBankInfo?.setTitle(user.isBankDetail == "1" ? "Update Bank Info" : "Add Bank Info", for: .normal)
        }
        
        self.setUpAAChartView()
        self.getWalletData()
        
        self.setupESInfiniteScrollinWithTableView()
        self.getUserTransactionList()
        let year = Calendar.current.component(.year, from: Date())
        self.lblTopYear?.text = "\(year)"
        self.getAccountChartData(year: "\(year)")
    }
    
    private func configureGradientColorAreasplineChart(arr : [ChartDataModel]) -> AAChartModel {
        let gradientColorDic1 = AAGradientColor.linearGradient(
            direction: .toBottom,
            startColor: "#F39F44",//"rgba(50,108,122,1.0)",//深粉色, alpha 透明度 1
            endColor: "#FBDDBE"//"rgba(255,255,255,1.0)"//热情的粉红, alpha 透明度 0.3
        )
        let arrmonth = arr.map({$0.month})
        //let arrvalue = arr.map({Double($0.amount) ?? 0})
        
        let arrvalue = arr.map({Double(((Double($0.amount)) ?? 0).convertDoubletoString(digits: 2) ) ?? 0})
        print("Char Values : \(arrvalue)")
        //let formatedarrvalue = arr.map({"$\(Double($0.amount) ?? 0)"})
        //["JAN", "FEB", "MAR", "APR", "MAY", "JUN",
        //"JULY", "AUG", "SEPT", "OCT", "NOV", "DEC"]
        
        var datamodel : AADataLabels = AADataLabels()
            .format("${y}")
            .overflow("r")
        
        /*let aaopriuon : AAOptions = = AAOptions()
            .title?.userHTML(true)
            .for*/
        
        return AAChartModel()
            .chartType(.areaspline)
            .categories(arrmonth)
            .yAxisTitle("")
            .markerRadius(0)//marker点半径为8个像素
            .markerSymbolStyle(.normal)//marker点为空心效果
            .markerSymbol(.circle)//marker点为圆形点○
            .legendEnabled(true)
            .dataLabelsEnabled(false)
            .series([
                AASeriesElement()
                    .enableMouseTracking(false)
                    .dataLabels(datamodel)
                    .name("Total")
                    //.negativeFillColor(gradientColorDic1)
                    .lineWidth(0.0)
                    .color(AAColor.clear)//rgbaColor(220, 20, 60, 1))//AARgba(220, 20, 60, 1))//猩红色, alpha 透明度 1
                    .fillColor(gradientColorDic1)
                    .data(arrvalue),
            ])
            //.tooltipValueSuffix("$")
        //[0.7, 30, 80, 60, 70, 30, 80, 60,10,60]
    }
    
    private func setUpAAChartView() {
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
                //self.aaChartView.aa_drawChartWithChartModel(self.configureGradientColorAreasplineChart())
           // }
        //}
     }
    
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

extension AccountViewController: AAChartViewDelegate {
    
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
}

//MARK: Pagination tableview Mthonthd
extension AccountViewController {
    
    private func reloadTableData(){
        self.pageNo = 1
        self.arrTransaction.removeAll()
        self.tblTransactions?.reloadData()
        self.getUserTransactionList()
        self.getWalletData()
    }
    /**
     This method is used to  setup ESInfiniteScrollin With TableView
     */
    //Harshad
    func setupESInfiniteScrollinWithTableView() {
        
        self.scrollview?.es.addPullToRefresh {
            [unowned self] in
            self.view.endEditing(true)
            self.reloadTableData()
        }
        
        self.scrollview?.es.addInfiniteScrolling {
            
            if !self.isLoading {
                if self.pageNo == 1 {
                    self.getUserTransactionList()
                } else if self.pageNo <= self.totalPages {
                    self.getUserTransactionList(isshowloader: false)
                } else {
                    self.scrollview?.es.noticeNoMoreData()
                }
            } else {
                self.scrollview?.es.noticeNoMoreData()
            }
        }
        if let animator = self.scrollview?.footer?.animator as? ESRefreshFooterAnimator {
            animator.noMoreDataDescription = ""
        }
    }
    
    /**
     This function is used to hide the footer infinte loading.
     - Parameter success: Used to know API reponse is succeed or fail.
     */
    //Harshad
    func hideFooterLoading(success: Bool) {
        if success {
            if self.pageNo == self.totalPages {
                self.scrollview?.es.noticeNoMoreData()
            }
            else {
                self.scrollview?.es.stopLoadingMore()
            }
            self.isLoading = false
        }
        else {
            self.scrollview?.es.stopLoadingMore()
            self.scrollview?.es.noticeNoMoreData()
            self.isLoading = true
        }
        
    }
}


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
        return self.arrTransaction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(for: indexPath, with: TransactionCell.self)
        cell.isFromAcocunt = true
        if self.arrTransaction.count > 0 {
            cell.setTransactionData(obj: self.arrTransaction[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK: - IBAction
extension AccountViewController {
    @IBAction func btnWithdrawClicked(_ sender: XtraHelpButton) {
        if let user = UserModel.getCurrentUserFromDefault() {
            if user.isStripeConnect == "0" || user.isStripeConnect == "" {
                self.connectStripeAPICall()
            } else if user.isBankDetail == "0" || user.isBankDetail == ""{
                self.appNavigationController?.push(BankAccountViewController.self,configuration: { (vc) in
                })
            } else {
                self.appNavigationController?.present(WithdrawAmountViewController.self, configuration: { (vc) in
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.totalAmount = self.withdrawTotalAmount
                    vc.delegate = self
                })
            }
        } else {
            self.connectStripeAPICall()
        }
    }
    
    @IBAction func btnAddUpdateBankInfoClicked(_ sender: UIButton) {
        if let user = UserModel.getCurrentUserFromDefault() {
            if user.isStripeConnect == "0" || user.isStripeConnect == "" {
                self.connectStripeAPICall()
            } else if user.isBankDetail == "0" || user.isBankDetail == "" || user.isBankDetail == "1"{
                self.appNavigationController?.push(BankAccountViewController.self,configuration: { (vc) in
                })
            }
        } else {
            self.connectStripeAPICall()
        }
    }
    
    @IBAction func btnYearSelect(_ sender: UIButton){
        var selecetdIndex : Int = 0
        for i in stride(from: 0, to: self.arrYear.count, by: 1){
            if (self.lblTopYear?.text ?? "") == self.arrYear[i] {
                selecetdIndex = i
            }
        }
        
        let picker = ActionSheetStringPicker(title: "Select Year", rows: self.arrYear, initialSelection: selecetdIndex, doneBlock: { (picker, indexes, values) in
            self.lblTopYear?.text = self.arrYear[indexes]
            self.getAccountChartData(year: self.arrYear[indexes])
            return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
        picker?.toolbarButtonsColor = UIColor.CustomColor.appColor
        picker?.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.CustomColor.labelTextColor]
        picker?.show()
    }
}

// MARK: - WithdrawAmountDelegate
extension AccountViewController : WithdrawAmountDelegate {
    
    func selectWithdrawAmount(price: String) {
        self.withdrawAmountAPICall(amount: price)
    }
}


// MARK: - API Call
extension AccountViewController {
    private func connectStripeAPICall() {
        if let user = UserModel.getCurrentUserFromDefault() {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            AccountModel.connectStripe(with: param, success: { (msg,accID,stripeURL) in
                self.appNavigationController?.push(StripeConnectViewController.self, configuration: { (vc) in
                    vc.stripeURL = stripeURL
                    vc.stripeID = accID
                    vc.delegate = self
                })
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    //self.showAlert(withTitle: errorType.rawValue, with: error)
                    self.showMessage(error, themeStyle: .error)
                }
            })
        }
    }
    
    private func withdrawAmountAPICall(amount : String) {
        if let user = UserModel.getCurrentUserFromDefault() {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kamount : amount
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            AccountModel.withdrawAmount(with: param, success: { (msg) in
                self.showMessage(msg, themeStyle: .success)
                self.getWalletData()
                self.reloadTableData()
                self.getAccountChartData(year: self.lblTopYear?.text ?? "")
                //self.reloadTableData()
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    //self.showAlert(withTitle: errorType.rawValue, with: error)
                    self.showMessage(error, themeStyle: .error)
                }
            })
        }
    }
    
    private func getWalletData() {
        if let user = UserModel.getCurrentUserFromDefault() {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            AccountModel.getWalletData(with: param, success: { (message,amountremainingformate,remainingamount,stripeConnect,totalamount,withdrawamount) in
                self.lblTotalOne?.text = totalamount
                self.lblTotalTwo?.text = withdrawamount
                self.lblTotalThree?.text = amountremainingformate
                self.withdrawTotalAmount = remainingamount.toDouble() ?? 0
                
                if let user = UserModel.getCurrentUserFromDefault(){
                    user.isStripeConnect = stripeConnect
                    user.saveCurrentUserInDefault()
                }
                
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                if !error.isEmpty {
                    //self.showAlert(withTitle: errorType.rawValue, with: error)
                    self.showMessage(error, themeStyle: .error)
                }
            })
        }
    }
    
    private func getUserTransactionList(isshowloader :Bool = true){
        if let user = UserModel.getCurrentUserFromDefault() {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kPageNo : "\(self.pageNo)",
                klimit : "10",
                ksearch : ""
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            TransactionModel.getUserTransaction(with: param, isShowLoader: isshowloader, success: { (arr,totalpage,msg) in
                //self.arrResources = arr
                self.scrollview?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.totalPages = totalpage
                
                self.arrTransaction.append(contentsOf: arr)
                self.hideFooterLoading(success: self.pageNo <= self.totalPages ? true : false )
                self.pageNo = self.pageNo + 1
                self.tblTransactions?.reloadData()
                //self.vwNoData.isHidden = (self.arrCard.isEmpty && self.arrTransaction.isEmpty) ? false : true
                /*if self.arrCard.isEmpty && self.arrTransaction.isEmpty {
                    self.headerview?.setNoCardNoTransaction(isHide: true)
                }*/
                //self.lblNoData.isHidden = self.arrBlog.count == 0 ?  false : true
                //self.lblNoData.text = msg
                self.vwTransactionsMain?.isHidden = self.arrTransaction.isEmpty
            }, failure: {[unowned self] (statuscode,error, errorType) in
                print(error)
                self.scrollview?.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
                self.hideFooterLoading(success: false )
                self.vwTransactionsMain?.isHidden = self.arrTransaction.isEmpty
                //self.vwNoData.isHidden = (self.arrCard.isEmpty && self.arrTransaction.isEmpty) ? false : true
                /*if self.arrCard.isEmpty && self.arrTransaction.isEmpty {
                    self.headerview?.setNoCardNoTransaction(isHide: true)
                }*/
                //self.lblNoData.isHidden = self.arrBlog.count == 0 ?  false : true
                if !error.isEmpty {
                    //showMessage(error)
                    //self.lblNoData.text = error
                }
            })
        }
    }
    
    private func getAccountChartData(isshowloader :Bool = true,year : String){
        if let user = UserModel.getCurrentUserFromDefault() {
            
            let dict : [String:Any] = [
                klangType : XtraHelp.sharedInstance.languageType,
                ktoken : user.token,
                kyear : year
            ]
            
            let param : [String:Any] = [
                kData : dict
            ]
            
            ChartDataModel.getAccountChartData(with: param, isShowLoader: isshowloader, success: { (arr,totalpage,msg) in
                self.aaChartView.aa_drawChartWithChartModel(self.configureGradientColorAreasplineChart(arr: arr))
            }, failure: { (statuscode,error, errorType) in
                print(error)
            })
        }
    }
}

// MARK: - API Call
extension AccountViewController : stripeConnectDelegate {
    func successStripe(){
        //self.isStripeConnected = true
        //self.reloadTableData()
    }
}

// MARK: - ViewControllerDescribable
extension AccountViewController: ViewControllerDescribable {
    static var storyboardName: StoryboardNameDescribable {
        return UIStoryboard.Name.CMS
    }
}

// MARK: - AppNavigationControllerInteractable
extension AccountViewController: AppNavigationControllerInteractable{}
