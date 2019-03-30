//
//  PersonalResultsCell.swift
//  SLAPP
//
//  Created by apple on 2018/6/19.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class PersonalResultsCell: UITableViewCell {

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var model:Presults_listModel?{
        didSet{
            
            
            if model!.edittime != "0" {
                timeLable.text = Date.timeIntervalToDateStr(timeInterval: Double(model!.edittime)!)
            }
            
            contentLable.text = model!.name.appending("成功签单，合同额").appending(model!.amount).appending("万,实现业绩").appending(model!.down_payment).appending("万")
            let c =  Int(Double(model!.meet_requirement)!)
            let z =  Int(Double(model!.total_performance)!)
            
            let str = String.init(format: "%d%@,总业绩完成率%d%@",c,"%",z,"%")
            let allStr = "完成业绩".appending(str)
            alreadyLable.attributedText = String.configAttributedStr(oldStr: allStr, subStr: str, oldColor: kTextGrayColor, color: kGreenColor, font:UIFont.systemFont(ofSize: 13), lineSpacing: -1)
//            alreadyLable.attributedText = String.configAttributedStr(oldStr: allStr, subStr: str, oldColor: UIColor.darkText, color: kGreenColor)
            
            
        }
    }
    
    
    func configUI(){
        
        self.contentView.addSubview(timeLable)
        self.contentView.addSubview(contentLable)
        self.contentView.addSubview(alreadyLable)
        self.contentView.addSubview(topLine)
        self.contentView.backgroundColor = UIColor.groupTableViewBackground
        
        timeLable.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(20)
            make.height.equalTo(25)
            make.right.equalTo(-20)
        }
        
        contentLable.snp.makeConstraints {[weak self] (make) in
            make.top.equalTo((self?.timeLable.snp.bottom)!).offset(10)
            make.left.equalTo((self?.timeLable.snp.left)!)
            make.right.equalTo((self?.timeLable.snp.right)!)
            make.bottom.equalTo((self?.alreadyLable.snp.top)!).offset(-10)
//            make.height.lessThanOrEqualTo(25)
        }
        contentLable.numberOfLines = 0
        
        alreadyLable.snp.makeConstraints {[weak self] (make) in
            make.top.equalTo((self?.contentLable.snp.bottom)!).offset(10)
            make.left.equalTo(20)
            make.height.equalTo(25)
            make.right.equalTo(-20)
            make.bottom.equalTo(-10)
        }
        
        let cycle = UIView()
        self.contentView.addSubview(cycle)
        
        cycle.snp.makeConstraints {[weak self] (make) in
            make.width.height.equalTo(10)
            make.centerY.equalTo((self?.timeLable)!)
        }
        cycle.layer.cornerRadius = 5
        cycle.backgroundColor = kGreenColor
        
        
        topLine.snp.makeConstraints {[weak cycle] (make) in
            make.width.equalTo(0.5)
            make.top.equalTo(0)
            make.centerX.equalTo(cycle!)
            make.bottom.equalTo((cycle!.snp.bottom))
        }
        
        
        let line = UIView()
        self.contentView.addSubview(line)
        line.backgroundColor = UIColor.lightGray
        topLine.backgroundColor = UIColor.lightGray
        line.snp.makeConstraints {[weak cycle,weak self] (make) in
            make.width.equalTo(0.5)
            make.top.equalTo((cycle?.snp.bottom)!)
            make.centerX.equalTo(cycle!)
            make.bottom.equalTo((self?.contentView.snp.bottom)!)
        }
        
    }
    
    lazy var topLine = { () -> UIView in
        let lable = UIView()
        return lable
    }()
    
    
    
    lazy var timeLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        //        lable.textAlignment = .center
        lable.textColor = UIColor.darkText.withAlphaComponent(0.5)
        return lable
    }()
    
    //内容
    lazy var contentLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 13)
        //        lable.textAlignment = .center
        lable.textColor = kTextGrayColor
        return lable
    }()
    
    //业绩完成
    lazy var alreadyLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 13)
        //        lable.textAlignment = .center
//        lable.textColor =
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
