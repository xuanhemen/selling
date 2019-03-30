//
//  TutoringMembersCell.swift
//  SLAPP
//
//  Created by apple on 2018/3/14.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
let cellWidth = (MAIN_SCREEN_WIDTH-100)/5
class TutoringMembersCell: UICollectionViewCell {
    
    var model:MemberModel?
    
    lazy var headImage = { () -> UIImageView in
        let image = UIImageView()
        return image
    }()
    
    lazy var markImage = { () -> UIImageView in
        let image = UIImageView()
        image.image = UIImage.init(named: "logic_normal")
        image.contentMode = .scaleAspectFit
//        image.isHidden = true
        return image
    }()
    
    
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = kFont_Middle
        //        lable.textAlignment = .center
        //        lable.textColor =
        return lable
    }()
    
    lazy var multiple = { () -> UILabel in
        let lable = UILabel()
        lable.font = kFont_Middle
        //        lable.textAlignment = .center
        //        lable.textColor =
        return lable
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configUI()
    }
    
    
    func configUI(){
        
        self.contentView.backgroundColor = UIColor.white
        self.contentView.layer.cornerRadius = 6
       
        self.contentView.addSubview(headImage)
        self.contentView.addSubview(markImage)
        self.contentView.addSubview(nameLable)
        self.contentView.addSubview(multiple)
        multiple.textColor = UIColor.orange
        
        headImage.layer.cornerRadius = (cellWidth-10)/2.0
        headImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
            make.width.height.equalTo(cellWidth-10)
        }
        headImage.clipsToBounds = true
        
        markImage.snp.makeConstraints { (make) in
                    make.top.equalTo(5)
                    make.right.equalTo(-5)
                    make.width.height.equalTo(15)
        }
        
//        markImage.snp.makeConstraints { (make) in
//            make.top.equalTo(-3)
//            make.right.equalTo(3)
//            make.width.height.equalTo(15)
//        }
        nameLable.textAlignment = .center
//        nameLable.snp.makeConstraints {[weak self] (make) in
//            make.left.equalTo(5)
//            make.right.equalTo(-5)
//            make.height.equalTo(20)
//            make.bottom.equalTo((self?.multiple.snp.top)!).offset(-5)
//        }
        
        nameLable.snp.makeConstraints {[weak self] (make) in
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.height.equalTo(15)
            make.bottom.equalTo((self?.multiple.snp.top)!).offset(-5)
        }
        multiple.textAlignment = .center
        multiple.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.height.equalTo(15)
            make.bottom.equalToSuperview().offset(-5)
        }
        
//        nameLable.text = "asdasdasd"
        
    }
    
    
    
    
    func congfigModel(model:MemberModel){
        self.model = model
        nameLable.text = model.name!
        
        if self.model?.id == "+" {
            headImage.image = UIImage.init(named: "memberAdd")
             headImage.contentMode = .center
        }else if self.model?.id == "-" {
            headImage.image = UIImage.init(named: "memberDelete")
             headImage.contentMode = .center
        }else{
            headImage.setImageWith(url: model.head, imageName: "mine_avatar")
             headImage.contentMode = .scaleAspectFit
        }
        
        if model.classStr != nil {
            multiple.text = model.classStr!.appending("倍计费")
        }else{
            multiple.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
                make.bottom.equalToSuperview().offset(0)
            })
            
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
