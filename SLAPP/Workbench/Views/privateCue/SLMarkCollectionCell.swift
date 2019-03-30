//
//  SLMarkCollectionCell.swift
//  SLAPP
//
//  Created by 董建伟 on 2019/1/7.
//  Copyright © 2019年 柴进. All rights reserved.
//

import UIKit

class SLMarkCollectionCell: UICollectionViewCell {
    
    lazy var mark: UILabel = {
        let mark = UILabel()
        mark.text = "商务"
        mark.textColor = UIColor.black
        mark.backgroundColor = RGBA(R: 245, G: 245, B: 245, A: 1)
        self.addSubview(mark)
        mark.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(50)
        })
        return mark
    }()
}
