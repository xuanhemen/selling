//
//  SaveRecordScrollView.swift
//  SLAPP
//
//  Created by rms on 2018/1/30.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class SaveRecordScrollView: UIScrollView {

    /// 按钮点击事件的回调
    var oneBtnClickBlock : ((_ btn: UIButton) -> ())?
    /// 详情按钮点击事件的回调
    var oneDetailBtnClickBlock : ((_ btn: UIButton) -> ())?
    var selectedBtn : UIButton?
    convenience init(modelArr : Array<String>, frame : CGRect, hasDefault : Bool) {
        self.init()
        self.backgroundColor = UIColor.white
        self.frame = frame
        self.contentSize = CGSize.init(width: 0, height: CGFloat(modelArr.count) * 50)
        for i in 0..<modelArr.count {
            let btn = UIButton.init(frame: CGRect.init(x: 0, y: CGFloat(i) * 50, width: self.frame.size.width, height: 40))
            btn.tag = i
            btn.layer.borderWidth = 0.5
            btn.layer.borderColor = UIColor.darkGray.cgColor
            btn.layer.cornerRadius = 5
            btn.layer.masksToBounds = true
            btn.setTitle(modelArr[i], for: .normal)
            btn.setTitleColor(UIColor.gray, for: .normal)
            btn.addTarget(self, action: #selector(oneBtnClicked), for: .touchUpInside)
            self.addSubview(btn)
            //默认选择第一个
            if hasDefault == true && i == 0{
                btn.backgroundColor = kGreenColor
                btn.setTitleColor(UIColor.white, for: .normal)
                self.selectedBtn = btn
            }
        }
       
        
    }
    /// 放弃录音按钮点击事件
    ///
    /// - Parameter btn: 放弃录音按钮
    @objc func oneBtnClicked(btn:UIButton) {
        
        if self.oneBtnClickBlock != nil {
            self.oneBtnClickBlock!(btn)
        }
        if self.oneDetailBtnClickBlock != nil {
            if btn == self.selectedBtn{
                return
            }
            self.selectedBtn?.backgroundColor = UIColor.white
            self.selectedBtn?.setTitleColor(UIColor.gray, for: .normal)
            btn.backgroundColor = kGreenColor
            btn.setTitleColor(UIColor.white, for: .normal)
            self.selectedBtn = btn
            self.oneDetailBtnClickBlock!(btn)
        }
    }
}
