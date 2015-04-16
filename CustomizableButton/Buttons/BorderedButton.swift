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
        self.conf.normal.titleColor = UIColor.blackColor()
        self.conf.normal.backgroundColor = UIColor.lightGrayColor()
        self.conf.normal.borderColor = UIColor.blueColor()
        self.conf.normal.borderWidth = 2.0
        
        self.conf.selected.shape = .Circle
        self.conf.selected.borderWidth = 1.0
        self.conf.selected.backgroundColor = UIColor.greenColor()
        
        self.conf.highlited.borderWidth = 0.0
        self.conf.highlited.backgroundColor = UIColor.redColor()
        
        self.conf.selectedHiglighted.borderWidth = 0.0
        self.conf.selectedHiglighted.backgroundColor = UIColor.darkGrayColor()
        
        self.conf.normal.image = UIColor.yellowColor().image(CGSizeMake(28.0, 28.0))
        self.conf.highlited.image = UIColor.yellowColor().darkenColor().image(CGSizeMake(28.0, 28.0))
        self.conf.selected.image = UIColor(white: 0.5, alpha: 1.0).image(CGSizeMake(28.0, 28.0))
        self.conf.selectedHiglighted.image = UIColor(white: 0.5, alpha: 1.0).lightenColor().image(CGSizeMake(28.0, 28.0))
        
        self.contentEdgeInsets.top = 10.0
        self.contentEdgeInsets.bottom = 10.0
        self.contentEdgeInsets.left = 10.0
        self.contentEdgeInsets.right = 10.0
    }
}
