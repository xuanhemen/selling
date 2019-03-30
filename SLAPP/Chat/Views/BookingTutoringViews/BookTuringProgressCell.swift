//
//  BookTuringProgressCell.swift
//  SLAPP
//
//  Created by apple on 2018/3/16.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import ASProgressPopUpView
class BookTuringProgressCell: UITableViewCell {

    
    lazy var progress = { () -> ASProgressPopUpView in
        let lable = ASProgressPopUpView.init()
        return lable
    }()
    
    var mimuteStr:Int?{
        didSet{
            nameLable.text = self.configtimerStr(time: mimuteStr!)
        }
    }
    
    func configtimerStr(time:Int)->(String){
        
        let hour = time/(60)
        let mimu = time%60
        if hour != 0 {
            return "剩余\(hour)小时"+"\(mimu)分钟"
        }
        return "剩余\(mimu)分钟"
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.groupTableViewBackground
        let view = UIView()
        view.backgroundColor = UIColor.white
        self.contentView.addSubview(view)
        view.layer.cornerRadius = 6
        
        
        view.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-5)
        }
        view.addSubview(progress)
        progress.snp.makeConstraints { (make) in
            make.top.equalTo(35)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(5)
//            make.bottom.equalTo(-20)
        }
        
        
        
        progress.trackTintColor = UIColor.lightGray
        progress.font = UIFont.init(name: "Futura-CondensedExtraBold", size: 16)
        progress.show(animated: true)
        progress.popUpViewAnimatedColors = [kGreenColor,UIColor.orange,UIColor.red]
        
        nameLable.textAlignment = .center
        self.contentView.addSubview(nameLable)
        nameLable.snp.makeConstraints {[weak progress] (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(15)
            make.top.equalTo((progress?.snp.bottom)!).offset(15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        return lable
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
