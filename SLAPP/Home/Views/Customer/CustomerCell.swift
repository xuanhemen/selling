//
//  CustomerCell.swift
//  SLAPP
//
//  Created by rms on 2018/2/1.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class CustomerCell: UITableViewCell {

    @objc let headerImage = UIImageView()
    @objc let lbCustomerName = UILabel()
    @objc let contactHeaderImage = UIImageView()
    @objc let lbContacts = UILabel()
    @objc let red = UIView()
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
        
        lbCustomerName.font = kFont_Big
        lbCustomerName.textColor = UIColor.black
        lbContacts.font = kFont_Middle
        lbContacts.textColor = UIColor.gray
        contactHeaderImage.image = UIImage.init(named: "contactIcon")
        self.contentView.addSubview(headerImage)
        self.contentView.addSubview(lbCustomerName)
        self.contentView.addSubview(contactHeaderImage)
        self.contentView.addSubview(lbContacts)
        self.addSubview(red)
        headerImage.mas_makeConstraints { [unowned self](make) in
            make!.centerY.equalTo()(self)
            make!.left.equalTo()(LEFT_PADDING)
            make!.size.equalTo()(CGSize.init(width: 45, height: 45))
        }
        
        lbCustomerName.mas_makeConstraints { [unowned self](make) in
            make!.top.equalTo()(self.headerImage)?.offset()(0)
            make!.left.equalTo()(self.headerImage.mas_right)?.offset()(LEFT_PADDING)
            make!.right.mas_equalTo()(0);
        }

        lbContacts.mas_makeConstraints { [unowned self](make) in
            make!.bottom.equalTo()(self.headerImage)?.offset()(-0)
            make!.left.equalTo()(self.headerImage.mas_right)?.offset()(LEFT_PADDING + 20)
            make!.right.equalTo()(-5)
        }
        contactHeaderImage.mas_makeConstraints { [unowned self](make) in
            make!.centerY.equalTo()(self.lbContacts)
            make!.left.equalTo()(self.headerImage.mas_right)?.offset()(LEFT_PADDING)
            make!.size.equalTo()(CGSize.init(width: 15, height: 15))
        }
        
        red.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.right.equalTo(-5)
            make.width.height.equalTo(10)
        }
        red.backgroundColor = UIColor.red
        red.layer.cornerRadius = 5
        red.clipsToBounds = true
        red.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

