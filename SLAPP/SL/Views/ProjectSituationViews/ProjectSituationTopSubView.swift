//
//  ProjectSituationTopSubView.swift
//  SLAPP
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ProjectSituationTopSubView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configUI()
    }
    
    func configUI(){
        self.addSubview(headImage)
        self.addSubview(nameLable)
        headImage.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        nameLable.snp.makeConstraints {[weak headImage] (make) in
            make.left.equalTo((headImage?.snp.right)!).offset(10)
            make.right.equalToSuperview().offset(-100)
            make.centerY.equalToSuperview()
        }
    }
    
    
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        return lable
    }()
    
    
    lazy var headImage = { () -> UIImageView in
        let image = UIImageView()
        return image
    }()
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
