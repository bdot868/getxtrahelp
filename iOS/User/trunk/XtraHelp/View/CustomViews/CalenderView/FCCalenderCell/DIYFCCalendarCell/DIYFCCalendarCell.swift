//
//  DIYFCCalendarCell.swift
//  RecordingStudio
//
//  Created by mac on 23/01/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import FSCalendar
enum SelectionType : Int {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
    case selectPrevDate
}


class DIYFCCalendarCell: FSCalendarCell {
    
    weak var circleImageView: UIImageView!
    
    weak var selectionLayer: CAShapeLayer!
    weak var startselectionLayer: CAShapeLayer!
    
    weak var prevSelectionLayer: CAShapeLayer!
    weak var prevStartselectionLayer: CAShapeLayer!
    
    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init!(coder aDecoder: NSCoder!)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let datefirstselectionLayer = CAShapeLayer()
        datefirstselectionLayer.fillColor = UIColor.CustomColor.appColor.withAlphaComponent(0.5).cgColor
        datefirstselectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(datefirstselectionLayer, below: self.titleLabel.layer)
        self.startselectionLayer = datefirstselectionLayer
        
        
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = UIColor.CustomColor.appColor.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel.layer)
        self.selectionLayer = selectionLayer
        
        
        /*let prevselectionLayer = CAShapeLayer()
        prevselectionLayer.fillColor = UIColor.CustomColor.prevCalendarLightColor.cgColor
        prevselectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(prevselectionLayer, below: self.titleLabel!.layer)
        self.prevSelectionLayer = selectionLayer
        
        let prevdatefirstselectionLayer = CAShapeLayer()
        prevdatefirstselectionLayer.fillColor = UIColor.lightGray.cgColor
        prevdatefirstselectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(prevdatefirstselectionLayer, below: self.titleLabel!.layer)
        self.prevStartselectionLayer = prevdatefirstselectionLayer*/
        
        self.shapeLayer.isHidden = true
        
        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.clear
        self.backgroundView = view;
        
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
        self.selectionLayer.frame = self.contentView.bounds
        
        self.startselectionLayer.frame = self.contentView.bounds
        
        if selectionType == .middle {
            self.selectionLayer.path = UIBezierPath(rect: self.selectionLayer.bounds).cgPath
            
            //self.startselectionLayer.path = UIBezierPath(rect: self.startselectionLayer.bounds).cgPath
            
            self.selectionLayer.path = UIBezierPath(rect: CGRect (x: 0, y: -2, width:  self.selectionLayer.frame.width, height: self.selectionLayer.frame.height)).cgPath
            //Hinali
            //self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topLeft, .bottomLeft, .topRight, .bottomRight], cornerRadii: CGSize(width: 0, height: 0)).cgPath
            //self.titleLabel.textColor = .white
        }
        else if selectionType == .leftBorder {
            //self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
            //self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topLeft, .bottomLeft, .topRight, .bottomRight], cornerRadii: CGSize(width: self.selectionLayer.frame.width/2, height: self.selectionLayer.frame.height/2)).cgPath
            
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: (self.contentView.frame.height / 2 - diameter / 2)-2, width: diameter, height: diameter)).cgPath
            
            let startdiameter: CGFloat = min(self.startselectionLayer.frame.height, self.startselectionLayer.frame.width)
            
            self.startselectionLayer.path = UIBezierPath(roundedRect: CGRect(x: self.contentView.frame.width / 2 - startdiameter / 2, y: (self.contentView.frame.height / 2 - startdiameter / 2)-2, width: self.contentView.frame.width, height: self.startselectionLayer.frame.height), byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: startdiameter, height: startdiameter)).cgPath
            //self.startselectionLayer.path = UIBezierPath(roundedRect: self.startselectionLayer.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.startselectionLayer.frame.width/2, height: self.startselectionLayer.frame.height/2)).cgPath
            //self.titleLabel.textColor = .white
        }
        else if selectionType == .rightBorder {
            //self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
            // self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topRight, .bottomRight,.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.selectionLayer.frame.width/2, height: self.selectionLayer.frame.height/2)).cgPath
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: (self.contentView.frame.height / 2 - diameter / 2)-2, width: diameter, height: diameter)).cgPath
            
            let startdiameter: CGFloat = min(self.startselectionLayer.frame.height, self.startselectionLayer.frame.width)
            //self.startselectionLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: (self.contentView.frame.height / 2 - startdiameter / 2) - 2, width: startdiameter+5, height: self.startselectionLayer.frame.height), byRoundingCorners: [.bottomRight,.topRight], cornerRadii: CGSize(width: startdiameter, height: startdiameter)).cgPath
            
            
            self.startselectionLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: (self.contentView.frame.height / 2 - startdiameter / 2) - 2, width: DeviceType.IS_PAD ? ((self.contentView.frame.width) - (startdiameter+5)) : (startdiameter+5), height: self.startselectionLayer.frame.height), byRoundingCorners: [.bottomRight,.topRight], cornerRadii: CGSize(width: startdiameter, height: startdiameter)).cgPath
            //self.titleLabel.textColor = .white
        }
        else if selectionType == .single {
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: (self.contentView.frame.height / 2 - diameter / 2) - 2, width: diameter, height: diameter)).cgPath
            //self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
            //self.titleLabel.textColor = .white
        } /*else if selectionType == .selectPrevDate {
            //let diameter: CGFloat = min(self.prevSelectionLayer.frame.height, self.prevSelectionLayer.frame.width)
            //self.prevSelectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: (self.contentView.frame.height / 2 - diameter / 2) - 2, width: diameter, height: diameter)).cgPath
            //self.titleLabel.textColor = UIColor.CustomColor.appColor
        }*/
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        // Override the build-in appearance configuration
        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
            if self.titleLabel != nil {
                self.titleLabel.textColor = UIColor.lightGray
            }
            
        }
    }
    
}
