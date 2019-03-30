//
//  CustomDetailContactsCell.swift
//  SLAPP
//
//  Created by fank on 2018/12/4.
//  Copyright © 2018年 柴进. All rights reserved.
//  客户详情 - 联系人列表

import UIKit

let SystemFont12 = UIFont.systemFont(ofSize: 12)
let SystemFont14 = UIFont.systemFont(ofSize: 14)
let BoldSystemFont14 = UIFont.boldSystemFont(ofSize: 14)

class CustomDetailContactsCell: UITableViewCell {
    
    var indexInt : Int?
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var selectImageView: UIImageView!
    
    var tempCustomDetailModel : CustomDetailModel!
    
    var customDetailModel : CustomDetailModel {
        get {
            return CustomDetailModel()
        }
        set(newCustomDetailModel){
            
            self.tempCustomDetailModel = newCustomDetailModel
            
            self.nameLabel.attributedText = NSMutableAttributedString.attributeStringWithText(textOne: newCustomDetailModel.nameString ?? "", textTwo: " | \(newCustomDetailModel.titleString ?? "")", textThree: "", colorOne: UIColor.darkGray, colorTwo: UIColor.darkGray, fontOne: BoldSystemFont14, fontTwo: SystemFont12)
            
            self.detailLabel.text = newCustomDetailModel.companyString
            
            if let selectImageView = self.selectImageView {
                selectImageView.isHighlighted = newCustomDetailModel.isSelected
            }
        }
    }
    
    @IBAction func callBtnClickFunc(_ sender: UIButton) {
        if let phone = self.tempCustomDetailModel.phoneString, let url = URL(string: "telprompt:\(phone)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func handleSelImageViewFunc(completion: (_ index: Int, _ isSelected: Bool) -> Swift.Void) {
        
        self.selectImageView.isHighlighted = !self.selectImageView.isHighlighted
        
        if let index = self.indexInt {
            completion(index, self.selectImageView.isHighlighted)
        }
    }
}
