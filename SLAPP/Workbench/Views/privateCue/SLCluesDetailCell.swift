//
//  SLCluesDetailCell.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/5.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class SLCluesDetailCell: UITableViewCell {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
      
       
    }
    lazy var name: UILabel = {
        let name = UILabel()
        name.textColor = kTitleColor
        name.font = FONT_16
        self.addSubview(name)
        name.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        })
        return name
    }()
    lazy var content: UILabel = {
        let content = UILabel()
        content.textColor = kTitleColor
        content.font = FONT_16
        self.addSubview(content)
        content.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(name.snp.right).offset(30)
        })
        return content
    }()
   
    
}
