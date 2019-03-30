//
//  SLAddCluesCell.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/25.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class SLAddCluesCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /**必填标识*/
    lazy var indentifier: UILabel = {
        let indentifier = UILabel()
        indentifier.text = "*"
        indentifier.textColor = UIColor.red
        indentifier.font = UIFont.systemFont(ofSize: 16)
        indentifier.sizeToFit()
        self.addSubview(indentifier)
        indentifier.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(7)
        })
        return indentifier
    }()
    /**名字*/
    lazy var name: UILabel = {
        let name = UILabel()
        name.textColor = RGBA(R: 50, G: 50, B: 50, A: 1)
        name.font = UIFont.systemFont(ofSize: 16)
        name.sizeToFit()
        self.addSubview(name)
        name.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        })
        return name
    }()
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = FONT_16
        self.addSubview(textField)
        textField.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(100)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(60)
        })
        return textField
    }()
    func setCellWithModel(model: SLAddCluesModel) {
        self.name.text = model.name
        self.textField.placeholder = "请输入\(model.name ?? "")"
        if model.isLogo == true{
            self.indentifier.isHidden = false
        }
    }

}
