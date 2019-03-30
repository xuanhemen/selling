//
//  CustomMergeCell.swift
//  SLAPP
//
//  Created by fank on 2018/12/7.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

protocol CustomMergeCellDelegate : NSObjectProtocol {
    func customMergeCellBtnClickFunc(key:String, value: String, index: Int, tag: String)
}

enum MergeShowEnum : String {
    
    case key = "key"
    case name = "name"
    case first = "first"
    case second = "second"
    case selected = "selected"
    
    var value : String {
        return self.rawValue
    }
}

class CustomMergeCell: UITableViewCell {
    
    var indexInt : Int?
    
    weak var delegate : CustomMergeCellDelegate?
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var nameOneLabel: UILabel!
    
    @IBOutlet weak var nameTwoLabel: UILabel!
    
    @IBOutlet weak var selOneImageView: UIImageView!
    
    @IBOutlet weak var selTwoImageView: UIImageView!
    
    var tempModel : StringDictionary!
    
    var model : StringDictionary {
        get {
            return [:]
        }
        set(newModel){
            
            self.tempModel = newModel
            
            self.typeLabel.text = newModel[MergeShowEnum.name.value]
            
            self.nameOneLabel.text = newModel[MergeShowEnum.first.value]
            
            self.nameTwoLabel.text = newModel[MergeShowEnum.second.value]
            
            switch newModel[MergeShowEnum.selected.value] {
            case "1":
                self.selOneImageView.isHighlighted = true
                self.selTwoImageView.isHighlighted = false
            case "2":
                self.selOneImageView.isHighlighted = false
                self.selTwoImageView.isHighlighted = true
            default:
                self.selOneImageView.isHighlighted = false
                self.selTwoImageView.isHighlighted = false
            }
        }
    }
    
    @IBAction func btnClickFunc(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            if !self.selOneImageView.isHighlighted {
                self.selOneImageView.isHighlighted = !self.selOneImageView.isHighlighted
                self.selTwoImageView.isHighlighted = !self.selOneImageView.isHighlighted
            }
        case 2:
            if !self.selTwoImageView.isHighlighted {
                self.selTwoImageView.isHighlighted = !self.selTwoImageView.isHighlighted
                self.selOneImageView.isHighlighted = !self.selTwoImageView.isHighlighted
            }
        default:
            break
        }
        
        if let delegate = self.delegate, let index = self.indexInt {
            delegate.customMergeCellBtnClickFunc(key: self.tempModel[MergeShowEnum.key.value]!, value: sender.tag == 1 ? self.tempModel[MergeShowEnum.first.value]! : self.tempModel[MergeShowEnum.second.value]!, index: index, tag: sender.tag.description)
        }
    }
}
