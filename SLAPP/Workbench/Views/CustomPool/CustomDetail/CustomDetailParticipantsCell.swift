//
//  CustomDetailParticipantsCell.swift
//  SLAPP
//
//  Created by fank on 2018/12/4.
//  Copyright © 2018年 柴进. All rights reserved.
//  客户详情 - 参与人列表

import UIKit

class CustomDetailParticipantsCell: UITableViewCell {
    
    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    var customDetailModel : CustomDetailModel {
        get {
            return CustomDetailModel()
        }
        set(newCustomDetailModel){
            
            self.headImageView.kf.setImage(with: URL(string: newCustomDetailModel.imageString?.appending(imageSuffix) ?? ""), placeholder: R.image.smallHeadG())
            
            self.nameLabel.text = newCustomDetailModel.nameString
            
            self.detailLabel.text = "\(newCustomDetailModel.titleString ?? "")  \(newCustomDetailModel.phoneString ?? "")"
        }
    }
    
}
