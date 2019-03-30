//
//  SLIndustryCell.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/28.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class SLIndustryCell: UITableViewCell {

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
    /**名字*/
    lazy var name: UILabel = {
        let name = UILabel()
        name.textColor = RGBA(R: 100, G: 100, B: 100, A: 1)
        name.font = UIFont.boldSystemFont(ofSize: 15)
        name.sizeToFit()
        self.addSubview(name)
        name.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        })
        return name
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
