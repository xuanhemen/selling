//
//  CustomerBottomView.swift
//  SLAPP
//
//  Created by apple on 2018/6/12.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class CustomerBottomView: UIView {

    /// 取消按钮点击事件的回调
    var cancleBtnClickBlock : (()->())?
    /// 保存按钮点击事件的回调
    var saveBtnClickBlock : (()->())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configUI(){
      let cancleBtn = UIButton.init(frame: CGRect.init(x: 0, y:0, width: frame.size.width * 0.5, height: 40))
        cancleBtn.setTitle("取消", for: .normal)
        cancleBtn.backgroundColor = UIColor.gray
        cancleBtn.addTarget(self, action:  #selector(cancleBtnClick), for: .touchUpInside)
      let saveBtn = UIButton.init(frame: CGRect.init(x: frame.size.width * 0.5, y:0, width: frame.size.width * 0.5, height: 40))
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.backgroundColor = UIColor.init(hexString: "30b475")
        saveBtn.addTarget(self, action:  #selector(saveBtnClick), for: .touchUpInside)
        self.addSubview(cancleBtn)
        self.addSubview(saveBtn)
        
    }
    
    @objc func saveBtnClick(btn:UIButton)  {
        if self.saveBtnClickBlock != nil {
            self.saveBtnClickBlock!()
        }
    }
    @objc func cancleBtnClick(btn:UIButton)  {
        if self.cancleBtnClickBlock != nil {
            self.cancleBtnClickBlock!()
        }
    }
    
}
