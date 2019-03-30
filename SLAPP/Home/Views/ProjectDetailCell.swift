//
//  ProjectDetailCell.swift
//  SLAPP
//
//  Created by apple on 2018/2/8.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ProjectDetailCell: UITableViewCell {
    @IBOutlet weak var backView: UIView!
  
    
    @IBOutlet weak var statusImage: UIImageView!
    
    @IBOutlet weak var projectName: UILabel!
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var company: UILabel!
    
    @IBOutlet weak var amount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        backView.layer.borderWidth = 1
//        backView.layer.cornerRadius = 1
//        backView.layer.borderColor = UIColor.lightGray.cgColor
        self.amount.textColor = kGreenColor
        self.contentView.backgroundColor = UIColor.groupTableViewBackground
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
