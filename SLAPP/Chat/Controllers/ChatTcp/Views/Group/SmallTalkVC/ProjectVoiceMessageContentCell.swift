//
//  ProjectVoiceMessageContentCell.swift
//  SLAPP
//
//  Created by apple on 2018/4/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ProjectVoiceMessageContentCell: RCMessageCell {
    
    lazy var backView = { () -> UIView in
        let view = UIView()
        return view
    }()
    
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        return lable
    }()
    
    lazy var btn = { () -> UIButton in
        let btn = UIButton()
        return btn
    }()
    
    lazy var progress = { () -> UIProgressView in
        let btn = UIProgressView()
        return btn
    }()
    
    
    var click:(_ model:RCMessageModel)->() = { _ in
        
    }
    
    lazy var timeLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        //        lable.textAlignment = .center
        //        lable.textColor =
        return lable
    }()
    
    lazy var timeLableall = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        //        lable.textAlignment = .center
        //        lable.textColor =
        return lable
    }()
    
    override class func size(for model: RCMessageModel!, withCollectionViewWidth: CGFloat, referenceExtraHeight: CGFloat) -> CGSize {
        if model.isDisplayMessageTime == true{
            return super.size(for: model, withCollectionViewWidth: withCollectionViewWidth, referenceExtraHeight: 200)
        }else{
            return super.size(for: model, withCollectionViewWidth: withCollectionViewWidth, referenceExtraHeight: 120)
        }
        
    }
    
    override init!(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(backView)
        
        backView.frame = CGRect(x: 70, y: 60, width: frame.size.width-140, height: 60)
        
        backView.backgroundColor = UIColor.white
        backView.addSubview(btn)
        btn.frame = CGRect(x: 15, y:10, width: 60 , height: 60)
        btn.setImage(UIImage.init(named: "proStart"), for: .normal)
        
        backView.addSubview(nameLable)
        nameLable.frame = CGRect(x: 90 , y: 5, width: backView.width-100, height: 30)
        nameLable.numberOfLines = 0
        
        backView.addSubview(progress)
        progress.frame = CGRect(x: 90, y: 45, width: backView.width-100, height: 5)
        progress.tintColor = UIColor.green
        progress.progress = 0
        
        backView.addSubview(timeLable)
        timeLable.frame = CGRect(x: 90, y: 60, width: (backView.width-100)/2, height: 15)
        timeLable.text = "0:00"
        timeLable.textAlignment = .right
        backView.addSubview(timeLableall)
        timeLableall.frame = CGRect(x: 90+(backView.width-100)/2, y: 60, width: (backView.width-100)/2, height: 15)
        timeLableall.text = ""
        
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
    }
    
    @objc func btnClick(){
        
        self.click(self.model)
    }
    
    override func setDataModel(_ model: RCMessageModel!) {
        super.setDataModel(model)
        
        let content:ProjectVoiceMessageContent = model.content as! ProjectVoiceMessageContent
        nameLable.text = content.projectName
        
        let duration = NSString.init(string: content.duration).integerValue/1000
        timeLableall.text = "/" + "\(duration/60)" + ":" + "\(duration%60)"
        if model.isDisplayMessageTime == true{
            backView.frame = CGRect(x: 70, y: 60, width: frame.size.width-140, height: 80)
        }else{
            backView.frame = CGRect(x: 70, y: 30, width: frame.size.width-140, height: 80)
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
