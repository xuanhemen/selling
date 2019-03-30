//
//  ProPlanDetailDefaultCell.swift
//  SLAPP
//
//  Created by qwp on 2018/5/6.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ProPlanDetailDefaultCell: UITableViewCell {

    @IBOutlet weak var nextArrow: UIImageView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    
    @IBOutlet weak var cellDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
