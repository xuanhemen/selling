//
//  DisDepCell.swift
//  SLAPP
//
//  Created by apple on 2018/6/8.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class DisDepCell: UITableViewCell {

    //点击下一层  查看子集
    var nextClick:(_ model:DepModel)->() = {_ in 
        
    }
    
//    部门model
    var dModel:DepModel?{
        didSet{
            self.nameLable.text = dModel?.name
            self.headImage.image = #imageLiteral(resourceName: "qf_depImage")
            self.timerLable.isHidden = true
            if dModel?.whether_del == "0" {
                self.arrowImage.isHidden = false
                self.btn.isHidden = false
            }else{
                self.arrowImage.isHidden = true
                self.btn.isHidden = true
            }
            
        }
    }
    
//   人员model
    var mModel:DepMemberModel?{
        didSet{
            self.nameLable.text = mModel?.realname
            self.headImage.sd_setImage(with: URL.init(string: (mModel?.head)! + imageSuffix), placeholderImage: UIImage.init(named: "mine_avatar"))
            self.timerLable.isHidden = false
            self.timerLable.text = mModel?.phone
            self.arrowImage.isHidden = true
            self.btn.isHidden = true
        }
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
        self.contentView.addSubview(timerLable)
        self.contentView.addSubview(arrowImage)
        self.contentView.addSubview(btn)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
        
        
        markImage.snp.makeConstraints { (make) in
            make.width.height.equalTo(18)
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        
        headImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(50)
            make.width.equalTo(45)
            make.height.equalTo(45)
        }
        
        nameLable.snp.makeConstraints {[weak headImage] (make) in
            make.top.equalTo((headImage?.snp.top)!)
            make.left.equalTo((headImage?.snp.right)!).offset(5)
            make.width.equalToSuperview().offset(-70)
            make.height.equalTo(20)
        }
        
        timerLable.snp.makeConstraints {[weak headImage] (make) in

            make.left.equalTo((headImage?.snp.right)!).offset(5)
            make.right.equalToSuperview().offset(-50)
            make.height.equalTo(20)
            make.bottom.equalTo(headImage!)
        }
        
        arrowImage.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        btn.snp.makeConstraints {[weak arrowImage] (make) in
            make.center.equalTo(arrowImage!)
            make.width.height.equalTo(45)
        }
        
//
//
//        timeconsuming.snp.makeConstraints { (make) in
//            make.right.equalTo(-10)
//            make.height.equalTo(20)
//            make.centerY.equalToSuperview()
//        }
        
    }
    
    @objc func btnClick(){
        
        guard self.dModel != nil else {
            return
        }
        self.nextClick(self.dModel!)
        
    }
    
    lazy var btn = { () -> UIButton in
        let btn = UIButton.init(type: .custom)
        return btn
    }()
    
    
    lazy var markImage = { () -> UIImageView in
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "dxNormal")
        return image
    }()
    
    lazy var headImage = { () -> UIImageView in
        let image = UIImageView()
    
        return image
    }()
    
    lazy var arrowImage = { () -> UIImageView in
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "qf_nextArrow")
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
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.configUI()
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
