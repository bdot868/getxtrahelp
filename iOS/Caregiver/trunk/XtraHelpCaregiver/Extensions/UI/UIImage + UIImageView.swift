//
//  UIImage + UIImageView.swift
//  Momentor
//
//  Created by mac on 21/01/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
import ChameleonFramework
import UIKit
import SDWebImage
extension UIImage {
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
    
    func toBase64() -> String? {
        guard let imageData = self.pngData() else { return nil }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    func resizeImage(scale: CGFloat) -> UIImage {
        let newSize = CGSize(width: self.size.width*scale, height: self.size.height*scale)
        let rect = CGRect(origin: CGPoint.zero, size: newSize)

        UIGraphicsBeginImageContext(newSize)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}

extension UIImageView {
    /*func setImage(withUrl url: String, placeholderImage image: UIImage?, indicatorStyle: UIActivityIndicatorView.Style = .gray, isProgressive: Bool = false) {
        if isProgressive {
            self.sd_setImage(with: URL(string: url), placeholderImage: image, options: .lowPriority)
        }
        else {
            self.sd_imageIndicator?.startAnimatingIndicator()
            self.sd_setImage(with: URL(string: url), placeholderImage: image, options: .lowPriority, completed: nil)
        }
    }*/
    
    func setImage(withUrl url: String, placeholderImage image: UIImage = #imageLiteral(resourceName: "LogoColor"), indicatorStyle: UIActivityIndicatorView.Style = .gray, isProgressive: Bool = false,imageindicator : SDWebImageActivityIndicator = SDWebImageActivityIndicator.gray) {
        if !isProgressive {
            self.sd_setImage(with: URL(string: url), placeholderImage: image, options: .lowPriority)
        }
        else {
            self.sd_imageIndicator = imageindicator
            self.sd_imageIndicator?.startAnimatingIndicator()
            self.sd_setImage(with: URL(string: url), placeholderImage: image, options: .lowPriority, completed: nil)
        }
    }
    
    func setCompileImage(withUrl url: String, placeholderImage image: UIImage?, indicatorStyle: UIActivityIndicatorView.Style = .gray, isProgressive: Bool = false,imageindicator : SDWebImageActivityIndicator = SDWebImageActivityIndicator.gray) {
        if !isProgressive {
            self.sd_setImage(with: URL(string: url), placeholderImage: image, options: .lowPriority)
        }
        else {
            self.sd_imageIndicator = imageindicator
            self.sd_imageIndicator?.startAnimatingIndicator()
            self.sd_setImage(with: URL(string: url), placeholderImage: image, options: .lowPriority, completed: nil)
        }
    }
    
    /**
     This property is used to change Image Tintcolor.
     */
    func changeImageTintcolor(changeimage: UIImageView , imagename : String ,color : UIColor) {
        let imagenew = UIImage(named: imagename)?.withRenderingMode(.alwaysTemplate)
        changeimage.image = imagenew
        changeimage.tintColor = color
    }
}
