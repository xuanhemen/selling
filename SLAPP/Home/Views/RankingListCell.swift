//
//  RankingListCell.swift
//  SLAPP
//
//  Created by apple on 2018/3/1.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import LFProgressView
class RankingListCell: UITableViewCell {

    var editClick = { (str:String) in
    
    }
    var headerClick = { (str:String) in
        
    }
    var userid = ""
    
    @IBOutlet weak var editBtn: UIButton!
    @IBAction func EditBtn(_ sender: UIButton) {
      
            self.editClick(userid)
        
    }
    @IBOutlet weak var progress: LDProgressView!
    
    @IBOutlet weak var medals: UIImageView!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var percent: UILabel!
    @IBOutlet weak var edit: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var head: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.groupTableViewBackground
        backview.layer.cornerRadius = 6
        head.layer.cornerRadius = 25
        head.clipsToBounds = true
        head.image = UIImage.init(named: "mine_avatar")
        
        progress.backgroundColor = UIColor.clear
        progress.background = UIColor.hexString(hexString: "ACADAE")
//        progress.type = LDProgressStripes
//        progress.showBackground = 1
        progress.animate = 1
        progress.stripeSlope = 0.5
        progress.progress = 0
        progress.flat = 1
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func headerButtonClick(_ sender: Any) {
        self.headerClick(userid)
    }
}
