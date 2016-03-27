//
//  CustomObject.swift
//  TranslateTougue
//
//  Created by Serx on 16/3/27.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import UIKit

public let blueColor = UIColor(red: 0/255, green: 180/255, blue: 250/255, alpha: 1.0)

class RoundedRectangleButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 5.0
        self.backgroundColor = blueColor
        self.tintColor = UIColor.whiteColor()
    }
}

class RoundedRectangleImageView: UIImageView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
    }
}

class CircleImageView: UIImageView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderWidth = 0
        let cornerRadius = self.frame.size.height / 2
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
}

class RoundedRectangleLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 5.0
        self.textColor = UIColor.lightGrayColor()
    }
}

class RoundedRectangleTextView: UITextView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.cornerRadius = 5.0
        self.textColor = UIColor.lightGrayColor()
    }
}


