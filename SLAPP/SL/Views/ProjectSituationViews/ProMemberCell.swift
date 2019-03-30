//
//  ProMemberCell.swift
//  SLAPP
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ProMemberCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configUI()
    }
    
    var model:MemberModel?
    var click:(String)->() = {_ in
        
    }
    
    let addBtn = UIButton.init(type: .custom)
    let deleteBtn = UIButton.init(type: .custom)
    func configUI(){
        
        self.contentView.addSubview(nameLable)
        self.contentView.addSubview(headImage)
        headImage.layer.cornerRadius = 10
        headImage.clipsToBounds = true
       
        headImage.snp.makeConstraints { [weak nameLable](make) in
            make.left.equalTo(10);
            make.right.equalTo((nameLable?.snp.left)!).offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        nameLable.snp.makeConstraints {[weak headImage] (make) in
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(14)
            make.centerY.equalTo((headImage?.snp.centerY)!)
        }
        nameLable.font = UIFont.systemFont(ofSize: 13)
        nameLable.sizeToFit()
        
        
       
        self.contentView.addSubview(addBtn)
        
        self.contentView.addSubview(deleteBtn)
        addBtn.addTarget(self, action: #selector(addClick), for: .touchUpInside)
        deleteBtn.addTarget(self, action: #selector(deleteClick), for: .touchUpInside)
        
        addBtn.setImage(UIImage.init(named: "memberAdd"), for: .normal)
        deleteBtn.setImage(UIImage.init(named: "memberDelete"), for: .normal)
        
        addBtn.snp.makeConstraints {[weak headImage] (make) in
            make.left.equalTo(10)
            make.height.width.equalTo(30)
             make.centerY.equalTo((headImage?.snp.centerY)!)
        }
        
        deleteBtn.snp.makeConstraints {[weak headImage] (make) in
            make.right.equalTo(-10)
            make.height.width.equalTo(30)
            make.centerY.equalTo((headImage?.snp.centerY)!)
        }
        
        addBtn.isHidden = true
        deleteBtn.isHidden = true
        
        self.contentView.addSubview(markImage)
        markImage.snp.makeConstraints {[weak headImage] (make) in
            make.top.equalTo((headImage?.snp.top)!).offset(-3)
            make.right.equalTo((headImage?.snp.right)!).offset(5)
            make.height.width.equalTo(10)
        }
    }
    
    lazy var markImage = { () -> UIImageView in
        let image = UIImageView()
        image.image = UIImage.init(named: "itemDelete")
        image.contentMode = .scaleAspectFit
        return image
    }()
    lazy var headImage = { () -> UIImageView in
        let image = UIImageView()
        return image
    }()
    
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 16)
        //        lable.textAlignment = .center
        //        lable.textColor =
        return lable
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configWithModel(model:MemberModel){
        self.model = model
        if model.id == "+" {
            addBtn.isHidden = false
            deleteBtn.isHidden = false
            headImage.isHidden = true
            nameLable.isHidden = true
        }else{
         nameLable.text = String.noNilStr(str: model.name)
            headImage.setHeadImage(url: model.head)
            addBtn.isHidden = true
            deleteBtn.isHidden = true
            headImage.isHidden = false
            nameLable.isHidden = false
        }
    }
    
    @objc func deleteClick(){
        self.click("-")
    }
    @objc func addClick(){
         self.click("+")
    }
    
    
    
    
//    
    
    
}
