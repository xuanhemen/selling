//
//  SelectMyGroupCell.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 17/4/21.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
private let headerImageViewWidth : CGFloat = 35.0
class SelectMyGroupCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(headerImageView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(selectImageView)
        self.hiddenSelectImage = true
        
        selectImageView.mas_makeConstraints { [unowned self](make) in
            make!.left.equalTo()(LEFT_PADDING)
            make!.size.equalTo()(CGSize(width: 15, height: 15))
            make!.centerY.equalTo()(self)
        }
        headerImageView.mas_makeConstraints { [unowned self](make) in
            make!.top.equalTo()(5)
            make!.left.equalTo()(self.selectImageView.mas_right)!.offset()(LEFT_PADDING)
//            make!.size.equalTo()(CGSize(width: self.frame.size.height - 10, height: self.frame.size.height - 10))
            make!.centerY.equalTo()(self)
            make!.width.equalTo()(self.headerImageView.mas_height)
        }
        nameLabel.mas_makeConstraints { [unowned self](make) in
            make!.left.equalTo()(self.headerImageView.mas_right)!.offset()(LEFT_PADDING)
            make!.centerY.equalTo()(self)
            make!.right.equalTo()(-LEFT_PADDING)
        }
        
    }

    var model : GroupModel?{
    
        didSet{
            headerImageView.sd_setImage(with: NSURL.init(string: (model?.icon_url)!) as URL?, placeholderImage: UIImage.init(named: "mine_avatar"))
            nameLabel.text = model?.group_name
        
        }
    
    }
    var hiddenSelectImage : Bool?{
        
        didSet{
            self.selectImageView.isHidden = hiddenSelectImage!
            headerImageView.mas_updateConstraints { [unowned self](make) in
                if self.hiddenSelectImage! {
                    make!.left.equalTo()(LEFT_PADDING)
                }else{
                    make!.left.equalTo()(self.selectImageView.mas_right)!.offset()(LEFT_PADDING)
                }
            }

        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Getter and Setter
    //头像
    var headerImageView: StitchingImageView = {
        var headerImageView = StitchingImageView.init(frame: CGRect(x: 0, y: 0, width: headerImageViewWidth, height: headerImageViewWidth))
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.layer.cornerRadius = 4.0
        headerImageView.clipsToBounds = true
        headerImageView.layer.borderColor = UIColor.hexString(hexString: headerBorderColor).cgColor
        headerImageView.layer.borderWidth = 0.5
        return headerImageView
    }()
    //名称
    lazy var nameLabel: UILabel = {
        var nameLabel = UILabel()
        nameLabel.font = FONT_14
        nameLabel.textColor = UIColor.black
        return nameLabel
    }()
    //选择状态icon
    var selectImageView: UIImageView = {
        var selectImageView = UIImageView.init()
        selectImageView.contentMode = .scaleAspectFit
        selectImageView.image = UIImage.init(named: "logic_normal")
        return selectImageView
    }()

}
