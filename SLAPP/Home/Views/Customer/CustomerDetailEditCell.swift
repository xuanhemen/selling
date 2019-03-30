//
//  CustomerDetailEditCell.swift
//  SLAPP
//
//  Created by rms on 2018/1/31.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class CustomerDetailEditCell: CustomerDetailBaseCell {

    var editBtn : UIButton!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        editBtn = UIButton.init()
        editBtn.backgroundColor = UIColor.orange
        editBtn.setTitle("修改所属人", for: .normal)
        self.contentView.addSubview(editBtn)
        
        editBtn.mas_makeConstraints { [unowned self](make) in
            make!.centerY.equalTo()(self)
            make!.size.equalTo()(CGSize.init(width: 100, height: 40))
            make!.right.equalTo()(-LEFT_PADDING)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var model : String!{
        didSet{
            
            detailLb.text = model
        }
    }

}
