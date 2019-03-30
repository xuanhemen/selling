//
//  QFChooseDepCell.swift
//  SLAPP
//
//  Created by qwp on 2018/6/8.
//  Copyright © 2018 柴进. All rights reserved.
//

import UIKit

class QFChooseDepCell: UITableViewCell {

    
    var nextButtonSelect:() -> () = {
        
    }
    @IBOutlet weak var nextImage: UIImageView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBAction func chooseNext(_ sender: Any) {
        self.nextButtonSelect()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
