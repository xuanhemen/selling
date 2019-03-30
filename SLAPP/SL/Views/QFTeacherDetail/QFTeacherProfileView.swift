//
//  QFTeacherProfileView.swift
//  SLAPP
//
//  Created by qwp on 2018/4/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class QFTeacherProfileView: UIView {

    let detailLabel = UILabel()
    
    func setData(string:String) ->CGFloat {
        
        self.detailLabel.text = string
        let height = self.heightForView(text: string, font: self.detailLabel.font, width: SCREEN_WIDTH-50)
        return 50 + height + 20
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 2
        self.backgroundColor = .white
        
        let imageView = UIImageView()
        self.addSubview(imageView)
        imageView.image = #imageLiteral(resourceName: "qf_gerenjianjieImage")
        imageView.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
            make.height.width.equalTo(20)
        }
        let titleLabel = UILabel()
        self.addSubview(titleLabel)
        titleLabel.text = "个人简介"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        titleLabel.textColor = HexColor("#333333")
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(15)
            make.top.equalTo(15)
            make.height.equalTo(20)
            make.right.equalTo(-15)
        }
        
        let line = UILabel()
        self.addSubview(line)
        line.backgroundColor = HexColor("#F2F2F2")
        line.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(49.5)
            make.height.equalTo(0.5)
            make.right.equalTo(0)
        }
        
        self.addSubview(detailLabel)
        detailLabel.text = ""
        detailLabel.textColor = HexColor("#333333")
        detailLabel.numberOfLines = 0
        detailLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(60)
            make.bottom.equalTo(-10)
            make.right.equalTo(-15)
            make.left.equalTo(15)
        }
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
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
