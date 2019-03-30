//
//  SLPublicCluesPoolCell.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/21.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class SLPublicCluesPoolCell: UITableViewCell {

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
     /**button*/
    lazy var selectBtn: UIButton = {
        let selectBtn = UIButton.init(type: UIButtonType.custom)
        selectBtn.setImage(UIImage(named: "qf_select_statusdefault"), for: UIControlState.normal)
        selectBtn.setImage(UIImage(named: "qf_select_statuschoose"), for: UIControlState.selected)
        self.addSubview(selectBtn)
        selectBtn.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        })
        return selectBtn
    }()
    /**名字*/
    lazy var name: UILabel = {
        let name = UILabel()
        name.textColor = RGBA(R: 50, G: 50, B: 50, A: 1)
        name.font = UIFont.boldSystemFont(ofSize: 16)
        name.sizeToFit()
        self.addSubview(name)
        name.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview().offset(-70/5)
            make.left.equalToSuperview().offset(50)
        })
        return name
    }()
    /**公司*/
    lazy var company: UILabel = {
        let company = UILabel()
        company.textColor = RGBA(R: 50, G: 50, B: 50, A: 1)
        company.font = UIFont.systemFont(ofSize: 14)
        company.sizeToFit()
        self.addSubview(company)
        company.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview().offset(70/5)
            make.left.equalToSuperview().offset(50)
            make.width.equalTo(200)
        })
        return company
    }()
    /**退回次数*/
    lazy var returnCount: UILabel = {
        let returnCount = UILabel()
        returnCount.textColor = RGBA(R: 100, G: 100, B: 100, A: 1)
        returnCount.font = UIFont.systemFont(ofSize: 14)
        returnCount.sizeToFit()
        self.addSubview(returnCount)
        returnCount.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview().offset(-70/5)
            make.right.equalToSuperview().offset(-10)
        })
        return returnCount
    }()
    /**时间*/
    lazy var time: UILabel = {
        let time = UILabel()
        time.textColor = RGBA(R: 100, G: 100, B: 100, A: 1)
        time.font = UIFont.systemFont(ofSize: 14)
        time.sizeToFit()
        self.addSubview(time)
        time.snp.makeConstraints({ (make) in
             make.centerY.equalToSuperview().offset(70/5)
            make.right.equalToSuperview().offset(-10)
        })
        return time
    }()
    /**设置cell*/
//    func setCellWithModel(model: SLPublicModel) {
//        self.name.text = model.name
//        self.company.text = model.corp_name
//        self.returnCount.text = "退回：\(model.return_times!)次"
//        let string = NSString.init(string: model.addtime_str!)
//        let time = string.substring(to: 10)
//        self.time.text = time
//    }
    func setCellWithModel(model: SLPublicModel) {
        self.name.text = model.name
        self.company.text = model.corp_name
        self.returnCount.text = "退回：\(model.return_times ?? "0")次"
        let string = NSString.init(string: model.addtime_str ?? "")
        if string.length==0 {
            self.time.text = ""
        }else{
            let time = string.substring(to: 10)
            self.time.text = time
        }
       
    }

}
