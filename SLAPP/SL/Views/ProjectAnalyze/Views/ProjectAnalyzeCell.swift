//
//  ProjectAnalyzeCell.swift
//  SwiftStudy
//
//  Created by qwp on 2018/4/10.
//  Copyright © 2018年 祁伟鹏. All rights reserved.
//

import UIKit

class ProjectAnalyzeCell: UITableViewCell {

    var label:UILabel = UILabel()
    var subLabel:UILabel = UILabel()
    var imageV: UIImageView = UIImageView()
    var cellType:String?
    let qf_width = UIScreen.main.bounds.size.width
    public func uiConfig(ID:String) {
        
        cellType = ID
        
        self.backgroundColor = UIColor.init(red: 235/255.0, green: 234/255.0, blue: 241/255.0, alpha: 1)
        
        let backView = UIView.init(frame: CGRect(x: 15, y: 5, width: qf_width-30, height: 40))
        backView.layer.cornerRadius = 2
        backView.backgroundColor = UIColor.white
        backView.layer.shadowOffset = CGSize(width:0, height:0.5)
        backView.layer.shadowOpacity = 0.2
        backView.layer.shadowColor = UIColor.gray.cgColor
        self.contentView.addSubview(backView)
        
        
        imageV = UIImageView.init(frame: CGRect(x: 5, y: 5, width: 30, height: 30))
        
        label = UILabel.init(frame: CGRect(x: 5, y: 5, width: backView.frame.size.width-45, height: 30))
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        backView.addSubview(label)
        
        switch ID {
        case "CELL0":do {
            backView.addSubview(imageV)
            label.frame = CGRect(x: 40, y: 5, width: backView.frame.size.width-80, height: 30)
            label.textColor = UIColor.red
            imageV.image = UIImage.init(imageLiteralResourceName: "qf_project_waring.png")
            }
        case "CELL1":do {
            
            imageV.layer.cornerRadius = imageV.frame.size.height/2.0
            imageV.backgroundColor = UIColor.init(red: 58/255.0,green: 129/255.0, blue: 62/255.0, alpha: 1)
            subLabel = UILabel.init(frame: CGRect(x: imageV.frame.origin.x, y: 10, width: imageV.frame.size.width, height: 20))
            subLabel.text = ""
            subLabel.textAlignment = .center
            subLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            subLabel.textColor = UIColor.white
            backView.addSubview(imageV)
            backView.addSubview(subLabel)
            
            label.frame = CGRect(x: 40, y: 5, width: backView.frame.size.width-80, height: 30)
    
            }
        
            
        default:do {
            
            }
        }
        
        let rightArrowImageV = UIImageView.init(frame: CGRect(x: backView.frame.size.width-35, y: 5, width: 30, height: 30))
        rightArrowImageV.image = UIImage.init(imageLiteralResourceName: "qf_project_nextArrow.png")
        backView.addSubview(rightArrowImageV)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
}
