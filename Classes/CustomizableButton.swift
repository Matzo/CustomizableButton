//
//  CustomizableButton.swift
//  CustomizableButton
//
//  Created by Matsuo Keisuke on 4/17/15.
//  Copyright (c) 2015 Keisuke Matsuo. All rights reserved.
//

import UIKit

class CustomizableButton: UIButton {
    var conf: Config = Config()
    
    override var enabled: Bool {
        didSet {
            self.customizeDynamic(self.state)
        }
    }
    override var selected: Bool {
        didSet {
            self.customizeDynamic(self.state)
        }
    }
    override var highlighted: Bool {
        didSet {
            self.customizeDynamic(self.state)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.customizeDynamic(self.state)
    }
    
    func initialize() {
        self.setupConfiguration()
        self.setupByIBInspectable()
        self.customize()
        self.customizeDynamic(self.state)
    }
    
    /**
     * initialize config by coding here
     */
    func setupConfiguration() {
    }
    /**
     * setupByIBInspectable() will called before customize()
     * you should update conf parameters in setupByIBInspectable()
     */
    func setupByIBInspectable() {
    }
    func customize() {
        
        let stateList = [
            UIControlState.Normal,
            UIControlState.Selected,
            UIControlState.Selected | UIControlState.Highlighted,
            UIControlState.Selected | UIControlState.Disabled,
            UIControlState.Highlighted,
            UIControlState.Disabled
        ]
        for state in stateList {
            
            // title
            if let localizableKey = self.conf.forState(state).localizableTitle {
                self.setTitle(NSLocalizedString(localizableKey, comment: ""), forState: state)
            }
            if let titleColor = self.conf.forState(state).titleColor {
                self.setTitleColor(titleColor, forState: state)
            }
            
            // image
            if let image = self.conf.forState(state).image {
                self.setImage(image, forState: state)
            }
            
            // background image
            if let image = self.conf.forState(state).backgroundImage {
                self.setBackgroundImage(image.cb_stretchableImage(), forState: state)
            }
            
        }
        
    }
    func customizeDynamic(state:UIControlState) {
        if state == UIControlState.Disabled {
            
        }
        // background
        if let color = self.conf.forState(state).backgroundColor {
            self.backgroundColor = color
        } else {
            if let base = self.defaultForState(state,
                normal: self.conf.normal.backgroundColor,
                highlighted: self.conf.highlighted.backgroundColor,
                selected: self.conf.selected.backgroundColor,
                selectedHighlited: self.conf.selectedHiglighted.backgroundColor) {
                    self.backgroundColor = self.defaultEffectedColorForState(state, baseColor: base)
            }
        }
        
        // border
        if let borderWidth = self.conf.forState(state).borderWidth {
            self.layer.borderWidth = borderWidth
        } else {
            if let base = self.defaultForState(state,
                normal: self.conf.normal.borderWidth,
                highlighted: self.conf.highlighted.borderWidth,
                selected: self.conf.selected.borderWidth,
                selectedHighlited: self.conf.selectedHiglighted.borderWidth) {
                    self.layer.borderWidth = base
            }
        }
        if let borderColor = self.conf.forState(state).borderColor {
            self.layer.borderColor = borderColor.CGColor
        } else {
            if let base = self.defaultForState(state,
                normal: self.conf.normal.borderColor,
                highlighted: self.conf.highlighted.borderColor,
                selected: self.conf.selected.borderColor,
                selectedHighlited: self.conf.selectedHiglighted.borderColor) {
                    self.layer.borderColor = self.defaultEffectedColorForState(state, baseColor: base).CGColor
            }
        }
        
        // shape
        var shape = self.conf.forState(state).shape
        if shape == nil {
            shape = self.defaultForState(state,
                normal: self.conf.normal.shape,
                highlighted: self.conf.highlighted.shape,
                selected: self.conf.selected.shape,
                selectedHighlited: self.conf.selectedHiglighted.shape)
        }
        if shape != nil {
            switch shape! {
            case .Circle:
                self.layer.cornerRadius = min(self.frame.size.width, self.frame.size.height) * 0.5
            case .Round:
                if let radius = self.conf.forState(state).cornerRadius ?? self.conf.normal.cornerRadius {
                    self.layer.cornerRadius = radius
                } else {
                    if let radius = self.defaultForState(state,
                        normal: self.conf.normal.cornerRadius,
                        highlighted: self.conf.highlighted.cornerRadius,
                        selected: self.conf.selected.cornerRadius,
                        selectedHighlited: self.conf.selectedHiglighted.cornerRadius) {
                            self.layer.cornerRadius = radius
                    }
                }
            case .Rect:
                self.layer.cornerRadius = 0.0
            }
        }
        
        self.adjustImageTitleEdgeInsets()
    }
    
    func adjustImageTitleEdgeInsets() {
        // image and title margin
        if let title = self.titleForState(state), image = self.imageForState(state) {
            self.imageEdgeInsets.right = 1
            self.imageEdgeInsets.left = -1
            self.titleEdgeInsets.right = -3
            self.titleEdgeInsets.left = 3
        } else {
            self.imageEdgeInsets.right = 0
            self.imageEdgeInsets.left = 0
            self.titleEdgeInsets.right = 0
            self.titleEdgeInsets.left = 0
        }
    }
    
    func defaultForState<T>(state:UIControlState, normal:T?, highlighted:T?, selected:T?, selectedHighlited:T?) -> T? {
        if state == UIControlState.Normal {
            return nil
        } else if state == UIControlState.Highlighted {
            if normal != nil {
                return normal
            }
        } else if state == UIControlState.Selected {
            if normal != nil {
                return normal
            }
        } else if state == UIControlState.Disabled {
            if normal != nil {
                return normal
            }
        } else if state == UIControlState.Selected | UIControlState.Highlighted {
            if selected != nil {
                return selected
            } else if highlighted != nil {
                return highlighted
            } else if normal != nil {
                return normal
            }
        } else if state == UIControlState.Selected | UIControlState.Disabled {
            if selected != nil {
                return selected
            } else if normal != nil {
                return normal
            }
        }
        return nil
    }
    
    // effected color
    func defaultEffectedColorForState(state:UIControlState, baseColor:UIColor) -> UIColor {
        if state == UIControlState.Highlighted {
            return self.defaultHighlightedColor(baseColor)
        } else if state == UIControlState.Selected {
            return self.defaultSelectedColor(baseColor)
        } else if state == UIControlState.Disabled {
            return self.defaultDisabledColor(baseColor)
        } else if state == UIControlState.Selected | UIControlState.Highlighted {
            return self.defaultHighlightedColor(baseColor)
        } else if state == UIControlState.Selected | UIControlState.Disabled {
            return self.defaultDisabledColor(baseColor)
        }
        return baseColor
    }
    // MARK: - for override
    func defaultHighlightedColor(baseColor:UIColor) -> UIColor {
        return baseColor.cb_darkenColor()
    }
    func defaultSelectedColor(baseColor:UIColor) -> UIColor {
        return baseColor.cb_lightenColor()
    }
    func defaultDisabledColor(baseColor:UIColor) -> UIColor {
        return baseColor.cb_transparentedColor()
    }
}

struct Config {
    var normal: ButtonConfig = ButtonConfig()
    var highlighted: ButtonConfig = ButtonConfig()
    var selected: ButtonConfig = ButtonConfig()
    var selectedHiglighted: ButtonConfig = ButtonConfig()
    var selectedDisabled: ButtonConfig = ButtonConfig()
    var disabled: ButtonConfig = ButtonConfig()
    func forState(state:UIControlState) -> ButtonConfig {
        if state == UIControlState.Normal {
            return self.normal
        } else if state == UIControlState.Highlighted {
            return self.highlighted
        } else if state == UIControlState.Selected {
            return self.selected
        } else if state == UIControlState.Disabled {
            return self.disabled
        } else if state == UIControlState.Selected | UIControlState.Highlighted {
            return self.selectedHiglighted
        } else if state == UIControlState.Selected | UIControlState.Disabled {
            return self.selectedDisabled
        } else {
            return self.normal
        }
    }
}

enum Shape {
    case Circle, Round, Rect
}

class ButtonConfig {
    var borderColor:UIColor?
    var borderWidth:CGFloat?
    var shape:Shape?
    var cornerRadius:CGFloat?
    var image:UIImage?
    var imageSize:CGSize?
    var backgroundColor:UIColor?
    var backgroundImage:UIImage?
    var localizableTitle:String?
    var titleColor:UIColor?
}

extension UIColor {
    func cb_image() -> UIImage {
        return self.image(CGSizeMake(1.0, 1.0))
    }
    func image(size:CGSize) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, size.width, size.height)
        UIGraphicsBeginImageContext(rect.size)
        let c:CGContextRef = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(c, self.CGColor)
        CGContextFillRect(c, rect)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image
    }
    
    func cb_adjustedColor(hue hRatio:CGFloat = 1.0, saturation sRatio:CGFloat = 1.0, brightness bRatio:CGFloat = 1.0, alpha aRatio:CGFloat = 1.0) -> UIColor {
        var hue:CGFloat  = 0;
        var saturation:CGFloat = 0;
        var brightness:CGFloat = 0;
        var alpha:CGFloat = 0;
        
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            hue += (hRatio-1.0);
            hue = max(min(hue, 1.0), 0.0);
            saturation += (sRatio-1.0);
            saturation = max(min(saturation, 1.0), 0.0);
            brightness += (bRatio-1.0);
            brightness = max(min(brightness, 1.0), 0.0);
            alpha += (aRatio-1.0);
            alpha = max(min(alpha, 1.0), 0.0);
            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        }
        return self
    
    }

    func cb_darkenColor() -> UIColor {
        return self.cb_adjustedColor(brightness: 0.9)
    }
    func cb_lightenColor() -> UIColor {
        return self.cb_adjustedColor(brightness: 1.3)
    }
    func cb_transparentedColor() -> UIColor {
        return self.cb_adjustedColor(alpha: 0.2)
    }
}

extension UIImage {
    func cb_stretchableImage() -> UIImage {
        var halfWidth:CGFloat = floor(self.size.width * 0.5)
        var halfHeight:CGFloat = floor(self.size.height * 0.5)
        return self.resizableImageWithCapInsets(UIEdgeInsetsMake(halfHeight, halfWidth, halfHeight, halfWidth), resizingMode:UIImageResizingMode.Stretch)
    }
}