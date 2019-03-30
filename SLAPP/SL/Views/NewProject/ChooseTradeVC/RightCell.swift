//
//  RightCell.swift
//  SLAPP
//
//  Created by 柴进 on 2018/4/12.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class RightCell: UITableViewCell {

    @IBOutlet weak var markImage: UIImageView!
    @IBOutlet weak var lable: UILabel!
    
    var isNewSelected = false{
        didSet{
            if isNewSelected {
                markImage.image = UIImage.init(named: "changeStage_selected")
                lable.textColor = kGreenColor
            }else{
                markImage.image = UIImage.init(named: "changeStage")
                lable.textColor = UIColor.darkText
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
