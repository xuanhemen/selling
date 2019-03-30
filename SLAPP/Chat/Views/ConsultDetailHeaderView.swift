//
//  ConsultDetailHeaderView.swift
//  SLAPP
//
//  Created by rms on 2018/2/5.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ConsultDetailHeaderView: UIView {
    let starNum = 5
    var headerImgV : UIImageView!
    var nameLb : UILabel!
    var starBtn : UIButton!
    var positionLb : UILabel!
    var phoneBtn : UIButton!
    var messageBtn : UIButton!
    var modelArr : Array<String>!
    var phoneNum:String?
    var startMessage:() -> () = {}
    var gotoTeacherDetail:() -> () = {}
    /// 切换按钮点击事件的回调
    var switchBtnClickBlock : ((_ btn: UIButton) -> ())?
    convenience init(modelArr : Array<String>, frame : CGRect) {
        self.init()
        self.frame = frame
        self.backgroundColor = UIColor.white
        self.modelArr = modelArr
        
        headerImgV = UIImageView.init()
        headerImgV.layer.cornerRadius = (self.frame.size.height - 2 * 25) * 0.5
        headerImgV.layer.masksToBounds = true
        headerImgV.sd_setImage(with: NSURL.init(string:modelArr[0] + imageSuffix)! as URL, placeholderImage: UIImage.init(named: "login_avatar"))
        self.addSubview(headerImgV)
        
        let headerImageButton = UIButton.init(frame: headerImgV.frame)
        headerImageButton.addTarget(self, action: #selector(headerImageClick), for: UIControlEvents.touchUpInside)
        self.addSubview(headerImageButton)
        
        nameLb = UILabel.init()
        nameLb.font = kFont_Big
        nameLb.textColor = UIColor.black
        nameLb.text = modelArr[1]
        self.addSubview(nameLb)
        
        starBtn = UIButton.init()
        self.addSubview(starBtn)
        let imgV_WH : CGFloat = 20
        let imgV_Margin : CGFloat = 5
        DLog(modelArr[3])
        for i in 1...starNum {
            let imgV1 = UIImageView.init(frame: CGRect.init(x: (imgV_WH + imgV_Margin) * CGFloat(i-1), y: 5, width: imgV_WH/2, height: imgV_WH))
            let imgV2 = UIImageView.init(frame: CGRect.init(x: (imgV_WH + imgV_Margin) * CGFloat(i-1) + imgV_WH/2, y: 5, width: imgV_WH/2, height: imgV_WH))
            
            if Float(i) < Float(modelArr[3])!  {
                imgV1.image = UIImage.init(named: "star_select_left")
                imgV2.image = UIImage.init(named: "star_select_right")
            }else{
                if (Float(i) - 0.5) < Float(modelArr[3])!{
                    imgV1.image = UIImage.init(named: "star_select_left")
                    if (Float(i) - 0.25) < Float(modelArr[3])!{
                        imgV2.image = UIImage.init(named: "star_select_right")
                    }else{
                        imgV2.image = UIImage.init(named: "star_normal_right")
                    }
                }else{
                    if (Float(i) - 0.75) < Float(modelArr[3])!{
                        imgV1.image = UIImage.init(named: "star_select_left")
                    }else{
                        imgV1.image = UIImage.init(named: "star_normal_left")
                    }
                     imgV2.image = UIImage.init(named: "star_normal_right")
                }
            }
            starBtn.addSubview(imgV1)
            starBtn.addSubview(imgV2)
        }
        positionLb = UILabel.init()
        positionLb.font = kFont_Middle
        positionLb.textColor = UIColor.darkGray
        positionLb.text = modelArr[2]
        self.addSubview(positionLb)
        
        messageBtn = UIButton.init()
        messageBtn.setTitleColor(kGreenColor, for: .normal)
        messageBtn.setTitle("发消息", for: .normal)
        messageBtn.setImage(UIImage.init(named: "messagesend"), for: .normal)
        messageBtn.titleLabel?.font = kFont_Middle
        messageBtn.imageEdgeInsets = UIEdgeInsetsMake(2, -10, 2, 15)
        messageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5)
        messageBtn.addTarget(self, action: #selector(messageClick), for: .touchUpInside)

        self.addSubview(messageBtn)
        
        phoneBtn = UIButton.init()
        phoneBtn.setTitleColor(kGreenColor, for: .normal)
        phoneBtn.setTitle("打电话", for: .normal)
        phoneBtn.setImage(UIImage.init(named: "photo"), for: .normal)
        phoneBtn.titleLabel?.font = kFont_Middle
        phoneBtn.imageEdgeInsets = UIEdgeInsetsMake(2, -10, 2, 15)
        phoneBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5)
        phoneBtn.addTarget(self, action: #selector(phoneBtnClick), for: .touchUpInside)
        
        self.addSubview(phoneBtn)
        
        headerImgV.mas_makeConstraints { (make) in
            make!.centerY.equalTo()(self)
            make!.left.equalTo()(10)
            make!.size.equalTo()(CGSize.init(width: self.frame.size.height - 2 * 25, height:self.frame.size.height - 2 * 25 ))
        }
        headerImageButton.mas_makeConstraints { (make) in
            make!.centerY.equalTo()(self)
            make!.left.equalTo()(LEFT_PADDING)
            make!.size.equalTo()(CGSize.init(width: self.frame.size.height - 2 * 25, height:self.frame.size.height - 2 * 25 ))
        }
        nameLb.mas_makeConstraints { [unowned self](make) in
            make!.left.equalTo()(self.headerImgV.mas_right)?.offset()(5)
            make!.top.equalTo()(self.headerImgV)
            make?.width.equalTo()(75)
        }
        starBtn.mas_makeConstraints { [unowned self](make) in
            make!.left.equalTo()(self.nameLb.mas_right)?.offset()(LEFT_PADDING)
            make!.centerY.equalTo()(self.nameLb)
            make!.size.equalTo()(CGSize.init(width: (imgV_WH + imgV_Margin) * CGFloat(starNum), height: imgV_WH + imgV_Margin * 2))
        }
        positionLb.mas_makeConstraints { [unowned self](make) in
            make!.left.equalTo()(self.headerImgV.mas_right)?.offset()(LEFT_PADDING)
            make!.top.equalTo()(self.nameLb.mas_bottom)?.offset()(5)
        }
        messageBtn.mas_makeConstraints { [unowned self](make) in
            make!.left.equalTo()(self.headerImgV.mas_right)?.offset()(LEFT_PADDING)
            make?.width.equalTo()(70)
            make!.bottom.equalTo()(self.headerImgV)
        }
        phoneBtn.mas_makeConstraints { [unowned self](make) in
            make!.left.equalTo()(self.messageBtn.mas_right)?.offset()(30)
            make!.centerY.equalTo()(self.messageBtn)
        }
        
       
    }
    @objc func headerImageClick(){
        self.gotoTeacherDetail()
    }

    @objc func phoneBtnClick(){
     
        if (self.phoneNum?.isEmpty)! {
            PublicMethod.toastWithText(toastText: "电话号码不能为空")
            return
        }
        
        let web = UIWebView()
        self.addSubview(web)
        web.loadRequest(URLRequest.init(url: URL.init(string: String.init(format: "tel:%@", self.phoneNum!.removeHiddenCode()))!))
    }
    @objc func messageClick(){
        startMessage()
    }
    
}
