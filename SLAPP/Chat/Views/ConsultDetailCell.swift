//
//  ConsultDetailCell.swift
//  SLAPP
//
//  Created by rms on 2018/2/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ConsultDetailCell: UITableViewCell {

    var detailLb : UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none

        detailLb = UILabel.init()
        detailLb.textColor = UIColor.black
        detailLb.font = kFont_Big
        self.contentView.addSubview(detailLb)
        
        detailLb.mas_makeConstraints { [unowned self](make) in
            make!.centerY.equalTo()(self)
            make!.left.equalTo()(LEFT_PADDING)
            make!.right.equalTo()(-LEFT_PADDING)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model : String!{
        didSet{
            
            detailLb.text = model
        }
    }

}
