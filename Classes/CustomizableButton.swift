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
        self.customizeDynamic(UIControlState.Normal)
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
            
        }
        
    }
    func customizeDynamic(state:UIControlState) {
        // background
        if let backgroundColor = self.conf.forState(state).backgroundColor {
            self.backgroundColor = backgroundColor
        }
        
        // border
        if let borderWidth = self.conf.forState(state).borderWidth {
            self.layer.borderWidth = borderWidth
        }
        
        // shape
        if let shape = self.conf.forState(state).shape {
            switch shape {
            case .Circle:
                self.layer.cornerRadius = min(self.frame.size.width, self.frame.size.height) * 0.5
            case .Round:
                if let radius =  self.conf.forState(state).cornerRadius {
                    self.layer.cornerRadius = radius
                }
                return
            case .Rect:
                return
            }
        }
    }
    
    // MARK: - Utility Methods
    private func highlightedColor(baseColor:UIColor) -> UIColor {
        return baseColor.darkenColor()
    }
}

struct Config {
    var normal: ButtonConfig = ButtonConfig()
    var highlited: ButtonConfig = ButtonConfig()
    var selected: ButtonConfig = ButtonConfig()
    var selectedHiglighted: ButtonConfig = ButtonConfig()
    var selectedDisabled: ButtonConfig = ButtonConfig()
    var disabled: ButtonConfig = ButtonConfig()
    func forState(state:UIControlState) -> ButtonConfig {
        if state == UIControlState.Normal {
            return self.normal
        } else if state == UIControlState.Highlighted {
            return self.highlited
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
    var localizableTitle:String?
    var titleColor:UIColor?
}


extension UIColor {
    func image() -> UIImage {
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
    
    func colorChangedBrightness(ratio:CGFloat) -> UIColor {
        var hue:CGFloat  = 0;
        var saturation:CGFloat = 0;
        var brightness:CGFloat = 0;
        var alpha:CGFloat = 0;
        
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            brightness += (ratio-1.0);
            brightness = max(min(brightness, 1.0), 0.0);
            return UIColor(hue: hue, saturation: saturation, brightness: (brightness * ratio), alpha: alpha)
        }
        return self
    }
    func darkenColor() -> UIColor {
        return self.colorChangedBrightness(0.8)
    }
    func lightenColor() -> UIColor {
        return self.colorChangedBrightness(1.2)
    }
}
extension UIImage {
    func stretchableImage() -> UIImage {
        return self
    }
}