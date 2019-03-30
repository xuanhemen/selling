//
//  GroupNameEditTextField.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 17/3/15.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

class GroupNameEditTextField: UITextField {

    convenience init(placeholder:String) {
        self.init()
        self.font = FONT_14
        self.textColor = UIColor.black
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.hexString(hexString: headerBorderColor).cgColor
        self.layer.borderWidth = 0.5
        self.placeholder = placeholder
        self.clearButtonMode = .whileEditing

    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        super.placeholderRect(forBounds: bounds)
        return  CGRect.init(x: bounds.origin.x + 5, y: bounds.origin.y, width: bounds.size.width - 30, height: bounds.size.height)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        super.editingRect(forBounds: bounds)
        return  CGRect.init(x: bounds.origin.x + 5, y: bounds.origin.y, width: bounds.size.width - 30, height: bounds.size.height)
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds)
        return  CGRect.init(x: bounds.origin.x + 5, y: bounds.origin.y, width: bounds.size.width - 30, height: bounds.size.height)
    }
}
