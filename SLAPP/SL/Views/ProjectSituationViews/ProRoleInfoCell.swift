//
//  ProRoleInfoCell.swift
//  SLAPP
//
//  Created by apple on 2018/3/22.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ProRoleInfoCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI(){
        
        let view = UIView()
        self.contentView.addSubview(view)
        self.contentView.backgroundColor = UIColor.groupTableViewBackground
        view.addSubview(nameLable)
        view.addSubview(contentLable)
        view.addSubview(rightImageView)
        
        view.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-5)
        }
        view.backgroundColor = UIColor.white
//        view.layer.cornerRadius = 6
//        view.layer.borderColor = UIColor.lightGray.cgColor
//        view.layer.borderWidth = 0.5
        
        nameLable.snp.makeConstraints { (make) in
            //make.width.equalTo(100)
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
        
        rightImageView.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.right.equalTo(-5)
            make.bottom.equalTo(-5)
            make.width.equalTo(rightImageView.snp.height)
        }
        
        contentLable.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-50)
            make.left.equalTo(nameLable.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
        
    }
    
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = HexColor("#333333")
        return lable
    }()
    
    lazy var rightImageView = { () -> UIImageView in
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var contentLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = HexColor("#666666")
        return lable
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
