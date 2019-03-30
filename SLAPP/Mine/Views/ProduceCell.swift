//
//  ProduceCell.swift
//  SLAPP
//
//  Created by apple on 2018/2/1.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

public enum productBtnClick : Int {
    case edit
    case delete
}

class ProduceCell: UITableViewCell {
    
    @IBAction func deleteBtn(_ sender: Any) {
        clickBlock(.delete)
    }
    
    @IBAction func editClick(_ sender: Any) {
        clickBlock(.edit)
    }
    var clickBlock = {(type:productBtnClick) in
        
    }
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var desLb: UILabel!
    @IBOutlet weak var headImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        headImage.image = UIImage.init(named: "ch_product_item_icon")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
