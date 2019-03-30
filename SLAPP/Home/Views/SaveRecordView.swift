//
//  SaveRecordView.swift
//  SLAPP
//
//  Created by rms on 2018/1/30.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class SaveRecordView: UIView {

    var cancleBtn : UIButton!
    var backBtn : UIButton!
    var saveBtn : UIButton!
    var bgView : UIView!
    var firstView : UIView!
    var secondView : UIView!
    var scrollView : SaveRecordScrollView?
    var detailScrollView : SaveRecordScrollView?
    var modelArr : Array<String>?
    var moduleIndex : Int?
    var detailIndex : Int?
    /// 放弃录音按钮点击事件的回调
    var cancleBtnClickBlock : ((_ btn: UIButton) -> ())?
    /// 保存按钮点击事件的回调
    var saveBtnClickBlock : ((_ moduleIndex: Int?, _ detailIndex: Int?) -> ())?
    /// 选择一个一级按钮点击事件的回调
    var moduleBtnClickBlock : ((_ btn: UIButton) -> ())?
    convenience init(modelArr : Array<String>, frame : CGRect) {
        self.init()
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.frame = frame
        self.modelArr = modelArr
        bgView = UIView.init(frame: CGRect.init(x: 15, y: MAIN_SCREEN_HEIGHT - TAB_HEIGHT - NAV_HEIGHT - 90 - 20 - 260, width: MAIN_SCREEN_WIDTH - 30, height: 260))
        bgView.backgroundColor = UIColor.white
        bgView.layer.borderWidth = 0.5
        bgView.layer.borderColor = UIColor.darkGray.cgColor
        bgView.layer.cornerRadius = 5
        bgView.layer.masksToBounds = true
        self.addSubview(bgView)
        firstView = UIView.init(frame: CGRect.init(x: 15, y: 5, width: bgView.frame.size.width - 30, height: ((CGFloat)(modelArr.count > 4 ? 4 : modelArr.count) * 50 + 50)))
        bgView.addSubview(firstView)
      
        let titleLb = UILabel.init()
        titleLb.text = "要把该录音存到什么地方?"
        firstView.addSubview(titleLb)
        cancleBtn = UIButton.init()
        cancleBtn.layer.cornerRadius = 5
        cancleBtn.layer.masksToBounds = true
        cancleBtn.backgroundColor = kOrangeColor
        cancleBtn.setTitle("放弃此录音", for: .normal)
        cancleBtn.addTarget(self, action: #selector(cancleBtnClicked), for: .touchUpInside)
        firstView.addSubview(cancleBtn)
        scrollView = SaveRecordScrollView.init(modelArr:modelArr, frame : CGRect.init(x: 0, y: 55, width: firstView.frame.size.width, height: (CGFloat)(modelArr.count > 4 ? 4 : modelArr.count) * 50), hasDefault : false)
        firstView.addSubview(scrollView!)
        
        scrollView?.oneBtnClickBlock = ({ [weak self](btn) in
            self?.moduleIndex = btn.tag
            if self?.moduleBtnClickBlock != nil {
                self?.moduleBtnClickBlock!(btn)
            }
        })
        titleLb.mas_makeConstraints { (make) in
            make!.top.equalTo()(10)
            make!.left.equalTo()(0)
            make!.height.equalTo()(40)
        }
        cancleBtn.mas_makeConstraints { (make) in
            make!.top.equalTo()(10)
            make!.right.equalTo()(0)
            make!.size.equalTo()(CGSize.init(width: 100, height: 40))
        }
       
        
    }
    
    /// 放弃录音按钮点击事件
    ///
    /// - Parameter btn: 放弃录音按钮
    @objc func cancleBtnClicked(btn:UIButton) {
        self.umAnalyticsWithName(name: um_recordGiveUp)
        if self.cancleBtnClickBlock != nil {
            self.cancleBtnClickBlock!(btn)
        }
    }
    
    /// 返回按钮点击事件
    ///
    /// - Parameter btn: 放弃录音按钮
    @objc func backBtnClicked(btn:UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            var frame = self.firstView.frame
            frame.origin.x += (self.bgView.frame.size.width - 15)
            self.firstView.frame = frame
            var frame2 = self.secondView.frame
            frame2.origin.x += (self.bgView.frame.size.width - 15)
            self.secondView.frame = frame2
        }) { (finish) in
            
        }
    }
    
    /// 保存按钮点击事件
    ///
    /// - Parameter btn: 放弃录音按钮
    @objc func saveBtnClicked(btn:UIButton) {
        self.umAnalyticsWithName(name: um_recordSave)
        if self.saveBtnClickBlock != nil {
            self.saveBtnClickBlock!(self.moduleIndex,self.detailIndex)
        }
    }
    func scrollTodetailView(detailArr: Array<String>){
        
        secondView = UIView.init(frame: CGRect.init(x: bgView.frame.size.width, y: 5, width: bgView.frame.size.width - 30, height: 250))
        self.addSubview(secondView)
       
        backBtn = UIButton.init(frame: CGRect.init(x: 0, y: secondView.frame.size.height - 45, width: (secondView.frame.size.width - LEFT_PADDING) * 0.5, height: 40))
        backBtn.layer.cornerRadius = 5
        backBtn.layer.masksToBounds = true
        backBtn.backgroundColor = HexColor("b6b6b6")
        backBtn.setTitle("返回上一级", for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnClicked), for: .touchUpInside)
        secondView.addSubview(backBtn)
        saveBtn = UIButton.init(frame: CGRect.init(x: backBtn.frame.size.width + LEFT_PADDING, y: secondView.frame.size.height - 45, width: (secondView.frame.size.width - LEFT_PADDING) * 0.5, height: 40))
        saveBtn.layer.cornerRadius = 5
        saveBtn.layer.masksToBounds = true
        saveBtn.backgroundColor = kOrangeColor
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.addTarget(self, action: #selector(saveBtnClicked), for: .touchUpInside)
        secondView.addSubview(saveBtn)
        
        detailScrollView = SaveRecordScrollView.init(modelArr:detailArr, frame : CGRect.init(x: 0, y: 5, width: secondView.frame.size.width, height: (CGFloat)(detailArr.count > 4 ? 4 : detailArr.count) * 50), hasDefault :true)
        secondView.addSubview(detailScrollView!)
        bgView.addSubview(self.secondView)
        self.detailIndex = 0//默认选择第一个
        detailScrollView?.oneDetailBtnClickBlock = ({ [weak self](btn) in
            self?.detailIndex = btn.tag
        })
        
        UIView.animate(withDuration: 0.5, animations: {
            var frame = self.firstView.frame
            frame.origin.x -= (self.bgView.frame.size.width - 15)
            self.firstView.frame = frame
            var frame2 = self.secondView.frame
            frame2.origin.x -= (self.bgView.frame.size.width - 15)
            self.secondView.frame = frame2
        }) { (finish) in
           
        }
    }
}
