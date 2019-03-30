//
//  ThemeListBaseCell.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 17/6/7.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
private let headerImageViewWidth : CGFloat = 44.0
private let rightArrowWidth : CGFloat = 16.0
private let lb_rightArrow_margin : CGFloat = 5.0

class ThemeListBaseCell: RCConversationBaseCell {
    var btnClickBlock : ((_ btn: UIButton) -> ())?
    var bottomTitleImgs: Array<Array<String>>? = []
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.groupTableViewBackground

        self.contentView.addSubview(bgView)
        bgView.addSubview(headerImageView)
        bgView.addSubview(badgeLb)
        bgView.addSubview(nameLabel)
        bgView.addSubview(timeLabel)
        bgView.addSubview(detailLabel)
        bgView.addSubview(rightArrow)
        
        bgView.mas_makeConstraints { [unowned self](make) in
            make!.top.left().right().equalTo()(self)
            make!.height.equalTo()(64)
        }
        headerImageView.mas_makeConstraints { (make) in
            make!.top.left().equalTo()(LEFT_PADDING)
            make!.size.equalTo()(CGSize(width: headerImageViewWidth, height: headerImageViewWidth))
        }
        nameLabel.mas_makeConstraints { [unowned self](make) in
            make!.top.equalTo()(self.headerImageView)
            make!.left.equalTo()(self.headerImageView.mas_right)!.offset()(LEFT_PADDING)
            make!.right.equalTo()(-LEFT_PADDING - rightArrowWidth - lb_rightArrow_margin)
        }
        timeLabel.mas_makeConstraints { [unowned self](make) in
            make!.left.equalTo()(self.headerImageView.mas_right)!.offset()(LEFT_PADDING)
            make!.bottom.equalTo()(self.headerImageView)
        }
        detailLabel.mas_makeConstraints { [unowned self](make) in
            make!.left.equalTo()(self.timeLabel.mas_right)!.offset()(LEFT_PADDING)
            make!.right.equalTo()(-LEFT_PADDING - rightArrowWidth - lb_rightArrow_margin)
            make!.bottom.equalTo()(self.headerImageView)
        }
        rightArrow.mas_makeConstraints { [unowned self](make) in
            make!.centerY.equalTo()(self.headerImageView)
            make!.right.equalTo()(-LEFT_PADDING)
            make!.size.equalTo()(CGSize.init(width: rightArrowWidth, height: rightArrowWidth))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var model: RCConversationModel!{
        didSet {
            self.backgroundColor = model.isTop ? model.topCellBackgroundColor : model.cellBackgroundColor
            bgView.backgroundColor = model.isTop ? model.topCellBackgroundColor : model.cellBackgroundColor
            self.headerImageView.sd_setImage(with: NSURL.init(string: model.extend != nil ? model.extend as! String : " ") as URL?, placeholderImage: UIImage.init(named: "mine_avatar"))
            //            self.headerImageView.badgeCenterOffset = CGPoint(x : -2, y : 0)
            
            if model.unreadMessageCount > 0 {
                //                self.headerImageView.showBadge()
                self.badgeLb.isHidden = false
            }else{
                //                self.headerImageView.clearBadge()
                self.badgeLb.isHidden = true
            }
            
            self.nameLabel.text = model.conversationTitle
            
            if model.sentTime == 0 {
                self.timeLabel.text = ""
            }else{
                let target : Date = Date.init(timeIntervalSince1970: TimeInterval(model.sentTime/1000))
                self.timeLabel.text = self.convertDate(date: target)
            }
            self.timeLabel.sizeToFit()
            timeLabel.mas_updateConstraints { [unowned self](make) in
                make!.width.equalTo()(self.timeLabel.frame.size.width)
            }
            let groupModel = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",model.targetId)).firstObject() as? GroupModel
//            let groupUserModels = GroupUserModel.objects(with: NSPredicate.init(format: "groupid == %@ AND is_delete == '0'",(groupModel?.groupid)!))
//
//            let ownUserModel = GroupUserModel.objects(with: NSPredicate.init(format: "groupid == %@ AND userid == %@ AND is_delete == '0'",(groupModel?.groupid)!,(groupModel?.owner_id)!)).firstObject() as! GroupUserModel?
//            if let own = ownUserModel {
//                self.detailLabel.text = own.realname + " · \(groupModel?.is_delete == "1" ? 1 : groupUserModels.count)人参与"
//            }
            let ownUserModel = GroupUserModel.objects(with: NSPredicate.init(format: "userid == %@",(groupModel?.owner_id)!)).firstObject() as! GroupUserModel?
            let userModel : UserModelTcp? = UserModelTcp.objects(with: NSPredicate.init(format: "userid == %@", ownUserModel?.userid != nil ? (ownUserModel?.userid)! : "")).firstObject() as! UserModelTcp?

            self.detailLabel.text = userModel?.realname != nil ? (userModel?.realname)! : "" + " · " + ((groupModel?.is_delete)! == "1" ? "已解散" : ((groupModel?.user_num)! + "人参与"))
            
        }
    }
    func convertDate(date:Date) -> String {
        if Date.isToday(target: date) {
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
//        }else if Date.isLastDay(target: date) {
//            return "昨天"
//        }else if Date.isOneWeek(target: date) {
//            return Date.weekWithDateString(target: date)
        }else{
            return Date.formattDay(target: date)
        }
    }
    class func cell(withTableView tableView: UITableView) -> ThemeListBaseCell {
        //        var cell = tableView.dequeueReusableCell(withIdentifier: String(describing: self)) as? ThemeListBaseCell
        //        if cell == nil {
        //            cell = ThemeListBaseCell(style: .default, reuseIdentifier: String(describing: self))
        //            cell?.selectionStyle = .none
        //        }
        let cell = ThemeListBaseCell.init(style: .default, reuseIdentifier: String(describing: self))
        cell.selectionStyle = .none
        
        return cell
    }
    
    //MARK: - Getter and Setter
    //背景view
    lazy var bgView: UIView = {
        var bgView = UIView()
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    //头像
    lazy var headerImageView: StitchingImageView = {
        var headerImageView = StitchingImageView.init(frame: CGRect(x: 0, y: 0, width: headerImageViewWidth, height: headerImageViewWidth))
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.layer.cornerRadius = 4.0
        headerImageView.clipsToBounds = true
        headerImageView.layer.borderColor = UIColor.hexString(hexString: headerBorderColor).cgColor
        headerImageView.layer.borderWidth = 0.5
        return headerImageView
    }()
    //badgeView
    lazy var badgeLb: UILabel = {
        var badgeLb = UILabel.init()
        badgeLb.frame = CGRect.init(x: LEFT_PADDING+headerImageViewWidth - 4, y: LEFT_PADDING - 4, width: 8, height: 8)
        badgeLb.layer.cornerRadius = 4
        badgeLb.layer.masksToBounds = true
        badgeLb.backgroundColor = UIColor.red
        return badgeLb
    }()
    //名称
    lazy var nameLabel: UILabel = {
        var nameLabel = UILabel()
        nameLabel.font = FONT_14
        nameLabel.textColor = UIColor.black
        return nameLabel
    }()
    
    //时间
    lazy var timeLabel: UILabel = {
        var timeLabel = UILabel()
        timeLabel.font = FONT_12
        timeLabel.textColor = UIColor.lightGray
        timeLabel.sizeToFit()
        return timeLabel
    }()
    
    //内容
    lazy var detailLabel: UILabel = {
        var detailLabel = UILabel()
        detailLabel.font = FONT_12
        detailLabel.textColor = UIColor.lightGray
        return detailLabel
    }()

    //右箭头
    lazy var rightArrow: UIImageView = {
        var rightArrow = UIImageView()
        rightArrow.image = UIImage.init(named: "theme_rightArrow")
        return rightArrow
    }()
}
