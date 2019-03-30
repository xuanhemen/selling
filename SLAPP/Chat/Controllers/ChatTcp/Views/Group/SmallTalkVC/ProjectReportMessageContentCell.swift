//
//  ProjectReportMessageContentCell.swift
//  SLAPP
//
//  Created by apple on 2018/4/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
class ProjectReportMessageContentCell: RCMessageCell {
    var topArray:Array<UILabel> = Array()
     var bottomArray:Array<UILabel> = Array()
    lazy var backView = { () -> UIView in
        let view = UIView()
        return view
    }()
    
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        //        lable.textAlignment = .center
        //        lable.textColor =
        return lable
    }()
    
    
    override class func size(for model: RCMessageModel!, withCollectionViewWidth: CGFloat, referenceExtraHeight: CGFloat) -> CGSize {
        
        if model.isDisplayMessageTime == true{
           return super.size(for: model, withCollectionViewWidth: withCollectionViewWidth, referenceExtraHeight: 280)
        }else{
            
            return super.size(for: model, withCollectionViewWidth: withCollectionViewWidth, referenceExtraHeight: 280)
        }
        
        
    }
    
    override init!(frame: CGRect) {
        super.init(frame: frame)
        
         self.contentView.addSubview(backView)
        //self.contentView.backgroundColor = .black
        backView.frame = CGRect(x: 70, y: 60, width: frame.size.width-140, height: 200)
        
        
        
//        backView.snp.makeConstraints { (make) in
//            make.top.equalTo(0)
//            if self.portraitImageView.frame.x > 100{
//                make.left.equalTo(0)
//            }else{
//                make.right.equalTo(self.portra)
//            }
//            
//            
//        }
        
         backView.backgroundColor = UIColor.white
         backView.addSubview(nameLable)
         nameLable.frame = CGRect(x: 5, y: 5, width: backView.width, height: 30)
         nameLable.text = "项目分析报告"
        let width = (backView.width - 4*10)/3
        let height = backView.height - 90
        let array = ["项目得分","赢单指数","风险项"]
        
        for i in 0...2 {
            
            let cardView = UIView.init(frame: CGRect(x:width * CGFloat(i)  + 10 * CGFloat(i)+10, y: nameLable.max_Y+10, width: width, height: height))
            backView.addSubview(cardView)
            cardView.backgroundColor = UIColor.red
            let labletop = UILabel.init(frame: CGRect(x:0, y: 5, width: width, height: 20))
            labletop.textAlignment = .center
            labletop.font = UIFont.systemFont(ofSize: 14)
            let lablebottom = UILabel.init(frame: CGRect(x:  0, y: 25, width: width, height: height-25))
            lablebottom.textAlignment = .center
            lablebottom.font = UIFont.systemFont(ofSize: 22)
            labletop.text = array[i]
            cardView.addSubview(labletop)
            cardView.layer.cornerRadius = 2
            cardView.clipsToBounds = true
            cardView.addSubview(lablebottom)
            if i != 2 {
                labletop.textColor = UIColor.darkGray
                cardView.backgroundColor = HexColor("#60C177")
                lablebottom.textColor = UIColor.white
            }else{
                  lablebottom.textColor = UIColor.red
                 labletop.textColor = UIColor.lightGray
                cardView.backgroundColor = UIColor.white
                cardView.layer.borderColor = UIColor.red.cgColor
                cardView.layer.borderWidth = 0.5
            }

            topArray.append(lablebottom)

        }
        
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = UIColor.hexString(hexString: "176CC7")
        btn.setTitle("查看报告", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.layer.cornerRadius = 2
        btn.clipsToBounds = true
        btn.frame = CGRect(x: 10, y: backView.height-40, width: backView.width-20, height: 30)
        backView.addSubview(btn)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
    }
    
    @objc func btnClick(){
        let content:ProjectReportMessageContent = model.content as! ProjectReportMessageContent
        let vc = MineReviseVC()
        vc.url = URL.init(string: content.url)
    PublicMethod.appCurrentViewController().navigationController?.pushViewController(vc, animated: true)
        
    }
     
    override func setDataModel(_ model: RCMessageModel!) {
        super.setDataModel(model)
        let content:ProjectReportMessageContent = model.content as! ProjectReportMessageContent
        
        for i in 0...self.topArray.count-1 {
            let lab = self.topArray[i]
            if i == 0 {
                lab.text = String.init(format: "%d", NSString.init(string: content.projectScore).integerValue)
            }else if i == 1 {
                lab.text = String.init(format: "%d", NSString.init(string: content.projectWinIndex).integerValue)
                
            }else{
                lab.text = String.init(format: "%d", NSString.init(string: content.projectRisk).integerValue)
                
            }
        }

         if model.isDisplayMessageTime == true{
            backView.frame = CGRect(x: 70, y: 80, width: frame.size.width-140, height: 200)
         }else{
            backView.frame = CGRect(x: 70, y: 60, width: frame.size.width-140, height: 200)
            
        }
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
