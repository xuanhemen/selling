//
//  AddRecordTagView.swift
//  SLAPP
//
//  Created by rms on 2018/2/1.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class AddRecordTagView: UIView {

    var skipBtn : UIButton!
    var sureBtn : UIButton!
    var bgView : UIView!
    let nameTf = UITextField.init() //名称输入框
    let tipTf = UITextField.init() //标签输入框
    var tagView : TagView!
    var modelArr : Array<String>?
    /// 跳过按钮点击事件的回调
    var skipBtnClickBlock : (() -> ())?
    /// 确定按钮点击事件的回调
    var sureBtnClickBlock : ((_ name: String?, _ tagStr: String?) -> ())?
    /// 选择一个一级按钮点击事件的回调
    var moduleBtnClickBlock : ((_ btn: UIButton) -> ())?
    
    /// 初始化方法
    ///
    /// - Parameters:
    ///   - modelArr: 常用标签数组
    ///   - frame: frame
    convenience init(modelArr : Array<String>, frame : CGRect) {
        self.init()
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.frame = frame
        self.modelArr = modelArr
        bgView = UIView.init(frame: CGRect.init(x: 15, y: 50, width: frame.size.width - 30, height: MAIN_SCREEN_HEIGHT_PX - NAV_HEIGHT - TAB_HEIGHT - 50))
        bgView.backgroundColor = UIColor.white
        bgView.layer.borderWidth = 0.5
        bgView.layer.borderColor = UIColor.darkGray.cgColor
        bgView.layer.cornerRadius = 5
        bgView.layer.masksToBounds = true
        self.addSubview(bgView)
        
        
        let titleLb = UILabel.init()
        titleLb.numberOfLines = 0
        titleLb.text = "录音已经保存,为了方便你下一次找到它,填一些必要信息吧"
        bgView.addSubview(titleLb)
        
        let nameBgView = UIView.init()
        nameBgView.layer.borderColor = UIColor.gray.cgColor
        nameBgView.layer.borderWidth = 0.5
        nameBgView.layer.cornerRadius = 2
        nameBgView.layer.masksToBounds = true
        bgView.addSubview(nameBgView)
        
        let tipBgView = UIView.init()
        tipBgView.layer.borderColor = UIColor.gray.cgColor
        tipBgView.layer.borderWidth = 0.5
        tipBgView.layer.cornerRadius = 2
        tipBgView.layer.masksToBounds = true
        bgView.addSubview(tipBgView)
        
        nameBgView.mas_makeConstraints { (make) in
            make!.top.equalTo()(titleLb.mas_bottom)?.offset()(20)
            make!.left.equalTo()(LEFT_PADDING)
            make!.right.equalTo()(-LEFT_PADDING)
            make!.height.equalTo()(40)
        }
        tipBgView.mas_makeConstraints { (make) in
            make!.top.equalTo()(nameBgView.mas_bottom)?.offset()(15)
            make!.left.equalTo()(LEFT_PADDING)
            make!.right.equalTo()(-LEFT_PADDING)
            make!.height.equalTo()(40)
        }
        
        let nameLb = UILabel.init()
        nameLb.text = "名称:"
        nameBgView.addSubview(nameLb)
      
        nameTf.placeholder = "请输入名称"
        nameBgView.addSubview(nameTf)
        
        let tipLb = UILabel.init()
        tipLb.text = "标签:"
        tipBgView.addSubview(tipLb)
        
        tipTf.placeholder = "请输入标签"
        tipBgView.addSubview(tipTf)
        
        //监听输入框输入内容
        tipTf.reactive.continuousTextValues.observeValues { (text) in

            DLog(text)
//            if self.tipTf.text != nil{
                self.tagView.updateBtnStatus(tagStr:self.tipTf.text)
//            }

        }
        
        titleLb.mas_makeConstraints { (make) in
            make!.top.equalTo()(20)
            make!.left.equalTo()(LEFT_PADDING)
            make!.right.equalTo()(-LEFT_PADDING)
        }
        nameLb.mas_makeConstraints { (make) in
            make!.centerY.equalTo()(nameBgView)
            make!.left.equalTo()(LEFT_PADDING)
            make!.width.equalTo()(40)
        }
        nameTf.mas_makeConstraints { (make) in
            make!.centerY.equalTo()(nameLb)
            make!.left.equalTo()(nameLb.mas_right)?.offset()(10)
            make!.right.equalTo()(0)
            make!.height.equalTo()(35)
        }
        tipLb.mas_makeConstraints { (make) in
            make!.centerY.equalTo()(tipBgView)
            make!.left.equalTo()(LEFT_PADDING)
            make!.width.equalTo()(40)
        }
        tipTf.mas_makeConstraints { (make) in
            make!.centerY.equalTo()(tipLb)
            make!.left.equalTo()(tipLb.mas_right)?.offset()(10)
            make!.right.equalTo()(0)
            make!.height.equalTo()(35)
        }
       
        skipBtn = UIButton.init(frame: CGRect.init(x: LEFT_PADDING, y: bgView.frame.size.height - 45, width: (bgView.frame.size.width - 3 * LEFT_PADDING) * 0.5, height: 40))
        skipBtn.layer.cornerRadius = 5
        skipBtn.layer.masksToBounds = true
        skipBtn.backgroundColor = UIColor.init(hexString: "b6b6b6")
        skipBtn.setTitle("跳过", for: .normal)
        skipBtn.addTarget(self, action: #selector(skipBtnClicked), for: .touchUpInside)
        bgView.addSubview(skipBtn)
        sureBtn = UIButton.init(frame: CGRect.init(x: skipBtn.frame.size.width + 2 * LEFT_PADDING, y: bgView.frame.size.height - 45, width: (bgView.frame.size.width - 3 * LEFT_PADDING) * 0.5, height: 40))
        sureBtn.layer.cornerRadius = 5
        sureBtn.layer.masksToBounds = true
        sureBtn.backgroundColor = kOrangeColor
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.addTarget(self, action: #selector(sureBtnClicked), for: .touchUpInside)
        bgView.addSubview(sureBtn)
        
        if modelArr.count > 0 {
            
            let tipTitleLb = UILabel.init()
            tipTitleLb.text = "您常用的标签"
            bgView.addSubview(tipTitleLb)
            
            tipTitleLb.mas_makeConstraints { (make) in
                make!.top.equalTo()(tipBgView.mas_bottom)?.offset()(20)
                make!.left.equalTo()(LEFT_PADDING)
            }
            tagView = TagView.init(tagArray: modelArr, frame: CGRect.init(x: 0, y: 0, width: bgView.frame.size.width - LEFT_PADDING * 2, height: 200))
            bgView.addSubview(tagView)
            tagView.mas_makeConstraints { (make) in
                make!.top.equalTo()(tipTitleLb.mas_bottom)?.offset()(10)
                make!.left.equalTo()(LEFT_PADDING)
                make!.right.equalTo()(-LEFT_PADDING)
                make!.bottom.equalTo()(-50)
            }
            tagView.oneBtnClickBlock = ({ [weak self](tagStr) in
              
                if self?.tipTf.text == tagStr! {
                    self?.tipTf.text = ""
                }else {
                    self?.tipTf.text = tagStr
                }
            })
        }else{
            tagView = TagView.init(tagArray: [], frame: CGRect.init(x: 0, y: 0, width: bgView.frame.size.width - LEFT_PADDING * 2, height: 200))
//            bgView.addSubview(tagView)
        }
    }
    
    
    ///跳过按钮点击事件
    ///
    /// - Parameter btn: 放弃录音按钮
    @objc func skipBtnClicked(btn:UIButton) {
        if self.skipBtnClickBlock != nil {
            self.skipBtnClickBlock!()
        }
    }
    
    /// 确定按钮点击事件
    ///
    /// - Parameter btn: 放弃录音按钮
    @objc func sureBtnClicked(btn:UIButton) {
        if self.sureBtnClickBlock != nil {
            self.sureBtnClickBlock!(self.nameTf.text,self.tipTf.text)
        }
    }
    
}

