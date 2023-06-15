//
//  AdditionalQuestionsCell.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 04/12/21.
//

import UIKit

class AdditionalQuestionsCell: UITableViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet weak var lblQuestionNumber: UILabel?
    @IBOutlet weak var lblQuestion: UILabel?
    
    @IBOutlet weak var lblAnswerHeader: UILabel?
    @IBOutlet weak var lblAnswer: UILabel?
    @IBOutlet weak var vwSeprator: UIView?
    @IBOutlet weak var stackAnswerMain: UIStackView?
    
    @IBOutlet weak var vwAnswer: ReusableTextview?
    
    // MARK: - Variables
    var isFromJobDetail : Bool = false {
        didSet{
            self.vwAnswer?.isHidden = true
        }
    }
    
    var isFromJobApplicant : Bool = false {
        didSet{
            self.vwAnswer?.isHidden = true
            self.stackAnswerMain?.isHidden = false
        }
    }
    
    // MARK: - LIfe Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.InitConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    // MARK: - Init Configure Methods
    private func InitConfig(){
        self.lblQuestionNumber?.textColor = UIColor.CustomColor.tabBarColor
        self.lblQuestionNumber?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 10.0))
         
        self.lblQuestion?.textColor = UIColor.CustomColor.commonLabelColor
        self.lblQuestion?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        
        self.lblAnswerHeader?.textColor = UIColor.CustomColor.tabBarColor
        self.lblAnswerHeader?.font = UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 10.0))
         
        self.lblAnswer?.textColor = UIColor.CustomColor.commonLabelColor
        self.lblAnswer?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        
        self.vwSeprator?.backgroundColor = UIColor.CustomColor.borderColorSession
    }
    
    func setApplicantQuesAnsData(obj : AdditionalQuestionModel){
        self.lblQuestion?.text = obj.question
        self.lblAnswer?.text = obj.answer
    }
}

// MARK: - NibReusable
extension AdditionalQuestionsCell: NibReusable { }
