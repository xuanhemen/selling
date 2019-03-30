//
//  CheckViewCell.swift
//  SLAPP
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class CheckViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.configUI()
    }
    
   
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configUI(){
        
        self.contentView.addSubview(headImage)
        self.contentView.addSubview(nameLable)
        nameLable.textAlignment = .left
        nameLable.font = UIFont.systemFont(ofSize: 14)
        nameLable.numberOfLines = 0
        headImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        nameLable.snp.makeConstraints {[weak headImage] (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalTo((headImage?.snp.right)!).offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    
    
    
    lazy var headImage = { () -> UIImageView in
        let image = UIImageView()
        image.image = UIImage.init(named: "logic_normal")
        return image
    }()
    
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        return lable
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
