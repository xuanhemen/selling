//
//  CustomPoolCell.swift
//  SLAPP
//
//  Created by fank on 2018/11/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

protocol CustomPoolCellDelegate : NSObjectProtocol {
    func customPoolCellBtnClickFunc(indexPath: IndexPath, isSelected: Bool)
}

class CustomPoolCell: UITableViewCell {
    
    var indexPath : IndexPath?
    
    weak var delegate : CustomPoolCellDelegate?

    @IBOutlet weak var selectImageView: UIImageView!
    
    @IBOutlet weak var companyNameLabel: UILabel!
    
    @IBOutlet weak var sendBackTimesLabel: UILabel!
    
    @IBOutlet weak var createTimeLabel: UILabel!
    
    @IBOutlet weak var sendBackReasonLabel: UILabel!
    
    var tempCustomPoolModel : CustomPoolModel!
    
    var customPoolModel : CustomPoolModel {
        get {
            return CustomPoolModel()
        }
        set(newCustomPoolModel){
            
            self.tempCustomPoolModel = newCustomPoolModel
            
            self.companyNameLabel.text = newCustomPoolModel.companyNameString
            
            self.selectImageView.isHighlighted = newCustomPoolModel.isSelected
            
            self.sendBackTimesLabel.text = "退回：\(newCustomPoolModel.sendBackTimesString ?? "")"
            
            self.createTimeLabel.text = "创建：\((newCustomPoolModel.createTimeString ?? ""))"
            
            self.sendBackReasonLabel.text = "理由：\(newCustomPoolModel.sendBackReasonString ?? "")"
        }
    }
    
    @IBAction func selectBtnClickFunc(_ sender: UIButton) {
        
        self.selectImageView.isHighlighted = !self.selectImageView.isHighlighted
        
        if let delegate = self.delegate, let indexPath = self.indexPath {
            delegate.customPoolCellBtnClickFunc(indexPath: indexPath, isSelected: self.selectImageView.isHighlighted)
        } else {
            print("代理为空")
        }
    }
}
