//
//  CalenderView.swift
//  Momentor
//
//  Created by wm-devIOShp on 20/10/21.
//

import UIKit
import FSCalendar

protocol calenderViewDelegate {
    func selectCalenderDate(date : Date)
    func selectMultipleCalenderDate(arr : [Date])
    func deSelectMultipleCalenderDate(arr : [Date])
}

class CalenderView: UIView {

    @IBOutlet weak var lblMonth: UILabel?
    
    @IBOutlet weak var vwMain: ShadowRadiousView?
    
    @IBOutlet weak var btnPrev: UIButton?
    @IBOutlet weak var btnNext: UIButton?
    
    @IBOutlet weak var calendar: FSCalendar?
    
    // MARK: - Variables
    private var prevStartDate : Date?
    private var prevEndDate : Date?
    private var startDate : Date?
    private var endDate : Date?
    private var dateRange = [Date]()
    
    public var selectedDates : [Date] = [] {
        didSet{
            self.calendar?.select(selectedDates.first)
            self.calendar?.reloadData()
        }
    }
    private var tomorrowDate : Date = Date()
    private var prevSelectedDates = [Date]()
    var todayDate : Date = Date()
    var minimumDate : Date = Date()
    private var editPrevSelectedDates = [Date]()
    
    var arrAvailibilitySelectedDates : [Date] = [] {
        didSet{
            
            self.calendar?.reloadData()
        }
    }
    
    var isFromCaregiverAvailibility : Bool = false
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = AppConstant.DateFormat.k_MM_dd_yyyy
        return formatter
    }()
    
    var isFromOneTime : Bool = false {
        didSet{
            if let calendar = self.calendar {
                calendar.allowsMultipleSelection = !isFromOneTime
                if isFromOneTime {
                    for i in stride(from: 0, to: self.selectedDates.count, by: 1) {
                        calendar.deselect(self.selectedDates[i])
                        if i == self.selectedDates.count - 1 {
                            self.selectedDates.removeAll()
                            calendar.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    var delegate : calenderViewDelegate?
    
    //MARK: - Life Cycle Methods
    override func awakeFromNib() {
        self.InitConfig()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    private func InitConfig(){
        self.lblMonth?.textColor = UIColor.CustomColor.OnlineSidemenuColor
        self.lblMonth?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 13.0))
        
        self.minimumDate = Date().removeTimeStampFromDate()
        self.todayDate = Date().removeTimeStampFromDate()
        
        self.ConfigureCalendarView()
    }
    
    private func ConfigureCalendarView() {
        if let calendar = self.calendar {
            calendar.allowsMultipleSelection = false
            let usLocale = Locale(identifier: "en_US")
            calendar.appearance.headerDateFormat = DateFormatter.dateFormat(fromTemplate: AppConstant.DateFormat.k_MMMM_yyyy, options: 0, locale: usLocale)
            
            let fontSize : CGFloat = DeviceType.IS_PAD ? 14 : 12
            calendar.appearance.titleFont = UIFont.RubikRegular(ofSize: fontSize)
            
            calendar.register(DIYFCCalendarCell.self, forCellReuseIdentifier: "cell")
            calendar.delegate = self
            calendar.dataSource = self
            
            calendar.swipeToChooseGesture.isEnabled = true
            //        self.calendar.ignoreSwitchingByNextPrevious = true
            calendar.headerHeight = 0.0
            calendar.appearance.headerTitleColor = UIColor.CustomColor.searchPlaceholderColor
            //self.calendar.appearance.selectionColor = UIColor.CustomColor.appColor
            calendar.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesUpperCase//weekdayUsesSingleUpperCase
            calendar.appearance.weekdayTextColor = UIColor.CustomColor.weekdayTextColor
            calendar.appearance.todayColor = UIColor.CustomColor.appColor
            calendar.appearance.titleTodayColor = UIColor.CustomColor.appColor
            calendar.appearance.headerMinimumDissolvedAlpha = 0
            calendar.appearance.headerTitleFont = UIFont.RubikBold(ofSize: GetAppFontSize(size: 12.0))
            calendar.placeholderType = .none
            calendar.appearance.borderRadius = 1.0
            
            self.lblMonth?.text = Date().getFormattedString(format: AppConstant.DateFormat.k_MMMM_yyyy)
        }
    }
   
}

// MARK: - IBAction
extension CalenderView {
    @IBAction func btnPrevClicked(_ sender: UIButton) {
        if let calendar = self.calendar {
            calendar.setCurrentPage(getPreviousMonth(date: calendar.currentPage), animated: true)
        }
    }
    
    @IBAction func btnNextClicked(_ sender: UIButton) {
        if let calendar = self.calendar {
            calendar.setCurrentPage(getNextMonth(date: calendar.currentPage), animated: true)
        }
    }
    
    func getNextMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }
    
    func getPreviousMonth(date:Date)->Date {
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
}

//MARK:- Calender Delegate Method
extension CalenderView : FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance{
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        //self.lblCurrentMonth.text = String(calenderView.currentPage.currentMonth)
        self.lblMonth?.text = calendar.currentPage.getFormattedString(format: AppConstant.DateFormat.k_MMM_yyyy)
    }
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        //self.lblCurrentMonth.text = iTemp.shared.getMonthName(index: calenderView.currentPage.currentMonth)
        self.lblMonth?.text = calendar.currentPage.getFormattedString(format: AppConstant.DateFormat.k_MMM_yyyy)
        
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {

        //let dateString = self.dateFormatter1.string(from: date)

        if self.selectedDates.contains(date) {
            return GradientColor(gradientStyle: .topToBottom, frame: calendar.frame(for: date), colors: [UIColor.CustomColor.gradiantColorTop,UIColor.CustomColor.gradiantColorBottom])
        } else if date == self.todayDate {
            return UIColor.CustomColor.whitecolor//GradientColor(gradientStyle: .topToBottom, frame: calendar.frame(for: date), colors: [UIColor.CustomColor.gradiantColorTop,UIColor.CustomColor.gradiantColorBottom])
        } else if self.arrAvailibilitySelectedDates.contains(date) {
            return UIColor.CustomColor.tabBarColor
        }/*else if dateString == self.selectFromHomeScreenDate {
            return #colorLiteral(red: 0.9803921569, green: 0.9098039216, blue: 0, alpha: 1)
        }*/ /*else if date > Date() {
            /*if dateString == self.selectAvailibilityDate{
                return #colorLiteral(red: 0.9803921569, green: 0.9098039216, blue: 0, alpha: 1)
            }*/
            return #colorLiteral(red: 0.9764705882, green: 0.1058823529, blue: 0.1058823529, alpha: 1)
        }*/

        return .clear
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return GradientColor(gradientStyle: .topToBottom, frame: calendar.frame(for: date), colors: [UIColor.CustomColor.gradiantColorTop,UIColor.CustomColor.gradiantColorBottom])
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        if date == self.todayDate {
            return UIColor.CustomColor.appColor//GradientColor(gradientStyle: .topToBottom, frame: calendar.frame(for: date), colors: [UIColor.CustomColor.gradiantColorTop,UIColor.CustomColor.gradiantColorBottom])
        }
        return UIColor.clear
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        if date == self.todayDate {
            return UIColor.CustomColor.appColor//GradientColor(gradientStyle: .topToBottom, frame: calendar.frame(for: date), colors: [UIColor.CustomColor.gradiantColorTop,UIColor.CustomColor.gradiantColorBottom])
        }
        return UIColor.clear
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
       // let dateString = self.dateFormatter1.string(from: date)
        if self.selectedDates.contains(date) {
            return UIColor.white
        } else if self.todayDate == date {
            return UIColor.CustomColor.appColor
        } else if date < self.todayDate {
            return UIColor.CustomColor.prevDateTextColor
        } else if self.arrAvailibilitySelectedDates.contains(date) {
            return UIColor.CustomColor.whitecolor
        }
        return UIColor.black
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        //self.selectAvailibilityDate = ""
        print("Select Date : \(date.getFormattedString(format: AppConstant.DateFormat.k_dd_MM_yyyy))")
        self.selectedDates.append(date)
        if self.isFromCaregiverAvailibility {
            self.delegate?.selectCalenderDate(date: date)
        }
        self.delegate?.selectMultipleCalenderDate(arr: self.selectedDates)
        
        //self.selectedDates.append(date)
        self.calendar?.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("DeSelect Date : \(date.getFormattedString(format: AppConstant.DateFormat.k_dd_MM_yyyy))")
        let filter = self.selectedDates.filter({$0 == date})
        if filter.count > 0 {
            self.selectedDates.removeAll(where: {$0 == date})
            print(self.selectedDates)
            self.delegate?.deSelectMultipleCalenderDate(arr: self.selectedDates)
            self.calendar?.reloadData()
        }
    }
    
    /*func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let dateString = self.dateFormatter1.string(from: date)
        if self.selectedDates.contains(dateString) {
            return false
        }
        return true
    }*/
    func minimumDate(for calendar: FSCalendar) -> Date {
        //return Date()
        return self.minimumDate
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
       // let dateString = self.dateFormatter1.string(from: date)
        /*if self.selectedDates.contains(dateString) {
            return UIColor.white
        } else if dateString == self.todayDate {
            return UIColor.white
        } else if dateString == self.greenDate {
            return UIColor.white
        } else if dateString == self.redDate {
            return UIColor.white
        }*/
        if self.selectedDates.contains(date) {
            return UIColor.white
        } else if date == self.todayDate {
            return UIColor.white
        } else if self.arrAvailibilitySelectedDates.contains(date) {
            return UIColor.CustomColor.whitecolor
        }
        return UIColor.black
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        
        //let dateString = self.dateFormatter1.string(from: date)
        var color : [UIColor] = [.clear]
        if self.selectedDates.contains(date) {
            //let filter = self.selectedDates.filter({$0 == dateString})
            //color =  (filter.count > 0) ? [#colorLiteral(red: 0.8823529412, green: 0.6784313725, blue: 0.003921568627, alpha: 1)] : [UIColor.clear]
        } /*else if self.selectedUnHireDates.contains(dateString) {
            let filter = self.selectedUnHireDates.filter({$0 == dateString})
            color = (filter.count > 0) ? [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)] : [UIColor.clear]
        } else if self.availibilityDates.contains(dateString) {
            let filter = self.availibilityDates.filter({$0 == dateString})
            color = (filter.count > 0) ? [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)] : [UIColor.clear]
        } else if self.selectedHireDates.contains(dateString) {
            let filter = self.selectedHireDates.filter({$0 == dateString})
            color = (filter.count > 0) ? [#colorLiteral(red: 0, green: 0.862745098, blue: 0.4941176471, alpha: 1)] : [UIColor.clear]
        } else if self.selectedPastDates.contains(dateString) {
            let filter = self.selectedPastDates.filter({$0 == dateString})
            color = (filter.count > 0) ? [#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)] : [UIColor.clear]
        } *//*else if dateString == self.selectAvailibilityDate{
            return [UIColor.purple]
        }*/
        return color//[UIColor.clear]//[#colorLiteral(red: 0.9764705882, green: 0.1058823529, blue: 0.1058823529, alpha: 1)]
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        //let dateString = self.dateFormatter1.string(from: date)
       /* if self.selectedDates.contains(dateString) {
            return 1
        }*/
        
        /*if self.selectedDates.contains(dateString) {
            //let filter = self.selectedDates.filter({$0 == dateString})
            //let filter = self.selectedComplatedDates.filter({$0 == dateString})
            //return (filter.count >= 3) ? 3 : filter.count
        } else if self.selectedUnHireDates.contains(dateString) {
            //let filter = self.selectedUnHireDates.filter({$0 == dateString})
            let filter = self.selectedComplatedDates.filter({$0 == dateString})
            return (filter.count >= 3) ? 3 : filter.count
        } else if self.availibilityDates.contains(dateString) {
            //let filter = self.availibilityDates.filter({$0 == dateString})
            let filter = self.selectedComplatedDates.filter({$0 == dateString})
            return (filter.count >= 3) ? 3 : filter.count
        } else if self.selectedHireDates.contains(dateString) {
            //let filter = self.selectedHireDates.filter({$0 == dateString})
            let filter = self.selectedComplatedDates.filter({$0 == dateString})
            return (filter.count >= 3) ? 3 : filter.count
        } else if self.selectedPastDates.contains(dateString) {
            //let filter = self.selectedPastDates.filter({$0 == dateString})
            let filter = self.selectedComplatedDates.filter({$0 == dateString})
            return (filter.count >= 3) ? 3 : filter.count
        }*/ /*else if dateString == self.todayDate {
            return UIColor.white
        }*/
        
        return 0
    }
}

//MARK: - FSCalenderView Setup
/*extension CalenderView {
    private func configureVisibleCells() {
        if let calender = self.calendar {
            calender.visibleCells().forEach { (cell) in
                let date = calender.date(for: cell)
                let position = calender.monthPosition(for: cell)
                
                if let dateIs = date?.removeTimeStampFromDate() {
                    
                    guard let diyCell  = cell as? DIYFCCalendarCell else { return }
                    
                    // let prevDateIs = dateIs.getFormattedString(format: Constant.DateFormat.k_YYYY_MM_dd).getDateFromString(format: Constant.DateFormat.k_YYYY_MM_dd)
                    
                    if let startDt = self.startDate, let endDt = self.endDate,
                       (dateIs.compare(startDt) == .orderedSame ||  dateIs.compare(startDt) == .orderedDescending) &&
                        (dateIs.compare(endDt) == .orderedSame ||  dateIs.compare(endDt) == .orderedAscending) {
                        
                        calender.select(date)
                        //diyCell.selectionLayer.fillColor = (date == self.startDate || date == self.startDate)  ? UIColor.CustomColor.calendarLightColor.cgColor : UIColor.CustomColor.calendarLightColor.withAlphaComponent(0.5).cgColor
                        
                        diyCell.selectionLayer.fillColor = (date == self.startDate || date == self.startDate)  ? UIColor.CustomColor.appColor.cgColor : UIColor.CustomColor.appColor.cgColor
                        
                        //diyCell.startselectionLayer.fillColor = (date == self.startDate || date == self.startDate)  ? UIColor.CustomColor.calendarLightColor.withAlphaComponent(0.5).cgColor : UIColor.clear.cgColor
                        
                        diyCell.startselectionLayer.fillColor = (date == self.startDate || date == self.startDate)  ? UIColor.CustomColor.appColor.cgColor : UIColor.clear.cgColor
                        
                    } else {
                        if let startDt = self.startDate, startDt == dateIs {
                            calender.select(date) //Change this if needed
                            diyCell.selectionLayer.fillColor = (date == self.startDate || date == self.startDate)  ? UIColor.CustomColor.appColor.cgColor : UIColor.CustomColor.appColor.cgColor
                            diyCell.startselectionLayer.fillColor = (date == self.startDate || date == self.startDate)  ? UIColor.CustomColor.appColor.cgColor : UIColor.CustomColor.appColor.cgColor
                            
                        } else {
                            /*if self.prevSelectedDates.contains(prevDateIs) {
                             //cell.calendar.deselect(dateIs)
                             //cell.calendar.select(dateIs)
                             //diyCell.prevSelectionLayer.fillColor = UIColor.CustomColor.prevCalendarLightColor.cgColor
                             diyCell.titleLabel.textColor = UIColor.CustomColor.appColor
                             } else {*/
                            cell.calendar.deselect(dateIs)
                            diyCell.selectionLayer.fillColor = UIColor.clear.cgColor
                            diyCell.startselectionLayer.fillColor = UIColor.clear.cgColor
                            //}
                        }
                    }
                    if let d = date {
                        self.configure(cell: cell, for: d, at: position)
                    }
                }
            }
        }
    }
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        if let calender = self.calendar {
            let diyCell = (cell as! DIYFCCalendarCell)
            //        self.diyCell = diyCell
            
            let dateIs = date.removeTimeStampFromDate()
            if position == .current {
                var selectionType = SelectionType.none
                
                if calender.selectedDates.contains(date) {
                    
                    //Hinali
                    guard let diyCell = cell as? DIYFCCalendarCell else { return }
                    
                    if self.endDate == nil && self.startDate != nil &&  dateIs == self.startDate {
                        selectionType = .single
                        diyCell.selectionLayer.fillColor = UIColor.CustomColor.calendarLightColor.cgColor
                        diyCell.startselectionLayer.fillColor = UIColor.clear.cgColor
                    } else {
                        
                        if dateIs == self.startDate {
                            selectionType = .leftBorder
                            diyCell.selectionLayer.fillColor = UIColor.CustomColor.calendarLightColor.cgColor
                            diyCell.startselectionLayer.fillColor = UIColor.CustomColor.calendarLightColor.cgColor
                        } else if dateIs == self.endDate {
                            selectionType = .rightBorder
                            diyCell.selectionLayer.fillColor = UIColor.CustomColor.calendarLightColor.cgColor
                            diyCell.startselectionLayer.fillColor = UIColor.CustomColor.calendarLightColor.cgColor
                        } else if let s = startDate, let e = endDate , ((dateIs.compare(s) == .orderedDescending) && (dateIs.compare(e) == .orderedAscending))  {
                            selectionType = .middle
                            diyCell.selectionLayer.fillColor = UIColor.CustomColor.calendarLightColor.cgColor
                            diyCell.startselectionLayer.fillColor = UIColor.clear.cgColor
                        } else {
                            selectionType = .none
                            diyCell.calendar.appearance.titleDefaultColor = UIColor.black
                        }
                    }
                } else {
                    //diyCell.calendar.appearance.titleDefaultColor = .black
                    diyCell.selectionLayer.fillColor = UIColor.clear.cgColor
                    diyCell.startselectionLayer.fillColor = UIColor.clear.cgColor
                    selectionType = .none
                    return
                }
                
                if selectionType == .none {
                    //diyCell.calendar.appearance.titleDefaultColor = .black
                    diyCell.selectionLayer.fillColor = UIColor.clear.cgColor
                    diyCell.selectionLayer.isHidden = true
                    diyCell.startselectionLayer.isHidden = true
                    return
                }
                diyCell.selectionType = selectionType
                diyCell.selectionLayer.isHidden = false
                diyCell.startselectionLayer.isHidden = false
            } else {
                diyCell.calendar.appearance.titleDefaultColor = UIColor.black
                diyCell.selectionLayer.fillColor = UIColor.clear.cgColor
                diyCell.selectionLayer.isHidden = true
                diyCell.selectionType = .none
                diyCell.startselectionLayer.fillColor = UIColor.clear.cgColor
                diyCell.startselectionLayer.isHidden = true
            }
        }
    }
    
    
    private func getDateRange(startDate : Date, endDate : Date) -> [Date]? {
        let calendar = Calendar.current
        var dateRange = [Date]()
        
        var sDate = startDate
        dateRange.append(sDate)
        while sDate < endDate {
            let date = calendar.date(byAdding: .day, value: 1, to: sDate)?.removeTimeStampFromDate()
            dateRange.append(date ?? Date())
            sDate = date ?? Date()
        }
        
        return dateRange
    }
    
    
    
    
    private func setStartEndDate() {
        
        //        let formatter = DateFormatter()
        //        formatter.dateFormat = "yyyy"
        //
        //        let dayFormatter = DateFormatter()
        //        dayFormatter.dateFormat = "d"
        
        /*if let s = self.startDate {
            
            let year =  s.getFormattedString(format: Constant.DateFormat.k_MM_dd_yyyy)  //formatter.string(from: s)
            
            let sDateString =  s.getFormattedString(format: "d") //dayFormatter.string(from: s)
            let weekDay = self.getWeekDay(date: s)
            let month = self.getMonth(date: s)
            
            
//            self.lblStartDate.text = "\(weekDay), \(month) \(sDateString)"
//            self.lblStartYear.text = "\(year)"
            
        } else {
//            self.lblStartDate.text = ""
//            self.lblStartYear.text = ""
        }
        
        if let e = self.endDate {
            
            let year =  e.getFormattedString(format: Constant.DateFormat.k_MM_dd_yyyy) //formatter.string(from: e)
            
            let eDateString = e.getFormattedString(format: "d")  //dayFormatter.string(from: e)
            let weekDay = self.getWeekDay(date: e)
            let month = self.getMonth(date: e)
            
//            self.lblEndDate.text = "\(weekDay), \(month) \(eDateString)"
//            self.lblEndYear.text = "\(year)"
            
        } else {
//            self.lblEndDate.text = ""
//            self.lblEndYear.text = ""
        }*/
    }
    
    private func getWeekDay (date : Date) -> String {
        
        /*switch date.getDayOfWeek() {
            
        case WeekDays.Sun.rawValue:
            return LocalizableKeys.WeekDayLabels.kSunday.localized()
            
        case WeekDays.Mon.rawValue:
            return LocalizableKeys.WeekDayLabels.kMonday.localized()
            
        case WeekDays.Tue.rawValue:
            return LocalizableKeys.WeekDayLabels.kTuesday.localized()
            
        case WeekDays.Wed.rawValue:
            return LocalizableKeys.WeekDayLabels.kWednesday.localized()
            
        case WeekDays.Thu.rawValue:
            return LocalizableKeys.WeekDayLabels.kThursday.localized()
            
        case WeekDays.Fri.rawValue:
            return LocalizableKeys.WeekDayLabels.kFriday.localized()
            
        case WeekDays.Sat.rawValue:
            return LocalizableKeys.WeekDayLabels.kSaturday.localized()
            
        default:*/
            return ""
        //}
        
    }
    
    private func getMonth(date : Date) -> String {
        let calendar =  Calendar.current
        _ = calendar.component(.month, from: date)
        
        /*switch month {
        case 1:
            return LocalizableKeys.MonthNames.kJan.localized()
        case 2:
            return LocalizableKeys.MonthNames.kFeb.localized()
        case 3:
            return LocalizableKeys.MonthNames.kMar.localized()
        case 4:
            return LocalizableKeys.MonthNames.kApr.localized()
        case 5:
            return LocalizableKeys.MonthNames.kMay.localized()
        case 6:
            return LocalizableKeys.MonthNames.kJun.localized()
        case 7:
            return LocalizableKeys.MonthNames.kJul.localized()
        case 8:
            return LocalizableKeys.MonthNames.kAug.localized()
        case 9:
            return LocalizableKeys.MonthNames.kSep.localized()
        case 10:
            return LocalizableKeys.MonthNames.kOct.localized()
        case 11:
            return LocalizableKeys.MonthNames.kNov.localized()
        case 12:
            return LocalizableKeys.MonthNames.kDec.localized()
        default:*/
            return ""
        //}
    }
}

//MARK: - FSCalendarDelegate
extension CalenderView : FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        //self.lblCurrentMonth.text = String(calenderView.currentPage.currentMonth)
        self.lblMonth?.text = calendar.currentPage.getFormattedString(format: AppConstant.DateFormat.k_MMMM_yyyy)
    }
   
    func prevDatesRange(from: Date, to: Date,selectedTag : Int) -> Bool {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return false }

        var tempDate = from

        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate) ?? Date()
            print(tempDate.getFormattedString(format: AppConstant.DateFormat.k_dd_MM_yyyy))
            let convertdate = tempDate.getFormattedString(format: AppConstant.DateFormat.k_YYYY_MM_dd).getDateFromString(format: AppConstant.DateFormat.k_YYYY_MM_dd)
            if self.prevSelectedDates.contains(convertdate) && !self.editPrevSelectedDates.contains(convertdate) {
                return true
            }
        }

        return false
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    /*func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return UIColor.red
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return UIColor.red
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let prevDateIs = date.removeTimeStampFromDate().getFormattedString(format: Constant.DateFormat.k_YYYY_MM_dd).getDateFromString(format: Constant.DateFormat.k_YYYY_MM_dd)
        if self.prevSelectedDates.contains(prevDateIs) {
            return UIColor.red
        } else {
            return UIColor.black
        }
    }*/
    
    
    /*func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let prevDateIs = date.removeTimeStampFromDate().getFormattedString(format: Constant.DateFormat.k_YYYY_MM_dd).getDateFromString(format: Constant.DateFormat.k_YYYY_MM_dd)
        if self.prevSelectedDates.contains(prevDateIs) {
            return 1
        }
        return 0
    }*/
    
    
    
    /*func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let prevDateIs = date.removeTimeStampFromDate().getFormattedString(format: Constant.DateFormat.k_YYYY_MM_dd).getDateFromString(format: Constant.DateFormat.k_YYYY_MM_dd)
        if self.prevSelectedDates.contains(prevDateIs) {
            return [UIColor.CustomColor.appColor]
        }
        return nil
    }*/
    
    /*func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        let prevDateIs = date.removeTimeStampFromDate().getFormattedString(format: Constant.DateFormat.k_YYYY_MM_dd).getDateFromString(format: Constant.DateFormat.k_YYYY_MM_dd)
        if self.prevSelectedDates.contains(prevDateIs) {
            return [UIColor.CustomColor.appColor]
        }
        return nil
    }*/
    
    /*func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        let prevDateIs = date.removeTimeStampFromDate().getFormattedString(format: Constant.DateFormat.k_YYYY_MM_dd).getDateFromString(format: Constant.DateFormat.k_YYYY_MM_dd)
        if self.prevSelectedDates.contains(prevDateIs) {
            return UIColor.CustomColor.appColor
        }
        return UIColor.clear
    }*/
    
    /*func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let prevDateIs = date.removeTimeStampFromDate().getFormattedString(format: Constant.DateFormat.k_YYYY_MM_dd).getDateFromString(format: Constant.DateFormat.k_YYYY_MM_dd)
        if self.prevSelectedDates.contains(prevDateIs) {
            return UIColor.CustomColor.appColor
        }
        return UIColor.clear
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        let prevDateIs = date.removeTimeStampFromDate().getFormattedString(format: Constant.DateFormat.k_YYYY_MM_dd).getDateFromString(format: Constant.DateFormat.k_YYYY_MM_dd)
        if self.prevSelectedDates.contains(prevDateIs) {
            return UIColor.CustomColor.appColor
        }
        return UIColor.clear
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        let prevDateIs = date.removeTimeStampFromDate().getFormattedString(format: Constant.DateFormat.k_YYYY_MM_dd).getDateFromString(format: Constant.DateFormat.k_YYYY_MM_dd)
        if self.prevSelectedDates.contains(prevDateIs) {
            return UIColor.CustomColor.appColor
        }
        return UIColor.clear
    }*/
    
    /*func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
        let prevDateIs = date.removeTimeStampFromDate().getFormattedString(format: Constant.DateFormat.k_YYYY_MM_dd).getDateFromString(format: Constant.DateFormat.k_YYYY_MM_dd)
        if self.prevSelectedDates.contains(prevDateIs) {
            return 1.0
        }
        return 0.0
    }*/
    
    /*func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        let prevDateIs = date.removeTimeStampFromDate().getFormattedString(format: Constant.DateFormat.k_YYYY_MM_dd).getDateFromString(format: Constant.DateFormat.k_YYYY_MM_dd)
        if self.prevSelectedDates.contains(prevDateIs) {
            return [UIColor.CustomColor.appColor]
        }
        return [UIColor.clear]
    }*/
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let prevDateIs = date.getFormattedString(format: AppConstant.DateFormat.k_YYYY_MM_dd).getDateFromString(format: AppConstant.DateFormat.k_YYYY_MM_dd)
        let todayDateIs = Date().getFormattedString(format: AppConstant.DateFormat.k_YYYY_MM_dd).getDateFromString(format: AppConstant.DateFormat.k_YYYY_MM_dd)
        if (self.prevSelectedDates.contains(prevDateIs) && !self.self.editPrevSelectedDates.contains(prevDateIs)) {
                return false
        }
        return true
    }
    
    /*func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        let prevDateIs = date.removeTimeStampFromDate().getFormattedString(format: Constant.DateFormat.k_YYYY_MM_dd).getDateFromString(format: Constant.DateFormat.k_YYYY_MM_dd)
        if self.prevSelectedDates.contains(prevDateIs) {
            return UIColor.CustomColor.appColor
        }
        return UIColor.clear
    }*/
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let prevDateIs = date.getFormattedString(format: AppConstant.DateFormat.k_YYYY_MM_dd).getDateFromString(format: AppConstant.DateFormat.k_YYYY_MM_dd)
        //return !self.prevSelectedDates.contains(d)
        if self.prevSelectedDates.contains(prevDateIs) && !self.self.editPrevSelectedDates.contains(prevDateIs){
                return false
        }
        return true
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("Selecting")
        if let calender = self.calendar {
            if self.startDate == nil  {
                self.startDate = date.removeTimeStampFromDate()
            } else if self.endDate == nil {
                if (date > (startDate ?? Date())) {
                    self.endDate = date.removeTimeStampFromDate()
                } else {
                    self.endDate = self.startDate
                    self.startDate = date.removeTimeStampFromDate()
                }
                
                
                
            } else if let s = startDate, let e = endDate , ((date.removeTimeStampFromDate().compare(s) == .orderedDescending) || (date.removeTimeStampFromDate() == s)  || (date.removeTimeStampFromDate().compare(e) == .orderedAscending) || (date.removeTimeStampFromDate() == e)) {
                self.startDate = date.removeTimeStampFromDate()
                self.endDate = nil
                self.dateRange.forEach {
                    calender.deselect($0)
                }
                //Harshad
                self.selectedDates.removeAll()
                
                self.dateRange.removeAll()
                
            } else {
                self.startDate = date.removeTimeStampFromDate()
                self.endDate = nil
                self.dateRange.forEach {
                    calender.deselect($0)
                }
                
                self.dateRange.removeAll()
            }
            
            if let sDate = self.startDate, let  eDate = self.endDate {
                
                if self.prevDatesRange(from: sDate, to: eDate, selectedTag: 0) {
                    self.endDate = nil
                    self.startDate = nil
                    self.selectedDates.removeAll()
                    self.dateRange.removeAll()
                } else {
                    
                    if let dateRange = self.getDateRange(startDate: sDate, endDate: eDate) {
                        self.dateRange = dateRange
                        
                        for item in self.dateRange {
                            if item >= self.tomorrowDate {
                                calender.select(item)
                            }
                        }
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.setStartEndDate()
                
                self.configureVisibleCells()
            }
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        print("Deselecting")
        if let calender = self.calendar {
            if date.removeTimeStampFromDate() == self.startDate {
                
                if self.dateRange.contains(date.removeTimeStampFromDate())/* self.calendar.selectedDates.contains(date.removeTimeStampFromDate())*/ {
                    self.startDate = date.removeTimeStampFromDate()
                    self.endDate = nil
                    self.dateRange.forEach {
                        calender.deselect($0)
                    }
                    self.dateRange.removeAll()
                    self.selectedDates.removeAll()
                } else {
                    self.startDate = nil
                }
                self.endDate = nil
            } else if date.removeTimeStampFromDate() == self.endDate {
                self.startDate = date.removeTimeStampFromDate()
                self.endDate = nil
                self.dateRange.forEach {
                    calender.deselect($0)
                }
                self.dateRange.removeAll()
            } else if self.dateRange.contains(date.removeTimeStampFromDate()) {
                self.startDate = date.removeTimeStampFromDate()
                self.endDate = nil
                self.dateRange.forEach {
                    calender.deselect($0)
                }
                self.dateRange.removeAll()
                self.selectedDates.removeAll()
            }
            self.setStartEndDate()
            self.configureVisibleCells()
        }
    }
}

//MARK: - FSCalendarDataSource
extension CalenderView : FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
        self.lblMonth?.text = calendar.currentPage.getFormattedString(format: AppConstant.DateFormat.k_MMMM_yyyy)
        let prevDateIs = date.removeTimeStampFromDate().getFormattedString(format: AppConstant.DateFormat.k_YYYY_MM_dd).getDateFromString(format: AppConstant.DateFormat.k_YYYY_MM_dd)
        if self.prevSelectedDates.contains(prevDateIs) {
            if !self.self.editPrevSelectedDates.contains(prevDateIs) {
                cell.backgroundColor = UIColor.lightGray
            }
        }
    }
}*/
