//
//  MyFollowupCell.swift
//  SLAPP
//
//  Created by apple on 2018/6/29.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class MyFollowupCell: UITableViewCell {

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
        self.configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configUI(){
        
        self.contentView.addSubview(headImage)
        self.contentView.addSubview(nameLable)
        self.contentView.addSubview(timerLable)
        self.contentView.addSubview(timeconsuming)
        self.contentView.addSubview(supportImage)
        self.contentView.addSubview(content)
//        nameLable.text = "adsasdasdasd"
//        timerLable.text = "2222222"
//        timeconsuming.text = "33333333"
        headImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        nameLable.snp.makeConstraints {[weak headImage] (make) in
            make.top.equalTo(5)
            make.left.equalTo((headImage?.snp.right)!).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        timerLable.snp.makeConstraints {[weak headImage] (make) in
            make.left.equalTo(nameLable)
            make.right.equalToSuperview().offset(-100)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        supportImage.snp.makeConstraints { (make) in
            make.left.equalTo(nameLable)
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        timeconsuming.snp.makeConstraints { (make) in
            make.left.equalTo(nameLable)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        content.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
            make.width.equalTo(80)
            make.right.equalToSuperview().offset(-10)
        }
        
        
        supportImage.isHidden = true
    }
    
    
    
    
    lazy var headImage = { () -> UIImageView in
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "mine_avatar")
        return image
    }()
    
    lazy var supportImage = { () -> UIImageView in
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "Like")
        return image
    }()
    
    
    lazy var nameLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        return lable
    }()
    
    lazy var timerLable = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        return lable
    }()
    
    lazy var timeconsuming = { () -> UILabel in
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        return lable
    }()
    
    lazy var content = { () -> UILabel in
        let lable = UILabel()
        lable.numberOfLines = 0
        lable.backgroundColor = UIColor.groupTableViewBackground
        lable.textColor = UIColor.lightGray
        lable.font = UIFont.systemFont(ofSize: 14)
        return lable
    }()
    
    var model:MyFollowupModel?{
        didSet{
            headImage.setImageWith(url: model?.from_head ?? "mine_avatar", imageName: "mine_avatar")
            nameLable.text = model?.from_realname
            supportImage.isHidden = true
            if model?.type == "comment" {
                
//                timerLable.text = model?.content.replacingOccurrences(of: "+", with: "%20").removingPercentEncoding
                timerLable.text = String.base64Decode(str: model?.encode_content ?? "")
                
            }else if model?.type == "remind"{
                timerLable.text = "提到了我"
            }else if model?.type == "reply2"{
                
                timerLable.text = "回复了".appending(model!.to_realname)
            }else if model?.type == "support"{
                supportImage.isHidden = false
            }
            
            
            timeconsuming.text = model?.stamp
            content.text = String.base64Decode(str: model?.encode_note ?? "")
            
//            NSString *transString = [NSString stringWithString:[[model.msgContent stringByReplacingOccurrencesOfString:@"+" withString:@"%20"]stringByRemovingPercentEncoding]];
        }
        
    }
    
}
