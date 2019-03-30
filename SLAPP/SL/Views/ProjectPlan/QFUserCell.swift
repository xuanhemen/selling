//
//  QFUserCell.swift
//  SwiftStudy
//
//  Created by qwp on 2018/4/20.
//  Copyright © 2018年 祁伟鹏. All rights reserved.
//

import UIKit

class QFUserCell: UITableViewCell {
    let titleLabel = UILabel.init(frame: CGRect(x: 60, y: 10, width: 60, height: 30))
    var detailLabel:UILabel?
    let QF_Width = UIScreen.main.bounds.size.width
    var backView:UIView?
    var click:()->() = {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setData(model:ProAddContactModel) {
        
        titleLabel.text = model.name
        self.detailLabel?.text = model.plan_title
    }
    
    func configUI()  {
        self.backgroundColor = .clear
        backView = UIView.init(frame: CGRect(x: 15, y: 5, width: UIScreen.main.bounds.size.width-30, height: 40))
        backView?.backgroundColor = .white
        self.contentView.addSubview(backView!)
        
        let imageView = UIImageView.init(frame: CGRect(x: 25, y: 15, width: 20, height: 20))
        imageView.image = #imageLiteral(resourceName: "project_chooses")
        self.contentView.addSubview(imageView)
        
        
        
        
        let nextImageView = UIImageView.init(frame: CGRect(x: QF_Width-35, y: 15, width: 20, height: 20))
        nextImageView.image = #imageLiteral(resourceName: "qf_project_nextArrow")
        self.contentView.addSubview(nextImageView)
     
        
        
        
        
        titleLabel.text = ""
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.contentView.addSubview(titleLabel)
        
        let detailLabel = UILabel.init(frame: CGRect(x: 120, y: 10, width: QF_Width-120-35, height: 30))
        detailLabel.text = ""
        detailLabel.textColor = .darkGray
        detailLabel.textAlignment = .left
        detailLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        self.contentView.addSubview(detailLabel)
        self.detailLabel = detailLabel
        
        
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH-60, height: 50))
        button.addTarget(self, action: #selector(chooseButtonClick), for: UIControlEvents.touchUpInside)
        self.contentView.addSubview(button)
        
    }
    
    @objc func chooseButtonClick(){
         self.click()
    }

}
