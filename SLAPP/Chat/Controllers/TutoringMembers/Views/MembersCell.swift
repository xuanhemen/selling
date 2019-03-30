//
//  MembersCell.swift
//  SLAPP
//
//  Created by apple on 2018/3/16.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class MembersCell: TutoringMembersCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        markImage.image = UIImage.init(named: "itemDelete")
        markImage.snp.updateConstraints { (make) in
            make.top.equalTo(-3)
            make.right.equalTo(3)
            make.width.height.equalTo(15)
        }
        
        multiple.snp.updateConstraints { (make) in
            make.height.equalTo(0)
            make.bottom.equalToSuperview().offset(0)
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
