//
//  CommissionTableViewCell.swift
//  SLAPP
//
//  Created by rms on 2018/2/2.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class CommissionTableViewCell: UITableViewCell {

    var dotLb : UILabel!
    var detailLb : UILabel!
    var dateLb : UILabel!
    var topLineV : UIView!
    var bottomLineV : UIView!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        dotLb = UILabel.init()
        dotLb.layer.cornerRadius = 5
        dotLb.layer.masksToBounds = true
        self.contentView.addSubview(dotLb)
        
        detailLb = UILabel.init(frame: CGRect.zero)
        detailLb.numberOfLines = 0
        detailLb.textColor = UIColor.black
        detailLb.font = kFont_Big
        self.contentView.addSubview(detailLb)
        
        let dateImageV = UIImageView.init()
        dateImageV.image = UIImage.init(named: "time")
        self.contentView.addSubview(dateImageV)
        
        dateLb = UILabel.init()
        dateLb.textColor = UIColor.gray
        dateLb.font = kFont_Small
        self.contentView.addSubview(dateLb)
        
        topLineV = UIView.init()
        topLineV.backgroundColor = kGreenColor
        self.contentView.addSubview(topLineV)

        bottomLineV = UIView.init()
        bottomLineV.backgroundColor = kGreenColor
        self.contentView.addSubview(bottomLineV)
        
        
        dotLb.mas_makeConstraints { (make) in
            make!.top.equalTo()(25)
            make!.left.equalTo()(LEFT_PADDING)
            make!.size.equalTo()(CGSize.init(width: 10, height: 10))
        }
        detailLb.mas_makeConstraints { [unowned self](make) in
            make!.top.equalTo()(20)
            make!.left.equalTo()(self.dotLb.mas_right)?.offset()(10)
            make!.right.equalTo()(-LEFT_PADDING)
        }
        dateLb.mas_makeConstraints { [unowned self](make) in
            make!.top.equalTo()(self.detailLb.mas_bottom)?.offset()(10)
            make!.left.equalTo()(self.detailLb)?.offset()(15)
            make!.right.equalTo()(-LEFT_PADDING)
            make!.bottom.equalTo()(-20)
        }
        dateImageV.mas_makeConstraints { [unowned self](make) in
            make!.centerY.equalTo()(self.dateLb)
            make!.left.equalTo()(self.detailLb)
            make!.size.equalTo()(CGSize.init(width: 10, height: 10))
        }
        topLineV.mas_makeConstraints { [unowned self](make) in
            make!.top.equalTo()(self)
            make!.centerX.equalTo()(self.dotLb)
            make!.bottom.equalTo()(self.dotLb.mas_top)
            make!.width.equalTo()(0.5)
        }
        bottomLineV.mas_makeConstraints { [unowned self](make) in
            make!.bottom.equalTo()(self)
            make!.centerX.equalTo()(self.dotLb)
            make!.top.equalTo()(self.dotLb.mas_bottom)
            make!.width.equalTo()(0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model : Dictionary<String,Any>!{
        didSet{
            DLog(model)
            detailLb.text = String.noNilStr(str: model["content"])
            detailLb.changeLineSpace(text: detailLb.text!, space: textLineSpace)
            dateLb.text =  String.noNilStr(str: model["date_time"])
        }
    }
    
}

