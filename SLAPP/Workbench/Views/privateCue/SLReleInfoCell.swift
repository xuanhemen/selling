//
//  SLReleInfoCell.swift
//  SLAPP
//
//  Created by 董建伟 on 2019/1/11.
//  Copyright © 2019年 柴进. All rights reserved.
//

import UIKit

class SLReleInfoCell: UITableViewCell {

    
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
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var title: UILabel = {
        let title = UILabel()
        title.text = "创建人"
        title.textColor = .gray
        self.addSubview(title)
        title.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview().offset(-80/5)
            make.left.equalToSuperview().offset(20)
        })
        return title
    }()
    lazy var content: UILabel = {
        let content = UILabel()
        content.text = "内容"
        self.addSubview(content)
        content.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview().offset(80/5)
            make.left.equalToSuperview().offset(20)
        })
        return content
    }()
    

}
