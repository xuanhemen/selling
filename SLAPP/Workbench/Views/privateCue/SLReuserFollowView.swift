//
//  SLReuserFollowView.swift
//  SLAPP
//
//  Created by 董建伟 on 2019/1/17.
//  Copyright © 2019年 柴进. All rights reserved.
//

import UIKit

class SLReuserFollowView: UICollectionReusableView {
    
    lazy var content = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        let button = UIButton.init(type: .custom)
        button.backgroundColor = .white
        button.layer.masksToBounds = true
        button.layer.borderColor = RGBA(R: 233, G: 233, B: 233, A: 1).cgColor
        button.layer.borderWidth = 0.5
        self.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(20, -1, 20, -1))
        }
        
        let imageView = UIImageView.init()
        imageView.image = image("workbenchNomal")
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        let title = UILabel()
        title.text = "所属分类"
        title.textColor = kTitleColor
        title.font = FONT_16
        self.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(imageView.snp.right).offset(10)
        }
        content.text = "标签"
        content.textColor = kTitleColor
        content.font = FONT_16
        self.addSubview(content)
        content.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //    lazy var btn: UIButton = {
//        let btn = UIButton.init(type: UIButtonType.custom)
//        bt
//        return <#value#>
//    }()
}
