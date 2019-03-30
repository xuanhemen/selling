//
//  ProjectAnalyzeHeaderView.swift
//  SwiftStudy
//
//  Created by qwp on 2018/4/10.
//  Copyright © 2018年 祁伟鹏. All rights reserved.
//

import UIKit
import SwiftyJSON
class ProjectAnalyzeHeaderView: UIView {

    var myModel:ProjectAnalyzeModel?
    var click:(_ tag:Int)->() = {_ in
        
    }
    func configUI(model:ProjectAnalyzeModel) ->CGFloat {
        self.myModel = model
        let valueArray = [model.pro_defen,model.Winindex,model.risk_warning_count]
        let imageArray = ["qf_project_xiangmudefen.png","qf_project_yingdanzhishu.png","qf_project_fengxianxiang.png"]
        let sViewWidth = (self.frame.size.width-60)/3.0
        
        let colorArr = [UIColor.init(red: 87/255.0, green: 193/255.0, blue: 108/255.0, alpha: 1),UIColor.init(red: 231/255.0, green: 99/255.0, blue: 40/255.0, alpha: 1),UIColor.init(red: 225/255.0, green: 39/255.0, blue: 39/255.0, alpha: 1)]
        for i in 0...2 {
            
            let view = UIView.init(frame: CGRect(x: 15+(sViewWidth+15)*CGFloat(i), y: 15, width: sViewWidth, height: sViewWidth/2))
            view.backgroundColor = .white
            view.layer.cornerRadius = 2
            view.layer.shadowOffset = CGSize(width:0, height:0.5)
            view.layer.shadowOpacity = 0.2
            view.layer.shadowColor = UIColor.gray.cgColor
            self.addSubview(view)
            
            let valueLabel = UILabel.init(frame: CGRect(x: sViewWidth/2, y: sViewWidth/8, width: sViewWidth/2, height: sViewWidth/4))
            valueLabel.text = String.init(format: "%d", JSON(valueArray[i]).intValue)
            valueLabel.textAlignment = .center
            valueLabel.textColor = colorArr[i]
            valueLabel.font = UIFont.systemFont(ofSize: 17, weight: .light)
            view.addSubview(valueLabel)
            
            if i==2 {
                let ranStr = valueLabel.text!+"个"
                let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:ranStr)
                attrstring.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 12, weight: .light), range: NSMakeRange(ranStr.count-1, 1))
                valueLabel.attributedText = attrstring
                
            }
            
            let line = UIView.init(frame: CGRect(x: sViewWidth/2-0.5, y: 5, width: 1, height: sViewWidth/2-10))
            line.backgroundColor = UIColor.init(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
            view.addSubview(line)
            
            let imageV = UIImageView.init(frame: CGRect(x:0, y: 0, width: sViewWidth/2, height: sViewWidth/2))
            imageV.image = UIImage.init(imageLiteralResourceName: imageArray[i])
            view.addSubview(imageV)
            
            if i > 0{
                let btn = UIButton.init(type: .custom)
                btn.frame = CGRect(x: 0, y: 0, width: sViewWidth, height: sViewWidth/2)
                btn.tag = i+200
                view.addSubview(btn)
                btn.backgroundColor = UIColor.clear
                btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
            }
            
        }
        
        return self.configBottom(heigth: sViewWidth/2+40    )
    }
    func configUINoValue(model:ProjectAnalyzeModel) ->CGFloat{
        self.myModel = model
        return self.configBottom(heigth: 15)
    }
    func configBottom(heigth:CGFloat) ->CGFloat {
        
        let hintLabel = UILabel.init(frame: CGRect(x:15, y: heigth, width: self.frame.size.width-30, height: 20))
        //hintLabel.text = self.myModel?.xiaoluo?.title
        hintLabel.text = "策略建议"
        hintLabel.textAlignment = .left
        hintLabel.textColor = UIColor.darkGray
        hintLabel.font = UIFont.systemFont(ofSize: 16)
        self.addSubview(hintLabel)
        
        
        
        let summaryLabel = UILabel.init(frame: CGRect(x:15, y: 55, width: self.frame.size.width-60, height: 20))
        let sText = String.noNilStr(str: self.myModel?.xiaoluo?.content)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        let setStr = NSMutableAttributedString.init(string: sText)
        setStr.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, sText.count))
        
        summaryLabel.textAlignment = .left
        summaryLabel.textColor = UIColor.init(red: 32/255.0, green: 70/255.0, blue: 0, alpha: 1)
        summaryLabel.numberOfLines = 0
        summaryLabel.font = UIFont.systemFont(ofSize: 13)
        
        summaryLabel.attributedText =  setStr
        
        let nheight = self.heightForView(text: summaryLabel.text!, font: summaryLabel.font, width: self.frame.size.width-60)
        summaryLabel.frame = CGRect(x: 15, y: 55, width: self.frame.size.width-60, height: nheight)
        
        var summaryHeight = nheight+30+40+30;
        if heigth == 15 {
            summaryHeight = nheight + 30 + 30
        }
        
        let summaryView = UIView.init(frame: CGRect(x: 15, y: hintLabel.frame.origin.y+hintLabel.frame.size.height+10, width: self.frame.size.width-30, height: summaryHeight))
        summaryView.backgroundColor = .white
        summaryView.layer.shadowOffset = CGSize(width:0, height:0.5)
        summaryView.layer.shadowOpacity = 0.2
        summaryView.layer.shadowColor = UIColor.gray.cgColor
        self.addSubview(summaryView)
        summaryView.addSubview(summaryLabel)
        
        let textBackImageV = UIImageView.init(frame: CGRect(x:0, y:summaryView.frame.size.height-summaryView.frame.size.width/320*90, width: summaryView.frame.size.width, height: summaryView.frame.size.width/320*90))
        textBackImageV.image = UIImage.init(imageLiteralResourceName: "qf_project_textBack.png")
        summaryView.addSubview(textBackImageV)
        
        
        
        let titleLabel = UILabel.init(frame: CGRect(x:0, y: 0, width: summaryView.frame.size.width, height: 40))
        titleLabel.text = String.noNilStr(str: self.myModel?.xiaoluo?.title_two)
        titleLabel.backgroundColor = UIColor.init(red: 99/255.0, green: 223/255.0, blue: 147/255.0, alpha: 1)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        summaryView.addSubview(titleLabel)
        
        let shouldLabel = UILabel.init(frame: CGRect(x:15, y: summaryView.frame.size.height-30, width: summaryView.frame.size.width/2, height: 30))
        shouldLabel.text = String.noNilStr(str: self.myModel?.xiaoluo?.suitable)
        shouldLabel.textAlignment = .left
        shouldLabel.textColor = UIColor.init(red: 234/255.0, green: 121/255.0, blue: 40/255.0, alpha: 1)
        shouldLabel.font = UIFont.systemFont(ofSize: 14)
        if heigth != 15 {
            summaryView.addSubview(shouldLabel)
        }
        
        
        let inadvisableLabel = UILabel.init(frame: CGRect(x:summaryView.frame.size.width/2-15, y: summaryView.frame.size.height-30, width: summaryView.frame.size.width/2, height: 30))
        inadvisableLabel.text = String.noNilStr(str: self.myModel?.xiaoluo?.no_suitable)
        inadvisableLabel.textAlignment = .right
        inadvisableLabel.textColor = UIColor.init(red: 225/255.0, green: 39/255.0, blue: 39/255.0, alpha: 1)
        inadvisableLabel.font = UIFont.systemFont(ofSize: 14)
        if heigth != 15 {
            summaryView.addSubview(inadvisableLabel)
        }
        return summaryView.frame.size.height + summaryView.frame.origin.y
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
    @objc func btnClick(sender:UIButton){
        self.click(sender.tag-200)
    }
    
}
