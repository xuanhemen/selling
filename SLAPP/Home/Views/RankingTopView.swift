//
//  RankingTopView.swift
//  SLAPP
//
//  Created by apple on 2018/3/1.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class RankingTopView: UIView {

    var headerClick = { 
        
    }

    
    lazy var head = { () -> UIImageView in
       let image = UIImageView()
       image.image = UIImage.init(named: "mine_avatar")
       return image
    }()

    lazy var crownImage = { () -> UIImageView in
        let image = UIImageView()
//        image.image = UIImage.init(named: "crown")
        return image
    }()

    lazy var rankingImage = { () -> UIImageView in
        let image = UIImageView()
//        image.image = UIImage.init(named: "rankingImage")
        return image
    }()
    
    lazy var top = { () -> UILabel in
        let lable = UILabel()
        return lable
    }()
    
    lazy var num = { () -> UILabel in
        let lable = UILabel()
        return lable
    }()
    
    lazy var middle = { () -> UILabel in
        let lable = UILabel()
        return lable
    }()
    
    lazy var bottom = { () -> UILabel in
        let lable = UILabel()
        return lable
    }()
    
    lazy var editBtn = { () -> UIButton in
        let btn = UIButton.init(type: .custom)
        return btn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kGrayColor_Slapp
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configWithRanking(ranking:Int){
        if ranking > 0 && ranking <= 3 {
            crownImage.image = UIImage.init(named: "crown".appending("\(ranking)"))
            rankingImage.image = UIImage.init(named: "rankingImage".appending("\(ranking)"))
        }
        else{
            crownImage.image = nil
            rankingImage.image = UIImage.init(named: "rankingImage4")
            
        }
    }

    func configUI(){
     
        let backView = UIView()
        self.addSubview(backView)
        backView.addSubview(head)
        backView.addSubview(crownImage)
        backView.addSubview(rankingImage)
        backView.addSubview(top)
        backView.addSubview(middle)
        backView.addSubview(bottom)
        
        let headerBtn = UIButton()
        backView.addSubview(headerBtn)
        
        backView.snp.makeConstraints { (make) in
            make.height.equalTo(100)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(-20)
        }
        backView.backgroundColor = UIColor.white
        backView.layer.cornerRadius = 6
        
        head.snp.makeConstraints { (make) in
            make.height.width.equalTo(60)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(30)
        }
        headerBtn.snp.makeConstraints { (make) in
            make.height.width.equalTo(60)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(30)
        }
        headerBtn.addTarget(self, action: #selector(headerButtonClick(_:)), for: .touchUpInside)
        
        head.layer.cornerRadius = 30
        head.clipsToBounds = true
        crownImage.snp.makeConstraints {[weak head] (make) in
            make.height.width.equalTo(25)
            make.top.equalTo((head?.snp.top)!).offset(-10)
            make.centerX.equalTo((head?.snp.centerX)!).offset(25)
        }
        
        rankingImage.snp.makeConstraints {[weak head] (make) in
            make.height.equalTo(15)
            make.width.equalTo(80)
        make.bottom.equalTo((head?.snp.bottom)!).offset(7)
            make.centerX.equalTo((head?.snp.centerX)!)
        }
        
        rankingImage.addSubview(num)
        num.textAlignment = .center
        num.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(20)
        }
        
        top.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.left.equalToSuperview().offset(120)
            make.right.equalToSuperview().offset(-40)
            make.top.equalToSuperview().offset(10)
        }
        
        
        middle.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.left.equalToSuperview().offset(120)
            make.right.equalToSuperview().offset(-40)
            make.top.equalToSuperview().offset(40)
        }
        
        
        bottom.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.left.equalToSuperview().offset(120)
            make.right.equalToSuperview().offset(-40)
            make.top.equalToSuperview().offset(70)
        }
        
        backView.addSubview(editBtn)
        editBtn.setImage(UIImage.init(named: "ch_product_edit_icon"), for: .normal)
        editBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        
    }
    
    @objc func headerButtonClick(_ sender: Any) {
        self.headerClick()
    }
}
