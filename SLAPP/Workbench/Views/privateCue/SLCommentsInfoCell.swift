//
//  SLCommentsInfoCell.swift
//  SLAPP
//
//  Created by 董建伟 on 2019/1/14.
//  Copyright © 2019年 柴进. All rights reserved.
//

import UIKit

class SLCommentsInfoCell: UITableViewCell {

    lazy var commentPeople = UILabel()
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
        let bgView = UIView()
        bgView.backgroundColor = RGBA(R: 245, G: 245, B: 245, A: 1)
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(0, 50, 0, 25))
        }
       
    }
    lazy var content: YYLabel = {
        let content = YYLabel()
        content.textColor = RGBA(R: 103, G: 119, B: 155, A: 1)
        content.font = FONT_14
        content.numberOfLines = 0
        content.preferredMaxLayoutWidth = SCREEN_WIDTH-80
        self.addSubview(content)
        content.snp.makeConstraints({ (make) in
          make.edges.equalToSuperview().inset(UIEdgeInsetsMake(5,55, 5, 25))
        })
    
        return content
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
