//
//  MyCustomListCell.swift
//  SLAPP
//
//  Created by fank on 2018/12/5.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class MyCustomListCell: UITableViewCell {
    
    var indexInt : Int?
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var recycleLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var selectImageView: UIImageView!
    
    @IBOutlet weak var redPointLabel: UIView!
    
    var myCustomListModel : MyCustomListModel {
        get {
            return MyCustomListModel()
        }
        set(newMyCustomListModel){
            
            self.nameLabel.text = newMyCustomListModel.nameString
            
            self.recycleLabel.text = newMyCustomListModel.recycleString
            
            if let address = newMyCustomListModel.addressString {
                self.addressLabel.text = address
            }
            
            if let time = newMyCustomListModel.timeString {
                self.timeLabel.text = "创建：\(time)"
            }
            
            if let msgCount = newMyCustomListModel.msgCountString, let value = Int(msgCount) {
                self.redPointLabel.isHidden = value > 0 ? false : true
            }
            
            if let foCount = newMyCustomListModel.foCountString, let value = Int(foCount) {
                self.redPointLabel.isHidden = value > 0 ? false : true
            }
            
            if let _ = self.selectImageView {
                self.selectImageView.isHighlighted = newMyCustomListModel.isSelected
            }
        }
    }
    
    func handleSelImageViewFunc(completion: (_ index: Int, _ isSelected: Bool) -> Swift.Void) {
        
        self.selectImageView.isHighlighted = !self.selectImageView.isHighlighted
        
        if let index = self.indexInt {
            completion(index, self.selectImageView.isHighlighted)
        }
    }
}
