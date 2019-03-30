//
//  TutoringTopCell.swift
//  SLAPP
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class TutoringTopCell: UICollectionViewCell {
    lazy var headImage = { () -> UIImageView in
        let image = UIImageView()
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(headImage)
        headImage.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        headImage.layer.cornerRadius = 20
        headImage.clipsToBounds = true
    }
    
    
    func congfigModel(model:MemberModel){
//        self.model = model
//        nameLable.text = model.name!
        headImage.setHeadImage(url: model.head)
        
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
