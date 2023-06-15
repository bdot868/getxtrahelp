//
//  AdditionalQuestionsCell.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 04/12/21.
//

import UIKit

protocol JobAddAdditionQuestionCellEndEditingDelegate {
    func EndQuestionEditing(text : String,cell : AdditionalQuestionsCell)
}

class AdditionalQuestionsCell: UITableViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet weak var lblQuestionNumber: UILabel?
    @IBOutlet weak var lblQuestion: UILabel?
    @IBOutlet weak var lblAnswer: UILabel?
   
    @IBOutlet weak var vwAnswer: ReusableTextview?
    
    // MARK: - Variables
    var isFromJobDetail : Bool = false {
        didSet{
            self.vwAnswer?.isHidden = true
            //self.lblAnswer?.isHidden = false
        }
    }
    var delegate : JobAddAdditionQuestionCellEndEditingDelegate?
    
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
        
        self.lblAnswer?.textColor = UIColor.CustomColor.SubscriptuionSubColor
        self.lblAnswer?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 13.0))
        
        self.vwAnswer?.txtInput?.delegate = self
    }
}

//MARK: - UITextField Delegate Methods
extension AdditionalQuestionsCell : UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == self.vwAnswer?.txtInput {
            if let del = self.delegate {
                del.EndQuestionEditing(text: textView.text ?? "", cell: self)
            }
        }
    }
}

// MARK: - NibReusable
extension AdditionalQuestionsCell: NibReusable { }
