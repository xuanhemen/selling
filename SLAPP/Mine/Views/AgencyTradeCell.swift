//
//  AgencyTradeCell.swift
//  SLAPP
//
//  Created by apple on 2018/2/7.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class AgencyTradeCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var btnA: UIButton!
    var index:Int?
    @IBAction func BtnB(_ sender: UIButton) {
        self.click(index!,2)
    }
    @IBAction func BtnAClick(_ sender: UIButton) {
        self.click(index!,1)
    }
    
    var click = { (type:Int,Btn:Int) in


    }
    
    @IBOutlet weak var btnB: UIButton!
    @IBOutlet weak var back: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        back.layer.cornerRadius = 2
        back.layer.borderColor = UIColor.lightGray.cgColor
        back.layer.borderWidth = 0.3
        contentView.backgroundColor = UIColor.groupTableViewBackground
        btnA.titleLabel?.textAlignment = .center
        btnB.titleLabel?.textAlignment = .center
        btnA.titleLabel?.snp.updateConstraints { (make) in
            make.right.equalTo(-10)
        }
        btnB.titleLabel?.snp.updateConstraints { (make) in
            make.right.equalTo(-10)
        }
        
       
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
