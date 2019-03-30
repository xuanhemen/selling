//
//  QFChooseCell.swift
//  SwiftStudy
//
//  Created by qwp on 2018/4/19.
//  Copyright © 2018年 祁伟鹏. All rights reserved.
//

import UIKit

class QFChooseCell: UITableViewCell {
    
    var titleLabel:UILabel?
    var starView:UIView?
    var imageV:UIImageView?
    var backView:UIView?
    let imageDic = ["常规交流":"project_message","方案呈现":"project_fangan","产品演示":"project_chanping","商务活动":"project_huodong","需求调研":"project_diaoyan","样板参观":"project_yangban","技术交流":"project_jishujiaoliu"]
    
    
    
    func setData(model:ProjectPlanStarModel) {
    
        self.titleLabel?.text = model.name
        self.imageV?.image = UIImage.init(named: imageDic[model.name] ?? "")
        self.starView = self.configStarView(star: model.star, fatherView: backView!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear

        backView = UIView.init(frame: CGRect(x: 15, y: 7, width: UIScreen.main.bounds.size.width-30, height: 40))
        backView?.backgroundColor = .white
        self.contentView.addSubview(backView!)
        
        imageV = UIImageView.init(frame: CGRect(x: 5, y: 5, width: 30, height: 30))
        backView?.addSubview(imageV!)
        
        
        titleLabel = UILabel.init(frame: CGRect(x: 40, y: 5, width: (backView?.frame.size.width)!/2.0-40, height: 30))
        titleLabel?.text = "常规交流"
        titleLabel?.textColor = .black
        titleLabel?.textAlignment = .left
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        backView?.addSubview(titleLabel!)
        
        starView = self.configStarView(star: 5,fatherView: backView!)
        
    }
    func configStarView(star:Int,fatherView:UIView)->UIView {
        
        starView?.removeFromSuperview()
        
        let view = UIView.init(frame: CGRect(x: fatherView.frame.size.width/2, y: 5, width: fatherView.frame.size.width/2-15, height: 30))
        fatherView.addSubview(view)
        
        let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        label.text = "推荐指数："
        label.textColor = .gray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        view.addSubview(label)
        let starViewWidth = (view.frame.size.width-70)/5
        
        
        for i in 0..<star {
            let starView = UIImageView.init(frame: CGRect(x: (starViewWidth+2)*CGFloat(i)+70, y: 0, width: starViewWidth, height: 30))
            starView.image = #imageLiteral(resourceName: "projectStar")
            starView.contentMode = UIViewContentMode.scaleAspectFit
            view.addSubview(starView)
        }
        
        return view
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
