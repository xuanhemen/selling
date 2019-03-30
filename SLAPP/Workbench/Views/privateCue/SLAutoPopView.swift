//
//  SLAutoPopView.swift
//  SLAPP
//
//  Created by 董建伟 on 2019/1/10.
//  Copyright © 2019年 柴进. All rights reserved.
//

import UIKit

class SLAutoPopView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    lazy var suportBtn = UIButton.init(type: UIButtonType.custom)
    
    lazy var commentsBtn = UIButton.init(type: UIButtonType.custom)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 6
        self.backgroundColor = RGBA(R: 37, G: 39, B: 49, A: 1)
        suportBtn.setTitle("赞", for: UIControlState.normal)
        suportBtn.setTitleColor(.white, for: UIControlState.normal)
        suportBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        suportBtn.titleLabel?.font = FONT_14
        self.addSubview(suportBtn)
        commentsBtn.setTitle("评论", for: UIControlState.normal)
        commentsBtn.setTitleColor(.white, for: UIControlState.normal)
        commentsBtn.frame = CGRect(x: 60, y: 0, width: 60, height: 30)
        commentsBtn.titleLabel?.font = FONT_14
        self.addSubview(commentsBtn)
        
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = CGRect(x: 60, y: 5, width: 1, height: 20)
        self.layer.addSublayer(layer)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
