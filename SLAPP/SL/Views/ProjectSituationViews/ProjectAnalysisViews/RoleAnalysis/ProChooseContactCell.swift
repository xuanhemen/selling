//
//  ProChooseContactCell.swift
//  SLAPP
//
//  Created by apple on 2018/4/3.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ProChooseContactCell: UITableViewCell {

    var model:ProAddContactModel?{
        didSet{
            nameLable.text = model?.name
            timerLable.text = model?.phone
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configUI(){
        
        self.contentView.addSubview(headImage)
        self.contentView.addSubview(nameLable)
        self.contentView.addSubview(timerLable)
        headImage.image = UIImage.init(named: "situationCellmarkNomal")
        headImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
        nameLable.snp.makeConstraints {[weak headImage] (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo((headImage?.snp.right)!).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        timerLable.snp.makeConstraints {[weak nameLable] (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo((nameLable?.snp.right)!).offset(5)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(20)
        }
        
        
       
        
    }
    
    
    
    
    lazy var headImage = { () -> UIImageView in
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
    
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
