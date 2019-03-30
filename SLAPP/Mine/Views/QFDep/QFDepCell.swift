//
//  QFDepCell.swift
//  SLAPP
//
//  Created by qwp on 2018/5/7.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class QFDepCell: UITableViewCell {

    var editButtonSelect:() -> () = {
    
    }
    var delete:() -> () = {
        
    }
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.cellImageView.image = UIImage.init(imageLiteralResourceName: "default_collection_portrait.png")
    }

    @IBAction func deleteButtonClick(_ sender: Any) {
        self.delete()
    }
    @IBAction func editButtonClick(_ sender: Any) {
        self.editButtonSelect()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
