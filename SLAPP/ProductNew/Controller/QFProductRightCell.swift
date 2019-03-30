//
//  QFProductRightCell.swift
//  SLAPP
//
//  Created by qwp on 2018/4/23.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
protocol RightCellDelegate : NSObjectProtocol{
    func rightCellMarkBtnClickWith(indexpath:IndexPath)
}
class QFProductRightCell: UITableViewCell {
    
    var delegate:RightCellDelegate?
    
    @objc var rightCellMarkBtnClick = {(indexpath:IndexPath)  in
        
    }
    
    @objc var indexPath = IndexPath()
    @objc @IBOutlet weak var markBtn: UIButton!
    @objc @IBOutlet weak var nameLable: UILabel!
    @objc @IBOutlet weak var textField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        markBtn.setImage(UIImage.init(named: "changeStage"), for: .normal)
        markBtn.setImage(UIImage.init(named: "changeStage_selected"), for: .selected)
        textField.isEnabled = false
        textField.keyboardType = .numbersAndPunctuation
        selectionStyle = .none
    }
    @IBAction func markClick(_ sender: Any) {
        //markClick(sender: sender as! UIButton)
    }
    func markClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if (sender.isSelected == true)
        {
            textField.isEnabled = true;
        }
        else
        {
            textField.isEnabled = false;
        }
        //        if (delegate != nil && delegate?.responds(to: Selector(delegate!.rightCellMarkBtnClickWith(indexpath: IndexPath()))))
        //        {
        delegate?.rightCellMarkBtnClickWith(indexpath: indexPath)
        //        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
