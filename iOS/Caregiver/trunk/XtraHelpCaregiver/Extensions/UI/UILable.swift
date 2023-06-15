//
//  UILable.swift
//  Momentor
//
//  Created by mac on 21/01/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

extension UILabel {
    
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 12.0)], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
    
    // MARK: - spacingValue is spacing that you need
    func addInterlineSpacing(spacingValue: CGFloat = 2) {

        // MARK: - Check if there's any text
        guard let textString = text else { return }

        // MARK: - Create "NSMutableAttributedString" with your text
        let attributedString = NSMutableAttributedString(string: textString)

        // MARK: - Create instance of "NSMutableParagraphStyle"
        let paragraphStyle = NSMutableParagraphStyle()

        // MARK: - Actually adding spacing we need to ParagraphStyle
        paragraphStyle.lineSpacing = spacingValue

        // MARK: - Adding ParagraphStyle to your attributed String
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length
        ))

        // MARK: - Assign string that you've modified to current attributed Text
        attributedText = attributedString
    }
    
    
    func setSessionDateAttributedTextLable(firstText : String,SecondText :String) {

        let accountAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.NavTitleColor, NSAttributedString.Key.font: UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 12.0))]
        let signupAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.NavTitleColor, NSAttributedString.Key.font: UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 19.0))]

        let account = NSMutableAttributedString(string: firstText, attributes: accountAttributes)
        let signup = NSMutableAttributedString(string: SecondText, attributes: signupAttributes)

        let combination = NSMutableAttributedString()

        combination.append(account)
        combination.append(signup)
        
        /*let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        combination.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, combination.length))*/
        
        self.attributedText = combination
    }
    func setHeaderCommonAttributedTextLable(firstText : String,SecondText :String) {

        let accountAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.whitecolor, NSAttributedString.Key.font: UIFont.RubikLight(ofSize: GetAppFontSize(size: 39.0))]
        let signupAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.whitecolor, NSAttributedString.Key.font: UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 39.0))]

        let account = NSMutableAttributedString(string: firstText, attributes: accountAttributes)
        let signup = NSMutableAttributedString(string: SecondText, attributes: signupAttributes)

        let combination = NSMutableAttributedString()

        combination.append(account)
        combination.append(signup)
        
        self.attributedText = combination
    }
    
    func setFindJobHeaderAttributedTextLable(firstText : String,SecondText :String) {

        let accountAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.whitecolor, NSAttributedString.Key.font: UIFont.RubikRegular(ofSize: GetAppFontSize(size: 25.0))]
        let signupAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.whitecolor, NSAttributedString.Key.font: UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 25.0))]

        let account = NSMutableAttributedString(string: firstText, attributes: accountAttributes)
        let signup = NSMutableAttributedString(string: SecondText, attributes: signupAttributes)

        let combination = NSMutableAttributedString()

        combination.append(account)
        combination.append(signup)
        
        self.attributedText = combination
    }
    
    func setHelloUserAttributedTextLable(firstText : String,SecondText :String) {

        let accountAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.whitecolor, NSAttributedString.Key.font: UIFont.RubikLight(ofSize: GetAppFontSize(size: 22.0))]
        let signupAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.whitecolor, NSAttributedString.Key.font: UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 22.0))]

        let account = NSMutableAttributedString(string: firstText, attributes: accountAttributes)
        let signup = NSMutableAttributedString(string: SecondText, attributes: signupAttributes)

        let combination = NSMutableAttributedString()

        combination.append(account)
        combination.append(signup)
        
        self.attributedText = combination
    }
    
    func setAlreadyRegisterAttributedTextLable(firstText : String,SecondText :String) {

        let accountAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.whitecolor, NSAttributedString.Key.font: UIFont.RubikLight(ofSize: GetAppFontSize(size: 13.0))]
        let signupAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.whitecolor, NSAttributedString.Key.font: UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 13.0))]
            
        let account = NSMutableAttributedString(string: firstText, attributes: accountAttributes)
        let signup = NSMutableAttributedString(string: SecondText, attributes: signupAttributes)

        let combination = NSMutableAttributedString()

        combination.append(account)
        combination.append(signup)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0

        // MARK: - Adding ParagraphStyle to your attributed String
        combination.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: combination.length
        ))
        
        self.attributedText = combination
    }
    func setTermConditionAttributedTextLable(firstText : String,SecondText :String) {

        let accountAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.textConnectLogin, NSAttributedString.Key.font: UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))]
        let signupAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.forgotColor, NSAttributedString.Key.font: UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))]

        let account = NSMutableAttributedString(string: firstText, attributes: accountAttributes)
        let signup = NSMutableAttributedString(string: SecondText, attributes: signupAttributes)
       
        let combination = NSMutableAttributedString()

        combination.append(account)
        combination.append(signup)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        combination.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, combination.length))
        
        self.attributedText = combination
    }
    
    func setMembershipPriceAttributedTextLable(firstText : String,SecondText :String) {

        let accountAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.whitecolor, NSAttributedString.Key.font: UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 80.0))]
        let signupAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.appColor, NSAttributedString.Key.font: UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 22.0))]

        let account = NSMutableAttributedString(string: firstText, attributes: accountAttributes)
        let signup = NSMutableAttributedString(string: SecondText, attributes: signupAttributes)

        let combination = NSMutableAttributedString()

        combination.append(account)
        combination.append(signup)
        
        self.attributedText = combination
    }
    
    func setAttributedFeedText(str : String) {
        let nsText: NSString = str as NSString
        let words:[String] = nsText.components(separatedBy: .whitespacesAndNewlines)
        let attributedString = NSMutableAttributedString(string: nsText as String, attributes: [NSAttributedString.Key.font:UIFont.RubikRegular(ofSize: GetAppFontSize(size: GetAppFontSize(size: 14.0)))])
        let boldFontAttribute = [NSAttributedString.Key.font: UIFont.RubikRegular(ofSize: GetAppFontSize(size: GetAppFontSize(size: 14.0)))]
        
        let linkFontAttribute = [NSAttributedString.Key.font: UIFont.RubikRegular(ofSize: GetAppFontSize(size: GetAppFontSize(size: 14.0))),NSAttributedString.Key.foregroundColor : UIColor.CustomColor.LinkedinColor,NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
        
        for word in words {
            if word.hasPrefix("#") {
                let matchRange:NSRange = nsText.range(of: word as String)
                attributedString.addAttributes(boldFontAttribute, range: matchRange)
                // for append value in string
            }
            
            let w = word.lowercased()
            if w.contains("http:") || w.contains("www.") || w.contains("https:") {
                
                let matchRange:NSRange = nsText.range(of: word as String)
                attributedString.addAttributes(linkFontAttribute, range: matchRange)
            }
        }
        
        self.attributedText = attributedString
        
    }
    
    func setGetIntroduceTextLable(firstText : String,SecondText :String,ThirdText :String) {

        let accountAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.LoginSubLabelTextColor, NSAttributedString.Key.font: UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))]
        let signupAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.LoginSubLabelTextColor, NSAttributedString.Key.font: UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))]
        let otherAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.LoginSubLabelTextColor, NSAttributedString.Key.font: UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))]

        let account = NSMutableAttributedString(string: firstText, attributes: accountAttributes)
        let signup = NSMutableAttributedString(string: SecondText, attributes: signupAttributes)
        let other = NSMutableAttributedString(string: ThirdText, attributes: otherAttributes)

        let combination = NSMutableAttributedString()

        combination.append(account)
        combination.append(signup)
        combination.append(other)
        
        self.attributedText = combination
    }
    
    func setHomeCourseTimeAttributedTextLable(firstText : String,SecondText :String) {

        let accountAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.whitecolor, NSAttributedString.Key.font: UIFont.RubikRegular(ofSize: GetAppFontSize(size: 9.0))]
        let signupAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.whitecolor, NSAttributedString.Key.font: UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 12.0))]
            //,NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]

        let account = NSMutableAttributedString(string: firstText, attributes: accountAttributes)
        let signup = NSMutableAttributedString(string: SecondText, attributes: signupAttributes)

        let combination = NSMutableAttributedString()

        combination.append(account)
        combination.append(signup)
        
        self.attributedText = combination
    }
    
    func setCourseUpgradeAttributedTextLable(firstText : String,SecondText :String) {

        let accountAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.labelTextColor, NSAttributedString.Key.font: UIFont.RubikMedium(ofSize: GetAppFontSize(size: 14.0))]
        let signupAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.labelTextColor, NSAttributedString.Key.font: UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0))]
            //,NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]

        let account = NSMutableAttributedString(string: firstText, attributes: accountAttributes)
        let signup = NSMutableAttributedString(string: SecondText, attributes: signupAttributes)

        let combination = NSMutableAttributedString()

        combination.append(account)
        combination.append(signup)
        
        self.attributedText = combination
    }
    
    func setPriceTextLable(firstText : String,SecondText : String) {

        let accountAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.commonLabelColor, NSAttributedString.Key.font: UIFont.RubikMedium(ofSize: GetAppFontSize(size: 25.0))]
        let signupAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.commonLabelColor, NSAttributedString.Key.font: UIFont.RubikMedium(ofSize: GetAppFontSize(size: 15.0))]

        let account = NSMutableAttributedString(string: firstText, attributes: accountAttributes)
        let signup = NSMutableAttributedString(string: SecondText, attributes: signupAttributes)

        let combination = NSMutableAttributedString()

        combination.append(account)
        combination.append(signup)
        
        self.attributedText = combination
    }
    
    func setCourseUpgradePriceAttributedTextLable(firstText : String,SecondText :String) {

        let accountAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.labelTextColor, NSAttributedString.Key.font: UIFont.RubikBold(ofSize: GetAppFontSize(size: 28.0))]
        let signupAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.labelTextColor, NSAttributedString.Key.font: UIFont.RubikBold(ofSize: GetAppFontSize(size: 14.0))]
            //,NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]

        let account = NSMutableAttributedString(string: firstText, attributes: accountAttributes)
        let signup = NSMutableAttributedString(string: SecondText, attributes: signupAttributes)

        let combination = NSMutableAttributedString()

        combination.append(account)
        combination.append(signup)
        
        self.attributedText = combination
    }
    
    func setHomeLastLoginAttributedTextLable(firstText : String,SecondText :String) {

        let accountAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.labelTextColor, NSAttributedString.Key.font: UIFont.RubikRegular(ofSize: GetAppFontSize(size: 10.0))]
        let signupAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.profilebackcolor, NSAttributedString.Key.font: UIFont.RubikRegular(ofSize: GetAppFontSize(size: 10.0))]
            //,NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]

        let account = NSMutableAttributedString(string: firstText, attributes: accountAttributes)
        let signup = NSMutableAttributedString(string: SecondText, attributes: signupAttributes)

        let combination = NSMutableAttributedString()

        combination.append(account)
        combination.append(signup)
        
        self.attributedText = combination
    }
    
    func OTPAttributedTextLable(firstText : String,SecondText :String) {

        let accountAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.registerColor, NSAttributedString.Key.font: UIFont.RubikBold(ofSize: GetAppFontSize(size: 10.0))]
        let signupAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.otpTextColor, NSAttributedString.Key.font: UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 12.0))]

        let account = NSMutableAttributedString(string: firstText, attributes: accountAttributes)
        let signup = NSMutableAttributedString(string: SecondText, attributes: signupAttributes)

        let combination = NSMutableAttributedString()

        combination.append(account)
        combination.append(signup)
        
        self.attributedText = combination
    }
    
    func setUnitDetailHTMLFromString(text: String,fontSize : CGFloat = 14.0) {
        let font = UIFont(name: "Poppins-Regular", size: GetAppFontSize(size: fontSize)) ?? UIFont.systemFont(ofSize: GetAppFontSize(size: fontSize))
        let modifiedFont = NSString(format:"<span style=\"font-family: \(font.fontName); font-size: \(font.pointSize); color:#242F57\">%@</span>" as NSString, text)
        do {
            let attrStr = try NSAttributedString(
                data: modifiedFont.data(using: String.Encoding.unicode.rawValue, allowLossyConversion: true)!,
                options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil)

            self.attributedText = attrStr.attributedStringWithResizedImages(with: self.frame.size.width)
        } catch {
            
        }
    }
    
    func setExperienceAttributedTextLable(firstText : String,SecondText :String) {

        let accountAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.AppointmentTExtColor, NSAttributedString.Key.font: UIFont.RubikMedium(ofSize: GetAppFontSize(size: 9.0))]
        let signupAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.tabBarColor, NSAttributedString.Key.font: UIFont.RubikBold(ofSize: GetAppFontSize(size: 11.0))]

        let account = NSMutableAttributedString(string: firstText, attributes: accountAttributes)
        let signup = NSMutableAttributedString(string: SecondText, attributes: signupAttributes)

        let combination = NSMutableAttributedString()

        combination.append(account)
        combination.append(signup)
        
        self.attributedText = combination
    }
    
    func setNextAvailableAttributedLable(firstText : String,SecondText :String) {

        let accountAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.SuccessStaus, NSAttributedString.Key.font: UIFont.RubikMedium(ofSize: GetAppFontSize(size: 9.0))]
        let signupAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.tabBarColor, NSAttributedString.Key.font: UIFont.RubikMedium(ofSize: GetAppFontSize(size: 11.0))]

        let account = NSMutableAttributedString(string: firstText, attributes: accountAttributes)
        let signup = NSMutableAttributedString(string: SecondText, attributes: signupAttributes)

        let combination = NSMutableAttributedString()

        combination.append(account)
        combination.append(signup)
        
        self.attributedText = combination
    }
    
    func setHTMLFromString(text: String) {
        let font = UIFont.RubikRegular(ofSize: GetAppFontSize(size: 13.0))
        let modifiedFont = NSString(format:"<span style=\"font-family: \(font.fontName); font-size: \(font.pointSize)\">%@</span>" as NSString, text)
        
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: String.Encoding.unicode.rawValue, allowLossyConversion: true)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        self.attributedText = attrStr
    }
    
    func setHomeHeaderAttributedTextLable(firstText : String,SecondText :String) {

        let accountAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.whitecolor, NSAttributedString.Key.font: UIFont.RubikRegular(ofSize: GetAppFontSize(size: 25.0))]
        let signupAttributes = [NSAttributedString.Key.foregroundColor: UIColor.CustomColor.whitecolor, NSAttributedString.Key.font: UIFont.RubikSemiBold(ofSize: GetAppFontSize(size: 25.0))]

        let account = NSMutableAttributedString(string: firstText, attributes: accountAttributes)
        let signup = NSMutableAttributedString(string: SecondText, attributes: signupAttributes)

        let combination = NSMutableAttributedString()

        combination.append(account)
        combination.append(signup)
        
        self.attributedText = combination
    }
}
