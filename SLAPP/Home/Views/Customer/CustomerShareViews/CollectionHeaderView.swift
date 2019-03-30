//
//  CollectionHeaderView.swift
//  SLAPP
//
//  Created by apple on 2018/6/12.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(nameLable)
        nameLable.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        //        lable.textAlignment = .center
        //        lable.textColor =
        return lable
    }()
}
