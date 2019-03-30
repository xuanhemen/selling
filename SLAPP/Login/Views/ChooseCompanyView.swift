//
//  ChooseCompanyView.swift
//  SLAPP
//
//  Created by 柴进 on 2018/2/12.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ChooseCompanyView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    effectView.frame = CGRectMake(0, 0, bgImgView.frame.size.width * 0.5, bgImgView.frame.size.height);
//    [bgImgView addSubview:effectView];
    
    var chooseOne:(_ dic:Dictionary<String,Any>)->() = {
        a in
    }
    
    var companyDic = Array<Dictionary<String,Any>>()
    {
        didSet{
            for oldView in backScro.subviews {
                oldView.removeFromSuperview()
            }
            var i = 0
            for onebtn in companyDic{
                let aBtn = UIButton.init(type: .custom)
                aBtn.frame = CGRect(x: LEFT_PADDING, y: 80.0 * CGFloat(i), width: MAIN_SCREEN_WIDTH - LEFT_PADDING * 2, height: 60.0)
               
                aBtn.layer.cornerRadius = 1.0
                aBtn.layer.shadowColor = UIColor.darkGray.cgColor;
                aBtn.layer.shadowOffset = CGSize.init(width: 2, height: 2);
                aBtn.layer.shadowOpacity = 0.5;
                aBtn.layer.shadowRadius = 2;
                backScro.addSubview(aBtn)
                aBtn.setTitle(onebtn["name"] as! String, for: .normal)
                aBtn.backgroundColor = .white
                aBtn.setTitleColor(.black, for: .normal)
                aBtn.reactive.controlEvents(UIControlEvents.touchUpInside).observe({ (event) in
                    self.chooseOne(onebtn)
                })
                
                i = i+1
                
                backScro.contentSize = CGSize.init(width: MAIN_SCREEN_WIDTH, height: 80.0 * CGFloat(i))
            }
        }
    }
    let backScro = UIScrollView.init(frame: CGRect(x: 0, y: MAIN_SCREEN_HEIGHT_PX/6+60, width: MAIN_SCREEN_WIDTH, height: 400))
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: MAIN_SCREEN_HEIGHT_PX))
        let effect = UIBlurEffect.init(style: UIBlurEffectStyle.dark)
        let effectView = UIVisualEffectView.init(effect: effect)
        effectView.frame = CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: MAIN_SCREEN_HEIGHT_PX)
        effectView.alpha = 0.7
        self.backgroundColor = .clear
        self.addSubview(effectView)
        
        let w1Lab = UILabel.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH/6*5, height: 60))
        w1Lab.text = "您的账号在几个企业中都能使用，请选择此次要登录的企业。"
        w1Lab.textColor = .white
        w1Lab.font = UIFont.systemFont(ofSize: 20)
        w1Lab.textAlignment = .left
        w1Lab.numberOfLines = 0
        w1Lab.center = CGPoint(x: self.centerX, y: self.centerY/3)
        self.addSubview(w1Lab)
        
        
//        backScro.backgroundColor =
        self.addSubview(backScro)
 
//        for onebtn in companyDic
 
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
