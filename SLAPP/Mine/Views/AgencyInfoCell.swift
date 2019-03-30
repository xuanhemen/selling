//
//  AgencyInfoCell.swift
//  SLAPP
//
//  Created by apple on 2018/2/3.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class AgencyInfoCell: UITableViewCell {

    @IBOutlet weak var nameValue: UITextField!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var back: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        back.layer.cornerRadius = 2
        back.layer.borderColor = UIColor.lightGray.cgColor
        back.layer.borderWidth = 0.3
        contentView.backgroundColor = UIColor.groupTableViewBackground
        nameValue.placeholder = "请填写"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
