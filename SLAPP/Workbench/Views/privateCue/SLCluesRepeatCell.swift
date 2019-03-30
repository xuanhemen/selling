//
//  SLCluesRepeatCell.swift
//  SLAPP
//
//  Created by 董建伟 on 2019/1/24.
//  Copyright © 2019 柴进. All rights reserved.
//

import UIKit

class SLCluesRepeatCell: UITableViewCell {

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
    lazy var name: UILabel = {
        let name = UILabel()
        name.textColor = UIColor.black
        name.font = UIFont.boldSystemFont(ofSize: 16)
        self.addSubview(name)
        name.snp.makeConstraints({ (make) in
           make.centerY.equalToSuperview().offset(-80/5)
           make.left.equalToSuperview().offset(15)
           make.width.equalTo(150)
        })
        return name
    }()
    lazy var industry: UILabel = {
        let industry = UILabel()
        industry.textColor = kTitleColor
        industry.font = FONT_16
        self.addSubview(industry)
        industry.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview().offset(80/5)
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(150)
        })
        return industry
    }()
    lazy var resName: UILabel = {
        let resName = UILabel()
        resName.textColor = kTitleColor
        resName.font = FONT_16
        self.addSubview(resName)
        resName.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview().offset(-80/5)
            make.right.equalToSuperview().offset(-15)
        })
        return resName
    }()
    lazy var addTime: UILabel = {
        let addTime = UILabel()
        addTime.textColor = kTitleColor
        addTime.font = FONT_16
        self.addSubview(addTime)
        addTime.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview().offset(80/5)
            make.right.equalToSuperview().offset(-15)
        })
        return addTime
    }()
    func setCell(model:SLConverRepeatModel) {
        self.name.text = model.name
        self.industry.text = "行业："+(model.trade_name ?? "")
        self.resName.text = "负责："+(model.realname ?? "")
        self.addTime.text = "创建："+(model.addtime ?? "")
    }

}
