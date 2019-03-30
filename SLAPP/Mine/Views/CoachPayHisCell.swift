//
//  CoachPayHisCell.swift
//  SLAPP
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
class CoachPayHisCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configUI()
    }
    
    
    
    func configUI(){
        
        self.contentView.addSubview(headImage)
        self.contentView.addSubview(nameLable)
        self.contentView.addSubview(timerLable)
        self.contentView.addSubview(timeconsuming)
        self.contentView.addSubview(other)
        
        headImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(70)
            make.height.equalTo(70)
        }
        
        nameLable.snp.makeConstraints {[weak headImage,weak timeconsuming] (make) in
            make.top.equalTo((headImage?.snp.top)!)
            make.left.equalTo((headImage?.snp.right)!).offset(5)
            make.right.equalTo((timeconsuming?.snp.left)!).offset(-10)
            make.height.equalTo(20)
        }
        
        timerLable.snp.makeConstraints {[weak headImage,weak timeconsuming] (make) in
            make.left.equalTo((headImage?.snp.right)!).offset(5)
            make.right.equalTo((timeconsuming?.snp.left)!).offset(-10)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        other.snp.makeConstraints {[weak headImage,weak timeconsuming,weak timerLable] (make) in
            make.left.equalTo((headImage?.snp.right)!).offset(5)
            make.right.equalTo(-20)
            make.height.equalTo(20)
            
            make.bottom.equalTo(headImage!)
        }
        
        timeconsuming.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
    }
    
    
    
    
    lazy var headImage = { () -> UIImageView in
        let image = UIImageView()
        image.image = UIImage.init(named: "CoachPay")
        return image
    }()
    
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = kFont_Middle
        return lable
    }()
    
    lazy var timerLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = kFont_Small
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    lazy var timeconsuming = { () -> UILabel in
        let lable = UILabel()
//        lable.textAlignment = .right
        lable.font = kFont_Middle
        return lable
    }()
    
    
    lazy var other = { () -> UILabel in
        let lable = UILabel()
        //        lable.textAlignment = .right
        lable.font = kFont_Middle
        return lable
    }()
    
    var model:Dictionary<String,Any>?{
        didSet{
            
           self.nameLable.text = JSON(model!["show"]).stringValue
           self.timerLable.text = Date.timeIntervalToDateDetailStr(timeInterval: JSON(model!["begintime"]).doubleValue)
           self.timeconsuming.text = "消费时长:".appending(JSON(model!["used_hour_str"]).stringValue)
            if JSON(model!["consult_status"]).stringValue == "4" {
                other.text = "临时取消，扣除0.5小时费用给导师"
                headImage.image = #imageLiteral(resourceName: "CoachPayGray")
            }else{
                other.text = ""
                headImage.image = #imageLiteral(resourceName: "CoachPay")
                
            }
        }
        
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
