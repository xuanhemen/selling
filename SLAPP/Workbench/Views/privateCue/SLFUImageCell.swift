//
//  SLFUImageCell.swift
//  SLAPP
//
//  Created by 董建伟 on 2019/1/17.
//  Copyright © 2019年 柴进. All rights reserved.
//

import UIKit

class SLFUImageCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        self.addSubview(imageView)
        imageView.snp.makeConstraints({ (make) in
         make.edges.equalToSuperview().inset(UIEdgeInsetsMake(0, 0, 0, 0))
        })
        return imageView
    }()
    lazy var addBtn: UIButton = {
        let addBtn = UIButton.init(type: UIButtonType.custom)
        addBtn.setImage(UIImage.init(named: "imageAdd"), for: UIControlState.normal)
        self.addSubview(addBtn)
        addBtn.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(0, 0, 0, 0))
        })
        return addBtn
    }()
    lazy var delete: UIButton = {
        let delete = UIButton.init(type: UIButtonType.custom)
        delete.setImage(UIImage.init(named: "imageDelete"), for: UIControlState.normal)
        self.addSubview(delete)
        delete.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
        })
        return delete
    }()
}
