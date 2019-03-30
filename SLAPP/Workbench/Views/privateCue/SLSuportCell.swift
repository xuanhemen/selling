//
//  SLSuportCell.swift
//  SLAPP
//
//  Created by 董建伟 on 2019/1/11.
//  Copyright © 2019年 柴进. All rights reserved.
//

import UIKit

class SLSuportCell: UITableViewCell {

    lazy var likeView = UIImageView.init()
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
        let bgView = UIView()
        bgView.backgroundColor = RGBA(R: 245, G: 245, B: 245, A: 1)
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(5, 50, 10, 25))
        }
        bgView.addSubview(likeView)
        likeView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var content: UILabel = {
        let content = UILabel()
        content.textColor = RGBA(R: 103, G: 119, B: 155, A: 1)
        content.font = FONT_14
        content.numberOfLines = 0
        self.addSubview(content)
        content.snp.makeConstraints({ (make) in
          make.edges.equalToSuperview().inset(UIEdgeInsetsMake(10,90, 15, 25))
        })
        return content
    }()

}
