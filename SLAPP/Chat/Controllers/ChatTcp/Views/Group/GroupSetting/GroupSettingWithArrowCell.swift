//
//  GroupSettingWithArrowCell.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 17/3/9.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

class GroupSettingWithArrowCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = UIColor.white
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(detailLabel)
        self.contentView.addSubview(detailImage)
        self.contentView.addSubview(rightArrow)

        titleLabel.mas_makeConstraints { [unowned self](make) in
            make!.left.equalTo()(LEFT_PADDING_GS)
            make!.centerY.equalTo()(self)
        }
        detailLabel.mas_makeConstraints { [unowned self](make) in
            make!.left.equalTo()(self.titleLabel.mas_right)!.offset()(10)
            make!.right.equalTo()(-LEFT_PADDING_BIG)
            make!.centerY.equalTo()(self)
        }
        detailImage.mas_makeConstraints { [unowned self](make) in
            make!.right.equalTo()(-LEFT_PADDING_BIG)
            make!.centerY.equalTo()(self)
            make!.size.equalTo()(CGSize.init(width: 17, height: 17))
        }
        rightArrow.mas_makeConstraints { [unowned self](make) in
            make!.right.equalTo()(-LEFT_PADDING_GS)
            make!.centerY.equalTo()(self)
            make!.size.equalTo()(CGSize.init(width: 16, height: 16))
        }

    }
    
    var model: Any? {
        didSet{
            titleLabel.text = (model as! Dictionary<String, Any>).first?.key
            detailLabel.text = (model as! Dictionary<String, Any>).first?.value as! String?
            titleLabel.sizeToFit()
            if titleLabel.text == "群组公告" && detailLabel.text != "未设置"{
                titleLabel.mas_remakeConstraints { (make) in
                    make!.left.equalTo()(LEFT_PADDING_GS)
                    make!.top.equalTo()(12)
                    make!.width.equalTo()(titleLabel.frame.size.width)
                }
                let height = ((detailLabel.text?.getTextHeight(font: FONT_14, width: SCREEN_WIDTH - LEFT_PADDING_GS - LEFT_PADDING_BIG))! + 0.4) > 60 ? 50.5 : ((detailLabel.text?.getTextHeight(font: FONT_14, width: SCREEN_WIDTH - LEFT_PADDING_GS - LEFT_PADDING_BIG))! + 0.4)
                detailLabel.mas_remakeConstraints { [unowned self](make) in
                    make!.left.equalTo()(self.titleLabel)
                    make!.right.equalTo()(-LEFT_PADDING_BIG)
                    make!.top.equalTo()(self.titleLabel.mas_bottom)!.offset()(5)
                    make!.height.equalTo()(height)
                }
            }else{
                titleLabel.mas_remakeConstraints { [unowned self](make) in
                    make!.left.equalTo()(LEFT_PADDING_GS)
                    make!.centerY.equalTo()(self)
                    make!.width.equalTo()(self.titleLabel.frame.size.width)
                }
                if rightArrow.isHidden{
                    detailLabel.mas_remakeConstraints { [unowned self](make) in
                        make!.left.equalTo()(self.titleLabel.mas_right)!.offset()(10)
                        make!.right.equalTo()(-LEFT_PADDING_GS)
                        make!.centerY.equalTo()(self)
                    }
                }else{
                    detailLabel.mas_remakeConstraints { [unowned self](make) in
                        make!.left.equalTo()(self.titleLabel.mas_right)!.offset()(10)
                        make!.right.equalTo()(-LEFT_PADDING_BIG)
                        make!.centerY.equalTo()(self)
                    }

                }
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func cell(withTableView tableView: UITableView) -> GroupSettingWithArrowCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: String(describing: self)) as? GroupSettingWithArrowCell
        if cell == nil {
            cell = GroupSettingWithArrowCell.init(style: .default, reuseIdentifier: String(describing: self))
            cell?.selectionStyle = .none
        }
        return cell!
    }

    //MARK: - Getter and Setter
    //标题
    fileprivate lazy var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.font = FONT_16
        titleLabel.textColor = UIColor.black
        return titleLabel
    }()
    
    //内容
    lazy var detailLabel: UILabel = {
        var detailLabel = UILabel()
        detailLabel.font = FONT_14
        detailLabel.textColor = UIColor.lightGray
        detailLabel.textAlignment = .right
//        detailLabel.numberOfLines = 3
        return detailLabel
    }()
    
    //图片内容
    lazy var detailImage: UIImageView = {
        var detailImage = UIImageView()
        detailImage.image = UIImage.init(named: "二维码")
        return detailImage
    }()
    
    //箭头
    lazy var rightArrow: UIImageView = {
        var rightArrow = UIImageView()
        rightArrow.image = UIImage.init(named: "rightArrow")
        return rightArrow
    }()

}
