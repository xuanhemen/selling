//
//  QFTeacherHeaderView.swift
//  SLAPP
//
//  Created by qwp on 2018/4/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class QFTeacherHeaderView: UIView {
    
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let zhichengLabel = UILabel()
    let backView = UIView()
    let starView = UIView()
    
    
    func setData(name:String,zhicheng:String,imageString:String,star:Float) {
        self.zhichengLabel.text = zhicheng
        self.nameLabel.text = name
        self.imageView.sd_setImage(with: NSURL.init(string: imageString) as URL?, placeholderImage: UIImage.init(named: "mine_avatar"))
        self.configStarView(star: star, fatherView: backView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let blackView = UIView()
        blackView.backgroundColor = UIColor.init(red: 38/255.0, green: 40/255.0, blue: 50/255.0, alpha: 1)
        self.addSubview(blackView)
        blackView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(SCREEN_WIDTH/4.4-10)
        }
        
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        whiteView.alpha = 0.97
        whiteView.layer.cornerRadius = 2
        self.addSubview(whiteView)
        whiteView.snp.makeConstraints { (make) in
            make.left.top.equalTo(10)
            make.right.bottom.equalTo(-10)
        }
        
        backView.backgroundColor = .clear
        self.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.left.top.equalTo(10)
            make.right.bottom.equalTo(-10)
        }
        
        self.imageView.layer.cornerRadius = (SCREEN_WIDTH/2.2-60)/2
        backView.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (make) in
            make.left.top.equalTo(20)
            make.bottom.equalTo(-20)
            make.width.equalTo(self.imageView.snp.height)
        }
        backView.addSubview(nameLabel)
        nameLabel.text = "章往力"
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .black)
        nameLabel.textColor = HexColor("#333333")
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(25)
            make.left.equalTo(self.imageView.snp.right).offset(20)
            make.height.equalTo(25)
            make.right.equalTo(-20)
        }
        
        backView.addSubview(zhichengLabel)
        zhichengLabel.text = "银河公司销售副总裁"
        zhichengLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        zhichengLabel.textColor = HexColor("#666666")
        zhichengLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(10)
            make.left.equalTo(self.imageView.snp.right).offset(20)
            make.height.equalTo(20)
            make.right.equalTo(-20)
        }
        
        
        self.configStarView(star: 5, fatherView: backView)
    }
    
    func configStarView(star:Float,fatherView:UIView){
        
        starView.removeFromSuperview()
        
        starView.frame = CGRect(x: SCREEN_WIDTH/2.2-20, y: SCREEN_WIDTH/2.2-75, width: 150, height: 30)
        fatherView.addSubview(starView)
        
        let starViewWidth = starView.frame.size.width/5
        
        let imgV_WH : CGFloat = starViewWidth > 20 ? 20 : starViewWidth
        let imgV_Margin : CGFloat = 5
        for i in 1...5 {
            let imgV1 = UIImageView.init(frame: CGRect.init(x: (imgV_WH + imgV_Margin) * CGFloat(i-1), y: 5, width: imgV_WH/2, height: imgV_WH))
            let imgV2 = UIImageView.init(frame: CGRect.init(x: (imgV_WH + imgV_Margin) * CGFloat(i-1) + imgV_WH/2, y: 5, width: imgV_WH/2, height: imgV_WH))
            
            if Float(i) < Float(star)  {
                imgV1.image = UIImage.init(named: "star_select_left")
                imgV2.image = UIImage.init(named: "star_select_right")
            }else{
                if (Float(i) - 0.5) < Float(star){
                    imgV1.image = UIImage.init(named: "star_select_left")
                    if (Float(i) - 0.25) < Float(star){
                        imgV2.image = UIImage.init(named: "star_select_right")
                    }else{
                        imgV2.image = UIImage.init(named: "star_normal_right")
                    }
                }else{
                    if (Float(i) - 0.75) < Float(star){
                        imgV1.image = UIImage.init(named: "star_select_left")
                    }else{
                        imgV1.image = UIImage.init(named: "star_normal_left")
                    }
                    imgV2.image = UIImage.init(named: "star_normal_right")
                }
            }
            starView.addSubview(imgV1)
            starView.addSubview(imgV2)
        }
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
