//
//  ProjectTabBtn.swift
//  SLAPP
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
let kScale:CGFloat = 0.5
class ProjectTabBtn: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView?.contentMode = .center
        self.titleLabel?.font = kFont_Middle
        self.titleLabel?.textAlignment = .center
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let x:CGFloat = 0
        let y:CGFloat = 0
        let width:CGFloat = contentRect.size.width
        let height:CGFloat = contentRect.size.height * kScale
        return CGRect.init(x: x, y: y, width: width, height: height)
    }
    
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let x:CGFloat = 0
        let y:CGFloat = contentRect.size.height * kScale
        let width:CGFloat = contentRect.size.width
        let height:CGFloat = contentRect.size.height * (1-kScale)
        return CGRect.init(x: x, y: y, width: width, height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
