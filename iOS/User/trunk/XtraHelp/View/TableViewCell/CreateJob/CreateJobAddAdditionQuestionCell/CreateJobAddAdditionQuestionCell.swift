//
//  CreateJobAddAdditionQuestionCell.swift
//  XtraHelp
//
//  Created by wm-devIOShp on 09/12/21.
//

import UIKit

protocol CreateJobAddAdditionQuestionCellEndEditingDelegate {
    func EndQuestionEditing(text : String,cell : CreateJobAddAdditionQuestionCell)
}

class CreateJobAddAdditionQuestionCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var lblQuestion: UILabel?
    @IBOutlet weak var btnRemove: UIButton?
    
    @IBOutlet weak var vwQuestion: ReusableView!
    
    // MARK: - Variables
    var delegate : CreateJobAddAdditionQuestionCellEndEditingDelegate?
    
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
        
        self.lblQuestion?.textColor = UIColor.CustomColor.commonLabelColor
        self.lblQuestion?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))
        
        self.btnRemove?.titleLabel?.font = UIFont.RubikMedium(ofSize: GetAppFontSize(size: 12.0))
        self.btnRemove?.setTitleColor(UIColor.CustomColor.resourceBtnColor, for: .normal)
        
        self.vwQuestion.txtInput.delegate = self
    }
}

//MARK: - UITextField Delegate Methods
extension CreateJobAddAdditionQuestionCell : UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == self.vwQuestion?.txtInput {
            if let del = self.delegate {
                del.EndQuestionEditing(text: textField.text ?? "", cell: self)
            }
        }
        return true
    }
}

// MARK: - NibReusable
extension CreateJobAddAdditionQuestionCell: NibReusable{}
