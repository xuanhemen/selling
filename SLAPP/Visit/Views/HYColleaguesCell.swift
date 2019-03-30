//
//  HYColleaguesCell.swift
//  SLAPP
//
//  Created by apple on 2018/12/7.
//  Copyright © 2018 柴进. All rights reserved.
//

import UIKit

class HYColleaguesCell: UITableViewCell {
    
    
    var model:MemberModel?{
        didSet {
           nameLable.text = model?.name
           headImage.setImageWith(url: model?.head ?? "", imageName: "smallHeadG")
       }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configUI()
    }
    
   
    
    func configUI(){
        
        self.contentView.addSubview(markImage)
        self.contentView.addSubview(headImage)
        self.contentView.addSubview(nameLable)
        
        markImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        
        
        headImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(60)
            make.width.equalTo(45)
            make.height.equalTo(45)
        }
        
        headImage.layer.cornerRadius = 22.5;
        headImage.clipsToBounds = true
        
        nameLable.snp.makeConstraints {[weak headImage] (make) in
//            make.top.equalTo((headImage?.snp.top)!)
            make.centerY.equalToSuperview()
            make.left.equalTo((headImage?.snp.right)!).offset(15)
            make.right.equalToSuperview().offset(-15);
            make.height.equalTo(20)
        }
        
    }
    
    
    
    
    lazy var headImage = { () -> UIImageView in
        let image = UIImageView()
        return image
    }()
    
    lazy var markImage = { () -> UIImageView in
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "qf_select_statusdefault")
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
