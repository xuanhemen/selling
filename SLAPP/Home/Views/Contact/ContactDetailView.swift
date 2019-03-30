//
//  ContactDetailView.swift
//  SLAPP
//
//  Created by rms on 2018/2/1.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ContactDetailView: UIView{
    
    var headerImgV : UIImageView!
    var nameLb : UILabel!
    var positionLb : UILabel!
    var companyLb : UILabel!
    var phoneBtn : UIButton!
    var emailBtn : UIButton!
    var modelArr : Array<String>!
    var selectedBtn : UIButton?//记录当前选中的按钮
    let redBackView = UIView.init()
    let redView = UIView.init()
    let redNumLabel = UILabel.init()
    
    var gotoContactTimeLine:()->() = {
        
    }
    /// 切换按钮点击事件的回调
    var switchBtnClickBlock : ((_ btn: UIButton) -> ())?
    convenience init(modelArr : Array<String>, frame : CGRect) {
        self.init()
        self.frame = frame
        self.backgroundColor = .clear
        self.modelArr = modelArr
        
        let topView = UIView.init(frame: CGRect.init(x: 0, y: 20, width: frame.size.width - 2 * 15, height: 190))
        topView.layer.cornerRadius = 2
        topView.clipsToBounds = true
        topView.backgroundColor = UIColor.white
        self.addSubview(topView)
        
        headerImgV = UIImageView.init()
        headerImgV.layer.cornerRadius = (topView.frame.size.height-40 - 2 * 15) * 0.5
        headerImgV.layer.masksToBounds = true
        headerImgV.image = UIImage.init(named: modelArr[0])
        topView.addSubview(headerImgV)
        
        nameLb = UILabel.init()
        nameLb.font = kFont_Big
        nameLb.textColor = UIColor.black
        nameLb.text = modelArr[1]
        topView.addSubview(nameLb)
        
        positionLb = UILabel.init()
        positionLb.font = kFont_Middle
        positionLb.textColor = UIColor.darkGray
        positionLb.text = modelArr[2]
        topView.addSubview(positionLb)
        
        companyLb = UILabel.init()
        companyLb.font = kFont_Middle
        companyLb.textColor = UIColor.darkGray
        companyLb.text = modelArr[3]
        topView.addSubview(companyLb)
        
        phoneBtn = UIButton.init()
        phoneBtn.addTarget(self, action: #selector(phoneBtnClick), for: .touchUpInside)
        phoneBtn.setTitleColor(kGreenColor, for: .normal)
        phoneBtn.setTitle(modelArr[4], for: .normal)
        phoneBtn.setImage(UIImage.init(named: "contact_tel"), for: .normal)
        phoneBtn.titleLabel?.font = kFont_Big
        phoneBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5)
        topView.addSubview(phoneBtn)
        
        emailBtn = UIButton.init()
        emailBtn.addTarget(self, action: #selector(emailBtnClick), for: .touchUpInside)
        emailBtn.setTitleColor(kGreenColor, for: .normal)
        emailBtn.setTitle(modelArr[5], for: .normal)
        emailBtn.setImage(UIImage.init(named: "contact_email"), for: .normal)
        emailBtn.titleLabel?.font = kFont_Middle
        emailBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5)
        topView.addSubview(emailBtn)
        
        
        let line = UILabel.init()
        line.backgroundColor = HexColor("#f2f2f2")
        topView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.bottom.equalTo(-40)
            make.height.equalTo(1)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        
        let greenLabel = UILabel.init()
        greenLabel.textColor = kGreenColor
        greenLabel.text = "查看跟进记录"
        greenLabel.font = UIFont.systemFont(ofSize: 15)
        topView.addSubview(greenLabel)
        greenLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.height.equalTo(40)
            make.centerX.equalTo(topView)
        }
        
        redView.backgroundColor = .red
        redView.layer.cornerRadius = 5
        redView.clipsToBounds = true
        redView.isHidden = true
        topView.addSubview(redView)
        redView.snp.makeConstraints { (make) in
            make.width.equalTo(10)
            make.height.equalTo(10)
            make.centerY.equalTo(greenLabel)
            make.left.equalTo(greenLabel.snp.right).offset(5)
        }
        
        redBackView.backgroundColor = .red
        redBackView.layer.cornerRadius = 10
        redBackView.clipsToBounds = true
        redBackView.isHidden = true
        topView.addSubview(redBackView)
        redBackView.snp.makeConstraints { (make) in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.centerY.equalTo(greenLabel)
            make.left.equalTo(greenLabel.snp.right).offset(5)
        }
        
        redNumLabel.textColor = .white
        redNumLabel.text = "99"
        redNumLabel.textAlignment = .center
        redNumLabel.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        redBackView.addSubview(redNumLabel)
        redNumLabel.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(0)
        }
        
        
        let nextImage = UIImageView.init()
        nextImage.image = #imageLiteral(resourceName: "qf_nextArrow")
        topView.addSubview(nextImage)
        nextImage.snp.makeConstraints { (make) in
            make.width.equalTo(10)
            make.height.equalTo(10)
            make.centerY.equalTo(greenLabel)
            make.right.equalTo(-15)
        }
        
        let followUpBtn = UIButton.init()
        followUpBtn.addTarget(self, action: #selector(gotoContactTimeLineButtonClick), for: .touchUpInside)
        topView.addSubview(followUpBtn)
        followUpBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.height.equalTo(40)
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
        
        headerImgV.snp.makeConstraints { (make) in
            make.centerY.equalTo((topView.frame.size.height-40)/2)
            make.left.equalTo(LEFT_PADDING)
            make.size.equalTo(CGSize.init(width: (topView.frame.size.height-40) - 2 * 15,height: (topView.frame.size.height-40) - 2 * 15 ))
        }
        
        nameLb.mas_makeConstraints { [unowned self](make) in
            make!.left.equalTo()(self.headerImgV.mas_right)?.offset()(LEFT_PADDING)
            make!.top.equalTo()(self.headerImgV)
        }
        positionLb.mas_makeConstraints { [unowned self](make) in
            make!.left.equalTo()(self.nameLb.mas_right)?.offset()(LEFT_PADDING)
            make!.centerY.equalTo()(self.nameLb)
        }
        companyLb.mas_makeConstraints { [unowned self](make) in
            make!.left.equalTo()(self.headerImgV.mas_right)?.offset()(LEFT_PADDING)
            make!.top.equalTo()(self.nameLb.mas_bottom)?.offset()(5)
        }
        emailBtn.mas_makeConstraints { [unowned self](make) in
            make!.left.equalTo()(self.headerImgV.mas_right)?.offset()(LEFT_PADDING)
            make!.bottom.equalTo()(self.headerImgV)
        }
        phoneBtn.mas_makeConstraints { [unowned self](make) in
            make!.left.equalTo()(self.headerImgV.mas_right)?.offset()(LEFT_PADDING)
            make!.bottom.equalTo()(self.emailBtn.mas_top)?.offset()(-5)
        }
        
        
        
        
        
        
        let share = UILabel.init(frame: CGRect(x: 0, y: topView.max_Y + 20, width: SCREEN_WIDTH-30, height: 0))
        share.font = UIFont.systemFont(ofSize: 14)
        share.text = modelArr.last
        share.numberOfLines = 0
        share.backgroundColor = UIColor.white
        self.addSubview(share)
        
        share.snp.makeConstraints { (make) in
            make.top.equalTo(210 + 20)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(-80)
        }
        
        
        
        
        
        
        
        
        
        
        let btnArr = ["相关项目","其他信息"]
        let btnMargin : CGFloat = 15
        let btnWidth = (frame.size.width - 30 - CGFloat(btnArr.count - 1) * CGFloat(btnMargin))/CGFloat(btnArr.count)
        for i in 0..<btnArr.count {
            
            let btn = UIButton.init(frame: CGRect.init(x: 0 + (btnWidth + btnMargin) * CGFloat(i), y:self.frame.size.height - 60, width: btnWidth, height: 40))
            btn.tag = 10 + i
            btn.backgroundColor = UIColor.white
            btn.setTitleColor(UIColor.gray, for: .normal)
            btn.setTitle(btnArr[i], for: .normal)
            btn.titleLabel?.font = kFont_Big
            btn.addTarget(self, action: #selector(switchBtnClick), for: .touchUpInside)

            self.addSubview(btn)
            if i == 0 {
                self.selectedBtn = btn
                btn.setTitleColor(kGreenColor, for: .normal)
            }
        }

    }
    //更新数据
    func update(modelArr : Array<String>) {
        self.modelArr = modelArr
        headerImgV.image = UIImage.init(named: modelArr[0])
        nameLb.text = modelArr[1]
        positionLb.text = modelArr[2]
        companyLb.text = modelArr[3]
        phoneBtn.setTitle(modelArr[4], for: .normal)
        emailBtn.setTitle(modelArr[5], for: .normal)
    }

    @objc func switchBtnClick(btn:UIButton) {
        if btn == self.selectedBtn{
            return
        }
        self.selectedBtn?.setTitleColor(UIColor.gray, for: .normal)
        btn.setTitleColor(kGreenColor, for: .normal)
        self.selectedBtn = btn
        if self.switchBtnClickBlock != nil {
            self.switchBtnClickBlock!(btn)
        }
    }
    
    @objc func gotoContactTimeLineButtonClick(){
        self.gotoContactTimeLine()
        
    }
    
    @objc func phoneBtnClick(){
        
        if String.noNilStr(str: self.modelArr[4]) == ""{
            PublicMethod.toastWithText(toastText: "电话号码不能为空")
            return
        }
        
        let web = UIWebView()
        self.addSubview(web)
        web.loadRequest(URLRequest.init(url: URL.init(string: String.init(format: "tel:%@", String.noNilStr(str: self.modelArr[4].removeHiddenCode())))!))
    }
    @objc func emailBtnClick(){
        
        if String.noNilStr(str: self.modelArr[5]) == ""{
            PublicMethod.toastWithText(toastText: "邮箱不能为空")
            return
        }
        
        let web = UIWebView()
        self.addSubview(web)
        web.loadRequest(URLRequest.init(url: URL.init(string: String.init(format: "mailto:%@", String.noNilStr(str: self.modelArr[5])))!))
    }
}

