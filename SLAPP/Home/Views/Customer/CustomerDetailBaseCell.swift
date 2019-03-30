//
//  CustomerDetailBaseCell.swift
//  SLAPP
//
//  Created by rms on 2018/1/31.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class CustomerDetailBaseCell: UITableViewCell {

    var detailLb : UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        let dotLb = UILabel.init()
        dotLb.backgroundColor = UIColor.gray
        dotLb.layer.cornerRadius = 3
        dotLb.layer.masksToBounds = true
        self.contentView.addSubview(dotLb)
        
        detailLb = UILabel.init()
        detailLb.textColor = UIColor.gray
        detailLb.font = kFont_Big
        detailLb.numberOfLines = 0
        self.contentView.addSubview(detailLb)
        
        dotLb.mas_makeConstraints { [unowned self](make) in
            make!.centerY.equalTo()(self)
            make!.left.equalTo()(LEFT_PADDING)
            make!.size.equalTo()(CGSize.init(width: 6, height: 6))
        }
        detailLb.mas_makeConstraints { [unowned self](make) in
            make!.centerY.equalTo()(self)
            make!.left.equalTo()(dotLb.mas_right)?.offset()(5)
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
