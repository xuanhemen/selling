//
//  ProjectAnalyzeBaseDetailVC.swift
//  SwiftStudy
//
//  Created by qwp on 2018/4/11.
//  Copyright © 2018年 祁伟鹏. All rights reserved.
//

import UIKit
import SwiftyJSON
class ProjectAnalyzeBaseDetailVC: UIViewController {
     var myModel:ProjectSituationModel?
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    var titleLabel:UILabel?
    var scrollView:UIScrollView?
    var detailLabel:UILabel?
    var hintlLabel:UILabel?

    var index:Int?
    var model:three_broadModel?{
        didSet{
            self.uiConfig()
        }
    }
    
    var riskModel:risk_warningSubModel?{
        didSet{
          self.title = "风险预警"
           self.riskUiConfig()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "东方网络集团大客户销售项目"
        self.view.backgroundColor = UIColor.init(red: 235/255.0, green: 234/255.0, blue: 241/255.0, alpha: 1)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func uiConfig() {
        self.scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: width, height: height-64))
        self.scrollView?.isPagingEnabled = true
        self.scrollView?.isScrollEnabled = false
        self.scrollView?.showsVerticalScrollIndicator = false
        self.scrollView?.showsHorizontalScrollIndicator = false
        self.view.addSubview(self.scrollView!)
     
        self.titleLabel = UILabel.init(frame: CGRect(x:0, y: 0, width: width-30, height: 40))
        self.titleLabel?.text = self.model?.sub_shortname
        self.titleLabel?.backgroundColor = UIColor.init(red: 99/255.0, green: 223/255.0, blue: 147/255.0, alpha: 1)
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.textColor = UIColor.white
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        
        self.detailLabel = UILabel.init(frame: CGRect(x:15, y: 55, width: width-60, height: 20))
        
        self.detailLabel?.textAlignment = .left
        self.detailLabel?.textColor = UIColor.init(red: 32/255.0, green: 70/255.0, blue: 0, alpha: 1)
        self.detailLabel?.backgroundColor = .white
        self.detailLabel?.numberOfLines = 0
        self.detailLabel?.font = UIFont.systemFont(ofSize: 14)

        
        
        
        var string = self.model?.str_val ?? ""
        if (self.model?.arr_val.count)! > 0 {
            string = (self.model?.arr_val.joined(separator: "\n"))!
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let setStr = NSMutableAttributedString.init(string: string)
        setStr.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, string.count))
        self.detailLabel?.attributedText = setStr
        
        
        let nheight = self.heightForView(text: (self.detailLabel?.text)!, font: (self.detailLabel?.font)!, width: width-40)
        self.detailLabel?.frame = CGRect(x: 10, y: 50, width: width-40, height: nheight)
        
        let summaryHeight = nheight + 50 + 10
        
        let summaryView = UIView.init(frame: CGRect(x: 15, y: 15, width: width-30, height: summaryHeight))
        summaryView.backgroundColor = .white
        summaryView.layer.shadowOffset = CGSize(width:0, height:0.5)
        summaryView.layer.shadowOpacity = 0.2
        summaryView.layer.shadowColor = UIColor.gray.cgColor
        
        summaryView.addSubview(self.titleLabel!)
        summaryView.addSubview(self.detailLabel!)
        
        self.scrollView?.addSubview(summaryView)
        
        self.hintlLabel = UILabel.init(frame: CGRect(x:15, y: summaryView.frame.size.height+summaryView.frame.origin.y+10, width: width-30, height: 30))
        self.hintlLabel?.text = self.model?.str_val_people
        self.hintlLabel?.textAlignment = .left
        self.hintlLabel?.textColor = UIColor.darkGray
        self.hintlLabel?.font = UIFont.systemFont(ofSize: 14)
        self.scrollView?.addSubview(self.hintlLabel!)
        let sViewWidth = (width-70)/3.0
        if (self.model?.str_people.count)! > 0 {
            
            
//            let titleArray = ["王总","张经理","王总"]
            
            let count = self.model!.str_people.count
            for i in 0...count-1 {
                let subModel:str_peopleModel = self.model!.str_people[i]
                
                let view = UIView.init(frame: CGRect(x: 15+(sViewWidth+20)*CGFloat(i), y: self.hintlLabel!.frame.size.height+self.hintlLabel!.frame.origin.y+10, width: sViewWidth, height: sViewWidth*1.2))
                view.layer.shadowOffset = CGSize(width:0, height:0.5)
                view.layer.shadowOpacity = 0.2
                view.layer.shadowColor = UIColor.gray.cgColor
                view.backgroundColor = .white
                self.scrollView?.addSubview(view)
                
                let imageV = UIImageView.init(frame: CGRect(x: (sViewWidth-view.frame.size.height*0.67+10)/2.0, y: 10, width: view.frame.size.height*0.67-10, height: view.frame.size.height*0.67-10))
                imageV.contentMode = .scaleAspectFit
                imageV.backgroundColor = HexColor(subModel.circle_color)
                imageV.layer.cornerRadius = imageV.frame.size.width/2.0
                view.addSubview(imageV)
                
                let titleLabel = UILabel.init(frame: CGRect(x:0, y: view.frame.size.height*0.67, width: sViewWidth, height: view.frame.size.height*0.33))
                titleLabel.text = subModel.name
                titleLabel.textAlignment = .center
                titleLabel.textColor = UIColor.darkGray
                titleLabel.font = UIFont.systemFont(ofSize: 14)
                view.addSubview(titleLabel)
                
                let subStr = titleLabel.text?.prefix(1)
                let subLabel = UILabel.init(frame: CGRect(x:imageV.frame.origin.x, y:imageV.frame.origin.y+(imageV.frame.size.height-26)/2, width: imageV.frame.size.width, height: 26))
                subLabel.text = String(subStr!)
                subLabel.textAlignment = .center
                subLabel.textColor = UIColor.white
                subLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
                view.addSubview(subLabel)
                
                let btn = UIButton.init(type: .custom)
                btn.frame = view.bounds
                btn.tag = i
                view.addSubview(btn)
                btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
                
            }
        }else{
            self.hintlLabel?.isHidden = true
        }
        
        
        
        
        let btn = UIButton.init(frame: CGRect(x:15, y: self.hintlLabel!.frame.size.height+self.hintlLabel!.frame.origin.y+10+sViewWidth*1.2+40, width: width-30, height: 40))
        btn.setTitleColor(.white, for: UIControlState.normal)
        btn.setTitle("到赢单罗盘中看看有没有Coach?", for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.backgroundColor = .red
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 4
        btn.addTarget(self, action: #selector(toProDetail), for: .touchUpInside)
        //self.scrollView?.addSubview(btn)
        
        if index != 1 {
            btn.isHidden = true
        }
        //隐藏coach按钮
        btn.isHidden = true
        
        self.scrollView?.contentSize = CGSize(width: 0, height: btn.frame.size.height+btn.frame.origin.y+30)
        
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        //QF -- mark -- 调整行间距
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let setStr = NSMutableAttributedString.init(string: text)
        setStr.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, text.count))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.attributedText = setStr
        label.sizeToFit()
        return label.frame.height+label.font.ascender
    }
    
    
    
    
    func riskUiConfig() {
        self.scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: width, height: height-64))
        self.scrollView?.isPagingEnabled = true
        self.scrollView?.isScrollEnabled = false
        self.scrollView?.showsVerticalScrollIndicator = false
        self.scrollView?.showsHorizontalScrollIndicator = false
        self.view.addSubview(self.scrollView!)
        
        self.titleLabel = UILabel.init(frame: CGRect(x:0, y: 0, width: width-30, height: 40))
        self.titleLabel?.text = self.riskModel?.title
        self.titleLabel?.backgroundColor = UIColor.init(red: 99/255.0, green: 223/255.0, blue: 147/255.0, alpha: 1)
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.textColor = UIColor.white
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        
        self.detailLabel = UILabel.init(frame: CGRect(x:15, y: 55, width: width-60, height: 20))
        //        self.detailLabel?.text = ""
        self.detailLabel?.textAlignment = .left
        self.detailLabel?.textColor = UIColor.init(red: 32/255.0, green: 70/255.0, blue: 0, alpha: 1)
        self.detailLabel?.numberOfLines = 0
        self.detailLabel?.font = UIFont.systemFont(ofSize: 14)
        var string = self.riskModel?.str_val ?? ""
        if (self.riskModel?.arr_val.count)! > 0 {
            string = (self.riskModel?.arr_val.joined(separator: "\n"))!
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let setStr = NSMutableAttributedString.init(string: string)
        setStr.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, string.count))
        self.detailLabel?.attributedText = setStr
        
        
        let nheight = self.heightForView(text: (self.detailLabel?.text)!, font: (self.detailLabel?.font)!, width: width-40)
        self.detailLabel?.frame = CGRect(x: 10, y: 50, width: width-40, height: nheight)
        
        let summaryHeight = nheight + 50 + 10
        
        let summaryView = UIView.init(frame: CGRect(x: 15, y: 15, width: width-30, height: summaryHeight))
        summaryView.backgroundColor = .white
        summaryView.layer.shadowOffset = CGSize(width:0, height:0.5)
        summaryView.layer.shadowOpacity = 0.2
        summaryView.layer.shadowColor = UIColor.gray.cgColor
        
        summaryView.addSubview(self.titleLabel!)
        summaryView.addSubview(self.detailLabel!)
        
        self.scrollView?.addSubview(summaryView)
        
        self.hintlLabel = UILabel.init(frame: CGRect(x:15, y: summaryView.frame.size.height+summaryView.frame.origin.y+10, width: width-30, height: 30))
        self.hintlLabel?.text = self.model?.str_val_people
        self.hintlLabel?.textAlignment = .left
        self.hintlLabel?.textColor = UIColor.darkGray
        self.hintlLabel?.font = UIFont.systemFont(ofSize: 14)
        self.scrollView?.addSubview(self.hintlLabel!)
        
        if self.riskModel?.title == "角色覆盖度不够" {
            PublicMethod.showProgress()
            LoginRequest.getPost(methodName: LOGICANALYSE_ROLERADAR, params: ["project_id":self.myModel?.id as Any].addToken(), hadToast: true, fail: { (dic) in
                PublicMethod.dismiss()
            }) {[weak self] (dic) in
                 PublicMethod.dismiss()
                if let radarModel = ProRoleRadarModel.deserialize(from: dic){
                    DLog(radarModel)
                    self?.creatRadar(model: radarModel)
                }
            }
        }
    
        
        
    }
    
    
    func creatRadar(model:ProRoleRadarModel){
        let radarView = QFRadarChartView.init(frame: CGRect(x: 15, y: (self.hintlLabel?.max_Y)!-10, width: self.width-30, height: self.width-20))
        radarView.backgroundColor = .white
        radarView.layer.shadowOffset = CGSize(width:0, height:0.5)
        radarView.layer.shadowOpacity = 0.2
        radarView.yAxisMaximum = Double(model.maxValue())
        radarView.layer.shadowColor = UIColor.gray.cgColor
        radarView.yAxisTags = model.titles()
        radarView.configUI()
        
        let entry = radarView.addChartsData(title: "", valueArr: model.values() , lineColor: UIColor.init(red: 119/255.0, green: 195/255.0, blue: 248/255.0, alpha: 1), lineWidth: 1, fillColor: UIColor.init(red: 119/255.0, green: 195/255.0, blue: 248/255.0, alpha: 1), fillAlpha: 0.5)
        
        
        radarView.setChartData(setArray: [entry])
        
        self.scrollView?.addSubview(radarView)
        self.scrollView?.isScrollEnabled = true
        self.scrollView?.contentSize = CGSize(width: 0, height: radarView.max_Y+30)
    }
    
    
    
    @objc func btnClick(btn:UIButton){
       
         let subModel:str_peopleModel = self.model!.str_people[btn.tag]
        
        let vc = ProRolePlanVC()
        vc.title = self.myModel?.name
        vc.projectId = (self.myModel?.id)!
        vc.currentUserId = subModel.id
        vc.currentName = subModel.name
        vc.model = self.myModel
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @objc func toProDetail(){
        self.isHasTime()
    }
    
    func isHasTime(){
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: COACHPAY_LIST, params: [:].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
            DLog(dic)
            
            let a =  JSON(dic["left_hour_str"]).floatValue
            if a <= 0 {
                PublicMethod.toastWithText(toastText: "您好，您的可预约时长用完了")
                return
            }else{
                
                var per = "0.0"
                let use = JSON(dic["used_minute"] as Any).intValue
                let left = JSON(dic["left_minute"] as Any).intValue
                if use+left != 0{
                    per = String.init(format: "%.1f",CGFloat(left)/CGFloat((use+left)))
                    
                }
                
                self?.toMakeAppointment(per:per,left:"\(left)")
            }
        }
        
    }
    
    func toMakeAppointment(per:String,left:String){
        let vc = BookingTutoringVC()
        let model = ["projectId":self.myModel?.id,"project_name":self.myModel?.name,"percentage":per,"left_minute":left]
        vc.configAlreadyInfo(model: model, mArray: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
