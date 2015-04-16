//
//  IconButton.swift
//  CustomizableButton
//
//  Created by Matsuo Keisuke on 4/17/15.
//  Copyright (c) 2015 Keisuke Matsuo. All rights reserved.
//

import UIKit

class IconButton: CustomizableButton {
    override func setupConfiguration() {
        super.setupConfiguration()
        
        self.conf.normal.titleColor = UIColor.blackColor()
        
        self.conf.normal.image = UIColor.purpleColor().image(CGSizeMake(28.0, 28.0))
        self.conf.highlited.image = UIColor.yellowColor().image(CGSizeMake(28.0, 28.0))
        
        self.contentEdgeInsets.top = 10.0
        self.contentEdgeInsets.bottom = 10.0
        self.contentEdgeInsets.left = 10.0
        self.contentEdgeInsets.right = 10.0
    }
}
