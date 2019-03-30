//
//  BadgeButton.swift
//  SLAPP
//
//  Created by 柴进 on 2018/1/22.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class BadgeButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var badgeValue:String? = "0"{
        didSet{
            if badgeValue == nil {
                badgeValue = "0"
            }
            if Int(badgeValue!)! > 0{
                isHidden = false
                //设置文字
                if Int(badgeValue!)! > 99 {
                    badgeValue = "99+"
                }
                setTitle(badgeValue, for: .normal)
                //设置frame
                var frame = self.frame;
                let badgeH = self.currentBackgroundImage?.size.height
                var badgeW = self.currentBackgroundImage?.size.width
                if (Int(badgeValue!)! > 1) {
                    let size1 = CGSize(width: 9000.0, height: 9000.0)
                    let badgeSize = self.sizeWithText(text: badgeValue!, font: self.titleLabel!.font, maxSize:size1)
                    badgeW = badgeSize.width+10;
                }
                frame.size.width = badgeW!;
                frame.size.height = badgeH!;
                self.frame = frame;
            }else{
                isHidden = true
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        isUserInteractionEnabled = false
        setBackgroundImage(UIImage(named: "main_badge"), for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 11)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sizeWithText(text:String,font:UIFont,maxSize:CGSize) -> CGSize {
        return text.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:font], context: nil).size
    }
}
