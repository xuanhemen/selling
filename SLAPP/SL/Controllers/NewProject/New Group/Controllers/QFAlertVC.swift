//
//  QFAlertVC.swift
//  SLAPP
//
//  Created by qwp on 2018/4/28.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
class QFAlertVC: UIViewController {
    
    var project_id = ""
    
    let headerImageV = UIImageView.init()
    let percentLabel = UILabel.init()
    let nameLabel = UILabel.init()
    let aLabel = UILabel.init()
    let pointLabel = UILabel.init()
    let zhishuLabel = UILabel.init()
    let backView = UIView.init()
    let backImageView = UIImageView.init()
    let shareBottomView = UIView.init()
    let emitter = CAEmitterLayer()//创建发射器

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var params = Dictionary<String,Any>()
        params["project_id"] = project_id
        LoginRequest.getPost(methodName: LOGICANALYSE, params: params.addToken(), hadToast: true, fail: { (dic) in
        }) { [weak self](dic) in
            let headerURL = "\(dic["head"] ?? "")\(imageSuffix)"
            self?.headerImageV.sd_setImage(with: (NSURL.init(string: headerURL)! as URL),placeholderImage:#imageLiteral(resourceName: "ch_protrait_green"))
            
            
            let intExceed:Int = JSON(dic["exceed"] as Any).intValue
            self?.percentLabel.text = "\(intExceed)%"
            self?.nameLabel.text = "\(dic["realname"]! )"
            self?.aLabel.text = "\(dic["exceed_name"]! )"
            let isFirst:Int = dic["new_is_pro_an"] as! Int
            if isFirst == 1 {
                var zhishuF = JSON(dic["contrast_Winindex"] as Any).floatValue
                if zhishuF>=0{
                    self?.zhishuLabel.text = "赢单指数提高了\(zhishuF)分"
                }else{
                    zhishuF = zhishuF * -1
                    self?.zhishuLabel.text = "赢单指数降低了\(zhishuF)分"
                }
                self?.labelTextReset(label: (self?.zhishuLabel)!, range: NSMakeRange(7, (self?.zhishuLabel.text?.count)!-8))
                
                var pointF = JSON(dic["contrast_defen"] as Any).floatValue
                if pointF >= 0{
                    self?.pointLabel.text = "您的项目得分提高了\(pointF)分"
                }else{
                    pointF = pointF * -1
                    self?.pointLabel.text = "您的项目得分降低了\(pointF)分"
                }
                self?.labelTextReset(label: (self?.pointLabel)!, range: NSMakeRange(9, (self?.pointLabel.text?.count)!-10))
            }else{
                self?.pointLabel.text = "您的项目得分为\(dic["pro_defen"]!)分"
                self?.labelTextReset(label: (self?.pointLabel)!, range: NSMakeRange(7, (self?.pointLabel.text?.count)!-8))
                
                self?.zhishuLabel.text = "赢单指数为\(dic["Winindex"]!)分"
                self?.labelTextReset(label: (self?.zhishuLabel)!, range: NSMakeRange(5, (self?.zhishuLabel.text?.count)!-6))
            }
            
        }
        self.configUI()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.startParticleAnimation()
//        self.perform(#selector(stopParticleAnimation), with: nil, afterDelay: 5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configUI()  {
        self.view.backgroundColor = .clear
        
        
        backView.backgroundColor = .black
        backView.alpha = 0.7
        self.view.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
        
        
        backImageView.isUserInteractionEnabled = true
        backImageView.image = #imageLiteral(resourceName: "qf_alertBackImage")
        backImageView.layer.cornerRadius = 5
        backImageView.clipsToBounds = true
        self.view.addSubview(backImageView)
        backImageView.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.width.equalTo(SCREEN_WIDTH-80)
            make.height.equalTo((SCREEN_WIDTH-80)*1.2)
            make.top.equalTo((SCREEN_HEIGHT-109-(SCREEN_WIDTH-80)*1.2)/2)
        }
        
        let bili = (SCREEN_WIDTH-80)/1000
        
        //头像
        headerImageV.layer.cornerRadius = bili*130/2
        headerImageV.clipsToBounds = true
        //headerImageV.backgroundColor = .red
        backImageView.addSubview(headerImageV)
        headerImageV.snp.makeConstraints { (make) in
            make.top.equalTo(bili*30)
            make.left.equalTo(bili*40)
            make.width.height.equalTo(bili*130)
        }
        
        //百分比
        percentLabel.textAlignment = .center
        percentLabel.text = " "
        percentLabel.font = UIFont.systemFont(ofSize: 28, weight: .black)
        percentLabel.sizeToFit()
        //percentLabel.backgroundColor = .white
        percentLabel.textColor = HexColor("#FBEE3F")
        backImageView.addSubview(percentLabel)
        percentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bili*380)
            make.left.equalTo(bili*380)
            make.right.equalTo(-bili*380)
            make.bottom.equalTo(-bili*720)
        }
        
        
        nameLabel.text = ""
        nameLabel.textColor = HexColor("#FFFFFF")
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        nameLabel.sizeToFit()
        backImageView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headerImageV.snp.right).offset(10)
            make.width.equalTo(50)
            make.centerY.equalTo(headerImageV.snp.centerY)
        }
        
        
        aLabel.text = ""
        aLabel.textAlignment = .right
        aLabel.textColor = HexColor("#FFFFFF")
        aLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        aLabel.sizeToFit()
        backImageView.addSubview(aLabel)
        aLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-5)
            make.left.equalTo(nameLabel.snp.right).offset(5)
            make.centerY.equalTo(headerImageV.snp.centerY)
        }
        
        let lineImage = UIImageView.init()
        lineImage.image = #imageLiteral(resourceName: "qf_alert_line")
        lineImage.contentMode = .scaleAspectFit
        backImageView.addSubview(lineImage)
        lineImage.snp.makeConstraints { (make) in
            make.top.equalTo(aLabel.snp.top)
            make.left.equalTo(aLabel.snp.left).offset(20)
            make.width.equalTo(aLabel.snp.width)
            make.height.equalTo(aLabel.snp.height)
        }
        
        pointLabel.text = ""
        pointLabel.textAlignment = .center
        pointLabel.textColor = HexColor("#FFFFFF")
        pointLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        self.labelTextReset(label: pointLabel, range: NSMakeRange(7, (pointLabel.text?.count)!-8))
        backImageView.addSubview(pointLabel)
        pointLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.left.equalTo(15)
            make.top.equalTo(bili*730)
        }
        
        zhishuLabel.text = ""
        zhishuLabel.textAlignment = .center
        zhishuLabel.textColor = HexColor("#FFFFFF")
        zhishuLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        self.labelTextReset(label: zhishuLabel, range: NSMakeRange(5, (zhishuLabel.text?.count)!-6))
        backImageView.addSubview(zhishuLabel)
        zhishuLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.left.equalTo(15)
            make.top.equalTo(bili*870)
        }
        
        let leftBtn = UIButton.init()
        leftBtn.backgroundColor = HexColor("#1A9A5E")
        leftBtn.setTitleColor(.white, for: .normal)
        leftBtn.layer.cornerRadius = 5
        leftBtn.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        leftBtn.setTitle("查看结果", for: .normal)
        backImageView.addSubview(leftBtn)
        leftBtn.snp.makeConstraints { (make) in
            make.left.equalTo(bili*70)
            //make.width.equalTo(bili*400)
            make.right.equalTo(-bili*70)//修改
            make.height.equalTo(bili*115)
            make.bottom.equalTo(-bili*40)
        }
        
        //隐藏了
        let rightBtn = UIButton.init()
        rightBtn.isHidden = true
        rightBtn.layer.cornerRadius = 5
        rightBtn.backgroundColor = HexColor("#FFFFFF")
        rightBtn.setTitleColor(HexColor("#23B572"), for: .normal)
        rightBtn.setTitle("臭拽一下", for: .normal)
        rightBtn.addTarget(self, action: #selector(shareButtonClick), for: .touchUpInside)
        backImageView.addSubview(rightBtn)
        rightBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-bili*70)
            make.width.equalTo(bili*400)
            make.height.equalTo(bili*115)
            make.bottom.equalTo(-bili*40)
        }
        
        let closeBtn = UIButton.init()
        closeBtn.setImage(#imageLiteral(resourceName: "qf_alert_xx"), for: .normal)
        self.view.addSubview(closeBtn)
        closeBtn.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        closeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(backImageView.snp.bottom).offset(40)
            make.width.height.equalTo(50)
            make.centerX.equalTo(backImageView.snp.centerX)
        }
        
        backImageView.addSubview(shareBottomView)
        shareBottomView.backgroundColor = UIColor.init(red: 92/255.0, green: 205/255.0, blue: 140/255.0, alpha: 1)
        shareBottomView.isHidden = true
        shareBottomView.snp.makeConstraints { (make) in
            make.top.equalTo(zhishuLabel.snp.bottom).offset(20)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-10)
        }
        
        
        let codeImageV = UIImageView.init()
        codeImageV.image = #imageLiteral(resourceName: "right")
        shareBottomView.addSubview(codeImageV)
        codeImageV.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.right.equalTo(-10)
            make.width.equalTo(codeImageV.snp.height)
        }
        
        //百分比
        let hintLabel = UILabel.init()
        hintLabel.textAlignment = .center
        hintLabel.text = "-- 想要业绩提升，就用赢单罗盘 --"
        hintLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        hintLabel.sizeToFit()
        //percentLabel.backgroundColor = .white
        hintLabel.textColor = HexColor("#FFFFFF")
        shareBottomView.addSubview(hintLabel)
        hintLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(codeImageV.snp.left).offset(-10)
            make.centerY.equalTo(shareBottomView.snp.centerY)
        }
    }
    @objc func stopParticleAnimation(){
        emitter.removeAllAnimations()
        emitter.removeFromSuperlayer()
    }
    func startParticleAnimation(){
        emitter.emitterPosition = CGPoint(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height)
        emitter.emitterSize = CGSize(width: 50, height: 0.0)
        emitter.emitterMode = kCAEmitterLayerOutline
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.renderMode = kCAEmitterLayerAdditive
        
        let bullet = CAEmitterCell()
        bullet.name = "snow"
        bullet.birthRate = 2.0
        bullet.lifetime = 1.3
        bullet.contents = self.imageWithColor(UIColor.white).cgImage
        bullet.emissionRange = 0.15 * .pi
        bullet.velocity = self.view.bounds.size.height - 100
        bullet.velocityRange = 10
        bullet.yAcceleration = 0
        bullet.spin = .pi/2
        bullet.redRange = 1.0
        bullet.greenRange = 1.0
        bullet.blueRange = 1.0

        let burst = CAEmitterCell()
        burst.birthRate = 1.0
        burst.velocity = 0;
        burst.scale     = 2.5;
        burst.redSpeed = -1.5;        // shifting
        burst.blueSpeed = 1.5;        // shifting
        burst.greenSpeed = 1.0;        // shifting
        burst.lifetime = 0.35;
        
        //爆炸后的烟花
        let spark = CAEmitterCell()
        spark.birthRate = 666
        spark.lifetime = 3
        spark.velocity = 125
        spark.velocityRange = 100
        spark.emissionRange = 2 * .pi
        spark.contents = UIImage(named: "fire.png")?.cgImage
        spark.scale = 0.1
        spark.scaleRange = 0.05
        spark.greenSpeed        = -0.1;
        spark.redSpeed            = 0.4;
        spark.blueSpeed            = -0.1;
        spark.alphaSpeed        = -0.5;
        spark.spin                = 2 * .pi;
        spark.spinRange            = 2 * .pi;
        
        //这里是重点,先将子弹添加给发射器
        emitter.emitterCells = [bullet]
        //子弹发射后,将爆炸cell添加给子弹cell
        bullet.emitterCells = [burst]
        //将烟花cell添加给爆炸效果cell
        burst.emitterCells = [spark]
        //最后将发射器附加到主视图的layer上
        self.view.layer.addSublayer(emitter)
        
        
    }
    
    //将颜色转为图片
    private func imageWithColor(_ color: UIColor) -> UIImage {
        
        let rect = CGRect(x: 0.0, y: 0.0, width: 5.0, height: 5.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    @objc func closeButtonClick(){
        self.dismiss(animated: true) {
            
        }
    }
    @objc func shareButtonClick(){
        shareBottomView.isHidden = false
        
        UIGraphicsBeginImageContext(CGSize(width: SCREEN_WIDTH-80, height: (SCREEN_WIDTH-80)*1.2))
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        headerImageV.image = image
        
        shareBottomView.isHidden = true
    }
    
    func labelTextReset(label:UILabel,range:NSRange){
        guard !(label.text?.isEmpty)!  else {
            return
        }
        
        let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:label.text!)
        attrstring.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 26, weight: .regular), range: range)
        attrstring.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.init(red: 43/255.0, green: 95/255.0, blue: 51/255.0, alpha: 1), range: range)
        label.attributedText = attrstring
    }
}
