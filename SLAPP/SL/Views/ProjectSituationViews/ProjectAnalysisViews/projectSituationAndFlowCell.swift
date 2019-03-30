//
//  projectSituationAndFlowCell.swift
//  SLAPP
//
//  Created by apple on 2018/3/29.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class projectSituationAndFlowCell: UITableViewCell {

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configUI(){
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.addSubview(headImage)
        self.contentView.addSubview(nameLable)
        headImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(18)
            make.height.equalTo(18)
        }
        
        nameLable.snp.makeConstraints {[weak headImage] (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo((headImage?.snp.right)!).offset(10)
            make.right.equalTo(-5)
            make.height.equalTo(40)
        }
        
        
        
    }
    
    
    
    
    lazy var headImage = { () -> UIImageView in
        let image = UIImageView()
        image.image = UIImage.init(named: "situationCellmarkNomal")
        return image
    }()
    
  @objc  lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.numberOfLines = 0
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = UIColor.white
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
