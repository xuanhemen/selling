//
//  SLCluesInfoTableViewCell.swift
//  SLAPP
//
//  Created by 董建伟 on 2019/1/11.
//  Copyright © 2019年 柴进. All rights reserved.
//

import UIKit

class SLCluesInfoTableViewCell: UITableViewCell {

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
    lazy var indentifier: UILabel = {
        let title = UILabel()
        title.text = "*"
        title.textColor = .red
        title.font = FONT_16
        self.addSubview(title)
        title.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(5)
        })
        return title
    }()
    lazy var title: UILabel = {
        let title = UILabel()
        title.textColor = kTitleColor
        title.font = FONT_16
        self.addSubview(title)
        title.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        })
        return title
    }()

    lazy var content: UITextField = {
        let content = UITextField()
        content.textColor = .black
        content.font = FONT_16
        content.isEnabled = false
        self.addSubview(content)
        content.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(0, 80, 0, 40))
        })
        return content
    }()

}
