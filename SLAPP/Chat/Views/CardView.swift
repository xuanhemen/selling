//
//  CardView.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 17/6/8.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

let BottomLine_Height : CGFloat = 2.0
class CardView: UIView {

    var bottomLine : UIView!
    var selectedBtn : UIButton?
    var btnClickBlock : ((_ btn: UIButton) -> ())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kNavBarBGColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func creatBtnsWithTitles(titlesArr:Array<String>){
    
        let btnWidth : CGFloat = self.frame.size.width / CGFloat(titlesArr.count);

        for i in 0..<titlesArr.count {
            let btn = UIButton()
            btn.tag = i + 10
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            btn.titleLabel?.font = kFont_Big
            btn.setTitle(titlesArr[i], for: .normal)
            btn.setTitleColor(UIColor.darkGray, for: .normal)
            btn.frame = CGRect.init(x: CGFloat(i) * btnWidth, y: 0, width: btnWidth, height: self.frame.size.height - BottomLine_Height)
            self.addSubview(btn)
            
        }
        bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.green
        bottomLine.frame = CGRect.init(x: 30, y: self.frame.size.height - BottomLine_Height, width: btnWidth - 2*30, height: BottomLine_Height)
        self.addSubview(bottomLine)
        
        self .btnClick(btn: self.viewWithTag(10) as! UIButton)
    }
    
}

extension CardView {
    @objc func btnClick(btn:UIButton){
    
        if (selectedBtn == btn) {
            return;
        }
        selectedBtn?.setTitleColor(UIColor.darkGray, for: .normal)
        let btn = self.viewWithTag(btn.tag) as? UIButton
        btn?.setTitleColor(UIColor.white, for: .normal)
        selectedBtn = btn;
        UIView.animate(withDuration: 0.3) {
            var frame : CGRect = self.bottomLine.frame
            frame.origin.x = (btn?.frame.origin.x)! + 30
            self.bottomLine.frame = frame
        }
        
        if (self.btnClickBlock != nil) {
            self.btnClickBlock!(btn!)
        }
    }
}
