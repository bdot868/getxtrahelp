//
//  CertificateCell.swift
//  XtraHelpCaregiver
//
//  Created by wm-devIOShp on 16/11/21.
//

import UIKit

protocol CertificateCellEndEditingDelegate {
    func EndCerNameEditing(text : String,cell : CertificateCell)
    func EndCerNumberEditing(text : String,cell : CertificateCell)
    func EndCerDescEditing(text : String,cell : CertificateCell)
}

class CertificateCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var lblType: UILabel?
    @IBOutlet weak var lblUpload: UILabel?
    
    @IBOutlet weak var vwType: ReusableView?
    @IBOutlet weak var vwCerName: ReusableView?
    @IBOutlet weak var vwCerNumber: ReusableView?
    @IBOutlet weak var vwDateIssue: ReusableView?
    @IBOutlet weak var vwDateExpire: ReusableView?
    @IBOutlet weak var vwDateIssueMain: UIView?
    @IBOutlet weak var vwDateExpireMain: UIView?
    
    @IBOutlet weak var vwUploadMain: UIView?
    @IBOutlet weak var vwimgCertificate: UIView?
    
    @IBOutlet weak var btnUpload: UIButton?
    @IBOutlet weak var btnSelectType: UIButton?
    
    @IBOutlet weak var btnSelectDateIssue: UIButton?
    @IBOutlet weak var btnSelectDateExpire: UIButton?
    
    @IBOutlet weak var imgCertificate: UIImageView?
    
    @IBOutlet weak var vwDescCer: ReusableTextview?
    
    // MARK: - Variables
    var certificateDelegate : CertificateCellEndEditingDelegate?
    
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
    
    // MARK: - Init Configure Methods
    private func InitConfig(){
        
        self.lblType?.textColor = UIColor.CustomColor.SubscriptuionSubColor
        self.lblType?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 15.0))
        
        self.lblUpload?.textColor = UIColor.CustomColor.appColor
        self.lblUpload?.font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))
        
        delay(seconds: 0.2) {
            self.vwUploadMain?.addDashedBorder()
            self.vwimgCertificate?.cornerRadius = 15.0
            self.imgCertificate?.cornerRadius = 15.0
            //self.vwimgCertificate?.addDashedBorder()
        }
        
        [self.vwCerName,self.vwCerNumber].forEach({
            $0?.txtInput.delegate = self
        })
        
        self.vwDescCer?.txtInput?.delegate = self
    }
    
    func setInsurenceData(){
        self.vwCerName?.placeholderText = "Insurance Name Here"
        self.vwCerNumber?.placeholderText = "Insurance Number"
        self.vwDateIssueMain?.isHidden = true
        self.vwDateExpire?.placeholderText = "Date Expires"
        self.lblUpload?.text = "Upload Insurance"
        self.vwDescCer?.isHidden = true
    }
    
    func setCertificateData(obj : CertificationsLicenseModel) {
        self.vwType?.txtInput.text = obj.licenceTypeName
        self.vwCerName?.txtInput.text = obj.licenceName
        self.vwCerNumber?.txtInput.text = obj.licenceNumber
        if !obj.issueDate.isEmpty {
            self.vwDateIssue?.txtInput.text = obj.issueDate.getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd).getTimeString(inFormate: AppConstant.DateFormat.k_MM_dd_yyyy)
        }
        if !obj.expireDate.isEmpty {
            self.vwDateExpire?.txtInput.text = obj.expireDate.getDateFromString(format: AppConstant.DateFormat.k_yyyy_MM_dd).getTimeString(inFormate: AppConstant.DateFormat.k_MM_dd_yyyy)
        }
        
        self.vwDescCer?.txtInput?.text = obj.licenceDescription
        self.vwimgCertificate?.isHidden = obj.licenceImageUrl.isEmpty
        if !obj.licenceImageUrl.isEmpty {
            if #available(iOS 13.0, *) {
                self.imgCertificate?.setImage(withUrl: obj.licenceImageUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.AppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .gray)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func setInsuranceData(obj : InsuranceModel) {
        self.vwType?.txtInput.text = obj.insuranceTypeName
        self.vwCerName?.txtInput.text = obj.insuranceName
        self.vwCerNumber?.txtInput.text = obj.insuranceNumber
       
       
        
        self.vwimgCertificate?.isHidden = obj.insuranceImageUrl.isEmpty
        if !obj.insuranceImageUrl.isEmpty {
            if #available(iOS 13.0, *) {
                self.imgCertificate?.setImage(withUrl: obj.insuranceImageUrl, placeholderImage: #imageLiteral(resourceName: DefaultPlaceholderImage.AppPlaceholder), indicatorStyle: .medium, isProgressive: true, imageindicator: .gray)
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

//MARK: - UITextField Delegate Methods
extension CertificateCell : UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == self.vwCerName?.txtInput {
            if let del = self.certificateDelegate {
                del.EndCerNameEditing(text: textField.text ?? "", cell: self)
            }
        } else if textField == self.vwCerNumber?.txtInput {
            if let del = self.certificateDelegate {
                del.EndCerNumberEditing(text: textField.text ?? "", cell: self)
            }
        }
        return true
    }
}

//MARK: - UITextView Delegate Methods
extension CertificateCell : UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView == self.vwDescCer?.txtInput {
            if let del = self.certificateDelegate {
                del.EndCerDescEditing(text: textView.text ?? "", cell: self)
            }
        }
        return true
    }
}

// MARK: - NibReusable
extension CertificateCell: NibReusable { }
