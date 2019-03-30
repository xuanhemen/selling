//
//  SelectMyThemeCell.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 17/7/5.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

class SelectMyThemeCell: SelectMyGroupCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(detailLabel)
        
        self.nameLabel.mas_remakeConstraints { [unowned self](make) in
            make!.top.equalTo()(self.headerImageView)
            make!.left.equalTo()(self.headerImageView.mas_right)!.offset()(LEFT_PADDING)
            make!.right.equalTo()(-LEFT_PADDING)
        }
        detailLabel.mas_makeConstraints { [unowned self](make) in
            make!.left.equalTo()(self.headerImageView.mas_right)!.offset()(LEFT_PADDING)
            make!.right.equalTo()(-LEFT_PADDING)
            make!.bottom.equalTo()(self.headerImageView)
        }
    }
    
    
    override var model : GroupModel?{
        
        didSet{
            let groupModel : GroupModel? = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",(model?.parentid)!)).firstObject() as! GroupModel?
            if let gModel = groupModel{
                detailLabel.text = "来源:" + gModel.group_name
            }else{
                detailLabel.text = "来源不详"
            }
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
       //来源
    fileprivate lazy var detailLabel: UILabel = {
        var detailLabel = UILabel()
        detailLabel.font = FONT_14
        detailLabel.textColor = UIColor.lightGray
        return detailLabel
    }()

}
