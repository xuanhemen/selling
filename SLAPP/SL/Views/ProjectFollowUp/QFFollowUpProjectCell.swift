//
//  QFFollowUpProjectCell.swift
//  SLAPP
//
//  Created by qwp on 2018/7/18.
//  Copyright © 2018 柴进. All rights reserved.
//

import UIKit

class QFFollowUpProjectCell: UITableViewCell {

 @objc   @IBOutlet weak var backView: UIView!
 @objc   @IBOutlet weak var numLabel: UILabel!
 @objc   @IBOutlet weak var nameLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backView.layer.cornerRadius = 3
        self.backView.layer.shadowColor = HexColor("#000000").cgColor;
        self.backView.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.backView.layer.shadowOpacity = 0.1
        self.backView.layer.shadowRadius = 5;
        
        self.numLabel.layer.cornerRadius = 15
        self.numLabel.clipsToBounds = true
        
    }

    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
