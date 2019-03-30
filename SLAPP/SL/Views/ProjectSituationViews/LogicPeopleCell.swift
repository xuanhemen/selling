//
//  LogicPeopleCell.swift
//  SLAPP
//
//  Created by apple on 2018/3/22.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class LogicPeopleCell: UITableViewCell {

    var click:(_ model:LogicPeopleModel)->() = {_ in
        
    }
    
    let titleLabel = UILabel()
    let detailLabel = UILabel()
    
    lazy var red = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        //        lable.textAlignment = .center
        //        lable.textColor =
        return lable
    }()
    
    var model:LogicPeopleModel?{
        didSet{
            self.titleLabel.text = String.noNilStr(str: model?.name)
            self.detailLabel.text = String.noNilStr(str: model?.eutc_input)

        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configUI()
    }
    
    func configUI(){
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(detailLabel)
        self.contentView.addSubview(btn)
        
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = HexColor("333333")
        
        detailLabel.font = UIFont.systemFont(ofSize: 12)
        detailLabel.textColor = HexColor("666666")
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(15)
            make.height.equalTo(20)
            make.right.equalTo(-40)
        }
        //detailLabel.backgroundColor = UIColor.red
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.left.equalTo(15)
            make.height.equalTo(20)
            make.right.equalTo(-40)
        }
        
        
        btn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        btn.setImage(UIImage.init(named: "menuDelete"), for: .normal)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        self.contentView.addSubview(red)
        red.backgroundColor = UIColor.red
        red.layer.cornerRadius = 5
        red.clipsToBounds = true
        red.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-30)
            make.height.width.equalTo(10)
            
        }
        
    }
    
    
    @objc func btnClick(){
        
        if model != nil {
            self.click(model!)
        }
        
    }
    
    lazy var btn = { () -> UIButton in
        let lable = UIButton()
       
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
