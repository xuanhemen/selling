//
//  RemindTableViewCell.swift
//  SLAPP
//
//  Created by rms on 2018/1/31.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit


class RemindTableViewCell: UITableViewCell ,TTTAttributedLabelDelegate{

    var dotLb : UILabel!
    var detailLb : TTTAttributedLabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        dotLb = UILabel.init()
        dotLb.backgroundColor = UIColor.clear
        dotLb.layer.borderWidth = 1.0
        dotLb.layer.borderColor = UIColor.gray.cgColor
        dotLb.layer.cornerRadius = 5
        dotLb.layer.masksToBounds = true
        self.contentView.addSubview(dotLb)
        
        detailLb = TTTAttributedLabel.init(frame: CGRect.zero)
        detailLb.numberOfLines = 0
        detailLb.textColor = UIColor.gray
        detailLb.font = kFont_Big
        detailLb.enabledTextCheckingTypes = NSTextCheckingAllTypes
        detailLb.delegate = self
        self.contentView.addSubview(detailLb)
        
        dotLb.mas_makeConstraints { (make) in
            make!.top.equalTo()(25)
            make!.left.equalTo()(LEFT_PADDING)
            make!.size.equalTo()(CGSize.init(width: 10, height: 10))
        }
        detailLb.mas_makeConstraints { [unowned self](make) in
            make!.top.equalTo()(20)
            make!.left.equalTo()(self.dotLb.mas_right)?.offset()(10)
            make!.right.equalTo()(-LEFT_PADDING)
            make!.bottom.equalTo()(-20)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model : (String,Array<(String,String)>,String,String)!{
        didSet{
            let tempPname = NSMutableAttributedString()
            var fullAtt = Array<(String,NSRange)>()
            DLog(model)
            for pName in model.1 {
                if tempPname.string != "" {
                    tempPname.append(NSAttributedString(string: "、", attributes: [NSAttributedStringKey.foregroundColor : kGreenColor]))
                }
                fullAtt.append((pName.0, NSMakeRange(tempPname.string.count, pName.1.count)))
                tempPname.append(NSAttributedString(string: pName.1, attributes: [NSAttributedStringKey.foregroundColor : kGreenColor, NSAttributedStringKey.font : kFont_Big]))
//                detailLb.addLink(TTTAttributedLabelLink.init(attributesFrom: <#T##TTTAttributedLabel!#>, textCheckingResult: <#T##NSTextCheckingResult!#>))
            }
            let paragraphStyle = NSMutableParagraphStyle.init()
            var waitString = ""
            let count = model.3
            if Int(count)! > 2 {
                waitString = "等"
            }
            paragraphStyle.lineSpacing = textLineSpace
            tempPname.append(NSAttributedString(string: waitString+model.0, attributes: [NSAttributedStringKey.font : kFont_Big,NSAttributedStringKey.paragraphStyle:paragraphStyle]))
            detailLb.attributedText = tempPname
            //链接正常状态文本属性
            detailLb.linkAttributes = [NSAttributedStringKey.foregroundColor : kGreenColor, NSAttributedStringKey.font : kFont_Big,NSAttributedStringKey.paragraphStyle:paragraphStyle]
            //链接高亮状态文本属性
//            detailLb.activeLinkAttributes = [NSAttributedStringKey.foregroundColor : kGreenColor, NSAttributedStringKey.font : kFont_Big]

            for oneAtt in fullAtt{
//                detailLb.addLink(to: URL(string: h5_host + "main.html#/projectSurvey/id/" + oneAtt.0 + "/app"), with: oneAtt.1)
                detailLb.addLink(to: URL(string: oneAtt.0), with: oneAtt.1)
                // .activeAttributes = [NSAttributedStringKey.foregroundColor : kGreenColor, NSAttributedStringKey.font : kFont_Big]
            }
            //            detailLb.text = model
            
        }
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        
        
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: PROJECT_DETAIL, params: ["project_id":String.noNilStr(str: url.absoluteString)].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { [weak self](dic) in
            DLog(dic)
            PublicMethod.dismiss()
            if let model = ProjectSituationModel.deserialize(from: dic){
                let tab = ProjectSituationTabVC()
                tab.model = model; PublicMethod.appCurrentViewController().navigationController?.pushViewController(tab, animated: true)
            }
        }
        
//        let canBack = CanBackWebVC()
//        canBack.url = url.absoluteString
//        PublicMethod.appCurrentViewController().navigationController?.pushViewController(canBack, animated: true)
        
    }
}

