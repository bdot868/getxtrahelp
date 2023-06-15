//
//  UIView+Layer.swift
//  Momentor
//
//  Created by mac on 16/01/2020.
//  Copyright © 2019 Differenzsystem Pvt. LTD. All rights reserved.
//

import UIKit

extension UIView {
    
    @discardableResult func borderWidth(_ width: CGFloat) -> Self {
        layer.borderWidth = width
        layer.masksToBounds = true
        
        return self
    }
    
    @discardableResult func borderColor(_ color: UIColor = .black) -> Self {
        layer.borderColor = color.cgColor
        
        return self
    }
    
    @discardableResult func removeBorder() -> Self {
        return borderColor(.clear)
            .borderWidth(0)
    }
    
    @discardableResult func cornerRadius(_ radius: CGFloat) -> Self {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        
        return self
    }
    
    @discardableResult func roundSides() -> Self {
        return cornerRadius(bounds.height / 2.0)
    }
    
    @discardableResult func roundedCornerRadius() -> Self {
        return cornerRadius(min(bounds.height, bounds.width) / 2.0)
    }
   
    
    
    @discardableResult func shadowColor(_ color: UIColor) -> Self {
        layer.shadowColor = color.cgColor
        
        return self
    }
    
    @discardableResult func shadowOffset(_ offset: CGSize) -> Self {
        layer.shadowOffset = offset
        
        return self
    }
    
    @discardableResult func shadowOpacity(_ opacity: Float) -> Self {
        layer.shadowOpacity = opacity
        
        return self
    }
    
    @discardableResult func shadowRadius(_ radius: CGFloat) -> Self {
        layer.shadowRadius = radius
        
        return self
    }
    
    @discardableResult func roundCorners(_ corners: UIRectCorner,
                                         radius: CGFloat) -> Self {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
        
        return self
    }
    
    @discardableResult func shadow(_ color: UIColor = .black,
                                   radius: CGFloat = 3,
                                   offset: CGSize = .zero,
                                   opacity: Float = 0.5) -> Self {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
        
        return self
    }
    
    /**
     This method is used to give size constraints custom view of navigation item.
     - Parameter size: Size of view.
     */
    func applyNavBarConstraints(with size: CGSize) {
        let widthConstraint = self.widthAnchor.constraint(equalToConstant: size.width)
        let heightConstraint = self.heightAnchor.constraint(equalToConstant: size.height)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
    }
    
   
    /**
     This method is used to show shadow.
     - Parameters:
     - color: Color of shadow
     - opacity: Opacity of shadow
     - offset: Shadow offset
     - radius: Shadow radius
     */
    func showShadow(with color: UIColor = .gray, opacity: Float = 1.0, offset: CGSize = CGSize(width: 0, height: 1), radius : CGFloat = 1.0) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    
    /**
     This method is used to show shadow to all side of view.
     - Parameters:
     - color: Color of shadow
     - opacity: Opacity of shadow
     */
    func showShadowToAllSide(with color: UIColor = .black, opacity: Float = 1.0) {
        let shadowSize : CGFloat = 5.0
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: self.frame.size.width + shadowSize,
                                                   height: self.frame.size.height + shadowSize))
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = opacity
        self.layer.shadowPath = shadowPath.cgPath
    }
    
    /**
     This method is used to remove shadow.
     */
    func removeShadow() {
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOpacity = 0
        layer.masksToBounds = false
    }
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func createDottedLine(width: CGFloat, color: CGColor) {
       let caShapeLayer = CAShapeLayer()
       caShapeLayer.strokeColor = color
       caShapeLayer.lineWidth = width
       caShapeLayer.lineDashPattern = [2,3]
       let cgPath = CGMutablePath()
       let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: self.frame.width, y: 0)]
       cgPath.addLines(between: cgPoint)
       caShapeLayer.path = cgPath
       layer.addSublayer(caShapeLayer)
    }
    
    func addDashedBorder() {
        let color = UIColor.black.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor//UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [4,4]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 0).cgPath
        self.layer.masksToBounds = false
        self.layer.addSublayer(shapeLayer)
    }
    
    // Top Anchor
    var safeAreaTopAnchor: NSLayoutYAxisAnchor {
      if #available(iOS 11.0, *) {
        return self.safeAreaLayoutGuide.topAnchor
      } else {
        return self.topAnchor
      }
    }

    // Bottom Anchor
    var safeAreaBottomAnchor: NSLayoutYAxisAnchor {
      if #available(iOS 11.0, *) {
        return self.safeAreaLayoutGuide.bottomAnchor
      } else {
        return self.bottomAnchor
      }
    }

    // Left Anchor
    var safeAreaLeftAnchor: NSLayoutXAxisAnchor {
      if #available(iOS 11.0, *) {
        return self.safeAreaLayoutGuide.leftAnchor
      } else {
        return self.leftAnchor
      }
    }

    // Right Anchor
    var safeAreaRightAnchor: NSLayoutXAxisAnchor {
      if #available(iOS 11.0, *) {
        return self.safeAreaLayoutGuide.rightAnchor
      } else {
        return self.rightAnchor
      }
    }
    
    /**
     This method is used to set Corner Radiuse.
     - Parameters:
     - borderWidth: set border Width
     - borderColor: set border Color
     - cornerRadius: set corner radius
     */
    func setCornerRadius(withBorder borderWidth: CGFloat, borderColor: UIColor , cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.clipsToBounds = true
    }
}

