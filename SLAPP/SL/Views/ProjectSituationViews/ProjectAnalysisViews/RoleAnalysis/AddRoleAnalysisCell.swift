//
//  AddRoleAnalysisCell.swift
//  SLAPP
//
//  Created by apple on 2018/3/29.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class AddRoleAnalysisCell: UITableViewCell {
     let backView = UIView.init()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configUI(){
        
        self.contentView.backgroundColor = UIColor.groupTableViewBackground
        self.backgroundColor = UIColor.groupTableViewBackground
        
        self.contentView.addSubview(backView)
        backView.backgroundColor = UIColor.white
        backView.layer.borderColor = UIColor.lightText.cgColor
        backView.layer.borderWidth = 0.3
        
        backView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        backView.addSubview(nameLable)
        backView.addSubview(textField)
        
        nameLable.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(3)
            make.width.lessThanOrEqualTo(120)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        textField.isEnabled = false
        textField.snp.makeConstraints {[weak nameLable] (make) in
            make.left.equalTo((nameLable?.snp.right)!).offset(3)
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
    }
    

    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        return lable
    }()
    
    
    lazy var textField = { () -> UITextField in
        let lable = UITextField()
        lable.font = UIFont.systemFont(ofSize: 14)
        return lable
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
