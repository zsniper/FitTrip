//
//  MyTextField.swift
//  WeatherHack2
//
//  Created by zkmb on 2015-01-18.
//  Copyright (c) 2015 zkmb. All rights reserved.
//

import UIKit

class MyTextField : UITextField {
    var leftTextMargin : CGFloat = 20.0
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += leftTextMargin
        return newBounds
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += leftTextMargin
        return newBounds
    }
}