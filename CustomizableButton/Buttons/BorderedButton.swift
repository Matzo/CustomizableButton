//
//  BorderedButton.swift
//  CustomizableButton
//
//  Created by Matsuo Keisuke on 4/17/15.
//  Copyright (c) 2015 Keisuke Matsuo. All rights reserved.
//

import UIKit

class BorderedButton: CustomizableButton {
    override func setupConfiguration() {
        super.setupConfiguration()
        
        self.conf.normal.shape = .Circle
        self.conf.normal.titleColor = UIColor.whiteColor()
        self.conf.normal.backgroundColor = UIColor(red: 0.29, green: 0.45, blue: 0.69, alpha: 1.0)
        self.conf.normal.borderWidth = 1.0
        self.conf.normal.borderColor = self.conf.normal.backgroundColor?.cb_darkenColor()
        self.conf.normal.cornerRadius = 4.0
        
        self.conf.selectedDisabled.borderWidth = 0.0
        self.conf.normal.image = UIColor.whiteColor().image(CGSizeMake(18.0, 18.0))
        
        let padding:CGFloat = 10
        self.contentEdgeInsets = UIEdgeInsetsMake(padding, padding, padding, padding)
    }
    
}
