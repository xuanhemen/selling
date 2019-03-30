//
//  ProFollowUpChooseMemberCell.swift
//  SLAPP
//
//  Created by apple on 2018/6/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ProFollowUpChooseMemberCell: UITableViewCell {

    var model:MemberModel?{
        didSet{
            nameLable.text = model?.name
            headImage.setImageWith(url: (model?.head)!.appending(imageSuffix), imageName: "mine_avatar")
        }
    }
    
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
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    func configUI(){
        
        self.contentView.addSubview(markImage)
        self.contentView.addSubview(headImage)
        self.contentView.addSubview(nameLable)
        
        markImage.image = UIImage.init(named: "situationCellmarkNomal")
        markImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
        headImage.snp.makeConstraints {[weak markImage] (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo((markImage?.snp.right)!).offset(20)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        nameLable.snp.makeConstraints {[weak headImage] (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo((headImage?.snp.right)!).offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(20)
        }
        
        
        
        
        
        
    }
    
    
    lazy var headImage = { () -> UIImageView in
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "mine_avatar")
        return image
    }()
    
    
    lazy var markImage = { () -> UIImageView in
        let image = UIImageView()
        return image
    }()
    
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        return lable
    }()
    
    lazy var timerLable = { () -> UILabel in
        let lable = UILabel()
        return lable
    }()
    
}
