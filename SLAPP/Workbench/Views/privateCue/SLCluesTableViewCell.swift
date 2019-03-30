//
//  SLCluesTableViewCell.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/6.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class SLCluesTableViewCell: UITableViewCell {

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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /**人名*/
    lazy var name: UILabel = {
        let name = UILabel()
        name.textColor = UIColor.black
        name.font = UIFont.boldSystemFont(ofSize: 15)
        name.sizeToFit()
        self.addSubview(name)
        name.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview().offset(-70/5)
            make.left.equalToSuperview().offset(18)
        })
        return name
    }()
    /**电话*/
    lazy var phone: UILabel = {
        let phone = UILabel()
        phone.textColor = UIColor.gray
        phone.font = UIFont.systemFont(ofSize: 14)
        phone.sizeToFit()
        self.addSubview(phone)
        phone.snp.makeConstraints({ (make) in
            make.centerY.equalTo(name)
            make.left.equalTo(name.snp.right).offset(20)
        })
        return phone
    }()
    /**公司*/
    lazy var company: UILabel = {
        let company = UILabel()
        company.textColor = UIColor.gray
        company.font = UIFont.systemFont(ofSize: 14)
        company.sizeToFit()
        self.addSubview(company)
        company.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview().offset(70/5)
            make.left.equalToSuperview().offset(18)
            make.width.equalTo(200)
        })
        return company
    }()
    /**状态*/
    lazy var state: UILabel = {
        let state = UILabel()
        state.textColor = UIColor.black
        state.font = UIFont.systemFont(ofSize: 14)
        state.sizeToFit()
        self.addSubview(state)
        state.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-18)
        })
        return state
    }()
    /*给cell赋值*/
    func setCellWithModel(model: SLCluesModel) {
        
        self.name.text = model.name
        self.phone.text = model.phone
        self.company.text = "公司："+(model.corp_name ?? "")
        if model.status == "0" {
           self.state.text = "未跟进"
           self.state.textColor = RGBA(R: 244, G: 176, B: 81, A: 1)
        }else if model.status == "1" {
           self.state.text = "已联系"
           self.state.textColor = RGBA(R: 90, G: 198, B: 223, A: 1)
        }else if model.status == "3" {
           self.state.text = "无效信息"
           self.state.textColor = RGBA(R: 241, G: 52, B: 86, A: 1)
        }
        
    }
    
}
