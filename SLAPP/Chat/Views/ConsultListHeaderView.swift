//
//  ConsultListHeaderView.swift
//  SLAPP
//
//  Created by rms on 2018/2/2.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ConsultListHeaderView: UIView {

    let dateLb = UILabel.init()
    let timeLb = UILabel.init()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.layer.cornerRadius = 2
        self.layer.masksToBounds = true
  
        let imageV = UIImageView.init()
//        imageV.backgroundColor = UIColor.red
        imageV.image = UIImage.init(named: "date")
        self.addSubview(imageV)
        
        dateLb.font = kFont_Small
        dateLb.textColor = UIColor.white
        self.addSubview(dateLb)
        
        timeLb.font = kFont_Small
        timeLb.textColor = UIColor.white
        self.addSubview(timeLb)
        
        imageV.mas_makeConstraints { [weak self](make) in
            make!.top.equalTo()(5)
            make!.centerX.equalTo()(self!)
            make!.size.equalTo()(CGSize.init(width: 20, height: 20))
        }
        
        dateLb.mas_makeConstraints { [weak self](make) in
            make!.top.equalTo()(imageV.mas_bottom)?.offset()(5)
            make!.centerX.equalTo()(self!)
        }
        
        timeLb.mas_makeConstraints {[weak self] (make) in
            make!.top.equalTo()(dateLb.mas_bottom)?.offset()(0)
            make!.centerX.equalTo()(self!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setData(type : String,dateStr : String,timeStr : String)  {
        //状态明细：1：预约中；2：预约成功; 3:预约失败；4：取消; 5:辅导中；6：辅导结束；7：修改待确认；8：取消待确认
        switch type {
        case "1":
            self.backgroundColor = HexColor("A0A0A0")
        case "2":
            self.backgroundColor = kOrangeColor
        case "5","6":
            self.backgroundColor = kGreenColor
        default:
            self.backgroundColor = HexColor("A0A0A0")
            break
        }
        
        dateLb.text = dateStr
        timeLb.text = timeStr
    }
   
}
