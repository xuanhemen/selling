//
//  ProBublesCell.swift
//  SLAPP
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ProBublesCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        let backView = UIView.init()
        backView.backgroundColor = kBackGreen
        self.contentView.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        backView.addSubview(nameLable)
        nameLable.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
        nameLable.textColor = UIColor.white
        nameLable.numberOfLines = 0
        self.contentView.backgroundColor = UIColor.groupTableViewBackground
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        return lable
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
