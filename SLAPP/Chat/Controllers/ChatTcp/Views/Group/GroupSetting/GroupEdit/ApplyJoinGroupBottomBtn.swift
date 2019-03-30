//
//  ApplyJoinGroupBottomBtn.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 17/3/20.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

class ApplyJoinGroupBottomBtn: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineView.frame = CGRect.init(x: 0, y: self.frame.size.height - 5, width: self.frame.size.width, height: 0.7)
    }
    
    lazy var lineView: UIView = {
        let lineView = UIView.init()
        lineView.backgroundColor = UIColor.hexString(hexString: "2183DE")
        return lineView
    }()
}
