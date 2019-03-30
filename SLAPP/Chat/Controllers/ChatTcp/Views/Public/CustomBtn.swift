//
//  CustomBtn.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 2017/4/24.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

class CustomBtn: UIButton {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        let btnW = self.frame.size.width
        let imageW:CGFloat = 22.0
        self.imageView?.frame = CGRect(x: (btnW - imageW)/2.0, y: 5.5, width: imageW+0.5, height: imageW+0.5)
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.frame = CGRect(x: 0, y: 30, width: btnW, height: (self.titleLabel?.frame.size.height)! + 2.0)
        self.titleLabel?.backgroundColor = UIColor.clear
        //        self.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
    
}
