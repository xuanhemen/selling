//
//  CLDropDownBtn.swift
//  CLAppWithSwift
//
//  Created by harry on 2017/7/11.
//  Copyright © 2017年 销售罗盘. All rights reserved.
//

import UIKit
import SnapKit
class CLDropDownBtn: UIButton {

     lazy var markImageView:UIImageView = {
    
        return UIImageView()
     }()
//    var
//
//
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(markImageView)
        
        markImageView.snp.makeConstraints { [unowned self](make) in
            
            make.centerY.equalTo(self)
            make.right.equalTo(self.snp.centerX).offset(-20)
            make.width.height.equalTo(15)
            
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imgDown = UIImage.init(named: "project_search_down")
    let imgUp   = UIImage.init(named: "project_search_up")
    
    
    
    /// 按钮设置
    ///
    /// - Parameter title: 按钮标题
    func configWithTitle(title:String){
        
      self.setTitle(title, for: .normal)
      self.setImage(imgDown, for: .normal)
      self.setImage(imgUp, for: .selected)
      self.setImage(imgUp, for: .highlighted)
      self.setTitleColor(UIColor.darkGray, for: .normal)
      self.setTitleColor(kGreenColor, for: .selected)
      self.setTitleColor(kGreenColor, for: .highlighted)
        
     self.titleLabel?.font = kFont_Big
     self.titleLabel?.textAlignment = .center
     self.imageView?.contentMode = .scaleAspectFit
        
//    self.titleEdgeInsets = UIEdgeInsetsMake(0, -50, 0, (self.imageView?.bounds.size.width)!)
    self.imageEdgeInsets = UIEdgeInsetsMake(0, (self.titleLabel?.bounds.size.width)!*2, 0, -(self.titleLabel?.bounds.size.width)!)
    }
    
    
    
}



