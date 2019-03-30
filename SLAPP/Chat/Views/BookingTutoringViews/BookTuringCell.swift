//
//  BookTuringCell.swift
//  SLAPP
//
//  Created by apple on 2018/3/16.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

enum BookTutoringType:Int {
    case tutor
    case beginTime
    case tutoringTime
}
class BookTuringCell: UITableViewCell {

    var type:BookTutoringType?{
        didSet{
            
            switch type {
            case .tutor?:
                self.timerLable.isHidden = false
                self.textField.isHidden = true
                self.timerLable.text = "请选择导师"
                break
            case .beginTime?:
                self.timerLable.isHidden = false
                self.textField.isHidden = true
                break
            case .tutoringTime?:
                self.timerLable.isHidden = true
                self.textField.isHidden = false
                self.textField.placeholder = "例如：1小时"
                break
            default: break
                
            }
           
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.configUI()
    }
//
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configUI(){
        
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
        
        
        view.addSubview(headImage)
        view.addSubview(nameLable)
        view.addSubview(timerLable)
        view.addSubview(textField)
        view.addSubview(teacherImage)
        nameLable.text = "选择辅导导师:"
        
        headImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        nameLable.font = kFont_Middle
        nameLable.snp.makeConstraints {[weak headImage] (make) in
            make.top.equalTo((headImage?.snp.top)!)
            make.left.equalTo((headImage?.snp.right)!).offset(5)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        teacherImage.clipsToBounds = true
        teacherImage.layer.cornerRadius = 15
        teacherImage.snp.makeConstraints {[weak nameLable] (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo((nameLable?.snp.right)!).offset(10)
            make.width.equalTo(0)
            make.height.equalTo(0)
           
        }
        
        
        timerLable.snp.makeConstraints {[weak teacherImage] (make) in
            make.left.equalTo((teacherImage?.snp.right)!).offset(5)
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        
        textField.snp.makeConstraints {[weak nameLable] (make) in
            make.left.equalTo((nameLable?.snp.right)!).offset(5)
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(rightImage)
        rightImage.contentMode = .scaleAspectFit
        rightImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-3)
            make.height.equalTo(15)
            make.width.equalTo(15)
        }
    }
    
    
    lazy var teacherImage = { () -> UIImageView in
        let image = UIImageView()
        image.image = UIImage.init(named: "myIcon")
        return image
    }()
    
    lazy var headImage = { () -> UIImageView in
        let image = UIImageView()
        image.image = UIImage.init(named: "myIcon")
        return image
    }()
    
    
    lazy var rightImage = { () -> UIImageView in
        let image = UIImageView()
        
        image.image = UIImage.init(named: "myIcon")
        return image
    }()
    
    
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        return lable
    }()
    
    lazy var timerLable = { () -> UILabel in
        let lable = UILabel()
        return lable
    }()
    
    lazy var textField = { () -> UITextField in
        let lable = UITextField()
        return lable
    }()
    
    
    var model:Dictionary<String,Any>?{
        didSet{
            
        }
        
    }
}
