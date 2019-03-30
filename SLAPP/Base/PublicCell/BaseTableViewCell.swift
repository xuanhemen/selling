//
//  BaseTableViewCell.swift
//  SLAPP
//
//  Created by 柴进 on 2018/1/30.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    let lbTop = UILabel()
    let lbMid = UILabel()
    let lbBottom = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(lbTop)
        lbTop.mas_makeConstraints { (make) in
            make?.left.top().mas_equalTo()(kLbLeftTopPadding)
        }
        self.contentView.addSubview(lbMid)
        lbMid.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(kLbLeftTopPadding)
            make?.top.equalTo()(lbTop.mas_bottom)?.valueOffset()(kLbMargin as NSValue)
        }
        self.contentView.addSubview(lbBottom)
        lbBottom.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(kLbLeftTopPadding);
            make?.top.equalTo()(lbMid.mas_bottom)?.valueOffset()(kLbMargin as NSValue);
            make?.bottom.mas_equalTo()(-kLbLeftTopPadding);
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
