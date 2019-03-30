//
//  MenuListView.swift
//  SLAPP
//
//  Created by 柴进 on 2018/3/23.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class MenuListView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var model = Array<(String,String,String,Bool)>(){
        didSet{
            configUi()
        }
    }
    
    var chooseOne:(Int,(String,String,String,Bool))->() = {a,b in
        print(a)
    }
    
    
    var clicktop:()->() = {
        
    }
    
    
    let pText1 = UILabel()
    let pPoint1 = UIImageView()
    
    
    func configUi() {
        for subView in self.subviews{
            subView.removeFromSuperview()
        }
        for i in -1..<model.count {
            let backImage = UIImageView()
            backImage.isUserInteractionEnabled = true
            if i == -1{
                backImage.image = UIImage.init(named: "p_menu_top")
                self.addSubview(backImage)
                backImage.snp.makeConstraints({ (make) in
                    make.left.right.equalToSuperview()
                    make.top.equalToSuperview().offset(0)
                    make.height.equalTo(44)
                })
                
                let pImage = UIImageView()
                let pState = UIImageView()
                backImage.addSubview(pImage)
                backImage.addSubview(pText1)
                backImage.addSubview(pPoint1)
                backImage.addSubview(pState)
                
                pImage.image = UIImage.init(named: "p_menu_sort_img")
                pImage.snp.makeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.size.equalTo(CGSize(width: 16, height: 16))
                    make.left.equalTo(LEFT_PADDING)
                }
                if kScreenW <= 320 {
                    pText1.font = kFont_Small
                }else{
                    pText1.font = kFont_Big
                }
                
                if model.count == 7 {
                    pText1.text = "排序"
                }else{
                    pText1.text = "分组"
                }
                
//                pText1.font = kFont_Big
                pText1.textColor = .white
                pText1.snp.makeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.height.equalTo(20)
                    make.left.equalTo(pImage.snp.right).offset(MARGIN)
                }
                
                pPoint1.image = UIImage.init(named: "p_menu_dowm")
                pPoint1.snp.makeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.size.equalTo(CGSize(width: 5, height: 12))
                    make.left.equalTo(pText1.snp.right).offset(MARGIN)
                }
                
                pState.image = UIImage.init(named: "p_menu_show_img")
                pState.snp.makeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.size.equalTo(CGSize(width: 12, height: 7))
                    make.right.equalTo(-MARGIN-10)
                }
                
                let btn = UIButton.init(type: UIButtonType.custom)
                backImage.addSubview(btn)
                btn.snp.makeConstraints({ (make) in
                    make.left.right.top.bottom.equalToSuperview()
                })
//                configBottonUi(btn: btn,i:i)
                btn.reactive.controlEvents(UIControlEvents.touchUpInside).observe({[weak self] (event) in
//                    self.chooseOne(i,self.model[i])
                    self?.clicktop()
                })
                
                
            }else if i == model.count-1{
                backImage.image = UIImage.init(named: "p_menu_bottom")
                self.addSubview(backImage)
                backImage.snp.makeConstraints({ (make) in
                    make.left.right.equalToSuperview()
                    make.top.equalTo(44 * (i+1))
                    make.height.equalTo(54)
                })
                let btn = UIButton.init(type: UIButtonType.custom)
                backImage.addSubview(btn)
                btn.snp.makeConstraints({ (make) in
                    make.left.right.top.bottom.equalToSuperview()
                })
                configBottonUi(btn: btn,i:i)
                btn.reactive.controlEvents(UIControlEvents.touchUpInside).observe({ (event) in
                    self.chooseOne(i,self.model[i])
                })
            }else{
                backImage.image = UIImage.init(named: "p_menu_center")
                self.addSubview(backImage)
                backImage.snp.makeConstraints({ (make) in
                    make.left.right.equalToSuperview()
                    make.top.equalTo(44 * (i+1))
                    make.height.equalTo(44)
                })
                let btn = UIButton.init(type: UIButtonType.custom)
                backImage.addSubview(btn)
                btn.snp.makeConstraints({ (make) in
                    make.left.right.top.bottom.equalToSuperview()
                })
                configBottonUi(btn: btn,i:i)
                btn.reactive.controlEvents(UIControlEvents.touchUpInside).observe({ (event) in
                    self.chooseOne(i,self.model[i])
                })
            }
            if i != -1 && self.model[i].3{
                pText1.text = self.model[i].1
                pPoint1.image = UIImage.init(named: "p_menu_"+self.model[i].2)
            }
        }
    }

    func configBottonUi(btn:UIButton,i:Int){
        let pImage = UIImageView()
        btn.addSubview(pImage)
        pImage.image = UIImage.init(named:  "p_m_s_" + self.model[i].0)
        pImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(btn.snp.top).offset(22)
            make.size.equalTo(CGSize(width: 16, height: 16))
            make.left.equalTo(LEFT_PADDING)
        }
        
        let pText = UILabel()
        btn.addSubview(pText)
        pText.text = self.model[i].1
        
        if kScreenW <= 320 {
            pText.font = kFont_Small
        }else{
            pText.font = kFont_Big
        }
        
        
        pText.textColor = HexColor("7A7D91")
        pText.snp.makeConstraints { (make) in
            make.centerY.equalTo(btn.snp.top).offset(22)
            make.height.equalTo(20)
            make.left.equalTo(pImage.snp.right).offset(MARGIN)
        }
        
        let pPoint = UIImageView()
        btn.addSubview(pPoint)
        pPoint.image = UIImage.init(named: "p_menu_"+self.model[i].2)
        pPoint.snp.makeConstraints { (make) in
            make.centerY.equalTo(btn.snp.top).offset(22)
            make.size.equalTo(CGSize(width: 5, height: 12))
            make.right.equalTo(-MARGIN)
        }
    }
}
