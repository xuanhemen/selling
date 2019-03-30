//
//  QFProjectPlanCell.swift
//  SwiftStudy
//
//  Created by qwp on 2018/4/19.
//  Copyright © 2018年 祁伟鹏. All rights reserved.
//

import UIKit

class QFProjectPlanCell: UITableViewCell {
    
    var typeLabel:UILabel?          //类型
    var typeImageView:UIImageView?  //类型图片
    var titleLabel:UILabel?         //角色
    var detailLabel:UILabel?        //详情
    var dateLabel:UILabel?          //日期
    var weekLabel:UILabel?          //星期
    var topBackImage:UIImageView?
    var statusImageView:UIImageView?
    
    let imageDic = ["常规交流":"project_message","方案呈现":"project_fangan","产品演示":"project_chanping","商务活动":"project_huodong","需求调研":"project_diaoyan","样板参观":"project_yangban","技术交流":"project_jishujiaoliu"]
    //QF -- add
    func setData(model:QFProjectPlanModel) {
        typeLabel?.text = model.action_style_name
        titleLabel?.text = model.people_name
        detailLabel?.text = model.action_target
        
        self.dateLabel?.text = model.date_d
        self.weekLabel?.text = model.date_n
        self.typeImageView?.image = UIImage.init(named: imageDic[model.action_style_name] ?? "")
        if model.is_achieve == "1" {
            self.statusImageView?.isHidden = false
        }else{
            self.statusImageView?.isHidden = true
        }
        
    }
    
    @objc func setDict(dict:Dictionary<String,Any>) {
        typeLabel?.text = String.init(format: "%@", dict["action_style_name"] as! CVarArg)
        titleLabel?.text = String.init(format: "%@", dict["people_name"] as! CVarArg)
        detailLabel?.text = String.init(format: "%@", dict["action_target"] as! CVarArg)
        
        self.dateLabel?.text = String.init(format: "%@", dict["date_d"] as! CVarArg)
        self.weekLabel?.text = String.init(format: "%@", dict["date_n"] as! CVarArg)
        self.typeImageView?.image = UIImage.init(named: imageDic[String.init(format: "%@", dict["action_style_name"] as! CVarArg)] ?? "")
        if String.init(format: "%@", dict["is_achieve"] as! CVarArg) == "1" {
            self.statusImageView?.isHidden = false
        }else{
            self.statusImageView?.isHidden = true
        }
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - ***********   UIConfig    ***********
    
    func configUI() {
        self.backgroundColor = .clear
        
        let backView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 84.5))
        backView.backgroundColor = .white
        self.contentView.addSubview(backView)
        
        let calendarFrame = CGRect(x: 10, y: 10, width: 65, height: 65)
        self.calendarConfig(frame: calendarFrame,fatherView: backView)
        
        
        let labelFrame = CGRect(x: 85, y: 10, width: backView.frame.size.width-105, height: 65)
        self.labelConfig(frame: labelFrame, fatherView: backView)
        
        
        let arrowImageView = UIImageView.init(frame: CGRect(x: backView.frame.size.width-20, y: (backView.frame.size.height-15)/2, width: 15, height: 15))
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.image = #imageLiteral(resourceName: "Arrow")
        backView.addSubview(arrowImageView)
        
    }
    
    func labelConfig(frame:CGRect,fatherView:UIView){
        let backView = UIView.init(frame: frame)
        fatherView.addSubview(backView)
        
        typeLabel = UILabel.init(frame: CGRect(x: (backView.frame.size.width-10)-60, y: 0, width: 60, height: backView.frame.size.height/2-5))
        typeLabel?.text = ""
        typeLabel?.textColor = .darkGray
        typeLabel?.textAlignment = .right
        typeLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        backView.addSubview(typeLabel!)
        
        typeImageView = UIImageView.init(frame: CGRect(x: (typeLabel?.frame.origin.x)!-(typeLabel?.frame.size.height)!, y: 0, width: (typeLabel?.frame.size.height)!, height: (typeLabel?.frame.size.height)!))
        typeImageView?.image = #imageLiteral(resourceName: "project_message")
        backView.addSubview(typeImageView!)
        
        
        titleLabel = UILabel.init(frame: CGRect(x: 5, y: 0, width: backView.frame.size.width-10-100, height: backView.frame.size.height/2))
        titleLabel?.text = ""
        titleLabel?.textColor = .black
        titleLabel?.textAlignment = .left
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        backView.addSubview(titleLabel!)
        
        
        
        detailLabel = UILabel.init(frame: CGRect(x: 5, y: backView.frame.size.height/2, width: backView.frame.size.width-10, height: backView.frame.size.height/2-2))
        detailLabel?.text = ""
        detailLabel?.numberOfLines = 0
        detailLabel?.textColor = .gray
        detailLabel?.textAlignment = .left
        detailLabel?.font = UIFont.systemFont(ofSize: 12, weight: .light)
        backView.addSubview(detailLabel!)
        
    }
    
    //MARK: - ***********   日历📅    ***********
    func calendarConfig(frame:CGRect,fatherView:UIView){
        let backView = UIView.init(frame: frame)
        backView.backgroundColor = .clear
        fatherView.addSubview(backView)
        
        topBackImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: backView.frame.size.width, height: backView.frame.size.width))
        topBackImage?.backgroundColor = UIColor.init(red: 234/255.0, green: 124/255.0, blue: 40/255.0, alpha: 1)
        topBackImage?.layer.cornerRadius = 5
        backView.addSubview(topBackImage!)
        
        dateLabel = UILabel.init(frame: CGRect(x: 5, y: 10, width: 55, height: 25))
        dateLabel?.text = "22"
        dateLabel?.textColor = .white
        dateLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        dateLabel?.textAlignment = .center
        backView.addSubview(dateLabel!)
        
        weekLabel = UILabel.init(frame: CGRect(x: 5, y: 16+24, width: 55, height: 11))
        weekLabel?.text = "星期三"
        weekLabel?.textColor = .white
        weekLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        weekLabel?.textAlignment = .center
        backView.addSubview(weekLabel!)
        
        statusImageView = UIImageView.init(frame: CGRect(x:backView.frame.size.width-12, y: backView.frame.size.width-12, width: 15, height: 15))
        statusImageView?.image = #imageLiteral(resourceName: "qf_green_right")
        statusImageView?.isHidden = true
        backView.addSubview(statusImageView!)
    }
    

}
