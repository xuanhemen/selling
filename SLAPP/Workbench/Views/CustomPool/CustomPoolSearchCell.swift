//
//  CustomPoolSearchCell.swift
//  SLAPP
//
//  Created by fank on 2018/11/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class CustomPoolSearchCell: UITableViewCell {

    @IBOutlet weak var companyNameLabel: UILabel!
    
    @IBOutlet weak var sendBackTimesLabel: UILabel!
    
    @IBOutlet weak var createTimeLabel: UILabel!
    
    @IBOutlet weak var sendBackReasonLabel: UILabel!
    
    var customPoolModel : CustomPoolModel {
        get {
            return CustomPoolModel()
        }
        set(newCustomPoolModel){
            
            self.companyNameLabel.text = newCustomPoolModel.companyNameString
            
            self.sendBackTimesLabel.text = "退回：\(newCustomPoolModel.sendBackTimesString ?? "")"
            
            self.createTimeLabel.text = "创建：\((newCustomPoolModel.createTimeString ?? ""))"
            
            self.sendBackReasonLabel.text = "理由：\(newCustomPoolModel.sendBackReasonString ?? "")"
        }
    }

}
