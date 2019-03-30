//
//  ScatterView.swift
//  SD
//
//  Created by apple on 2018/4/10.
//  Copyright © 2018年 apple. All rights reserved.
//

import UIKit

class ScatterView: UIView {

    var currentUserId:String = ""
    var maxXValue:CGFloat = 10.0  //参与度
    var maxYValue:CGFloat = 10.0  //支持度
    
    var model:ProBublesModel?
    var lbArray = Array<UILabel>() //存放圆圈的lable
    var selectRoleId:(_ roleid:String)->() = {_ in
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.creatCoordinate()
    }
    
   fileprivate func creatCoordinate(){
    
        DrawLineManager.drawLine(start: CGPoint(x: 15, y: 15), end: CGPoint(x: 15, y: self.frame.size.height-15), width: 0.5, lineColor: UIColor.black, inView: self)
        DrawLineManager.drawLine(start: CGPoint(x: 15, y: 15), end: CGPoint(x: 10, y: 30), width: 0.5, lineColor: UIColor.black, inView: self)
        DrawLineManager.drawLine(start: CGPoint(x: 15, y: 15), end: CGPoint(x: 20, y: 30), width: 0.5, lineColor: UIColor.black, inView: self)
    
    DrawLineManager.drawLine(start: CGPoint(x: 15, y: self.frame.size.height-15), end: CGPoint(x: self.frame.size.width-15, y: self.frame.size.height-15), width: 0.5, lineColor: UIColor.black, inView: self)
    DrawLineManager.drawLine(start: CGPoint(x: self.frame.size.width-15, y: self.frame.size.height-15), end: CGPoint(x: self.frame.size.width-30, y: self.frame.size.height-20), width: 0.5, lineColor: UIColor.black, inView: self)
    DrawLineManager.drawLine(start: CGPoint(x: self.frame.size.width-15, y: self.frame.size.height-15), end: CGPoint(x: self.frame.size.width-30, y: self.frame.size.height-10), width: 0.5, lineColor: UIColor.black, inView: self)
    
        DrawLineManager.drawLine(start: CGPoint(x: 15, y: self.frame.size.height/2.0), end: CGPoint(x: self.frame.size.width-15, y: self.frame.size.height/2.0), width: 0.5, lineColor: UIColor.lightGray, inView: self)
        
        DrawLineManager.drawLine(start: CGPoint(x: self.frame.size.width/2.0, y: 15), end: CGPoint(x: self.frame.size.width/2.0, y: self.frame.size.height-15), width: 0.5, lineColor: UIColor.lightGray, inView: self)
    
         let sLable = UILabel.init(frame: CGRect(x: 30, y: 10, width: 40, height: 20))
         sLable.text = "支持度"
         sLable.font = UIFont.systemFont(ofSize: 10)
         self.addSubview(sLable)
    
        let eLable = UILabel.init(frame: CGRect(x: self.frame.size.width-40, y: self.frame.size.height-40, width: 40, height: 20))
        eLable.text = "参与度"
        eLable.font = UIFont.systemFont(ofSize: 10)
        self.addSubview(eLable)
    
    
       self.showAera()
    
        
    }
    
    
    
    
    // MARK: - 添加项限名称
    func showAera(){
        let aeraArray = ["热恋区","暗恋区","路人区","情敌区"]
        for (index,str) in aeraArray.enumerated() {
            
            let eLable = UILabel()
            if index == 0 {
                eLable.frame = CGRect(x: self.frame.size.width-40, y: 40, width: 40, height: 20)
            }else if index == 1 {
                eLable.frame = CGRect(x: 20, y: 40, width: 40, height: 20)
            }else if index == 2 {
                eLable.frame = CGRect(x: 20 , y: self.frame.size.height-60, width: 40, height: 20)
            }
            else{
                eLable.frame = CGRect(x: self.frame.size.width-60 , y: self.frame.size.height-60, width: 40, height: 20)
            }
            eLable.textColor = UIColor.lightGray
            eLable.text = str
            eLable.font = UIFont.systemFont(ofSize: 10)
            self.addSubview(eLable)
        }
    }
    

    func configWithModel(model:ProBublesModel){
        if self.model != nil {
            return
        }
        self.model = model
        self.maxXValue = (model.parameter?.engagement_max)! != 0 ? (model.parameter?.engagement_max)!+50 : 10
        self.maxYValue = (model.parameter?.support_max)! != 0 ? (model.parameter?.support_max)!+50 : 10
        
       
        var lab:UILabel?
        
        for subModel in model.people {
            
            let newPoint = self.transPoint(point: CGPoint.init(x: CGFloat(truncating: subModel.circle_engagement), y: CGFloat(truncating: subModel.circle_support)))

            
            let w = CGFloat(truncating: subModel.circle_size)/CGFloat((model.parameter?.circle_size_max)!)  * (self.frame.width-30)/4
                let lable = UILabel.init(frame: CGRect(x: 0, y: 0, width: w, height: w))
                lable.layer.cornerRadius = w/2.0
                lable.center = newPoint
                lable.clipsToBounds = true;
                lable.text = String(subModel.name.prefix(1))
                lable.textAlignment = .center
                lable.backgroundColor = UIColor.lightGray
            lable.isUserInteractionEnabled = true
                self.addSubview(lable)
            
                let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: lable.frame.size.width, height: lable.frame.size.height))
            button.tag = 100+Int(subModel.id)!
            button.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
                lable.addSubview(button)
            lbArray.append(lable)
            
            if subModel.id == self.currentUserId {
                lab = lable
//                DLog("有"+subModel.userid+String(subModel.name.prefix(1)))
                lable.backgroundColor = UIColor.hexString(hexString: subModel.circle_color)
            }
        }
        if lab != nil {
            self.bringSubview(toFront: lab!)
        }
    }
    
    @objc func buttonClick(button:UIButton) {
        
        let subModelArray = self.model?.people.filter({ (model) -> Bool in
            return model.id == String.init(format: "%ld", button.tag-100)
        })
        for lab in lbArray {
            lab.backgroundColor = UIColor.lightGray
            if lab == button.superview{
                lab.backgroundColor = UIColor.hexString(hexString: (subModelArray?.first?.circle_color)!)
                self.bringSubview(toFront: lab)
            }
        }
        self.selectRoleId(String.init(format: "%ld", button.tag-100))
    }
    
    
    
    
  fileprivate  func transPoint(point:CGPoint)->CGPoint{
        return CGPoint(x: self.transX(x: point.x), y: self.transY(y: point.y))
    }
    
  fileprivate  func transX(x:CGFloat)->CGFloat{
        return (self.frame.width-30)/2.0 + ((self.frame.width-30)/2.0)*x/maxXValue
    }
    
  fileprivate  func transY(y:CGFloat)->CGFloat{
        return (self.frame.height-30)/2.0 - ((self.frame.height-30)/2.0)*y/maxYValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
