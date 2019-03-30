//
//  ProLoginSituationCell.swift
//  SLAPP
//
//  Created by apple on 2018/3/22.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ProLoginSituationCell: UITableViewCell {

    var model:LogicSituationModel?{
        didSet{
            self.nameLable.text = model?.title
            self.contentLable.text = model?.shortname
        }
        
    }
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configUI()
    }
    
    
    func configUI(){
        
        self.contentView.addSubview(nameLable)
        self.contentView.addSubview(contentLable)
        self.contentView.addSubview(headImage)
        contentLable.numberOfLines = 0
        nameLable.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
            make.width.equalTo(100)
            make.height.equalTo(20)
            
        }
        //hhh
        contentLable.snp.makeConstraints {[weak nameLable] (make) in
            make.top.equalToSuperview().offset(0)
        make.left.equalTo((nameLable?.snp.right)!).offset(0)
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(0)
        }
        
        headImage.snp.makeConstraints { (make) in
           make.height.equalTo(10)
           make.width.equalTo(17)
           make.right.equalToSuperview().offset(-5)
           make.centerY.equalToSuperview()
        }
    }
    
    lazy var headImage = { () -> UIImageView in
        let image = UIImageView()
        image.image = UIImage.init(named: "p_show0")
        return image
    }()
    
    
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        return lable
    }()
    
    
    lazy var contentLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        //        lable.textAlignment = .center
        //        lable.textColor =
        return lable
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
