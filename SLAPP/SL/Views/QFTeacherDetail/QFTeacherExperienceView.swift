//
//  QFTeacherExperienceView.swift
//  SLAPP
//
//  Created by qwp on 2018/4/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class QFTeacherExperienceView: UIView {

    let hintLabel = UILabel()
    let hintImageView = UIImageView()
    let line = UILabel()
    let btn = UIButton()
    let nextImageView = UIImageView()
    
    let headerImageView = UIImageView()
    let nameLabel = UILabel()
    let dateLabel = UILabel()
    let detailLabel = UILabel()
    
    var btnClick = {
    
    }
    
    func setData(isShow:Bool,haveValue:Bool,isShowArrow:Bool,model:QFExperienceModel) -> CGFloat {
        
        if model.type == 0{
            hintLabel.text = "工作经历"
            hintImageView.image = #imageLiteral(resourceName: "qf_gongzuojingliImage")
        }else{
            hintLabel.text = "教育经历"
            hintImageView.image = #imageLiteral(resourceName: "qf_jiaoyujingliImage")
        }
        
        headerImageView.isHidden = !haveValue
        nameLabel.isHidden = !haveValue
        dateLabel.isHidden = !haveValue
        detailLabel.isHidden = !haveValue
        
        nameLabel.text = model.name
        detailLabel.text = model.detail
        dateLabel.text = model.date
        headerImageView.sd_setImage(with: NSURL.init(string: model.headerImageUrl) as URL?, placeholderImage: UIImage.init(named: "mine_avatar"))
        
        let height = self.heightForView(text: model.detail, font: self.detailLabel.font, width: SCREEN_WIDTH-100)
        var y:CGFloat = 50
        if isShow == false {
            y = 0
        }
        line.isHidden = !isShow
        hintLabel.isHidden = !isShow
        hintImageView.isHidden = !isShow
        btn.isHidden = !isShow
        nextImageView.isHidden = !isShow
        if isShow {
            nextImageView.isHidden = !isShowArrow
        }
        
        
        self.reloadUI(y: y)
        if !isShow {
            return 0
        }
        if !haveValue {
            return 100
        }
        return  y+height+80
    }
    
    func reloadUI(y:CGFloat) {
        self.addSubview(headerImageView)
        self.addSubview(nameLabel)
        self.addSubview(dateLabel)
        self.addSubview(detailLabel)
        
        headerImageView.backgroundColor = .red
        headerImageView.snp.remakeConstraints { (make) in
            make.top.equalTo(15+y)
            make.left.equalTo(15)
            make.height.width.equalTo(50)
        }
        
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        nameLabel.textColor = HexColor("#333333")
        nameLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(headerImageView.snp.right).offset(15)
            make.top.equalTo(headerImageView.snp.top)
            make.height.equalTo(20)
            make.right.equalTo(-15)
        }
        
        dateLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        dateLabel.textColor = HexColor("#666666")
        dateLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(headerImageView.snp.right).offset(15)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.height.equalTo(20)
            make.right.equalTo(-15)
        }
        
        detailLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        detailLabel.textColor = HexColor("#333333")
        detailLabel.numberOfLines = 0
        detailLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(headerImageView.snp.right).offset(15)
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.bottom.equalTo(-15)
            make.right.equalTo(-15)
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 2
        self.backgroundColor = .white
        
        self.addSubview(hintImageView)
        hintImageView.image = #imageLiteral(resourceName: "qf_gerenjianjieImage")
        hintImageView.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
            make.height.width.equalTo(20)
        }
        
        self.addSubview(hintLabel)
        hintLabel.text = "工作经历"
        hintLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        hintLabel.textColor = HexColor("#333333")
        hintLabel.snp.makeConstraints { (make) in
            make.left.equalTo(hintImageView.snp.right).offset(15)
            make.top.equalTo(15)
            make.height.equalTo(20)
            make.right.equalTo(-15)
        }
        
        self.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(50)
        }
        btn.addTarget(self, action: #selector(selectButtonClick), for: UIControlEvents.touchUpInside)
        
        self.addSubview(nextImageView)
        nextImageView.image = #imageLiteral(resourceName: "qf_nextArrow")
        nextImageView.contentMode = .scaleAspectFit
        nextImageView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.equalTo(15)
            make.height.equalTo(20)
        }
        
        
        self.addSubview(line)
        line.backgroundColor = HexColor("#F2F2F2")
        line.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(49.5)
            make.height.equalTo(0.7)
            make.right.equalTo(0)
        }
        
        self.reloadUI(y:50)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        //QF -- mark -- 调整行间距
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        //        let paragraphStyle = NSMutableParagraphStyle()
        //        paragraphStyle.lineSpacing = 10
        //        let setStr = NSMutableAttributedString.init(string: text)
        //        setStr.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, text.count))
        
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        //label.attributedText = setStr
        label.sizeToFit()
        return label.frame.height+label.font.ascender
    }
    
    @objc func selectButtonClick(){
        if self.nextImageView.isHidden == false{
            self.btnClick()
        }
    }

}
