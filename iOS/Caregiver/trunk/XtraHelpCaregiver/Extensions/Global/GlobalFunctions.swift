//
//  GlobalFunctions.swift
//  Momentor
//
//  Created by mac on 16/01/2020.
//  Copyright © 2019 Differenzsystem Pvt. LTD. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
func executeBackground<T>(_ block: @escaping () -> (T?), notifyMain completion: @escaping ((_: T?) -> ())) {
    DispatchQueue.global(qos: .background).async {
        let result: T? = block()
        DispatchQueue.main.async {
            completion(result)
        }
    }
}

func delay(seconds: Double, execute: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: execute)
}

func concat(_ strings: [String?], separator: String = " ") -> String? {
    let filtered = strings.compactMap({ $0 })
    guard !filtered.isEmpty else { return nil }
    return filtered.joined(separator: separator)
}

func isEmptyString(_ string: String?) -> Bool {
    guard let string = string else { return true }
    return string.isEmpty
}

func saveValueInNSUserDefaults(_ value:AnyObject?, forKey key:String) {
    UserDefaults.standard.set(value, forKey: key)
    
    UserDefaults.standard.synchronize()
}

func getValueFromNSUserDefaults(key:String) -> Any? {
    let val =  UserDefaults.standard.value(forKey: key)
    return val
}
func getImageFileUrl(image: UIImage) -> NSDictionary {
    //let finalURL: URL?
    let imageData = image.pngData()
    let paths: [Any] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory: String? = (paths[0] as? String)
    let timestamp = String(format: "%.f", Date().timeIntervalSince1970)
    let imagePathProfile = URL(fileURLWithPath: documentsDirectory!).appendingPathComponent("image\(timestamp).png")
    
    do {
        try imageData?.write(to: imagePathProfile, options: .atomic)
        print("saved")
        
        let dict: NSDictionary = [FileData.FILE_NAME: "image\(timestamp).png", FileData.FILE_MIME_TYPE: FileData.MIME_JPG, FileData.FILE_URL: imagePathProfile, FileData.FILE_DATA: imageData! as Data, FileData.FILE_ATTACHMENTMESSAGE_KEY: FileData.FILE_ATTACHMENTMESSGE_IMAGE]
        
        return dict
    } catch {
        print(error)
        print("not saved")
        return [:]
    }
    
}

func convertVideoToLowQuailty(withInputURL inputURL: URL?, outputURL: URL?, handler: @escaping (AVAssetExportSession?) -> Void) {
    if let outputURL = outputURL {
        try? FileManager.default.removeItem(at: outputURL)
    }
    var asset: AVURLAsset? = nil
    if let inputURL = inputURL {
        asset = AVURLAsset(url: inputURL, options: nil)
    }
    var exportSession: AVAssetExportSession? = nil
    if let asset = asset {
        exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality)
    }
    exportSession?.outputURL = outputURL
    exportSession?.outputFileType = .mov
    exportSession?.exportAsynchronously(completionHandler: {
        handler(exportSession)
    })    
}

func addNoDataLable(strMessage: String) -> UILabel
{
    let noDataLabel = UILabel(frame:CGRect(x: 10, y: 50, width: ScreenSize.SCREEN_WIDTH - 20, height: ScreenSize.SCREEN_HEIGHT - 100))
    noDataLabel.text = strMessage
    noDataLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    noDataLabel.textAlignment = .center
    noDataLabel.numberOfLines = 0
    return noDataLabel
}

func getImageHightWithScale(height:CGFloat,width:CGFloat) -> CGFloat {
    if height > 450 {
        return 430
    }
    else {
        return height
    }
}
func format(with mask: String, phone: String) -> String {
    let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    var result = ""
    var index = numbers.startIndex // numbers iterator

    // iterate over the mask characters until the iterator of numbers ends
    for ch in mask where index < numbers.endIndex {
        if ch == "X" {
            // mask requires a number in this place, so take the next one
            result.append(numbers[index])

            // move numbers iterator to the next index
            index = numbers.index(after: index)

        } else {
            result.append(ch) // just append a mask character
        }
    }
    return result
}

// MARK:-
@IBDesignable
extension UIView {
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func roundCornersTest(corners: UIRectCorner, radius: CGFloat) {
         /*let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         layer.mask = mask*/
        
        if #available(iOS 11.0, *) {
            self.clipsToBounds = false
            self.maskToBounds = true
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            let rectShape = CAShapeLayer()
            rectShape.bounds = self.frame
            rectShape.position = self.center
            rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
            self.layer.mask = rectShape
        }
    }
    
    @IBInspectable
    /// Should the corner be as circle
    public var circleCorner: Bool {
        get {
            return min(bounds.size.height, bounds.size.width) / 2 == cornerRadius
        }
        set {
            cornerRadius = newValue ? min(bounds.size.height, bounds.size.width) / 2 : cornerRadius
        }
    }
    
    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = circleCorner ? min(bounds.size.height, bounds.size.width) / 2 : newValue
            //abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    
    @IBInspectable
    /// Border color of view; also inspectable from Storyboard.
    public var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            layer.borderColor = color.cgColor
        }
    }
    
    @IBInspectable
    /// Border width of view; also inspectable from Storyboard.
    public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    /// Shadow color of view; also inspectable from Storyboard.
    public var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    /// Shadow offset of view; also inspectable from Storyboard.
    public var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    /// Shadow opacity of view; also inspectable from Storyboard.
    public var shadowOpacity: Double {
        get {
            return Double(layer.shadowOpacity)
        }
        set {
            layer.shadowOpacity = Float(newValue)
        }
    }
    
    @IBInspectable
    /// Shadow radius of view; also inspectable from Storyboard.
    public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    /// Shadow path of view; also inspectable from Storyboard.
    public var shadowPath: CGPath? {
        get {
            return layer.shadowPath
        }
        set {
            layer.shadowPath = newValue
        }
    }
    
    @IBInspectable
    /// Should shadow rasterize of view; also inspectable from Storyboard.
    /// cache the rendered shadow so that it doesn't need to be redrawn
    public var shadowShouldRasterize: Bool {
        get {
            return layer.shouldRasterize
        }
        set {
            layer.shouldRasterize = newValue
        }
    }
    
    @IBInspectable
    /// Should shadow rasterize of view; also inspectable from Storyboard.
    /// cache the rendered shadow so that it doesn't need to be redrawn
    public var shadowRasterizationScale: CGFloat {
        get {
            return layer.rasterizationScale
        }
        set {
            layer.rasterizationScale = newValue
        }
    }
    
    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    public var maskToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
    
    // Drop Shadow to UIView
    func dropShadow(shadowWidth: Int, shadowHeight: Int, color: UIColor = UIColor.black, opacity: Float = 0.5) {
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: shadowWidth, height: shadowHeight)
        self.layer.shadowRadius = 2
    }
    
}

// MARK: - UserDefaults's Extension

extension UserDefaults {
    class var isUserLogin: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKey.kIsLoggedIn)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.kIsLoggedIn)
        }
    }
    
    class var incognitoModeCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKey.kIncognitoCount)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.kIncognitoCount)
        }
    }
    class var incognitoModeDate: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKey.kIncognitoDate) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.kIncognitoDate)
        }
    }
    class var onChatUserID: UInt {
        get {
            return UInt(uint(UserDefaults.standard.integer(forKey: UserDefaultsKey.kUserChatID)))
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.kUserChatID)
        }
    }
    class var onFetchUserFullName: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKey.kUserFullName) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.kUserFullName)
        }
    }
    
    class var setDeviceToken: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKey.kUserDeviceToken) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.kUserDeviceToken)
        }
    }
    
    class var selectedLanguageCode: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKey.kSelectedLanguageCode) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.kSelectedLanguageCode)
        }
    }
    
    /*class var selectedLanguageAPICode: String {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKey.kSelectedLanguageCode) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.kSelectedLanguageCode)
        }
    }*/
}

extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element {
        return reduce(.zero, +)
    }
}

extension Double {
    
    func convertDoubletoString(digits : Int) -> String {
        let num = self
        return String(format: "%.\(digits)f", num)
    }
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        /*print("\(self * divisor)")
        print("\(self * divisor.rounded())")
        print("\(self * divisor.rounded() / divisor)")*/
        return (self * divisor).rounded() / divisor
    }
    
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
}

extension UIScrollView {
   func scrollToBottom(animated: Bool) {
     if self.contentSize.height < self.bounds.size.height { return }
     let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
     self.setContentOffset(bottomOffset, animated: animated)
  }
}

extension String {
    
    func decodingEmoji() -> String {
        let data = self.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII) ?? self
    }
    
    func encodindEmoji() -> String {
        let data = self.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    
    func isValidString() -> Bool {
        return self.removeSpaceAndNewLine().isEmpty
    }
    
    func removeSpaceAndNewLine() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
    /**
     This method is used to  get the width of string.
     - Parameter font : UIFont of the string.
     - Returns: CGFloat - width of the string
     */
    func textWidth(font: UIFont?) -> CGFloat {
        let attributes = font != nil ? [NSAttributedString.Key.font: font] : [:]
        return self.size(withAttributes: attributes as [NSAttributedString.Key : Any]).width
    }
    
    var doubleValue: Double {
        return Double(self) ?? 0
    }
    
    func toDouble() -> Double? {
            return NumberFormatter().number(from: self)?.doubleValue
        }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    public var trimWhiteSpace: String {
        get {
            return self.trimmingCharacters(in: .whitespaces)
        }
    }
    
    /**
     This method is used to set attributed placeholder of textfiled.
     - Parameters:
     - range: Range of string
     - string: String that needs to replace in range
     */
    func replacingCharacters(in range: NSRange, with string: String) -> String {
        let newRange = self.index(self.startIndex, offsetBy: range.lowerBound)..<self.index(self.startIndex, offsetBy: range.upperBound)
        return self.replacingCharacters(in: newRange, with: string)
    }
    
    func getDateFromString(format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self) ?? Date()
    }
    
    func getUTCToLocalDateFromString(format: String,conevertString : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        let utcdate = dateFormatter.date(from: self) ?? Date()
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.abbreviation() ?? "GMT")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = conevertString
        print(dateFormatter.string(from: utcdate))
        
        return dateFormatter.string(from: utcdate)
    }
    
    func getUTCToLocalDatePastYearFromString(format: String,conevertString : String,convertyearstr : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        let utcdate = dateFormatter.date(from: self) ?? Date()
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.abbreviation() ?? "GMT")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = conevertString
        print(dateFormatter.string(from: utcdate))
        
        var strconvertdate = dateFormatter.string(from: utcdate)
        
        let cyear : Int = Date().getCurrentYear()
        let serveryear = utcdate.getCurrentYear()
        
        if cyear == serveryear {
            dateFormatter.dateFormat = convertyearstr
            strconvertdate = dateFormatter.string(from: utcdate)
        }
        
        return strconvertdate
    }
    
   
    func getStringToDateToStringToDate(firstformat: String,secondformat: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = firstformat
        let fdate = dateFormatter.date(from: self) ?? Date()
        let strfdate = fdate.getFormattedString(format: secondformat)
        dateFormatter.dateFormat = secondformat
        return dateFormatter.date(from: strfdate) ?? Date()
    }
    
    func getFormmattedDateFromString(format: String) -> String {
        let date = self.getDateFromString(format: format)
        return date.getFormattedString(format: format)
    }

    /**
     This method is used to generate base64 string.
     */
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    /**
     This method is used to validate email field.
     - Returns: Return boolen value to indicate email is valid or not
     */
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+\\.[A-Za-z]{1,}(\\.[A-Za-z]{1,}){0,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidAlphNumericString() -> Bool {
        let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789 ")
        return self.rangeOfCharacter(from: set.inverted) == nil
    }
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    /**
    This method is used to localize String Key
    */
    func localized(comment: String = "") -> String {
        return LanguageManager.shared.bundle?.localizedString(forKey: self, value: comment, table: nil) ?? ""
    }
    
    func convertStringToDictionary() -> [String:AnyObject]? {
        if let data = self.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    var removeSpecialCharsFromString: String {
            let okayChars = Set("0123456789")
            return self.filter {okayChars.contains($0) }
        }
}

//MARK: - UIApplication Extension
extension UIApplication {
    
    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

extension UIButton {
    /**
     This method is used to show shadow.
     - Parameters:
     - color: Color of shadow
     - opacity: Opacity of shadow
     - offset: Shadow offset
     - radius: Shadow radius
     */
    func addButtonShadow(with color: UIColor = .gray, opacity: Float = 1.0, offset: CGSize = CGSize(width: 0, height: 1), radius : CGFloat = 1.0) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = false
    }
}

extension UILabel{
    func resolveHashTags(){

        // turn string in to NSString
        if let nsText = self.text as NSString? {
            
            // this needs to be an array of NSString.  String does not work.
            let words:[NSString] = nsText.components(separatedBy: " ") as [NSString]
            
            // you can't set the font size in the storyboard anymore, since it gets overridden here.
            let attrs = [
                NSAttributedString.Key.font : UIFont.RubikRegular(ofSize: GetAppFontSize(size: 14.0)),
                NSAttributedString.Key.foregroundColor : UIColor.CustomColor.borderColor
            ]
            
            // you can staple URLs onto attributed strings
            let attrString = NSMutableAttributedString(string: nsText as String, attributes:attrs)
            
            // tag each word if it has a hashtag
            for word in words {
                
                // found a word that is prepended by a hashtag!
                // homework for you: implement @mentions here too.
                if word.hasPrefix("#") {
                    
                    // a range is the character position, followed by how many characters are in the word.
                    // we need this because we staple the "href" to this range.
                    let matchRange:NSRange = nsText.range(of: word as String)
                    
                    // convert the word from NSString to String
                    // this allows us to call "dropFirst" to remove the hashtag
                    var stringifiedWord:String = word as String
                    
                    // drop the hashtag
                    stringifiedWord = String(stringifiedWord.dropFirst())
                    
                    // check to see if the hashtag has numbers.
                    // ribl is "#1" shouldn't be considered a hashtag.
                    let digits = NSCharacterSet.decimalDigits
                    
                    if let numbersExist = stringifiedWord.rangeOfCharacter(from: digits) {
                        // hashtag contains a number, like "#1"
                        // so don't make it clickable
                    } else {
                        // set a link for when the user clicks on this word.
                        // it's not enough to use the word "hash", but you need the url scheme syntax "hash://"
                        // note:  since it's a URL now, the color is set to the project's tint color
                        attrString.addAttribute(NSAttributedString.Key.link, value: "hash:\(stringifiedWord)", range: matchRange)
                    }
                    
                }
            }
            
            // we're used to textView.text
            // but here we use textView.attributedText
            // again, this will also wipe out any fonts and colors from the storyboard,
            // so remember to re-add them in the attrs dictionary above
            self.attributedText = attrString
        }
    }
}


extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        /*// Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
         let layoutManager = NSLayoutManager()
         let textContainer = NSTextContainer(size: CGSize.zero)
         let textStorage = NSTextStorage(attributedString: label.attributedText!)
         
         // Configure layoutManager and textStorage
         layoutManager.addTextContainer(textContainer)
         textStorage.addLayoutManager(layoutManager)
         
         // Configure textContainer
         textContainer.lineFragmentPadding = 0.0
         textContainer.lineBreakMode = label.lineBreakMode
         textContainer.maximumNumberOfLines = label.numberOfLines
         let labelSize = label.bounds.size
         textContainer.size = labelSize
         
         // Find the tapped character location and compare it to the specified range
         let locationOfTouchInLabel = self.location(in: label)
         let textBoundingBox = layoutManager.usedRect(for: textContainer)
         let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
         
         let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
         
         let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
         
         return NSLocationInRange(indexOfCharacter, targetRange)*/
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        /*let layoutManager = NSLayoutManager()
         let textContainer = NSTextContainer(size: CGSize.zero)
         let textStorage = NSTextStorage(attributedString: label.attributedText!)
         
         // Configure layoutManager and textStorage
         layoutManager.addTextContainer(textContainer)
         textStorage.addLayoutManager(layoutManager)
         
         // Configure textContainer
         textContainer.lineFragmentPadding = 0.0
         textContainer.lineBreakMode = label.lineBreakMode
         textContainer.maximumNumberOfLines = label.numberOfLines
         let labelSize = label.bounds.size
         textContainer.size = labelSize
         
         // Find the tapped character location and compare it to the specified range
         let locationOfTouchInLabel = self.location(in: label)
         let textBoundingBox = layoutManager.usedRect(for: textContainer)
         
         let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
         
         let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
         let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
         return NSLocationInRange(indexOfCharacter, targetRange)*/
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        /*let layoutManager = NSLayoutManager()
         let textContainer = NSTextContainer(size: CGSize.zero)
         let textStorage = NSTextStorage(attributedString: label.attributedText!)
         
         // Configure layoutManager and textStorage
         layoutManager.addTextContainer(textContainer)
         textStorage.addLayoutManager(layoutManager)
         
         // Configure textContainer
         textContainer.lineFragmentPadding = 0.0
         textContainer.lineBreakMode = label.lineBreakMode
         textContainer.maximumNumberOfLines = label.numberOfLines
         let labelSize = label.bounds.size
         textContainer.size = labelSize
         
         // Find the tapped character location and compare it to the specified range
         let locationOfTouchInLabel = self.location(in: label)
         let textBoundingBox = layoutManager.usedRect(for: textContainer)
         let textContainerOffset = CGPoint(
         x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
         y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
         )
         let locationOfTouchInTextContainer = CGPoint(
         x: locationOfTouchInLabel.x - textContainerOffset.x,
         y: locationOfTouchInLabel.y - textContainerOffset.y
         )
         let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
         
         return NSLocationInRange(indexOfCharacter, targetRange)*/
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}

extension UITextField {
    
    /**
     This method is used to show shadow.
     - Parameters:
     - color: Color of shadow
     - opacity: Opacity of shadow
     - offset: Shadow offset
     - radius: Shadow radius
     */
    func addTextFiledShadow(with color: UIColor = .gray, opacity: Float = 1.0, offset: CGSize = CGSize(width: 0, height: 1), radius : CGFloat = 1.0) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = false
    }
}
extension Array where Element: Equatable {
    func removingDuplicates() -> Array {
        return reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

//extension Array {
    
//}

//MARK: - Dictionary
extension Dictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: []) else {
            return nil
        }

        return String(data: theJSONData, encoding: .ascii)
    }
}

//MARK: - Date
extension Date {
    
    func dateFormatWithSuffix() -> String {
            return "dd\(self.daySuffix()) MMMM yyyy"
        }

        func daySuffix() -> String {
            let calendar = Calendar.current
            let components = (calendar as NSCalendar).components(.day, from: self)
            let dayOfMonth = components.day
            switch dayOfMonth {
            case 1, 21, 31:
                return "st"
            case 2, 22:
                return "nd"
            case 3, 23:
                return "rd"
            default:
                return "th"
            }
        }
    
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
            return calendar.dateComponents(Set(components), from: self)
        }

        func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
            return calendar.component(component, from: self)
        }
    
    func rounded(minutes: TimeInterval, rounding: DateRoundingType = .round) -> Date {
        return rounded(seconds: minutes * 60, rounding: rounding)
    }
    
    func rounded(seconds: TimeInterval, rounding: DateRoundingType = .round) -> Date {
        var roundedInterval: TimeInterval = 0
        switch rounding  {
        case .round:
            roundedInterval = (timeIntervalSinceReferenceDate / seconds).rounded() * seconds
        case .ceil:
            roundedInterval = ceil(timeIntervalSinceReferenceDate / seconds) * seconds
        case .floor:
            roundedInterval = floor(timeIntervalSinceReferenceDate / seconds) * seconds
        }
        return Date(timeIntervalSinceReferenceDate: roundedInterval)
    }
    
    func ConvertDateTo12HoursDate(formate : String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        let currenttstrdate = formatter.string(from: self)
        let currenttdate = formatter.date(from: currenttstrdate)
        return currenttdate
    }
    
    /**
     This method is used to get string of time according to system time formate (12/24 hour).
     */
    func getSystemTimeString() -> String {
        
        let dateFormatter = DateFormatter()
        let locale = NSLocale.current
        
        if let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale), formatter.contains("a") {
            dateFormatter.dateFormat = AppConstant.DateFormat.k_hh_mm_a
        } else {
            dateFormatter.dateFormat = AppConstant.DateFormat.k_HH_mm
        }
        let timeString = dateFormatter.string(from: self)
        
        return timeString
    }
    
    /**
     This method is used to get string of time according to system time formate (12/24 hour).
     */
    func get24HoursTimeString() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AppConstant.DateFormat.k_HH_mm
        let timeString = dateFormatter.string(from: self)
        
        return timeString
    }
    
    /**
     This method is used to get string of time according to system time formate (12/24 hour).
     */
    func get12HoursTimeString() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = AppConstant.DateFormat.k_hh_mm_a
        let timeString = dateFormatter.string(from: self)
        
        return timeString
    }
    
    /**
     This method is used to get string of time.
     */
    func getTimeString(inFormate : String) -> String {
        
        //Conversion into 24 hours formate required in API
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inFormate
        let timeString = dateFormatter.string(from: self)
        return timeString
    }
    
    func removeTimeStampFromDate() -> Date {
        
        var dateComponents = Calendar.current.dateComponents([.year,.month,.day], from: self)
        print(TimeZone.current.abbreviation() ?? "")
        dateComponents.timeZone = TimeZone(identifier: TimeZone.current.abbreviation() ?? "GMT")
        dateComponents.minute = 0
        dateComponents.hour = 0
        dateComponents.second = 0
        
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
    
    func startOfMonth() -> Date? {
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month, .hour], from: Calendar.current.startOfDay(for: self))
        return Calendar.current.date(from: comp)!
    }
    
    func endOfMonth() -> Date? {
        var comp: DateComponents = Calendar.current.dateComponents([.month, .day, .hour], from: Calendar.current.startOfDay(for: self))
        comp.month = 1
        comp.day = -1
        return Calendar.current.date(byAdding: comp, to: self.startOfMonth()!)
    }
    
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    func getDayOfWeek()->Int? {
        
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: self)
        let weekDay = myComponents.weekday
        return weekDay
    }
    
    func getCurrentYear() -> Int {
        return Calendar.current.component(.year, from: self)
    }
    
    func getDayFromDate() -> Int {
        return Calendar.current.component(.day, from: self)
    }
    
    func getMonthFromDate() -> Int {
        return Calendar.current.component(.month, from: self)
    }
    
    func getYearFromDate() -> Int {
        return Calendar.current.component(.year, from: self)
    }
    
    /**
     get Formatted String UTC Time Zone Date String
     - Parameter format: formatter string
     - Returns: returns date string.
     */
    func getFormattedString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
    
    func calculateYearMonthDuration(from date: Date) -> String {
        let dc = Calendar.current.dateComponents([.year,.month], from: date, to: self)
        if dc.year == 0 {
            return "\(dc.month ?? 0) Months"
        } else {
            if dc.month == 0 {
                return "\(dc.year ?? 0) Years"
            }
            return "\(dc.year ?? 0) Years \(dc.month ?? 0) Months"
        }
    }
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    
}
extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}

extension Int {

    func formatUsingAbbrevation () -> String {
        let numFormatter = NumberFormatter()

        typealias Abbrevation = (threshold:Double, divisor:Double, suffix:String)
        let abbreviations:[Abbrevation] = [(0, 1, ""),
                                           (100, 1000.0, "K"),
                                           (100_000.0, 1_000_000.0, "M"),
                                           (100_000_000.0, 1_000_000_000.0, "B")]
                                           // you can add more !
        let startValue = Double (abs(self))
        let abbreviation:Abbrevation = {
            var prevAbbreviation = abbreviations[0]
            for tmpAbbreviation in abbreviations {
                if (startValue < tmpAbbreviation.threshold) {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        } ()

        let value = Double(self) / abbreviation.divisor
        numFormatter.positiveSuffix = abbreviation.suffix
        numFormatter.negativeSuffix = abbreviation.suffix
        numFormatter.allowsFloats = true
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 1

        //return numFormatter.stringFromNumber(NSNumber (double:value))!
        return numFormatter.string(from: NSNumber(value: value)) ?? "0"
    }

}

extension NSAttributedString {
    func attributedStringWithResizedImages(with maxWidth: CGFloat) -> NSAttributedString {
        let text = NSMutableAttributedString(attributedString: self)
        text.enumerateAttribute(NSAttributedString.Key.attachment, in: NSMakeRange(0, text.length), options: .init(rawValue: 0), using: { (value, range, stop) in
            if let attachement = value as? NSTextAttachment {
                if let image = attachement.image(forBounds: attachement.bounds, textContainer: NSTextContainer(), characterIndex: range.location) {
                    if image.size.width > maxWidth {
                        let newImage = image.resizeImage(scale: maxWidth/image.size.width)
                        let newAttribut = NSTextAttachment()
                        newAttribut.image = newImage
                        text.addAttribute(NSAttributedString.Key.attachment, value: newAttribut, range: range)
                    }
                }
            }
        })
        return text
    }
}

/*extension PageControl.Dot {

    static var customStyle1: PageControl.Dot {
        let regularStyle = PageControl.Dot.Style(
            radius: 5,
            fillColor:#colorLiteral(red: 0.8823529412, green: 0.8117647059, blue: 1, alpha: 1),
            strokeColor: #colorLiteral(red: 0.8823529412, green: 0.8117647059, blue: 1, alpha: 1),
            strokeWidth: 0
        )

        let activeStyle = PageControl.Dot.Style(
            radius: 12,
            fillColor: #colorLiteral(red: 0.4352941176, green: 0.1529411765, blue: 1, alpha: 1),
            strokeColor:#colorLiteral(red: 0.8823529412, green: 0.8117647059, blue: 1, alpha: 1),
            strokeWidth: 6
        )

        return PageControl.Dot(
            regularStyle: regularStyle,
            activeStyle: activeStyle
        )
    }
}*/

extension AVAsset {

    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
}

@objc class ClosureSleeve: NSObject {
    let closure: ()->()
    
    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, "[\(arc4random())]", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
