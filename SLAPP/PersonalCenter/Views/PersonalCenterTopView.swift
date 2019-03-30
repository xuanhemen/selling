//
//  PersonalCenterTopView.swift
//  SLAPP
//
//  Created by apple on 2018/6/19.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import LFProgressView
let textColor = UIColor.darkText.withAlphaComponent(0.6)

class PersonalCenterTopView: UIView {
     let btnLeft = UIButton.init(type: .custom)
     let btnRight = UIButton.init(type: .custom)
    var tempBtn:UIButton?
    let btn = UIButton.init(type: .custom)
    var btnClickBlock:(_ tag:Int)->() = {_ in
        
    }
    
    
    var clickChat:()->() = {
        
    }
    
    var perModel:Pperformance_completion_rateModel?
    var model:PmemberModel?
//    {
////        didSet{
////            nameLable.text = model?.realname
////
////            alreadyValue.text = "300万"
////            targetValue.text = "1000万"
////            completionValue.text = "%30"
////            username.text = "用户名：".appending(model?.realname ?? "")
////            phone.text = "手机号：".appending(model?.mobile ?? "")
////            email.text = "邮箱：".appending(model?.email ?? "")
////        }
//
//    }
    
    func configWithData(model:PmemberModel,pModel:Pperformance_completion_rateModel,auth:String){
        self.model = model
        self.perModel = pModel
        
        btn.isHidden = model.userid == UserModel.getUserModel().id
        
        
        nameLable.text = model.realname
        positionLable.text = model.dep_name
        DLog(pModel.win_down_payment);
        
        //
        alreadyValue.text = String.init(format: "%.2f万",pModel.win_down_payment)
        targetValue.text = String.init(format: "%.2f万",pModel.planamount)
        completionValue.text = String.init(format: "%.2f%@",pModel.completion_rate,"%")
        let str = String.init(format: "%.2f",pModel.completion_rate/100)
        progress.progress = CGFloat(Double(str)!)
        username.text = "用户名：".appending(model.realname)
        phone.text = "手机号：".appending(model.mobile)
        email.text = "邮箱：".appending(model.email)
        headImage.setImageWith(url: model.head, imageName: "mine_avatar")
        
        if auth == "1" {
            alreadyValue.isHidden = false
            targetValue.isHidden = false
            completionValue.isHidden = false
            progress.isHidden = false
            btnLeft.isHidden = false
            btnRight.isHidden = false
        }else{
            alreadyValue.isHidden = true
            targetValue.isHidden = true
            completionValue.isHidden = true
            progress.isHidden = true
            btnLeft.isHidden = true
            btnRight.isHidden = true
        }
        
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI(){
        self.backgroundColor = UIColor.groupTableViewBackground
        
        let top = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 100))
        top.backgroundColor = kGrayColor_Slapp
        self.addSubview(top)
        
        
        
        let infoView = UIView()
        self.addSubview(infoView)
        infoView.layer.cornerRadius = 6
        infoView.backgroundColor = UIColor.white
        
        infoView.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(200)
        }
        
        infoView.addSubview(headImage)
        infoView.addSubview(nameLable)
        infoView.addSubview(positionLable)
        infoView.addSubview(target)
        infoView.addSubview(already)
        infoView.addSubview(completion)
        infoView.addSubview(progress)
        infoView.addSubview(targetValue)
        infoView.addSubview(alreadyValue)
        infoView.addSubview(completionValue)
        
        
        
        

        target.text = "业绩目标："
        already.text = "已完成："
        completion.text = "业绩完成率："
        
        let lwidth = 80
        
       
        headImage.layer.cornerRadius = 70/2
        headImage.clipsToBounds = true
        headImage.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.height.equalTo(70)
            make.top.equalTo(15)
        }
        
        
        nameLable.snp.makeConstraints {[weak self] (make) in
            make.left.equalTo((self?.headImage.snp.right)!).offset(5)
            make.width.equalTo(lwidth)
            make.height.equalTo(25)
            make.top.equalTo(5)
        }
        
        
        positionLable.snp.makeConstraints {[weak self] (make) in
            make.top.equalTo((self?.nameLable)!)
            make.left.equalTo((self?.nameLable.snp.right)!).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(25)
        }
        
        target.snp.makeConstraints {[weak self] (make) in
            make.left.equalTo((self?.headImage.snp.right)!).offset(5)
            make.width.equalTo(lwidth)
            make.height.equalTo(25)
            make.top.equalTo((self?.nameLable.snp.bottom)!).offset(0)
        }
        
        
        already.snp.makeConstraints {[weak self] (make) in
            make.left.equalTo((self?.headImage.snp.right)!).offset(5)
            make.width.equalTo(lwidth)
            make.height.equalTo(25)
            make.top.equalTo((self?.target.snp.bottom)!).offset(0)
        }
        
        
        completion.snp.makeConstraints {[weak self] (make) in
            make.left.equalTo((self?.headImage.snp.right)!).offset(5)
            make.width.equalTo(lwidth+15)
            make.height.equalTo(25)
            make.top.equalTo((self?.already.snp.bottom)!).offset(0)
        }
        
        
        progress.snp.makeConstraints {[weak self] (make) in
            make.left.equalTo((self?.completion.snp.right)!).offset(3)
            make.height.equalTo(5)
            make.right.equalTo(-70)
            make.centerY.equalTo((self?.completion.snp.centerY)!)
        }
        
        
        
        
        
        targetValue.snp.makeConstraints {[weak self] (make) in
            make.centerY.equalTo((self?.target)!)
            make.right.equalTo(-10)
            make.left.equalTo((self?.target.snp.right)!).offset(10)
            make.height.equalTo(25)
        }
        
        alreadyValue.snp.makeConstraints {[weak self] (make) in
            make.centerY.equalTo((self?.already)!)
            make.right.equalTo(-10)
            make.left.equalTo((self?.already.snp.right)!).offset(10)
            make.height.equalTo(25)
        }
        
        completionValue.snp.makeConstraints {[weak self] (make) in
            make.centerY.equalTo((self?.completion)!)
            make.right.equalTo(-10)
            make.left.equalTo((self?.completion.snp.right)!).offset(10)
            make.height.equalTo(25)
        }
        
        
        
        
        
        
        
        
        
        let line = UIView()
        line.backgroundColor = UIColor.groupTableViewBackground
        self.addSubview(line)
        line.snp.makeConstraints { [weak self](make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(0.5)
            make.top.equalTo((self?.completion.snp.bottom)!).offset(5)
        }
        
        
        infoView.addSubview(username)
        infoView.addSubview(phone)
        infoView.addSubview(email)
        
        
        
        username.snp.makeConstraints {[weak self] (make) in
            make.left.equalTo(10)
            make.top.equalTo((self?.completion.snp.bottom)!).offset(10)
            make.right.equalToSuperview().offset(-60)
            make.height.equalTo(25)
        }
        
        phone.snp.makeConstraints {[weak self] (make) in
            make.left.equalTo(10)
            make.top.equalTo((self?.username.snp.bottom)!).offset(0)
            make.right.equalToSuperview().offset(-60)
            make.height.equalTo(25)
        }
        
        email.snp.makeConstraints {[weak self] (make) in
            make.left.equalTo(10)
            make.top.equalTo((self?.phone.snp.bottom)!).offset(0)
            make.right.equalToSuperview().offset(-60)
            make.height.equalTo(25)
        }
        
        
        
        infoView.addSubview(btn)
        btn.setImage(#imageLiteral(resourceName: "pChat"), for: .normal)
        btn.isHidden = true
        btn.snp.makeConstraints {[weak self] (make) in
            make.height.width.equalTo(40)
            make.centerY.equalTo((self?.phone)!)
            make.right.equalToSuperview().offset(-20)
        }
        btn.addTarget(self, action: #selector(btnClickChat), for: .touchUpInside)
        
       
        self.addSubview(btnLeft)
        btnLeft.setTitle("业绩", for: .normal)
        btnLeft.backgroundColor = kGreenColor
        btnLeft.tag = 1000
       
        self.addSubview(btnRight)
        
        btnRight.setTitle("项目", for: .normal)
        btnRight.backgroundColor = UIColor.white
        btnRight.setTitleColor(textColor, for: .normal)
        btnRight.tag = 1001
        btnLeft.snp.makeConstraints {[weak btnRight] (make) in
            make.left.equalTo(10)
            make.bottom.equalTo(-12)
            make.height.equalTo(50)
            make.width.height.equalTo(btnRight!)
            make.right.equalTo((btnRight?.snp.left)!).offset(-10)
        }
        tempBtn = btnLeft
        
        btnRight.snp.makeConstraints {[weak btnLeft] (make) in
            make.bottom.equalTo((btnLeft?.snp.bottom)!)
            make.width.height.equalTo(btnLeft!)
//            make.left.equalTo(btnLeft?.snp.right).offset(10)
            make.right.equalTo(-10)
        }
        
        btnLeft.addTarget(self, action: #selector(btnClick(btn: )), for: .touchUpInside)
        btnRight.addTarget(self, action: #selector(btnClick(btn: )), for: .touchUpInside)
    }
    
    
    @objc func btnClickChat(){
        clickChat()
        
    }
    
    
    
    
    @objc func btnClick(btn:UIButton){
        tempBtn?.backgroundColor = UIColor.white
        tempBtn?.setTitleColor(textColor, for: .normal)
        
        btn.backgroundColor = kGreenColor
        btn.setTitleColor(UIColor.white, for: .normal)
        
        tempBtn = btn
        btnClickBlock(btn.tag-1000)
    }
    
    
    
    
    
    //姓名
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 17)
        lable.textColor = textColor
        return lable
    }()
    
    //职位
    lazy var positionLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    
    //业绩目标
    lazy var target = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = textColor
        return lable
    }()
    //已完成
    lazy var already = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = textColor
        return lable
    }()
    
    //完成率
    lazy var completion = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = textColor
        return lable
    }()
    
    
    
    //业绩目标
    lazy var targetValue = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = UIColor.orange
        lable.textAlignment = .right
        return lable
    }()
    //已完成
    lazy var alreadyValue = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = UIColor.orange
        lable.textAlignment = .right
        return lable
    }()
    
    //完成率
    lazy var completionValue = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = kGreenColor
        lable.textAlignment = .right
        return lable
    }()
    
    
    
    
    
    
    //用户名
    lazy var username = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = textColor
        return lable
    }()
    
    //手机号
    lazy var phone = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = textColor
        return lable
    }()
    
    //邮箱
    lazy var email = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = textColor
        return lable
    }()
    
    lazy var headImage = { () -> UIImageView in
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "mine_avatar")
        return image
    }()
    
//    进度条
    lazy var progress = { ()-> LFProgressView in
        let p = LFProgressView.init()
        p.backgroundColor = UIColor.clear
        p.background = UIColor.hexString(hexString: "ACADAE")
        p.color = kGreenColor
        p.animate = 1
        p.stripeSlope = 0.5
        p.progress = 0
        p.flat = 1
        return p
    }()
}
