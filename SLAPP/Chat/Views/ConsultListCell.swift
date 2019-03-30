//
//  ConsultListCell.swift
//  SLAPP
//
//  Created by rms on 2018/2/2.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
private let headerViewWidth : CGFloat = 60
private let rightArrowWidth : CGFloat = 16.0
private let lb_rightArrow_margin : CGFloat = 5.0
class ConsultListCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(bgView)
        bgView.addSubview(headerView)
        bgView.addSubview(statusImageView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(detailLabel)
        bgView.addSubview(rightArrow)
        bgView.addSubview(status)
        
        bgView.mas_makeConstraints {[unowned self] (make) in
            make!.top.left().right().bottom().equalTo()(self)
        }
        headerView.mas_makeConstraints { [unowned self](make) in
            make!.left.equalTo()(LEFT_PADDING)
            make!.centerY.equalTo()(self)
            make!.size.equalTo()(CGSize(width: headerViewWidth, height: headerViewWidth))
        }
        statusImageView.mas_makeConstraints{ (make) in
            make!.right.equalTo()(headerView.mas_right)?.offset()(5)
            make!.bottom.equalTo()(headerView.mas_bottom)?.offset()(5)
            make!.size.equalTo()(CGSize(width: 15, height: 15))
        }
        nameLabel.mas_makeConstraints { [unowned self](make) in
            make!.top.equalTo()(self.headerView)?.offset()(0)
            make!.left.equalTo()(self.headerView.mas_right)!.offset()(LEFT_PADDING)
            make!.right.equalTo()(-LEFT_PADDING - rightArrowWidth - lb_rightArrow_margin)
        }

        detailLabel.mas_makeConstraints { [unowned self](make) in
            make!.left.equalTo()(self.nameLabel)
            make!.right.equalTo()(-LEFT_PADDING - rightArrowWidth - lb_rightArrow_margin)
            make?.centerY.equalTo()(self)
        }
        
        
        status.mas_makeConstraints { [unowned self](make) in
            make!.left.equalTo()(self.nameLabel)
            make?.bottom.equalTo()(self.headerView)
           
        }
        
        rightArrow.mas_makeConstraints { [unowned self](make) in
            make!.centerY.equalTo()(self.headerView)
            make!.right.equalTo()(-LEFT_PADDING)
            make!.size.equalTo()(CGSize.init(width: rightArrowWidth, height: rightArrowWidth))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var model: Dictionary<String,Any>!{
        didSet {
            DLog(model)
            
            headerView.setData(type:String.noNilStr(str: model["consult_status"]), dateStr:String.noNilStr(str: model["md"]), timeStr:String.noNilStr(str: model["hi"]))
            nameLabel.text =  String.noNilStr(str: model["project_name"])
            detailLabel.text = "辅导老师: " +  String.noNilStr(str: model["teacher_realname"]);
            if model["consult_status"] != nil {
                status.text = statusArray[Int(String.noNilStr(str: model["consult_status"]))!]
            }else if model["consult_status_name"] != nil {
                status.text = String.noNilStr(str: model["consult_status_name"])
            }

            
            self.headerView.backgroundColor = kGreenColor
            
//            if JSON(model["cate"] as Any).intValue == 3{
//                statusImageView.isHidden = false
//            }else{
//                statusImageView.isHidden = true
//            }
        }
    }
    
    
    
    override var frame: CGRect{
        didSet{
            var newFrame = frame
            newFrame.origin.x += 10
            newFrame.size.width -= 20
            newFrame.origin.y += 10
            newFrame.size.height -= 20
            super.frame = newFrame
        }
        
    }
    //MARK: - Getter and Setter
    //背景view
    lazy var bgView: UIView = {
        var bgView = UIView()
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    //头像
    lazy var headerView: ConsultListHeaderView = {
        var headerView = ConsultListHeaderView()      
        return headerView
    }()
    //状态
    lazy var statusImageView: UIImageView = {
        var statusImageView = UIImageView()
        statusImageView.image = #imageLiteral(resourceName: "qf_yellow_right")
        statusImageView.isHidden = true
        return statusImageView
    }()
    //名称
    lazy var nameLabel: UILabel = {
        var nameLabel = UILabel()
        nameLabel.font = kFont_Big
        nameLabel.textColor = UIColor.black
        return nameLabel
    }()
  
    //内容
    lazy var detailLabel: UILabel = {
        var detailLabel = UILabel()
        detailLabel.font = kFont_Middle
        detailLabel.textColor = UIColor.lightGray
        return detailLabel
    }()
    
    
    lazy var status:UILabel = {
        var detailLabel = UILabel()
        detailLabel.font = kFont_Middle
        detailLabel.textColor = UIColor.orange
        return detailLabel
        
    }()
    
    //右箭头
    lazy var rightArrow: UIImageView = {
        var rightArrow = UIImageView()
        rightArrow.image = UIImage.init(named: "ch_div_right_new")
        return rightArrow
    }()
    
    let statusArray = ["","预约中","预约成功","预约失败","取消","辅导中","辅导结束","修改待确认","取消待确认"]
}
