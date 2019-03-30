//
//  MoreSelectBottomView.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 17/6/28.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
let BottomLine_Height : CGFloat = 2.0

class MoreSelectBottomView: UIView {

    var btnClickBlock : ((_ btn: UIButton) -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.groupTableViewBackground
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatBtnsWithImageNames(ImageNamesArr:Array<String>){
        
        let btnWidth : CGFloat = self.frame.size.width / CGFloat(ImageNamesArr.count);
        
        for i in 0..<ImageNamesArr.count {
            let btn = UIButton()
            btn.tag = i + 10
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            btn.setImage(UIImage.init(named: ImageNamesArr[i]), for: .normal)
            btn.frame = CGRect.init(x: CGFloat(i) * btnWidth, y: 0, width: btnWidth, height: self.frame.size.height - BottomLine_Height)
            self.addSubview(btn)
            
        }
    }
    func creatBtnsWithTitleNames(TitleNamesArr:Array<String>){
        
        let btnWidth : CGFloat = self.frame.size.width / CGFloat(TitleNamesArr.count);
        
        for i in 0..<TitleNamesArr.count {
            let btn = UIButton()
            btn.tag = i + 10
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            btn.setTitle(TitleNamesArr[i], for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.frame = CGRect.init(x: CGFloat(i) * btnWidth, y: 0, width: btnWidth, height: self.frame.size.height - BottomLine_Height)
            self.addSubview(btn)
            
        }
    }
}
extension MoreSelectBottomView {
    @objc func btnClick(btn:UIButton){
        if (self.btnClickBlock != nil) {
            self.btnClickBlock!(btn)
        }

    }
}
