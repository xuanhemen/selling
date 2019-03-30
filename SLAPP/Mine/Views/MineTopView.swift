//
//  MineTopView.swift
//  SLAPP
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SnapKit
class MineTopView: UIView {

    var model:Dictionary<String,Any>?
    var headClick:(_ model:Dictionary<String,Any>)->() = { _ in
        
    }
    
    lazy var headImage:UIImageView = {
       let image = UIImageView.init()
      return image
    }()
    
    
    lazy var name:UILabel = {
        let lable = UILabel.init()
        return lable
    }()
    
    
    lazy var idLable:UILabel = {
        let lable = UILabel.init()
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = UIColor.lightGray
        return lable
    }()
    
    
    lazy var company:UILabel = {
        let lable = UILabel.init()
        return lable
    }()
    
    lazy var changeBtn:UIButton = {
        let btn = UIButton.init(type: .custom)
        btn .setBackgroundImage(UIImage.init(named: "changeBtn"), for: .normal)
        btn .setBackgroundImage(UIImage.init(named: "changeBtn"), for: .highlighted)
        btn .setBackgroundImage(UIImage.init(named: "changeBtn"), for: .selected)
        return btn
    }()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kNavBarBGColor
        let top = UIView.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 110))
        top.backgroundColor = kGrayColor_Slapp
        self.addSubview(top)
        
        let bottom = UIView.init(frame: CGRect(x: 0, y: 110, width: MAIN_SCREEN_WIDTH, height: 130))
        bottom.backgroundColor = UIColor.groupTableViewBackground
        self.addSubview(bottom)
        
        
        let backView = UIButton.init(frame: CGRect(x: 20, y: 30, width: MAIN_SCREEN_WIDTH-40, height: 160))
        backView.backgroundColor = UIColor.white
        backView.layer.cornerRadius = 6
        
        backView.layer.shadowColor = UIColor.darkGray.cgColor;
        backView.layer.shadowOffset = CGSize.init(width: 5, height: 5);
        backView.layer.shadowOpacity = 0.5;
        backView.layer.shadowRadius = 5;
        
        self.addSubview(backView)
        
        
        self.headImage.frame = CGRect(x: 20, y: 20, width: 80, height: 80)
       
        self.headImage.layer.cornerRadius = 40
        self.headImage.image = UIImage.init(named: "mine_avatar")
        self.headImage.clipsToBounds = true
        backView.addSubview(self.headImage)
    
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect(x: 20, y: 20, width: 80, height: 80)
        backView.addSubview(btn)
        btn.addTarget(self, action: #selector(btnclick), for: .touchUpInside)
        backView.addTarget(self, action: #selector(btnclick), for: .touchUpInside)
        
        backView.addSubview(self.name)
        self.name.snp.makeConstraints {[weak self] (make) in
            make.top.equalTo((self?.headImage.snp.top)!).offset(10)
            make.left.equalTo((self?.headImage.snp.right)!).offset(15)
            make.right.equalTo(-15)
            make.height.equalTo(20)
        }
        
        
        backView.addSubview(self.idLable)
        self.idLable.snp.makeConstraints {[weak self] (make) in
            make.left.equalTo((self?.name)!).offset(-5)
            make.height.equalTo(30)
            make.top.equalTo((self?.name.snp.bottom)!).offset(10)
        make.width.lessThanOrEqualToSuperview().offset(-30)
        }
        
        self.idLable.layer.cornerRadius = 15
        self.idLable.layer.borderWidth = 1
        self.idLable.layer.borderColor = UIColor.lightGray.cgColor
  
        
        let line = UIView()
        self.addSubview(line)
        line.backgroundColor = UIColor.groupTableViewBackground
        line.snp.makeConstraints {[weak backView] (make) in
       make.top.equalTo(self.headImage.snp.bottom).offset(20)
            make.left.equalTo(backView!).offset(20)
            make.right.equalTo(backView!).offset(-20)
            make.height.equalTo(1)
        }
        
      self.addSubview(company)
      self.addSubview(changeBtn)
        changeBtn.isHidden = true
        company.snp.makeConstraints {[weak line,weak backView,weak self] (make) in
            make.top.equalTo(line!).offset(10)
            make.left.equalTo(backView!).offset(20)
            make.right.equalTo((self?.changeBtn.snp.left)!).offset(-20)
            make.height.equalTo(20)
        }
        
//        company.text = "所属公司:销售罗盘"
        changeBtn.snp.makeConstraints {[weak backView,weak self] (make) in
            make.centerY.equalTo((self?.company)!)
            make.right.equalTo(backView!).offset(-20)
            make.width.equalTo(60)
            make.height.equalTo(23)
        }
        
        
        
        
        
    }
    
    
    /// 刷新  添加网络数据到UI
    ///
    /// - Parameter model: <#model description#>
    func reload(model:Dictionary<String,Any>){
        
        self.model = model
      
        self.name.text = model["realname"] as? String
        self.company.text = "所属公司:" + (model["company"] as? String)!
        self.idLable.text = "   ID:" + (model["login_mobile"] as! String) + "   "
        
         headImage.sd_setImage(with: NSURL.init(string: String.noNilStr(str: model["head"]).appending(imageSuffix)) as URL?, placeholderImage: UIImage.init(named: "mine_avatar"))
        if let array:Array = (model["other_company"] as! Array<Any>) {
            if array.count > 0 {
                changeBtn.isHidden = false
                self.company.snp.updateConstraints({[weak self] (make) in
                   make.right.equalTo((self?.changeBtn.snp.left)!).offset(-20)
                })
                
            }else{
                self.company.snp.updateConstraints({[weak self] (make) in
                    make.right.equalTo((self?.changeBtn.snp.left)!).offset(60)
                })
                
            }
        }
        
    }
    
    @objc func btnclick(){
        
        if self.model != nil {
            headClick(self.model!)
        }
        
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
