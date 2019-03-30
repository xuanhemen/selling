//
//  GroupSettingTableViewHeaderItem.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 17/3/9.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
class GroupSettingTableViewHeaderItem: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.contentView.addSubview(avatarImgV)
        self.contentView.addSubview(nameLabel)
        
        avatarImgV.mas_makeConstraints { [unowned self](make) in
            make!.top.left().equalTo()(self)
            make!.size.equalTo()(CGSize(width: self.frame.size.width, height: self.frame.size.width))
        }
        nameLabel.mas_makeConstraints { [unowned self](make) in
            make!.top.equalTo()(self.avatarImgV.mas_bottom)!.offset()(5)
            make!.left.equalTo()(self.avatarImgV)
            make!.right.equalTo()(self.avatarImgV)
        }

    }
    
    var model: GroupUserModel? {
        didSet{
            if model != nil {
                let userModel : UserModelTcp? = UserModelTcp.objects(with: NSPredicate.init(format: "userid == %@", (model?.userid)!)).firstObject() as! UserModelTcp?
                
                nameLabel.text = userModel?.realname
            }else{
                nameLabel.text = ""
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //头像
    lazy var avatarImgV: UIImageView = {
        var avatarImgV = UIImageView()
        avatarImgV.layer.cornerRadius = self.frame.size.width/2
        avatarImgV.clipsToBounds = true
        avatarImgV.layer.borderWidth = 0.0
        avatarImgV.layer.borderColor = UIColor.hexString(hexString: headerBorderColor).cgColor
        return avatarImgV
    }()
    //名称
    fileprivate lazy var nameLabel: UILabel = {
        var nameLabel = UILabel()
        nameLabel.font = FONT_12
        nameLabel.textColor = UIColor.darkGray
        nameLabel.textAlignment = .center
        return nameLabel
    }()

}
