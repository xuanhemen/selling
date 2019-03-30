//
//  AddRoleAnalysisTopCell.swift
//  SLAPP
//
//  Created by apple on 2018/4/3.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class AddRoleAnalysisTopCell: AddRoleAnalysisCell {
let btn = UIButton.init(type: .custom)
    var btnClick:()->() = { 
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configUI()
    }
    
    override func configUI() {
        super.configUI()
       textField.isEnabled = true
        self.backView.snp.updateConstraints { (make) in
            make.right.equalToSuperview().offset(-100)
        }
        
        
        self.contentView.addSubview(btn)
        btn.snp.makeConstraints {[weak backView] (make) in
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.left.equalTo((backView?.snp.right)!).offset(30)
        }
        btn.setImage(UIImage.init(named: "smallHeadG"), for: .normal)
        btn.addTarget(self, action: #selector(btnclick), for: .touchUpInside)
    }
    
    @objc func btnclick(){
        btnClick()
    }
    
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
