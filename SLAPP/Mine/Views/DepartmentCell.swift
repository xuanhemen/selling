//
//  DepartmentCell.swift
//  SLAPP
//
//  Created by apple on 2018/2/2.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class DepartmentCell: UITableViewCell {
    
    @IBOutlet weak var headerX: NSLayoutConstraint!
    @IBOutlet weak var reSendBtn: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    
    var clickBlock = {(isReSend:Bool) in
        
    }
    var checkBlock = {(isCheck:Bool) in
        
    }
    @IBAction func checkButtonClick(_ sender: Any) {
        self.checkButton.isSelected = !self.checkButton.isSelected
        self.checkBlock(self.checkButton.isSelected)
    }
    @IBAction func reSendBtnClick(_ sender: Any) {
        clickBlock(true)
    }
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBAction func deleteBtnClick(_ sender: Any) {
        clickBlock(false)
    }
    @IBOutlet weak var bottom: UILabel!
    @IBOutlet weak var top: UILabel!
    @IBOutlet weak var headImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.white
    }

    func grayType(isGray:Bool){
        if isGray {
            self.top.textColor = UIColor.lightGray
            self.bottom.textColor = UIColor.lightGray
            self.contentView.backgroundColor = UIColor.groupTableViewBackground
        }else{
            self.top.textColor = UIColor.darkText
            self.bottom.textColor = UIColor.darkGray
            self.contentView.backgroundColor = UIColor.white
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
