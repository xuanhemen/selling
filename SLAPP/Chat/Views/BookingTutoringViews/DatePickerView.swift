//
//  DatePickerView.swift
//  SLAPP
//
//  Created by apple on 2018/3/16.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class DatePickerView: UIView {

    var pickerResult:(_ date:Date)->() = { _ in
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.gray
        self.addSubview(picker)
        
        let line = UIView()
        self.addSubview(line)
        line.backgroundColor = UIColor.darkGray
        line.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(1)
        }
        
        let btn = UIButton.init(type: .custom)
        btn.setTitle("完成", for: .normal)
        btn.setTitleColor(kGreenColor, for: .normal)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        self.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(30)
            make.width.equalTo(50)
        }
        
        picker.backgroundColor = UIColor.groupTableViewBackground
        
        
        picker.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func btnClick(){
        self.pickerResult(picker.date)
        self.removeFromSuperview()
        
    }
    
    lazy var picker = { () -> UIDatePicker in
        let lable = UIDatePicker.init()
        lable.datePickerMode = .dateAndTime
        return lable
    }()
    
    
    
}
