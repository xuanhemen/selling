//
//  TagView.swift
//  SLAPP
//
//  Created by rms on 2018/2/1.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class TagView: UIScrollView {

    var tagArray : Array<String>!
    var tagStrArr : Array<String>? = Array()
    var selectedBtn : UIButton!
    /// 按钮点击事件的回调
    var oneBtnClickBlock : ((_ tagStr: String?) -> ())?
    convenience init(tagArray : Array<String>, frame : CGRect) {
        self.init()
        self.backgroundColor = UIColor.white
        self.frame = frame
        self.tagArray = tagArray
        self.createTagButton()
    }

    func createTagButton() {

        // 按钮高度
        let btnH : CGFloat = 28
        // 距离左边距
        var leftX : CGFloat = 6
        // 距离上边距
        var topY : CGFloat = 10
          // 按钮左右间隙
        let marginX : CGFloat = 10
           // 按钮上下间隙
        let marginY : CGFloat = 10
          // 文字左右间隙
        let fontMargin : CGFloat = 10
        for i in 0..<self.tagArray.count {
            let btn = UIButton.init(frame: CGRect.init(x: leftX, y: topY, width: 100, height: btnH))
            
            btn.setTitle(self.tagArray[i], for: .normal)
            btn.setTitleColor(UIColor.gray, for: .normal)
            btn.setTitleColor(UIColor.white, for: .selected)
            
            btn.layer.cornerRadius = 2.0
            btn.layer.masksToBounds = true
            btn.layer.borderColor = UIColor.lightGray.cgColor
            btn.layer.borderWidth = 0.5
            
            // 设置按钮的边距、间隙
            self.setBtnMargin(btn:btn,fontMargin: fontMargin)
            
            if btn.frame.origin.x + btn.frame.size.width + 6 > self.frame.size.width {
                // 换行
                topY += btnH + marginY
                
                // 重置
                leftX = 6
                btn.frame = CGRect.init(x: leftX, y: topY, width: btn.frame.size.width, height: btnH)
                
            }
        
            // 重置高度
            var frame = btn.frame
            frame.size.height = btnH
            btn.frame = frame
            btn.addTarget(self, action: #selector(selectdButton), for: .touchUpInside)
            self.addSubview(btn)
            leftX += btn.frame.size.width + marginX
            
            if (i == self.tagArray.count - 1) {
                self.contentSize = CGSize.init(width: 0, height: btn.frame.origin.y + btnH + marginY)
            }
        }
    }
    func setBtnMargin(btn: UIButton,fontMargin: CGFloat)  {
        btn.sizeToFit()
        var frame = btn.frame
        frame.size.width += fontMargin*2
        btn.frame = frame
        
    }
    
    func updateBtnStatus(tagStr:String?) {
        for subView in self.subviews {
            if subView is UIButton {
                if tagStr == (subView as! UIButton).titleLabel?.text{
                    (subView as! UIButton).isSelected = true
                    (subView as! UIButton).backgroundColor = kGreenColor
                }else{
                    (subView as! UIButton).isSelected = false
                    (subView as! UIButton).backgroundColor = UIColor.clear
                }
            }
        }
    }
    @objc func selectdButton(btn: UIButton){

        btn.isSelected = !btn.isSelected
        if btn.isSelected == true {
            if self.selectedBtn != nil {
                 self.selectedBtn.isSelected = false
                    self.selectedBtn.backgroundColor = UIColor.clear
                 self.selectedBtn = nil
            }
            self.selectedBtn = btn
            self.selectedBtn.isSelected = true
            self.selectedBtn.backgroundColor = kGreenColor
        }else{
            self.selectedBtn.isSelected = false
            self.selectedBtn.backgroundColor = UIColor.clear
            self.selectedBtn = nil
        }
        if self.oneBtnClickBlock != nil{

            self.oneBtnClickBlock!(btn.titleLabel?.text)
        }
    }
}
