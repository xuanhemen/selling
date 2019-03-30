//
//  SLGroupCell.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/18.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class SLGroupCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
//    cell.textLabel?.text = model.name
//    cell.textLabel?.textColor = RGBA(R: 50, G: 50, B: 50, A: 1)
//    cell.textLabel?.font = FONT_18
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.isEnabled = false
        textField.textColor = RGBA(R: 50, G: 50, B: 50, A: 1)
        textField.font = FONT_18
        textField.keyboardType = UIKeyboardType.default
        textField.borderStyle = UITextBorderStyle.none
        self.addSubview(textField)
        textField.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 200, height: 44))
        })
        return textField
    }()
    lazy var delBtn: UIButton = {
        var delBtn = UIButton.init(type: UIButtonType.custom)
        delBtn.setImage(UIImage(named: "qfphonedel"), for: UIControlState.normal)
        //delBtn.addTarget(self, action: #selector(delGroup), for: UIControlEvents.touchUpInside)
        self.addSubview(delBtn)
        delBtn.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        })
        return delBtn
    }()
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
}
